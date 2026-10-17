import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/core/db/app_database.dart';
import 'package:planpal/core/sync/sync_engine.dart';
import 'package:planpal/features/tasks/data/task_repository.dart';

void main() {
  late AppDatabase database;
  late SyncEngine sync;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    sync.dispose();
    await database.close();
  });

  test('sends task due dates as UTC ISO-8601 timestamps', () async {
    RequestOptions? request;
    final dio = Dio(BaseOptions(baseUrl: 'https://planpal.test/api/v1'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            request = options;
            final now = DateTime.utc(2026, 10, 17, 12);
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 201,
                data: {
                  'task': {
                    'id': options.data['id'],
                    'workspace_id': 'workspace-1',
                    'title': 'Deadline task',
                    'description': '',
                    'status': 'todo',
                    'priority': 'medium',
                    'due_at': options.data['dueAt'],
                    'reminder_minutes_before': null,
                    'assignee_id': 'user-1',
                    'label_id': null,
                    'created_by': 'user-1',
                    'created_at': now.toIso8601String(),
                    'updated_at': now.toIso8601String(),
                  },
                },
              ),
            );
          },
        ),
      );
    sync = SyncEngine(dio, database);
    final repository = TaskRepository(
      dio,
      database,
      sync,
      currentUserId: () => 'user-1',
    );
    final dueAt = DateTime(2026, 10, 17, 9, 30);

    final (task, failure) = await repository.createTask(
      'workspace-1',
      title: 'Deadline task',
      dueAt: dueAt,
      assigneeId: 'user-1',
    );

    expect(failure, isNull);
    expect(task?.title, 'Deadline task');
    final serializedDueAt = request!.data['dueAt'] as String;
    expect(serializedDueAt, endsWith('Z'));
    expect(DateTime.parse(serializedDueAt), dueAt.toUtc());
  });

  test(
    'keeps an offline-created task cached and queues its UTC payload',
    () async {
      RequestOptions? request;
      final dio = Dio(BaseOptions(baseUrl: 'https://planpal.test/api/v1'))
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              request = options;
              handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.connectionError,
                ),
              );
            },
          ),
        );
      sync = SyncEngine(dio, database);
      final repository = TaskRepository(
        dio,
        database,
        sync,
        currentUserId: () => 'user-1',
      );
      final dueAt = DateTime(2026, 10, 17, 9, 30);

      final (task, failure) = await repository.createTask(
        'workspace-1',
        title: 'Offline task',
        dueAt: dueAt,
        assigneeId: 'user-1',
      );

      expect(task, isNotNull);
      expect(failure, isNotNull);
      final createdTask = task!;
      final cached = await (database.select(
        database.tasks,
      )..where((row) => row.id.equals(createdTask.id))).getSingle();
      expect(cached.title, 'Offline task');

      final queued = await (database.select(
        database.outboxEntries,
      )..where((row) => row.entityId.equals(createdTask.id))).getSingle();
      final payload = jsonDecode(queued.payload) as Map<String, dynamic>;
      expect(payload['dueAt'], endsWith('Z'));
      expect(DateTime.parse(payload['dueAt'] as String), dueAt.toUtc());
      expect(request!.data['id'], createdTask.id);
    },
  );

  test('opens a cached offline task without requesting the server', () async {
    var requestCount = 0;
    final dio = Dio(BaseOptions(baseUrl: 'https://planpal.test/api/v1'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requestCount++;
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.connectionError,
              ),
            );
          },
        ),
      );
    sync = SyncEngine(dio, database);
    final repository = TaskRepository(
      dio,
      database,
      sync,
      currentUserId: () => 'user-1',
    );
    final (createdTask, _) = await repository.createTask(
      'workspace-1',
      title: 'Offline detail task',
    );
    final requestsAfterCreate = requestCount;

    final (task, failure) = await repository.getTask(
      createdTask!.id,
      offline: true,
    );

    expect(task?.title, 'Offline detail task');
    expect(failure, isNull);
    expect(requestCount, requestsAfterCreate);
  });

  test(
    'uses the cached task when its queued create is not on the server',
    () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://planpal.test/api/v1'))
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              if (options.method == 'POST') {
                handler.reject(
                  DioException(
                    requestOptions: options,
                    type: DioExceptionType.connectionError,
                  ),
                );
                return;
              }
              final response = Response(
                requestOptions: options,
                statusCode: 404,
                data: {
                  'error': {'code': 'NOT_FOUND'},
                },
              );
              handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.badResponse,
                  response: response,
                ),
              );
            },
          ),
        );
      sync = SyncEngine(dio, database);
      final repository = TaskRepository(
        dio,
        database,
        sync,
        currentUserId: () => 'user-1',
      );
      final (createdTask, _) = await repository.createTask(
        'workspace-1',
        title: 'Queued detail task',
      );

      final (task, failure) = await repository.getTask(createdTask!.id);

      expect(task?.title, 'Queued detail task');
      expect(failure, isNull);
    },
  );
}

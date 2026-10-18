import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/core/db/app_database.dart';
import 'package:planpal/core/sync/sync_engine.dart';

class _SyncPagesInterceptor extends Interceptor {
  _SyncPagesInterceptor(this.pages);

  final List<Map<String, dynamic>> pages;
  final requests = <RequestOptions>[];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    requests.add(options);
    handler.resolve(
      Response(
        requestOptions: options,
        statusCode: 200,
        data: pages.removeAt(0),
      ),
    );
  }
}

class _ReplyInterceptor extends Interceptor {
  _ReplyInterceptor(this.statusCode);

  final int statusCode;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (statusCode >= 400) {
      handler.reject(
        DioException(
          requestOptions: options,
          response: Response(requestOptions: options, statusCode: statusCode),
        ),
      );
      return;
    }

    handler.resolve(Response(requestOptions: options, statusCode: statusCode));
  }
}

void main() {
  late AppDatabase database;
  late SyncEngine engine;

  Future<int> addOutboxEntry() => database
      .into(database.outboxEntries)
      .insert(
        OutboxEntriesCompanion.insert(
          operation: 'create',
          entityType: 'workspaces/workspace-id/tasks',
          entityId: 'task-id',
          payload: '{}',
          createdAt: DateTime.now(),
        ),
      );

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    engine = SyncEngine(
      Dio(BaseOptions(baseUrl: 'https://example.invalid/api/v1'))
        ..interceptors.add(_ReplyInterceptor(503)),
      database,
    );
  });

  tearDown(() async {
    engine.dispose();
    await database.close();
  });

  test('transient failures stay queued after repeated attempts', () async {
    final entryId = await addOutboxEntry();

    for (var attempt = 0; attempt < 7; attempt++) {
      await engine.push();
    }

    final entry = await (database.select(
      database.outboxEntries,
    )..where((row) => row.id.equals(entryId))).getSingle();

    expect(entry.retryCount, lessThan(5));
  });

  test('permanent client errors are marked failed', () async {
    final entryId = await addOutboxEntry();
    engine.dispose();
    engine = SyncEngine(
      Dio(BaseOptions(baseUrl: 'https://example.invalid/api/v1'))
        ..interceptors.add(_ReplyInterceptor(400)),
      database,
    );

    await engine.push();

    final entry = await (database.select(
      database.outboxEntries,
    )..where((row) => row.id.equals(entryId))).getSingle();

    expect(entry.retryCount, 5);
  });

  test('successful replay removes the queued entry', () async {
    final entryId = await addOutboxEntry();
    engine.dispose();
    engine = SyncEngine(
      Dio(BaseOptions(baseUrl: 'https://example.invalid/api/v1'))
        ..interceptors.add(_ReplyInterceptor(201)),
      database,
    );

    await engine.push();

    final entry = await (database.select(
      database.outboxEntries,
    )..where((row) => row.id.equals(entryId))).getSingleOrNull();

    expect(entry, isNull);
  });

  test('replays queued task moves through the move endpoint', () async {
    RequestOptions? moveRequest;
    engine.dispose();
    engine = SyncEngine(
      Dio(BaseOptions(baseUrl: 'https://example.invalid/api/v1'))
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              moveRequest = options;
              handler.resolve(
                Response(requestOptions: options, statusCode: 200),
              );
            },
          ),
        ),
      database,
    );
    await database
        .into(database.outboxEntries)
        .insert(
          OutboxEntriesCompanion.insert(
            operation: 'task_move',
            entityType: 'tasks',
            entityId: 'task-id',
            payload: jsonEncode({'targetWorkspaceId': 'workspace-2'}),
            createdAt: DateTime.now(),
          ),
        );

    await engine.push();

    expect(moveRequest?.method, 'POST');
    expect(moveRequest?.path, '/tasks/task-id/move');
    expect(moveRequest?.data, {'targetWorkspaceId': 'workspace-2'});
    expect(await database.select(database.outboxEntries).get(), isEmpty);
  });

  test(
    'uses opaque continuation cursor and saves checkpoint after final page',
    () async {
      final interceptor = _SyncPagesInterceptor([
        {
          'hasMore': true,
          'nextCursor': 'opaque-next',
          'serverTime': 'server-1',
        },
        {'hasMore': false, 'serverTime': 'server-final'},
      ]);
      final writes = <String>[];
      var checkpoint = 'initial-checkpoint';
      engine.dispose();
      engine = SyncEngine(
        Dio(BaseOptions(baseUrl: 'https://example.invalid/api/v1'))
          ..interceptors.add(interceptor),
        database,
        readCheckpoint: (_) async => checkpoint,
        writeCheckpoint: (_, value) async {
          writes.add(value);
          checkpoint = value;
        },
      );

      await engine.pull('workspace-id');

      expect(interceptor.requests, hasLength(2));
      expect(interceptor.requests[0].queryParameters, {
        'since': 'initial-checkpoint',
      });
      expect(interceptor.requests[1].queryParameters, {
        'cursor': 'opaque-next',
      });
      expect(checkpoint, 'server-final');
      expect(writes, ['server-final']);
    },
  );

  test(
    'workspace membership tombstone removes cached workspace and its tasks',
    () async {
      final now = DateTime.utc(2026, 1, 1);
      await database
          .into(database.workspaces)
          .insert(
            WorkspacesCompanion.insert(
              id: 'removed-workspace',
              name: 'Team',
              type: 'team',
              createdBy: 'owner-id',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await database
          .into(database.tasks)
          .insert(
            TasksCompanion.insert(
              id: 'removed-task',
              workspaceId: 'removed-workspace',
              title: 'Task',
              createdBy: 'owner-id',
              createdAt: now,
              updatedAt: now,
            ),
          );

      engine.dispose();
      engine = SyncEngine(
        Dio(BaseOptions(baseUrl: 'https://example.invalid/api/v1'))
          ..interceptors.add(
            _SyncPagesInterceptor([
              {
                'hasMore': false,
                'serverTime': 'server-time',
                'workspaceMembers': [
                  {
                    'workspace_id': 'removed-workspace',
                    'user_id': 'current-user',
                    'deleted_at': '2026-01-01T00:00:00Z',
                  },
                ],
              },
            ]),
          ),
        database,
        readCheckpoint: (_) async => null,
        writeCheckpoint: (_, __) async {},
      );

      await engine.pull('removed-workspace');

      expect(
        await (database.select(
          database.workspaces,
        )..where((row) => row.id.equals('removed-workspace'))).get(),
        isEmpty,
      );
      expect(
        await (database.select(
          database.tasks,
        )..where((row) => row.workspaceId.equals('removed-workspace'))).get(),
        isEmpty,
      );
    },
  );
}

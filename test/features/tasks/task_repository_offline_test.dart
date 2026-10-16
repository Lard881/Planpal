import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/core/db/app_database.dart';
import 'package:planpal/core/sync/sync_engine.dart';
import 'package:planpal/features/tasks/data/task_repository.dart';

class _UnavailableInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.reject(
      DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
      ),
    );
  }
}

void main() {
  late AppDatabase database;
  late SyncEngine sync;
  late TaskRepository repository;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    final dio = Dio(BaseOptions(baseUrl: 'https://example.invalid/api/v1'))
      ..interceptors.add(_UnavailableInterceptor());
    sync = SyncEngine(dio, database);
    repository = TaskRepository(dio, database, sync);
    final now = DateTime.utc(2025);
    await database
        .into(database.tasks)
        .insert(
          TasksCompanion.insert(
            id: 'task-1',
            workspaceId: 'workspace-1',
            title: 'Before edit',
            createdBy: 'user-1',
            createdAt: now,
            updatedAt: now,
          ),
        );
  });

  tearDown(() async {
    sync.dispose();
    await database.close();
  });

  test('keeps an offline inline edit locally and queues it for sync', () async {
    final failure = await repository.updateTask('task-1', {
      'title': 'After edit',
    });

    final task = await (database.select(
      database.tasks,
    )..where((row) => row.id.equals('task-1'))).getSingle();
    final queuedUpdates = await (database.select(
      database.outboxEntries,
    )..where((entry) => entry.entityId.equals('task-1'))).get();

    expect(failure, isNotNull);
    expect(task.title, 'After edit');
    expect(queuedUpdates, hasLength(1));
    expect(queuedUpdates.single.operation, 'update');
  });

  test(
    'restores comment authors and attachments from offline detail cache',
    () async {
      final now = DateTime.utc(2025);
      await database
          .into(database.taskComments)
          .insert(
            TaskCommentsCompanion.insert(
              id: 'comment-1',
              taskId: 'task-1',
              authorId: 'user-2',
              authorName: const Value('Member'),
              authorAvatarUrl: const Value('https://example.invalid/avatar'),
              body: 'Offline comment',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await database
          .into(database.taskAttachments)
          .insert(
            TaskAttachmentsCompanion.insert(
              taskId: 'task-1',
              fileId: 'file-1',
              name: 'notes.pdf',
              mimeType: 'application/pdf',
              sizeBytes: 1200,
              storagePath: 'workspace-1/notes.pdf',
            ),
          );

      final (task, failure) = await repository.getTask('task-1');

      expect(failure, isNull);
      expect(task!.comments.single.authorName, 'Member');
      expect(task.comments.single.authorAvatarUrl, contains('/avatar'));
      expect(task.attachments.single.fileId, 'file-1');
      expect(task.attachments.single.storagePath, 'workspace-1/notes.pdf');
    },
  );
}

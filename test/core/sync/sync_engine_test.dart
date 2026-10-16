import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/core/db/app_database.dart';
import 'package:planpal/core/sync/sync_engine.dart';

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
}

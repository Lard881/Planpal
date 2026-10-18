import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/core/db/app_database.dart';
import 'package:planpal/core/sync/sync_engine.dart';
import 'package:planpal/features/calendar/data/calendar_repository.dart';

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
  test('offline event edits update the cache and queue for sync', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final sync = SyncEngine(
      Dio(BaseOptions(baseUrl: 'https://example.invalid/api/v1'))
        ..interceptors.add(_UnavailableInterceptor()),
      database,
    );
    addTearDown(() async {
      sync.dispose();
      await database.close();
    });

    final now = DateTime.utc(2026, 10, 18, 9);
    await database
        .into(database.events)
        .insert(
          EventsCompanion.insert(
            id: 'event-1',
            workspaceId: 'workspace-1',
            title: 'Before edit',
            startsAt: now,
            endsAt: now.add(const Duration(hours: 1)),
            createdBy: 'user-1',
            createdAt: now,
            updatedAt: now,
          ),
        );
    final repository = CalendarRepository(
      Dio(BaseOptions(baseUrl: 'https://example.invalid/api/v1'))
        ..interceptors.add(_UnavailableInterceptor()),
      database,
      sync,
    );

    final failure = await repository.updateEvent('event-1', {
      'title': 'After edit',
      'startsAt': now.add(const Duration(hours: 2)).toIso8601String(),
    });

    final event = await (database.select(
      database.events,
    )..where((row) => row.id.equals('event-1'))).getSingle();
    final queuedUpdate = await (database.select(
      database.outboxEntries,
    )..where((row) => row.entityId.equals('event-1'))).getSingle();

    expect(failure, isNotNull);
    expect(event.title, 'After edit');
    expect(
      event.startsAt.isAtSameMomentAs(now.add(const Duration(hours: 2))),
      isTrue,
    );
    expect(queuedUpdate.operation, 'update');
    expect(queuedUpdate.entityType, 'events');
    expect(queuedUpdate.payload, contains('After edit'));
  });
}

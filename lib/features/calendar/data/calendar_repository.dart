// app/lib/features/calendar/data/calendar_repository.dart
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../core/db/app_database.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_mapper.dart';
import '../../../core/network/app_failure.dart';
import '../../../core/sync/sync_engine.dart';
import '../models/event_model.dart';

const _uuid = Uuid();

class CalendarRepository {
  final Dio _dio;
  final AppDatabase _db;
  final SyncEngine _sync;

  CalendarRepository(this._dio, this._db, this._sync);

  Future<(List<EventModel>, List<DueTaskModel>, AppFailure?)> getEvents(
    String workspaceId,
    DateTime from,
    DateTime to,
  ) async {
    try {
      final res = await _dio.get(
        '/workspaces/$workspaceId/events',
        queryParameters: {
          'from': from.toUtc().toIso8601String(),
          'to': to.toUtc().toIso8601String(),
        },
      );
      final events = (res.data['events'] as List? ?? [])
          .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
          .toList();
      final dueTasks = (res.data['dueTasks'] as List? ?? [])
          .map((e) => DueTaskModel.fromJson(e as Map<String, dynamic>))
          .toList();
      await _cacheEvents(events);
      return (events, dueTasks, null);
    } on DioException catch (e) {
      final cachedEvents = await _getCachedEvents(workspaceId, from, to);
      final cachedTasks = await _getCachedDueTasks(workspaceId, from, to);
      if (cachedEvents.isNotEmpty || cachedTasks.isNotEmpty) {
        return (cachedEvents, cachedTasks, mapDioError(e));
      }
      return (<EventModel>[], <DueTaskModel>[], mapDioError(e));
    }
  }

  Future<(EventModel?, AppFailure?)> createEvent(
    String workspaceId, {
    required String title,
    String description = '',
    required DateTime startsAt,
    required DateTime endsAt,
    bool allDay = false,
    String color = '#4F46E5',
    List<String> attendeeIds = const [],
    int reminderMinutesBefore = 15,
  }) async {
    final createdBy = Supabase.instance.client.auth.currentUser?.id;
    if (createdBy == null) {
      return (null, const AuthRequiredFailure());
    }
    final id = _uuid.v4();
    final now = DateTime.now();
    final event = EventModel(
      id: id,
      workspaceId: workspaceId,
      title: title,
      description: description,
      startsAt: startsAt,
      endsAt: endsAt,
      allDay: allDay,
      color: color,
      reminderMinutesBefore: reminderMinutesBefore,
      createdBy: createdBy,
      attendeeIds: attendeeIds,
    );
    await _cacheEvent(event, now: now);
    final data = {
      'id': id,
      'title': title,
      'description': description,
      'startsAt': startsAt.toUtc().toIso8601String(),
      'endsAt': endsAt.toUtc().toIso8601String(),
      'allDay': allDay,
      'color': color,
      'reminderMinutesBefore': reminderMinutesBefore,
      'attendeeIds': attendeeIds,
    };
    try {
      final res = await _dio.post(
        '/workspaces/$workspaceId/events',
        data: data,
      );
      final responseEvent = EventModel.fromJson(
        res.data['event'] as Map<String, dynamic>,
      );
      final saved = EventModel(
        id: responseEvent.id,
        workspaceId: responseEvent.workspaceId,
        title: responseEvent.title,
        description: responseEvent.description,
        startsAt: responseEvent.startsAt,
        endsAt: responseEvent.endsAt,
        allDay: responseEvent.allDay,
        color: responseEvent.color,
        taskId: responseEvent.taskId,
        reminderMinutesBefore: responseEvent.reminderMinutesBefore,
        createdBy: responseEvent.createdBy,
        attendeeIds: attendeeIds,
      );
      await _cacheEvent(saved);
      return (saved, null);
    } on DioException catch (e) {
      final failure = mapDioError(e);
      if (_isTemporaryFailure(failure)) {
        await _sync.queueCreate('workspaces/$workspaceId/events', id, data);
        return (event, failure);
      }
      await (_db.delete(_db.events)..where((row) => row.id.equals(id))).go();
      await (_db.delete(
        _db.eventAttendees,
      )..where((row) => row.eventId.equals(id))).go();
      return (null, failure);
    }
  }

  Future<AppFailure?> updateEvent(
    String eventId,
    Map<String, dynamic> updates,
  ) async {
    final row = await (_db.select(
      _db.events,
    )..where((event) => event.id.equals(eventId))).getSingleOrNull();
    if (row == null) {
      final failure = await _sendEventUpdate(eventId, updates);
      if (failure != null && _isTemporaryFailure(failure)) {
        await _sync.queueUpdate('events', eventId, updates);
      }
      return failure;
    }
    final attendeeRows = await (_db.select(
      _db.eventAttendees,
    )..where((attendee) => attendee.eventId.equals(eventId))).get();
    final original = EventModel(
      id: row.id,
      workspaceId: row.workspaceId,
      title: row.title,
      description: row.description,
      startsAt: row.startsAt,
      endsAt: row.endsAt,
      allDay: row.allDay,
      color: row.color,
      taskId: row.taskId,
      reminderMinutesBefore: row.reminderMinutesBefore,
      createdBy: row.createdBy,
      attendeeIds: attendeeRows.map((attendee) => attendee.userId).toList(),
    );
    final changed = EventModel(
      id: original.id,
      workspaceId: original.workspaceId,
      title: updates['title'] as String? ?? original.title,
      description: updates['description'] as String? ?? original.description,
      startsAt: updates['startsAt'] == null
          ? original.startsAt
          : DateTime.parse(updates['startsAt'] as String).toLocal(),
      endsAt: updates['endsAt'] == null
          ? original.endsAt
          : DateTime.parse(updates['endsAt'] as String).toLocal(),
      allDay: updates['allDay'] as bool? ?? original.allDay,
      color: updates['color'] as String? ?? original.color,
      taskId: original.taskId,
      reminderMinutesBefore:
          updates['reminderMinutesBefore'] as int? ??
          original.reminderMinutesBefore,
      createdBy: original.createdBy,
      attendeeIds:
          (updates['attendeeIds'] as List<dynamic>?)?.cast<String>() ??
          original.attendeeIds,
    );
    await _cacheEvent(changed);
    final failure = await _sendEventUpdate(eventId, updates);
    if (failure != null) {
      if (_isTemporaryFailure(failure)) {
        await _sync.queueUpdate('events', eventId, updates);
      } else {
        await _cacheEvent(original);
      }
    }
    return failure;
  }

  Future<AppFailure?> _sendEventUpdate(
    String eventId,
    Map<String, dynamic> updates,
  ) async {
    try {
      await _dio.patch('/events/$eventId', data: updates);
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }

  Future<AppFailure?> deleteEvent(String workspaceId, String eventId) async {
    final deletedAt = DateTime.now();
    await (_db.update(_db.events)..where((row) => row.id.equals(eventId)))
        .write(EventsCompanion(deletedAt: Value(deletedAt)));
    try {
      await _dio.delete('/events/$eventId');
      return null;
    } on DioException catch (e) {
      final failure = mapDioError(e);
      if (_isTemporaryFailure(failure)) {
        await _sync.queueDelete('events', eventId);
      } else {
        await (_db.update(_db.events)..where((row) => row.id.equals(eventId)))
            .write(EventsCompanion(deletedAt: const Value(null)));
      }
      return failure;
    }
  }

  Future<void> _cacheEvents(List<EventModel> events) async {
    await _db.transaction(() async {
      for (final event in events) {
        await _writeCachedEvent(event);
      }
    });
  }

  Future<void> _cacheEvent(EventModel event, {DateTime? now}) async {
    await _db.transaction(() async {
      await _writeCachedEvent(event, now: now);
    });
  }

  Future<void> _writeCachedEvent(EventModel event, {DateTime? now}) async {
    final timestamp = now ?? DateTime.now();
    await _db
        .into(_db.events)
        .insertOnConflictUpdate(
          EventsCompanion(
            id: Value(event.id),
            workspaceId: Value(event.workspaceId),
            title: Value(event.title),
            description: Value(event.description),
            startsAt: Value(event.startsAt),
            endsAt: Value(event.endsAt),
            allDay: Value(event.allDay),
            color: Value(event.color),
            taskId: Value(event.taskId),
            reminderMinutesBefore: Value(event.reminderMinutesBefore),
            createdBy: Value(event.createdBy),
            createdAt: Value(timestamp),
            updatedAt: Value(timestamp),
            deletedAt: const Value(null),
          ),
        );
    await (_db.delete(
      _db.eventAttendees,
    )..where((row) => row.eventId.equals(event.id))).go();
    for (final userId in event.attendeeIds.toSet()) {
      await _db
          .into(_db.eventAttendees)
          .insert(
            EventAttendeesCompanion.insert(
              eventId: event.id,
              userId: userId,
              createdAt: timestamp,
              updatedAt: timestamp,
            ),
          );
    }
  }

  Future<List<EventModel>> _getCachedEvents(
    String workspaceId,
    DateTime from,
    DateTime to,
  ) async {
    final rows =
        await (_db.select(_db.events)
              ..where(
                (event) =>
                    event.workspaceId.equals(workspaceId) &
                    event.deletedAt.isNull() &
                    event.startsAt.isBiggerOrEqualValue(from) &
                    event.startsAt.isSmallerOrEqualValue(to),
              )
              ..orderBy([(event) => OrderingTerm.asc(event.startsAt)]))
            .get();
    final models = <EventModel>[];
    for (final row in rows) {
      final attendees = await (_db.select(
        _db.eventAttendees,
      )..where((attendee) => attendee.eventId.equals(row.id))).get();
      models.add(
        EventModel(
          id: row.id,
          workspaceId: row.workspaceId,
          title: row.title,
          description: row.description,
          startsAt: row.startsAt,
          endsAt: row.endsAt,
          allDay: row.allDay,
          color: row.color,
          taskId: row.taskId,
          reminderMinutesBefore: row.reminderMinutesBefore,
          createdBy: row.createdBy,
          attendeeIds: attendees.map((attendee) => attendee.userId).toList(),
        ),
      );
    }
    return models;
  }

  Future<List<DueTaskModel>> _getCachedDueTasks(
    String workspaceId,
    DateTime from,
    DateTime to,
  ) async {
    final rows =
        await (_db.select(_db.tasks)..where(
              (task) =>
                  task.workspaceId.equals(workspaceId) &
                  task.deletedAt.isNull() &
                  task.dueAt.isBiggerOrEqualValue(from) &
                  task.dueAt.isSmallerOrEqualValue(to),
            ))
            .get();
    return rows
        .where((task) => task.dueAt != null)
        .map(
          (task) => DueTaskModel(
            id: task.id,
            title: task.title,
            dueAt: task.dueAt!,
            status: task.status,
            priority: task.priority,
          ),
        )
        .toList();
  }

  bool _isTemporaryFailure(AppFailure failure) =>
      failure is NetworkFailure ||
      failure is ServerUnreachableFailure ||
      failure is TimeoutFailure;
}

final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  return CalendarRepository(
    ref.watch(apiClientProvider).dio,
    ref.watch(appDatabaseProvider),
    ref.watch(syncEngineProvider.notifier),
  );
});

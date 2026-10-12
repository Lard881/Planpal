import 'package:drift/drift.dart';
import '../../../core/db/app_database.dart';
import '../../../core/network/api_client.dart';
import '../../../core/sync/outbox_service.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// S8.5: Event repository with Drift + Outbox + Sync
class EventRepository {
  final AppDatabase _db;
  final ApiClient _api;
  final OutboxService _outbox;

  EventRepository({
    required AppDatabase database,
    required ApiClient apiClient,
    required OutboxService outboxService,
  })  : _db = database,
        _api = apiClient,
        _outbox = outboxService;

  /// Watch events in date range
  Stream<List<Event>> watchEvents(
    String workspaceId, {
    DateTime? from,
    DateTime? to,
  }) {
    var query = _db.select(_db.events)
      ..where((e) => e.workspaceId.equals(workspaceId))
      ..where((e) => e.deletedAt.isNull());

    if (from != null) {
      query.where((e) => e.startTime.isBiggerOrEqualValue(from));
    }
    if (to != null) {
      query.where((e) => e.startTime.isSmallerOrEqualValue(to));
    }

    query.orderBy([(e) => OrderingTerm.asc(e.startTime)]);
    return query.watch();
  }

  /// Create event (offline-first)
  Future<Event> createEvent({
    required String workspaceId,
    required String title,
    required DateTime startsAt,
    required DateTime endsAt,
    bool? allDay,
    String? description,
    String? color,
    List<String>? attendeeIds,
  }) async {
    final eventId = _uuid.v4();
    final now = DateTime.now();

    // Save locally
    final event = EventsCompanion.insert(
      id: eventId,
      workspaceId: workspaceId,
      title: title,
      startTime: startsAt,
      endTime: endsAt,
      createdBy: 'current-user',
      createdAt: now,
      updatedAt: now,
      description: Value(description ?? ''),
    );

    await _db.into(_db.events).insert(event);

    // Queue for sync
    await _outbox.enqueue(
      entityType: 'event',
      entityId: eventId,
      operation: 'create',
      payload: {
        'id': eventId,
        'title': title,
        'workspace_id': workspaceId,
        'start_time': startsAt.toIso8601String(),
        'end_time': endsAt.toIso8601String(),
        'description': description,
        'attendee_ids': attendeeIds,
      },
    );

    return (await getEvent(eventId))!;
  }

  /// Update event
  Future<void> updateEvent(String eventId, EventsCompanion updates) async {
    await (_db.update(_db.events)..where((e) => e.id.equals(eventId)))
        .write(updates.copyWith(updatedAt: Value(DateTime.now())));

    final event = await getEvent(eventId);
    if (event == null) return;

    final payload = <String, dynamic>{};
    if (updates.title.present) payload['title'] = updates.title.value;
    if (updates.startTime.present) {
      payload['start_time'] = updates.startTime.value.toIso8601String();
    }
    if (updates.endTime.present) {
      payload['end_time'] = updates.endTime.value.toIso8601String();
    }
    if (updates.description.present) {
      payload['description'] = updates.description.value;
    }

    await _outbox.enqueue(
      entityType: 'event',
      entityId: eventId,
      operation: 'update',
      payload: payload,
    );
  }

  /// Delete event
  Future<void> deleteEvent(String eventId) async {
    final now = DateTime.now();
    await (_db.update(_db.events)..where((e) => e.id.equals(eventId))).write(
      EventsCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );

    final event = await (_db.select(_db.events)
          ..where((e) => e.id.equals(eventId)))
        .getSingleOrNull();
    if (event == null) return;

    await _outbox.enqueue(
      entityType: 'event',
      entityId: eventId,
      operation: 'delete',
      payload: {'id': eventId},
    );
  }

  /// Get single event
  Future<Event?> getEvent(String id) {
    return (_db.select(_db.events)..where((e) => e.id.equals(id)))
        .getSingleOrNull();
  }

  /// Sync events with server
  Future<void> syncEvents(String workspaceId) async {
    try {
      final response = await _api.get('/workspaces/$workspaceId/events');
      final eventsJson = response.data['events'] as List<dynamic>;

      for (final eventJson in eventsJson) {
        await _mergeEventFromServer(eventJson as Map<String, dynamic>);
      }
    } catch (e) {
      // ignore
    }
  }

  Future<void> _mergeEventFromServer(Map<String, dynamic> json) async {
    final event = EventsCompanion.insert(
      id: json['id'] as String,
      workspaceId: json['workspace_id'] as String,
      title: json['title'] as String,
      startTime: DateTime.parse((json['starts_at'] ?? json['start_time']) as String),
      endTime: DateTime.parse((json['ends_at'] ?? json['end_time']) as String),
      createdBy: (json['created_by'] ?? 'server') as String,
      createdAt: DateTime.parse((json['created_at'] ?? DateTime.now().toIso8601String()) as String),
      updatedAt: DateTime.parse((json['updated_at'] ?? DateTime.now().toIso8601String()) as String),
      description: Value((json['description'] as String?) ?? ''),
      deletedAt: Value(json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null),
    );

    await _db.into(_db.events).insertOnConflictUpdate(event);
  }
}

import 'dart:async';
import 'package:drift/drift.dart';
import 'package:planpal/core/db/app_database.dart';
import 'package:planpal/core/network/api_client.dart';
import 'package:planpal/core/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

/// Repository for notifications
class NotificationRepository {
  final AppDatabase _db;
  final ApiClient _api;
  final SupabaseService _supabase;

  StreamSubscription? _notificationSubscription;

  NotificationRepository({
    required AppDatabase db,
    required ApiClient api,
    required SupabaseService supabase,
  })  : _db = db,
        _api = api,
        _supabase = supabase;

  // ===== NOTIFICATIONS =====

  /// Watch all notifications (local cache)
  Stream<List<Notification>> watchNotifications({String? filter}) {
    var query = _db.select(_db.notifications)
      ..orderBy([(n) => OrderingTerm(expression: n.createdAt, mode: OrderingMode.desc)]);

    if (filter == 'unread') {
      query = query..where((n) => n.readAt.isNull());
    } else if (filter == 'tasks') {
      query = query
        ..where((n) => n.type.isIn([
              'task_assigned',
              'task_updated',
              'task_comment',
              'deadline_approaching',
              'task_overdue'
            ]));
    } else if (filter == 'mentions') {
      query = query..where((n) => n.type.equals('mention'));
    }

    return query.watch();
  }

  /// Get unread count
  Future<int> getUnreadCount() async {
    final count = await (_db.selectOnly(_db.notifications)
          ..addColumns([_db.notifications.id.count()])
          ..where(_db.notifications.readAt.isNull()))
        .getSingle();

    return count.read(_db.notifications.id.count()) ?? 0;
  }

  /// Watch unread count
  Stream<int> watchUnreadCount() {
    return (_db.selectOnly(_db.notifications)
          ..addColumns([_db.notifications.id.count()])
          ..where(_db.notifications.readAt.isNull()))
        .map((row) => row.read(_db.notifications.id.count()) ?? 0)
        .watchSingle();
  }

  /// Sync notifications from server
  Future<void> syncNotifications({String? filter, String? cursor}) async {
    try {
      final queryParams = <String, dynamic>{
        if (filter != null) 'filter': filter,
        if (cursor != null) 'cursor': cursor,
        'limit': 50,
      };

      final response = await _api.get('/notifications', queryParameters: queryParams);

      final notifications = (response.data['notifications'] as List)
          .map((json) => _notificationFromJson(json))
          .toList();

      await _db.batch((batch) {
        batch.insertAll(
          _db.notifications,
          notifications,
          mode: InsertMode.insertOrReplace,
        );
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _api.post('/notifications/$notificationId/read');

      await (_db.update(_db.notifications)..where((n) => n.id.equals(notificationId)))
          .write(NotificationsCompanion(readAt: Value(DateTime.now())));
    } catch (e) {
      rethrow;
    }
  }

  /// Mark notification as unread
  Future<void> markAsUnread(String notificationId) async {
    try {
      await _api.post('/notifications/$notificationId/unread');

      await (_db.update(_db.notifications)..where((n) => n.id.equals(notificationId)))
          .write(const NotificationsCompanion(readAt: Value(null)));
    } catch (e) {
      rethrow;
    }
  }

  /// Mark all as read
  Future<void> markAllAsRead() async {
    try {
      await _api.post('/notifications/read-all');

      await (_db.update(_db.notifications)..where((n) => n.readAt.isNull()))
          .write(NotificationsCompanion(readAt: Value(DateTime.now())));
    } catch (e) {
      rethrow;
    }
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _api.delete('/notifications/$notificationId');

      await (_db.delete(_db.notifications)..where((n) => n.id.equals(notificationId))).go();
    } catch (e) {
      rethrow;
    }
  }

  // ===== REALTIME SUBSCRIPTION =====

  /// Subscribe to notification updates
  void subscribeToNotifications() {
    _notificationSubscription?.cancel();

    _notificationSubscription = _supabase.client
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', _supabase.currentUserId!)
        .listen((data) {
      final notifications = data.map((json) => _notificationFromJson(json)).toList();
      _db.batch((batch) {
        batch.insertAll(
          _db.notifications,
          notifications,
          mode: InsertMode.insertOrReplace,
        );
      });
    });
  }

  /// Dispose
  void dispose() {
    _notificationSubscription?.cancel();
  }

  // ===== HELPER METHODS =====

  NotificationsCompanion _notificationFromJson(Map<String, dynamic> json) {
    return NotificationsCompanion.insert(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      body: Value(json['body'] as String? ?? ''),
      entityType: Value(json['entity_type'] as String?),
      entityId: Value(json['entity_id'] as String?),
      workspaceId: Value(json['workspace_id'] as String?),
      dedupeKey: Value(json['dedupe_key'] as String?),
      readAt: Value(json['read_at'] != null ? DateTime.parse(json['read_at'] as String) : null),
      pushedAt: Value(json['pushed_at'] != null ? DateTime.parse(json['pushed_at'] as String) : null),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

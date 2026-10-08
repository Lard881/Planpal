import 'package:drift/drift.dart';
import '../../../core/db/app_database.dart';
import '../../../core/network/api_client.dart';
import '../models/notification.dart';

class NotificationRepository {
  final AppDatabase _db;
  final ApiClient _api;

  NotificationRepository({
    required AppDatabase database,
    required ApiClient apiClient,
  })  : _db = database,
        _api = apiClient;

  // ========================================================================
  // Local database operations
  // ========================================================================

  /// Watch all notifications for the current user
  Stream<List<Notification>> watchNotifications({
    String? workspaceId,
    bool? read,
    String? type,
  }) {
    final query = _db.select(_db.notifications)
      ..orderBy([(n) => OrderingTerm.desc(n.createdAt)]);

    if (workspaceId != null) {
      query.where((n) => n.workspaceId.equals(workspaceId));
    }

    if (read != null) {
      if (read) {
        query.where((n) => n.readAt.isNotNull());
      } else {
        query.where((n) => n.readAt.isNull());
      }
    }

    if (type != null) {
      query.where((n) => n.type.equals(type));
    }

    return query.watch();
  }

  /// Get notifications as Future
  Future<List<Notification>> getNotifications({
    String? workspaceId,
    bool? read,
    String? type,
    int? limit,
  }) {
    final query = _db.select(_db.notifications)
      ..orderBy([(n) => OrderingTerm.desc(n.createdAt)]);

    if (workspaceId != null) {
      query.where((n) => n.workspaceId.equals(workspaceId));
    }

    if (read != null) {
      if (read) {
        query.where((n) => n.readAt.isNotNull());
      } else {
        query.where((n) => n.readAt.isNull());
      }
    }

    if (type != null) {
      query.where((n) => n.type.equals(type));
    }

    if (limit != null) {
      query.limit(limit);
    }

    return query.get();
  }

  /// Get unread notification count
  Stream<int> watchUnreadCount({String? workspaceId}) {
    final query = _db.notifications.count(
      where: (n) {
        Expression<bool> condition = n.readAt.isNull();
        if (workspaceId != null) {
          condition = condition & n.workspaceId.equals(workspaceId);
        }
        return condition;
      },
    );

    return query.watchSingle();
  }

  /// Get unread count as Future
  Future<int> getUnreadCount({String? workspaceId}) async {
    final query = _db.notifications.count(
      where: (n) {
        Expression<bool> condition = n.readAt.isNull();
        if (workspaceId != null) {
          condition = condition & n.workspaceId.equals(workspaceId);
        }
        return condition;
      },
    );

    return query.getSingle();
  }

  /// Get a single notification by ID
  Future<NotificationData?> getNotification(String id) async {
    final n = await (_db.select(_db.notifications)..where((n) => n.id.equals(id)))
        .getSingleOrNull();
    return n != null ? _notificationToModel(n) : null;
  }

  /// Watch a single notification by ID
  Stream<NotificationData?> watchNotification(String id) {
    return (_db.select(_db.notifications)..where((n) => n.id.equals(id)))
        .watchSingleOrNull()
        .map((n) => n != null ? _notificationToModel(n) : null);
  }

  /// Insert or update notification in local database
  Future<void> upsertNotification(AppNotification notification) {
    return _db.into(_db.notifications).insertOnConflictUpdate(
          NotificationsCompanion(
            id: Value(notification.id),
            userId: Value(notification.userId),
            workspaceId: Value(notification.workspaceId),
            type: Value(notification.type.value),
            title: Value(notification.title),
            body: Value(notification.body),
            entityType: Value(notification.entityType),
            entityId: Value(notification.entityId),
            dedupeKey: Value(notification.dedupeKey),
            readAt: Value(notification.readAt),
            pushedAt: Value(notification.pushedAt),
            createdAt: Value(notification.createdAt),
            updatedAt: Value(notification.updatedAt),
          ),
        );
  }

  /// Insert or update multiple notifications
  Future<void> upsertNotifications(List<AppNotification> notifications) async {
    await _db.batch((batch) {
      for (final notification in notifications) {
        batch.insert(
          _db.notifications,
          NotificationsCompanion(
            id: Value(notification.id),
            userId: Value(notification.userId),
            workspaceId: Value(notification.workspaceId),
            type: Value(notification.type.value),
            title: Value(notification.title),
            body: Value(notification.body),
            entityType: Value(notification.entityType),
            entityId: Value(notification.entityId),
            dedupeKey: Value(notification.dedupeKey),
            readAt: Value(notification.readAt),
            pushedAt: Value(notification.pushedAt),
            createdAt: Value(notification.createdAt),
            updatedAt: Value(notification.updatedAt),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// Mark notification as read locally
  Future<void> markAsReadLocal(String id) {
    return (_db.update(_db.notifications)..where((n) => n.id.equals(id)))
        .write(NotificationsCompanion(
      readAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Mark notification as unread locally
  Future<void> markAsUnreadLocal(String id) {
    return (_db.update(_db.notifications)..where((n) => n.id.equals(id)))
        .write(NotificationsCompanion(
      readAt: const Value(null),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Mark all notifications as read locally
  Future<void> markAllAsReadLocal({String? workspaceId}) {
    final query = _db.update(_db.notifications);

    if (workspaceId != null) {
      query.where((n) => n.workspaceId.equals(workspaceId));
    }

    return query.write(NotificationsCompanion(
      readAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Delete notification locally
  Future<void> deleteNotificationLocal(String id) {
    return (_db.delete(_db.notifications)..where((n) => n.id.equals(id))).go();
  }

  /// Delete multiple notifications locally
  Future<void> deleteNotificationsLocal(List<String> ids) {
    return (_db.delete(_db.notifications)..where((n) => n.id.isIn(ids))).go();
  }

  /// Clear all local notifications (for logout/reset)
  Future<void> clearAllLocal() {
    return _db.delete(_db.notifications).go();
  }

  // ========================================================================
  // API operations (with local sync)
  // ========================================================================

  /// Fetch notifications from API and sync to local database
  Future<List<AppNotification>> fetchAndSyncNotifications({
    int page = 1,
    int limit = 50,
    NotificationFilter? filter,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        ...?filter?.toQueryParams(),
      };

      final response = await _api.get('/notifications', queryParameters: queryParams);

      final notifications = (response.data['data'] as List)
          .map((json) => AppNotification.fromJson(json))
          .toList();

      // Sync to local database
      await upsertNotifications(notifications);

      return notifications;
    } catch (e) {
      // On error, return cached local data
      final localNotifications = await getNotifications(
        workspaceId: filter?.workspaceId,
        read: filter?.read,
        type: filter?.type?.value,
        limit: limit,
      );

      return localNotifications
          .map((data) => _notificationToModel(data))
          .toList();
    }
  }

  /// Get notification counts from API
  Future<NotificationCounts> fetchNotificationCounts({
    String? workspaceId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (workspaceId != null) {
        queryParams['workspace_id'] = workspaceId;
      }

      final response =
          await _api.get('/notifications/counts', queryParameters: queryParams);

      return NotificationCounts.fromJson(response.data);
    } catch (e) {
      // On error, calculate from local database
      final all = await getNotifications(workspaceId: workspaceId);
      final unreadCount =
          all.where((n) => n.readAt == null).length;

      return NotificationCounts(
        total: all.length,
        unread: unreadCount,
        read: all.length - unreadCount,
        byType: {},
        unreadByType: {},
      );
    }
  }

  /// Mark notification as read (API + local)
  Future<void> markAsRead(String id) async {
    try {
      // Optimistic local update
      await markAsReadLocal(id);

      // API call
      await _api.patch('/notifications/$id/read');
    } catch (e) {
      // Revert local change on error
      await markAsUnreadLocal(id);
      rethrow;
    }
  }

  /// Mark notification as unread (API + local)
  Future<void> markAsUnread(String id) async {
    try {
      // Optimistic local update
      await markAsUnreadLocal(id);

      // API call
      await _api.patch('/notifications/$id/unread');
    } catch (e) {
      // Revert local change on error
      await markAsReadLocal(id);
      rethrow;
    }
  }

  /// Mark all notifications as read (API + local)
  Future<int> markAllAsRead({String? workspaceId}) async {
    try {
      // Optimistic local update
      await markAllAsReadLocal(workspaceId: workspaceId);

      // API call
      final body = <String, dynamic>{};
      if (workspaceId != null) {
        body['workspace_id'] = workspaceId;
      }

      final response = await _api.post('/notifications/mark-all-read', data: body);

      return response.data['count'] as int;
    } catch (e) {
      // On error, return local count
      final count = await getUnreadCount(workspaceId: workspaceId);
      return count;
    }
  }

  /// Delete notification (API + local)
  Future<void> deleteNotification(String id) async {
    try {
      // Optimistic local delete
      await deleteNotificationLocal(id);

      // API call
      await _api.delete('/notifications/$id');
    } catch (e) {
      // On error, refetch from API to restore
      await fetchAndSyncNotifications(limit: 1);
      rethrow;
    }
  }

  /// Bulk delete notifications (API + local)
  Future<int> bulkDeleteNotifications(List<String> ids) async {
    try {
      // Optimistic local delete
      await deleteNotificationsLocal(ids);

      // API call
      final response = await _api.post(
        '/notifications/bulk-delete',
        data: {'notification_ids': ids},
      );

      return response.data['count'] as int;
    } catch (e) {
      // On error, refetch from API to restore
      await fetchAndSyncNotifications(limit: ids.length);
      rethrow;
    }
  }

  // ========================================================================
  // Helper methods
  // ========================================================================

  /// Convert Drift Notification to AppNotification model
  AppNotification _notificationToModel(Notification n) {
    return AppNotification(
      id: n.id,
      userId: n.userId,
      workspaceId: n.workspaceId,
      type: NotificationType.values.firstWhere(
        (t) => t.name == n.type,
        orElse: () => NotificationType.system,
      ),
      title: n.title,
      body: n.body,
      entityType: n.entityType,
      entityId: n.entityId,
      dedupeKey: n.dedupeKey,
      readAt: n.readAt,
      pushedAt: n.pushedAt,
      createdAt: n.createdAt,
      updatedAt: n.updatedAt,
    );
  }
}

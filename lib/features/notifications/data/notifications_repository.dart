// app/lib/features/notifications/data/notifications_repository.dart
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_mapper.dart';
import '../../../core/network/app_failure.dart';
import '../../../core/db/app_database.dart';
import '../../../core/sync/sync_engine.dart';
import '../models/notification_model.dart';

class NotificationsRepository {
  final Dio _dio;
  final AppDatabase _db;
  final SyncEngine _sync;
  NotificationsRepository(this._dio, this._db, this._sync);

  Future<(List<NotificationModel>, int, AppFailure?)> getNotifications({
    String filter = 'all',
    String? cursor,
  }) async {
    try {
      final params = <String, dynamic>{'filter': filter};
      if (cursor != null) params['cursor'] = cursor;
      final res = await _dio.get('/notifications', queryParameters: params);
      final list = (res.data['notifications'] as List)
          .map((n) => NotificationModel.fromJson(n as Map<String, dynamic>))
          .toList();
      await _cacheNotifications(list);
      final unreadCount = res.data['unreadCount'] as int? ?? 0;
      return (list, unreadCount, null);
    } on DioException catch (e) {
      final failure = mapDioError(e);
      if (failure is NetworkFailure ||
          failure is TimeoutFailure ||
          failure is ServerUnreachableFailure) {
        final cached = await _getCachedNotifications(filter);
        if (cached != null) return cached;
      }
      return (<NotificationModel>[], 0, mapDioError(e));
    }
  }

  Future<void> _cacheNotifications(List<NotificationModel> notifications) {
    return _db.transaction(() async {
      for (final notification in notifications) {
        await _db
            .into(_db.notifications)
            .insertOnConflictUpdate(
              NotificationsCompanion(
                id: Value(notification.id),
                userId: Value(notification.userId),
                workspaceId: Value(notification.workspaceId),
                type: Value(notification.type),
                title: Value(notification.title),
                body: Value(notification.body),
                entityType: Value(notification.entityType),
                entityId: Value(notification.entityId),
                readAt: Value(notification.readAt),
                createdAt: Value(notification.createdAt),
              ),
            );
      }
    });
  }

  Future<(List<NotificationModel>, int, AppFailure?)?> _getCachedNotifications(
    String filter,
  ) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return null;

    final rows =
        await (_db.select(_db.notifications)
              ..where((notification) => notification.userId.equals(userId))
              ..orderBy([
                (notification) => OrderingTerm.desc(notification.createdAt),
              ]))
            .get();
    if (rows.isEmpty) return null;

    final notifications = rows
        .map(
          (row) => NotificationModel(
            id: row.id,
            userId: row.userId,
            workspaceId: row.workspaceId,
            type: row.type,
            title: row.title,
            body: row.body,
            entityType: row.entityType,
            entityId: row.entityId,
            readAt: row.readAt,
            createdAt: row.createdAt,
          ),
        )
        .toList();
    final unreadCount = notifications
        .where((notification) => notification.isUnread)
        .length;
    final filtered = notifications.where((notification) {
      return switch (filter) {
        'unread' => notification.isUnread,
        'tasks' => const {
          'task_assigned',
          'task_updated',
          'task_comment',
          'deadline_approaching',
          'task_overdue',
        }.contains(notification.type),
        'mentions' => notification.type == 'mention',
        _ => true,
      };
    }).toList();

    return (filtered, unreadCount, null);
  }

  Future<AppFailure?> markRead(String notificationId) async {
    return _runAction(
      () => _dio.post('/notifications/$notificationId/read'),
      () => _setReadAt(notificationId, DateTime.now()),
      'mark_read',
      notificationId,
    );
  }

  Future<AppFailure?> markUnread(String notificationId) async {
    return _runAction(
      () => _dio.post('/notifications/$notificationId/unread'),
      () => _setReadAt(notificationId, null),
      'mark_unread',
      notificationId,
    );
  }

  Future<AppFailure?> markAllRead() async {
    return _runAction(
      () => _dio.post('/notifications/read-all'),
      _setAllRead,
      'mark_all_read',
      'all',
    );
  }

  Future<AppFailure?> deleteNotification(String notificationId) async {
    return _runAction(
      () => _dio.delete('/notifications/$notificationId'),
      () => _deleteCached(notificationId),
      'delete',
      notificationId,
    );
  }

  Future<AppFailure?> _runAction(
    Future<void> Function() request,
    Future<void> Function() updateLocal,
    String operation,
    String notificationId,
  ) async {
    try {
      await request();
      await updateLocal();
      return null;
    } on DioException catch (e) {
      final failure = mapDioError(e);
      if (failure is NetworkFailure ||
          failure is TimeoutFailure ||
          failure is ServerUnreachableFailure) {
        await updateLocal();
        await _sync.queueNotificationAction(operation, notificationId);
        return null;
      }
      return failure;
    }
  }

  Future<void> _setReadAt(String notificationId, DateTime? readAt) async {
    await (_db.update(_db.notifications)
          ..where((notification) => notification.id.equals(notificationId)))
        .write(NotificationsCompanion(readAt: Value(readAt)));
  }

  Future<void> _setAllRead() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    await (_db.update(_db.notifications)
          ..where((notification) => notification.userId.equals(userId)))
        .write(NotificationsCompanion(readAt: Value(DateTime.now())));
  }

  Future<void> _deleteCached(String notificationId) async {
    await (_db.delete(
      _db.notifications,
    )..where((notification) => notification.id.equals(notificationId))).go();
  }

  Future<AppFailure?> registerDevice(String token, String platform) async {
    try {
      await _dio.post('/devices', data: {'token': token, 'platform': platform});
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }

  Future<AppFailure?> unregisterDevice(String token) async {
    try {
      await _dio.delete('/devices/$token');
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }
}

final notificationsRepositoryProvider = Provider<NotificationsRepository>((
  ref,
) {
  return NotificationsRepository(
    ref.watch(apiClientProvider).dio,
    ref.watch(appDatabaseProvider),
    ref.watch(syncEngineProvider.notifier),
  );
});

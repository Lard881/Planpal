// app/lib/features/notifications/providers/notifications_providers.dart
import 'dart:async';
import '../../../core/platform/platform_info.dart';
import '../../../core/services/fcm_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/notifications_repository.dart';
import '../models/notification_model.dart';
import 'notification_preferences.dart';

class NotificationsState {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final bool loading;
  final String? error;
  final String filter; // all|unread|tasks|mentions

  const NotificationsState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.loading = false,
    this.error,
    this.filter = 'all',
  });

  NotificationsState copyWith({
    List<NotificationModel>? notifications,
    int? unreadCount,
    bool? loading,
    String? error,
    String? filter,
    bool clearError = false,
  }) => NotificationsState(
    notifications: notifications ?? this.notifications,
    unreadCount: unreadCount ?? this.unreadCount,
    loading: loading ?? this.loading,
    error: clearError ? null : (error ?? this.error),
    filter: filter ?? this.filter,
  );
}

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final NotificationsRepository _repo;
  final NotificationPreferences Function() _preferences;
  RealtimeChannel? _channel;

  NotificationsNotifier(this._repo, String? userId, this._preferences)
    : super(const NotificationsState()) {
    load();
    if (userId != null) _subscribe(userId);
  }

  void _subscribe(String userId) {
    _channel = Supabase.instance.client
        .channel('notifications:$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            unawaited(load());
            if (PlatformInfo.isWindows) {
              final notification =
                  Map<String, dynamic>.from(payload.newRecord);
              final preferences = _preferences();
              if (preferences.allowsInAppType(
                notification['type'] as String?,
              )) {
                unawaited(
                  FcmService.showRealtimeNotification(notification),
                );
              }
            }
          },
        )
        .subscribe();
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    super.dispose();
  }

  Future<void> load({String? filter}) async {
    final f = filter ?? state.filter;
    state = state.copyWith(loading: true, clearError: true, filter: f);
    final (list, unread, err) = await _repo.getNotifications(filter: f);
    if (!mounted) return;
    state = state.copyWith(
      notifications: list,
      unreadCount: unread,
      loading: false,
      error: err?.message,
    );
  }

  Future<void> markRead(String id) async {
    final wasUnread = state.notifications.any((n) => n.id == id && n.isUnread);
    final error = await _repo.markRead(id);
    if (error != null) {
      state = state.copyWith(error: error.message);
      return;
    }
    final updated = state.notifications
        .map(
          (n) => n.id == id
              ? NotificationModel(
                  id: n.id,
                  userId: n.userId,
                  workspaceId: n.workspaceId,
                  type: n.type,
                  title: n.title,
                  body: n.body,
                  entityType: n.entityType,
                  entityId: n.entityId,
                  readAt: DateTime.now(),
                  createdAt: n.createdAt,
                )
              : n,
        )
        .toList();
    state = state.copyWith(
      notifications: state.filter == 'unread'
          ? updated.where((notification) => notification.isUnread).toList()
          : updated,
      unreadCount: wasUnread
          ? (state.unreadCount - 1).clamp(0, 9999)
          : state.unreadCount,
      clearError: true,
    );
  }

  Future<void> markUnread(String id) async {
    final wasRead = state.notifications.any((n) => n.id == id && !n.isUnread);
    final error = await _repo.markUnread(id);
    if (error != null) {
      state = state.copyWith(error: error.message);
      return;
    }
    state = state.copyWith(
      notifications: state.notifications
          .map(
            (n) => n.id == id
                ? NotificationModel(
                    id: n.id,
                    userId: n.userId,
                    workspaceId: n.workspaceId,
                    type: n.type,
                    title: n.title,
                    body: n.body,
                    entityType: n.entityType,
                    entityId: n.entityId,
                    readAt: null,
                    createdAt: n.createdAt,
                  )
                : n,
          )
          .toList(),
      unreadCount: wasRead ? state.unreadCount + 1 : state.unreadCount,
      clearError: true,
    );
  }

  Future<void> markAllRead() async {
    final error = await _repo.markAllRead();
    if (error != null) {
      state = state.copyWith(error: error.message);
      return;
    }
    final updated = state.notifications
        .map(
          (n) => NotificationModel(
            id: n.id,
            userId: n.userId,
            workspaceId: n.workspaceId,
            type: n.type,
            title: n.title,
            body: n.body,
            entityType: n.entityType,
            entityId: n.entityId,
            readAt: n.readAt ?? DateTime.now(),
            createdAt: n.createdAt,
          ),
        )
        .toList();
    state = state.copyWith(
      notifications: state.filter == 'unread' ? [] : updated,
      unreadCount: 0,
      clearError: true,
    );
  }

  Future<void> delete(String id) async {
    final wasUnread = state.notifications.any((n) => n.id == id && n.isUnread);
    final error = await _repo.deleteNotification(id);
    if (error != null) {
      state = state.copyWith(error: error.message);
      return;
    }
    state = state.copyWith(
      notifications: state.notifications.where((n) => n.id != id).toList(),
      unreadCount: wasUnread
          ? (state.unreadCount - 1).clamp(0, 9999)
          : state.unreadCount,
      clearError: true,
    );
  }

  void addRealtime(NotificationModel n) {
    if (!state.notifications.any((existing) => existing.id == n.id)) {
      state = state.copyWith(
        notifications: [n, ...state.notifications],
        unreadCount: state.unreadCount + 1,
      );
    }
  }
}

final notificationsProvider =
    StateNotifierProvider.autoDispose<
      NotificationsNotifier,
      NotificationsState
    >(
      (ref) => NotificationsNotifier(
        ref.watch(notificationsRepositoryProvider),
        Supabase.instance.client.auth.currentUser?.id,
        () => ref.read(notificationPreferencesProvider),
      ),
    );

// Global unread count provider — used by the bell icon in the shell
final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationsProvider).unreadCount;
});

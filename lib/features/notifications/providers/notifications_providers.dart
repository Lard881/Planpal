// app/lib/features/notifications/providers/notifications_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/notifications_repository.dart';
import '../models/notification_model.dart';

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

  NotificationsNotifier(this._repo) : super(const NotificationsState()) {
    load();
  }

  Future<void> load({String? filter}) async {
    final f = filter ?? state.filter;
    state = state.copyWith(loading: true, clearError: true, filter: f);
    final (list, unread, err) = await _repo.getNotifications(filter: f);
    state = state.copyWith(
      notifications: list,
      unreadCount: unread,
      loading: false,
      error: err?.message,
    );
  }

  Future<void> markRead(String id) async {
    await _repo.markRead(id);
    state = state.copyWith(
      notifications: state.notifications.map((n) =>
        n.id == id
            ? NotificationModel(
                id: n.id, userId: n.userId, workspaceId: n.workspaceId,
                type: n.type, title: n.title, body: n.body,
                entityType: n.entityType, entityId: n.entityId,
                readAt: DateTime.now(), createdAt: n.createdAt)
            : n).toList(),
      unreadCount: (state.unreadCount - 1).clamp(0, 9999),
    );
  }

  Future<void> markUnread(String id) async {
    await _repo.markUnread(id);
    state = state.copyWith(
      notifications: state.notifications.map((n) =>
        n.id == id
            ? NotificationModel(
                id: n.id, userId: n.userId, workspaceId: n.workspaceId,
                type: n.type, title: n.title, body: n.body,
                entityType: n.entityType, entityId: n.entityId,
                readAt: null, createdAt: n.createdAt)
            : n).toList(),
      unreadCount: state.unreadCount + 1,
    );
  }

  Future<void> markAllRead() async {
    await _repo.markAllRead();
    state = state.copyWith(
      notifications: state.notifications.map((n) =>
        NotificationModel(
          id: n.id, userId: n.userId, workspaceId: n.workspaceId,
          type: n.type, title: n.title, body: n.body,
          entityType: n.entityType, entityId: n.entityId,
          readAt: n.readAt ?? DateTime.now(), createdAt: n.createdAt)
      ).toList(),
      unreadCount: 0,
    );
  }

  Future<void> delete(String id) async {
    await _repo.deleteNotification(id);
    state = state.copyWith(
      notifications: state.notifications.where((n) => n.id != id).toList());
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
    StateNotifierProvider.autoDispose<NotificationsNotifier, NotificationsState>(
  (ref) => NotificationsNotifier(ref.watch(notificationsRepositoryProvider)),
);

// Global unread count provider — used by the bell icon in the shell
final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationsProvider).unreadCount;
});

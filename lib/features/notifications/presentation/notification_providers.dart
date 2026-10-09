import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planpal/core/db/app_database.dart';
import 'package:planpal/core/network/api_client.dart';
import 'package:planpal/core/services/supabase_service.dart';
import 'package:planpal/features/notifications/data/notification_repository.dart';

/// Notification repository provider
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final api = ref.watch(apiClientProvider);
  final supabase = ref.watch(supabaseServiceProvider);

  final repo = NotificationRepository(db: db, api: api, supabase: supabase);

  // Subscribe to realtime updates
  Future.microtask(() => repo.subscribeToNotifications());

  ref.onDispose(() {
    repo.dispose();
  });

  return repo;
});

/// Current notification filter provider
final notificationFilterProvider = StateProvider<String?>((ref) => null);

/// Notifications list provider
final notificationsProvider = StreamProvider<List<Notification>>((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  final filter = ref.watch(notificationFilterProvider);

  // Trigger initial sync
  Future.microtask(() => repo.syncNotifications(filter: filter));

  return repo.watchNotifications(filter: filter);
});

/// Unread count provider
final unreadCountProvider = StreamProvider<int>((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.watchUnreadCount();
});

/// Notification actions controller
final notificationActionsProvider = Provider<NotificationActions>((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  return NotificationActions(repo);
});

/// Controller for notification actions
class NotificationActions {
  final NotificationRepository _repo;

  NotificationActions(this._repo);

  Future<void> markAsRead(String notificationId) async {
    await _repo.markAsRead(notificationId);
  }

  Future<void> markAsUnread(String notificationId) async {
    await _repo.markAsUnread(notificationId);
  }

  Future<void> markAllAsRead() async {
    await _repo.markAllAsRead();
  }

  Future<void> deleteNotification(String notificationId) async {
    await _repo.deleteNotification(notificationId);
  }
}

/// API client provider
final apiClientProvider = Provider<ApiClient>((ref) {
  throw UnimplementedError('ApiClient provider must be overridden');
});

/// Supabase service provider
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

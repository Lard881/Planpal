import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/db/app_database.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers/app_providers.dart';
import '../models/notification.dart';
import '../repositories/notification_repository.dart';
import '../data/notification_realtime_service.dart';
import '../data/windows_notification_service.dart';

/// Notification repository provider
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final database = ref.watch(databaseProvider);
  final apiClient = ref.watch(apiClientProvider);

  return NotificationRepository(
    database: database,
    apiClient: apiClient,
  );
});

/// Notification realtime service provider
final notificationRealtimeServiceProvider =
    Provider<NotificationRealtimeService?>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  final supabase = Supabase.instance.client;
  final currentUser = supabase.auth.currentUser;

  if (currentUser == null) {
    return null;
  }

  // Windows notification callback (only on Windows platform)
  OnNotificationReceived? onNotificationReceived;
  
  if (Platform.isWindows) {
    // Get Windows notification service (will be initialized separately)
    onNotificationReceived = (notification) {
      // Show local notification on Windows
      WindowsNotificationService().showNotification(notification);
    };
  }

  final service = NotificationRealtimeService(
    supabase: supabase,
    repository: repository,
    userId: currentUser.id,
    onNotificationReceived: onNotificationReceived,
  );

  // Start listening on creation
  service.startListening();

  // Cleanup on dispose
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

/// Watch all notifications stream provider
final notificationsStreamProvider = StreamProvider.autoDispose
    .family<List<NotificationData>, NotificationFilter?>((ref, filter) {
  final repository = ref.watch(notificationRepositoryProvider);

  // Ensure realtime service is started
  ref.watch(notificationRealtimeServiceProvider);

  return repository.watchNotifications(
    workspaceId: filter?.workspaceId,
    read: filter?.read,
    type: filter?.type?.value,
  );
});

/// Watch unread notification count
final unreadNotificationCountProvider =
    StreamProvider.autoDispose.family<int, String?>((ref, workspaceId) {
  final repository = ref.watch(notificationRepositoryProvider);

  // Ensure realtime service is started
  ref.watch(notificationRealtimeServiceProvider);

  return repository.watchUnreadCount(workspaceId: workspaceId);
});

/// Fetch and sync notifications future provider
final fetchNotificationsProvider = FutureProvider.autoDispose
    .family<List<AppNotification>, NotificationFilter?>((ref, filter) async {
  final repository = ref.watch(notificationRepositoryProvider);

  return repository.fetchAndSyncNotifications(
    page: 1,
    limit: 100,
    filter: filter,
  );
});

/// Notification counts provider
final notificationCountsProvider = FutureProvider.autoDispose
    .family<NotificationCounts, String?>((ref, workspaceId) async {
  final repository = ref.watch(notificationRepositoryProvider);

  return repository.fetchNotificationCounts(workspaceId: workspaceId);
});

/// Mark notification as read action
final markNotificationAsReadProvider =
    Provider.autoDispose<Future<void> Function(String)>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);

  return (String id) async {
    await repository.markAsRead(id);
  };
});

/// Mark notification as unread action
final markNotificationAsUnreadProvider =
    Provider.autoDispose<Future<void> Function(String)>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);

  return (String id) async {
    await repository.markAsUnread(id);
  };
});

/// Mark all notifications as read action
final markAllNotificationsAsReadProvider =
    Provider.autoDispose<Future<int> Function({String? workspaceId})>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);

  return ({String? workspaceId}) async {
    return repository.markAllAsRead(workspaceId: workspaceId);
  };
});

/// Delete notification action
final deleteNotificationProvider =
    Provider.autoDispose<Future<void> Function(String)>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);

  return (String id) async {
    await repository.deleteNotification(id);
  };
});

/// Bulk delete notifications action
final bulkDeleteNotificationsProvider =
    Provider.autoDispose<Future<int> Function(List<String>)>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);

  return (List<String> ids) async {
    return repository.bulkDeleteNotifications(ids);
  };
});

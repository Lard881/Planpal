import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../core/providers/app_providers.dart';
import 'firebase_messaging_service.dart';

/// Provider for FirebaseMessagingService singleton instance
final firebaseMessagingServiceProvider = Provider<FirebaseMessagingService>((ref) {
  final service = FirebaseMessagingService();
  
  // Set dependencies when they become available
  final apiClient = ref.watch(apiClientProvider);
  final repository = ref.watch(notificationRepositoryProvider);
  
  service.setDependencies(
    apiClient: apiClient,
    repository: repository,
  );
  
  return service;
});

/// Provider for FCM token
final fcmTokenProvider = FutureProvider<String?>((ref) async {
  final service = ref.watch(firebaseMessagingServiceProvider);
  return service.getToken();
});

/// Provider to initialize Firebase Messaging
final initializeFirebaseMessagingProvider = FutureProvider<void>((ref) async {
  final service = ref.watch(firebaseMessagingServiceProvider);
  await service.initialize();
});

/// Provider for notification permission status
final notificationPermissionProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(firebaseMessagingServiceProvider);
  return service.areNotificationsEnabled();
});

/// Provider to request notification permissions
final requestNotificationPermissionProvider = FutureProvider.autoDispose<bool>((ref) async {
  final service = ref.watch(firebaseMessagingServiceProvider);
  return service.requestPermission();
});

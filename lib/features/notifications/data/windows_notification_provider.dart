import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'windows_notification_service.dart';
import '../presentation/notification_providers.dart';

/// Provider for WindowsNotificationService singleton instance
final windowsNotificationServiceProvider = Provider<WindowsNotificationService>((ref) {
  final service = WindowsNotificationService();
  
  // Set dependencies when they become available
  final repository = ref.watch(notificationRepositoryProvider);
  
  service.setDependencies(
    repository: repository,
  );
  
  return service;
});

/// Provider to initialize Windows local notifications
final initializeWindowsNotificationsProvider = FutureProvider<void>((ref) async {
  final service = ref.watch(windowsNotificationServiceProvider);
  await service.initialize();
});

/// Provider for Windows notification enabled status
final windowsNotificationEnabledProvider = StateProvider<bool>((ref) => true);

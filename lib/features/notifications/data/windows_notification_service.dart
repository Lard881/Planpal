import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../core/navigation/global_navigator_key.dart';
import 'notification_navigation_service.dart';
import '../repositories/notification_repository.dart';
import '../models/notification.dart' as app_models;
import '../models/notification_settings.dart';

/// Service for showing local notifications on Windows when app is running
/// Windows doesn't support push notifications, so we rely on Realtime updates
class WindowsNotificationService {
  static final WindowsNotificationService _instance = WindowsNotificationService._internal();
  factory WindowsNotificationService() => _instance;
  
  WindowsNotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  NotificationRepository? _repository;
  NotificationSettings? _settings;
  
  bool _isInitialized = false;

  /// Set dependencies (call this before initialize)
  void setDependencies({
    NotificationRepository? repository,
    NotificationSettings? settings,
  }) {
    _repository = repository;
    _settings = settings;
  }

  /// Update settings (called when settings change)
  void updateSettings(NotificationSettings settings) {
    _settings = settings;
  }

  /// Initialize local notifications for Windows
  Future<void> initialize() async {
    if (_isInitialized) return;
    if (!Platform.isWindows) {
      debugPrint('WindowsNotificationService: Not on Windows, skipping initialization');
      return;
    }

    try {
      // TODO: Windows notifications - InitializationSettings doesn't have 'windows' parameter
      // Use a stub for now
      const initSettings = InitializationSettings(
        // Windows not yet supported by flutter_local_notifications
        android: null,
        iOS: null,
      );

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _handleNotificationTap,
      );

      _isInitialized = true;
      debugPrint('✓ Windows local notifications initialized');
    } catch (e, stackTrace) {
      debugPrint('Error initializing Windows notifications: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Show a notification (called when Realtime update received)
  Future<void> showNotification(app_models.AppNotification notification) async {
    if (!_isInitialized) {
      debugPrint('WindowsNotificationService: Not initialized');
      return;
    }

    // Check settings
    if (_settings != null) {
      if (!_settings!.shouldShowNotification(notification.type.value)) {
        debugPrint('WindowsNotificationService: Notification type disabled by user');
        return;
      }
    }

    if (!Platform.isWindows) {
      debugPrint('WindowsNotificationService: Not on Windows platform');
      return;
    }

    try {
      // Build payload for tap handling
      final payload = '${notification.id}|${notification.entityType ?? ''}|${notification.entityId ?? ''}';

      const windowsDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        subtitle: null,
        threadIdentifier: 'planpal_notifications',
      );

      // TODO: NotificationDetails doesn't have 'windows' parameter
      const details = NotificationDetails(
        // windows: windowsDetails, // Not supported
      );

      await _localNotifications.show(
        notification.id.hashCode,
        notification.title,
        notification.body,
        details,
        payload: payload,
      );

      debugPrint('Showed Windows notification: ${notification.title}');
    } catch (e, stackTrace) {
      debugPrint('Error showing Windows notification: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Handle notification tap
  void _handleNotificationTap(NotificationResponse response) {
    debugPrint('Windows notification tapped: ${response.payload}');

    if (response.payload != null) {
      // Parse payload and navigate
      final parts = response.payload!.split('|');
      if (parts.length >= 3) {
        final notificationId = parts[0];
        final entityType = parts[1];
        final entityId = parts[2];

        // Mark as read
        if (_repository != null) {
          _repository!.markAsRead(notificationId).catchError((e) {
            debugPrint('Error marking notification as read: $e');
          });
        }

        // Navigate using the global navigator key
        if (entityType.isNotEmpty && entityId.isNotEmpty) {
          final context = globalNavigatorKey.currentContext;
          if (context != null) {
            // Create temporary notification object for navigation
            final tempNotification = app_models.AppNotification(
              id: 'temp',
              userId: '',
              workspaceId: '',
              type: app_models.NotificationType.system,
              title: '',
              body: '',
              entityType: entityType,
              entityId: entityId,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
            NotificationNavigationService.navigateToNotification(
              context,
              tempNotification,
            );
          }
        }
      }
    }
  }

  /// Enable or disable notifications (user preference)
  void setEnabled(bool enabled) {
    debugPrint('Windows notifications ${enabled ? 'enabled' : 'disabled'}');
    // This is now handled by NotificationSettings
  }

  /// Check if notifications are enabled
  bool get isEnabled => _settings?.pushEnabled ?? true;

  /// Check if initialized
  bool get isInitialized => _isInitialized;

  /// Cancel a notification
  Future<void> cancelNotification(String notificationId) async {
    if (!_isInitialized) return;

    try {
      await _localNotifications.cancel(notificationId.hashCode);
    } catch (e) {
      debugPrint('Error canceling notification: $e');
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    if (!_isInitialized) return;

    try {
      await _localNotifications.cancelAll();
    } catch (e) {
      debugPrint('Error canceling all notifications: $e');
    }
  }

  /// Check if platform supports local notifications
  static bool get isSupported => Platform.isWindows;
}

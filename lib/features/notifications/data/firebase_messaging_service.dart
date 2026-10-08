import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../core/network/api_client.dart';
import '../../../core/navigation/global_navigator_key.dart';
import 'notification_navigation_service.dart';
import '../repositories/notification_repository.dart';
import '../models/notification.dart' as app_models;

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message received: ${message.messageId}');
  // Background messages are handled by the OS notification system
  // The tap handler will be called when user taps the notification
}

/// Service for handling Firebase Cloud Messaging (FCM) push notifications
class FirebaseMessagingService {
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();
  factory FirebaseMessagingService() => _instance;
  
  FirebaseMessagingService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  ApiClient? _apiClient;
  NotificationRepository? _repository;
  
  bool _isInitialized = false;
  String? _fcmToken;

  /// Set dependencies (call this before initialize)
  void setDependencies({
    required ApiClient apiClient,
    NotificationRepository? repository,
  }) {
    _apiClient = apiClient;
    _repository = repository;
  }

  /// Initialize FCM and request permissions
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Register background message handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Initialize local notifications plugin
      await _initializeLocalNotifications();

      // Request permission (iOS/macOS/Web)
      final permission = await requestPermission();
      if (!permission) {
        debugPrint('Notification permission denied');
        return;
      }

      // Get FCM token
      _fcmToken = await _firebaseMessaging.getToken();
      debugPrint('FCM Token: $_fcmToken');

      if (_fcmToken != null && _apiClient != null) {
        // Register token with backend
        await _registerTokenWithBackend(_fcmToken!);
      }

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        debugPrint('FCM Token refreshed: $newToken');
        _fcmToken = newToken;
        if (_apiClient != null) {
          _registerTokenWithBackend(newToken);
        }
      });

      // Configure foreground notification presentation (iOS)
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle background message taps
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // Check if app was opened from a terminated state via notification
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpenedApp(initialMessage);
      }

      _isInitialized = true;
      debugPrint('Firebase Messaging initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('Error initializing Firebase Messaging: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Initialize local notifications plugin for foreground notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );

    // Create Android notification channel
    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        'planpal_notifications',
        'PlanPal Notifications',
        description: 'Notifications for tasks, deadlines, and events',
        importance: Importance.high,
        enableVibration: true,
        playSound: true,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  /// Request notification permissions
  Future<bool> requestPermission() async {
    if (Platform.isIOS || Platform.isMacOS) {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    }

    // Android 13+ requires runtime permission
    if (Platform.isAndroid) {
      final plugin = _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (plugin != null) {
        final granted = await plugin.requestNotificationsPermission();
        return granted ?? false;
      }
    }

    return true; // Assume granted for older Android versions
  }

  /// Register FCM token with backend
  Future<void> _registerTokenWithBackend(String token) async {
    if (_apiClient == null) return;
    
    try {
      final platform = _getPlatformString();

      await _apiClient!.post(
        '/device-tokens',
        data: {
          'token': token,
          'platform': platform,
        },
      );

      debugPrint('FCM token registered with backend: $platform');
    } catch (e) {
      debugPrint('Error registering FCM token: $e');
    }
  }

  /// Handle foreground messages (when app is open)
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('Foreground message: ${message.messageId}');

    // Sync notification to local database
    await _syncNotificationToDatabase(message);

    // Show local notification
    await _showLocalNotification(message);
  }

  /// Handle message opened from background/terminated state
  Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
    debugPrint('Message opened app: ${message.messageId}');

    // Extract navigation data
    final notificationId = message.data['notificationId'] as String?;
    final entityType = message.data['entityType'] as String?;
    final entityId = message.data['entityId'] as String?;

    if (notificationId != null && _repository != null) {
      // Mark as read
      try {
        await _repository!.markAsRead(notificationId);
      } catch (e) {
        debugPrint('Error marking notification as read: $e');
      }
    }

    // Navigate using the global navigator key
    if (entityType != null && entityId != null) {
      final context = globalNavigatorKey.currentContext;
      if (context != null) {
        // Create temporary notification for navigation
        final tempNotification = app_models.AppNotification(
          id: notificationId ?? 'temp',
          userId: '',
          workspaceId: '',
          type: app_models.NotificationType.system,
          title: message.notification?.title ?? '',
          body: message.notification?.body ?? '',
          entityType: entityType,
          entityId: entityId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        NotificationNavigationService.navigateToNotification(
          context,
          tempNotification,
        );
      } else {
        debugPrint('Navigation context not available, storing for later');
        // Store for when context becomes available
        _pendingNavigation = {
          'entityType': entityType,
          'entityId': entityId,
        };
      }
    }
  }

  Map<String, String>? _pendingNavigation;

  /// Check and execute pending navigation (call when app is ready)
  void executePendingNavigation() {
    if (_pendingNavigation != null) {
      final context = globalNavigatorKey.currentContext;
      if (context != null) {
        // Create temporary notification for navigation
        final tempNotification = app_models.AppNotification(
          id: 'pending',
          userId: '',
          workspaceId: '',
          type: app_models.NotificationType.system,
          title: '',
          body: '',
          entityType: _pendingNavigation!['entityType'],
          entityId: _pendingNavigation!['entityId'],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        NotificationNavigationService.navigateToNotification(
          context,
          tempNotification,
        );
        _pendingNavigation = null;
      }
    }
  }

  /// Handle notification tap (from local notification)
  void _handleNotificationTap(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');

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
        final context = globalNavigatorKey.currentContext;
        if (context != null) {
          // Create temporary notification for navigation
          final tempNotification = app_models.AppNotification(
            id: notificationId,
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

  /// Show local notification for foreground messages
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    // Build payload for tap handling
    final notificationId = message.data['notificationId'] ?? '';
    final entityType = message.data['entityType'] ?? '';
    final entityId = message.data['entityId'] ?? '';
    final payload = '$notificationId|$entityType|$entityId';

    const androidDetails = AndroidNotificationDetails(
      'planpal_notifications',
      'PlanPal Notifications',
      channelDescription: 'Notifications for tasks, deadlines, and events',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
      payload: payload,
    );
  }

  /// Sync FCM notification to local database
  Future<void> _syncNotificationToDatabase(RemoteMessage message) async {
    if (_repository == null) return;

    try {
      final data = message.data;
      final notificationId = data['notificationId'] as String?;

      if (notificationId == null) return;

      // Create notification model from FCM data
      final notification = app_models.AppNotification(
        id: notificationId,
        userId: data['userId'] ?? '',
        workspaceId: data['workspaceId'] ?? '',
        type: app_models.NotificationTypeExtension.fromString(
          data['type'] ?? 'system',
        ),
        title: message.notification?.title ?? data['title'] ?? '',
        body: message.notification?.body ?? data['body'] ?? '',
        entityType: data['entityType'],
        entityId: data['entityId'],
        dedupeKey: data['dedupeKey'],
        readAt: null, // New notification
        pushedAt: DateTime.now(), // Just pushed
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _repository!.upsertNotification(notification);
    } catch (e) {
      debugPrint('Error syncing notification to database: $e');
    }
  }

  /// Get platform string for API
  String _getPlatformString() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isWindows) return 'windows';
    return 'unknown';
  }

  /// Get current FCM token
  Future<String?> getToken() async {
    _fcmToken ??= await _firebaseMessaging.getToken();
    return _fcmToken;
  }

  /// Check if initialized
  bool get isInitialized => _isInitialized;

  /// Delete FCM token (for sign out)
  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      _fcmToken = null;
      debugPrint('FCM token deleted');
    } catch (e) {
      debugPrint('Error deleting FCM token: $e');
    }
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    if (Platform.isIOS || Platform.isMacOS) {
      final settings = await _firebaseMessaging.getNotificationSettings();
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    }

    if (Platform.isAndroid) {
      final plugin = _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (plugin != null) {
        final granted = await plugin.areNotificationsEnabled();
        return granted ?? false;
      }
    }

    return true;
  }
}

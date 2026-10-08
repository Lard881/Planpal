import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:planpal/core/network/api_client.dart';

/// Push notification service for Android and Windows
class PushNotificationService {
  final ApiClient _api;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final FirebaseMessaging _firebaseMessaging;

  String? _fcmToken;
  StreamSubscription? _tokenRefreshSubscription;

  PushNotificationService({
    required ApiClient api,
  })  : _api = api,
        _localNotifications = FlutterLocalNotificationsPlugin(),
        _firebaseMessaging = FirebaseMessaging.instance;

  /// Initialize push notifications
  Future<void> initialize() async {
    if (Platform.isAndroid) {
      await _initializeAndroid();
    } else if (Platform.isWindows) {
      await _initializeWindows();
    }
  }

  /// Initialize Android push notifications
  Future<void> _initializeAndroid() async {
    // Request permission
    final permission = await _requestPermission();
    if (!permission) {
      print('Push notification permission denied');
      return;
    }

    // Initialize local notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );

    // Create notification channel
    const channel = AndroidNotificationChannel(
      'planpal_notifications',
      'PlanPal Notifications',
      description: 'Notifications for tasks, events, and messages',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Get FCM token
    _fcmToken = await _firebaseMessaging.getToken();
    if (_fcmToken != null) {
      await _registerToken(_fcmToken!);
    }

    // Listen for token refresh
    _tokenRefreshSubscription = _firebaseMessaging.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      _registerToken(newToken);
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessageTap);

    // Handle initial message (app opened from notification)
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessageTap(initialMessage);
    }
  }

  /// Initialize Windows local notifications
  Future<void> _initializeWindows() async {
    const initSettings = InitializationSettings(
      windows: DarwinInitializationSettings(),
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );
  }

  /// Request notification permission
  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    }

    return true;
  }

  /// Register FCM token with backend
  Future<void> _registerToken(String token) async {
    try {
      await _api.post('/devices', data: {
        'token': token,
        'platform': Platform.isAndroid ? 'android' : 'windows',
      });
      print('FCM token registered: ${token.substring(0, 10)}...');
    } catch (e) {
      print('Failed to register FCM token: $e');
    }
  }

  /// Unregister FCM token (on logout)
  Future<void> unregisterToken() async {
    if (_fcmToken != null) {
      try {
        await _api.delete('/devices/$_fcmToken');
        print('FCM token unregistered');
      } catch (e) {
        print('Failed to unregister FCM token: $e');
      }
    }
  }

  /// Handle foreground message (show local notification)
  void _handleForegroundMessage(RemoteMessage message) {
    print('Foreground message received: ${message.messageId}');

    final notification = message.notification;
    if (notification != null) {
      _showLocalNotification(
        title: notification.title ?? 'PlanPal',
        body: notification.body ?? '',
        payload: message.data['entity_id']?.toString(),
      );
    }
  }

  /// Handle background message tap
  void _handleBackgroundMessageTap(RemoteMessage message) {
    print('Background message tapped: ${message.messageId}');
    
    // Navigate to entity
    final entityType = message.data['entity_type'];
    final entityId = message.data['entity_id'];
    final workspaceId = message.data['workspace_id'];

    if (entityType != null && entityId != null && workspaceId != null) {
      _navigateToEntity(entityType, entityId, workspaceId);
    }
  }

  /// Handle notification tap (local notification)
  void _handleNotificationTap(NotificationResponse response) {
    print('Local notification tapped: ${response.payload}');
    
    // TODO: Navigate to entity based on payload
    // This requires integrating with the app's navigation system
  }

  /// Show local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'planpal_notifications',
      'PlanPal Notifications',
      channelDescription: 'Notifications for tasks, events, and messages',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// Show local notification from Realtime (Windows)
  Future<void> showRealtimeNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (Platform.isWindows) {
      await _showLocalNotification(
        title: title,
        body: body,
        payload: payload,
      );
    }
  }

  /// Navigate to entity (to be implemented with app navigation)
  void _navigateToEntity(String entityType, String entityId, String workspaceId) {
    // TODO: Implement navigation using GoRouter
    // This will be connected to the app's navigation system
    print('Navigate to: $entityType/$entityId in workspace $workspaceId');
  }

  /// Dispose
  void dispose() {
    _tokenRefreshSubscription?.cancel();
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message: ${message.messageId}');
  // Handle background message
}

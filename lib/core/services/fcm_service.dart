// app/lib/core/services/fcm_service.dart
// Android FCM: request permission, get token, register with backend, handle taps.
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../network/api_client.dart';
import '../platform/platform_info.dart';

// Background message handler — must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // App is in background/terminated — Flutter engine is available
  // Navigation will happen when the user taps the notification
  debugPrint('FCM background message: ${message.messageId}');
}

class FcmService {
  static final _messaging = FirebaseMessaging.instance;
  static String? _currentToken;

  /// Call once after Firebase.initializeApp() in main.dart
  static Future<void> initialize(WidgetRef ref) async {
    if (!PlatformInfo.isAndroid) return;

    // Register background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permission (Android 13+)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('FCM: permission denied');
      return;
    }

    // Get token and register with backend
    await _registerToken(ref);

    // Refresh token listener
    _messaging.onTokenRefresh.listen((newToken) {
      _currentToken = newToken;
      _sendTokenToBackend(ref, newToken);
    });

    // Foreground messages — show a snackbar or in-app notification
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('FCM foreground: ${message.notification?.title}');
      // The notification bell will update via Realtime — no extra action needed
    });

    // App opened from a notification tap (background → foreground)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotificationTap(message);
    });

    // App opened from terminated state via notification
    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      _handleNotificationTap(initial);
    }
  }

  static Future<void> _registerToken(WidgetRef ref) async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        _currentToken = token;
        await _sendTokenToBackend(ref, token);
      }
    } catch (e) {
      debugPrint('FCM token error: $e');
    }
  }

  static Future<void> _sendTokenToBackend(WidgetRef ref, String token) async {
    try {
      await ref.read(apiClientProvider).dio.post('/devices', data: {
        'token': token,
        'platform': 'android',
      });
    } catch (e) {
      debugPrint('FCM register error: $e');
    }
  }

  /// Call on sign-out to unregister the device token
  static Future<void> unregister(WidgetRef ref) async {
    if (_currentToken == null) return;
    try {
      await ref.read(apiClientProvider).dio.delete('/devices/$_currentToken');
      _currentToken = null;
    } catch (_) {}
  }

  /// Navigate to the right screen based on notification data
  static void _handleNotificationTap(RemoteMessage message) {
    final data = message.data;
    final entityType = data['entity_type'] as String?;
    final entityId = data['entity_id'] as String?;
    if (entityType == null || entityId == null) return;

    // We use a global navigator key to navigate from outside the widget tree
    final ctx = _navigatorKey.currentContext;
    if (ctx == null) return;

    switch (entityType) {
      case 'task':
        ctx.push('/tasks/$entityId');
        break;
      case 'channel':
        ctx.push('/chat/$entityId');
        break;
      case 'document':
        ctx.push('/documents/$entityId');
        break;
      default:
        ctx.push('/notifications');
    }
  }

  // Global navigator key — set on MaterialApp.router
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
}

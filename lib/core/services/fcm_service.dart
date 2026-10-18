import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as timezone_data;
import 'package:timezone/timezone.dart' as timezone;

import '../platform/platform_info.dart';
import '../router/app_router.dart';
import '../../features/notifications/data/notifications_repository.dart';
import '../../features/notifications/providers/notification_preferences.dart';

class FcmService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static StreamSubscription<String>? _tokenSubscription;
  static StreamSubscription<RemoteMessage>? _messageSubscription;
  static StreamSubscription<RemoteMessage>? _openSubscription;
  static bool _localNotificationsInitialized = false;
  static bool _timezoneInitialized = false;
  static GoRouter? _router;

  static Future<void> initialize(WidgetRef ref) async {
    _router = ref.read(routerProvider);
    try {
      await _initializeLocalNotifications();
      await ref.read(notificationPreferencesProvider.notifier).ensureLoaded();
      if (!PlatformInfo.isAndroid) return;

      if (Firebase.apps.isEmpty) await Firebase.initializeApp();
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(alert: true, badge: true, sound: true);
      if (ref.read(notificationPreferencesProvider).push) {
        // The backend stores FCM registration tokens, not installation IDs.
        // ignore: deprecated_member_use
        final token = await messaging.getToken();
        if (token != null) await _registerToken(ref, token);
      }

      await _tokenSubscription?.cancel();
      // ignore: deprecated_member_use
      _tokenSubscription = messaging.onTokenRefresh.listen(
        (newToken) {
          if (ref.read(notificationPreferencesProvider).push) {
            unawaited(_registerToken(ref, newToken));
          }
        },
        onError: (Object error, StackTrace stackTrace) =>
            _report(error, stackTrace, 'FCM token refresh'),
      );

      await _messageSubscription?.cancel();
      _messageSubscription = FirebaseMessaging.onMessage.listen((message) {
        if (ref.read(notificationPreferencesProvider).push &&
            ref
                .read(notificationPreferencesProvider)
                .allowsType(message.data['type'] as String?)) {
          unawaited(_showMessage(message));
        }
      });

      await _openSubscription?.cancel();
      _openSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
        (message) => _openMessage(ref, message),
      );

      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) _openMessage(ref, initialMessage);
    } catch (error, stackTrace) {
      _report(error, stackTrace, 'notification initialization');
    }
  }

  static Future<void> unregister(WidgetRef ref) async {
    await _tokenSubscription?.cancel();
    _tokenSubscription = null;
    await _messageSubscription?.cancel();
    _messageSubscription = null;
    await _openSubscription?.cancel();
    _openSubscription = null;

    if (!PlatformInfo.isAndroid || Firebase.apps.isEmpty) return;
    // ignore: deprecated_member_use
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;
    final failure = await ref
        .read(notificationsRepositoryProvider)
        .unregisterDevice(token);
    if (failure != null) {
      _report(
        StateError(failure.message),
        StackTrace.current,
        'FCM device unregister',
      );
    }
  }

  static Future<void> setPushEnabled(WidgetRef ref, bool enabled) async {
    if (!PlatformInfo.isAndroid) return;
    if (enabled) {
      await initialize(ref);
    } else {
      await unregister(ref);
    }
  }

  static Future<void> showRealtimeNotification(
    Map<String, dynamic> notification,
  ) async {
    await _initializeLocalNotifications();
    await _show(
      notification['id']?.toString() ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      notification['title']?.toString() ?? '',
      notification['body']?.toString() ?? '',
      {
        'entityType': notification['entity_type'],
        'entityId': notification['entity_id'],
        'workspaceId': notification['workspace_id'],
        'type': notification['type'],
      },
    );
  }

  static Future<void> syncTaskReminder({
    required String taskId,
    required String title,
    required DateTime? dueAt,
    required int? minutesBefore,
  }) async {
    await _initializeLocalNotifications();
    if (!_timezoneInitialized) {
      timezone_data.initializeTimeZones();
      final localTimezone = await FlutterTimezone.getLocalTimezone();
      timezone.setLocalLocation(timezone.getLocation(localTimezone.identifier));
      _timezoneInitialized = true;
    }

    final id = _taskReminderId(taskId);
    final reminderAt = dueAt?.subtract(Duration(minutes: minutesBefore ?? 0));
    if (reminderAt == null ||
        minutesBefore == null ||
        reminderAt.isBefore(DateTime.now())) {
      await _localNotifications.cancel(id: id);
      return;
    }

    await _localNotifications.zonedSchedule(
      id: id,
      title: title,
      body: title,
      scheduledDate: timezone.TZDateTime.from(reminderAt, timezone.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'planpal_task_reminders',
          'Task reminders',
          channelDescription: 'Reminders for tasks with due dates',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        windows: WindowsNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: jsonEncode({'entityType': 'task', 'entityId': taskId}),
    );
  }

  static Future<void> _initializeLocalNotifications() async {
    if (_localNotificationsInitialized) return;
    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        windows: WindowsInitializationSettings(
          appName: 'PlanPal',
          appUserModelId: 'com.planpal.planpal',
          guid: 'a6bb1a6e-5508-44d0-a291-c89b137e4c23',
        ),
      ),
      onDidReceiveNotificationResponse: (response) {
        if (response.payload == null) return;
        final data = jsonDecode(response.payload!) as Map<String, dynamic>;
        _openData(data);
      },
    );
    _localNotificationsInitialized = true;
  }

  static Future<void> _registerToken(WidgetRef ref, String token) async {
    final failure = await ref
        .read(notificationsRepositoryProvider)
        .registerDevice(token, 'android');
    if (failure != null) {
      _report(
        StateError(failure.message),
        StackTrace.current,
        'FCM device registration',
      );
    }
  }

  static Future<void> _showMessage(RemoteMessage message) async {
    final title = message.notification?.title ?? '';
    final body = message.notification?.body ?? '';
    await _show(
      message.messageId ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title,
      body,
      message.data,
    );
  }

  static Future<void> _show(
    String id,
    String title,
    String body,
    Map<String, dynamic> data,
  ) async {
    final notificationId = id.hashCode & 0x7fffffff;
    await _localNotifications.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'planpal_notifications',
          'PlanPal notifications',
          channelDescription: 'Task, chat, and workspace updates',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        windows: WindowsNotificationDetails(),
      ),
      payload: jsonEncode(data),
    );
  }

  static int _taskReminderId(String taskId) {
    var hash = 0x811c9dc5;
    for (final codeUnit in taskId.codeUnits) {
      hash = ((hash ^ codeUnit) * 0x01000193) & 0x7fffffff;
    }
    return hash;
  }

  static void _openMessage(WidgetRef ref, RemoteMessage message) {
    _openData(message.data, router: ref.read(routerProvider));
  }

  static void _openData(Map<String, dynamic> data, {GoRouter? router}) {
    final entityType = data['entityType'] ?? data['entity_type'];
    final entityId = data['entityId'] ?? data['entity_id'];
    if (entityId is! String || entityId.isEmpty) return;
    final target = switch (entityType) {
      'task' => '/tasks/$entityId',
      'channel' => '/chat/$entityId',
      'document' => '/documents/$entityId',
      'event' => '/calendar',
      _ => '/notifications',
    };
    (router ?? _router)?.go(target);
  }

  static void _report(Object error, StackTrace stackTrace, String context) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: context,
      ),
    );
  }
}

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';

/// Service for managing local push notifications
class LocalNotificationsService {
  static final LocalNotificationsService _instance = LocalNotificationsService._internal();
  factory LocalNotificationsService() => _instance;
  LocalNotificationsService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// Initialize the notifications service
  Future<void> initialize() async {
    if (_initialized) return;

    // Android initialization
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
    debugPrint('[LocalNotifications] Service initialized');
  }

  /// Request notification permissions (iOS)
  Future<bool> requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final result = await _notifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result ?? false;
    }

    // Android permissions are handled in AndroidManifest.xml
    return true;
  }

  /// Schedule a notification for a specific time
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    // Don't schedule if time is in the past
    if (scheduledTime.isBefore(DateTime.now())) {
      debugPrint('[LocalNotifications] Cannot schedule notification in the past');
      return;
    }

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );

    debugPrint('[LocalNotifications] Scheduled notification $id for $scheduledTime');
  }

  /// Cancel a scheduled notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
    debugPrint('[LocalNotifications] Cancelled notification $id');
  }

  /// Cancel all scheduled notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    debugPrint('[LocalNotifications] Cancelled all notifications');
  }

  /// Show an immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    await _notifications.show(
      id,
      title,
      body,
      _notificationDetails(),
      payload: payload,
    );

    debugPrint('[LocalNotifications] Showed notification $id');
  }

  /// Get list of pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  /// Check if a specific notification is pending
  Future<bool> isNotificationPending(int id) async {
    final pending = await getPendingNotifications();
    return pending.any((notification) => notification.id == id);
  }

  /// Notification details for all platforms
  NotificationDetails _notificationDetails() {
    return NotificationDetails(
      android: _androidNotificationDetails(),
      iOS: _iosNotificationDetails(),
    );
  }

  /// Android-specific notification details
  AndroidNotificationDetails _androidNotificationDetails() {
    return const AndroidNotificationDetails(
      'task_reminders', // channel ID
      'Task Reminders', // channel name
      channelDescription: 'Notifications for task reminders',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
      playSound: true,
      actions: [
        AndroidNotificationAction(
          'mark_done',
          'Mark Done',
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          'snooze',
          'Snooze 15min',
          showsUserInterface: false,
        ),
      ],
    );
  }

  /// iOS-specific notification details
  DarwinNotificationDetails _iosNotificationDetails() {
    return const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: 'task_reminder_category',
    );
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('[LocalNotifications] Notification tapped: ${response.payload}');

    // Handle action buttons
    switch (response.actionId) {
      case 'mark_done':
        _handleMarkDone(response.payload);
        break;
      case 'snooze':
        _handleSnooze(response.payload);
        break;
      default:
        // Default tap - navigate to task
        _handleDefaultTap(response.payload);
    }
  }

  void _handleMarkDone(String? payload) {
    debugPrint('[LocalNotifications] Mark done action: $payload');
    // TODO: Mark task as complete
    // This will be handled by the notification scheduler service
  }

  void _handleSnooze(String? payload) {
    debugPrint('[LocalNotifications] Snooze action: $payload');
    // TODO: Reschedule notification for 15 minutes later
    // This will be handled by the notification scheduler service
  }

  void _handleDefaultTap(String? payload) {
    debugPrint('[LocalNotifications] Default tap: $payload');
    // TODO: Navigate to task detail screen
    // This will be handled by the notification scheduler service
  }
}

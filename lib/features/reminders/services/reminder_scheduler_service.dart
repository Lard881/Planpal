import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../../../core/db/app_database.dart';
import '../../../core/services/local_notifications_service.dart';
import '../models/reminder_type.dart';

/// Service for scheduling and managing task reminders
class ReminderSchedulerService {
  final AppDatabase _database;
  final LocalNotificationsService _notifications;

  ReminderSchedulerService({
    required AppDatabase database,
    required LocalNotificationsService notifications,
  })  : _database = database,
        _notifications = notifications;

  /// Schedule a reminder for a task
  Future<void> scheduleTaskReminder(Task task) async {
    // Cancel any existing reminder for this task
    await cancelTaskReminder(task.id);

    // Determine reminder time
    final reminderTime = _calculateReminderTime(task);
    
    if (reminderTime == null) {
      debugPrint('[ReminderScheduler] No reminder time calculated for task ${task.id}');
      return;
    }

    // Don't schedule if reminder time is in the past
    if (reminderTime.isBefore(DateTime.now())) {
      debugPrint('[ReminderScheduler] Reminder time is in the past for task ${task.id}');
      return;
    }

    // Create notification payload
    final payload = jsonEncode({
      'taskId': task.id,
      'taskTitle': task.title,
      'action': 'open_task',
    });

    // Schedule the notification
    await _notifications.scheduleNotification(
      id: _getNotificationId(task.id),
      title: '📋 Task Reminder',
      body: task.title,
      scheduledTime: reminderTime,
      payload: payload,
    );

    debugPrint('[ReminderScheduler] Scheduled reminder for task ${task.id} at $reminderTime');
  }

  /// Cancel a task's reminder
  Future<void> cancelTaskReminder(String taskId) async {
    final notificationId = _getNotificationId(taskId);
    await _notifications.cancelNotification(notificationId);
    debugPrint('[ReminderScheduler] Cancelled reminder for task $taskId');
  }

  /// Reschedule reminders for specific tasks (called after sync)
  Future<void> rescheduleTaskReminders(List<String> taskIds) async {
    if (taskIds.isEmpty) return;
    
    debugPrint('[ReminderScheduler] Rescheduling reminders for ${taskIds.length} synced tasks');

    int rescheduledCount = 0;
    for (final taskId in taskIds) {
      try {
        // Fetch task from database
        final task = await (_database.select(_database.tasks)
              ..where((t) => t.id.equals(taskId)))
            .getSingleOrNull();

        if (task == null) {
          debugPrint('[ReminderScheduler] Task $taskId not found, skipping');
          continue;
        }

        // Reschedule if task has a reminder
        final hasReminder = task.reminderAt != null || task.reminderMinutesBefore != null;
        if (hasReminder) {
          await scheduleTaskReminder(task);
          rescheduledCount++;
        } else {
          // Cancel reminder if task no longer has one
          await cancelTaskReminder(taskId);
        }
      } catch (e) {
        debugPrint('[ReminderScheduler] Error rescheduling task $taskId: $e');
      }
    }

    debugPrint('[ReminderScheduler] Rescheduled $rescheduledCount reminders after sync');
  }

  /// Reschedule all reminders for active tasks
  Future<void> rescheduleAllReminders({String? workspaceId}) async {
    debugPrint('[ReminderScheduler] Rescheduling all reminders...');

    // Cancel all existing notifications first
    await _notifications.cancelAllNotifications();

    // Get all tasks with reminders
    final query = _database.select(_database.tasks)
      ..where((task) => 
          task.status.equals('todo') | 
          task.status.equals('in_progress') |
          task.status.equals('blocked'))
      ..where((task) => task.deletedAt.isNull());

    if (workspaceId != null) {
      query.where((task) => task.workspaceId.equals(workspaceId));
    }

    final tasks = await query.get();

    int scheduledCount = 0;
    for (final task in tasks) {
      final hasReminder = task.reminderAt != null || task.reminderMinutesBefore != null;
      if (hasReminder) {
        await scheduleTaskReminder(task);
        scheduledCount++;
      }
    }

    debugPrint('[ReminderScheduler] Rescheduled $scheduledCount reminders');
  }

  /// Update reminder when task is modified
  Future<void> onTaskUpdated(Task task) async {
    // If task is completed or deleted, cancel reminder
    if (task.status == 'completed' || task.deletedAt != null) {
      await cancelTaskReminder(task.id);
      return;
    }

    // Otherwise, reschedule the reminder
    await scheduleTaskReminder(task);
  }

  /// Handle when a task is deleted
  Future<void> onTaskDeleted(String taskId) async {
    await cancelTaskReminder(taskId);
  }

  /// Snooze a reminder for 15 minutes
  Future<void> snoozeReminder(String taskId, String taskTitle) async {
    final snoozeTime = DateTime.now().add(const Duration(minutes: 15));
    
    final payload = jsonEncode({
      'taskId': taskId,
      'taskTitle': taskTitle,
      'action': 'open_task',
    });

    await _notifications.scheduleNotification(
      id: _getNotificationId(taskId),
      title: '📋 Task Reminder (Snoozed)',
      body: taskTitle,
      scheduledTime: snoozeTime,
      payload: payload,
    );

    debugPrint('[ReminderScheduler] Snoozed reminder for task $taskId until $snoozeTime');
  }

  /// Get all pending reminders
  Future<List<Map<String, dynamic>>> getPendingReminders() async {
    final pending = await _notifications.getPendingNotifications();
    
    return pending.map((notification) {
      Map<String, dynamic>? payload;
      if (notification.payload != null) {
        try {
          payload = jsonDecode(notification.payload!);
        } catch (e) {
          debugPrint('[ReminderScheduler] Failed to parse payload: $e');
        }
      }
      
      return {
        'id': notification.id,
        'title': notification.title,
        'body': notification.body,
        'payload': payload,
      };
    }).toList();
  }

  /// Check if a task has a pending reminder
  Future<bool> hasTaskReminder(String taskId) async {
    final notificationId = _getNotificationId(taskId);
    return await _notifications.isNotificationPending(notificationId);
  }

  /// Calculate reminder time from task data
  DateTime? _calculateReminderTime(Task task) {
    // Priority 1: Absolute reminder time
    if (task.reminderAt != null) {
      return task.reminderAt;
    }

    // Priority 2: Relative reminder (minutes before due date)
    if (task.reminderMinutesBefore != null && task.dueDate != null) {
      return task.dueDate!.subtract(
        Duration(minutes: task.reminderMinutesBefore!),
      );
    }

    // No reminder set
    return null;
  }

  /// Generate a unique notification ID from task ID
  /// Uses hashCode to convert string to int
  int _getNotificationId(String taskId) {
    // Use hashCode but ensure it's positive and within int32 range
    return taskId.hashCode.abs() % 2147483647;
  }

  /// Initialize the scheduler service
  Future<void> initialize() async {
    await _notifications.initialize();
    await _notifications.requestPermissions();
    debugPrint('[ReminderScheduler] Service initialized');
  }

  /// Handle app startup - reschedule reminders
  Future<void> onAppStartup({String? workspaceId}) async {
    debugPrint('[ReminderScheduler] App startup - checking reminders');
    
    // Reschedule all reminders to ensure they're up to date
    // This handles cases where the app was killed or device rebooted
    await rescheduleAllReminders(workspaceId: workspaceId);
  }

  /// Handle timezone changes
  Future<void> onTimezoneChanged() async {
    debugPrint('[ReminderScheduler] Timezone changed - rescheduling reminders');
    await rescheduleAllReminders();
  }

  /// Get next reminder time for a task
  DateTime? getNextReminderTime(Task task) {
    return _calculateReminderTime(task);
  }

  /// Validate reminder time is valid
  bool isReminderTimeValid(Task task) {
    final reminderTime = _calculateReminderTime(task);
    if (reminderTime == null) return false;
    
    // Check if reminder time is in the future
    if (reminderTime.isBefore(DateTime.now())) return false;
    
    // For relative reminders, check if due date exists
    if (task.reminderMinutesBefore != null && task.dueDate == null) {
      return false;
    }
    
    return true;
  }
}

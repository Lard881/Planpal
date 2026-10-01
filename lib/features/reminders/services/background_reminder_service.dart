import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import '../../../core/db/app_database.dart';
import '../../../core/services/local_notifications_service.dart';
import 'reminder_scheduler_service.dart';

/// Background service for checking and scheduling reminders
class BackgroundReminderService {
  static const String _taskName = 'reminder_check_task';
  static const String _uniqueName = 'com.planpal.reminder_check';

  /// Initialize the background service
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );
    debugPrint('[BackgroundReminder] Service initialized');
  }

  /// Register periodic reminder check (every 15 minutes)
  static Future<void> registerPeriodicCheck() async {
    await Workmanager().registerPeriodicTask(
      _uniqueName,
      _taskName,
      frequency: const Duration(minutes: 15),
      initialDelay: const Duration(minutes: 1),
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );
    debugPrint('[BackgroundReminder] Registered periodic check (every 15 minutes)');
  }

  /// Register one-time reminder check (for immediate execution)
  static Future<void> registerOneTimeCheck() async {
    await Workmanager().registerOneOffTask(
      '${_uniqueName}_onetime',
      _taskName,
      initialDelay: const Duration(seconds: 10),
    );
    debugPrint('[BackgroundReminder] Registered one-time check');
  }

  /// Cancel all background tasks
  static Future<void> cancelAll() async {
    await Workmanager().cancelAll();
    debugPrint('[BackgroundReminder] Cancelled all background tasks');
  }

  /// Cancel periodic check
  static Future<void> cancelPeriodicCheck() async {
    await Workmanager().cancelByUniqueName(_uniqueName);
    debugPrint('[BackgroundReminder] Cancelled periodic check');
  }
}

/// Callback dispatcher for background tasks
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('[BackgroundReminder] Executing task: $task');

    try {
      // Initialize services
      final database = AppDatabase();
      final notifications = LocalNotificationsService();
      await notifications.initialize();

      final scheduler = ReminderSchedulerService(
        database: database,
        notifications: notifications,
      );

      // Reschedule all reminders
      // This ensures reminders are up-to-date even if the app was killed
      await scheduler.rescheduleAllReminders();

      debugPrint('[BackgroundReminder] Task completed successfully');
      return true;
    } catch (e) {
      debugPrint('[BackgroundReminder] Task failed: $e');
      return false;
    }
  });
}

/// Helper class for managing background reminder settings
class BackgroundReminderSettings {
  static const String _keyEnabled = 'background_reminders_enabled';
  
  /// Check if background reminders are enabled
  static Future<bool> isEnabled() async {
    // TODO: Implement with shared_preferences
    // For now, return true by default
    return true;
  }

  /// Enable background reminders
  static Future<void> enable() async {
    await BackgroundReminderService.registerPeriodicCheck();
    // TODO: Save preference with shared_preferences
    debugPrint('[BackgroundReminder] Enabled');
  }

  /// Disable background reminders
  static Future<void> disable() async {
    await BackgroundReminderService.cancelPeriodicCheck();
    // TODO: Save preference with shared_preferences
    debugPrint('[BackgroundReminder] Disabled');
  }
}

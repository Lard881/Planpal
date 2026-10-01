import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_settings.dart';
import '../services/notification_settings_service.dart';

/// Provider for SharedPreferences instance
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// Provider for NotificationSettingsService
final notificationSettingsServiceProvider = Provider<NotificationSettingsService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).value;
  if (prefs == null) {
    throw Exception('SharedPreferences not initialized');
  }
  return NotificationSettingsService(prefs);
});

/// State notifier for notification settings
class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  final NotificationSettingsService _service;

  NotificationSettingsNotifier(this._service) : super(const NotificationSettings()) {
    _loadSettings();
  }

  /// Load settings from storage
  void _loadSettings() {
    final settings = _service.loadSettings();
    state = settings;
  }

  /// Update settings and persist
  Future<void> updateSettings(NotificationSettings settings) async {
    state = settings;
    await _service.saveSettings(settings);
  }

  /// Toggle push notifications
  Future<void> togglePushEnabled() async {
    await updateSettings(state.copyWith(pushEnabled: !state.pushEnabled));
  }

  /// Toggle sound
  Future<void> toggleSound() async {
    await updateSettings(state.copyWith(soundEnabled: !state.soundEnabled));
  }

  /// Toggle vibration
  Future<void> toggleVibration() async {
    await updateSettings(state.copyWith(vibrationEnabled: !state.vibrationEnabled));
  }

  /// Toggle quiet hours
  Future<void> toggleQuietHours() async {
    await updateSettings(state.copyWith(quietHoursEnabled: !state.quietHoursEnabled));
  }

  /// Set quiet hours times
  Future<void> setQuietHours(int start, int end) async {
    await updateSettings(state.copyWith(
      quietHoursStart: start,
      quietHoursEnd: end,
    ));
  }

  /// Toggle specific notification type
  Future<void> toggleNotificationType(String type, bool enabled) async {
    NotificationSettings newSettings = state;

    switch (type) {
      case 'task_assigned':
        newSettings = state.copyWith(taskAssignedEnabled: enabled);
        break;
      case 'task_completed':
        newSettings = state.copyWith(taskCompletedEnabled: enabled);
        break;
      case 'task_overdue':
        newSettings = state.copyWith(taskOverdueEnabled: enabled);
        break;
      case 'task_due_soon':
        newSettings = state.copyWith(taskDueSoonEnabled: enabled);
        break;
      case 'task_commented':
        newSettings = state.copyWith(taskCommentedEnabled: enabled);
        break;
      case 'task_status_changed':
        newSettings = state.copyWith(taskStatusChangedEnabled: enabled);
        break;
      case 'project_invite':
        newSettings = state.copyWith(projectInviteEnabled: enabled);
        break;
      case 'project_updated':
        newSettings = state.copyWith(projectUpdatedEnabled: enabled);
        break;
      case 'project_deadline':
        newSettings = state.copyWith(projectDeadlineEnabled: enabled);
        break;
      case 'event_reminder':
        newSettings = state.copyWith(eventReminderEnabled: enabled);
        break;
      case 'event_starting_soon':
        newSettings = state.copyWith(eventStartingSoonEnabled: enabled);
        break;
      case 'event_updated':
        newSettings = state.copyWith(eventUpdatedEnabled: enabled);
        break;
      case 'event_cancelled':
        newSettings = state.copyWith(eventCancelledEnabled: enabled);
        break;
      case 'chat_message':
        newSettings = state.copyWith(chatMessageEnabled: enabled);
        break;
      case 'chat_mention':
        newSettings = state.copyWith(chatMentionEnabled: enabled);
        break;
      case 'workspace_invite':
        newSettings = state.copyWith(workspaceInviteEnabled: enabled);
        break;
      case 'workspace_role_changed':
        newSettings = state.copyWith(workspaceRoleChangedEnabled: enabled);
        break;
      case 'system':
        newSettings = state.copyWith(systemEnabled: enabled);
        break;
    }

    await updateSettings(newSettings);
  }

  /// Enable all notification types
  Future<void> enableAllTypes() async {
    await updateSettings(state.copyWith(
      taskAssignedEnabled: true,
      taskCompletedEnabled: true,
      taskOverdueEnabled: true,
      taskDueSoonEnabled: true,
      taskCommentedEnabled: true,
      taskStatusChangedEnabled: true,
      projectInviteEnabled: true,
      projectUpdatedEnabled: true,
      projectDeadlineEnabled: true,
      eventReminderEnabled: true,
      eventStartingSoonEnabled: true,
      eventUpdatedEnabled: true,
      eventCancelledEnabled: true,
      chatMessageEnabled: true,
      chatMentionEnabled: true,
      workspaceInviteEnabled: true,
      workspaceRoleChangedEnabled: true,
      systemEnabled: true,
    ));
  }

  /// Disable all notification types
  Future<void> disableAllTypes() async {
    await updateSettings(state.copyWith(
      taskAssignedEnabled: false,
      taskCompletedEnabled: false,
      taskOverdueEnabled: false,
      taskDueSoonEnabled: false,
      taskCommentedEnabled: false,
      taskStatusChangedEnabled: false,
      projectInviteEnabled: false,
      projectUpdatedEnabled: false,
      projectDeadlineEnabled: false,
      eventReminderEnabled: false,
      eventStartingSoonEnabled: false,
      eventUpdatedEnabled: false,
      eventCancelledEnabled: false,
      chatMessageEnabled: false,
      chatMentionEnabled: false,
      workspaceInviteEnabled: false,
      workspaceRoleChangedEnabled: false,
      systemEnabled: false,
    ));
  }

  /// Reset to defaults
  Future<void> resetToDefaults() async {
    await _service.clearSettings();
    _loadSettings();
  }
}

/// Provider for notification settings state
final notificationSettingsProvider =
    StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>((ref) {
  final service = ref.watch(notificationSettingsServiceProvider);
  return NotificationSettingsNotifier(service);
});

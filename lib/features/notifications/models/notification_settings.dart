import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_settings.freezed.dart';
part 'notification_settings.g.dart';

/// Notification preferences for a user
@freezed
class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    // Push notification settings
    @Default(true) bool pushEnabled,
    @Default(true) bool soundEnabled,
    @Default(true) bool vibrationEnabled,
    
    // Task notifications
    @Default(true) bool taskAssignedEnabled,
    @Default(true) bool taskCompletedEnabled,
    @Default(true) bool taskOverdueEnabled,
    @Default(true) bool taskDueSoonEnabled,
    @Default(true) bool taskCommentedEnabled,
    @Default(true) bool taskStatusChangedEnabled,
    
    // Project notifications
    @Default(true) bool projectInviteEnabled,
    @Default(true) bool projectUpdatedEnabled,
    @Default(true) bool projectDeadlineEnabled,
    
    // Event notifications
    @Default(true) bool eventReminderEnabled,
    @Default(true) bool eventStartingSoonEnabled,
    @Default(true) bool eventUpdatedEnabled,
    @Default(true) bool eventCancelledEnabled,
    
    // Chat notifications
    @Default(true) bool chatMessageEnabled,
    @Default(true) bool chatMentionEnabled,
    
    // Workspace notifications
    @Default(true) bool workspaceInviteEnabled,
    @Default(true) bool workspaceRoleChangedEnabled,
    
    // System notifications
    @Default(true) bool systemEnabled,
    
    // Quiet hours
    @Default(false) bool quietHoursEnabled,
    @Default(22) int quietHoursStart, // 10 PM
    @Default(7) int quietHoursEnd, // 7 AM
  }) = _NotificationSettings;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);
}

/// Extension to check if a notification type is enabled
extension NotificationSettingsExtension on NotificationSettings {
  /// Check if notifications are enabled for a specific type
  bool isTypeEnabled(String type) {
    switch (type) {
      case 'task_assigned':
        return taskAssignedEnabled;
      case 'task_completed':
        return taskCompletedEnabled;
      case 'task_overdue':
        return taskOverdueEnabled;
      case 'task_due_soon':
        return taskDueSoonEnabled;
      case 'task_commented':
        return taskCommentedEnabled;
      case 'task_status_changed':
        return taskStatusChangedEnabled;
      case 'project_invite':
        return projectInviteEnabled;
      case 'project_updated':
        return projectUpdatedEnabled;
      case 'project_deadline':
        return projectDeadlineEnabled;
      case 'event_reminder':
        return eventReminderEnabled;
      case 'event_starting_soon':
        return eventStartingSoonEnabled;
      case 'event_updated':
        return eventUpdatedEnabled;
      case 'event_cancelled':
        return eventCancelledEnabled;
      case 'chat_message':
        return chatMessageEnabled;
      case 'chat_mention':
        return chatMentionEnabled;
      case 'workspace_invite':
        return workspaceInviteEnabled;
      case 'workspace_role_changed':
        return workspaceRoleChangedEnabled;
      case 'system':
        return systemEnabled;
      default:
        return true; // Default to enabled for unknown types
    }
  }

  /// Check if currently in quiet hours
  bool get isInQuietHours {
    if (!quietHoursEnabled) return false;

    final now = DateTime.now();
    final currentHour = now.hour;

    // Handle overnight quiet hours (e.g., 22:00 to 7:00)
    if (quietHoursStart > quietHoursEnd) {
      return currentHour >= quietHoursStart || currentHour < quietHoursEnd;
    }

    // Handle same-day quiet hours (e.g., 12:00 to 14:00)
    return currentHour >= quietHoursStart && currentHour < quietHoursEnd;
  }

  /// Check if notification should be shown (respects all settings)
  bool shouldShowNotification(String type) {
    // Check if push notifications are enabled globally
    if (!pushEnabled) return false;

    // Check if in quiet hours
    if (isInQuietHours) return false;

    // Check if this specific type is enabled
    return isTypeEnabled(type);
  }

  /// Get count of enabled notification types
  int get enabledTypesCount {
    int count = 0;
    if (taskAssignedEnabled) count++;
    if (taskCompletedEnabled) count++;
    if (taskOverdueEnabled) count++;
    if (taskDueSoonEnabled) count++;
    if (taskCommentedEnabled) count++;
    if (taskStatusChangedEnabled) count++;
    if (projectInviteEnabled) count++;
    if (projectUpdatedEnabled) count++;
    if (projectDeadlineEnabled) count++;
    if (eventReminderEnabled) count++;
    if (eventStartingSoonEnabled) count++;
    if (eventUpdatedEnabled) count++;
    if (eventCancelledEnabled) count++;
    if (chatMessageEnabled) count++;
    if (chatMentionEnabled) count++;
    if (workspaceInviteEnabled) count++;
    if (workspaceRoleChangedEnabled) count++;
    if (systemEnabled) count++;
    return count;
  }

  /// Check if all notification types are enabled
  bool get allTypesEnabled => enabledTypesCount == 18;

  /// Check if no notification types are enabled
  bool get noTypesEnabled => enabledTypesCount == 0;
}

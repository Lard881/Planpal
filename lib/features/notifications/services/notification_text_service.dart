import 'package:flutter/material.dart';
// Temporarily disabled until flutter_gen is generated
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/notification.dart';

/// Service for generating localized notification text
/// Converts notification type and entity data into user-friendly messages
/// TEMPORARY STUB - Replace with localized version once flutter_gen is generated
class NotificationTextService {
  /// Generate notification title based on type and entity
  static String generateTitle(
    BuildContext context,
    NotificationType type, {
    String? entityName,
    String? actorName,
  }) {
    switch (type) {
      case NotificationType.taskAssigned:
        return 'Task Assigned';
      case NotificationType.taskCompleted:
        return 'Task Completed';
      case NotificationType.taskOverdue:
        return 'Task Overdue';
      case NotificationType.taskDueSoon:
        return 'Task Due Soon';
      case NotificationType.taskCommented:
        return 'New Comment';
      case NotificationType.taskStatusChanged:
        return 'Task Status Changed';
      case NotificationType.projectInvite:
        return 'Project Invite';
      case NotificationType.projectUpdated:
        return 'Project Updated';
      case NotificationType.projectDeadline:
        return 'Project Deadline';
      case NotificationType.eventReminder:
        return 'Event Reminder';
      case NotificationType.eventStartingSoon:
        return 'Event Starting Soon';
      case NotificationType.eventUpdated:
        return 'Event Updated';
      case NotificationType.eventCancelled:
        return 'Event Cancelled';
      case NotificationType.chatMessage:
        return 'New Message';
      case NotificationType.chatMention:
        return 'You were mentioned';
      case NotificationType.workspaceInvite:
        return 'Workspace Invite';
      case NotificationType.workspaceRoleChanged:
        return 'Role Changed';
      case NotificationType.system:
        return 'System Notification';
      default:
        return 'Notification';
    }
  }

  /// Generate notification body text
  static String generateBody(
    BuildContext context,
    NotificationType type, {
    String? entityName,
    String? actorName,
    String? workspaceName,
    String? additionalInfo,
    DateTime? dueDate,
    DateTime? eventTime,
  }) {
    switch (type) {
      case NotificationType.taskAssigned:
        return actorName != null && entityName != null
            ? '$actorName assigned you "$entityName"'
            : 'You have been assigned a new task';
      case NotificationType.taskCompleted:
        return actorName != null && entityName != null
            ? '$actorName completed "$entityName"'
            : 'A task was completed';
      case NotificationType.taskOverdue:
        return entityName != null
            ? '"$entityName" is overdue'
            : 'You have an overdue task';
      case NotificationType.taskDueSoon:
        return entityName != null
            ? '"$entityName" is due soon'
            : 'You have a task due soon';
      case NotificationType.taskCommented:
        return actorName != null && entityName != null
            ? '$actorName commented on "$entityName"'
            : 'New comment on a task';
      case NotificationType.taskStatusChanged:
        return entityName != null && additionalInfo != null
            ? '"$entityName" status changed to $additionalInfo'
            : 'Task status was changed';
      case NotificationType.projectInvite:
        return actorName != null && entityName != null
            ? '$actorName invited you to "$entityName"'
            : 'You have been invited to a project';
      case NotificationType.projectUpdated:
        return entityName != null
            ? '"$entityName" has been updated'
            : 'Project was updated';
      case NotificationType.projectDeadline:
        return entityName != null
            ? '"$entityName" deadline approaching'
            : 'Project deadline approaching';
      case NotificationType.eventReminder:
        return entityName != null
            ? 'Reminder: $entityName'
            : 'Event reminder';
      case NotificationType.eventStartingSoon:
        return entityName != null
            ? '"$entityName" is starting soon'
            : 'Event starting soon';
      case NotificationType.eventUpdated:
        return entityName != null
            ? '"$entityName" has been updated'
            : 'Event was updated';
      case NotificationType.eventCancelled:
        return entityName != null
            ? '"$entityName" has been cancelled'
            : 'Event was cancelled';
      case NotificationType.chatMessage:
        return actorName != null
            ? 'Message from $actorName'
            : 'You have a new message';
      case NotificationType.chatMention:
        return actorName != null
            ? '$actorName mentioned you'
            : 'You were mentioned in a message';
      case NotificationType.workspaceInvite:
        return actorName != null && workspaceName != null
            ? '$actorName invited you to $workspaceName'
            : 'You have been invited to a workspace';
      case NotificationType.workspaceRoleChanged:
        return workspaceName != null && additionalInfo != null
            ? 'Your role in $workspaceName changed to $additionalInfo'
            : 'Your workspace role has changed';
      case NotificationType.system:
        return additionalInfo ?? 'System notification';
      default:
        return 'You have a new notification';
    }
  }

  /// Get icon for notification type
  static IconData getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.taskAssigned:
        return Icons.assignment_turned_in_outlined;
      case NotificationType.taskCompleted:
        return Icons.check_circle_outline;
      case NotificationType.taskOverdue:
        return Icons.warning_amber_outlined;
      case NotificationType.taskDueSoon:
        return Icons.schedule_outlined;
      case NotificationType.taskCommented:
        return Icons.comment_outlined;
      case NotificationType.taskStatusChanged:
        return Icons.update_outlined;
      case NotificationType.projectInvite:
        return Icons.group_add_outlined;
      case NotificationType.projectUpdated:
        return Icons.edit_note_outlined;
      case NotificationType.projectDeadline:
        return Icons.event_busy_outlined;
      case NotificationType.eventReminder:
        return Icons.event_note_outlined;
      case NotificationType.eventStartingSoon:
        return Icons.access_time_outlined;
      case NotificationType.eventUpdated:
        return Icons.event_available_outlined;
      case NotificationType.eventCancelled:
        return Icons.event_busy_outlined;
      case NotificationType.chatMessage:
        return Icons.message_outlined;
      case NotificationType.chatMention:
        return Icons.alternate_email_outlined;
      case NotificationType.workspaceInvite:
        return Icons.business_outlined;
      case NotificationType.workspaceRoleChanged:
        return Icons.admin_panel_settings_outlined;
      case NotificationType.system:
        return Icons.info_outline;
      default:
        return Icons.notifications_outlined;
    }
  }

  /// Get color for notification type
  static Color getColor(BuildContext context, NotificationType type) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (type) {
      case NotificationType.taskOverdue:
      case NotificationType.eventCancelled:
        return colorScheme.error;
      case NotificationType.taskDueSoon:
      case NotificationType.eventStartingSoon:
      case NotificationType.projectDeadline:
        return Colors.orange;
      case NotificationType.taskCompleted:
        return Colors.green;
      case NotificationType.taskAssigned:
      case NotificationType.projectInvite:
      case NotificationType.workspaceInvite:
        return colorScheme.primary;
      case NotificationType.chatMention:
        return Colors.blue;
      default:
        return colorScheme.onSurface;
    }
  }

  /// Get priority level for notification type
  static NotificationPriority getPriority(NotificationType type) {
    switch (type) {
      case NotificationType.taskOverdue:
      case NotificationType.eventCancelled:
      case NotificationType.eventStartingSoon:
        return NotificationPriority.high;
      case NotificationType.taskDueSoon:
      case NotificationType.projectDeadline:
      case NotificationType.eventReminder:
      case NotificationType.chatMention:
        return NotificationPriority.medium;
      default:
        return NotificationPriority.low;
    }
  }
}

/// Notification priority levels
enum NotificationPriority {
  low,
  medium,
  high,
}

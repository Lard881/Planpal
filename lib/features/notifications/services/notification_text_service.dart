import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/notification.dart';

/// Service for generating localized notification text
/// Converts notification type and entity data into user-friendly messages
class NotificationTextService {
  /// Generate notification title based on type and entity
  static String generateTitle(
    BuildContext context,
    NotificationType type, {
    String? entityName,
    String? actorName,
  }) {
    final l10n = AppLocalizations.of(context)!;

    switch (type) {
      // Task notifications
      case NotificationType.taskAssigned:
        return l10n.notificationTitleTaskAssigned;
      case NotificationType.taskCompleted:
        return l10n.notificationTitleTaskCompleted;
      case NotificationType.taskOverdue:
        return l10n.notificationTitleTaskOverdue;
      case NotificationType.taskDueSoon:
        return l10n.notificationTitleTaskDueSoon;
      case NotificationType.taskCommented:
        return l10n.notificationTitleTaskCommented;
      case NotificationType.taskStatusChanged:
        return l10n.notificationTitleTaskStatusChanged;

      // Project notifications
      case NotificationType.projectInvite:
        return l10n.notificationTitleProjectInvite;
      case NotificationType.projectUpdated:
        return l10n.notificationTitleProjectUpdated;
      case NotificationType.projectDeadline:
        return l10n.notificationTitleProjectDeadline;

      // Event notifications
      case NotificationType.eventReminder:
        return l10n.notificationTitleEventReminder;
      case NotificationType.eventStartingSoon:
        return l10n.notificationTitleEventStartingSoon;
      case NotificationType.eventUpdated:
        return l10n.notificationTitleEventUpdated;
      case NotificationType.eventCancelled:
        return l10n.notificationTitleEventCancelled;

      // Chat notifications
      case NotificationType.chatMessage:
        return l10n.notificationTitleChatMessage;
      case NotificationType.chatMention:
        return l10n.notificationTitleChatMention;

      // Workspace notifications
      case NotificationType.workspaceInvite:
        return l10n.notificationTitleWorkspaceInvite;
      case NotificationType.workspaceRoleChanged:
        return l10n.notificationTitleWorkspaceRoleChanged;

      // System notifications
      case NotificationType.system:
        return l10n.notificationTitleSystem;

      default:
        return l10n.notificationTitleDefault;
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
    final l10n = AppLocalizations.of(context)!;

    switch (type) {
      // Task notifications
      case NotificationType.taskAssigned:
        if (actorName != null && entityName != null) {
          return l10n.notificationBodyTaskAssigned(actorName, entityName);
        }
        return l10n.notificationBodyTaskAssignedGeneric;

      case NotificationType.taskCompleted:
        if (actorName != null && entityName != null) {
          return l10n.notificationBodyTaskCompleted(actorName, entityName);
        }
        return l10n.notificationBodyTaskCompletedGeneric;

      case NotificationType.taskOverdue:
        if (entityName != null) {
          return l10n.notificationBodyTaskOverdue(entityName);
        }
        return l10n.notificationBodyTaskOverdueGeneric;

      case NotificationType.taskDueSoon:
        if (entityName != null && dueDate != null) {
          final timeRemaining = _formatTimeRemaining(context, dueDate);
          return l10n.notificationBodyTaskDueSoon(entityName, timeRemaining);
        }
        return l10n.notificationBodyTaskDueSoonGeneric;

      case NotificationType.taskCommented:
        if (actorName != null && entityName != null) {
          return l10n.notificationBodyTaskCommented(actorName, entityName);
        }
        return l10n.notificationBodyTaskCommentedGeneric;

      case NotificationType.taskStatusChanged:
        if (entityName != null && additionalInfo != null) {
          return l10n.notificationBodyTaskStatusChanged(entityName, additionalInfo);
        }
        return l10n.notificationBodyTaskStatusChangedGeneric;

      // Project notifications
      case NotificationType.projectInvite:
        if (actorName != null && entityName != null) {
          return l10n.notificationBodyProjectInvite(actorName, entityName);
        }
        return l10n.notificationBodyProjectInviteGeneric;

      case NotificationType.projectUpdated:
        if (entityName != null) {
          return l10n.notificationBodyProjectUpdated(entityName);
        }
        return l10n.notificationBodyProjectUpdatedGeneric;

      case NotificationType.projectDeadline:
        if (entityName != null && dueDate != null) {
          final timeRemaining = _formatTimeRemaining(context, dueDate);
          return l10n.notificationBodyProjectDeadline(entityName, timeRemaining);
        }
        return l10n.notificationBodyProjectDeadlineGeneric;

      // Event notifications
      case NotificationType.eventReminder:
        if (entityName != null && eventTime != null) {
          final timeUntil = _formatTimeRemaining(context, eventTime);
          return l10n.notificationBodyEventReminder(entityName, timeUntil);
        }
        return l10n.notificationBodyEventReminderGeneric;

      case NotificationType.eventStartingSoon:
        if (entityName != null && eventTime != null) {
          final timeUntil = _formatTimeRemaining(context, eventTime);
          return l10n.notificationBodyEventStartingSoon(entityName, timeUntil);
        }
        return l10n.notificationBodyEventStartingSoonGeneric;

      case NotificationType.eventUpdated:
        if (entityName != null) {
          return l10n.notificationBodyEventUpdated(entityName);
        }
        return l10n.notificationBodyEventUpdatedGeneric;

      case NotificationType.eventCancelled:
        if (entityName != null) {
          return l10n.notificationBodyEventCancelled(entityName);
        }
        return l10n.notificationBodyEventCancelledGeneric;

      // Chat notifications
      case NotificationType.chatMessage:
        if (actorName != null) {
          return l10n.notificationBodyChatMessage(actorName);
        }
        return l10n.notificationBodyChatMessageGeneric;

      case NotificationType.chatMention:
        if (actorName != null) {
          return l10n.notificationBodyChatMention(actorName);
        }
        return l10n.notificationBodyChatMentionGeneric;

      // Workspace notifications
      case NotificationType.workspaceInvite:
        if (actorName != null && workspaceName != null) {
          return l10n.notificationBodyWorkspaceInvite(actorName, workspaceName);
        }
        return l10n.notificationBodyWorkspaceInviteGeneric;

      case NotificationType.workspaceRoleChanged:
        if (workspaceName != null && additionalInfo != null) {
          return l10n.notificationBodyWorkspaceRoleChanged(workspaceName, additionalInfo);
        }
        return l10n.notificationBodyWorkspaceRoleChangedGeneric;

      // System notifications
      case NotificationType.system:
        return additionalInfo ?? l10n.notificationBodySystemGeneric;

      default:
        return l10n.notificationBodyDefault;
    }
  }

  /// Format time remaining in human-readable format
  static String _formatTimeRemaining(BuildContext context, DateTime target) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = target.difference(now);

    if (difference.isNegative) {
      // Overdue
      final absDifference = difference.abs();
      if (absDifference.inDays > 0) {
        return l10n.timeOverdueDays(absDifference.inDays);
      } else if (absDifference.inHours > 0) {
        return l10n.timeOverdueHours(absDifference.inHours);
      } else {
        return l10n.timeOverdueMinutes(absDifference.inMinutes);
      }
    } else {
      // Future
      if (difference.inDays > 0) {
        return l10n.timeRemainingDays(difference.inDays);
      } else if (difference.inHours > 0) {
        return l10n.timeRemainingHours(difference.inHours);
      } else {
        return l10n.timeRemainingMinutes(difference.inMinutes);
      }
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

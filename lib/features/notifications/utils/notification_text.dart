import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:planpal/core/db/app_database.dart';

/// Generate localized notification text
class NotificationText {
  final AppLocalizations l10n;

  NotificationText(this.l10n);

  /// Get localized title for notification type
  String getTitle(Notification notification) {
    switch (notification.type) {
      case 'task_assigned':
        return l10n.notificationTaskAssigned;
      case 'task_updated':
        return l10n.notificationTaskUpdated;
      case 'task_comment':
        return l10n.notificationTaskComment;
      case 'deadline_approaching':
        return l10n.notificationDeadlineApproaching;
      case 'task_overdue':
        return l10n.notificationTaskOverdue;
      case 'mention':
        return l10n.notificationMention;
      case 'chat_message':
        return l10n.notificationChatMessage;
      case 'event_reminder':
        return l10n.notificationEventReminder;
      case 'workspace_invite':
        return l10n.notificationWorkspaceInvite;
      default:
        return notification.title;
    }
  }

  /// Get localized body for notification
  String getBody(Notification notification) {
    // If notification has custom body, use it
    if (notification.body.isNotEmpty) {
      return notification.body;
    }

    // Generate default body based on type
    switch (notification.type) {
      case 'task_assigned':
        return l10n.notificationTaskAssignedBody;
      case 'task_updated':
        return l10n.notificationTaskUpdatedBody;
      case 'task_comment':
        return l10n.notificationTaskCommentBody;
      case 'deadline_approaching':
        return l10n.notificationDeadlineApproachingBody;
      case 'task_overdue':
        return l10n.notificationTaskOverdueBody;
      case 'mention':
        return l10n.notificationMentionBody;
      case 'chat_message':
        return l10n.notificationChatMessageBody;
      case 'event_reminder':
        return l10n.notificationEventReminderBody;
      default:
        return '';
    }
  }

  /// Get icon for notification type
  IconData getIcon(String type) {
    switch (type) {
      case 'task_assigned':
        return Icons.assignment;
      case 'task_updated':
        return Icons.update;
      case 'task_comment':
        return Icons.comment;
      case 'deadline_approaching':
        return Icons.warning_amber;
      case 'task_overdue':
        return Icons.error;
      case 'mention':
        return Icons.alternate_email;
      case 'chat_message':
        return Icons.message;
      case 'event_reminder':
        return Icons.event;
      default:
        return Icons.notifications;
    }
  }

  /// Get color for notification type
  Color getColor(String type) {
    switch (type) {
      case 'task_assigned':
        return Colors.blue;
      case 'task_updated':
        return Colors.green;
      case 'task_comment':
        return Colors.purple;
      case 'deadline_approaching':
        return Colors.orange;
      case 'task_overdue':
        return Colors.red;
      case 'mention':
        return Colors.indigo;
      case 'chat_message':
        return Colors.teal;
      case 'event_reminder':
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }
}

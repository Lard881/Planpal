// app/lib/features/notifications/models/notification_model.dart
import 'package:flutter/material.dart';
import '../../../core/l10n/app_localizations.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String? workspaceId;
  final String type; // task_assigned|task_updated|task_comment|mention|deadline_approaching|task_overdue|event_reminder|chat_message|member_joined|system
  final String title;
  final String body;
  final String? entityType;
  final String? entityId;
  final DateTime? readAt;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    this.workspaceId,
    required this.type,
    required this.title,
    this.body = '',
    this.entityType,
    this.entityId,
    this.readAt,
    required this.createdAt,
  });

  bool get isUnread => readAt == null;

  String localizedTitle(AppLocalizations l10n) => switch (type) {
    'task_assigned' => l10n.notificationTaskAssigned,
    'task_updated' => l10n.notificationTaskUpdated,
    'task_comment' => l10n.notificationTaskComment,
    'mention' => l10n.notificationMention,
    'deadline_approaching' => l10n.notificationDeadline,
    'task_overdue' => l10n.notificationOverdue,
    'event_reminder' => l10n.notificationEventReminder,
    'chat_message' => l10n.notificationChatMessage,
    'member_joined' => l10n.notificationMemberJoined,
    _ => title,
  };

  String relativeTime(AppLocalizations l10n) {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return l10n.notificationJustNow;
    if (diff.inMinutes < 60) return l10n.notificationMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.notificationHoursAgo(diff.inHours);
    if (diff.inDays == 1) return l10n.yesterday;
    return l10n.notificationDaysAgo(diff.inDays);
  }

  IconData get icon {
    switch (type) {
      case 'task_assigned': return Icons.person_add_outlined;
      case 'mention': return Icons.alternate_email;
      case 'task_comment': return Icons.chat_bubble_outline;
      case 'deadline_approaching':
      case 'task_overdue': return Icons.alarm;
      case 'event_reminder': return Icons.event_outlined;
      case 'chat_message': return Icons.message_outlined;
      case 'member_joined': return Icons.group_outlined;
      default: return Icons.info_outline;
    }
  }

  Color iconBg(dynamic c) {
    switch (type) {
      case 'task_assigned': return c.primarySoft;
      case 'mention': return c.violetSoft;
      case 'task_comment': return c.skySoft;
      case 'deadline_approaching':
      case 'task_overdue': return c.dangerSoft;
      case 'event_reminder': return c.warningSoft;
      case 'chat_message': return c.successSoft;
      default: return c.surfaceAlt;
    }
  }

  Color iconFg(dynamic c) {
    switch (type) {
      case 'task_assigned': return c.primary;
      case 'mention': return c.violet;
      case 'task_comment': return c.sky;
      case 'deadline_approaching':
      case 'task_overdue': return c.danger;
      case 'event_reminder': return c.warningText;
      case 'chat_message': return c.success;
      default: return c.textMuted;
    }
  }

  factory NotificationModel.fromJson(Map<String, dynamic> j) =>
      NotificationModel(
        id: j['id'] as String,
        userId: j['user_id'] as String,
        workspaceId: j['workspace_id'] as String?,
        type: j['type'] as String? ?? 'system',
        title: j['title'] as String? ?? '',
        body: j['body'] as String? ?? '',
        entityType: j['entity_type'] as String?,
        entityId: j['entity_id'] as String?,
        readAt: j['read_at'] != null
            ? DateTime.parse(j['read_at'] as String) : null,
        createdAt: DateTime.parse(j['created_at'] as String),
      );
}

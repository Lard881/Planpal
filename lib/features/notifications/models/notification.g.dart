// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    AppNotification(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      workspaceId: json['workspace_id'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      title: json['title'] as String,
      body: json['body'] as String,
      entityType: json['entity_type'] as String?,
      entityId: json['entity_id'] as String?,
      dedupeKey: json['dedupe_key'] as String?,
      readAt: json['read_at'] == null
          ? null
          : DateTime.parse(json['read_at'] as String),
      pushedAt: json['pushed_at'] == null
          ? null
          : DateTime.parse(json['pushed_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$AppNotificationToJson(AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'workspace_id': instance.workspaceId,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'title': instance.title,
      'body': instance.body,
      'entity_type': instance.entityType,
      'entity_id': instance.entityId,
      'dedupe_key': instance.dedupeKey,
      'read_at': instance.readAt?.toIso8601String(),
      'pushed_at': instance.pushedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$NotificationTypeEnumMap = {
  NotificationType.taskAssigned: 'task_assigned',
  NotificationType.taskUpdated: 'task_updated',
  NotificationType.taskComment: 'task_comment',
  NotificationType.mention: 'mention',
  NotificationType.deadlineApproaching: 'deadline_approaching',
  NotificationType.taskOverdue: 'task_overdue',
  NotificationType.eventReminder: 'event_reminder',
  NotificationType.chatMessage: 'chat_message',
  NotificationType.memberJoined: 'member_joined',
  NotificationType.system: 'system',
};

NotificationCounts _$NotificationCountsFromJson(Map<String, dynamic> json) =>
    NotificationCounts(
      total: (json['total'] as num).toInt(),
      unread: (json['unread'] as num).toInt(),
      read: (json['read'] as num).toInt(),
      byType: Map<String, int>.from(json['by_type'] as Map),
      unreadByType: Map<String, int>.from(json['unread_by_type'] as Map),
    );

Map<String, dynamic> _$NotificationCountsToJson(NotificationCounts instance) =>
    <String, dynamic>{
      'total': instance.total,
      'unread': instance.unread,
      'read': instance.read,
      'by_type': instance.byType,
      'unread_by_type': instance.unreadByType,
    };

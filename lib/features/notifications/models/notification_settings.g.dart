// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationSettingsImpl _$$NotificationSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationSettingsImpl(
      pushEnabled: json['pushEnabled'] as bool? ?? true,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      taskAssignedEnabled: json['taskAssignedEnabled'] as bool? ?? true,
      taskCompletedEnabled: json['taskCompletedEnabled'] as bool? ?? true,
      taskOverdueEnabled: json['taskOverdueEnabled'] as bool? ?? true,
      taskDueSoonEnabled: json['taskDueSoonEnabled'] as bool? ?? true,
      taskCommentedEnabled: json['taskCommentedEnabled'] as bool? ?? true,
      taskStatusChangedEnabled:
          json['taskStatusChangedEnabled'] as bool? ?? true,
      projectInviteEnabled: json['projectInviteEnabled'] as bool? ?? true,
      projectUpdatedEnabled: json['projectUpdatedEnabled'] as bool? ?? true,
      projectDeadlineEnabled: json['projectDeadlineEnabled'] as bool? ?? true,
      eventReminderEnabled: json['eventReminderEnabled'] as bool? ?? true,
      eventStartingSoonEnabled:
          json['eventStartingSoonEnabled'] as bool? ?? true,
      eventUpdatedEnabled: json['eventUpdatedEnabled'] as bool? ?? true,
      eventCancelledEnabled: json['eventCancelledEnabled'] as bool? ?? true,
      chatMessageEnabled: json['chatMessageEnabled'] as bool? ?? true,
      chatMentionEnabled: json['chatMentionEnabled'] as bool? ?? true,
      workspaceInviteEnabled: json['workspaceInviteEnabled'] as bool? ?? true,
      workspaceRoleChangedEnabled:
          json['workspaceRoleChangedEnabled'] as bool? ?? true,
      systemEnabled: json['systemEnabled'] as bool? ?? true,
      quietHoursEnabled: json['quietHoursEnabled'] as bool? ?? false,
      quietHoursStart: (json['quietHoursStart'] as num?)?.toInt() ?? 22,
      quietHoursEnd: (json['quietHoursEnd'] as num?)?.toInt() ?? 7,
    );

Map<String, dynamic> _$$NotificationSettingsImplToJson(
        _$NotificationSettingsImpl instance) =>
    <String, dynamic>{
      'pushEnabled': instance.pushEnabled,
      'soundEnabled': instance.soundEnabled,
      'vibrationEnabled': instance.vibrationEnabled,
      'taskAssignedEnabled': instance.taskAssignedEnabled,
      'taskCompletedEnabled': instance.taskCompletedEnabled,
      'taskOverdueEnabled': instance.taskOverdueEnabled,
      'taskDueSoonEnabled': instance.taskDueSoonEnabled,
      'taskCommentedEnabled': instance.taskCommentedEnabled,
      'taskStatusChangedEnabled': instance.taskStatusChangedEnabled,
      'projectInviteEnabled': instance.projectInviteEnabled,
      'projectUpdatedEnabled': instance.projectUpdatedEnabled,
      'projectDeadlineEnabled': instance.projectDeadlineEnabled,
      'eventReminderEnabled': instance.eventReminderEnabled,
      'eventStartingSoonEnabled': instance.eventStartingSoonEnabled,
      'eventUpdatedEnabled': instance.eventUpdatedEnabled,
      'eventCancelledEnabled': instance.eventCancelledEnabled,
      'chatMessageEnabled': instance.chatMessageEnabled,
      'chatMentionEnabled': instance.chatMentionEnabled,
      'workspaceInviteEnabled': instance.workspaceInviteEnabled,
      'workspaceRoleChangedEnabled': instance.workspaceRoleChangedEnabled,
      'systemEnabled': instance.systemEnabled,
      'quietHoursEnabled': instance.quietHoursEnabled,
      'quietHoursStart': instance.quietHoursStart,
      'quietHoursEnd': instance.quietHoursEnd,
    };

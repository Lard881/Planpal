// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnalyticsEventImpl _$$AnalyticsEventImplFromJson(Map<String, dynamic> json) =>
    _$AnalyticsEventImpl(
      id: json['id'] as String?,
      userId: json['userId'] as String,
      workspaceId: json['workspaceId'] as String?,
      eventType: $enumDecode(_$AnalyticsEventTypeEnumMap, json['eventType']),
      eventData: json['eventData'] as Map<String, dynamic>? ?? const {},
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$AnalyticsEventImplToJson(
        _$AnalyticsEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'workspaceId': instance.workspaceId,
      'eventType': _$AnalyticsEventTypeEnumMap[instance.eventType]!,
      'eventData': instance.eventData,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$AnalyticsEventTypeEnumMap = {
  AnalyticsEventType.taskCreated: 'task_created',
  AnalyticsEventType.taskCompleted: 'task_completed',
  AnalyticsEventType.taskUpdated: 'task_updated',
  AnalyticsEventType.taskDeleted: 'task_deleted',
  AnalyticsEventType.searchPerformed: 'search_performed',
  AnalyticsEventType.attachmentUploaded: 'attachment_uploaded',
  AnalyticsEventType.commentAdded: 'comment_added',
  AnalyticsEventType.labelApplied: 'label_applied',
  AnalyticsEventType.projectCreated: 'project_created',
  AnalyticsEventType.workspaceJoined: 'workspace_joined',
  AnalyticsEventType.reminderSet: 'reminder_set',
  AnalyticsEventType.filterApplied: 'filter_applied',
  AnalyticsEventType.exportPerformed: 'export_performed',
  AnalyticsEventType.notificationClicked: 'notification_clicked',
  AnalyticsEventType.pageViewed: 'page_viewed',
};

_$AnalyticsEventBatchImpl _$$AnalyticsEventBatchImplFromJson(
        Map<String, dynamic> json) =>
    _$AnalyticsEventBatchImpl(
      eventType: $enumDecode(_$AnalyticsEventTypeEnumMap, json['eventType']),
      workspaceId: json['workspaceId'] as String?,
      eventData: json['eventData'] as Map<String, dynamic>? ?? const {},
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$AnalyticsEventBatchImplToJson(
        _$AnalyticsEventBatchImpl instance) =>
    <String, dynamic>{
      'eventType': _$AnalyticsEventTypeEnumMap[instance.eventType]!,
      'workspaceId': instance.workspaceId,
      'eventData': instance.eventData,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

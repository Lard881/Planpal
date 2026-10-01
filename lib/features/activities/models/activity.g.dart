// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityImpl _$$ActivityImplFromJson(Map<String, dynamic> json) =>
    _$ActivityImpl(
      id: json['id'] as String,
      entityType: $enumDecode(_$ActivityEntityTypeEnumMap, json['entityType']),
      entityId: json['entityId'] as String,
      action: $enumDecode(_$ActivityActionEnumMap, json['action']),
      workspaceId: json['workspaceId'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      changes: json['changes'] as Map<String, dynamic>? ?? const {},
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      user: json['user'] == null
          ? null
          : ActivityUser.fromJson(json['user'] as Map<String, dynamic>),
      task: json['task'] == null
          ? null
          : ActivityTask.fromJson(json['task'] as Map<String, dynamic>),
      project: json['project'] == null
          ? null
          : ActivityProject.fromJson(json['project'] as Map<String, dynamic>),
      workspace: json['workspace'] == null
          ? null
          : ActivityWorkspace.fromJson(
              json['workspace'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ActivityImplToJson(_$ActivityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityType': _$ActivityEntityTypeEnumMap[instance.entityType]!,
      'entityId': instance.entityId,
      'action': _$ActivityActionEnumMap[instance.action]!,
      'workspaceId': instance.workspaceId,
      'userId': instance.userId,
      'createdAt': instance.createdAt.toIso8601String(),
      'changes': instance.changes,
      'metadata': instance.metadata,
      'user': instance.user,
      'task': instance.task,
      'project': instance.project,
      'workspace': instance.workspace,
    };

const _$ActivityEntityTypeEnumMap = {
  ActivityEntityType.task: 'task',
  ActivityEntityType.project: 'project',
  ActivityEntityType.workspace: 'workspace',
  ActivityEntityType.comment: 'comment',
};

const _$ActivityActionEnumMap = {
  ActivityAction.created: 'created',
  ActivityAction.updated: 'updated',
  ActivityAction.deleted: 'deleted',
  ActivityAction.completed: 'completed',
  ActivityAction.reopened: 'reopened',
  ActivityAction.assigned: 'assigned',
  ActivityAction.unassigned: 'unassigned',
  ActivityAction.statusChanged: 'status_changed',
  ActivityAction.priorityChanged: 'priority_changed',
  ActivityAction.dueDateChanged: 'due_date_changed',
  ActivityAction.moved: 'moved',
  ActivityAction.commented: 'commented',
  ActivityAction.mentioned: 'mentioned',
};

_$ActivityUserImpl _$$ActivityUserImplFromJson(Map<String, dynamic> json) =>
    _$ActivityUserImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$$ActivityUserImplToJson(_$ActivityUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'email': instance.email,
    };

_$ActivityTaskImpl _$$ActivityTaskImplFromJson(Map<String, dynamic> json) =>
    _$ActivityTaskImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$$ActivityTaskImplToJson(_$ActivityTaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'status': instance.status,
    };

_$ActivityProjectImpl _$$ActivityProjectImplFromJson(
        Map<String, dynamic> json) =>
    _$ActivityProjectImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      color: json['color'] as String?,
    );

Map<String, dynamic> _$$ActivityProjectImplToJson(
        _$ActivityProjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
    };

_$ActivityWorkspaceImpl _$$ActivityWorkspaceImplFromJson(
        Map<String, dynamic> json) =>
    _$ActivityWorkspaceImpl(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$ActivityWorkspaceImplToJson(
        _$ActivityWorkspaceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

_$CreateActivityRequestImpl _$$CreateActivityRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateActivityRequestImpl(
      id: json['id'] as String?,
      entityType: $enumDecode(_$ActivityEntityTypeEnumMap, json['entityType']),
      entityId: json['entityId'] as String,
      action: $enumDecode(_$ActivityActionEnumMap, json['action']),
      workspaceId: json['workspaceId'] as String,
      changes: json['changes'] as Map<String, dynamic>? ?? const {},
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$CreateActivityRequestImplToJson(
        _$CreateActivityRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityType': _$ActivityEntityTypeEnumMap[instance.entityType]!,
      'entityId': instance.entityId,
      'action': _$ActivityActionEnumMap[instance.action]!,
      'workspaceId': instance.workspaceId,
      'changes': instance.changes,
      'metadata': instance.metadata,
    };

_$ActivitiesResponseImpl _$$ActivitiesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ActivitiesResponseImpl(
      activities: (json['activities'] as List<dynamic>)
          .map((e) => Activity.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
      pagination: json['pagination'] == null
          ? null
          : ActivitiesPagination.fromJson(
              json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ActivitiesResponseImplToJson(
        _$ActivitiesResponseImpl instance) =>
    <String, dynamic>{
      'activities': instance.activities,
      'total': instance.total,
      'pagination': instance.pagination,
    };

_$ActivitiesPaginationImpl _$$ActivitiesPaginationImplFromJson(
        Map<String, dynamic> json) =>
    _$ActivitiesPaginationImpl(
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );

Map<String, dynamic> _$$ActivitiesPaginationImplToJson(
        _$ActivitiesPaginationImpl instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'total': instance.total,
      'totalPages': instance.totalPages,
    };

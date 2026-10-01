// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
      id: json['id'] as String,
      workspaceId: json['workspaceId'] as String,
      projectId: json['projectId'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'todo',
      priority: json['priority'] as String?,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      assigneeId: json['assigneeId'] as String?,
      parentTaskId: json['parentTaskId'] as String?,
      position: (json['position'] as num?)?.toInt(),
      labelIds: (json['labelIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      project: json['project'] == null
          ? null
          : TaskProject.fromJson(json['project'] as Map<String, dynamic>),
      assignee: json['assignee'] == null
          ? null
          : TaskAssignee.fromJson(json['assignee'] as Map<String, dynamic>),
      labels: (json['labels'] as List<dynamic>?)
              ?.map((e) => TaskLabel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      subtasks: (json['subtasks'] as List<dynamic>?)
              ?.map((e) => Task.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workspaceId': instance.workspaceId,
      'projectId': instance.projectId,
      'title': instance.title,
      'description': instance.description,
      'status': instance.status,
      'priority': instance.priority,
      'dueDate': instance.dueDate?.toIso8601String(),
      'assigneeId': instance.assigneeId,
      'parentTaskId': instance.parentTaskId,
      'position': instance.position,
      'labelIds': instance.labelIds,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };

_$TaskProjectImpl _$$TaskProjectImplFromJson(Map<String, dynamic> json) =>
    _$TaskProjectImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      color: json['color'] as String?,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$$TaskProjectImplToJson(_$TaskProjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
      'icon': instance.icon,
    };

_$TaskAssigneeImpl _$$TaskAssigneeImplFromJson(Map<String, dynamic> json) =>
    _$TaskAssigneeImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$$TaskAssigneeImplToJson(_$TaskAssigneeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
    };

_$TaskLabelImpl _$$TaskLabelImplFromJson(Map<String, dynamic> json) =>
    _$TaskLabelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      color: json['color'] as String,
    );

Map<String, dynamic> _$$TaskLabelImplToJson(_$TaskLabelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
    };

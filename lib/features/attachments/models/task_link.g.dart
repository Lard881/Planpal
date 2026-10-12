// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskLinkImpl _$$TaskLinkImplFromJson(Map<String, dynamic> json) =>
    _$TaskLinkImpl(
      id: json['id'] as String,
      taskId: json['taskId'] as String,
      workspaceId: json['workspaceId'] as String,
      addedBy: json['addedBy'] as String,
      url: json['url'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      faviconUrl: json['faviconUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

Map<String, dynamic> _$$TaskLinkImplToJson(_$TaskLinkImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'workspaceId': instance.workspaceId,
      'addedBy': instance.addedBy,
      'url': instance.url,
      'title': instance.title,
      'description': instance.description,
      'faviconUrl': instance.faviconUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };

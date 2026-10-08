// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchResultImpl _$$SearchResultImplFromJson(Map<String, dynamic> json) =>
    _$SearchResultImpl(
      entityId: json['entity_id'] as String,
      entityType: json['entity_type'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      workspaceId: json['workspace_id'] as String?,
      workspaceName: json['workspace_name'] as String?,
      matchRank: (json['match_rank'] as num?)?.toDouble(),
      avatarUrl: json['avatar_url'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$SearchResultImplToJson(_$SearchResultImpl instance) =>
    <String, dynamic>{
      'entity_id': instance.entityId,
      'entity_type': instance.entityType,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'workspace_id': instance.workspaceId,
      'workspace_name': instance.workspaceName,
      'match_rank': instance.matchRank,
      'avatar_url': instance.avatarUrl,
      'metadata': instance.metadata,
    };

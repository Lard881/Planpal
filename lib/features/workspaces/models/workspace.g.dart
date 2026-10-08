// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkspaceImpl _$$WorkspaceImplFromJson(Map<String, dynamic> json) =>
    _$WorkspaceImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecodeNullable(_$WorkspaceTypeEnumMap, json['type']) ??
          WorkspaceType.team,
      createdBy: json['created_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      role: $enumDecodeNullable(_$WorkspaceRoleEnumMap, json['role']),
    );

Map<String, dynamic> _$$WorkspaceImplToJson(_$WorkspaceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$WorkspaceTypeEnumMap[instance.type]!,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'role': _$WorkspaceRoleEnumMap[instance.role],
    };

const _$WorkspaceTypeEnumMap = {
  WorkspaceType.personal: 'personal',
  WorkspaceType.team: 'team',
};

const _$WorkspaceRoleEnumMap = {
  WorkspaceRole.admin: 'admin',
  WorkspaceRole.member: 'member',
  WorkspaceRole.guest: 'guest',
};

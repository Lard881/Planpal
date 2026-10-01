// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkspaceImpl _$$WorkspaceImplFromJson(Map<String, dynamic> json) =>
    _$WorkspaceImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      isPersonal: json['isPersonal'] as bool? ?? false,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      role: json['role'] as String?,
      memberCount: (json['memberCount'] as num?)?.toInt(),
      membershipId: json['membershipId'] as String?,
    );

Map<String, dynamic> _$$WorkspaceImplToJson(_$WorkspaceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'isPersonal': instance.isPersonal,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$WorkspaceMemberImpl _$$WorkspaceMemberImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkspaceMemberImpl(
      id: json['id'] as String,
      workspaceId: json['workspaceId'] as String,
      userId: json['userId'] as String,
      role: json['role'] as String,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      user: json['user'] == null
          ? null
          : WorkspaceMemberUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$WorkspaceMemberImplToJson(
        _$WorkspaceMemberImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workspaceId': instance.workspaceId,
      'userId': instance.userId,
      'role': instance.role,
      'joinedAt': instance.joinedAt.toIso8601String(),
    };

_$WorkspaceMemberUserImpl _$$WorkspaceMemberUserImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkspaceMemberUserImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$$WorkspaceMemberUserImplToJson(
        _$WorkspaceMemberUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'avatarUrl': instance.avatarUrl,
    };

_$InviteCodeImpl _$$InviteCodeImplFromJson(Map<String, dynamic> json) =>
    _$InviteCodeImpl(
      id: json['id'] as String,
      workspaceId: json['workspaceId'] as String,
      code: json['code'] as String,
      uses: (json['uses'] as num?)?.toInt() ?? 0,
      maxUses: (json['maxUses'] as num?)?.toInt(),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      revokedAt: json['revokedAt'] == null
          ? null
          : DateTime.parse(json['revokedAt'] as String),
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      createdByUser: json['createdByUser'] == null
          ? null
          : InviteCodeCreator.fromJson(
              json['createdByUser'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$InviteCodeImplToJson(_$InviteCodeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workspaceId': instance.workspaceId,
      'code': instance.code,
      'uses': instance.uses,
      'maxUses': instance.maxUses,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'revokedAt': instance.revokedAt?.toIso8601String(),
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$InviteCodeCreatorImpl _$$InviteCodeCreatorImplFromJson(
        Map<String, dynamic> json) =>
    _$InviteCodeCreatorImpl(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$InviteCodeCreatorImplToJson(
        _$InviteCodeCreatorImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

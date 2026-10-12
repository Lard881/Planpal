// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkspaceMember _$WorkspaceMemberFromJson(Map<String, dynamic> json) =>
    WorkspaceMember(
      id: json['id'] as String,
      workspaceId: json['workspaceId'] as String,
      userId: json['userId'] as String,
      userEmail: json['userEmail'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String?,
      role: json['role'] as String,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
    );

Map<String, dynamic> _$WorkspaceMemberToJson(WorkspaceMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workspaceId': instance.workspaceId,
      'userId': instance.userId,
      'userEmail': instance.userEmail,
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
      'role': instance.role,
      'joinedAt': instance.joinedAt.toIso8601String(),
    };

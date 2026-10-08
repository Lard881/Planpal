import 'package:json_annotation/json_annotation.dart';

part 'workspace_member.g.dart';

@JsonSerializable()
class WorkspaceMember {
  final String id;
  final String workspaceId;
  final String userId;
  final String userEmail;
  final String userName;
  final String? userAvatar;
  final String role;
  final DateTime joinedAt;

  const WorkspaceMember({
    required this.id,
    required this.workspaceId,
    required this.userId,
    required this.userEmail,
    required this.userName,
    this.userAvatar,
    required this.role,
    required this.joinedAt,
  });

  factory WorkspaceMember.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceMemberFromJson(json);

  Map<String, dynamic> toJson() => _$WorkspaceMemberToJson(this);
}

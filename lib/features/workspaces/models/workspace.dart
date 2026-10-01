import 'package:freezed_annotation/freezed_annotation.dart';

part 'workspace.freezed.dart';
part 'workspace.g.dart';

@freezed
class Workspace with _$Workspace {
  const factory Workspace({
    required String id,
    required String name,
    String? description,
    @Default(false) bool isPersonal,
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    // Related data
    @JsonKey(includeFromJson: true, includeToJson: false) String? role,
    @JsonKey(includeFromJson: true, includeToJson: false) int? memberCount,
    @JsonKey(includeFromJson: true, includeToJson: false) String? membershipId,
  }) = _Workspace;

  factory Workspace.fromJson(Map<String, dynamic> json) => _$WorkspaceFromJson(json);
}

/// Workspace member
@freezed
class WorkspaceMember with _$WorkspaceMember {
  const factory WorkspaceMember({
    required String id,
    required String workspaceId,
    required String userId,
    required String role,
    required DateTime joinedAt,
    // User info
    @JsonKey(includeFromJson: true, includeToJson: false) WorkspaceMemberUser? user,
  }) = _WorkspaceMember;

  factory WorkspaceMember.fromJson(Map<String, dynamic> json) => _$WorkspaceMemberFromJson(json);
}

@freezed
class WorkspaceMemberUser with _$WorkspaceMemberUser {
  const factory WorkspaceMemberUser({
    required String id,
    required String name,
    String? email,
    String? avatarUrl,
  }) = _WorkspaceMemberUser;

  factory WorkspaceMemberUser.fromJson(Map<String, dynamic> json) => _$WorkspaceMemberUserFromJson(json);
}

/// Invite code
@freezed
class InviteCode with _$InviteCode {
  const factory InviteCode({
    required String id,
    required String workspaceId,
    required String code,
    @Default(0) int uses,
    int? maxUses,
    DateTime? expiresAt,
    DateTime? revokedAt,
    required String createdBy,
    required DateTime createdAt,
    // Creator info
    @JsonKey(includeFromJson: true, includeToJson: false) InviteCodeCreator? createdByUser,
  }) = _InviteCode;

  factory InviteCode.fromJson(Map<String, dynamic> json) => _$InviteCodeFromJson(json);
}

@freezed
class InviteCodeCreator with _$InviteCodeCreator {
  const factory InviteCodeCreator({
    required String id,
    required String name,
  }) = _InviteCodeCreator;

  factory InviteCodeCreator.fromJson(Map<String, dynamic> json) => _$InviteCodeCreatorFromJson(json);
}

/// Workspace role enum
enum WorkspaceRole {
  admin('admin'),
  member('member'),
  guest('guest');

  const WorkspaceRole(this.value);
  final String value;

  static WorkspaceRole fromString(String value) {
    return WorkspaceRole.values.firstWhere(
      (e) => e.value == value,
      orElse: () => WorkspaceRole.member,
    );
  }
}

/// Extension for workspace helpers
extension WorkspaceExtension on Workspace {
  bool get isAdmin => role == 'admin';
  bool get isMember => role == 'member' || role == 'admin';
  bool get isGuest => role == 'guest';
  
  WorkspaceRole get roleEnum => WorkspaceRole.fromString(role ?? 'guest');
}

/// Extension for invite code helpers
extension InviteCodeExtension on InviteCode {
  bool get isRevoked => revokedAt != null;
  bool get isExpired => expiresAt != null && expiresAt!.isBefore(DateTime.now());
  bool get isMaxedOut => maxUses != null && uses >= maxUses!;
  bool get isValid => !isRevoked && !isExpired && !isMaxedOut;
  
  String get statusText {
    if (isRevoked) return 'Revoked';
    if (isExpired) return 'Expired';
    if (isMaxedOut) return 'Max uses reached';
    return 'Active';
  }
}

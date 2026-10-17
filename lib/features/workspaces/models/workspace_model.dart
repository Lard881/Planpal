// app/lib/features/workspaces/models/workspace_model.dart
class WorkspaceModel {
  final String id;
  final String name;
  final String type; // 'personal' | 'team'
  final String? createdBy;
  final String? role; // caller's role
  final int? memberCount;
  final DateTime? createdAt;

  const WorkspaceModel({
    required this.id,
    required this.name,
    required this.type,
    this.createdBy,
    this.role,
    this.memberCount,
    this.createdAt,
  });

  bool get isPersonal => type == 'personal';
  bool get isAdmin => role == 'admin';
  bool get isMember => role == 'member';
  bool get isGuest => role == 'guest';

  String get initial => name.isNotEmpty ? name[0].toUpperCase() : '?';

  factory WorkspaceModel.fromJson(Map<String, dynamic> j) => WorkspaceModel(
    id: j['id'] as String,
    name: j['name'] as String,
    type: j['type'] as String? ?? 'team',
    createdBy: (j['createdBy'] ?? j['created_by']) as String?,
    role: j['role'] as String?,
    memberCount: j['memberCount'] as int?,
    createdAt: (j['createdAt'] ?? j['created_at']) is String
        ? DateTime.parse((j['createdAt'] ?? j['created_at']) as String)
        : null,
  );
}

class MemberModel {
  final String userId;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final String role;
  final DateTime? joinedAt;

  const MemberModel({
    required this.userId,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    required this.role,
    this.joinedAt,
  });

  factory MemberModel.fromJson(Map<String, dynamic> j) {
    final profile = j['profile'] as Map<String, dynamic>? ?? j;
    return MemberModel(
      userId: (j['userId'] ?? j['user_id'] ?? j['id']) as String,
      fullName:
          (j['fullName'] ?? profile['full_name'] ?? profile['fullName'])
              as String? ??
          '',
      email: (j['email'] ?? profile['email']) as String? ?? '',
      avatarUrl:
          (j['avatarUrl'] ?? profile['avatar_url'] ?? profile['avatarUrl'])
              as String?,
      role: j['role'] as String? ?? 'member',
      joinedAt: (j['joinedAt'] ?? j['joined_at']) is String
          ? DateTime.parse((j['joinedAt'] ?? j['joined_at']) as String)
          : null,
    );
  }
}

class InviteCodeModel {
  final String id;
  final String code;
  final String role;
  final int? maxUses;
  final int useCount;
  final DateTime? expiresAt;
  final DateTime? revokedAt;

  const InviteCodeModel({
    required this.id,
    required this.code,
    required this.role,
    this.maxUses,
    required this.useCount,
    this.expiresAt,
    this.revokedAt,
  });

  bool get isRevoked => revokedAt != null;
  bool get isExpired =>
      !isRevoked && expiresAt != null && expiresAt!.isBefore(DateTime.now());
  bool get isActive => !isRevoked && !isExpired;

  factory InviteCodeModel.fromJson(Map<String, dynamic> j) => InviteCodeModel(
    id: j['id'] as String,
    code: j['code'] as String,
    role: j['role'] as String? ?? 'member',
    maxUses: j['max_uses'] as int?,
    useCount: j['use_count'] as int? ?? 0,
    expiresAt: j['expires_at'] != null
        ? DateTime.parse(j['expires_at'] as String)
        : null,
    revokedAt: j['revoked_at'] != null
        ? DateTime.parse(j['revoked_at'] as String)
        : null,
  );
}

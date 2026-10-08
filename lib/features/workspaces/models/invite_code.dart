/// Simple InviteCode model (non-freezed to avoid conflicts)
class InviteCode {
  final String id;
  final String code;
  final String workspaceId;
  final String createdBy;
  final int? maxUses;
  final int currentUses;
  final DateTime? expiresAt;
  final DateTime createdAt;

  InviteCode({
    required this.id,
    required this.code,
    required this.workspaceId,
    required this.createdBy,
    this.maxUses,
    this.currentUses = 0,
    this.expiresAt,
    required this.createdAt,
  });

  factory InviteCode.fromJson(Map<String, dynamic> json) {
    return InviteCode(
      id: json['id'] as String,
      code: json['code'] as String,
      workspaceId: json['workspace_id'] as String,
      createdBy: json['created_by'] as String,
      maxUses: json['max_uses'] as int?,
      currentUses: json['current_uses'] as int? ?? 0,
      expiresAt: json['expires_at'] != null 
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'workspace_id': workspaceId,
      'created_by': createdBy,
      if (maxUses != null) 'max_uses': maxUses,
      'current_uses': currentUses,
      if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

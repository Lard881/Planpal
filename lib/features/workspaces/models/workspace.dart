import 'package:freezed_annotation/freezed_annotation.dart';

part 'workspace.freezed.dart';
part 'workspace.g.dart';

/// Workspace type enum
enum WorkspaceType {
  @JsonValue('personal')
  personal,
  @JsonValue('team')
  team,
}

/// Workspace role enum
enum WorkspaceRole {
  @JsonValue('admin')
  admin,
  @JsonValue('member')
  member,
  @JsonValue('guest')
  guest;
}

/// Workspace model (matches backend API schema)
@freezed
class Workspace with _$Workspace {
  const factory Workspace({
    required String id,
    required String name,
    @Default(WorkspaceType.team) WorkspaceType type,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    // User's role in this workspace (comes from workspace_members join)
    WorkspaceRole? role,
  }) = _Workspace;

  factory Workspace.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceFromJson(json);
}

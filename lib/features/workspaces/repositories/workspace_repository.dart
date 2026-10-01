import 'package:drift/drift.dart';
import '../../../core/db/app_database.dart';
import '../../../core/network/api_client.dart';
import '../models/workspace.dart';

class WorkspaceRepository {
  final AppDatabase _db;
  final ApiClient _api;

  WorkspaceRepository({
    required AppDatabase database,
    required ApiClient apiClient,
  })  : _db = database,
        _api = apiClient;

  // ========================================================================
  // Local database operations
  // ========================================================================

  /// Watch all workspaces for current user
  Stream<List<WorkspaceData>> watchWorkspaces() {
    return (_db.select(_db.workspaces)
          ..orderBy([(w) => OrderingTerm.asc(w.createdAt)]))
        .watch();
  }

  /// Get a single workspace
  Future<WorkspaceData?> getWorkspace(String id) {
    return (_db.select(_db.workspaces)
          ..where((w) => w.id.equals(id)))
        .getSingleOrNull();
  }

  /// Watch a single workspace
  Stream<WorkspaceData?> watchWorkspace(String id) {
    return (_db.select(_db.workspaces)
          ..where((w) => w.id.equals(id)))
        .watchSingleOrNull();
  }

  // ========================================================================
  // API operations
  // ========================================================================

  /// Fetch workspaces from API
  Future<List<Workspace>> fetchWorkspaces() async {
    final response = await _api.get('/workspaces');
    final workspaces = (response.data['workspaces'] as List)
        .map((json) => Workspace.fromJson(json as Map<String, dynamic>))
        .toList();

    // Store in local database
    for (final workspace in workspaces) {
      await _db.into(_db.workspaces).insertOnConflictUpdate(
            WorkspacesCompanion(
              id: Value(workspace.id),
              name: Value(workspace.name),
              description: Value(workspace.description),
              isPersonal: Value(workspace.isPersonal),
              createdBy: Value(workspace.createdBy),
              createdAt: Value(workspace.createdAt),
              updatedAt: Value(workspace.updatedAt),
            ),
          );
    }

    return workspaces;
  }

  /// Create new workspace
  Future<Workspace> createWorkspace({
    required String name,
    String? description,
  }) async {
    final response = await _api.post('/workspaces', body: {
      'name': name,
      if (description != null) 'description': description,
    });

    final workspace = Workspace.fromJson(response.data['workspace'] as Map<String, dynamic>);

    // Store locally
    await _db.into(_db.workspaces).insertOnConflictUpdate(
          WorkspacesCompanion(
            id: Value(workspace.id),
            name: Value(workspace.name),
            description: Value(workspace.description),
            isPersonal: Value(workspace.isPersonal),
            createdBy: Value(workspace.createdBy),
            createdAt: Value(workspace.createdAt),
            updatedAt: Value(workspace.updatedAt),
          ),
        );

    return workspace;
  }

  /// Update workspace
  Future<Workspace> updateWorkspace(
    String workspaceId, {
    String? name,
    String? description,
  }) async {
    final response = await _api.patch('/workspaces/$workspaceId', body: {
      if (name != null) 'name': name,
      if (description != null) 'description': description,
    });

    final workspace = Workspace.fromJson(response.data['workspace'] as Map<String, dynamic>);

    // Update locally
    await (_db.update(_db.workspaces)..where((w) => w.id.equals(workspaceId))).write(
      WorkspacesCompanion(
        name: Value(workspace.name),
        description: Value(workspace.description),
        updatedAt: Value(workspace.updatedAt),
      ),
    );

    return workspace;
  }

  /// Delete workspace
  Future<void> deleteWorkspace(String workspaceId) async {
    await _api.delete('/workspaces/$workspaceId');

    // Remove locally
    await (_db.delete(_db.workspaces)..where((w) => w.id.equals(workspaceId))).go();
  }

  /// Join workspace with invite code
  Future<Workspace> joinWorkspace(String code) async {
    final response = await _api.post('/workspaces/join', body: {
      'code': code,
    });

    final workspace = Workspace.fromJson(response.data['workspace'] as Map<String, dynamic>);

    // Store locally
    await _db.into(_db.workspaces).insertOnConflictUpdate(
          WorkspacesCompanion(
            id: Value(workspace.id),
            name: Value(workspace.name),
            description: Value(workspace.description),
            isPersonal: Value(workspace.isPersonal),
            createdBy: Value(workspace.createdBy),
            createdAt: Value(workspace.createdAt),
            updatedAt: Value(workspace.updatedAt),
          ),
        );

    return workspace;
  }

  /// Leave workspace
  Future<void> leaveWorkspace(String workspaceId) async {
    await _api.post('/workspaces/$workspaceId/leave');

    // Remove locally
    await (_db.delete(_db.workspaces)..where((w) => w.id.equals(workspaceId))).go();
  }

  // ========================================================================
  // Members
  // ========================================================================

  /// Fetch workspace members
  Future<List<WorkspaceMember>> fetchMembers(String workspaceId) async {
    final response = await _api.get('/workspaces/$workspaceId/members');
    return (response.data['members'] as List)
        .map((json) => WorkspaceMember.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Change member role
  Future<WorkspaceMember> changeMemberRole({
    required String workspaceId,
    required String memberId,
    required String role,
  }) async {
    final response = await _api.patch(
      '/workspaces/$workspaceId/members/$memberId/role',
      body: {'role': role},
    );

    return WorkspaceMember.fromJson(response.data['member'] as Map<String, dynamic>);
  }

  /// Remove member
  Future<void> removeMember({
    required String workspaceId,
    required String memberId,
  }) async {
    await _api.delete('/workspaces/$workspaceId/members/$memberId');
  }

  // ========================================================================
  // Invite codes
  // ========================================================================

  /// Fetch invite codes
  Future<List<InviteCode>> fetchInviteCodes(String workspaceId) async {
    final response = await _api.get('/invites', queryParams: {
      'workspace_id': workspaceId,
    });

    return (response.data['invites'] as List)
        .map((json) => InviteCode.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Create invite code
  Future<InviteCode> createInviteCode({
    required String workspaceId,
    int? maxUses,
    DateTime? expiresAt,
  }) async {
    final response = await _api.post('/invites', body: {
      'workspace_id': workspaceId,
      if (maxUses != null) 'max_uses': maxUses,
      if (expiresAt != null) 'expires_at': expiresAt.toIso8601String(),
    });

    return InviteCode.fromJson(response.data['invite'] as Map<String, dynamic>);
  }

  /// Revoke invite code
  Future<void> revokeInviteCode(String inviteId) async {
    await _api.delete('/invites/$inviteId');
  }
}

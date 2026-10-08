import 'package:drift/drift.dart';
import '../../../core/db/app_database.dart';
import '../../../core/network/api_client.dart';
import '../models/workspace.dart' as models;
import '../models/workspace_member.dart' as api_models;
import '../models/invite_code.dart';

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
  Stream<List<Workspace>> watchWorkspaces() {
    return (_db.select(_db.workspaces)
          ..orderBy([(w) => OrderingTerm.asc(w.createdAt)]))
        .watch();
  }

  /// Get all workspaces (async)
  Future<List<Workspace>> getWorkspaces() {
    return (_db.select(_db.workspaces)
          ..orderBy([(w) => OrderingTerm.asc(w.createdAt)]))
        .get();
  }

  /// Get a single workspace
  Future<Workspace?> getWorkspace(String id) {
    return (_db.select(_db.workspaces)
          ..where((w) => w.id.equals(id)))
        .getSingleOrNull();
  }

  /// Watch a single workspace
  Stream<Workspace?> watchWorkspace(String id) {
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
    final workspaces = <Workspace>[];

    // Parse JSON and convert to Drift Workspaces
    for (final json in (response.data['workspaces'] as List)) {
      final data = json as Map<String, dynamic>;
      
      // Store in local database
      await _db.into(_db.workspaces).insertOnConflictUpdate(
            WorkspacesCompanion(
              id: Value(data['id'] as String),
              name: Value(data['name'] as String),
              type: Value((data['is_personal'] as bool? ?? false) ? 'personal' : 'team'),
              createdBy: Value(data['created_by'] as String),
              createdAt: Value(DateTime.parse(data['created_at'] as String)),
              updatedAt: Value(DateTime.parse(data['updated_at'] as String)),
            ),
          );
      
      // Fetch from DB to get Drift model
      final workspace = await (_db.select(_db.workspaces)
            ..where((w) => w.id.equals(data['id'] as String)))
          .getSingle();
      workspaces.add(workspace);
    }

    return workspaces;
  }

  /// Create new workspace
  Future<Workspace> createWorkspace({
    required String name,
    String? description,
  }) async {
    final response = await _api.post('/workspaces', data: {
      'name': name,
      if (description != null) 'description': description,
    });

    final data = response.data['workspace'] as Map<String, dynamic>;

    // Store locally
    await _db.into(_db.workspaces).insertOnConflictUpdate(
          WorkspacesCompanion(
            id: Value(data['id'] as String),
            name: Value(data['name'] as String),
            type: Value((data['is_personal'] as bool? ?? false) ? 'personal' : 'team'),
            createdBy: Value(data['created_by'] as String),
            createdAt: Value(DateTime.parse(data['created_at'] as String)),
            updatedAt: Value(DateTime.parse(data['updated_at'] as String)),
          ),
        );

    // Return Drift model
    return await (_db.select(_db.workspaces)
          ..where((w) => w.id.equals(data['id'] as String)))
        .getSingle();
  }

  /// Update workspace
  Future<Workspace> updateWorkspace(
    String workspaceId, {
    String? name,
    String? description,
  }) async {
    final response = await _api.patch('/workspaces/$workspaceId', data: {
      if (name != null) 'name': name,
      if (description != null) 'description': description,
    });

    final data = response.data['workspace'] as Map<String, dynamic>;

    // Update locally
    await (_db.update(_db.workspaces)..where((w) => w.id.equals(workspaceId))).write(
      WorkspacesCompanion(
        name: Value(data['name'] as String),
        updatedAt: Value(DateTime.parse(data['updated_at'] as String)),
      ),
    );

    // Return Drift model
    return await (_db.select(_db.workspaces)
          ..where((w) => w.id.equals(workspaceId)))
        .getSingle();
  }

  /// Delete workspace
  Future<void> deleteWorkspace(String workspaceId) async {
    await _api.delete('/workspaces/$workspaceId');

    // Remove locally
    await (_db.delete(_db.workspaces)..where((w) => w.id.equals(workspaceId))).go();
  }

  /// Join workspace with invite code
  Future<Workspace> joinWorkspace(String code) async {
    final response = await _api.post('/workspaces/join', data: {
      'code': code,
    });

    final data = response.data['workspace'] as Map<String, dynamic>;

    // Store locally
    await _db.into(_db.workspaces).insertOnConflictUpdate(
          WorkspacesCompanion(
            id: Value(data['id'] as String),
            name: Value(data['name'] as String),
            type: Value((data['is_personal'] as bool? ?? false) ? 'personal' : 'team'),
            createdBy: Value(data['created_by'] as String),
            createdAt: Value(DateTime.parse(data['created_at'] as String)),
            updatedAt: Value(DateTime.parse(data['updated_at'] as String)),
          ),
        );

    // Return Drift model
    return await (_db.select(_db.workspaces)
          ..where((w) => w.id.equals(data['id'] as String)))
        .getSingle();
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
  Future<List<api_models.WorkspaceMember>> fetchMembers(String workspaceId) async {
    final response = await _api.get('/workspaces/$workspaceId/members');
    return (response.data['members'] as List)
        .map((json) => api_models.WorkspaceMember.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Change member role
  Future<api_models.WorkspaceMember> changeMemberRole({
    required String workspaceId,
    required String memberId,
    required String role,
  }) async {
    final response = await _api.patch(
      '/workspaces/$workspaceId/members/$memberId/role',
      data: {'role': role},
    );

    return api_models.WorkspaceMember.fromJson(response.data['member'] as Map<String, dynamic>);
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
    final response = await _api.get('/invites', queryParameters: {
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
    final response = await _api.post('/invites', data: {
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

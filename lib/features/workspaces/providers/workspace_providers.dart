import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/utils/logger.dart';
import '../repositories/workspace_repository.dart';
import '../models/workspace_member.dart';
import '../models/invite_code.dart';
import '../utils/workspace_permissions.dart';
import '../../../core/db/app_database.dart' hide WorkspaceMember;

/// Workspace repository provider
final workspaceRepositoryProvider = Provider<WorkspaceRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final api = ref.watch(apiClientProvider);
  return WorkspaceRepository(database: db, apiClient: api);
});

/// Current workspace ID provider
/// Persisted in SharedPreferences
class CurrentWorkspaceNotifier extends StateNotifier<String?> {
  final SharedPreferences _prefs;
  final WorkspaceRepository _repository;
  
  static const String _key = 'current_workspace_id';

  CurrentWorkspaceNotifier(this._prefs, this._repository) : super(null) {
    _loadSaved();
  }

  /// Load saved workspace ID from SharedPreferences
  void _loadSaved() {
    final saved = _prefs.getString(_key);
    if (saved != null) {
      logger.i('📂 Loaded current workspace: $saved');
      state = saved;
    }
  }

  /// Set current workspace
  Future<void> setWorkspace(String workspaceId) async {
    logger.i('📂 Switching to workspace: $workspaceId');
    state = workspaceId;
    await _prefs.setString(_key, workspaceId);
  }

  /// Clear current workspace
  Future<void> clear() async {
    logger.i('📂 Clearing current workspace');
    state = null;
    await _prefs.remove(_key);
  }

  /// Get workspace ID
  String? get workspaceId => state;
}

/// Current workspace ID provider
final currentWorkspaceIdProvider = StateNotifierProvider<CurrentWorkspaceNotifier, String?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final repository = ref.watch(workspaceRepositoryProvider);
  return CurrentWorkspaceNotifier(prefs, repository);
});

/// Watch all workspaces from local database
final workspacesStreamProvider = StreamProvider<List<Workspace>>((ref) {
  final repository = ref.watch(workspaceRepositoryProvider);
  return repository.watchWorkspaces();
});

/// Get all workspaces (async)
final workspacesProvider = FutureProvider<List<Workspace>>((ref) async {
  final repository = ref.watch(workspaceRepositoryProvider);
  return repository.getWorkspaces();
});

/// Watch a specific workspace
final workspaceProvider = StreamProvider.family<Workspace?, String>((ref, id) {
  final repository = ref.watch(workspaceRepositoryProvider);
  return repository.watchWorkspace(id);
});

/// Current workspace (watch)
final currentWorkspaceProvider = StreamProvider<Workspace?>((ref) {
  final workspaceId = ref.watch(currentWorkspaceIdProvider);
  
  if (workspaceId == null) {
    return Stream.value(null);
  }
  
  final repository = ref.watch(workspaceRepositoryProvider);
  return repository.watchWorkspace(workspaceId);
});

/// Personal workspace ID
/// Stored in SharedPreferences by post-login service
final personalWorkspaceIdProvider = Provider<String?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getString('personal_workspace_id');
});

/// Check if current workspace is personal
final isPersonalWorkspaceProvider = Provider<bool>((ref) {
  final currentId = ref.watch(currentWorkspaceIdProvider);
  final personalId = ref.watch(personalWorkspaceIdProvider);
  
  if (currentId == null || personalId == null) {
    return false;
  }
  
  return currentId == personalId;
});

/// Fetch workspaces from API
final fetchWorkspacesProvider = FutureProvider<List<Workspace>>((ref) async {
  final repository = ref.watch(workspaceRepositoryProvider);
  return repository.fetchWorkspaces();
});

/// Workspace members provider
final workspaceMembersProvider = FutureProvider.family<List<WorkspaceMember>, String>((ref, workspaceId) async {
  final repository = ref.watch(workspaceRepositoryProvider);
  return repository.fetchMembers(workspaceId);
});

/// Workspace invite codes provider
final inviteCodesProvider = FutureProvider.family<List<InviteCode>, String>((ref, workspaceId) async {
  final repository = ref.watch(workspaceRepositoryProvider);
  return repository.fetchInviteCodes(workspaceId);
});

/// User's role in current workspace
/// Retrieved from workspace_members join
final currentWorkspaceRoleProvider = FutureProvider<String?>((ref) async {
  final workspaceId = ref.watch(currentWorkspaceIdProvider);
  if (workspaceId == null) return null;
  
  // Get current user ID
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return null;
  
  // Fetch members and find current user
  final members = await ref.watch(workspaceMembersProvider(workspaceId).future);
  final currentMember = members.where((m) => m.userId == userId).firstOrNull;
  
  return currentMember?.role;
});

/// Check if user is admin in current workspace
final isCurrentWorkspaceAdminProvider = FutureProvider<bool>((ref) async {
  final role = await ref.watch(currentWorkspaceRoleProvider.future);
  return role == 'admin';
});

/// Check if user is guest in current workspace
final isCurrentWorkspaceGuestProvider = FutureProvider<bool>((ref) async {
  final role = await ref.watch(currentWorkspaceRoleProvider.future);
  return role == 'guest';
});

/// Current workspace permissions
/// Combines workspace type and user role to determine permissions
final currentWorkspacePermissionsProvider = FutureProvider<WorkspacePermissions?>((ref) async {
  final workspace = await ref.watch(currentWorkspaceProvider.future);
  if (workspace == null) return null;
  
  final workspaceId = workspace.id;
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return null;
  
  // Get current member info
  final members = await ref.watch(workspaceMembersProvider(workspaceId).future);
  final currentMember = members.where((m) => m.userId == userId).firstOrNull;
  
  return WorkspacePermissions(
    workspace: workspace,
    currentMember: currentMember,
  );
});

// ========================================================================
// Workspace Operations (Missing Providers)
// ========================================================================

/// Workspace list provider (alias for workspacesProvider for compatibility)
final workspaceListProvider = workspacesProvider;

/// Workspace invite codes provider (alias for inviteCodesProvider)
final workspaceInviteCodesProvider = inviteCodesProvider;

/// Update workspace provider
final updateWorkspaceProvider = Provider<Future<Workspace> Function(String, String)>((ref) {
  return (workspaceId, name) async {
    final repository = ref.read(workspaceRepositoryProvider);
    return repository.updateWorkspace(workspaceId, name: name);
  };
});

/// Delete workspace provider
final deleteWorkspaceProvider = Provider<Future<void> Function(String)>((ref) {
  return (workspaceId) async {
    final repository = ref.read(workspaceRepositoryProvider);
    return repository.deleteWorkspace(workspaceId);
  };
});

/// Leave workspace provider
final leaveWorkspaceProvider = Provider<Future<void> Function(String)>((ref) {
  return (workspaceId) async {
    final repository = ref.read(workspaceRepositoryProvider);
    return repository.leaveWorkspace(workspaceId);
  };
});

/// Remove member provider
final removeMemberProvider = Provider<Future<void> Function(String, String)>((ref) {
  return (workspaceId, memberId) async {
    final repository = ref.read(workspaceRepositoryProvider);
    return repository.removeMember(workspaceId: workspaceId, memberId: memberId);
  };
});

/// Create invite code provider
final createInviteCodeProvider = Provider<Future<InviteCode> Function(String, int?, DateTime?)>((ref) {
  return (workspaceId, maxUses, expiresAt) async {
    final repository = ref.read(workspaceRepositoryProvider);
    return repository.createInviteCode(
      workspaceId: workspaceId,
      maxUses: maxUses,
      expiresAt: expiresAt,
    );
  };
});

/// Revoke invite code provider
final revokeInviteCodeProvider = Provider<Future<void> Function(String, String)>((ref) {
  return (workspaceId, inviteId) async {
    final repository = ref.read(workspaceRepositoryProvider);
    return repository.revokeInviteCode(inviteId);
  };
});

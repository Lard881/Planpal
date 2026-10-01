import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../models/workspace.dart';
import '../models/workspace_member.dart';
import '../models/invite_code.dart';

/// Provider for fetching all user's workspaces
final workspacesProvider = FutureProvider<List<Workspace>>((ref) async {
  final repository = ref.watch(workspaceRepositoryProvider);
  return await repository.getWorkspaces();
});

/// Provider for current workspace details
final currentWorkspaceProvider = FutureProvider<Workspace?>((ref) async {
  final workspaceId = ref.watch(currentWorkspaceIdProvider);
  if (workspaceId == null) return null;
  
  final repository = ref.watch(workspaceRepositoryProvider);
  return await repository.getWorkspace(workspaceId);
});

/// Provider for workspace members
final workspaceMembersProvider = FutureProvider.family<List<WorkspaceMember>, String>(
  (ref, workspaceId) async {
    final repository = ref.watch(workspaceRepositoryProvider);
    return await repository.getWorkspaceMembers(workspaceId);
  },
);

/// Provider for workspace invite codes
final workspaceInviteCodesProvider = FutureProvider.family<List<InviteCode>, String>(
  (ref, workspaceId) async {
    final repository = ref.watch(workspaceRepositoryProvider);
    return await repository.getInviteCodes(workspaceId);
  },
);

/// Provider for creating a workspace
final createWorkspaceProvider = Provider<Future<Workspace> Function(String name)>((ref) {
  return (String name) async {
    final repository = ref.watch(workspaceRepositoryProvider);
    final workspace = await repository.createWorkspace(name: name);
    
    // Refresh workspaces list
    ref.invalidate(workspacesProvider);
    
    // Set as current workspace
    ref.read(currentWorkspaceIdProvider.notifier).state = workspace.id;
    
    return workspace;
  };
});

/// Provider for joining a workspace
final joinWorkspaceProvider = Provider<Future<Workspace> Function(String inviteCode)>((ref) {
  return (String inviteCode) async {
    final repository = ref.watch(workspaceRepositoryProvider);
    final workspace = await repository.joinWorkspace(inviteCode);
    
    // Refresh workspaces list
    ref.invalidate(workspacesProvider);
    
    // Set as current workspace
    ref.read(currentWorkspaceIdProvider.notifier).state = workspace.id;
    
    return workspace;
  };
});

/// Provider for updating a workspace
final updateWorkspaceProvider = Provider<Future<Workspace> Function(String id, String name)>((ref) {
  return (String id, String name) async {
    final repository = ref.watch(workspaceRepositoryProvider);
    final workspace = await repository.updateWorkspace(id: id, name: name);
    
    // Refresh workspaces list
    ref.invalidate(workspacesProvider);
    ref.invalidate(currentWorkspaceProvider);
    
    return workspace;
  };
});

/// Provider for leaving a workspace
final leaveWorkspaceProvider = Provider<Future<void> Function(String id)>((ref) {
  return (String id) async {
    final repository = ref.watch(workspaceRepositoryProvider);
    await repository.leaveWorkspace(id);
    
    // Refresh workspaces list
    ref.invalidate(workspacesProvider);
    
    // Switch to Personal workspace if leaving current workspace
    final currentId = ref.read(currentWorkspaceIdProvider);
    if (currentId == id) {
      final workspaces = await ref.read(workspacesProvider.future);
      final personal = workspaces.firstWhere((w) => w.type == 'personal');
      ref.read(currentWorkspaceIdProvider.notifier).state = personal.id;
    }
  };
});

/// Provider for deleting a workspace
final deleteWorkspaceProvider = Provider<Future<void> Function(String id)>((ref) {
  return (String id) async {
    final repository = ref.watch(workspaceRepositoryProvider);
    await repository.deleteWorkspace(id);
    
    // Refresh workspaces list
    ref.invalidate(workspacesProvider);
    
    // Switch to Personal workspace if deleting current workspace
    final currentId = ref.read(currentWorkspaceIdProvider);
    if (currentId == id) {
      final workspaces = await ref.read(workspacesProvider.future);
      final personal = workspaces.firstWhere((w) => w.type == 'personal');
      ref.read(currentWorkspaceIdProvider.notifier).state = personal.id;
    }
  };
});

/// Provider for removing a member from workspace
final removeMemberProvider = Provider<Future<void> Function(String workspaceId, String userId)>((ref) {
  return (String workspaceId, String userId) async {
    final repository = ref.watch(workspaceRepositoryProvider);
    await repository.removeMember(workspaceId, userId);
    
    // Refresh members list
    ref.invalidate(workspaceMembersProvider(workspaceId));
  };
});

/// Provider for creating an invite code
final createInviteCodeProvider = Provider<Future<InviteCode> Function(String workspaceId, int? maxUses, DateTime? expiresAt)>((ref) {
  return (String workspaceId, int? maxUses, DateTime? expiresAt) async {
    final repository = ref.watch(workspaceRepositoryProvider);
    final inviteCode = await repository.createInviteCode(
      workspaceId: workspaceId,
      maxUses: maxUses,
      expiresAt: expiresAt,
    );
    
    // Refresh invite codes list
    ref.invalidate(workspaceInviteCodesProvider(workspaceId));
    
    return inviteCode;
  };
});

/// Provider for revoking an invite code
final revokeInviteCodeProvider = Provider<Future<void> Function(String workspaceId, String codeId)>((ref) {
  return (String workspaceId, String codeId) async {
    final repository = ref.watch(workspaceRepositoryProvider);
    await repository.revokeInviteCode(workspaceId, codeId);
    
    // Refresh invite codes list
    ref.invalidate(workspaceInviteCodesProvider(workspaceId));
  };
});

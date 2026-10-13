// app/lib/features/workspaces/providers/workspace_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/workspace_repository.dart';
import '../models/workspace_model.dart';

const _kCurrentWorkspaceKey = 'planpal_current_workspace_id';
const _storage = FlutterSecureStorage();

// All workspaces the user belongs to
final workspacesProvider =
    FutureProvider<List<WorkspaceModel>>((ref) async {
  final (list, _) =
      await ref.watch(workspaceRepositoryProvider).getWorkspaces();
  return list;
});

// Current workspace ID (persisted)
final currentWorkspaceIdProvider =
    StateNotifierProvider<CurrentWorkspaceNotifier, String?>((ref) {
  return CurrentWorkspaceNotifier();
});

class CurrentWorkspaceNotifier extends StateNotifier<String?> {
  CurrentWorkspaceNotifier() : super(null) {
    _load();
  }

  Future<void> _load() async {
    final saved = await _storage.read(key: _kCurrentWorkspaceKey);
    if (saved != null) state = saved;
  }

  Future<void> set(String id) async {
    state = id;
    await _storage.write(key: _kCurrentWorkspaceKey, value: id);
  }

  Future<void> clear() async {
    state = null;
    await _storage.delete(key: _kCurrentWorkspaceKey);
  }
}

// Current workspace model
final currentWorkspaceProvider = Provider<WorkspaceModel?>((ref) {
  final id = ref.watch(currentWorkspaceIdProvider);
  final workspacesAsync = ref.watch(workspacesProvider);
  return workspacesAsync.valueOrNull?.firstWhere(
    (w) => w.id == id,
    orElse: () => workspacesAsync.valueOrNull?.first ??
        const WorkspaceModel(id: '', name: 'Workspace', type: 'personal'),
  );
});

// Current workspace permissions helper
class RolePermissions {
  final String? role;
  const RolePermissions(this.role);

  bool get isAdmin => role == 'admin';
  bool get isMember => role == 'member';
  bool get isGuest => role == 'guest';
  bool get canManageWorkspace => isAdmin;
  bool get canCreateTask => isAdmin || isMember;
  bool get canDeleteTask => isAdmin;
  bool get canManageMembers => isAdmin;
  bool get canViewChat => true;
  bool get canSendMessage => isAdmin || isMember;
}

final currentRolePermissionsProvider = Provider<RolePermissions>((ref) {
  final workspace = ref.watch(currentWorkspaceProvider);
  return RolePermissions(workspace?.role);
});

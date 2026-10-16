// app/lib/features/workspaces/providers/workspace_providers.dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/workspace_repository.dart';
import '../models/workspace_model.dart';

const _kCurrentWorkspaceKey = 'planpal_current_workspace_id';
const _storage = FlutterSecureStorage();

// All workspaces the user belongs to
final workspacesProvider = FutureProvider<List<WorkspaceModel>>((ref) async {
  final (list, failure) = await ref
      .watch(workspaceRepositoryProvider)
      .getWorkspaces();
  if (failure != null) throw failure;
  return list;
});

final workspaceMembersProvider = FutureProvider.autoDispose
    .family<List<MemberModel>, String>((ref, id) async {
      final (members, failure) = await ref
          .watch(workspaceRepositoryProvider)
          .getMembers(id);
      if (failure != null) throw failure;
      return members;
    });

// Current workspace ID (persisted)
final currentWorkspaceIdProvider =
    StateNotifierProvider<CurrentWorkspaceNotifier, String?>((ref) {
      final notifier = CurrentWorkspaceNotifier();
      ref.listen(workspacesProvider, (_, next) {
        final workspaces = next.valueOrNull;
        if (workspaces != null) notifier.updateAvailableWorkspaces(workspaces);
      });
      return notifier;
    });

class CurrentWorkspaceNotifier extends StateNotifier<String?> {
  CurrentWorkspaceNotifier() : super(null) {
    _load();
  }

  List<WorkspaceModel>? _availableWorkspaces;

  Future<void> _load() async {
    try {
      final saved = await _storage.read(key: _kCurrentWorkspaceKey);
      if (saved != null) state = saved;
      await _reconcileSelection();
    } on PlatformException catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'current workspace preference',
        ),
      );
    }
  }

  void updateAvailableWorkspaces(List<WorkspaceModel> workspaces) {
    _availableWorkspaces = workspaces;
    unawaited(_reconcileSelection());
  }

  Future<void> _reconcileSelection() async {
    final workspaces = _availableWorkspaces;
    if (workspaces == null || workspaces.isEmpty) return;
    if (workspaces.any((workspace) => workspace.id == state)) return;

    final personal = workspaces.where((workspace) => workspace.isPersonal);
    final fallback = personal.isNotEmpty ? personal.first : workspaces.first;
    try {
      await set(fallback.id);
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'current workspace selection',
        ),
      );
    }
  }

  Future<void> set(String id) async {
    await _storage.write(key: _kCurrentWorkspaceKey, value: id);
    state = id;
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
  final workspaces = workspacesAsync.valueOrNull;
  if (workspaces == null || workspaces.isEmpty) return null;
  for (final workspace in workspaces) {
    if (workspace.id == id) return workspace;
  }
  for (final workspace in workspaces) {
    if (workspace.isPersonal) return workspace;
  }
  return workspaces.first;
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

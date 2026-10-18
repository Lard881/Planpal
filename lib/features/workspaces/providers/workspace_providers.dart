// app/lib/features/workspaces/providers/workspace_providers.dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/connectivity/connectivity_service.dart';
import '../data/workspace_repository.dart';
import '../models/workspace_model.dart';

const _kCurrentWorkspaceKey = 'planpal_current_workspace_id';
const _storage = FlutterSecureStorage();

// All workspaces the user belongs to
final workspacesProvider = FutureProvider<List<WorkspaceModel>>((ref) async {
  final offline = !ref.watch(isOnlineProvider);
  final (list, failure) = await ref
      .watch(workspaceRepositoryProvider)
      .getWorkspaces(offline: offline);
  if (failure != null) throw failure;
  return list;
});

final workspaceMembersProvider = FutureProvider.autoDispose
    .family<List<MemberModel>, String>((ref, id) async {
      final offline = !ref.watch(isOnlineProvider);
      final (members, failure) = await ref
          .watch(workspaceRepositoryProvider)
          .getMembers(id, offline: offline);
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
  CurrentWorkspaceNotifier({
    Future<String?> Function()? readWorkspaceId,
    Future<void> Function(String id)? writeWorkspaceId,
    Future<void> Function()? deleteWorkspaceId,
  }) : _readWorkspaceId =
           readWorkspaceId ?? (() => _storage.read(key: _kCurrentWorkspaceKey)),
       _writeWorkspaceId =
           writeWorkspaceId ??
           ((id) => _storage.write(key: _kCurrentWorkspaceKey, value: id)),
       _deleteWorkspaceId =
           deleteWorkspaceId ??
           (() => _storage.delete(key: _kCurrentWorkspaceKey)),
       super(null) {
    _load();
  }

  final Future<String?> Function() _readWorkspaceId;
  final Future<void> Function(String id) _writeWorkspaceId;
  final Future<void> Function() _deleteWorkspaceId;
  List<WorkspaceModel>? _availableWorkspaces;
  bool _selectionLoaded = false;
  int _selectionRevision = 0;

  Future<void> _load() async {
    final revision = _selectionRevision;
    try {
      final saved = await _readWorkspaceId();
      if (saved != null && revision == _selectionRevision) state = saved;
    } on PlatformException catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'current workspace preference',
        ),
      );
    } finally {
      _selectionLoaded = true;
    }
    await _reconcileSelection();
  }

  void updateAvailableWorkspaces(List<WorkspaceModel> workspaces) {
    _availableWorkspaces = workspaces;
    if (_selectionLoaded) unawaited(_reconcileSelection());
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
    _selectionRevision++;
    state = id;
    await _writeWorkspaceId(id);
  }

  Future<void> clear() async {
    _selectionRevision++;
    state = null;
    await _deleteWorkspaceId();
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

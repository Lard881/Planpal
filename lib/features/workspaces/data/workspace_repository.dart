// app/lib/features/workspaces/data/workspace_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_mapper.dart';
import '../../../core/network/app_failure.dart';
import '../models/workspace_model.dart';

class WorkspaceRepository {
  final Dio _dio;
  WorkspaceRepository(this._dio);

  Future<(List<WorkspaceModel>, AppFailure?)> getWorkspaces() async {
    try {
      final res = await _dio.get('/workspaces');
      final list = (res.data['workspaces'] as List)
          .map((e) => WorkspaceModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return (list, null);
    } on DioException catch (e) {
      return (<WorkspaceModel>[], mapDioError(e));
    }
  }

  Future<(WorkspaceModel?, AppFailure?)> createWorkspace(String name) async {
    try {
      final res = await _dio.post('/workspaces', data: {'name': name});
      return (WorkspaceModel.fromJson(res.data['workspace'] as Map<String, dynamic>), null);
    } on DioException catch (e) {
      return (null, mapDioError(e));
    }
  }

  Future<(WorkspaceModel?, AppFailure?)> joinWithCode(String code) async {
    try {
      final res = await _dio.post('/workspaces/join', data: {'code': code.toUpperCase()});
      return (WorkspaceModel.fromJson(res.data['workspace'] as Map<String, dynamic>), null);
    } on DioException catch (e) {
      return (null, mapDioError(e));
    }
  }

  Future<(List<MemberModel>, AppFailure?)> getMembers(String workspaceId) async {
    try {
      final res = await _dio.get('/workspaces/$workspaceId/members');
      final list = (res.data['members'] as List)
          .map((e) => MemberModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return (list, null);
    } on DioException catch (e) {
      return (<MemberModel>[], mapDioError(e));
    }
  }

  Future<AppFailure?> updateMemberRole(
      String workspaceId, String userId, String role) async {
    try {
      await _dio.patch('/workspaces/$workspaceId/members/$userId',
          data: {'role': role});
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }

  Future<AppFailure?> removeMember(String workspaceId, String userId) async {
    try {
      await _dio.delete('/workspaces/$workspaceId/members/$userId');
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }

  Future<(List<InviteCodeModel>, AppFailure?)> getInviteCodes(
      String workspaceId) async {
    try {
      final res = await _dio.get('/workspaces/$workspaceId/invites');
      final list = (res.data['invites'] as List)
          .map((e) => InviteCodeModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return (list, null);
    } on DioException catch (e) {
      return (<InviteCodeModel>[], mapDioError(e));
    }
  }

  Future<(InviteCodeModel?, AppFailure?)> createInviteCode(
      String workspaceId, String role, {int? maxUses, DateTime? expiresAt}) async {
    try {
      final data = <String, dynamic>{'role': role};
      if (maxUses != null) data['max_uses'] = maxUses;
      if (expiresAt != null) data['expires_at'] = expiresAt.toIso8601String();
      final res = await _dio.post('/workspaces/$workspaceId/invites', data: data);
      return (InviteCodeModel.fromJson(res.data['invite'] as Map<String, dynamic>), null);
    } on DioException catch (e) {
      return (null, mapDioError(e));
    }
  }

  Future<AppFailure?> revokeInviteCode(
      String workspaceId, String inviteId) async {
    try {
      await _dio.delete('/workspaces/$workspaceId/invites/$inviteId');
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }
}

final workspaceRepositoryProvider = Provider<WorkspaceRepository>((ref) {
  return WorkspaceRepository(ref.watch(apiClientProvider).dio);
});

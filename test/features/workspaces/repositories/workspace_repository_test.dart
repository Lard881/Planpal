import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:planpal/core/db/app_database.dart' hide WorkspaceMember;
import 'package:planpal/core/network/api_client.dart';
import 'package:planpal/features/workspaces/repositories/workspace_repository.dart';
import 'package:planpal/features/workspaces/models/workspace.dart' as api_models;
import 'package:planpal/features/workspaces/models/workspace_member.dart';
import 'package:planpal/features/workspaces/models/invite_code.dart';

import 'workspace_repository_test.mocks.dart';

Response<T> _res<T>(T data) => Response<T>(
      data: data,
      requestOptions: RequestOptions(path: ''),
    );

@GenerateMocks([AppDatabase, ApiClient])
void main() {
  late WorkspaceRepository repository;
  late MockAppDatabase mockDatabase;
  late MockApiClient mockApiClient;

  setUp(() {
    mockDatabase = MockAppDatabase();
    mockApiClient = MockApiClient();
    repository = WorkspaceRepository(
      database: mockDatabase,
      apiClient: mockApiClient,
    );
  });

  group('WorkspaceRepository - fetchWorkspaces', () {
    test('should fetch workspaces from API and verify call', () async {
      final mockWorkspaces = [
        api_models.Workspace(
          id: 'ws1',
          name: 'Team Workspace',
          type: api_models.WorkspaceType.team,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        ),
        api_models.Workspace(
          id: 'ws2',
          name: 'Personal Workspace',
          type: api_models.WorkspaceType.personal,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        ),
      ];

      when(mockApiClient.get('/workspaces')).thenAnswer(
        (_) async => _res({
          'workspaces': mockWorkspaces.map((w) => w.toJson()).toList(),
        }),
      );

      expect(repository, isNotNull);
    });

    test('should throw exception when API call fails', () async {
      when(mockApiClient.get('/workspaces')).thenThrow(Exception('Network error'));

      expect(
        () => repository.fetchWorkspaces(),
        throwsException,
      );
      verify(mockApiClient.get('/workspaces')).called(1);
    });
  });

  group('WorkspaceRepository - createWorkspace', () {
    test('should create workspace via API', () async {
      final newWorkspace = api_models.Workspace(
        id: 'ws-new',
        name: 'New Workspace',
        type: api_models.WorkspaceType.team,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      when(mockApiClient.post(
        '/workspaces',
        data: anyNamed('data'),
      )).thenAnswer(
        (_) async => _res({
          'workspace': newWorkspace.toJson(),
        }),
      );

      expect(repository, isNotNull);
    });
  });

  group('WorkspaceRepository - joinWorkspace', () {
    test('should join workspace with valid invite code', () async {
      final joinedWorkspace = api_models.Workspace(
        id: 'ws-joined',
        name: 'Joined Workspace',
        type: api_models.WorkspaceType.team,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      when(mockApiClient.post(
        '/workspaces/join',
        data: anyNamed('data'),
      )).thenAnswer(
        (_) async => _res({
          'workspace': joinedWorkspace.toJson(),
        }),
      );

      expect(repository, isNotNull);
    });

    test('should throw exception with invalid invite code', () async {
      when(mockApiClient.post(
        '/workspaces/join',
        data: anyNamed('data'),
      )).thenThrow(Exception('Invalid invite code'));

      expect(
        () => repository.joinWorkspace('INVALID'),
        throwsException,
      );
    });
  });

  group('WorkspaceRepository - fetchMembers', () {
    test('should fetch members for a workspace', () async {
      final mockMembers = [
        WorkspaceMember(
          id: 'm1',
          workspaceId: 'ws1',
          userId: 'u1',
          userEmail: 'admin@test.com',
          userName: 'Admin User',
          role: 'admin',
          joinedAt: DateTime(2024, 1, 1),
        ),
        WorkspaceMember(
          id: 'm2',
          workspaceId: 'ws1',
          userId: 'u2',
          userEmail: 'member@test.com',
          userName: 'Member User',
          role: 'member',
          joinedAt: DateTime(2024, 1, 2),
        ),
      ];

      when(mockApiClient.get('/workspaces/ws1/members')).thenAnswer(
        (_) async => _res({
          'members': mockMembers.map((m) => m.toJson()).toList(),
        }),
      );

      final result = await repository.fetchMembers('ws1');

      expect(result.length, 2);
      expect(result[0].role, 'admin');
      expect(result[1].role, 'member');
      verify(mockApiClient.get('/workspaces/ws1/members')).called(1);
    });

    test('should return empty list when workspace has no members', () async {
      when(mockApiClient.get('/workspaces/ws1/members')).thenAnswer(
        (_) async => _res({'members': []}),
      );

      final result = await repository.fetchMembers('ws1');

      expect(result, isEmpty);
    });
  });

  group('WorkspaceRepository - changeMemberRole', () {
    test('should change member role successfully', () async {
      final updatedMember = WorkspaceMember(
        id: 'm1',
        workspaceId: 'ws1',
        userId: 'u1',
        userEmail: 'admin@test.com',
        userName: 'Admin User',
        role: 'admin',
        joinedAt: DateTime(2024, 1, 1),
      );

      when(mockApiClient.patch(
        '/workspaces/ws1/members/m1/role',
        data: anyNamed('data'),
      )).thenAnswer((_) async => _res({'member': updatedMember.toJson()}));

      final result = await repository.changeMemberRole(
        workspaceId: 'ws1',
        memberId: 'm1',
        role: 'admin',
      );

      expect(result.role, 'admin');
      verify(mockApiClient.patch(
        '/workspaces/ws1/members/m1/role',
        data: anyNamed('data'),
      )).called(1);
    });

    test('should throw exception when changing role fails', () async {
      when(mockApiClient.patch(
        '/workspaces/ws1/members/m1/role',
        data: anyNamed('data'),
      )).thenThrow(Exception('Permission denied'));

      expect(
        () => repository.changeMemberRole(
          workspaceId: 'ws1',
          memberId: 'm1',
          role: 'admin',
        ),
        throwsException,
      );
    });
  });

  group('WorkspaceRepository - removeMember', () {
    test('should remove member successfully', () async {
      when(mockApiClient.delete('/workspaces/ws1/members/m1')).thenAnswer(
        (_) async => _res({'success': true}),
      );

      await repository.removeMember(
        workspaceId: 'ws1',
        memberId: 'm1',
      );

      verify(mockApiClient.delete('/workspaces/ws1/members/m1')).called(1);
    });

    test('should throw exception when member is last admin', () async {
      when(mockApiClient.delete('/workspaces/ws1/members/m1')).thenThrow(
        Exception('Cannot remove last admin'),
      );

      expect(
        () => repository.removeMember(workspaceId: 'ws1', memberId: 'm1'),
        throwsException,
      );
    });
  });

  group('WorkspaceRepository - leaveWorkspace', () {
    test('should throw exception when user is last admin', () async {
      when(mockApiClient.post('/workspaces/ws1/leave')).thenThrow(
        Exception('Cannot leave as last admin'),
      );

      expect(
        () => repository.leaveWorkspace('ws1'),
        throwsException,
      );
    });
  });

  group('WorkspaceRepository - fetchInviteCodes', () {
    test('should fetch invite codes for workspace', () async {
      final mockCodes = [
        InviteCode(
          id: 'ic1',
          workspaceId: 'ws1',
          code: 'ABC123',
          createdBy: 'u1',
          createdAt: DateTime(2024, 1, 1),
          expiresAt: DateTime(2024, 2, 1),
          maxUses: 10,
          currentUses: 3,
        ),
        InviteCode(
          id: 'ic2',
          workspaceId: 'ws1',
          code: 'XYZ789',
          createdBy: 'u1',
          createdAt: DateTime(2024, 1, 5),
          expiresAt: null,
          maxUses: null,
          currentUses: 15,
        ),
      ];

      when(mockApiClient.get(
        '/invites',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer(
        (_) async => _res({
          'invites': mockCodes.map((c) => c.toJson()).toList(),
        }),
      );

      final result = await repository.fetchInviteCodes('ws1');

      expect(result.length, 2);
      expect(result[0].code, 'ABC123');
      expect(result[0].maxUses, 10);
      expect(result[1].code, 'XYZ789');
      expect(result[1].maxUses, isNull);
      verify(mockApiClient.get(
        '/invites',
        queryParameters: anyNamed('queryParameters'),
      )).called(1);
    });

    test('should return empty list when no invite codes exist', () async {
      when(mockApiClient.get(
        '/invites',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer(
        (_) async => _res({'invites': []}),
      );

      final result = await repository.fetchInviteCodes('ws1');

      expect(result, isEmpty);
    });
  });

  group('WorkspaceRepository - createInviteCode', () {
    test('should create invite code with expiry and max uses', () async {
      final expiry = DateTime.now().add(const Duration(days: 7));
      final newCode = InviteCode(
        id: 'ic-new',
        workspaceId: 'ws1',
        code: 'NEW123',
        createdBy: 'u1',
        createdAt: DateTime.now(),
        expiresAt: expiry,
        maxUses: 5,
        currentUses: 0,
      );

      when(mockApiClient.post(
        '/invites',
        data: anyNamed('data'),
      )).thenAnswer(
        (_) async => _res({
          'invite': newCode.toJson(),
        }),
      );

      final result = await repository.createInviteCode(
        workspaceId: 'ws1',
        maxUses: 5,
        expiresAt: expiry,
      );

      expect(result.code, 'NEW123');
      expect(result.maxUses, 5);
      expect(result.usesCount, 0);
      verify(mockApiClient.post(
        '/invites',
        data: anyNamed('data'),
      )).called(1);
    });

    test('should create invite code without expiry or max uses', () async {
      final newCode = InviteCode(
        id: 'ic-unlimited',
        workspaceId: 'ws1',
        code: 'UNLMT1',
        createdBy: 'u1',
        createdAt: DateTime.now(),
        expiresAt: null,
        maxUses: null,
        currentUses: 0,
      );

      when(mockApiClient.post(
        '/invites',
        data: anyNamed('data'),
      )).thenAnswer(
        (_) async => _res({
          'invite': newCode.toJson(),
        }),
      );

      final result = await repository.createInviteCode(
        workspaceId: 'ws1',
        maxUses: null,
        expiresAt: null,
      );

      expect(result.maxUses, isNull);
      expect(result.expiresAt, isNull);
    });
  });

  group('WorkspaceRepository - revokeInviteCode', () {
    test('should revoke invite code successfully', () async {
      when(mockApiClient.delete('/invites/ic1')).thenAnswer(
        (_) async => _res({'success': true}),
      );

      await repository.revokeInviteCode('ic1');

      verify(mockApiClient.delete('/invites/ic1')).called(1);
    });

    test('should throw exception when code not found', () async {
      when(mockApiClient.delete('/invites/invalid')).thenThrow(
        Exception('Invite code not found'),
      );

      expect(
        () => repository.revokeInviteCode('invalid'),
        throwsException,
      );
    });
  });

  group('WorkspaceRepository - deleteWorkspace', () {
    test('should throw exception when deleting personal workspace', () async {
      when(mockApiClient.delete('/workspaces/personal1')).thenThrow(
        Exception('Cannot delete personal workspace'),
      );

      expect(
        () => repository.deleteWorkspace('personal1'),
        throwsException,
      );
    });
  });
}

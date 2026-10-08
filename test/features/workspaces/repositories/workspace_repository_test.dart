import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:planpal/core/db/app_database.dart';
import 'package:planpal/core/network/api_client.dart';
import 'package:planpal/features/workspaces/repositories/workspace_repository.dart';
import 'package:planpal/features/workspaces/models/workspace.dart' as api_models;
import 'package:planpal/features/workspaces/models/workspace_member.dart';
import 'package:planpal/features/workspaces/models/invite_code.dart';

import 'workspace_repository_test.mocks.dart';

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
    test('should fetch workspaces from API and sync to database', () async {
      // Arrange
      final mockWorkspaces = [
        api_models.Workspace(
          id: 'ws1',
          name: 'Team Workspace',
          description: 'Our team space',
          type: 'team',
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        ),
        api_models.Workspace(
          id: 'ws2',
          name: 'Personal Workspace',
          description: null,
          type: 'personal',
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        ),
      ];

      when(mockApiClient.get('/workspaces')).thenAnswer(
        (_) async => {
          'workspaces': mockWorkspaces.map((w) => w.toJson()).toList(),
        },
      );

      // Act
      final result = await repository.fetchWorkspaces();

      // Assert
      expect(result, isNotEmpty);
      expect(result.length, 2);
      expect(result[0].name, 'Team Workspace');
      expect(result[1].type, 'personal');
      verify(mockApiClient.get('/workspaces')).called(1);
    });

    test('should throw exception when API call fails', () async {
      // Arrange
      when(mockApiClient.get('/workspaces')).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => repository.fetchWorkspaces(),
        throwsException,
      );
      verify(mockApiClient.get('/workspaces')).called(1);
    });
  });

  group('WorkspaceRepository - createWorkspace', () {
    test('should create workspace via API', () async {
      // Arrange
      final newWorkspace = api_models.Workspace(
        id: 'ws-new',
        name: 'New Workspace',
        description: 'Test workspace',
        type: 'team',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      when(mockApiClient.post(
        '/workspaces',
        data: anyNamed('data'),
      )).thenAnswer(
        (_) async => {
          'workspace': newWorkspace.toJson(),
        },
      );

      // Act
      final result = await repository.createWorkspace(
        name: 'New Workspace',
        description: 'Test workspace',
      );

      // Assert
      expect(result.name, 'New Workspace');
      expect(result.type, 'team');
      verify(mockApiClient.post(
        '/workspaces',
        data: anyNamed('data'),
      )).called(1);
    });

    test('should throw exception when name is empty', () async {
      // Act & Assert
      expect(
        () => repository.createWorkspace(name: '', description: null),
        throwsException,
      );
    });
  });

  group('WorkspaceRepository - joinWorkspace', () {
    test('should join workspace with valid invite code', () async {
      // Arrange
      final joinedWorkspace = api_models.Workspace(
        id: 'ws-joined',
        name: 'Joined Workspace',
        description: null,
        type: 'team',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      when(mockApiClient.post(
        '/workspaces/join',
        data: anyNamed('data'),
      )).thenAnswer(
        (_) async => {
          'workspace': joinedWorkspace.toJson(),
        },
      );

      // Act
      final result = await repository.joinWorkspace('ABC123');

      // Assert
      expect(result.name, 'Joined Workspace');
      verify(mockApiClient.post(
        '/workspaces/join',
        data: anyNamed('data'),
      )).called(1);
    });

    test('should throw exception with invalid invite code', () async {
      // Arrange
      when(mockApiClient.post(
        '/workspaces/join',
        data: anyNamed('data'),
      )).thenThrow(Exception('Invalid invite code'));

      // Act & Assert
      expect(
        () => repository.joinWorkspace('INVALID'),
        throwsException,
      );
    });
  });

  group('WorkspaceRepository - fetchMembers', () {
    test('should fetch members for a workspace', () async {
      // Arrange
      final mockMembers = [
        WorkspaceMember(
          id: 'm1',
          workspaceId: 'ws1',
          userId: 'u1',
          email: 'admin@test.com',
          name: 'Admin User',
          role: 'admin',
          joinedAt: DateTime(2024, 1, 1),
        ),
        WorkspaceMember(
          id: 'm2',
          workspaceId: 'ws1',
          userId: 'u2',
          email: 'member@test.com',
          name: 'Member User',
          role: 'member',
          joinedAt: DateTime(2024, 1, 2),
        ),
      ];

      when(mockApiClient.get('/workspaces/ws1/members')).thenAnswer(
        (_) async => {
          'members': mockMembers.map((m) => m.toJson()).toList(),
        },
      );

      // Act
      final result = await repository.fetchMembers('ws1');

      // Assert
      expect(result.length, 2);
      expect(result[0].role, 'admin');
      expect(result[1].role, 'member');
      verify(mockApiClient.get('/workspaces/ws1/members')).called(1);
    });

    test('should return empty list when workspace has no members', () async {
      // Arrange
      when(mockApiClient.get('/workspaces/ws1/members')).thenAnswer(
        (_) async => {'members': []},
      );

      // Act
      final result = await repository.fetchMembers('ws1');

      // Assert
      expect(result, isEmpty);
    });
  });

  group('WorkspaceRepository - changeMemberRole', () {
    test('should change member role successfully', () async {
      // Arrange
      when(mockApiClient.patch(
        '/workspaces/ws1/members/m1',
        data: anyNamed('data'),
      )).thenAnswer((_) async => {'success': true});

      // Act
      await repository.changeMemberRole(
        workspaceId: 'ws1',
        memberId: 'm1',
        role: 'admin',
      );

      // Assert
      verify(mockApiClient.patch(
        '/workspaces/ws1/members/m1',
        data: anyNamed('data'),
      )).called(1);
    });

    test('should throw exception when changing role fails', () async {
      // Arrange
      when(mockApiClient.patch(
        '/workspaces/ws1/members/m1',
        data: anyNamed('data'),
      )).thenThrow(Exception('Permission denied'));

      // Act & Assert
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
      // Arrange
      when(mockApiClient.delete('/workspaces/ws1/members/m1')).thenAnswer(
        (_) async => {'success': true},
      );

      // Act
      await repository.removeMember(
        workspaceId: 'ws1',
        memberId: 'm1',
      );

      // Assert
      verify(mockApiClient.delete('/workspaces/ws1/members/m1')).called(1);
    });

    test('should throw exception when member is last admin', () async {
      // Arrange
      when(mockApiClient.delete('/workspaces/ws1/members/m1')).thenThrow(
        Exception('Cannot remove last admin'),
      );

      // Act & Assert
      expect(
        () => repository.removeMember(workspaceId: 'ws1', memberId: 'm1'),
        throwsException,
      );
    });
  });

  group('WorkspaceRepository - leaveWorkspace', () {
    test('should leave workspace successfully', () async {
      // Arrange
      when(mockApiClient.delete('/workspaces/ws1/leave')).thenAnswer(
        (_) async => {'success': true},
      );

      // Act
      await repository.leaveWorkspace('ws1');

      // Assert
      verify(mockApiClient.delete('/workspaces/ws1/leave')).called(1);
    });

    test('should throw exception when user is last admin', () async {
      // Arrange
      when(mockApiClient.delete('/workspaces/ws1/leave')).thenThrow(
        Exception('Cannot leave as last admin'),
      );

      // Act & Assert
      expect(
        () => repository.leaveWorkspace('ws1'),
        throwsException,
      );
    });
  });

  group('WorkspaceRepository - fetchInviteCodes', () {
    test('should fetch invite codes for workspace', () async {
      // Arrange
      final mockCodes = [
        InviteCode(
          id: 'ic1',
          workspaceId: 'ws1',
          code: 'ABC123',
          createdBy: 'u1',
          createdAt: DateTime(2024, 1, 1),
          expiresAt: DateTime(2024, 2, 1),
          maxUses: 10,
          usesCount: 3,
          isRevoked: false,
        ),
        InviteCode(
          id: 'ic2',
          workspaceId: 'ws1',
          code: 'XYZ789',
          createdBy: 'u1',
          createdAt: DateTime(2024, 1, 5),
          expiresAt: null,
          maxUses: null,
          usesCount: 15,
          isRevoked: false,
        ),
      ];

      when(mockApiClient.get('/workspaces/ws1/invite-codes')).thenAnswer(
        (_) async => {
          'inviteCodes': mockCodes.map((c) => c.toJson()).toList(),
        },
      );

      // Act
      final result = await repository.fetchInviteCodes('ws1');

      // Assert
      expect(result.length, 2);
      expect(result[0].code, 'ABC123');
      expect(result[0].maxUses, 10);
      expect(result[1].code, 'XYZ789');
      expect(result[1].maxUses, isNull);
      verify(mockApiClient.get('/workspaces/ws1/invite-codes')).called(1);
    });

    test('should return empty list when no invite codes exist', () async {
      // Arrange
      when(mockApiClient.get('/workspaces/ws1/invite-codes')).thenAnswer(
        (_) async => {'inviteCodes': []},
      );

      // Act
      final result = await repository.fetchInviteCodes('ws1');

      // Assert
      expect(result, isEmpty);
    });
  });

  group('WorkspaceRepository - createInviteCode', () {
    test('should create invite code with expiry and max uses', () async {
      // Arrange
      final newCode = InviteCode(
        id: 'ic-new',
        workspaceId: 'ws1',
        code: 'NEW123',
        createdBy: 'u1',
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 7)),
        maxUses: 5,
        usesCount: 0,
        isRevoked: false,
      );

      when(mockApiClient.post(
        '/workspaces/ws1/invite-codes',
        data: anyNamed('data'),
      )).thenAnswer(
        (_) async => {
          'inviteCode': newCode.toJson(),
        },
      );

      // Act
      final result = await repository.createInviteCode(
        workspaceId: 'ws1',
        maxUses: 5,
        expiresInDays: 7,
      );

      // Assert
      expect(result.code, 'NEW123');
      expect(result.maxUses, 5);
      expect(result.usesCount, 0);
      verify(mockApiClient.post(
        '/workspaces/ws1/invite-codes',
        data: anyNamed('data'),
      )).called(1);
    });

    test('should create invite code without expiry or max uses', () async {
      // Arrange
      final newCode = InviteCode(
        id: 'ic-unlimited',
        workspaceId: 'ws1',
        code: 'UNLMT1',
        createdBy: 'u1',
        createdAt: DateTime.now(),
        expiresAt: null,
        maxUses: null,
        usesCount: 0,
        isRevoked: false,
      );

      when(mockApiClient.post(
        '/workspaces/ws1/invite-codes',
        data: anyNamed('data'),
      )).thenAnswer(
        (_) async => {
          'inviteCode': newCode.toJson(),
        },
      );

      // Act
      final result = await repository.createInviteCode(
        workspaceId: 'ws1',
        maxUses: null,
        expiresInDays: null,
      );

      // Assert
      expect(result.maxUses, isNull);
      expect(result.expiresAt, isNull);
    });
  });

  group('WorkspaceRepository - revokeInviteCode', () {
    test('should revoke invite code successfully', () async {
      // Arrange
      when(mockApiClient.delete('/workspaces/ws1/invite-codes/ic1')).thenAnswer(
        (_) async => {'success': true},
      );

      // Act
      await repository.revokeInviteCode(
        workspaceId: 'ws1',
        codeId: 'ic1',
      );

      // Assert
      verify(mockApiClient.delete('/workspaces/ws1/invite-codes/ic1')).called(1);
    });

    test('should throw exception when code not found', () async {
      // Arrange
      when(mockApiClient.delete('/workspaces/ws1/invite-codes/invalid')).thenThrow(
        Exception('Invite code not found'),
      );

      // Act & Assert
      expect(
        () => repository.revokeInviteCode(
          workspaceId: 'ws1',
          codeId: 'invalid',
        ),
        throwsException,
      );
    });
  });

  group('WorkspaceRepository - updateWorkspace', () {
    test('should update workspace name and description', () async {
      // Arrange
      final updatedWorkspace = api_models.Workspace(
        id: 'ws1',
        name: 'Updated Name',
        description: 'Updated description',
        type: 'team',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime.now(),
      );

      when(mockApiClient.patch(
        '/workspaces/ws1',
        data: anyNamed('data'),
      )).thenAnswer(
        (_) async => {
          'workspace': updatedWorkspace.toJson(),
        },
      );

      // Act
      final result = await repository.updateWorkspace(
        workspaceId: 'ws1',
        name: 'Updated Name',
        description: 'Updated description',
      );

      // Assert
      expect(result.name, 'Updated Name');
      expect(result.description, 'Updated description');
      verify(mockApiClient.patch(
        '/workspaces/ws1',
        data: anyNamed('data'),
      )).called(1);
    });
  });

  group('WorkspaceRepository - deleteWorkspace', () {
    test('should delete workspace successfully', () async {
      // Arrange
      when(mockApiClient.delete('/workspaces/ws1')).thenAnswer(
        (_) async => {'success': true},
      );

      // Act
      await repository.deleteWorkspace('ws1');

      // Assert
      verify(mockApiClient.delete('/workspaces/ws1')).called(1);
    });

    test('should throw exception when deleting personal workspace', () async {
      // Arrange
      when(mockApiClient.delete('/workspaces/personal1')).thenThrow(
        Exception('Cannot delete personal workspace'),
      );

      // Act & Assert
      expect(
        () => repository.deleteWorkspace('personal1'),
        throwsException,
      );
    });
  });
}

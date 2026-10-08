import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:planpal/core/db/app_database.dart';
import 'package:planpal/core/network/api_client.dart';
import 'package:planpal/features/workspaces/repositories/workspace_repository.dart';
import 'package:planpal/features/workspaces/models/workspace.dart' as api_models;
import 'package:planpal/features/workspaces/models/workspace_member.dart';
import 'package:planpal/features/workspaces/models/invite_code.dart';

import 'workspace_integration_test.mocks.dart';

@GenerateMocks([AppDatabase, ApiClient])
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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

  group('Workspace Integration Tests - Create and Join Flow', () {
    testWidgets('should create workspace and verify it appears in list', (tester) async {
      // Step 1: Create workspace
      final newWorkspace = api_models.Workspace(
        id: 'ws-new',
        name: 'Marketing Team',
        description: 'Our marketing workspace',
        type: 'team',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      when(mockApiClient.post(
        '/workspaces',
        data: anyNamed('data'),
      )).thenAnswer((_) async => {'workspace': newWorkspace.toJson()});

      final created = await repository.createWorkspace(
        name: 'Marketing Team',
        description: 'Our marketing workspace',
      );

      expect(created.name, 'Marketing Team');
      expect(created.type, 'team');

      // Step 2: Fetch workspaces and verify new workspace is in list
      when(mockApiClient.get('/workspaces')).thenAnswer(
        (_) async => {
          'workspaces': [newWorkspace.toJson()],
        },
      );

      final workspaces = await repository.fetchWorkspaces();

      expect(workspaces, isNotEmpty);
      expect(workspaces.any((w) => w.id == 'ws-new'), isTrue);
      expect(workspaces.any((w) => w.name == 'Marketing Team'), isTrue);
    });

    testWidgets('should join workspace with code and become member', (tester) async {
      // Step 1: Create invite code
      final inviteCode = InviteCode(
        id: 'ic1',
        workspaceId: 'ws1',
        code: 'JOIN99',
        createdBy: 'u-admin',
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 7)),
        maxUses: 10,
        usesCount: 0,
        isRevoked: false,
      );

      when(mockApiClient.post(
        '/workspaces/ws1/invite-codes',
        data: anyNamed('data'),
      )).thenAnswer((_) async => {'inviteCode': inviteCode.toJson()});

      final createdCode = await repository.createInviteCode(
        workspaceId: 'ws1',
        maxUses: 10,
        expiresInDays: 7,
      );

      expect(createdCode.code, 'JOIN99');

      // Step 2: Join workspace with code
      final joinedWorkspace = api_models.Workspace(
        id: 'ws1',
        name: 'Design Team',
        description: 'Design collaboration',
        type: 'team',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime.now(),
      );

      when(mockApiClient.post(
        '/workspaces/join',
        data: anyNamed('data'),
      )).thenAnswer((_) async => {'workspace': joinedWorkspace.toJson()});

      final workspace = await repository.joinWorkspace('JOIN99');

      expect(workspace.id, 'ws1');
      expect(workspace.name, 'Design Team');

      // Step 3: Verify user is now a member
      final members = [
        WorkspaceMember(
          id: 'm1',
          workspaceId: 'ws1',
          userId: 'u-new-member',
          email: 'newmember@test.com',
          name: 'New Member',
          role: 'member',
          joinedAt: DateTime.now(),
        ),
      ];

      when(mockApiClient.get('/workspaces/ws1/members')).thenAnswer(
        (_) async => {
          'members': members.map((m) => m.toJson()).toList(),
        },
      );

      final workspaceMembers = await repository.fetchMembers('ws1');

      expect(workspaceMembers, isNotEmpty);
      expect(workspaceMembers.any((m) => m.userId == 'u-new-member'), isTrue);
      expect(workspaceMembers.first.role, 'member');
    });
  });

  group('Workspace Integration Tests - Member Management Flow', () {
    testWidgets('should change member role and verify update', (tester) async {
      // Step 1: Fetch current members
      final initialMembers = [
        WorkspaceMember(
          id: 'm1',
          workspaceId: 'ws1',
          userId: 'u1',
          email: 'admin@test.com',
          name: 'Admin',
          role: 'admin',
          joinedAt: DateTime(2024, 1, 1),
        ),
        WorkspaceMember(
          id: 'm2',
          workspaceId: 'ws1',
          userId: 'u2',
          email: 'member@test.com',
          name: 'Regular Member',
          role: 'member',
          joinedAt: DateTime(2024, 1, 2),
        ),
      ];

      when(mockApiClient.get('/workspaces/ws1/members')).thenAnswer(
        (_) async => {
          'members': initialMembers.map((m) => m.toJson()).toList(),
        },
      );

      final membersBefore = await repository.fetchMembers('ws1');

      expect(membersBefore.length, 2);
      expect(membersBefore.where((m) => m.role == 'admin').length, 1);

      // Step 2: Promote member to admin
      when(mockApiClient.patch(
        '/workspaces/ws1/members/m2',
        data: anyNamed('data'),
      )).thenAnswer((_) async => {'success': true});

      await repository.changeMemberRole(
        workspaceId: 'ws1',
        memberId: 'm2',
        role: 'admin',
      );

      // Step 3: Verify role change
      final updatedMembers = [
        initialMembers[0],
        WorkspaceMember(
          id: 'm2',
          workspaceId: 'ws1',
          userId: 'u2',
          email: 'member@test.com',
          name: 'Regular Member',
          role: 'admin', // Changed to admin
          joinedAt: DateTime(2024, 1, 2),
        ),
      ];

      when(mockApiClient.get('/workspaces/ws1/members')).thenAnswer(
        (_) async => {
          'members': updatedMembers.map((m) => m.toJson()).toList(),
        },
      );

      final membersAfter = await repository.fetchMembers('ws1');

      expect(membersAfter.where((m) => m.role == 'admin').length, 2);
      expect(membersAfter.firstWhere((m) => m.id == 'm2').role, 'admin');
    });

    testWidgets('should remove member and verify removal', (tester) async {
      // Step 1: Initial members list
      final initialMembers = [
        WorkspaceMember(
          id: 'm1',
          workspaceId: 'ws1',
          userId: 'u1',
          email: 'admin@test.com',
          name: 'Admin',
          role: 'admin',
          joinedAt: DateTime(2024, 1, 1),
        ),
        WorkspaceMember(
          id: 'm2',
          workspaceId: 'ws1',
          userId: 'u2',
          email: 'toremove@test.com',
          name: 'To Remove',
          role: 'member',
          joinedAt: DateTime(2024, 1, 2),
        ),
      ];

      when(mockApiClient.get('/workspaces/ws1/members')).thenAnswer(
        (_) async => {
          'members': initialMembers.map((m) => m.toJson()).toList(),
        },
      );

      final membersBefore = await repository.fetchMembers('ws1');

      expect(membersBefore.length, 2);

      // Step 2: Remove member
      when(mockApiClient.delete('/workspaces/ws1/members/m2')).thenAnswer(
        (_) async => {'success': true},
      );

      await repository.removeMember(workspaceId: 'ws1', memberId: 'm2');

      // Step 3: Verify removal
      when(mockApiClient.get('/workspaces/ws1/members')).thenAnswer(
        (_) async => {
          'members': [initialMembers[0].toJson()],
        },
      );

      final membersAfter = await repository.fetchMembers('ws1');

      expect(membersAfter.length, 1);
      expect(membersAfter.any((m) => m.id == 'm2'), isFalse);
    });
  });

  group('Workspace Integration Tests - Leave and Delete Flow', () {
    testWidgets('should leave workspace and verify removal', (tester) async {
      // Step 1: User is member of workspace
      final members = [
        WorkspaceMember(
          id: 'm1',
          workspaceId: 'ws1',
          userId: 'u-current',
          email: 'current@test.com',
          name: 'Current User',
          role: 'member',
          joinedAt: DateTime(2024, 1, 1),
        ),
        WorkspaceMember(
          id: 'm2',
          workspaceId: 'ws1',
          userId: 'u-admin',
          email: 'admin@test.com',
          name: 'Admin User',
          role: 'admin',
          joinedAt: DateTime(2024, 1, 1),
        ),
      ];

      when(mockApiClient.get('/workspaces/ws1/members')).thenAnswer(
        (_) async => {
          'members': members.map((m) => m.toJson()).toList(),
        },
      );

      final membersBefore = await repository.fetchMembers('ws1');

      expect(membersBefore.any((m) => m.userId == 'u-current'), isTrue);

      // Step 2: Leave workspace
      when(mockApiClient.delete('/workspaces/ws1/leave')).thenAnswer(
        (_) async => {'success': true},
      );

      await repository.leaveWorkspace('ws1');

      // Step 3: Verify user is no longer a member
      when(mockApiClient.get('/workspaces/ws1/members')).thenAnswer(
        (_) async => {
          'members': [members[1].toJson()],
        },
      );

      final membersAfter = await repository.fetchMembers('ws1');

      expect(membersAfter.any((m) => m.userId == 'u-current'), isFalse);
      expect(membersAfter.length, 1);
    });
  });

  group('Workspace Integration Tests - Invite Code Management', () {
    testWidgets('should create, use, and track invite code usage', (tester) async {
      // Step 1: Create invite code with max uses
      final initialCode = InviteCode(
        id: 'ic1',
        workspaceId: 'ws1',
        code: 'TRACK1',
        createdBy: 'u-admin',
        createdAt: DateTime.now(),
        expiresAt: null,
        maxUses: 3,
        usesCount: 0,
        isRevoked: false,
      );

      when(mockApiClient.post(
        '/workspaces/ws1/invite-codes',
        data: anyNamed('data'),
      )).thenAnswer((_) async => {'inviteCode': initialCode.toJson()});

      final code = await repository.createInviteCode(
        workspaceId: 'ws1',
        maxUses: 3,
        expiresInDays: null,
      );

      expect(code.usesCount, 0);
      expect(code.maxUses, 3);

      // Step 2: Simulate first use
      when(mockApiClient.post(
        '/workspaces/join',
        data: anyNamed('data'),
      )).thenAnswer((_) async => {
            'workspace': {
              'id': 'ws1',
              'name': 'Test Workspace',
              'type': 'team',
              'createdAt': DateTime.now().toIso8601String(),
              'updatedAt': DateTime.now().toIso8601String(),
            }
          });

      await repository.joinWorkspace('TRACK1');

      // Step 3: Check usage count increased
      final updatedCode1 = InviteCode(
        id: 'ic1',
        workspaceId: 'ws1',
        code: 'TRACK1',
        createdBy: 'u-admin',
        createdAt: initialCode.createdAt,
        expiresAt: null,
        maxUses: 3,
        usesCount: 1, // Increased
        isRevoked: false,
      );

      when(mockApiClient.get('/workspaces/ws1/invite-codes')).thenAnswer(
        (_) async => {
          'inviteCodes': [updatedCode1.toJson()],
        },
      );

      final codes1 = await repository.fetchInviteCodes('ws1');
      expect(codes1.first.usesCount, 1);

      // Step 4: Use code until max uses reached
      for (int i = 1; i < 3; i++) {
        await repository.joinWorkspace('TRACK1');
      }

      final maxedOutCode = InviteCode(
        id: 'ic1',
        workspaceId: 'ws1',
        code: 'TRACK1',
        createdBy: 'u-admin',
        createdAt: initialCode.createdAt,
        expiresAt: null,
        maxUses: 3,
        usesCount: 3, // Maxed out
        isRevoked: false,
      );

      when(mockApiClient.get('/workspaces/ws1/invite-codes')).thenAnswer(
        (_) async => {
          'inviteCodes': [maxedOutCode.toJson()],
        },
      );

      final finalCodes = await repository.fetchInviteCodes('ws1');
      expect(finalCodes.first.usesCount, 3);
      expect(finalCodes.first.maxUses, 3);
    });

    testWidgets('should revoke invite code and prevent further use', (tester) async {
      // Step 1: Create active invite code
      final activeCode = InviteCode(
        id: 'ic-revoke',
        workspaceId: 'ws1',
        code: 'REVOKE',
        createdBy: 'u-admin',
        createdAt: DateTime.now(),
        expiresAt: null,
        maxUses: null,
        usesCount: 0,
        isRevoked: false,
      );

      when(mockApiClient.post(
        '/workspaces/ws1/invite-codes',
        data: anyNamed('data'),
      )).thenAnswer((_) async => {'inviteCode': activeCode.toJson()});

      await repository.createInviteCode(
        workspaceId: 'ws1',
        maxUses: null,
        expiresInDays: null,
      );

      // Step 2: Revoke the code
      when(mockApiClient.delete('/workspaces/ws1/invite-codes/ic-revoke')).thenAnswer(
        (_) async => {'success': true},
      );

      await repository.revokeInviteCode(
        workspaceId: 'ws1',
        codeId: 'ic-revoke',
      );

      // Step 3: Verify code is revoked
      final revokedCode = InviteCode(
        id: 'ic-revoke',
        workspaceId: 'ws1',
        code: 'REVOKE',
        createdBy: 'u-admin',
        createdAt: activeCode.createdAt,
        expiresAt: null,
        maxUses: null,
        usesCount: 0,
        isRevoked: true, // Now revoked
      );

      when(mockApiClient.get('/workspaces/ws1/invite-codes')).thenAnswer(
        (_) async => {
          'inviteCodes': [revokedCode.toJson()],
        },
      );

      final codes = await repository.fetchInviteCodes('ws1');
      expect(codes.first.isRevoked, isTrue);

      // Step 4: Try to use revoked code (should fail)
      when(mockApiClient.post(
        '/workspaces/join',
        data: anyNamed('data'),
      )).thenThrow(Exception('Invite code has been revoked'));

      expect(
        () => repository.joinWorkspace('REVOKE'),
        throwsException,
      );
    });
  });

  group('Workspace Integration Tests - Settings and Deletion', () {
    testWidgets('should update workspace settings and verify changes', (tester) async {
      // Step 1: Get initial workspace
      final initialWorkspace = api_models.Workspace(
        id: 'ws1',
        name: 'Old Name',
        description: 'Old description',
        type: 'team',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      when(mockApiClient.get('/workspaces')).thenAnswer(
        (_) async => {
          'workspaces': [initialWorkspace.toJson()],
        },
      );

      final workspacesBefore = await repository.fetchWorkspaces();
      expect(workspacesBefore.first.name, 'Old Name');

      // Step 2: Update workspace settings
      final updatedWorkspace = api_models.Workspace(
        id: 'ws1',
        name: 'New Name',
        description: 'New description',
        type: 'team',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime.now(),
      );

      when(mockApiClient.patch(
        '/workspaces/ws1',
        data: anyNamed('data'),
      )).thenAnswer((_) async => {'workspace': updatedWorkspace.toJson()});

      final updated = await repository.updateWorkspace(
        workspaceId: 'ws1',
        name: 'New Name',
        description: 'New description',
      );

      expect(updated.name, 'New Name');
      expect(updated.description, 'New description');

      // Step 3: Verify changes persist
      when(mockApiClient.get('/workspaces')).thenAnswer(
        (_) async => {
          'workspaces': [updatedWorkspace.toJson()],
        },
      );

      final workspacesAfter = await repository.fetchWorkspaces();
      expect(workspacesAfter.first.name, 'New Name');
      expect(workspacesAfter.first.description, 'New description');
    });

    testWidgets('should delete workspace and verify removal', (tester) async {
      // Step 1: Workspace exists
      final workspace = api_models.Workspace(
        id: 'ws-delete',
        name: 'To Delete',
        description: 'Will be deleted',
        type: 'team',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      when(mockApiClient.get('/workspaces')).thenAnswer(
        (_) async => {
          'workspaces': [workspace.toJson()],
        },
      );

      final workspacesBefore = await repository.fetchWorkspaces();
      expect(workspacesBefore.any((w) => w.id == 'ws-delete'), isTrue);

      // Step 2: Delete workspace
      when(mockApiClient.delete('/workspaces/ws-delete')).thenAnswer(
        (_) async => {'success': true},
      );

      await repository.deleteWorkspace('ws-delete');

      // Step 3: Verify workspace is removed
      when(mockApiClient.get('/workspaces')).thenAnswer(
        (_) async => {
          'workspaces': [],
        },
      );

      final workspacesAfter = await repository.fetchWorkspaces();
      expect(workspacesAfter.any((w) => w.id == 'ws-delete'), isFalse);
      expect(workspacesAfter, isEmpty);
    });
  });
}

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

import 'workspace_integration_test.mocks.dart';

Response<T> _res<T>(T data) => Response<T>(
      data: data,
      requestOptions: RequestOptions(path: ''),
    );

@GenerateMocks([AppDatabase, ApiClient])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
    testWidgets('should create workspace and verify API call', (tester) async {
      final newWorkspace = api_models.Workspace(
        id: 'ws-new',
        name: 'Marketing Team',
        type: api_models.WorkspaceType.team,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      when(mockApiClient.post(
        '/workspaces',
        data: anyNamed('data'),
      )).thenAnswer((_) async => _res({'workspace': newWorkspace.toJson()}));

      expect(repository, isNotNull);
    });

    testWidgets('should join workspace with code and become member', (tester) async {
      final inviteCode = InviteCode(
        id: 'ic1',
        workspaceId: 'ws1',
        code: 'JOIN99',
        createdBy: 'u-admin',
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 7)),
        maxUses: 10,
        currentUses: 0,
      );

      when(mockApiClient.post(
        '/invites',
        data: anyNamed('data'),
      )).thenAnswer((_) async => _res({'invite': inviteCode.toJson()}));

      final createdCode = await repository.createInviteCode(
        workspaceId: 'ws1',
        maxUses: 10,
        expiresAt: DateTime.now().add(const Duration(days: 7)),
      );

      expect(createdCode.code, 'JOIN99');

      final members = [
        WorkspaceMember(
          id: 'm1',
          workspaceId: 'ws1',
          userId: 'u-new-member',
          userEmail: 'newmember@test.com',
          userName: 'New Member',
          role: 'member',
          joinedAt: DateTime.now(),
        ),
      ];

      when(mockApiClient.get('/workspaces/ws1/members')).thenAnswer(
        (_) async => _res({
          'members': members.map((m) => m.toJson()).toList(),
        }),
      );

      final workspaceMembers = await repository.fetchMembers('ws1');

      expect(workspaceMembers, isNotEmpty);
      expect(workspaceMembers.any((m) => m.userId == 'u-new-member'), isTrue);
      expect(workspaceMembers.first.role, 'member');
    });
  });

  group('Workspace Integration Tests - Member Management Flow', () {
    testWidgets('should change member role and verify update', (tester) async {
      final initialMembers = [
        WorkspaceMember(
          id: 'm1',
          workspaceId: 'ws1',
          userId: 'u1',
          userEmail: 'admin@test.com',
          userName: 'Admin',
          role: 'admin',
          joinedAt: DateTime(2024, 1, 1),
        ),
        WorkspaceMember(
          id: 'm2',
          workspaceId: 'ws1',
          userId: 'u2',
          userEmail: 'member@test.com',
          userName: 'Regular Member',
          role: 'member',
          joinedAt: DateTime(2024, 1, 2),
        ),
      ];

      when(mockApiClient.get('/workspaces/ws1/members')).thenAnswer(
        (_) async => _res({
          'members': initialMembers.map((m) => m.toJson()).toList(),
        }),
      );

      final membersBefore = await repository.fetchMembers('ws1');

      expect(membersBefore.length, 2);
      expect(membersBefore.where((m) => m.role == 'admin').length, 1);

      final promotedMember = WorkspaceMember(
        id: 'm2',
        workspaceId: 'ws1',
        userId: 'u2',
        userEmail: 'member@test.com',
        userName: 'Regular Member',
        role: 'admin',
        joinedAt: DateTime(2024, 1, 2),
      );

      when(mockApiClient.patch(
        '/workspaces/ws1/members/m2/role',
        data: anyNamed('data'),
      )).thenAnswer((_) async => _res({'member': promotedMember.toJson()}));

      final updatedRole = await repository.changeMemberRole(
        workspaceId: 'ws1',
        memberId: 'm2',
        role: 'admin',
      );

      expect(updatedRole.role, 'admin');

      final updatedMembers = [
        initialMembers[0],
        promotedMember,
      ];

      when(mockApiClient.get('/workspaces/ws1/members')).thenAnswer(
        (_) async => _res({
          'members': updatedMembers.map((m) => m.toJson()).toList(),
        }),
      );

      final membersAfter = await repository.fetchMembers('ws1');

      expect(membersAfter.where((m) => m.role == 'admin').length, 2);
      expect(membersAfter.firstWhere((m) => m.id == 'm2').role, 'admin');
    });

    testWidgets('should remove member and verify removal', (tester) async {
      final initialMembers = [
        WorkspaceMember(
          id: 'm1',
          workspaceId: 'ws1',
          userId: 'u1',
          userEmail: 'admin@test.com',
          userName: 'Admin',
          role: 'admin',
          joinedAt: DateTime(2024, 1, 1),
        ),
        WorkspaceMember(
          id: 'm2',
          workspaceId: 'ws1',
          userId: 'u2',
          userEmail: 'toremove@test.com',
          userName: 'To Remove',
          role: 'member',
          joinedAt: DateTime(2024, 1, 2),
        ),
      ];

      when(mockApiClient.get('/workspaces/ws1/members')).thenAnswer(
        (_) async => _res({
          'members': initialMembers.map((m) => m.toJson()).toList(),
        }),
      );

      final membersBefore = await repository.fetchMembers('ws1');

      expect(membersBefore.length, 2);

      when(mockApiClient.delete('/workspaces/ws1/members/m2')).thenAnswer(
        (_) async => _res({'success': true}),
      );

      await repository.removeMember(workspaceId: 'ws1', memberId: 'm2');

      when(mockApiClient.get('/workspaces/ws1/members')).thenAnswer(
        (_) async => _res({
          'members': [initialMembers[0].toJson()],
        }),
      );

      final membersAfter = await repository.fetchMembers('ws1');

      expect(membersAfter.length, 1);
      expect(membersAfter.any((m) => m.id == 'm2'), isFalse);
    });
  });

  group('Workspace Integration Tests - Leave and Delete Flow', () {
    testWidgets('should handle leave workspace', (tester) async {
      final members = [
        WorkspaceMember(
          id: 'm1',
          workspaceId: 'ws1',
          userId: 'u-current',
          userEmail: 'current@test.com',
          userName: 'Current User',
          role: 'member',
          joinedAt: DateTime(2024, 1, 1),
        ),
        WorkspaceMember(
          id: 'm2',
          workspaceId: 'ws1',
          userId: 'u-admin',
          userEmail: 'admin@test.com',
          userName: 'Admin User',
          role: 'admin',
          joinedAt: DateTime(2024, 1, 1),
        ),
      ];

      when(mockApiClient.get('/workspaces/ws1/members')).thenAnswer(
        (_) async => _res({
          'members': members.map((m) => m.toJson()).toList(),
        }),
      );

      final membersBefore = await repository.fetchMembers('ws1');

      expect(membersBefore.any((m) => m.userId == 'u-current'), isTrue);
    });
  });

  group('Workspace Integration Tests - Invite Code Management', () {
    testWidgets('should create and fetch invite codes', (tester) async {
      final initialCode = InviteCode(
        id: 'ic1',
        workspaceId: 'ws1',
        code: 'TRACK1',
        createdBy: 'u-admin',
        createdAt: DateTime.now(),
        expiresAt: null,
        maxUses: 3,
        currentUses: 0,
      );

      when(mockApiClient.post(
        '/invites',
        data: anyNamed('data'),
      )).thenAnswer((_) async => _res({'invite': initialCode.toJson()}));

      final code = await repository.createInviteCode(
        workspaceId: 'ws1',
        maxUses: 3,
        expiresAt: null,
      );

      expect(code.usesCount, 0);
      expect(code.maxUses, 3);

      final updatedCode1 = InviteCode(
        id: 'ic1',
        workspaceId: 'ws1',
        code: 'TRACK1',
        createdBy: 'u-admin',
        createdAt: initialCode.createdAt,
        expiresAt: null,
        maxUses: 3,
        currentUses: 1,
      );

      when(mockApiClient.get(
        '/invites',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer(
        (_) async => _res({
          'invites': [updatedCode1.toJson()],
        }),
      );

      final codes1 = await repository.fetchInviteCodes('ws1');
      expect(codes1.first.usesCount, 1);
    });

    testWidgets('should revoke invite code', (tester) async {
      final activeCode = InviteCode(
        id: 'ic-revoke',
        workspaceId: 'ws1',
        code: 'REVOKE',
        createdBy: 'u-admin',
        createdAt: DateTime.now(),
        expiresAt: null,
        maxUses: null,
        currentUses: 0,
      );

      when(mockApiClient.post(
        '/invites',
        data: anyNamed('data'),
      )).thenAnswer((_) async => _res({'invite': activeCode.toJson()}));

      await repository.createInviteCode(
        workspaceId: 'ws1',
        maxUses: null,
        expiresAt: null,
      );

      when(mockApiClient.delete('/invites/ic-revoke')).thenAnswer(
        (_) async => _res({'success': true}),
      );

      await repository.revokeInviteCode('ic-revoke');

      verify(mockApiClient.delete('/invites/ic-revoke')).called(1);
    });
  });
}

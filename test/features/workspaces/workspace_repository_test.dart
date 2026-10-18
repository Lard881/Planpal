import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/core/db/app_database.dart';
import 'package:planpal/features/workspaces/data/workspace_repository.dart';

void main() {
  test('uses cached workspaces when the API is offline', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final createdAt = DateTime(2026, 7, 14);
    await database
        .into(database.workspaces)
        .insert(
          WorkspacesCompanion.insert(
            id: 'workspace-1',
            name: 'Team workspace',
            type: 'team',
            createdBy: 'user-1',
            role: const Value('admin'),
            createdAt: createdAt,
            updatedAt: createdAt,
          ),
        );
    final dio = Dio()
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) => handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.connectionError,
            ),
          ),
        ),
      );
    final repository = WorkspaceRepository(dio, database);

    final (workspaces, failure) = await repository.getWorkspaces();

    expect(failure, isNull);
    expect(workspaces, hasLength(1));
    expect(workspaces.single.id, 'workspace-1');
    expect(workspaces.single.role, 'admin');
    expect(workspaces.single.createdAt, createdAt);
  });

  test('returns cached workspace members while offline', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final joinedAt = DateTime(2026, 7, 14);
    await database
        .into(database.workspaceMembers)
        .insert(
          WorkspaceMembersCompanion.insert(
            workspaceId: 'workspace-1',
            userId: 'user-1',
            fullName: const Value('Member One'),
            email: const Value('member@example.invalid'),
            role: const Value('admin'),
            joinedAt: Value(joinedAt),
          ),
        );
    final repository = WorkspaceRepository(Dio(), database);

    final (members, failure) = await repository.getMembers(
      'workspace-1',
      offline: true,
    );

    expect(failure, isNull);
    expect(members, hasLength(1));
    expect(members.single.userId, 'user-1');
    expect(members.single.fullName, 'Member One');
    expect(members.single.role, 'admin');
    expect(members.single.joinedAt, joinedAt);
  });
}

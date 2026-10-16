import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/core/db/app_database.dart';
import 'package:planpal/core/network/app_failure.dart';
import 'package:planpal/features/workspaces/data/workspace_repository.dart';
import 'package:planpal/features/workspaces/models/workspace_model.dart';
import 'package:planpal/features/workspaces/providers/workspace_providers.dart';

class _FailingWorkspaceRepository extends WorkspaceRepository {
  _FailingWorkspaceRepository(this.failure, AppDatabase database)
    : super(Dio(), database);

  final AppFailure failure;

  @override
  Future<(List<WorkspaceModel>, AppFailure?)> getWorkspaces() async {
    return (<WorkspaceModel>[], failure);
  }
}

void main() {
  test('workspacesProvider propagates repository failures', () async {
    final failure = NetworkFailure();
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final container = ProviderContainer(
      overrides: [
        workspaceRepositoryProvider.overrideWith(
          (ref) => _FailingWorkspaceRepository(failure, database),
        ),
      ],
    );
    addTearDown(container.dispose);

    await expectLater(
      container.read(workspacesProvider.future),
      throwsA(same(failure)),
    );
  });
}

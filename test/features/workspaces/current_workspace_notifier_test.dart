import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/features/workspaces/models/workspace_model.dart';
import 'package:planpal/features/workspaces/providers/workspace_providers.dart';

void main() {
  test(
    'does not replace a saved team selection while workspaces load',
    () async {
      final savedSelection = Completer<String?>();
      final notifier = CurrentWorkspaceNotifier(
        readWorkspaceId: () => savedSelection.future,
        writeWorkspaceId: (_) async {},
        deleteWorkspaceId: () async {},
      );

      notifier.updateAvailableWorkspaces(_workspaces);
      expect(notifier.state, isNull);

      savedSelection.complete('team-1');
      await Future<void>.delayed(Duration.zero);

      expect(notifier.state, 'team-1');
      notifier.dispose();
    },
  );

  test(
    'keeps a user workspace choice made while saved selection loads',
    () async {
      final savedSelection = Completer<String?>();
      final notifier = CurrentWorkspaceNotifier(
        readWorkspaceId: () => savedSelection.future,
        writeWorkspaceId: (_) async {},
        deleteWorkspaceId: () async {},
      );

      notifier.updateAvailableWorkspaces(_workspaces);
      await notifier.set('team-1');
      savedSelection.complete('personal-1');
      await Future<void>.delayed(Duration.zero);

      expect(notifier.state, 'team-1');
      notifier.dispose();
    },
  );

  test('uses Personal only when no saved selection is available', () async {
    final notifier = CurrentWorkspaceNotifier(
      readWorkspaceId: () async => null,
      writeWorkspaceId: (_) async {},
      deleteWorkspaceId: () async {},
    );

    notifier.updateAvailableWorkspaces(_workspaces);
    await Future<void>.delayed(Duration.zero);

    expect(notifier.state, 'personal-1');
    notifier.dispose();
  });
}

final _workspaces = [
  const WorkspaceModel(
    id: 'personal-1',
    name: 'Personal space',
    type: 'personal',
  ),
  const WorkspaceModel(
    id: 'team-1',
    name: 'Team space',
    type: 'team',
    role: 'admin',
  ),
];

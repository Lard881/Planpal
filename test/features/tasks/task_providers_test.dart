import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/features/tasks/data/task_repository.dart';
import 'package:planpal/features/tasks/models/task_model.dart';
import 'package:planpal/features/tasks/providers/task_providers.dart';
import 'package:planpal/core/network/app_failure.dart';

void main() {
  group('TaskListNotifier search', () {
    test('clearing search removes the query and active-filter state', () {
      const searched = TaskFilter(q: 'query');
      final cleared = searched.copyWith(q: null, setQ: true);

      expect(searched.hasActiveFilters, isTrue);
      expect(cleared.q, isNull);
      expect(cleared.hasActiveFilters, isFalse);
    });

    test(
      'fetches once with every active filter and keeps those results',
      () async {
        final repository = _FakeTaskRepository();
        final notifier = TaskListNotifier(repository, 'workspace-1');
        await Future<void>.delayed(Duration.zero);
        repository.calls.clear();

        final task = TaskModel(
          id: 'task-1',
          workspaceId: 'workspace-1',
          title: 'Filtered search result',
          createdBy: 'user-1',
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        );
        repository.result = [task];
        notifier.setFilter(
          const TaskFilter(
            view: 'overdue',
            status: 'in_progress',
            priority: 'high',
            assigneeId: 'user-2',
            sort: 'title',
            q: 'filtered',
          ),
        );
        await Future<void>.delayed(Duration.zero);

        expect(repository.calls, hasLength(1));
        expect(repository.calls.single, {
          'workspaceId': 'workspace-1',
          'status': 'in_progress',
          'priority': 'high',
          'assigneeId': 'user-2',
          'view': 'overdue',
          'sort': 'title',
          'q': 'filtered',
          'cursor': null,
        });
        expect(notifier.state.tasks, [task]);

        notifier.dispose();
      },
    );

    test(
      'filters cached tasks locally when the search request fails offline',
      () async {
        final cachedTasks = [
          _task(id: 'task-1', title: 'Prepare project plan'),
          _task(id: 'task-2', title: 'Review budget'),
        ];
        final repository = _FakeTaskRepository()
          ..cache = cachedTasks
          ..failure = const NetworkFailure();
        final notifier = TaskListNotifier(repository, 'workspace-1');
        await Future<void>.delayed(Duration.zero);
        repository.calls.clear();

        notifier.setFilter(const TaskFilter(q: ' project '));
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        expect(repository.calls, hasLength(1));
        expect(notifier.state.tasks.map((task) => task.id), ['task-1']);
        expect(notifier.state.error, isNotNull);

        notifier.dispose();
      },
    );

    test(
      'keeps only failed tasks selected after a partial bulk action',
      () async {
        final repository = _FakeTaskRepository()
          ..bulkResult = const BulkTaskActionResult(
            succeededIds: ['task-1'],
            failedIds: ['task-2'],
          );
        final notifier = TaskListNotifier(repository, 'workspace-1');
        await Future<void>.delayed(Duration.zero);

        notifier
          ..toggleSelect('task-1')
          ..toggleSelect('task-2');
        final result = await notifier.bulkComplete();

        expect(result.succeededIds, ['task-1']);
        expect(result.failedIds, ['task-2']);
        expect(notifier.state.selectedIds, {'task-2'});

        notifier.dispose();
      },
    );

    test('loads the next page without duplicating cached tasks', () async {
      final first = _task(id: 'task-1', title: 'First');
      final second = _task(id: 'task-2', title: 'Second');
      final repository = _FakeTaskRepository()
        ..cache = [first]
        ..nextCursor = 'first-cursor';
      final notifier = TaskListNotifier(repository, 'workspace-1');
      await Future<void>.delayed(Duration.zero);
      repository
        ..result = [first, second]
        ..nextCursor = null;

      await notifier.loadMore();

      expect(notifier.state.tasks.map((task) => task.id), ['task-1', 'task-2']);
      expect(repository.calls.last['cursor'], 'first-cursor');
      expect(notifier.state.cursor, isNull);

      notifier.dispose();
    });

    test(
      'shows tasks assigned to other members when no assignee filter is set',
      () async {
        final assignedTask = TaskModel(
          id: 'task-assigned',
          workspaceId: 'workspace-1',
          title: 'Assigned to teammate',
          assigneeId: 'user-2',
          createdBy: 'user-1',
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        );
        final repository = _FakeTaskRepository()
          ..cache = [assignedTask]
          ..result = [assignedTask];
        final notifier = TaskListNotifier(repository, 'workspace-1');
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        expect(notifier.state.filter.assigneeId, isNull);
        expect(notifier.state.tasks, [assignedTask]);

        notifier.dispose();
      },
    );

    test(
      'keeps API assignee details when the local task stream updates',
      () async {
        final cachedTask = TaskModel(
          id: 'task-assigned',
          workspaceId: 'workspace-1',
          title: 'Assigned to teammate',
          assigneeId: 'user-2',
          createdBy: 'user-1',
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        );
        final apiTask = TaskModel(
          id: cachedTask.id,
          workspaceId: cachedTask.workspaceId,
          title: cachedTask.title,
          assigneeId: 'user-2',
          assigneeName: 'Teammate',
          assigneeAvatarUrl: 'https://example.test/avatar.png',
          createdBy: cachedTask.createdBy,
          createdAt: cachedTask.createdAt,
          updatedAt: cachedTask.updatedAt,
        );
        final repository = _FakeTaskRepository()
          ..cache = [cachedTask]
          ..result = [apiTask]
          ..totalCount = 1;
        final notifier = TaskListNotifier(repository, 'workspace-1');
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        repository.emitCache();

        expect(notifier.state.totalCount, 1);
        expect(notifier.state.tasks.single.assigneeId, 'user-2');
        expect(notifier.state.tasks.single.assigneeName, 'Teammate');
        expect(
          notifier.state.tasks.single.assigneeAvatarUrl,
          'https://example.test/avatar.png',
        );

        notifier.dispose();
      },
    );

    test(
      'keeps an empty cache loading until the API request finishes',
      () async {
        final repository = _FakeTaskRepository()
          ..pendingResult =
              Completer<(List<TaskModel>, String?, AppFailure?, int?)>();
        final notifier = TaskListNotifier(repository, 'workspace-1');
        await Future<void>.delayed(Duration.zero);

        expect(notifier.state.loading, isTrue);

        repository.pendingResult!.complete((
          const <TaskModel>[],
          null,
          const NetworkFailure(),
          null,
        ));
        await Future<void>.delayed(Duration.zero);

        expect(notifier.state.loading, isFalse);
        expect(notifier.state.error, isNotNull);

        repository.emitCache();

        expect(notifier.state.error, isNotNull);
        notifier.dispose();
      },
    );
  });
}

class _FakeTaskRepository implements TaskRepository {
  final calls = <Map<String, Object?>>[];
  void Function()? _publishCache;
  List<TaskModel> result = const [];
  List<TaskModel> cache = const [];
  String? nextCursor;
  int? totalCount;
  Completer<(List<TaskModel>, String?, AppFailure?, int?)>? pendingResult;
  AppFailure? failure;
  BulkTaskActionResult bulkResult = const BulkTaskActionResult();

  @override
  Stream<List<TaskModel>> watchTasks(
    String workspaceId, {
    String? status,
    String? priority,
    String? assigneeId,
    String? view,
    String? sort,
  }) => Stream.multi((controller) {
    controller.add(cache);
    _publishCache = () => controller.add(cache);
  });

  @override
  Future<(List<TaskModel>, String?, AppFailure?, int?)> getTasks(
    String workspaceId, {
    String? status,
    String? priority,
    String? assigneeId,
    String? view,
    String? sort,
    String? cursor,
    String? q,
  }) async {
    calls.add({
      'workspaceId': workspaceId,
      'status': status,
      'priority': priority,
      'assigneeId': assigneeId,
      'view': view,
      'sort': sort,
      'q': q,
      'cursor': cursor,
    });
    final pendingResult = this.pendingResult;
    if (pendingResult != null) return pendingResult.future;
    return (result, nextCursor, failure, totalCount);
  }

  void emitCache() => _publishCache?.call();

  @override
  Future<BulkTaskActionResult> bulkAction(
    List<String> taskIds,
    String action,
  ) async => bulkResult;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

TaskModel _task({required String id, required String title}) => TaskModel(
  id: id,
  workspaceId: 'workspace-1',
  title: title,
  createdBy: 'user-1',
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

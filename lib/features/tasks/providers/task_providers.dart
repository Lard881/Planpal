// app/lib/features/tasks/providers/task_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/task_repository.dart';
import '../models/task_model.dart';
import '../../../core/network/api_client.dart';
import '../../workspaces/providers/workspace_providers.dart';

class TaskFilter {
  final String view; // all|today|week|overdue
  final String? status;
  final String? priority;
  final String? assigneeId;
  final String sort; // due_date|priority|created|title
  final String? q;

  const TaskFilter({
    this.view = 'all',
    this.status,
    this.priority,
    this.assigneeId,
    this.sort = 'due_date',
    this.q,
  });

  bool get hasActiveFilters =>
      status != null || priority != null || assigneeId != null || view != 'all';

  TaskFilter copyWith({
    String? view, String? status, String? priority,
    String? assigneeId, String? sort, String? q,
    bool clearStatus = false, bool clearPriority = false,
    bool clearAssignee = false, bool clearQ = false,
  }) => TaskFilter(
    view: view ?? this.view,
    status: clearStatus ? null : (status ?? this.status),
    priority: clearPriority ? null : (priority ?? this.priority),
    assigneeId: clearAssignee ? null : (assigneeId ?? this.assigneeId),
    sort: sort ?? this.sort,
    q: clearQ ? null : (q ?? this.q),
  );

  TaskFilter cleared() => const TaskFilter();
}

class TaskListState {
  final List<TaskModel> tasks;
  final bool loading;
  final bool loadingMore;
  final String? cursor;
  final String? error;
  final TaskFilter filter;
  final Set<String> selectedIds;

  const TaskListState({
    this.tasks = const [],
    this.loading = false,
    this.loadingMore = false,
    this.cursor,
    this.error,
    this.filter = const TaskFilter(),
    this.selectedIds = const {},
  });

  int get dueToday => tasks.where((t) => t.isToday && !t.isCompleted).length;

  TaskListState copyWith({
    List<TaskModel>? tasks, bool? loading, bool? loadingMore,
    String? cursor, String? error, TaskFilter? filter,
    Set<String>? selectedIds, bool clearError = false, bool clearCursor = false,
  }) => TaskListState(
    tasks: tasks ?? this.tasks,
    loading: loading ?? this.loading,
    loadingMore: loadingMore ?? this.loadingMore,
    cursor: clearCursor ? null : (cursor ?? this.cursor),
    error: clearError ? null : (error ?? this.error),
    filter: filter ?? this.filter,
    selectedIds: selectedIds ?? this.selectedIds,
  );
}

class TaskListNotifier extends StateNotifier<TaskListState> {
  final TaskRepository _repo;
  final String workspaceId;

  TaskListNotifier(this._repo, this.workspaceId) : super(const TaskListState()) {
    load();
  }

  Future<void> load({bool refresh = false}) async {
    if (workspaceId.isEmpty) return; // Guard
    if (refresh) {
      state = state.copyWith(loading: true, clearError: true, clearCursor: true);
    } else {
      state = state.copyWith(loading: true, clearError: true);
    }

    final f = state.filter;
    final (tasks, cursor, err) = await _repo.getTasks(
      workspaceId,
      status: f.status,
      priority: f.priority,
      assigneeId: f.assigneeId,
      view: f.view,
      sort: f.sort,
      q: f.q,
    );

    state = state.copyWith(
      tasks: tasks,
      loading: false,
      cursor: cursor,
      error: err?.message,
    );
  }

  Future<void> loadMore() async {
    if (state.cursor == null || state.loadingMore) return;
    state = state.copyWith(loadingMore: true);
    final f = state.filter;
    final (more, cursor, _) = await _repo.getTasks(
      workspaceId,
      status: f.status, priority: f.priority,
      assigneeId: f.assigneeId, view: f.view,
      sort: f.sort, q: f.q, cursor: state.cursor,
    );
    state = state.copyWith(
      tasks: [...state.tasks, ...more],
      loadingMore: false,
      cursor: cursor,
    );
  }

  void setFilter(TaskFilter filter) {
    state = state.copyWith(filter: filter);
    load(refresh: true);
  }

  void toggleSelect(String id) {
    final ids = Set<String>.from(state.selectedIds);
    if (ids.contains(id)) ids.remove(id); else ids.add(id);
    state = state.copyWith(selectedIds: ids);
  }

  void clearSelection() => state = state.copyWith(selectedIds: {});

  Future<void> bulkComplete() async {
    final ids = state.selectedIds.toList();
    await _repo.bulkAction(ids, 'complete');
    clearSelection();
    load(refresh: true);
  }

  Future<void> bulkDelete() async {
    final ids = state.selectedIds.toList();
    await _repo.bulkAction(ids, 'delete');
    clearSelection();
    load(refresh: true);
  }

  Future<void> quickComplete(String taskId) async {
    await _repo.updateTask(taskId, {'status': 'completed'});
    load(refresh: true);
  }
}

final taskListProvider = StateNotifierProvider.family
    .autoDispose<TaskListNotifier, TaskListState, String>((ref, workspaceId) {
  return TaskListNotifier(ref.watch(taskRepositoryProvider), workspaceId);
});

final currentWorkspaceTasksProvider =
    StateNotifierProvider.autoDispose<TaskListNotifier, TaskListState>((ref) {
  final wsId = ref.watch(currentWorkspaceIdProvider) ?? '';
  return TaskListNotifier(ref.watch(taskRepositoryProvider), wsId);
});

final taskDetailProvider =
    FutureProvider.family.autoDispose<TaskModel?, String>((ref, taskId) async {
  final (task, _) = await ref.watch(taskRepositoryProvider).getTask(taskId);
  return task;
});

// Labels provider — loads workspace labels for the label picker
class LabelModel {
  final String id;
  final String name;
  final String color;
  const LabelModel({required this.id, required this.name, required this.color});

  factory LabelModel.fromJson(Map<String, dynamic> j) => LabelModel(
    id: j['id'] as String,
    name: j['name'] as String,
    color: j['color'] as String? ?? '#3B82F6',
  );
}

final labelsProvider = FutureProvider.family
    .autoDispose<List<LabelModel>, String>((ref, workspaceId) async {
  if (workspaceId.isEmpty) return [];
  try {
    final dio = ref.watch(apiClientProvider).dio;
    final res = await dio.get('/workspaces/$workspaceId/labels');
    final list = (res.data['labels'] as List)
        .map((l) => LabelModel.fromJson(l as Map<String, dynamic>))
        .toList();
    return list;
  } catch (_) {
    return [];
  }
});

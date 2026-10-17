import 'dart:async';
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
  final String sort; // due_at|priority|created_at|title
  final String? q;

  const TaskFilter({
    this.view = 'all',
    this.status,
    this.priority,
    this.assigneeId,
    this.sort = 'due_at',
    this.q,
  });

  bool get hasActiveFilters =>
      status != null ||
      priority != null ||
      assigneeId != null ||
      view != 'all' ||
      (q?.trim().isNotEmpty ?? false);

  TaskFilter copyWith({
    String? view,
    String? status,
    String? priority,
    String? assigneeId,
    String? sort,
    String? q,
    bool clearStatus = false,
    bool clearPriority = false,
    bool clearAssignee = false,
    bool clearQ = false,
    bool setQ = false,
  }) => TaskFilter(
    view: view ?? this.view,
    status: clearStatus ? null : (status ?? this.status),
    priority: clearPriority ? null : (priority ?? this.priority),
    assigneeId: clearAssignee ? null : (assigneeId ?? this.assigneeId),
    sort: sort ?? this.sort,
    q: clearQ ? null : (setQ ? q : (q ?? this.q)),
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
    List<TaskModel>? tasks,
    bool? loading,
    bool? loadingMore,
    String? cursor,
    String? error,
    TaskFilter? filter,
    Set<String>? selectedIds,
    bool clearError = false,
    bool clearCursor = false,
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
  StreamSubscription<List<TaskModel>>? _streamSub;

  TaskListNotifier(this._repo, this.workspaceId)
    : super(const TaskListState()) {
    _subscribeToCache();
    _fetchFromApi();
  }

  // A3: Subscribe to Drift stream — shows cached tasks instantly with no spinner
  void _subscribeToCache() {
    if (workspaceId.isEmpty) return;
    final f = state.filter;
    _streamSub?.cancel();
    _streamSub = _repo
        .watchTasks(
          workspaceId,
          status: f.status,
          priority: f.priority,
          assigneeId: f.assigneeId,
          view: f.view,
          sort: f.sort,
        )
        .listen((tasks) {
          final query = f.q?.trim().toLowerCase();
          final visibleTasks = query == null || query.isEmpty
              ? tasks
              : tasks
                    .where(
                      (task) =>
                          task.title.toLowerCase().contains(query) ||
                          task.description.toLowerCase().contains(query),
                    )
                    .toList();
          state = state.copyWith(
            tasks: visibleTasks,
            loading: false,
            clearError: true,
          );
        });
  }

  bool _shouldHideConnectivityError(String? message) {
    if (message == null) return false;
    return const [
      '__PLANPAL_API_ERROR__:NETWORK',
      '__PLANPAL_API_ERROR__:TIMEOUT',
      '__PLANPAL_API_ERROR__:SERVER_UNREACHABLE',
    ].any(message.startsWith);
  }

  // A3: Fetch from API in background — merges into Drift, stream updates UI
  Future<void> _fetchFromApi() async {
    if (workspaceId.isEmpty) return;
    state = state.copyWith(
      loading: state.tasks.isEmpty,
    ); // only show spinner if cache empty
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
    final shouldHideConnectivityError =
        _shouldHideConnectivityError(err?.message) && state.tasks.isNotEmpty;
    final nextError = shouldHideConnectivityError ? null : err?.message;
    // If there's a search query, update state directly (not via stream)
    if (f.q != null) {
      state = state.copyWith(
        tasks: err == null ? tasks : null,
        loading: false,
        cursor: cursor,
        error: nextError,
        clearError: err == null,
      );
    } else {
      state = state.copyWith(
        loading: false,
        cursor: cursor,
        error: nextError,
      );
    }
  }

  Future<void> load({bool refresh = false}) async {
    if (workspaceId.isEmpty) return;
    if (refresh) {
      state = state.copyWith(
        loading: true,
        clearError: true,
        clearCursor: true,
      );
      _subscribeToCache(); // re-subscribe with updated filter
    }
    await _fetchFromApi();
  }

  Future<void> loadMore() async {
    if (state.cursor == null || state.loadingMore) return;
    state = state.copyWith(loadingMore: true);
    final f = state.filter;
    final (more, cursor, error) = await _repo.getTasks(
      workspaceId,
      status: f.status,
      priority: f.priority,
      assigneeId: f.assigneeId,
      view: f.view,
      sort: f.sort,
      q: f.q,
      cursor: state.cursor,
    );
    if (error != null) {
      state = state.copyWith(loadingMore: false, error: error.message);
      return;
    }
    final existingIds = state.tasks.map((task) => task.id).toSet();
    state = state.copyWith(
      tasks: [
        ...state.tasks,
        ...more.where((task) => existingIds.add(task.id)),
      ],
      loadingMore: false,
      cursor: cursor,
      clearCursor: cursor == null,
      clearError: true,
    );
  }

  void setFilter(TaskFilter filter) {
    state = state.copyWith(filter: filter);
    load(refresh: true);
  }

  void toggleSelect(String id) {
    final ids = Set<String>.from(state.selectedIds);
    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }
    state = state.copyWith(selectedIds: ids);
  }

  void clearSelection() => state = state.copyWith(selectedIds: {});

  Future<BulkTaskActionResult> bulkComplete() => _performBulkAction('complete');

  Future<BulkTaskActionResult> bulkDelete() => _performBulkAction('delete');

  Future<BulkTaskActionResult> _performBulkAction(String action) async {
    final ids = state.selectedIds.toList();
    final result = await _repo.bulkAction(ids, action);
    if (result.succeededIds.isNotEmpty) {
      final remainingIds = Set<String>.from(state.selectedIds)
        ..removeAll(result.succeededIds);
      state = state.copyWith(selectedIds: remainingIds);
      await load(refresh: true);
    }
    return result;
  }

  Future<void> quickComplete(String taskId) async {
    await _repo.updateTask(taskId, {'status': 'completed'});
    await _fetchFromApi(); // refresh from API to get server-confirmed state
  }

  @override
  void dispose() {
    _streamSub?.cancel();
    super.dispose();
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

final taskDetailProvider = FutureProvider.family
    .autoDispose<TaskModel?, String>((ref, taskId) async {
      final (task, failure) = await ref
          .watch(taskRepositoryProvider)
          .getTask(taskId);
      if (task == null && failure != null) {
        throw failure;
      }
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
      final dio = ref.watch(apiClientProvider).dio;
      final res = await dio.get('/workspaces/$workspaceId/labels');
      return (res.data['labels'] as List)
          .map((l) => LabelModel.fromJson(l as Map<String, dynamic>))
          .toList();
    });

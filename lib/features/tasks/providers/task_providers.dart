import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/task_repository.dart';
import '../models/task_model.dart';
import '../../../core/connectivity/connectivity_service.dart';
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
  final int? totalCount;
  final String? error;
  final TaskFilter filter;
  final Set<String> selectedIds;

  const TaskListState({
    this.tasks = const [],
    this.loading = false,
    this.loadingMore = false,
    this.cursor,
    this.totalCount,
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
    int? totalCount,
    String? error,
    TaskFilter? filter,
    Set<String>? selectedIds,
    bool clearError = false,
    bool clearCursor = false,
    bool clearTotalCount = false,
  }) => TaskListState(
    tasks: tasks ?? this.tasks,
    loading: loading ?? this.loading,
    loadingMore: loadingMore ?? this.loadingMore,
    cursor: clearCursor ? null : (cursor ?? this.cursor),
    totalCount: clearTotalCount ? null : (totalCount ?? this.totalCount),
    error: clearError ? null : (error ?? this.error),
    filter: filter ?? this.filter,
    selectedIds: selectedIds ?? this.selectedIds,
  );
}

class TaskListNotifier extends StateNotifier<TaskListState> {
  final TaskRepository _repo;
  final String workspaceId;
  StreamSubscription<List<TaskModel>>? _streamSub;
  int _fetchRevision = 0;
  TaskModel? _recentlyCreatedTask;

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
          final knownTasks = {for (final task in state.tasks) task.id: task};
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
            tasks: visibleTasks.map((task) {
              final knownTask = knownTasks[task.id];
              if (knownTask == null) return task;
              return TaskModel(
                id: task.id,
                workspaceId: task.workspaceId,
                title: task.title,
                description: task.description,
                status: task.status,
                priority: task.priority,
                dueAt: task.dueAt,
                reminderMinutesBefore: task.reminderMinutesBefore,
                assigneeId: task.assigneeId,
                assigneeName: task.assigneeId == knownTask.assigneeId
                    ? knownTask.assigneeName
                    : null,
                assigneeAvatarUrl: task.assigneeId == knownTask.assigneeId
                    ? knownTask.assigneeAvatarUrl
                    : null,
                labelId: task.labelId,
                labelName: task.labelId == knownTask.labelId
                    ? knownTask.labelName
                    : null,
                labelColor: task.labelId == knownTask.labelId
                    ? knownTask.labelColor
                    : null,
                createdBy: task.createdBy,
                completedAt: task.completedAt,
                createdAt: task.createdAt,
                updatedAt: task.updatedAt,
              );
            }).toList(),
            loading: state.loading && visibleTasks.isEmpty,
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
    final fetchRevision = ++_fetchRevision;
    state = state.copyWith(
      loading: state.tasks.isEmpty,
    ); // only show spinner if cache empty
    final f = state.filter;
    final (tasks, cursor, err, totalCount) = await _repo.getTasks(
      workspaceId,
      status: f.status,
      priority: f.priority,
      assigneeId: f.assigneeId,
      view: f.view,
      sort: f.sort,
      q: f.q,
    );
    if (fetchRevision != _fetchRevision) return;
    final shouldHideConnectivityError =
        _shouldHideConnectivityError(err?.message) && state.tasks.isNotEmpty;
    final nextError = shouldHideConnectivityError ? null : err?.message;
    final visibleTasks = err == null ? _includeRecentTask(tasks) : null;
    state = state.copyWith(
      tasks: visibleTasks,
      loading: false,
      cursor: cursor,
      totalCount: totalCount,
      error: nextError,
      clearError: err == null,
    );
  }

  List<TaskModel> _includeRecentTask(List<TaskModel> tasks) {
    final recentTask = _recentlyCreatedTask;
    if (recentTask == null) return tasks;
    if (tasks.any((task) => task.id == recentTask.id)) {
      _recentlyCreatedTask = null;
      return tasks;
    }
    return [...tasks, recentTask];
  }

  void includeCreatedTask(TaskModel task) {
    if (task.workspaceId != workspaceId) return;
    _recentlyCreatedTask = task;
    if (state.tasks.any((existing) => existing.id == task.id)) return;
    state = state.copyWith(tasks: [...state.tasks, task]);
  }

  Future<void> load({bool refresh = false}) async {
    if (workspaceId.isEmpty) return;
    if (refresh) {
      state = state.copyWith(
        loading: true,
        loadingMore: false,
        clearError: true,
        clearCursor: true,
        clearTotalCount: true,
      );
      _subscribeToCache(); // re-subscribe with updated filter
    }
    await _fetchFromApi();
  }

  Future<void> loadMore() async {
    if (state.cursor == null || state.loadingMore) return;
    final fetchRevision = _fetchRevision;
    state = state.copyWith(loadingMore: true);
    final f = state.filter;
    final (more, cursor, error, totalCount) = await _repo.getTasks(
      workspaceId,
      status: f.status,
      priority: f.priority,
      assigneeId: f.assigneeId,
      view: f.view,
      sort: f.sort,
      q: f.q,
      cursor: state.cursor,
    );
    if (fetchRevision != _fetchRevision) return;
    if (error != null) {
      state = state.copyWith(loadingMore: false, error: error.message);
      return;
    }
    final visibleMore = _includeRecentTask(more);
    final existingIds = state.tasks.map((task) => task.id).toSet();
    state = state.copyWith(
      tasks: [
        ...state.tasks,
        ...visibleMore.where((task) => existingIds.add(task.id)),
      ],
      loadingMore: false,
      cursor: cursor,
      totalCount: totalCount,
      clearCursor: cursor == null,
      clearError: true,
    );
  }

  void setFilter(TaskFilter filter) {
    _recentlyCreatedTask = null;
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
          .getTask(taskId, offline: !ref.watch(isOnlineProvider));
      if (task == null && failure != null) {
        throw failure;
      }
      return task;
    });

// Labels provider — loads workspace labels for the label picker
typedef LabelModel = TaskLabelModel;

final labelsProvider = FutureProvider.family
    .autoDispose<List<LabelModel>, String>((ref, workspaceId) async {
      if (workspaceId.isEmpty) return [];
      final offline = !ref.watch(isOnlineProvider);
      final (labels, failure) = await ref
          .watch(taskRepositoryProvider)
          .getLabels(workspaceId, offline: offline);
      if (failure != null) throw failure;
      return labels;
    });

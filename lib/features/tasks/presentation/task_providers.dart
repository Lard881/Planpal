import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../repositories/task_repository.dart';
import '../../../core/db/app_database.dart';

/// Task list provider for a workspace
/// Returns stream of tasks filtered by workspace
final taskListProvider = StreamProvider.family<List<Task>, String>((ref, workspaceId) {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.watchTasks(workspaceId);
});

/// Filtered task list provider
final filteredTaskListProvider = StreamProvider.family<List<Task>, TaskFilter>((ref, filter) {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.watchTasksFiltered(
    workspaceId: filter.workspaceId,
    projectId: filter.projectId,
    assigneeId: filter.assigneeId,
    status: filter.status,
    view: filter.view,
  );
});

/// Single task provider
final taskProvider = StreamProvider.family<Task?, String>((ref, taskId) {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.watchTask(taskId);
});

/// Fetch and sync tasks from API
/// This is called manually to sync with server
final fetchTasksProvider = FutureProvider.family<List<Task>, String>((ref, workspaceId) async {
  final repository = ref.watch(taskRepositoryProvider);
  return await repository.fetchAndSyncTasks(workspaceId: workspaceId);
});

/// Task actions notifier
class TaskActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final TaskRepository _repository;

  TaskActionsNotifier(this._repository) : super(const AsyncValue.data(null));

  /// Create a new task
  Future<Task?> createTask({
    required String workspaceId,
    required String title,
    String? projectId,
    String? description,
    String? status,
    String? priority,
    DateTime? dueDate,
    String? assigneeId,
    List<String>? labelIds,
  }) async {
    state = const AsyncValue.loading();
    try {
      final task = await _repository.createTask(
        workspaceId: workspaceId,
        title: title,
        projectId: projectId,
        description: description,
        status: status,
        priority: priority,
        dueDate: dueDate,
        assigneeId: assigneeId,
        labelIds: labelIds,
      );
      state = const AsyncValue.data(null);
      return task;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  /// Update a task
  Future<bool> updateTask(String taskId, TasksCompanion updates) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateTask(taskId, updates);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Delete a task
  Future<bool> deleteTask(String taskId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteTask(taskId);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Toggle task completion
  Future<bool> toggleComplete(String taskId, bool isCompleted) async {
    state = const AsyncValue.loading();
    try {
      await _repository.toggleComplete(taskId, isCompleted);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Fetch and sync tasks from server
  Future<bool> syncTasks(String workspaceId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.fetchAndSyncTasks(workspaceId: workspaceId);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}

/// Task actions provider
final taskActionsProvider = StateNotifierProvider<TaskActionsNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskActionsNotifier(repository);
});

/// Task filter model
class TaskFilter {
  final String workspaceId;
  final String? projectId;
  final String? assigneeId;
  final String? status;
  final TaskView? view;

  const TaskFilter({
    required this.workspaceId,
    this.projectId,
    this.assigneeId,
    this.status,
    this.view,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskFilter &&
        other.workspaceId == workspaceId &&
        other.projectId == projectId &&
        other.assigneeId == assigneeId &&
        other.status == status &&
        other.view == view;
  }

  @override
  int get hashCode {
    return Object.hash(workspaceId, projectId, assigneeId, status, view);
  }
}

/// Task view enum
enum TaskView {
  all('all'),
  today('today'),
  week('week'),
  overdue('overdue'),
  completed('completed');

  final String value;
  const TaskView(this.value);
}

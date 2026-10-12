import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/db/app_database.dart';
import '../models/task.dart' show TaskView;
export '../../../core/providers/app_providers.dart' show taskRepositoryProvider;

/// Watch tasks for a workspace (reactive stream)
final watchTasksProvider = StreamProvider.autoDispose
    .family<List<Task>, String>((ref, workspaceId) {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.watchTasks(workspaceId);
});

/// Watch filtered tasks (S7.14)
final filteredTasksProvider = StreamProvider.autoDispose.family<
    List<Task>,
    ({
      String workspaceId,
      TaskView? view,
      String? searchQuery,
      String? status,
      String? assigneeId,
    })>((ref, params) {
  final repository = ref.watch(taskRepositoryProvider);

  var stream = repository.watchTasksFiltered(
    workspaceId: params.workspaceId,
    view: params.view,
    status: params.status,
    assigneeId: params.assigneeId,
  );

  // Apply search filter in Dart (local filtering)
  if (params.searchQuery != null && params.searchQuery!.isNotEmpty) {
    stream = stream.map((tasks) {
      final query = params.searchQuery!.toLowerCase();
      return tasks
          .where((task) =>
              task.title.toLowerCase().contains(query) ||
              task.description.toLowerCase().contains(query))
          .toList();
    });
  }

  return stream;
});

/// Watch a single task
final watchTaskProvider =
    StreamProvider.autoDispose.family<Task?, String>((ref, taskId) {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.watchTask(taskId);
});

/// Get a single task (one-time read)
final getTaskProvider =
    FutureProvider.autoDispose.family<Task?, String>((ref, taskId) {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.getTask(taskId);
});


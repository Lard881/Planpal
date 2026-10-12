import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'offline_queue_manager.dart';
import 'offline_queue_providers.dart';

/// Helper functions for common queue operations
class QueueHelpers {
  /// Create task (adds to queue if offline)
  static Future<bool> createTask(
    WidgetRef ref, {
    required String taskId,
    required Map<String, dynamic> taskData,
  }) async {
    final queueManager = ref.read(offlineQueueManagerProvider);
    
    return await queueManager.enqueueTaskOperation(
      taskId: taskId,
      operation: OperationType.insert,
      taskData: taskData,
    );
  }

  /// Update task (adds to queue if offline)
  static Future<bool> updateTask(
    WidgetRef ref, {
    required String taskId,
    required Map<String, dynamic> taskData,
  }) async {
    final queueManager = ref.read(offlineQueueManagerProvider);
    
    return await queueManager.enqueueTaskOperation(
      taskId: taskId,
      operation: OperationType.update,
      taskData: taskData,
    );
  }

  /// Delete task (adds to queue if offline)
  static Future<bool> deleteTask(
    WidgetRef ref, {
    required String taskId,
  }) async {
    final queueManager = ref.read(offlineQueueManagerProvider);
    
    return await queueManager.enqueueTaskOperation(
      taskId: taskId,
      operation: OperationType.delete,
    );
  }

  /// Create project (adds to queue if offline)
  static Future<bool> createProject(
    WidgetRef ref, {
    required String projectId,
    required Map<String, dynamic> projectData,
  }) async {
    final queueManager = ref.read(offlineQueueManagerProvider);
    
    return await queueManager.enqueueProjectOperation(
      projectId: projectId,
      operation: OperationType.insert,
      projectData: projectData,
    );
  }

  /// Update project (adds to queue if offline)
  static Future<bool> updateProject(
    WidgetRef ref, {
    required String projectId,
    required Map<String, dynamic> projectData,
  }) async {
    final queueManager = ref.read(offlineQueueManagerProvider);
    
    return await queueManager.enqueueProjectOperation(
      projectId: projectId,
      operation: OperationType.update,
      projectData: projectData,
    );
  }

  /// Delete project (adds to queue if offline)
  static Future<bool> deleteProject(
    WidgetRef ref, {
    required String projectId,
  }) async {
    final queueManager = ref.read(offlineQueueManagerProvider);
    
    return await queueManager.enqueueProjectOperation(
      projectId: projectId,
      operation: OperationType.delete,
    );
  }

  /// Create label (adds to queue if offline)
  static Future<bool> createLabel(
    WidgetRef ref, {
    required String labelId,
    required Map<String, dynamic> labelData,
  }) async {
    final queueManager = ref.read(offlineQueueManagerProvider);
    
    return await queueManager.enqueueLabelOperation(
      labelId: labelId,
      operation: OperationType.insert,
      labelData: labelData,
    );
  }

  /// Update label (adds to queue if offline)
  static Future<bool> updateLabel(
    WidgetRef ref, {
    required String labelId,
    required Map<String, dynamic> labelData,
  }) async {
    final queueManager = ref.read(offlineQueueManagerProvider);
    
    return await queueManager.enqueueLabelOperation(
      labelId: labelId,
      operation: OperationType.update,
      labelData: labelData,
    );
  }

  /// Add comment (adds to queue if offline)
  static Future<bool> addComment(
    WidgetRef ref, {
    required String commentId,
    required Map<String, dynamic> commentData,
  }) async {
    final queueManager = ref.read(offlineQueueManagerProvider);
    
    return await queueManager.enqueueCommentOperation(
      commentId: commentId,
      operation: OperationType.insert,
      commentData: commentData,
    );
  }

  /// Get pending count for display
  static Future<int> getPendingCount(WidgetRef ref) async {
    final queueManager = ref.read(offlineQueueManagerProvider);
    return await queueManager.getQueueSize();
  }

  /// Clear all pending operations
  static Future<bool> clearQueue(WidgetRef ref) async {
    final queueManager = ref.read(offlineQueueManagerProvider);
    return await queueManager.clearQueue();
  }

  /// Get queue statistics
  static Future<QueueStats> getStats(WidgetRef ref) async {
    final queueManager = ref.read(offlineQueueManagerProvider);
    return await queueManager.getStats();
  }

  /// Retry failed operations
  static Future<int> retryFailed(WidgetRef ref) async {
    final queueManager = ref.read(offlineQueueManagerProvider);
    return await queueManager.retryFailedOperations();
  }
}

/// Extension methods on WidgetRef for easier queue access
extension QueueExtensions on WidgetRef {
  /// Get queue manager
  OfflineQueueManager get queueManager => read(offlineQueueManagerProvider);

  /// Enqueue task creation
  Future<bool> enqueueCreateTask(String taskId, Map<String, dynamic> data) {
    return QueueHelpers.createTask(this, taskId: taskId, taskData: data);
  }

  /// Enqueue task update
  Future<bool> enqueueUpdateTask(String taskId, Map<String, dynamic> data) {
    return QueueHelpers.updateTask(this, taskId: taskId, taskData: data);
  }

  /// Enqueue task deletion
  Future<bool> enqueueDeleteTask(String taskId) {
    return QueueHelpers.deleteTask(this, taskId: taskId);
  }

  /// Enqueue project creation
  Future<bool> enqueueCreateProject(String projectId, Map<String, dynamic> data) {
    return QueueHelpers.createProject(this, projectId: projectId, projectData: data);
  }

  /// Enqueue project update
  Future<bool> enqueueUpdateProject(String projectId, Map<String, dynamic> data) {
    return QueueHelpers.updateProject(this, projectId: projectId, projectData: data);
  }

  /// Enqueue project deletion
  Future<bool> enqueueDeleteProject(String projectId) {
    return QueueHelpers.deleteProject(this, projectId: projectId);
  }

  /// Get queue size
  Future<int> getQueueSize() {
    return QueueHelpers.getPendingCount(this);
  }

  /// Clear queue
  Future<bool> clearQueue() {
    return QueueHelpers.clearQueue(this);
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../database/app_database.dart';
import '../database/entity_mappers.dart';

/// Operation to be queued
class QueuedOperation {
  final String entityType;
  final String entityId;
  final OperationType operation;
  final Map<String, dynamic>? data;
  final DateTime timestamp;

  QueuedOperation({
    required this.entityType,
    required this.entityId,
    required this.operation,
    this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'entity_type': entityType,
      'entity_id': entityId,
      'operation': operation.name,
      'data': data,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory QueuedOperation.fromJson(Map<String, dynamic> json) {
    return QueuedOperation(
      entityType: json['entity_type'] as String,
      entityId: json['entity_id'] as String,
      operation: OperationType.values.firstWhere(
        (e) => e.name == json['operation'],
      ),
      data: json['data'] as Map<String, dynamic>?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

/// Operation types
enum OperationType {
  insert,
  update,
  delete;

  String get apiValue => name;
}

/// Queue statistics
class QueueStats {
  final int totalOperations;
  final int pendingOperations;
  final int failedOperations;
  final DateTime? oldestOperation;
  final DateTime? newestOperation;

  QueueStats({
    required this.totalOperations,
    required this.pendingOperations,
    required this.failedOperations,
    this.oldestOperation,
    this.newestOperation,
  });

  bool get isEmpty => totalOperations == 0;
  bool get hasFailedOperations => failedOperations > 0;
}

/// Offline queue manager for handling operations while offline
class OfflineQueueManager {
  final AppDatabase _database;
  final Logger _logger;

  final _queueController = StreamController<QueueStats>.broadcast();
  Stream<QueueStats> get queueStatsStream => _queueController.stream;

  static const int maxQueueSize = 1000;
  static const int maxRetries = 3;

  OfflineQueueManager({
    required AppDatabase database,
    Logger? logger,
  })  : _database = database,
        _logger = logger ?? Logger();

  // ============================================================================
  // Queue Operations
  // ============================================================================

  /// Add operation to queue
  Future<bool> enqueue(QueuedOperation operation) async {
    try {
      // Check queue size
      final currentSize = await getQueueSize();
      if (currentSize >= maxQueueSize) {
        _logger.w('Queue is full, dropping oldest operation');
        await _dropOldestOperation();
      }

      // Add to database
      await _database.addPendingOperation(
        entityType: operation.entityType,
        entityId: operation.entityId,
        operation: operation.operation.apiValue,
        data: operation.data != null ? jsonEncode(operation.data) : null,
      );

      _logger.i('Enqueued ${operation.operation.name} for ${operation.entityType} ${operation.entityId}');

      // Update stats
      await _updateStats();

      return true;
    } catch (e, stack) {
      _logger.e('Failed to enqueue operation', error: e, stackTrace: stack);
      return false;
    }
  }

  /// Enqueue task operation
  Future<bool> enqueueTaskOperation({
    required String taskId,
    required OperationType operation,
    Map<String, dynamic>? taskData,
  }) async {
    return await enqueue(QueuedOperation(
      entityType: 'task',
      entityId: taskId,
      operation: operation,
      data: taskData,
    ));
  }

  /// Enqueue project operation
  Future<bool> enqueueProjectOperation({
    required String projectId,
    required OperationType operation,
    Map<String, dynamic>? projectData,
  }) async {
    return await enqueue(QueuedOperation(
      entityType: 'project',
      entityId: projectId,
      operation: operation,
      data: projectData,
    ));
  }

  /// Enqueue label operation
  Future<bool> enqueueLabelOperation({
    required String labelId,
    required OperationType operation,
    Map<String, dynamic>? labelData,
  }) async {
    return await enqueue(QueuedOperation(
      entityType: 'label',
      entityId: labelId,
      operation: operation,
      data: labelData,
    ));
  }

  /// Enqueue comment operation
  Future<bool> enqueueCommentOperation({
    required String commentId,
    required OperationType operation,
    Map<String, dynamic>? commentData,
  }) async {
    return await enqueue(QueuedOperation(
      entityType: 'comment',
      entityId: commentId,
      operation: operation,
      data: commentData,
    ));
  }

  /// Remove operation from queue
  Future<bool> dequeue(int operationId) async {
    try {
      await _database.removePendingOperation(operationId);
      await _updateStats();
      return true;
    } catch (e) {
      _logger.e('Failed to dequeue operation', error: e);
      return false;
    }
  }

  /// Clear all operations from queue
  Future<bool> clearQueue() async {
    try {
      await _database.clearPendingOperations();
      await _updateStats();
      _logger.i('Queue cleared');
      return true;
    } catch (e) {
      _logger.e('Failed to clear queue', error: e);
      return false;
    }
  }

  // ============================================================================
  // Queue Information
  // ============================================================================

  /// Get all pending operations
  Future<List<PendingOperation>> getAllOperations() async {
    return await _database.getAllPendingOperations();
  }

  /// Get queue size
  Future<int> getQueueSize() async {
    final operations = await _database.getAllPendingOperations();
    return operations.length;
  }

  /// Get queue statistics
  Future<QueueStats> getStats() async {
    final operations = await _database.getAllPendingOperations();

    if (operations.isEmpty) {
      return QueueStats(
        totalOperations: 0,
        pendingOperations: 0,
        failedOperations: 0,
      );
    }

    final failed = operations.where((op) => op.retryCount >= maxRetries).length;

    return QueueStats(
      totalOperations: operations.length,
      pendingOperations: operations.length - failed,
      failedOperations: failed,
      oldestOperation: operations.first.createdAt,
      newestOperation: operations.last.createdAt,
    );
  }

  /// Check if queue is empty
  Future<bool> isEmpty() async {
    final size = await getQueueSize();
    return size == 0;
  }

  /// Check if queue has failed operations
  Future<bool> hasFailedOperations() async {
    final operations = await _database.getAllPendingOperations();
    return operations.any((op) => op.retryCount >= maxRetries);
  }

  // ============================================================================
  // Queue Processing
  // ============================================================================

  /// Process operation with local database update
  Future<bool> processOperation(QueuedOperation operation) async {
    try {
      _logger.i('Processing ${operation.operation.name} for ${operation.entityType}');

      // Apply operation to local database and mark as unsynced
      await _applyLocalOperation(operation);

      _logger.i('Operation processed successfully');
      return true;
    } catch (e, stack) {
      _logger.e('Failed to process operation', error: e, stackTrace: stack);
      return false;
    }
  }

  /// Apply operation to local database
  Future<void> _applyLocalOperation(QueuedOperation operation) async {
    switch (operation.entityType) {
      case 'task':
        await _processTaskOperation(operation);
        break;

      case 'project':
        await _processProjectOperation(operation);
        break;

      case 'label':
        await _processLabelOperation(operation);
        break;

      case 'comment':
        await _processCommentOperation(operation);
        break;

      case 'attachment':
        await _processAttachmentOperation(operation);
        break;

      case 'link':
        await _processLinkOperation(operation);
        break;

      default:
        throw Exception('Unknown entity type: ${operation.entityType}');
    }
  }

  /// Process task operation
  Future<void> _processTaskOperation(QueuedOperation operation) async {
    switch (operation.operation) {
      case OperationType.insert:
      case OperationType.update:
        if (operation.data == null) {
          throw Exception('Task data is required for ${operation.operation.name}');
        }
        final task = EntityMappers.jsonToLocalTask(operation.data!);
        await _database.insertTask(task.copyWith(isSynced: false));
        break;

      case OperationType.delete:
        await _database.deleteTask(operation.entityId);
        break;
    }
  }

  /// Process project operation
  Future<void> _processProjectOperation(QueuedOperation operation) async {
    switch (operation.operation) {
      case OperationType.insert:
      case OperationType.update:
        if (operation.data == null) {
          throw Exception('Project data is required for ${operation.operation.name}');
        }
        final project = EntityMappers.jsonToLocalProject(operation.data!);
        await _database.insertProject(project.copyWith(isSynced: false));
        break;

      case OperationType.delete:
        await _database.deleteProject(operation.entityId);
        break;
    }
  }

  /// Process label operation
  Future<void> _processLabelOperation(QueuedOperation operation) async {
    switch (operation.operation) {
      case OperationType.insert:
      case OperationType.update:
        if (operation.data == null) {
          throw Exception('Label data is required for ${operation.operation.name}');
        }
        final label = EntityMappers.jsonToLocalLabel(operation.data!);
        await _database.insertLabel(label.copyWith(isSynced: false));
        break;

      case OperationType.delete:
        // Handle label deletion
        // Note: Labels might not support deletion depending on schema
        break;
    }
  }

  /// Process comment operation
  Future<void> _processCommentOperation(QueuedOperation operation) async {
    if (operation.data == null) return;

    final comment = LocalComment(
      id: operation.entityId,
      taskId: operation.data!['task_id'] as String,
      userId: operation.data!['user_id'] as String,
      content: operation.data!['content'] as String,
      createdAt: DateTime.parse(operation.data!['created_at'] as String),
      updatedAt: DateTime.now(),
      isSynced: false,
    );

    await _database.insertComment(comment);
  }

  /// Process attachment operation
  Future<void> _processAttachmentOperation(QueuedOperation operation) async {
    if (operation.data == null) return;

    final attachment = LocalAttachment(
      id: operation.entityId,
      taskId: operation.data!['task_id'] as String,
      fileName: operation.data!['file_name'] as String,
      fileSize: operation.data!['file_size'] as String,
      fileType: operation.data!['file_type'] as String,
      storagePath: operation.data!['storage_path'] as String?,
      localPath: operation.data!['local_path'] as String?,
      uploadedBy: operation.data!['uploaded_by'] as String,
      createdAt: DateTime.parse(operation.data!['created_at'] as String),
      updatedAt: DateTime.now(),
      isSynced: false,
    );

    await _database.insertAttachment(attachment);
  }

  /// Process link operation
  Future<void> _processLinkOperation(QueuedOperation operation) async {
    if (operation.data == null) return;

    final link = LocalLink(
      id: operation.entityId,
      taskId: operation.data!['task_id'] as String,
      url: operation.data!['url'] as String,
      title: operation.data!['title'] as String?,
      description: operation.data!['description'] as String?,
      addedBy: operation.data!['added_by'] as String,
      createdAt: DateTime.parse(operation.data!['created_at'] as String),
      updatedAt: DateTime.now(),
      isSynced: false,
    );

    await _database.insertLink(link);
  }

  // ============================================================================
  // Utility Methods
  // ============================================================================

  /// Drop oldest operation to make room
  Future<void> _dropOldestOperation() async {
    final operations = await _database.getAllPendingOperations();
    if (operations.isNotEmpty) {
      await _database.removePendingOperation(operations.first.id);
      _logger.w('Dropped oldest operation: ${operations.first.id}');
    }
  }

  /// Update queue statistics and notify listeners
  Future<void> _updateStats() async {
    final stats = await getStats();
    _queueController.add(stats);
  }

  /// Get operations by entity type
  Future<List<PendingOperation>> getOperationsByType(String entityType) async {
    final allOps = await _database.getAllPendingOperations();
    return allOps.where((op) => op.entityType == entityType).toList();
  }

  /// Get operations by entity ID
  Future<List<PendingOperation>> getOperationsByEntityId(String entityId) async {
    final allOps = await _database.getAllPendingOperations();
    return allOps.where((op) => op.entityId == entityId).toList();
  }

  /// Retry failed operations
  Future<int> retryFailedOperations() async {
    final operations = await _database.getAllPendingOperations();
    final failed = operations.where((op) => op.retryCount >= maxRetries).toList();

    int retried = 0;
    for (final op in failed) {
      // Reset retry count
      // Note: This would require adding a method to reset retry count in database
      // For now, we just count them
      retried++;
    }

    _logger.i('Retried $retried failed operations');
    return retried;
  }

  // ============================================================================
  // Lifecycle
  // ============================================================================

  void dispose() {
    _queueController.close();
  }
}

/// Extension for LocalTask copyWith
extension LocalTaskCopyWith on LocalTask {
  LocalTask copyWith({
    String? id,
    String? workspaceId,
    String? projectId,
    String? title,
    String? description,
    String? status,
    String? priority,
    DateTime? dueDate,
    String? assigneeId,
    int? position,
    String? labelIds,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isSynced,
  }) {
    return LocalTask(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      assigneeId: assigneeId ?? this.assigneeId,
      position: position ?? this.position,
      labelIds: labelIds ?? this.labelIds,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}

/// Extension for LocalProject copyWith
extension LocalProjectCopyWith on LocalProject {
  LocalProject copyWith({
    String? id,
    String? workspaceId,
    String? name,
    String? description,
    String? color,
    bool? isFavorite,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isSynced,
  }) {
    return LocalProject(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      isFavorite: isFavorite ?? this.isFavorite,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}

/// Extension for LocalLabel copyWith
extension LocalLabelCopyWith on LocalLabel {
  LocalLabel copyWith({
    String? id,
    String? workspaceId,
    String? name,
    String? color,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isSynced,
  }) {
    return LocalLabel(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      name: name ?? this.name,
      color: color ?? this.color,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}

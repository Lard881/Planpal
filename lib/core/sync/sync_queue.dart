import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';

/// Represents a pending sync operation in the queue
class SyncOperation {
  final String id;
  final String entityType; // 'task', 'project', 'label', 'workspace'
  final String entityId;
  final String action; // 'create', 'update', 'delete'
  final Map<String, dynamic> data;
  final DateTime createdAt;
  int retryCount;
  DateTime? lastAttempt;
  String? lastError;

  SyncOperation({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.action,
    required this.data,
    required this.createdAt,
    this.retryCount = 0,
    this.lastAttempt,
    this.lastError,
  });

  /// Check if operation should be retried based on exponential backoff
  bool shouldRetry({int maxRetries = 5}) {
    if (retryCount >= maxRetries) return false;
    if (lastAttempt == null) return true;

    // Exponential backoff: 2^retryCount seconds
    final backoffSeconds = (1 << retryCount); // 1, 2, 4, 8, 16 seconds
    final nextAttemptTime = lastAttempt!.add(Duration(seconds: backoffSeconds));
    
    return DateTime.now().isAfter(nextAttemptTime);
  }

  /// Get next retry delay in seconds
  int getNextRetryDelay() {
    return 1 << retryCount; // Exponential backoff
  }

  /// Copy with updated retry info
  SyncOperation copyWithRetry(String error) {
    return SyncOperation(
      id: id,
      entityType: entityType,
      entityId: entityId,
      action: action,
      data: data,
      createdAt: createdAt,
      retryCount: retryCount + 1,
      lastAttempt: DateTime.now(),
      lastError: error,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entityType': entityType,
      'entityId': entityId,
      'action': action,
      'data': data,
      'createdAt': createdAt.toIso8601String(),
      'retryCount': retryCount,
      'lastAttempt': lastAttempt?.toIso8601String(),
      'lastError': lastError,
    };
  }

  factory SyncOperation.fromJson(Map<String, dynamic> json) {
    return SyncOperation(
      id: json['id'] as String,
      entityType: json['entityType'] as String,
      entityId: json['entityId'] as String,
      action: json['action'] as String,
      data: json['data'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      retryCount: json['retryCount'] as int? ?? 0,
      lastAttempt: json['lastAttempt'] != null
          ? DateTime.parse(json['lastAttempt'] as String)
          : null,
      lastError: json['lastError'] as String?,
    );
  }
}

/// Manages a queue of pending sync operations with retry logic
class SyncQueue {
  final Queue<SyncOperation> _queue = Queue<SyncOperation>();
  final Map<String, SyncOperation> _operationMap = {};
  final List<SyncOperation> _failedOperations = [];
  
  final _queueController = StreamController<List<SyncOperation>>.broadcast();
  Stream<List<SyncOperation>> get queueStream => _queueController.stream;

  final int maxRetries;
  final int maxQueueSize;

  SyncQueue({
    this.maxRetries = 5,
    this.maxQueueSize = 1000,
  });

  /// Add operation to queue
  void enqueue(SyncOperation operation) {
    // Check if operation already exists (deduplication)
    final existingKey = '${operation.entityType}:${operation.entityId}:${operation.action}';
    if (_operationMap.containsKey(existingKey)) {
      debugPrint('[SyncQueue] Operation already queued: $existingKey');
      return;
    }

    // Check queue size limit
    if (_queue.length >= maxQueueSize) {
      debugPrint('[SyncQueue] Queue full, removing oldest operation');
      final removed = _queue.removeFirst();
      _operationMap.remove('${removed.entityType}:${removed.entityId}:${removed.action}');
    }

    _queue.add(operation);
    _operationMap[existingKey] = operation;
    _notifyListeners();
    
    debugPrint('[SyncQueue] Enqueued: ${operation.entityType} ${operation.action} ${operation.entityId} (queue size: ${_queue.length})');
  }

  /// Get next operation that's ready to be processed
  SyncOperation? dequeue() {
    while (_queue.isNotEmpty) {
      final operation = _queue.removeFirst();
      final key = '${operation.entityType}:${operation.entityId}:${operation.action}';
      _operationMap.remove(key);

      // Check if operation should be retried
      if (operation.shouldRetry(maxRetries: maxRetries)) {
        _notifyListeners();
        return operation;
      } else if (operation.retryCount >= maxRetries) {
        // Max retries reached - move to failed
        _failedOperations.add(operation);
        debugPrint('[SyncQueue] Operation failed after ${operation.retryCount} retries: $key');
      }
    }

    _notifyListeners();
    return null;
  }

  /// Re-queue operation with updated retry info
  void requeueWithRetry(SyncOperation operation, String error) {
    final updated = operation.copyWithRetry(error);
    
    if (updated.retryCount < maxRetries) {
      _queue.add(updated);
      final key = '${updated.entityType}:${updated.entityId}:${updated.action}';
      _operationMap[key] = updated;
      
      debugPrint('[SyncQueue] Re-queued with retry ${updated.retryCount}/$maxRetries: $key (next attempt in ${updated.getNextRetryDelay()}s)');
    } else {
      _failedOperations.add(updated);
      debugPrint('[SyncQueue] Operation moved to failed after max retries: ${updated.entityType}:${updated.entityId}');
    }
    
    _notifyListeners();
  }

  /// Remove operation from queue
  void remove(String operationId) {
    _queue.removeWhere((op) => op.id == operationId);
    _operationMap.removeWhere((key, op) => op.id == operationId);
    _notifyListeners();
  }

  /// Clear all operations
  void clear() {
    _queue.clear();
    _operationMap.clear();
    _failedOperations.clear();
    _notifyListeners();
  }

  /// Retry a failed operation
  void retryFailed(SyncOperation operation) {
    _failedOperations.remove(operation);
    
    // Reset retry count and re-queue
    final reset = SyncOperation(
      id: operation.id,
      entityType: operation.entityType,
      entityId: operation.entityId,
      action: operation.action,
      data: operation.data,
      createdAt: operation.createdAt,
      retryCount: 0,
    );
    
    enqueue(reset);
    debugPrint('[SyncQueue] Retrying failed operation: ${operation.entityType}:${operation.entityId}');
  }

  /// Retry all failed operations
  void retryAllFailed() {
    final failed = List<SyncOperation>.from(_failedOperations);
    _failedOperations.clear();
    
    for (final operation in failed) {
      retryFailed(operation);
    }
    
    debugPrint('[SyncQueue] Retrying ${failed.length} failed operations');
  }

  /// Get operations ready for processing
  List<SyncOperation> getReadyOperations({int limit = 10}) {
    final ready = <SyncOperation>[];
    
    for (final operation in _queue) {
      if (operation.shouldRetry(maxRetries: maxRetries)) {
        ready.add(operation);
        if (ready.length >= limit) break;
      }
    }
    
    return ready;
  }

  /// Get queue statistics
  Map<String, dynamic> getStats() {
    final stats = <String, dynamic>{
      'total': _queue.length,
      'failed': _failedOperations.length,
      'ready': getReadyOperations().length,
      'byType': <String, int>{},
      'byAction': <String, int>{},
    };

    for (final operation in _queue) {
      // Count by type
      stats['byType'][operation.entityType] = 
          (stats['byType'][operation.entityType] ?? 0) + 1;
      
      // Count by action
      stats['byAction'][operation.action] = 
          (stats['byAction'][operation.action] ?? 0) + 1;
    }

    return stats;
  }

  void _notifyListeners() {
    _queueController.add(List.unmodifiable(_queue));
  }

  // Getters
  int get length => _queue.length;
  bool get isEmpty => _queue.isEmpty;
  bool get isNotEmpty => _queue.isNotEmpty;
  List<SyncOperation> get failedOperations => List.unmodifiable(_failedOperations);
  List<SyncOperation> get allOperations => List.unmodifiable(_queue);

  /// Dispose resources
  void dispose() {
    _queueController.close();
  }
}

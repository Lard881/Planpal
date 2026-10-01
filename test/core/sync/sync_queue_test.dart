import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/core/sync/sync_queue.dart';

void main() {
  group('SyncQueue', () {
    late SyncQueue syncQueue;

    setUp(() {
      syncQueue = SyncQueue();
    });

    test('should add operation to queue', () {
      syncQueue.add(SyncOperation(
        id: '1',
        entityType: 'tasks',
        entityId: 'task-1',
        action: SyncAction.create,
        data: {'title': 'Test Task'},
        timestamp: DateTime.now(),
      ));

      expect(syncQueue.length, 1);
    });

    test('should deduplicate operations with same entity and action', () {
      final timestamp = DateTime.now();
      
      syncQueue.add(SyncOperation(
        id: '1',
        entityType: 'tasks',
        entityId: 'task-1',
        action: SyncAction.update,
        data: {'title': 'Version 1'},
        timestamp: timestamp,
      ));

      syncQueue.add(SyncOperation(
        id: '2',
        entityType: 'tasks',
        entityId: 'task-1',
        action: SyncAction.update,
        data: {'title': 'Version 2'},
        timestamp: timestamp.add(const Duration(seconds: 1)),
      ));

      // Should only keep the latest operation
      expect(syncQueue.length, 1);
      final ops = syncQueue.getReadyOperations();
      expect(ops.first.data['title'], 'Version 2');
    });

    test('should return ready operations only', () {
      final now = DateTime.now();
      
      // Add ready operation
      syncQueue.add(SyncOperation(
        id: '1',
        entityType: 'tasks',
        entityId: 'task-1',
        action: SyncAction.create,
        data: {},
        timestamp: now,
      ));

      // Add operation with future retry time
      syncQueue.add(SyncOperation(
        id: '2',
        entityType: 'tasks',
        entityId: 'task-2',
        action: SyncAction.create,
        data: {},
        timestamp: now,
        retryCount: 1,
        nextRetryAt: now.add(const Duration(hours: 1)),
      ));

      final ready = syncQueue.getReadyOperations();
      expect(ready.length, 1);
      expect(ready.first.id, '1');
    });

    test('should implement exponential backoff', () {
      final now = DateTime.now();
      final operation = SyncOperation(
        id: '1',
        entityType: 'tasks',
        entityId: 'task-1',
        action: SyncAction.create,
        data: {},
        timestamp: now,
      );

      syncQueue.add(operation);

      // First retry: 1 second
      syncQueue.requeueWithRetry(operation, 'Error 1');
      var ops = syncQueue.getReadyOperations();
      expect(ops.length, 0); // Not ready yet

      // Simulate time passing
      syncQueue.add(operation.copyWith(
        retryCount: 1,
        nextRetryAt: now.subtract(const Duration(seconds: 1)),
      ));

      // Second retry: should use exponential backoff
      final retriedOp = syncQueue.getReadyOperations().first;
      syncQueue.requeueWithRetry(retriedOp, 'Error 2');
      
      final stats = syncQueue.getStats();
      expect(stats['total'], greaterThan(0));
    });

    test('should move to failed after max retries', () {
      final operation = SyncOperation(
        id: '1',
        entityType: 'tasks',
        entityId: 'task-1',
        action: SyncAction.create,
        data: {},
        timestamp: DateTime.now(),
        retryCount: 4, // One retry left before max
      );

      syncQueue.add(operation);
      syncQueue.requeueWithRetry(operation, 'Final error');

      final stats = syncQueue.getStats();
      expect(stats['failed'], 1);
      
      final failed = syncQueue.getFailedOperations();
      expect(failed.length, 1);
      expect(failed.first.lastError, 'Final error');
    });

    test('should clear all operations', () {
      syncQueue.add(SyncOperation(
        id: '1',
        entityType: 'tasks',
        entityId: 'task-1',
        action: SyncAction.create,
        data: {},
        timestamp: DateTime.now(),
      ));

      syncQueue.add(SyncOperation(
        id: '2',
        entityType: 'projects',
        entityId: 'project-1',
        action: SyncAction.update,
        data: {},
        timestamp: DateTime.now(),
      ));

      expect(syncQueue.length, 2);

      syncQueue.clear();
      expect(syncQueue.length, 0);
    });

    test('should remove specific operation', () {
      syncQueue.add(SyncOperation(
        id: '1',
        entityType: 'tasks',
        entityId: 'task-1',
        action: SyncAction.create,
        data: {},
        timestamp: DateTime.now(),
      ));

      syncQueue.add(SyncOperation(
        id: '2',
        entityType: 'tasks',
        entityId: 'task-2',
        action: SyncAction.create,
        data: {},
        timestamp: DateTime.now(),
      ));

      syncQueue.remove('1');
      expect(syncQueue.length, 1);
      
      final ops = syncQueue.getReadyOperations();
      expect(ops.first.id, '2');
    });

    test('should provide accurate statistics', () {
      final now = DateTime.now();
      
      // Add ready operation
      syncQueue.add(SyncOperation(
        id: '1',
        entityType: 'tasks',
        entityId: 'task-1',
        action: SyncAction.create,
        data: {},
        timestamp: now,
      ));

      // Add failed operation
      syncQueue.add(SyncOperation(
        id: '2',
        entityType: 'tasks',
        entityId: 'task-2',
        action: SyncAction.create,
        data: {},
        timestamp: now,
        retryCount: 5,
        lastError: 'Max retries exceeded',
      ));

      final stats = syncQueue.getStats();
      expect(stats['total'], 2);
      expect(stats['ready'], 1);
      expect(stats['failed'], 1);
    });
  });
}

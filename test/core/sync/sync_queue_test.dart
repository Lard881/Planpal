import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/core/sync/sync_queue.dart';

void main() {
  group('SyncQueue', () {
    late SyncQueue syncQueue;

    setUp(() {
      syncQueue = SyncQueue();
    });

    tearDown(() {
      syncQueue.dispose();
    });

    test('should add operation to queue', () {
      syncQueue.enqueue(SyncOperation(
        id: '1',
        entityType: 'tasks',
        entityId: 'task-1',
        action: 'create',
        data: {'title': 'Test Task'},
        createdAt: DateTime.now(),
      ));

      expect(syncQueue.length, 1);
    });

    test('should deduplicate operations with same entity and action', () {
      final timestamp = DateTime.now();

      syncQueue.enqueue(SyncOperation(
        id: '1',
        entityType: 'tasks',
        entityId: 'task-1',
        action: 'update',
        data: {'title': 'Version 1'},
        createdAt: timestamp,
      ));

      syncQueue.enqueue(SyncOperation(
        id: '2',
        entityType: 'tasks',
        entityId: 'task-1',
        action: 'update',
        data: {'title': 'Version 2'},
        createdAt: timestamp.add(const Duration(seconds: 1)),
      ));

      // Should keep the existing operation and ignore duplicate
      expect(syncQueue.length, 1);
      final ops = syncQueue.getReadyOperations();
      expect(ops.first.data['title'], 'Version 1');
    });

    test('should return ready operations only', () {
      final now = DateTime.now();

      // Add ready operation
      syncQueue.enqueue(SyncOperation(
        id: '1',
        entityType: 'tasks',
        entityId: 'task-1',
        action: 'create',
        data: {},
        createdAt: now,
      ));

      // Add operation with future retry time
      syncQueue.enqueue(SyncOperation(
        id: '2',
        entityType: 'tasks',
        entityId: 'task-2',
        action: 'create',
        data: {},
        createdAt: now,
        retryCount: 1,
        lastAttempt: now,
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
        action: 'create',
        data: {},
        createdAt: now,
      );

      syncQueue.enqueue(operation);

      // First retry: sets retryCount = 1, lastAttempt = now -> next retry in 2 seconds
      syncQueue.requeueWithRetry(operation, 'Error 1');
      final ops = syncQueue.getReadyOperations();
      expect(ops.length, 0); // Not ready yet

      final stats = syncQueue.getStats();
      expect(stats['total'], greaterThan(0));
    });

    test('should move to failed after max retries', () {
      final operation = SyncOperation(
        id: '1',
        entityType: 'tasks',
        entityId: 'task-1',
        action: 'create',
        data: {},
        createdAt: DateTime.now(),
        retryCount: 4, // One retry left before max (5)
      );

      syncQueue.enqueue(operation);
      syncQueue.requeueWithRetry(operation, 'Final error');

      final stats = syncQueue.getStats();
      expect(stats['failed'], 1);

      final failed = syncQueue.failedOperations;
      expect(failed.length, 1);
      expect(failed.first.lastError, 'Final error');
    });

    test('should clear all operations', () {
      syncQueue.enqueue(SyncOperation(
        id: '1',
        entityType: 'tasks',
        entityId: 'task-1',
        action: 'create',
        data: {},
        createdAt: DateTime.now(),
      ));

      syncQueue.enqueue(SyncOperation(
        id: '2',
        entityType: 'projects',
        entityId: 'project-1',
        action: 'update',
        data: {},
        createdAt: DateTime.now(),
      ));

      expect(syncQueue.length, 2);

      syncQueue.clear();
      expect(syncQueue.length, 0);
    });

    test('should remove specific operation', () {
      syncQueue.enqueue(SyncOperation(
        id: '1',
        entityType: 'tasks',
        entityId: 'task-1',
        action: 'create',
        data: {},
        createdAt: DateTime.now(),
      ));

      syncQueue.enqueue(SyncOperation(
        id: '2',
        entityType: 'tasks',
        entityId: 'task-2',
        action: 'create',
        data: {},
        createdAt: DateTime.now(),
      ));

      syncQueue.remove('1');
      expect(syncQueue.length, 1);

      final ops = syncQueue.getReadyOperations();
      expect(ops.first.id, '2');
    });

    test('should provide accurate statistics', () {
      final now = DateTime.now();

      // Add ready operation
      syncQueue.enqueue(SyncOperation(
        id: '1',
        entityType: 'tasks',
        entityId: 'task-1',
        action: 'create',
        data: {},
        createdAt: now,
      ));

      // Add failed operation
      final op2 = SyncOperation(
        id: '2',
        entityType: 'tasks',
        entityId: 'task-2',
        action: 'create',
        data: {},
        createdAt: now,
        retryCount: 4,
      );
      syncQueue.enqueue(op2);
      syncQueue.requeueWithRetry(op2, 'Max retries exceeded');

      final stats = syncQueue.getStats();
      expect(stats['total'], 1);
      expect(stats['ready'], 1);
      expect(stats['failed'], 1);
    });
  });
}

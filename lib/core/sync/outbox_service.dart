import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import '../db/app_database.dart';
import '../network/api_client.dart';
import '../utils/logger.dart';

/// Outbox service for pushing local changes to server
/// 
/// Features:
/// - Processes queued operations in creation order
/// - Exponential backoff on failure (1s, 2s, 4s, 8s, 16s, max 32s)
/// - Retry logic with configurable max attempts
/// - Removes from outbox on success
/// - Marks as permanently failed after max retries
class OutboxService {
  final AppDatabase _database;
  final ApiClient _apiClient;
  
  bool _isPushing = false;
  
  // Retry configuration
  static const int maxRetries = 5;
  static const Duration initialBackoff = Duration(seconds: 1);
  static const Duration maxBackoff = Duration(seconds: 32);
  
  OutboxService({
    required AppDatabase database,
    required ApiClient apiClient,
  })  : _database = database,
        _apiClient = apiClient;

  /// Check if push is currently in progress
  bool get isPushing => _isPushing;

  /// Push all pending changes to server
  /// 
  /// Returns number of items successfully pushed
  Future<int> pushChanges() async {
    // Prevent concurrent pushes
    if (_isPushing) {
      logger.w('📤 Push already in progress, skipping');
      return 0;
    }

    _isPushing = true;
    int successCount = 0;
    
    try {
      logger.i('📤 Starting outbox push');
      
      // Get all pending items, ordered by creation time
      final pendingItems = await (_database.select(_database.outbox)
            ..where((tbl) => tbl.status.equals('pending'))
            ..orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt)]))
          .get();

      if (pendingItems.isEmpty) {
        logger.d('📤 No pending items to push');
        return 0;
      }

      logger.i('📤 Found ${pendingItems.length} pending items');

      // Process each item sequentially (to maintain order)
      for (final item in pendingItems) {
        final success = await _processOutboxItem(item);
        if (success) {
          successCount++;
        }
      }

      logger.i('📤 Push completed: $successCount/${pendingItems.length} succeeded');
      return successCount;
      
    } catch (e, stackTrace) {
      logger.e('📤 Push failed', error: e, stackTrace: stackTrace);
      return successCount;
    } finally {
      _isPushing = false;
    }
  }

  /// Push a single item to the outbox
  /// 
  /// Used when creating/updating entities offline
  Future<void> enqueue({
    required String entityType,
    required String entityId,
    required String operation,
    required Map<String, dynamic> payload,
  }) async {
    await _database.into(_database.outbox).insert(
          OutboxCompanion(
            entityType: Value(entityType),
            entityId: Value(entityId),
            operation: Value(operation),
            payloadJson: Value(jsonEncode(payload)),
            createdAt: Value(DateTime.now()),
            attempts: const Value(0),
            status: const Value('pending'),
          ),
        );

    logger.d('📤 Enqueued $operation for $entityType:$entityId');
  }

  /// Process a single outbox item
  Future<bool> _processOutboxItem(OutboxData item) async {
    try {
      logger.d('📤 Processing ${item.operation} for ${item.entityType}:${item.entityId}');

      // Mark as syncing
      await (_database.update(_database.outbox)
            ..where((tbl) => tbl.id.equals(item.id)))
          .write(
        OutboxCompanion(
          attempts: Value(item.attempts + 1),
        ),
      );

      // Decode payload
      final payload = jsonDecode(item.payloadJson) as Map<String, dynamic>;

      // Execute the operation
      await _executeOperation(
        entityType: item.entityType,
        entityId: item.entityId,
        operation: item.operation,
        payload: payload,
      );

      // Success - remove from outbox
      await (_database.delete(_database.outbox)
            ..where((tbl) => tbl.id.equals(item.id)))
          .go();

      logger.i('📤 Successfully synced ${item.entityType}:${item.entityId}');
      return true;
      
    } catch (e, stackTrace) {
      logger.w('📤 Failed to sync ${item.entityType}:${item.entityId}', 
               error: e, stackTrace: stackTrace);

      // Check if we should retry or mark as permanently failed
      final newAttempts = item.attempts + 1;
      
      if (newAttempts >= maxRetries) {
        // Max retries reached - mark as permanently failed
        await (_database.update(_database.outbox)
              ..where((tbl) => tbl.id.equals(item.id)))
            .write(
          OutboxCompanion(
            status: const Value('failed'),
            lastError: Value(e.toString()),
            attempts: Value(newAttempts),
          ),
        );
        
        logger.e('📤 Item permanently failed after $maxRetries attempts');
        return false;
      }

      // Calculate backoff delay
      final backoff = _calculateBackoff(newAttempts);
      
      // Update with error and new attempt count
      await (_database.update(_database.outbox)
            ..where((tbl) => tbl.id.equals(item.id)))
          .write(
        OutboxCompanion(
          attempts: Value(newAttempts),
          lastError: Value(e.toString()),
        ),
      );

      logger.d('📤 Will retry after $backoff (attempt $newAttempts/$maxRetries)');
      
      // Wait before next retry
      await Future.delayed(backoff);
      
      return false;
    }
  }

  /// Execute an operation on the server
  Future<void> _executeOperation({
    required String entityType,
    required String entityId,
    required String operation,
    required Map<String, dynamic> payload,
  }) async {
    switch (entityType) {
      case 'label':
        await _executeLabelOperation(entityId, operation, payload);
        break;
        
      case 'task':
        await _executeTaskOperation(entityId, operation, payload);
        break;
        
      case 'event':
        await _executeEventOperation(entityId, operation, payload);
        break;
        
      // TODO: Add more entity types as they're implemented
        
      default:
        throw UnsupportedError('Unknown entity type: $entityType');
    }
  }

  /// Execute label operation
  Future<void> _executeLabelOperation(
    String entityId,
    String operation,
    Map<String, dynamic> payload,
  ) async {
    final workspaceId = payload['workspace_id'] as String;

    switch (operation) {
      case 'create':
        await _apiClient.post(
          '/workspaces/$workspaceId/labels',
          data: {
            'id': entityId, // Client-supplied ID for idempotency
            'name': payload['name'],
            'color': payload['color'],
          },
        );
        break;

      case 'update':
        await _apiClient.patch(
          '/workspaces/$workspaceId/labels/$entityId',
          data: {
            if (payload.containsKey('name')) 'name': payload['name'],
            if (payload.containsKey('color')) 'color': payload['color'],
          },
        );
        break;

      case 'delete':
        await _apiClient.delete('/workspaces/$workspaceId/labels/$entityId');
        break;

      default:
        throw UnsupportedError('Unknown operation: $operation');
    }
  }

  /// Execute task operation
  Future<void> _executeTaskOperation(
    String entityId,
    String operation,
    Map<String, dynamic> payload,
  ) async {
    final workspaceId = payload['workspace_id'] as String;

    switch (operation) {
      case 'create':
        await _apiClient.post(
          '/workspaces/$workspaceId/tasks',
          data: {
            'id': entityId,
            ...payload,
          },
        );
        break;

      case 'update':
        await _apiClient.patch(
          '/workspaces/$workspaceId/tasks/$entityId',
          data: payload,
        );
        break;

      case 'delete':
        await _apiClient.delete('/workspaces/$workspaceId/tasks/$entityId');
        break;

      default:
        throw UnsupportedError('Unknown operation: $operation');
    }
  }

  /// Execute event operation
  Future<void> _executeEventOperation(
    String entityId,
    String operation,
    Map<String, dynamic> payload,
  ) async {
    final workspaceId = payload['workspace_id'] as String;

    switch (operation) {
      case 'create':
        await _apiClient.post(
          '/workspaces/$workspaceId/events',
          data: {
            'id': entityId,
            ...payload,
          },
        );
        break;

      case 'update':
        await _apiClient.patch(
          '/workspaces/$workspaceId/events/$entityId',
          data: payload,
        );
        break;

      case 'delete':
        await _apiClient.delete('/workspaces/$workspaceId/events/$entityId');
        break;

      default:
        throw UnsupportedError('Unknown operation: $operation');
    }
  }

  /// Calculate exponential backoff delay
  Duration _calculateBackoff(int attemptNumber) {
    // Exponential backoff: 1s, 2s, 4s, 8s, 16s, 32s (max)
    final delaySeconds = initialBackoff.inSeconds * (1 << (attemptNumber - 1));
    final delay = Duration(seconds: delaySeconds);
    
    return delay.compareTo(maxBackoff) > 0 ? maxBackoff : delay;
  }

  /// Get count of pending items
  Future<int> getPendingCount() async {
    final result = await (_database.selectOnly(_database.outbox)
          ..addColumns([_database.outbox.id.count()])
          ..where(_database.outbox.status.equals('pending')))
        .getSingle();

    return result.read(_database.outbox.id.count()) ?? 0;
  }

  /// Get count of failed items
  Future<int> getFailedCount() async {
    final result = await (_database.selectOnly(_database.outbox)
          ..addColumns([_database.outbox.id.count()])
          ..where(_database.outbox.status.equals('failed')))
        .getSingle();

    return result.read(_database.outbox.id.count()) ?? 0;
  }

  /// Get all failed items for user review
  Future<List<OutboxData>> getFailedItems() async {
    return await (_database.select(_database.outbox)
          ..where((tbl) => tbl.status.equals('failed'))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt)]))
        .get();
  }

  /// Retry all failed items
  Future<void> retryFailedItems() async {
    logger.i('📤 Retrying all failed items');

    await (_database.update(_database.outbox)
          ..where((tbl) => tbl.status.equals('failed')))
        .write(
      const OutboxCompanion(
        status: Value('pending'),
        attempts: Value(0),
        lastError: Value.absent(),
      ),
    );

    // Trigger push
    await pushChanges();
  }

  /// Discard a failed item
  Future<void> discardItem(int itemId) async {
    logger.i('📤 Discarding outbox item: $itemId');

    await (_database.delete(_database.outbox)
          ..where((tbl) => tbl.id.equals(itemId)))
        .go();
  }

  /// Discard all failed items
  Future<void> discardAllFailedItems() async {
    logger.i('📤 Discarding all failed items');

    await (_database.delete(_database.outbox)
          ..where((tbl) => tbl.status.equals('failed')))
        .go();
  }

  /// Clear all outbox items (use with caution!)
  Future<void> clearAll() async {
    logger.w('📤 Clearing all outbox items');

    await _database.delete(_database.outbox).go();
  }
}

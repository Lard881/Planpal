import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../database/entity_mappers.dart';

/// Sync result for tracking sync operations
class SyncResult {
  final bool success;
  final int processed;
  final int successful;
  final int failed;
  final int conflicts;
  final List<SyncConflict> conflictDetails;
  final String? errorMessage;

  SyncResult({
    required this.success,
    required this.processed,
    required this.successful,
    required this.failed,
    required this.conflicts,
    this.conflictDetails = const [],
    this.errorMessage,
  });

  bool get hasConflicts => conflicts > 0;
  bool get hasErrors => failed > 0 || errorMessage != null;
}

/// Sync conflict details
class SyncConflict {
  final String entityType;
  final String entityId;
  final String resolution;
  final Map<String, dynamic>? serverData;
  final Map<String, dynamic>? clientData;

  SyncConflict({
    required this.entityType,
    required this.entityId,
    required this.resolution,
    this.serverData,
    this.clientData,
  });
}

/// Sync configuration
class SyncConfig {
  final String deviceId;
  final List<String> entityTypes;
  final ConflictResolutionStrategy strategy;
  final int batchSize;
  final Duration timeout;

  const SyncConfig({
    required this.deviceId,
    this.entityTypes = const ['task', 'project', 'label', 'comment', 'attachment', 'link'],
    this.strategy = ConflictResolutionStrategy.serverWins,
    this.batchSize = 100,
    this.timeout = const Duration(seconds: 30),
  });
}

/// Conflict resolution strategy
enum ConflictResolutionStrategy {
  serverWins,
  clientWins,
  failOnConflict;

  String get apiValue {
    switch (this) {
      case ConflictResolutionStrategy.serverWins:
        return 'server_wins';
      case ConflictResolutionStrategy.clientWins:
        return 'client_wins';
      case ConflictResolutionStrategy.failOnConflict:
        return 'fail_on_conflict';
    }
  }
}

/// Main sync service for bidirectional synchronization
class SyncService {
  final AppDatabase _database;
  final Dio _dio;
  final Logger _logger;
  final SyncConfig config;

  SyncService({
    required AppDatabase database,
    required Dio dio,
    required this.config,
    Logger? logger,
  })  : _database = database,
        _dio = dio,
        _logger = logger ?? Logger();

  // ============================================================================
  // Full Sync (Pull + Push)
  // ============================================================================

  /// Perform full bidirectional sync
  Future<SyncResult> fullSync({
    String? workspaceId,
    ConflictResolutionStrategy? strategy,
  }) async {
    try {
      _logger.i('Starting full sync for workspace: $workspaceId');

      // 1. Pull changes from server
      final pullResult = await pullChanges(workspaceId: workspaceId);
      if (!pullResult.success) {
        return pullResult;
      }

      // 2. Push local changes to server
      final pushResult = await pushChanges(
        workspaceId: workspaceId,
        strategy: strategy,
      );

      // Combine results
      return SyncResult(
        success: pullResult.success && pushResult.success,
        processed: pullResult.processed + pushResult.processed,
        successful: pullResult.successful + pushResult.successful,
        failed: pullResult.failed + pushResult.failed,
        conflicts: pullResult.conflicts + pushResult.conflicts,
        conflictDetails: [...pullResult.conflictDetails, ...pushResult.conflictDetails],
      );
    } catch (e, stack) {
      _logger.e('Full sync failed', error: e, stackTrace: stack);
      return SyncResult(
        success: false,
        processed: 0,
        successful: 0,
        failed: 0,
        conflicts: 0,
        errorMessage: e.toString(),
      );
    }
  }

  // ============================================================================
  // Pull Changes from Server
  // ============================================================================

  /// Pull changes from server and apply to local database
  Future<SyncResult> pullChanges({String? workspaceId}) async {
    try {
      _logger.i('Pulling changes from server...');

      // Get sync states to determine since timestamps
      final syncStates = await _database.getAllSyncStates();

      // Build query parameters
      final queryParams = <String, dynamic>{
        'device_id': config.deviceId,
        'entity_types': config.entityTypes.join(','),
      };

      if (workspaceId != null) {
        queryParams['workspace_id'] = workspaceId;
      }

      // Make API request
      final response = await _dio.get(
        '/sync/pull',
        queryParameters: queryParams,
        options: Options(
          sendTimeout: config.timeout,
          receiveTimeout: config.timeout,
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Pull sync failed: ${response.statusCode}');
      }

      final data = response.data as Map<String, dynamic>;
      final changes = data['changes'] as Map<String, dynamic>;

      int processed = 0;
      int successful = 0;
      int failed = 0;

      // Apply changes for each entity type
      for (final entityType in config.entityTypes) {
        if (!changes.containsKey(entityType)) continue;

        final entityChanges = changes[entityType] as List<dynamic>;
        processed += entityChanges.length;

        for (final change in entityChanges) {
          final changeMap = change as Map<String, dynamic>;
          final operation = changeMap['operation'] as String;
          final entityData = changeMap['data'] as Map<String, dynamic>;

          try {
            await _applyRemoteChange(entityType, operation, entityData);
            successful++;
          } catch (e) {
            _logger.w('Failed to apply change for $entityType', error: e);
            failed++;
          }
        }

        // Update sync state
        await _database.updateSyncState(
          entityType: entityType,
          lastSyncAt: DateTime.now(),
          syncStatus: 'success',
        );
      }

      _logger.i('Pull complete: $successful/$processed successful');

      return SyncResult(
        success: failed == 0,
        processed: processed,
        successful: successful,
        failed: failed,
        conflicts: 0,
      );
    } catch (e, stack) {
      _logger.e('Pull sync failed', error: e, stackTrace: stack);
      return SyncResult(
        success: false,
        processed: 0,
        successful: 0,
        failed: 0,
        conflicts: 0,
        errorMessage: e.toString(),
      );
    }
  }

  /// Apply a remote change to local database
  Future<void> _applyRemoteChange(
    String entityType,
    String operation,
    Map<String, dynamic> data,
  ) async {
    switch (entityType) {
      case 'task':
        final task = EntityMappers.jsonToLocalTask(data);
        if (operation == 'delete') {
          await _database.deleteTask(task.id);
        } else {
          await _database.insertTask(task);
        }
        break;

      case 'project':
        final project = EntityMappers.jsonToLocalProject(data);
        if (operation == 'delete') {
          await _database.deleteProject(project.id);
        } else {
          await _database.insertProject(project);
        }
        break;

      case 'label':
        final label = EntityMappers.jsonToLocalLabel(data);
        if (operation == 'delete') {
          // Labels don't have soft delete in some implementations
          // Handle accordingly
        } else {
          await _database.insertLabel(label);
        }
        break;

      case 'comment':
        final comment = LocalComment(
          id: data['id'] as String,
          taskId: data['task_id'] as String,
          userId: data['user_id'] as String,
          content: data['content'] as String,
          createdAt: DateTime.parse(data['created_at'] as String),
          updatedAt: data['updated_at'] != null
              ? DateTime.parse(data['updated_at'] as String)
              : DateTime.parse(data['created_at'] as String),
          isSynced: true,
        );
        await _database.insertComment(comment);
        break;

      case 'attachment':
        final attachment = LocalAttachment(
          id: data['id'] as String,
          taskId: data['task_id'] as String,
          fileName: data['file_name'] as String,
          fileSize: data['file_size'] as String,
          fileType: data['file_type'] as String,
          storagePath: data['storage_path'] as String?,
          localPath: null,
          uploadedBy: data['uploaded_by'] as String,
          createdAt: DateTime.parse(data['created_at'] as String),
          updatedAt: data['updated_at'] != null
              ? DateTime.parse(data['updated_at'] as String)
              : DateTime.parse(data['created_at'] as String),
          isSynced: true,
        );
        await _database.insertAttachment(attachment);
        break;

      case 'link':
        final link = LocalLink(
          id: data['id'] as String,
          taskId: data['task_id'] as String,
          url: data['url'] as String,
          title: data['title'] as String?,
          description: data['description'] as String?,
          addedBy: data['added_by'] as String,
          createdAt: DateTime.parse(data['created_at'] as String),
          updatedAt: data['updated_at'] != null
              ? DateTime.parse(data['updated_at'] as String)
              : DateTime.parse(data['created_at'] as String),
          isSynced: true,
        );
        await _database.insertLink(link);
        break;

      default:
        _logger.w('Unknown entity type: $entityType');
    }
  }

  // ============================================================================
  // Push Changes to Server
  // ============================================================================

  /// Push local changes to server
  Future<SyncResult> pushChanges({
    String? workspaceId,
    ConflictResolutionStrategy? strategy,
  }) async {
    try {
      _logger.i('Pushing changes to server...');

      // Get all pending operations
      final pending = await _database.getAllPendingOperations();

      if (pending.isEmpty) {
        _logger.i('No pending changes to push');
        return SyncResult(
          success: true,
          processed: 0,
          successful: 0,
          failed: 0,
          conflicts: 0,
        );
      }

      // Convert to API format
      final changes = pending.map((op) {
        return {
          'entity_type': op.entityType,
          'entity_id': op.entityId,
          'operation': op.operation,
          'data': op.data != null ? jsonDecode(op.data!) : null,
          'client_updated_at': op.clientUpdatedAt.toIso8601String(),
        };
      }).toList();

      // Split into batches
      final batches = <List<Map<String, dynamic>>>[];
      for (var i = 0; i < changes.length; i += config.batchSize) {
        final end = (i + config.batchSize < changes.length)
            ? i + config.batchSize
            : changes.length;
        batches.add(changes.sublist(i, end));
      }

      int totalProcessed = 0;
      int totalSuccessful = 0;
      int totalFailed = 0;
      int totalConflicts = 0;
      final allConflicts = <SyncConflict>[];

      // Push each batch
      for (var i = 0; i < batches.length; i++) {
        final batch = batches[i];
        _logger.i('Pushing batch ${i + 1}/${batches.length} (${batch.length} changes)');

        final result = await _pushBatch(
          batch,
          workspaceId,
          strategy ?? config.strategy,
        );

        totalProcessed += result.processed;
        totalSuccessful += result.successful;
        totalFailed += result.failed;
        totalConflicts += result.conflicts;
        allConflicts.addAll(result.conflictDetails);

        // Remove successful operations from queue
        if (result.success) {
          for (var j = 0; j < batch.length; j++) {
            final opIndex = i * config.batchSize + j;
            if (opIndex < pending.length) {
              await _database.removePendingOperation(pending[opIndex].id);
            }
          }
        }
      }

      _logger.i('Push complete: $totalSuccessful/$totalProcessed successful, $totalConflicts conflicts');

      return SyncResult(
        success: totalFailed == 0,
        processed: totalProcessed,
        successful: totalSuccessful,
        failed: totalFailed,
        conflicts: totalConflicts,
        conflictDetails: allConflicts,
      );
    } catch (e, stack) {
      _logger.e('Push sync failed', error: e, stackTrace: stack);
      return SyncResult(
        success: false,
        processed: 0,
        successful: 0,
        failed: 0,
        conflicts: 0,
        errorMessage: e.toString(),
      );
    }
  }

  /// Push a single batch of changes
  Future<SyncResult> _pushBatch(
    List<Map<String, dynamic>> changes,
    String? workspaceId,
    ConflictResolutionStrategy strategy,
  ) async {
    try {
      final response = await _dio.post(
        '/sync/push',
        data: {
          'device_id': config.deviceId,
          'workspace_id': workspaceId,
          'conflict_resolution': strategy.apiValue,
          'changes': changes,
        },
        options: Options(
          sendTimeout: config.timeout,
          receiveTimeout: config.timeout,
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Push sync failed: ${response.statusCode}');
      }

      final data = response.data as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;

      final conflicts = <SyncConflict>[];
      for (final result in results) {
        final resultMap = result as Map<String, dynamic>;
        if (resultMap['conflict'] == true) {
          conflicts.add(SyncConflict(
            entityType: resultMap['entity_type'] as String,
            entityId: resultMap['entity_id'] as String,
            resolution: resultMap['resolution'] as String? ?? 'unknown',
            serverData: resultMap['server_data'] as Map<String, dynamic>?,
            clientData: resultMap['client_data'] as Map<String, dynamic>?,
          ));
        }
      }

      return SyncResult(
        success: data['success'] as bool,
        processed: data['processed'] as int,
        successful: data['successful'] as int,
        failed: data['failed'] as int,
        conflicts: data['conflicts'] as int,
        conflictDetails: conflicts,
      );
    } catch (e) {
      _logger.e('Batch push failed', error: e);
      rethrow;
    }
  }

  // ============================================================================
  // Sync Status
  // ============================================================================

  /// Get sync status from server
  Future<Map<String, dynamic>?> getSyncStatus({String? workspaceId}) async {
    try {
      final response = await _dio.get(
        '/sync/status',
        queryParameters: {
          'device_id': config.deviceId,
          if (workspaceId != null) 'workspace_id': workspaceId,
        },
      );

      return response.data as Map<String, dynamic>?;
    } catch (e) {
      _logger.e('Failed to get sync status', error: e);
      return null;
    }
  }

  /// Reset sync state (for testing/debugging)
  Future<bool> resetSyncState({String? workspaceId, String? entityType}) async {
    try {
      await _dio.post(
        '/sync/reset',
        data: {
          'device_id': config.deviceId,
          if (workspaceId != null) 'workspace_id': workspaceId,
          if (entityType != null) 'entity_type': entityType,
        },
      );

      // Also clear local sync state
      if (entityType != null) {
        await _database.updateSyncState(
          entityType: entityType,
          lastSyncAt: null,
          syncStatus: 'idle',
        );
      } else {
        // Clear all sync states
        await _database.clearAllData();
      }

      return true;
    } catch (e) {
      _logger.e('Failed to reset sync state', error: e);
      return false;
    }
  }

  // ============================================================================
  // Utility Methods
  // ============================================================================

  /// Get count of unsynced local changes
  Future<int> getUnsyncedCount() async {
    return await _database.getUnsyncedCount();
  }

  /// Get count of pending operations
  Future<int> getPendingOperationsCount() async {
    final operations = await _database.getAllPendingOperations();
    return operations.length;
  }

  /// Check if sync is needed
  Future<bool> needsSync() async {
    final pendingCount = await getPendingOperationsCount();
    final unsyncedCount = await getUnsyncedCount();
    return pendingCount > 0 || unsyncedCount > 0;
  }

  /// Get last sync time for entity type
  Future<DateTime?> getLastSyncTime(String entityType) async {
    final syncState = await _database.getSyncState(entityType);
    return syncState?.lastSyncAt;
  }
}

/// Generate a unique device ID
String generateDeviceId() {
  const uuid = Uuid();
  return uuid.v4();
}

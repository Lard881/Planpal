import 'dart:async';
import 'package:flutter/foundation.dart';
import '../db/app_database.dart';
import '../network/api_client.dart';
import 'sync_queue.dart';
import 'sync_timestamps.dart';
import 'sync_logger.dart';
import 'sync_log.dart';

/// Callback for when tasks are synced (for reminder rescheduling)
typedef TaskSyncCallback = Future<void> Function(List<String> taskIds);

/// Manages bidirectional sync between local database and server
/// - Processes outbox queue (local changes → server)
/// - Pulls remote changes (server → local)
/// - Handles conflicts with configurable strategies
/// - Workspace-scoped: only syncs data for the current workspace
/// - Incremental sync: only fetches data changed since last sync
class SyncEngine {
  final ApiClient _api;
  final SyncQueue _syncQueue;
  final SyncTimestamps? _timestamps;
  final SyncLogger _logger;
  Timer? _syncTimer;
  bool _isSyncing = false;
  ConflictResolutionStrategy _conflictStrategy = ConflictResolutionStrategy.lastWriteWins;
  String? _currentWorkspaceId;
  
  // Callback for rescheduling reminders when tasks are synced
  TaskSyncCallback? _onTasksSynced;
  
  final _syncStateController = StreamController<SyncState>.broadcast();
  Stream<SyncState> get syncState => _syncStateController.stream;
  
  final _conflictsController = StreamController<SyncConflict>.broadcast();
  Stream<SyncConflict> get conflicts => _conflictsController.stream;

  SyncEngine({
    required AppDatabase database,
    required ApiClient apiClient,
    ConflictResolutionStrategy conflictStrategy = ConflictResolutionStrategy.lastWriteWins,
    SyncQueue? syncQueue,
    String? initialWorkspaceId,
    SyncTimestamps? timestamps,
    SyncLogger? logger,
    TaskSyncCallback? onTasksSynced,
  })  : _api = apiClient,
        _syncQueue = syncQueue ?? SyncQueue(),
        _conflictStrategy = conflictStrategy,
        _currentWorkspaceId = initialWorkspaceId,
        _timestamps = timestamps,
        _logger = logger ?? SyncLogger(),
        _onTasksSynced = onTasksSynced;

  /// Get sync queue for monitoring
  SyncQueue get queue => _syncQueue;
  
  /// Get sync logger for viewing logs
  SyncLogger get logger => _logger;
  
  /// Get current workspace ID
  String? get currentWorkspaceId => _currentWorkspaceId;
  
  /// Set current workspace ID and optionally trigger sync
  void setWorkspace(String workspaceId, {bool syncImmediately = true}) {
    if (_currentWorkspaceId == workspaceId) {
      debugPrint('[SyncEngine] Already in workspace: $workspaceId');
      return;
    }
    
    debugPrint('[SyncEngine] Switching to workspace: $workspaceId');
    _logger.info(
      SyncLogType.syncStart,
      'Switched to workspace: $workspaceId',
      workspaceId: workspaceId,
    );
    
    _currentWorkspaceId = workspaceId;
    
    // Clear queue when switching workspaces to avoid cross-workspace sync
    _syncQueue.clear();
    
    if (syncImmediately) {
      sync();
    }
  }

  /// Set callback for when tasks are synced (for reminder rescheduling)
  void setTaskSyncCallback(TaskSyncCallback? callback) {
    _onTasksSynced = callback;
  }

  /// Change conflict resolution strategy
  void setConflictStrategy(ConflictResolutionStrategy strategy) {
    _conflictStrategy = strategy;
    debugPrint('[SyncEngine] Conflict resolution strategy changed to: $strategy');
    _logger.info(
      SyncLogType.syncStart,
      'Conflict resolution strategy changed to: $strategy',
      workspaceId: _currentWorkspaceId,
      metadata: {'strategy': strategy.toString()},
    );
  }

  /// Start periodic sync (every 30 seconds)
  void startPeriodicSync({Duration interval = const Duration(seconds: 30)}) {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(interval, (_) => sync());
    debugPrint('[SyncEngine] Periodic sync started (interval: $interval)');
    _logger.info(
      SyncLogType.syncStart,
      'Periodic sync started (interval: ${interval.inSeconds}s)',
      workspaceId: _currentWorkspaceId,
    );
  }

  /// Stop periodic sync
  void stopPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
    debugPrint('[SyncEngine] Periodic sync stopped');
    _logger.info(
      SyncLogType.syncComplete,
      'Periodic sync stopped',
      workspaceId: _currentWorkspaceId,
    );
  }

  /// Perform full sync: push outbox then pull changes
  Future<void> sync() async {
    if (_isSyncing) {
      debugPrint('[SyncEngine] Sync already in progress, skipping');
      return;
    }

    if (_currentWorkspaceId == null) {
      debugPrint('[SyncEngine] No workspace set, skipping sync');
      return;
    }

    _isSyncing = true;
    _syncStateController.add(SyncState.syncing);
    
    _logger.info(
      SyncLogType.syncStart,
      'Starting sync for workspace: $_currentWorkspaceId',
      workspaceId: _currentWorkspaceId,
    );

    try {
      debugPrint('[SyncEngine] Starting sync for workspace: $_currentWorkspaceId');
      
      // Step 1: Push local changes
      await _pushOutbox();
      
      // Step 2: Pull remote changes
      await _pullChanges();
      
      _syncStateController.add(SyncState.idle);
      debugPrint('[SyncEngine] Sync completed successfully for workspace: $_currentWorkspaceId');
      _logger.info(
        SyncLogType.syncComplete,
        'Sync completed successfully',
        workspaceId: _currentWorkspaceId,
      );
    } catch (e, stack) {
      debugPrint('[SyncEngine] Sync failed: $e\n$stack');
      _syncStateController.add(SyncState.error);
      _logger.error(
        SyncLogType.syncFailed,
        'Sync failed: $e',
        workspaceId: _currentWorkspaceId,
        errorDetails: stack.toString(),
      );
      rethrow;
    } finally {
      _isSyncing = false;
    }
  }

  /// Push all pending changes from outbox to server
  Future<void> _pushOutbox() async {
    // Get operations ready for processing
    final operations = _syncQueue.getReadyOperations(limit: 20);
    
    if (operations.isEmpty) {
      debugPrint('[SyncEngine] No operations ready to sync');
      return;
    }

    debugPrint('[SyncEngine] Processing ${operations.length} sync operations');
    _logger.info(
      SyncLogType.pushOperation,
      'Processing ${operations.length} sync operations',
      workspaceId: _currentWorkspaceId,
      metadata: {'operationCount': operations.length},
    );

    for (final operation in operations) {
      try {
        await _processOperation(operation);
        _syncQueue.remove(operation.id);
        debugPrint('[SyncEngine] ✓ Processed: ${operation.entityType} ${operation.action} ${operation.entityId}');
        _logger.debug(
          SyncLogType.pushOperation,
          'Processed: ${operation.entityType} ${operation.action}',
          entityType: operation.entityType,
          entityId: operation.entityId,
          workspaceId: _currentWorkspaceId,
        );
      } catch (e) {
        debugPrint('[SyncEngine] ✗ Failed: ${operation.entityType} ${operation.action} ${operation.entityId} - $e');
        _syncQueue.requeueWithRetry(operation, e.toString());
        _logger.error(
          SyncLogType.pushOperation,
          'Failed: ${operation.entityType} ${operation.action}',
          entityType: operation.entityType,
          entityId: operation.entityId,
          workspaceId: _currentWorkspaceId,
          errorDetails: e.toString(),
        );
      }
    }

    // Log queue stats
    final stats = _syncQueue.getStats();
    debugPrint('[SyncEngine] Queue stats: ${stats['total']} pending, ${stats['failed']} failed, ${stats['ready']} ready');
  }

  /// Process a single sync operation
  Future<void> _processOperation(SyncOperation operation) async {
    final endpoint = _getEndpoint(operation.entityType);
    
    switch (operation.action) {
      case 'create':
        await _api.post(endpoint, data: operation.data);
        break;
        
      case 'update':
        await _api.patch('$endpoint/${operation.entityId}', data: operation.data);
        break;
        
      case 'delete':
        await _api.delete('$endpoint/${operation.entityId}');
        break;
        
      default:
        throw Exception('Unknown action: ${operation.action}');
    }
  }

  /// Get API endpoint for entity type
  String _getEndpoint(String entityType) {
    switch (entityType) {
      case 'task':
        return '/tasks';
      case 'project':
        return '/projects';
      case 'label':
        return '/labels';
      case 'workspace':
        return '/workspaces';
      case 'comment':
        return '/comments';
      case 'activity':
        return '/activities';
      default:
        throw Exception('Unknown entity type: $entityType');
    }
  }

  /// Queue a change for sync (called by repositories)
  /// Only queues changes for entities in the current workspace
  void queueChange({
    required String entityType,
    required String entityId,
    required String action,
    required Map<String, dynamic> data,
    String? workspaceId,
  }) {
    // Validate workspace - only queue if matches current workspace
    final entityWorkspace = workspaceId ?? data['workspace_id'] as String?;
    
    if (entityWorkspace != null && _currentWorkspaceId != null && entityWorkspace != _currentWorkspaceId) {
      debugPrint('[SyncEngine] Skipping queue - entity workspace ($entityWorkspace) does not match current workspace ($_currentWorkspaceId)');
      return;
    }
    
    final operation = SyncOperation(
      id: '${entityType}_${entityId}_${action}_${DateTime.now().millisecondsSinceEpoch}',
      entityType: entityType,
      entityId: entityId,
      action: action,
      data: data,
      createdAt: DateTime.now(),
    );
    
    _syncQueue.enqueue(operation);
    debugPrint('[SyncEngine] Queued: ${operation.entityType} ${operation.action} ${operation.entityId} for workspace: $entityWorkspace');
  }

  /// Retry all failed operations
  void retryFailedOperations() {
    _syncQueue.retryAllFailed();
    debugPrint('[SyncEngine] Retrying all failed operations');
  }

  /// Get failed operations for UI display
  List<SyncOperation> getFailedOperations() {
    return _syncQueue.failedOperations;
  }
  
  /// Get workspace-specific sync statistics
  Map<String, dynamic> getWorkspaceStats() {
    final stats = _syncQueue.getStats();
    final workspaceId = _currentWorkspaceId;
    stats['currentWorkspaceId'] = workspaceId;
    stats['isSyncing'] = _isSyncing;
    
    // Add timestamp information if available
    if (_timestamps != null && workspaceId != null) {
      stats['lastSyncTimes'] = {
        'tasks': _timestamps.getTimeSinceLastSync(workspaceId, 'tasks'),
        'projects': _timestamps.getTimeSinceLastSync(workspaceId, 'projects'),
        'labels': _timestamps.getTimeSinceLastSync(workspaceId, 'labels'),
      };
      
      stats['incrementalSyncEnabled'] = {
        'tasks': _timestamps.canUseIncrementalSync(workspaceId, 'tasks'),
        'projects': _timestamps.canUseIncrementalSync(workspaceId, 'projects'),
        'labels': _timestamps.canUseIncrementalSync(workspaceId, 'labels'),
      };
    }
    
    return stats;
  }
  
  /// Clear all pending operations for current workspace
  /// Use when leaving a workspace or encountering sync issues
  void clearWorkspaceQueue() {
    _syncQueue.clear();
    debugPrint('[SyncEngine] Cleared queue for workspace: $_currentWorkspaceId');
  }

  /// Pull remote changes and merge into local database
  /// Uses incremental sync when timestamps are available
  Future<void> _pullChanges() async {
    if (_currentWorkspaceId == null) {
      debugPrint('[SyncEngine] No workspace ID, skipping pull');
      return;
    }

    try {
      // Pull tasks with incremental sync
      await _pullEntityChanges('tasks', _mergeTasksChanges);

      // Pull projects with incremental sync
      await _pullEntityChanges('projects', _mergeProjectsChanges);

      // Pull labels with incremental sync
      await _pullEntityChanges('labels', _mergeLabelsChanges);
      
      // Pull comments with incremental sync
      await _pullEntityChanges('comments', _mergeCommentsChanges);
      
      // Pull activities with incremental sync
      await _pullEntityChanges('activities', _mergeActivitiesChanges);
      
      debugPrint('[SyncEngine] Pulled changes for workspace: $_currentWorkspaceId');
    } catch (e) {
      debugPrint('[SyncEngine] Error pulling changes: $e');
      rethrow;
    }
  }

  /// Pull changes for a specific entity type with incremental sync support
  Future<void> _pullEntityChanges(
    String entityType,
    Future<void> Function(List<dynamic>) mergeFunction,
  ) async {
    final workspaceId = _currentWorkspaceId;
    if (workspaceId == null) return;

    // Build query parameters
    final queryParams = <String, String>{
      'workspace_id': workspaceId,
    };

    // Add incremental sync timestamp if available
    if (_timestamps != null) {
      final lastSync = _timestamps.getLastSyncTime(workspaceId, entityType);
      
      if (lastSync != null) {
        // Only fetch changes since last sync
        queryParams['updated_since'] = lastSync.toIso8601String();
        debugPrint('[SyncEngine] Incremental sync for $entityType since ${lastSync.toIso8601String()}');
      } else {
        debugPrint('[SyncEngine] Full sync for $entityType (first sync)');
      }
    }

    // Construct query string
    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    // Fetch data
    final response = await _api.get('/$entityType?$queryString');
    
    if (response.data != null && response.data[entityType] != null) {
      final items = response.data[entityType] as List;
      await mergeFunction(items);
      
      // Update last sync timestamp
      if (_timestamps != null) {
        await _timestamps.setLastSyncTime(
          workspaceId,
          entityType,
          DateTime.now(),
        );
      }
      
      debugPrint('[SyncEngine] Merged ${items.length} $entityType items');
    }
  }

  /// Merge remote tasks into local database with conflict resolution
  Future<void> _mergeTasksChanges(List<dynamic> remoteTasks) async {
    final syncedTaskIds = <String>[];
    
    for (final remoteTask in remoteTasks) {
      try {
        final taskMap = remoteTask as Map<String, dynamic>;
        final taskId = taskMap['id'] as String;
        
        syncedTaskIds.add(taskId);
        
        // TODO: Implement when tasksDao is available
        // For now, just log
        debugPrint('[SyncEngine] Would merge task: $taskId');
        
        // Example of conflict resolution logic:
        // final localTask = await _db.tasksDao.getById(taskId);
        // if (localTask != null) {
        //   final shouldUpdate = await _shouldApplyRemoteChange(
        //     entityType: 'task',
        //     entityId: taskId,
        //     localData: _taskToMap(localTask),
        //     remoteData: taskMap,
        //     localUpdatedAt: localTask.updatedAt,
        //     remoteUpdatedAt: DateTime.parse(taskMap['updated_at']),
        //   );
        //   if (shouldUpdate) {
        //     await _db.tasksDao.update(...);
        //   }
        // }
      } catch (e) {
        debugPrint('[SyncEngine] Error merging task: $e');
      }
    }
    
    // Notify reminder scheduler if tasks were synced
    if (syncedTaskIds.isNotEmpty && _onTasksSynced != null) {
      try {
        await _onTasksSynced!(syncedTaskIds);
        debugPrint('[SyncEngine] Notified reminder scheduler for ${syncedTaskIds.length} tasks');
      } catch (e) {
        debugPrint('[SyncEngine] Error in task sync callback: $e');
      }
    }
  }

  /// Merge remote projects into local database
  Future<void> _mergeProjectsChanges(List<dynamic> remoteProjects) async {
    debugPrint('[SyncEngine] Merged ${remoteProjects.length} projects (not yet implemented)');
  }

  /// Merge remote labels into local database
  /// Labels use last-write-wins for conflict resolution
  Future<void> _mergeLabelsChanges(List<dynamic> remoteLabels) async {
    debugPrint('[SyncEngine] Merging ${remoteLabels.length} labels');
    
    for (final remoteLabel in remoteLabels) {
      try {
        final labelMap = remoteLabel as Map<String, dynamic>;
        final labelId = labelMap['id'] as String;
        final labelName = labelMap['name'] as String;
        
        // Labels use last-write-wins conflict resolution
        // This is appropriate because:
        // 1. Label edits are infrequent
        // 2. Label names and colors are simple properties with no complex state
        // 3. Cross-user conflicts are rare (labels are workspace-scoped)
        
        debugPrint('[SyncEngine] Synced label: $labelId ($labelName)');
        
        _logger.debug(
          SyncLogType.pullOperation,
          'Synced label: $labelName',
          entityType: 'label',
          entityId: labelId,
          workspaceId: _currentWorkspaceId,
        );
        
        // Note: Actual database insertion should be handled by LabelRepository
        // The repository should watch the API and sync labels independently,
        // or the sync engine should be passed a repository reference
      } catch (e) {
        debugPrint('[SyncEngine] Error merging label: $e');
        _logger.error(
          SyncLogType.pullOperation,
          'Failed to sync label: $e',
          entityType: 'label',
          workspaceId: _currentWorkspaceId,
        );
      }
    }
  }

  /// Merge remote comments into local database with conflict resolution
  /// Comments are mostly append-only (creates don't conflict)
  /// Only edits and deletes can conflict
  Future<void> _mergeCommentsChanges(List<dynamic> remoteComments) async {
    debugPrint('[SyncEngine] Merging ${remoteComments.length} comments');
    
    for (final remoteComment in remoteComments) {
      try {
        final commentMap = remoteComment as Map<String, dynamic>;
        final commentId = commentMap['id'] as String;
        
        // Comments use last-write-wins for conflict resolution
        // This is because:
        // 1. New comments (creates) never conflict - they just get different IDs
        // 2. Edits are rare and last-write-wins is acceptable
        // 3. Deletes are soft deletes (deleted_at timestamp) - also last-write-wins
        
        debugPrint('[SyncEngine] Synced comment: $commentId');
        
        _logger.debug(
          SyncLogType.pullOperation,
          'Synced comment',
          entityType: 'comment',
          entityId: commentId,
          workspaceId: _currentWorkspaceId,
        );
      } catch (e) {
        debugPrint('[SyncEngine] Error merging comment: $e');
        _logger.error(
          SyncLogType.pullOperation,
          'Failed to sync comment: $e',
          entityType: 'comment',
          workspaceId: _currentWorkspaceId,
        );
      }
    }
  }

  /// Merge remote activities into local database
  /// Activities are append-only audit logs - no conflicts possible
  Future<void> _mergeActivitiesChanges(List<dynamic> remoteActivities) async {
    debugPrint('[SyncEngine] Merging ${remoteActivities.length} activities');
    
    for (final remoteActivity in remoteActivities) {
      try {
        final activityMap = remoteActivity as Map<String, dynamic>;
        final activityId = activityMap['id'] as String;
        
        // Activities are immutable audit logs
        // They never conflict - just get appended to the timeline
        // No edits or deletes allowed
        
        debugPrint('[SyncEngine] Synced activity: $activityId');
        
        _logger.debug(
          SyncLogType.pullOperation,
          'Synced activity',
          entityType: 'activity',
          entityId: activityId,
          workspaceId: _currentWorkspaceId,
        );
      } catch (e) {
        debugPrint('[SyncEngine] Error merging activity: $e');
        _logger.error(
          SyncLogType.pullOperation,
          'Failed to sync activity: $e',
          entityType: 'activity',
          workspaceId: _currentWorkspaceId,
        );
      }
    }
  }

  /// Determine if remote change should be applied based on conflict strategy
  /// This will be used when full DAO layer is implemented
  // ignore: unused_element
  Future<bool> _shouldApplyRemoteChange({
    required String entityType,
    required String entityId,
    required Map<String, dynamic> localData,
    required Map<String, dynamic> remoteData,
    required DateTime localUpdatedAt,
    required DateTime remoteUpdatedAt,
  }) async {
    switch (_conflictStrategy) {
      case ConflictResolutionStrategy.serverWins:
        // Always use server data
        debugPrint('[SyncEngine] Conflict resolved: server wins for $entityType:$entityId');
        return true;
        
      case ConflictResolutionStrategy.clientWins:
        // Always keep local data
        debugPrint('[SyncEngine] Conflict resolved: client wins for $entityType:$entityId');
        return false;
        
      case ConflictResolutionStrategy.lastWriteWins:
        // Use timestamp to determine winner
        final serverWins = remoteUpdatedAt.isAfter(localUpdatedAt);
        debugPrint('[SyncEngine] Conflict resolved: ${serverWins ? "server" : "client"} wins (timestamp) for $entityType:$entityId');
        return serverWins;
        
      case ConflictResolutionStrategy.manual:
        // Emit conflict for manual resolution
        debugPrint('[SyncEngine] Conflict detected: manual resolution required for $entityType:$entityId');
        _conflictsController.add(SyncConflict(
          entityType: entityType,
          entityId: entityId,
          localData: localData,
          remoteData: remoteData,
          localUpdatedAt: localUpdatedAt,
          remoteUpdatedAt: remoteUpdatedAt,
        ));
        _syncStateController.add(SyncState.conflict);
        // Don't update for now - wait for manual resolution
        return false;
    }
  }

  /// Manually resolve a conflict by choosing which version to keep
  Future<void> resolveConflict(SyncConflict conflict, bool useLocal) async {
    debugPrint('[SyncEngine] Resolving conflict for ${conflict.entityType}:${conflict.entityId} - useLocal: $useLocal');
    
    if (useLocal) {
      // Push local version to server
      await _pushEntityToServer(conflict.entityType, conflict.entityId, conflict.localData);
    } else {
      // Apply remote version to local
      await _applyRemoteData(conflict.entityType, conflict.entityId, conflict.remoteData);
    }
  }

  /// Push a specific entity to server
  Future<void> _pushEntityToServer(String entityType, String entityId, Map<String, dynamic> data) async {
    switch (entityType) {
      case 'task':
        await _api.patch('/tasks/$entityId', data: data);
        break;
      case 'project':
        await _api.patch('/projects/$entityId', data: data);
        break;
      case 'label':
        await _api.patch('/labels/$entityId', data: data);
        break;
      case 'comment':
        await _api.patch('/comments/$entityId', data: data);
        break;
      case 'activity':
        // Activities are immutable - cannot be updated
        throw Exception('Activities cannot be updated');
    }
  }

  /// Apply remote data to local database
  Future<void> _applyRemoteData(String entityType, String entityId, Map<String, dynamic> data) async {
    // TODO: Implement when DAOs are available
    debugPrint('[SyncEngine] Would apply remote data for $entityType:$entityId');
  }

  /// Dispose resources
  void dispose() {
    stopPeriodicSync();
    _syncStateController.close();
    _conflictsController.close();
    _syncQueue.dispose();
  }
}

/// Sync state enum
enum SyncState {
  idle,
  syncing,
  error,
  conflict, // Requires manual resolution
}

/// Conflict resolution strategy
enum ConflictResolutionStrategy {
  /// Server data always wins
  serverWins,
  
  /// Local data always wins (client-side changes take precedence)
  clientWins,
  
  /// Last write wins based on timestamp (default)
  lastWriteWins,
  
  /// Manual resolution required - emit conflict for UI handling
  manual,
}

/// Represents a sync conflict between local and remote data
class SyncConflict {
  final String entityType;
  final String entityId;
  final Map<String, dynamic> localData;
  final Map<String, dynamic> remoteData;
  final DateTime localUpdatedAt;
  final DateTime remoteUpdatedAt;

  SyncConflict({
    required this.entityType,
    required this.entityId,
    required this.localData,
    required this.remoteData,
    required this.localUpdatedAt,
    required this.remoteUpdatedAt,
  });
}


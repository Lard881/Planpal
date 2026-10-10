import 'dart:async';
import 'package:drift/drift.dart';
import '../db/app_database.dart';
import '../network/api_client.dart';
import '../utils/logger.dart';

/// Sync service for pulling changes from server
/// 
/// Features:
/// - Fetches changes since last sync timestamp
/// - Merges into local Drift database
/// - Handles soft-deleted rows
/// - Stores serverTime for next sync
/// - Thread-safe with lock mechanism
class SyncService {
  final AppDatabase _database;
  final ApiClient _apiClient;
  
  bool _isSyncing = false;
  DateTime? _lastSyncTime;
  
  SyncService({
    required AppDatabase database,
    required ApiClient apiClient,
  })  : _database = database,
        _apiClient = apiClient;

  /// Check if sync is currently in progress
  bool get isSyncing => _isSyncing;

  /// Get last successful sync time
  DateTime? get lastSyncTime => _lastSyncTime;

  /// Pull changes from server for a workspace
  /// 
  /// Returns true if sync was successful, false otherwise
  Future<bool> pullChanges(String workspaceId) async {
    // Prevent concurrent syncs
    if (_isSyncing) {
      logger.w('📥 Sync already in progress, skipping');
      return false;
    }

    _isSyncing = true;
    
    try {
      logger.i('📥 Starting sync for workspace: $workspaceId');
      
      // Get last sync time from database
      final lastSync = await _getLastSyncTime(workspaceId);
      final sinceParam = lastSync?.toIso8601String();
      
      logger.d('📥 Last sync: ${sinceParam ?? "never"}');

      // Call sync endpoint
      final response = await _apiClient.get(
        '/workspaces/$workspaceId/sync',
        queryParameters: sinceParam != null ? {'since': sinceParam} : null,
      );

      final serverTime = DateTime.parse(response.data['serverTime'] as String);
      
      // Process each entity type
      await _processLabels(
        workspaceId,
        (response.data['labels'] as List?)?.cast<Map<String, dynamic>>() ?? [],
      );
      
      await _processMembers(
        workspaceId,
        (response.data['members'] as List?)?.cast<Map<String, dynamic>>() ?? [],
      );
      
      // TODO: Add more entity types as they're implemented
      // - tasks
      // - subtasks
      // - events
      // - channels
      // - documents
      // etc.

      // Store new sync time
      await _setLastSyncTime(workspaceId, serverTime);
      _lastSyncTime = serverTime;
      
      final hasMore = response.data['hasMore'] as bool? ?? false;
      
      if (hasMore) {
        logger.w('📥 More data available, will sync again');
        // Recursively pull more data
        return await pullChanges(workspaceId);
      }
      
      logger.i('📥 Sync completed successfully');
      return true;
      
    } catch (e, stackTrace) {
      logger.e('📥 Sync failed', error: e, stackTrace: stackTrace);
      return false;
    } finally {
      _isSyncing = false;
    }
  }

  /// Process labels from sync response
  Future<void> _processLabels(
    String workspaceId,
    List<Map<String, dynamic>> labels,
  ) async {
    if (labels.isEmpty) return;

    logger.d('📥 Processing ${labels.length} labels');

    for (final labelData in labels) {
      final id = labelData['id'] as String;
      final deletedAt = labelData['deleted_at'] as String?;

      if (deletedAt != null) {
        // Soft-deleted on server - remove locally
        await (_database.delete(_database.labels)
              ..where((tbl) => tbl.id.equals(id)))
            .go();
        logger.d('📥 Deleted label: $id');
      } else {
        // Insert or update
        await _database.into(_database.labels).insertOnConflictUpdate(
              LabelsCompanion(
                id: Value(id),
                workspaceId: Value(workspaceId),
                name: Value(labelData['name'] as String),
                color: Value(labelData['color'] as String),
                createdAt: Value(DateTime.parse(labelData['created_at'] as String)),
                updatedAt: Value(DateTime.parse(labelData['updated_at'] as String)),
              ),
            );
        logger.d('📥 Synced label: ${labelData['name']}');
      }
    }
  }

  /// Process members from sync response
  Future<void> _processMembers(
    String workspaceId,
    List<Map<String, dynamic>> members,
  ) async {
    if (members.isEmpty) return;

    logger.d('📥 Processing ${members.length} members');

    for (final memberData in members) {
      final id = memberData['id'] as String;
      final deletedAt = memberData['deleted_at'] as String?;

      if (deletedAt != null) {
        // Member left or was removed
        await (_database.delete(_database.workspaceMembers)
              ..where((tbl) => tbl.id.equals(id)))
            .go();
        logger.d('📥 Removed member: $id');
      } else {
        // Insert or update
        await _database.into(_database.workspaceMembers).insertOnConflictUpdate(
              WorkspaceMembersCompanion(
                id: Value(id),
                workspaceId: Value(workspaceId),
                userId: Value(memberData['user_id'] as String),
                role: Value(memberData['role'] as String),
                joinedAt: Value(DateTime.parse(memberData['joined_at'] as String)),
                updatedAt: Value(DateTime.parse(memberData['updated_at'] as String)),
              ),
            );
        logger.d('📥 Synced member: ${memberData['user_id']}');
      }
    }
  }

  /// Get last sync time for a workspace
  Future<DateTime?> _getLastSyncTime(String workspaceId) async {
    final result = await (_database.select(_database.syncMetadata)
          ..where((tbl) => tbl.workspaceId.equals(workspaceId)))
        .getSingleOrNull();

    return result?.lastSyncTime;
  }

  /// Store last sync time for a workspace
  Future<void> _setLastSyncTime(String workspaceId, DateTime time) async {
    await _database.into(_database.syncMetadata).insertOnConflictUpdate(
          SyncMetadataCompanion(
            workspaceId: Value(workspaceId),
            lastSyncTime: Value(time),
          ),
        );
  }

  /// Clear all sync data for a workspace
  Future<void> clearWorkspaceData(String workspaceId) async {
    logger.i('🗑️  Clearing all data for workspace: $workspaceId');

    await _database.transaction(() async {
      // Delete labels
      await (_database.delete(_database.labels)
            ..where((tbl) => tbl.workspaceId.equals(workspaceId)))
          .go();

      // Delete workspace members
      await (_database.delete(_database.workspaceMembers)
            ..where((tbl) => tbl.workspaceId.equals(workspaceId)))
          .go();

      // Delete sync metadata
      await (_database.delete(_database.syncMetadata)
            ..where((tbl) => tbl.workspaceId.equals(workspaceId)))
          .go();

      // TODO: Delete other entity types as they're added
    });

    logger.i('🗑️  Workspace data cleared');
  }
}

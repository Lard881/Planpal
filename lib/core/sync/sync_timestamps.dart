import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages last sync timestamps for incremental sync
/// Tracks when each entity type was last synced per workspace
class SyncTimestamps {
  static const String _keyPrefix = 'last_sync_';
  
  final SharedPreferences _prefs;

  SyncTimestamps(this._prefs);

  /// Get last sync timestamp for an entity type in a workspace
  DateTime? getLastSyncTime(String workspaceId, String entityType) {
    final key = _buildKey(workspaceId, entityType);
    final timestamp = _prefs.getString(key);
    
    if (timestamp == null) return null;
    
    try {
      return DateTime.parse(timestamp);
    } catch (e) {
      debugPrint('[SyncTimestamps] Failed to parse timestamp for $key: $e');
      return null;
    }
  }

  /// Set last sync timestamp for an entity type in a workspace
  Future<void> setLastSyncTime(
    String workspaceId,
    String entityType,
    DateTime timestamp,
  ) async {
    final key = _buildKey(workspaceId, entityType);
    await _prefs.setString(key, timestamp.toIso8601String());
    debugPrint('[SyncTimestamps] Updated $key to ${timestamp.toIso8601String()}');
  }

  /// Get last sync time for all entity types in a workspace
  Map<String, DateTime?> getAllSyncTimes(String workspaceId) {
    return {
      'tasks': getLastSyncTime(workspaceId, 'tasks'),
      'projects': getLastSyncTime(workspaceId, 'projects'),
      'labels': getLastSyncTime(workspaceId, 'labels'),
    };
  }

  /// Clear all sync timestamps for a workspace
  Future<void> clearWorkspaceSyncTimes(String workspaceId) async {
    final entityTypes = ['tasks', 'projects', 'labels'];
    
    for (final entityType in entityTypes) {
      final key = _buildKey(workspaceId, entityType);
      await _prefs.remove(key);
    }
    
    debugPrint('[SyncTimestamps] Cleared all sync times for workspace: $workspaceId');
  }

  /// Clear all sync timestamps (reset sync state)
  Future<void> clearAllSyncTimes() async {
    final keys = _prefs.getKeys()
        .where((key) => key.startsWith(_keyPrefix))
        .toList();
    
    for (final key in keys) {
      await _prefs.remove(key);
    }
    
    debugPrint('[SyncTimestamps] Cleared all sync timestamps');
  }

  /// Build storage key for workspace + entity type
  String _buildKey(String workspaceId, String entityType) {
    return '$_keyPrefix${workspaceId}_$entityType';
  }

  /// Check if incremental sync is possible for an entity type
  /// Returns false if this is the first sync or timestamp is too old
  bool canUseIncrementalSync(
    String workspaceId,
    String entityType, {
    Duration maxAge = const Duration(days: 7),
  }) {
    final lastSync = getLastSyncTime(workspaceId, entityType);
    
    if (lastSync == null) {
      return false; // First sync - need full sync
    }
    
    final age = DateTime.now().difference(lastSync);
    if (age > maxAge) {
      return false; // Too old - safer to do full sync
    }
    
    return true;
  }

  /// Get time since last sync for debugging
  String getTimeSinceLastSync(String workspaceId, String entityType) {
    final lastSync = getLastSyncTime(workspaceId, entityType);
    
    if (lastSync == null) {
      return 'Never synced';
    }
    
    final diff = DateTime.now().difference(lastSync);
    
    if (diff.inDays > 0) {
      return '${diff.inDays} day(s) ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hour(s) ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} minute(s) ago';
    } else {
      return '${diff.inSeconds} second(s) ago';
    }
  }

  /// Factory method to create instance
  static Future<SyncTimestamps> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SyncTimestamps(prefs);
  }
}

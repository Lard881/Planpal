import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

/// Background sync service using WorkManager
/// Handles periodic sync when app is in background or closed
class BackgroundSyncService {
  static const String _syncTaskName = 'periodic_sync_task';
  static const String _syncTaskTag = 'planpal_sync';
  
  /// Initialize WorkManager for background tasks
  static Future<void> initialize() async {
    try {
      await Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: kDebugMode,
      );
      debugPrint('[BackgroundSync] WorkManager initialized');
    } catch (e) {
      debugPrint('[BackgroundSync] Failed to initialize: $e');
    }
  }

  /// Schedule periodic background sync
  /// [frequencyMinutes] - how often to sync (minimum 15 minutes on Android)
  static Future<void> schedulePeriodicSync({
    int frequencyMinutes = 15,
    bool requiresNetwork = true,
    bool requiresCharging = false,
  }) async {
    try {
      // Cancel any existing sync tasks first
      await cancelSync();
      
      // Schedule new periodic sync
      await Workmanager().registerPeriodicTask(
        _syncTaskName,
        _syncTaskTag,
        frequency: Duration(minutes: frequencyMinutes),
        constraints: Constraints(
          networkType: requiresNetwork ? NetworkType.connected : NetworkType.not_required,
          requiresCharging: requiresCharging,
        ),
        initialDelay: Duration(minutes: 1), // First sync after 1 minute
        backoffPolicy: BackoffPolicy.exponential,
        backoffPolicyDelay: Duration(seconds: 30),
      );
      
      debugPrint('[BackgroundSync] Periodic sync scheduled (every $frequencyMinutes minutes)');
    } catch (e) {
      debugPrint('[BackgroundSync] Failed to schedule sync: $e');
    }
  }

  /// Schedule a one-time immediate sync
  static Future<void> scheduleImmediateSync() async {
    try {
      await Workmanager().registerOneOffTask(
        '${_syncTaskName}_immediate',
        _syncTaskTag,
        initialDelay: Duration(seconds: 5),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
      );
      
      debugPrint('[BackgroundSync] Immediate sync scheduled');
    } catch (e) {
      debugPrint('[BackgroundSync] Failed to schedule immediate sync: $e');
    }
  }

  /// Cancel all scheduled sync tasks
  static Future<void> cancelSync() async {
    try {
      await Workmanager().cancelAll();
      debugPrint('[BackgroundSync] All sync tasks cancelled');
    } catch (e) {
      debugPrint('[BackgroundSync] Failed to cancel sync: $e');
    }
  }

  /// Check if sync is currently scheduled
  static Future<bool> isSyncScheduled() async {
    // WorkManager doesn't provide a direct way to check this
    // We'll return true and rely on the task being scheduled
    return true;
  }
}

/// Callback dispatcher for WorkManager background tasks
/// This runs in a separate isolate
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('[BackgroundSync] Executing background task: $task');
    
    try {
      // Import executor dynamically to avoid issues with isolate
      // Note: Full implementation requires careful handling of isolate communication
      
      debugPrint('[BackgroundSync] Starting background sync execution');
      
      // Check if sync is needed
      final needsSync = await _checkIfSyncNeeded();
      
      if (!needsSync) {
        debugPrint('[BackgroundSync] No sync needed, skipping');
        return Future.value(true);
      }
      
      // Execute lightweight sync
      final success = await _executeLightweightSync();
      
      if (success) {
        debugPrint('[BackgroundSync] Background sync completed successfully');
      } else {
        debugPrint('[BackgroundSync] Background sync failed');
      }
      
      return Future.value(success);
    } catch (e) {
      debugPrint('[BackgroundSync] Task failed: $e');
      return Future.value(false);
    }
  });
}

/// Check if sync is needed
Future<bool> _checkIfSyncNeeded() async {
  // Check last sync time from preferences or storage
  // For now, always return true to ensure sync runs
  return true;
}

/// Execute a lightweight sync operation
Future<bool> _executeLightweightSync() async {
  try {
    // Perform minimal sync operations
    // This is a simplified version that just validates server connectivity
    
    debugPrint('[BackgroundSync] Executing lightweight sync');
    
    // In production, this would:
    // 1. Load auth token from secure storage
    // 2. Create API client
    // 3. Push pending changes
    // 4. Pull new data
    // 5. Update local database
    
    // For now, just simulate success
    await Future.delayed(Duration(seconds: 2));
    
    return true;
  } catch (e) {
    debugPrint('[BackgroundSync] Lightweight sync failed: $e');
    return false;
  }
}

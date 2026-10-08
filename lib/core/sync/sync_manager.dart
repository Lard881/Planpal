import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'sync_service.dart';
import 'sync_providers.dart';

/// Sync manager for orchestrating sync operations
class SyncManager {
  final SyncService _syncService;
  final Logger _logger;
  
  Timer? _periodicSyncTimer;
  bool _isSyncing = false;
  DateTime? _lastSyncAttempt;
  
  final _syncStateController = StreamController<SyncState>.broadcast();
  Stream<SyncState> get syncStateStream => _syncStateController.stream;
  
  SyncState _currentState = SyncState.idle;
  SyncState get currentState => _currentState;

  SyncManager({
    required SyncService syncService,
    Logger? logger,
  })  : _syncService = syncService,
        _logger = logger ?? Logger();

  // ============================================================================
  // Sync Operations
  // ============================================================================

  /// Start automatic periodic sync
  void startPeriodicSync({Duration interval = const Duration(minutes: 5)}) {
    _logger.i('Starting periodic sync (every ${interval.inMinutes} minutes)');
    
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = Timer.periodic(interval, (_) async {
      await sync();
    });
  }

  /// Stop periodic sync
  void stopPeriodicSync() {
    _logger.i('Stopping periodic sync');
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = null;
  }

  /// Perform full sync
  Future<SyncResult> sync({
    String? workspaceId,
    ConflictResolutionStrategy? strategy,
    bool force = false,
  }) async {
    // Prevent concurrent syncs
    if (_isSyncing && !force) {
      _logger.w('Sync already in progress, skipping');
      return SyncResult(
        success: false,
        processed: 0,
        successful: 0,
        failed: 0,
        conflicts: 0,
        errorMessage: 'Sync already in progress',
      );
    }

    // Check if sync is needed
    if (!force) {
      final needsSync = await _syncService.needsSync();
      if (!needsSync) {
        _logger.i('No sync needed');
        return SyncResult(
          success: true,
          processed: 0,
          successful: 0,
          failed: 0,
          conflicts: 0,
        );
      }
    }

    try {
      _isSyncing = true;
      _lastSyncAttempt = DateTime.now();
      _updateState(SyncState.syncing);

      _logger.i('Starting sync...');
      final result = await _syncService.fullSync(
        workspaceId: workspaceId,
        strategy: strategy,
      );

      if (result.success) {
        _logger.i('Sync completed successfully');
        _updateState(SyncState.success);
      } else if (result.hasConflicts) {
        _logger.w('Sync completed with conflicts');
        _updateState(SyncState.conflicts);
      } else {
        _logger.e('Sync failed: ${result.errorMessage}');
        _updateState(SyncState.error);
      }

      return result;
    } catch (e, stack) {
      _logger.e('Sync failed with exception', error: e, stackTrace: stack);
      _updateState(SyncState.error);
      
      return SyncResult(
        success: false,
        processed: 0,
        successful: 0,
        failed: 0,
        conflicts: 0,
        errorMessage: e.toString(),
      );
    } finally {
      _isSyncing = false;
    }
  }

  /// Pull changes only
  Future<SyncResult> pullOnly({String? workspaceId}) async {
    if (_isSyncing) {
      return SyncResult(
        success: false,
        processed: 0,
        successful: 0,
        failed: 0,
        conflicts: 0,
        errorMessage: 'Sync already in progress',
      );
    }

    try {
      _isSyncing = true;
      _updateState(SyncState.syncing);

      final result = await _syncService.pullChanges(workspaceId: workspaceId);

      _updateState(result.success ? SyncState.success : SyncState.error);
      return result;
    } catch (e) {
      _updateState(SyncState.error);
      return SyncResult(
        success: false,
        processed: 0,
        successful: 0,
        failed: 0,
        conflicts: 0,
        errorMessage: e.toString(),
      );
    } finally {
      _isSyncing = false;
    }
  }

  /// Push changes only
  Future<SyncResult> pushOnly({
    String? workspaceId,
    ConflictResolutionStrategy? strategy,
  }) async {
    if (_isSyncing) {
      return SyncResult(
        success: false,
        processed: 0,
        successful: 0,
        failed: 0,
        conflicts: 0,
        errorMessage: 'Sync already in progress',
      );
    }

    try {
      _isSyncing = true;
      _updateState(SyncState.syncing);

      final result = await _syncService.pushChanges(
        workspaceId: workspaceId,
        strategy: strategy,
      );

      if (result.hasConflicts) {
        _updateState(SyncState.conflicts);
      } else {
        _updateState(result.success ? SyncState.success : SyncState.error);
      }

      return result;
    } catch (e) {
      _updateState(SyncState.error);
      return SyncResult(
        success: false,
        processed: 0,
        successful: 0,
        failed: 0,
        conflicts: 0,
        errorMessage: e.toString(),
      );
    } finally {
      _isSyncing = false;
    }
  }

  // ============================================================================
  // State Management
  // ============================================================================

  void _updateState(SyncState newState) {
    _currentState = newState;
    _syncStateController.add(newState);
  }

  // ============================================================================
  // Status & Utility
  // ============================================================================

  /// Check if currently syncing
  bool get isSyncing => _isSyncing;

  /// Get time since last sync attempt
  Duration? get timeSinceLastSync {
    if (_lastSyncAttempt == null) return null;
    return DateTime.now().difference(_lastSyncAttempt!);
  }

  /// Get pending operations count
  Future<int> getPendingCount() async {
    return await _syncService.getPendingOperationsCount();
  }

  /// Get unsynced items count
  Future<int> getUnsyncedCount() async {
    return await _syncService.getUnsyncedCount();
  }

  /// Check if sync is needed
  Future<bool> needsSync() async {
    return await _syncService.needsSync();
  }

  // ============================================================================
  // Lifecycle
  // ============================================================================

  void dispose() {
    _periodicSyncTimer?.cancel();
    _syncStateController.close();
  }
}

/// Sync state enum
enum SyncState {
  idle,
  syncing,
  success,
  error,
  conflicts;

  bool get isLoading => this == SyncState.syncing;
  bool get isIdle => this == SyncState.idle;
  bool get isSuccess => this == SyncState.success;
  bool get isError => this == SyncState.error;
  bool get hasConflicts => this == SyncState.conflicts;
}

/// Sync manager provider
final syncManagerProvider = Provider<SyncManager>((ref) {
  final serviceAsync = ref.watch(syncServiceProvider);
  
  if (serviceAsync is! AsyncData<SyncService>) {
    throw Exception('SyncService not ready');
  }
  
  final manager = SyncManager(
    syncService: serviceAsync.value,
    logger: Logger(),
  );
  
  ref.onDispose(() {
    manager.dispose();
  });
  
  return manager;
});

/// Sync state stream provider
final syncStateStreamProvider = StreamProvider<SyncState>((ref) {
  final manager = ref.watch(syncManagerProvider);
  return manager.syncStateStream;
});

/// Is syncing provider
final isSyncingProvider = Provider<bool>((ref) {
  final stateAsync = ref.watch(syncStateStreamProvider);
  return stateAsync.when(
    data: (state) => state.isLoading,
    loading: () => false,
    error: (_, __) => false,
  );
});
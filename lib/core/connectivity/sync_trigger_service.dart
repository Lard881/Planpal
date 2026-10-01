import 'dart:async';
import 'package:logger/logger.dart';
import 'connectivity_service.dart';
import '../sync/sync_manager.dart';
import '../sync/sync_service.dart';

/// Configuration for sync triggers
class SyncTriggerConfig {
  /// Trigger sync when coming online
  final bool syncOnReconnect;

  /// Trigger sync on app resume
  final bool syncOnResume;

  /// Minimum time between auto-syncs (prevents too frequent syncs)
  final Duration minSyncInterval;

  /// Delay before syncing after reconnect (allows connection to stabilize)
  final Duration reconnectDelay;

  /// Only auto-sync on WiFi (save mobile data)
  final bool wifiOnly;

  const SyncTriggerConfig({
    this.syncOnReconnect = true,
    this.syncOnResume = true,
    this.minSyncInterval = const Duration(minutes: 1),
    this.reconnectDelay = const Duration(seconds: 2),
    this.wifiOnly = false,
  });
}

/// Sync trigger service
/// Automatically triggers sync based on connectivity and app lifecycle events
class SyncTriggerService {
  final ConnectivityService _connectivityService;
  final SyncManager _syncManager;
  final SyncTriggerConfig config;
  final Logger _logger;

  StreamSubscription<ConnectivityState>? _connectivitySubscription;
  DateTime? _lastAutoSync;
  Timer? _reconnectTimer;

  SyncTriggerService({
    required ConnectivityService connectivityService,
    required SyncManager syncManager,
    this.config = const SyncTriggerConfig(),
    Logger? logger,
  })  : _connectivityService = connectivityService,
        _syncManager = syncManager,
        _logger = logger ?? Logger();

  // ============================================================================
  // Initialization
  // ============================================================================

  /// Start listening to triggers
  void start() {
    _logger.i('Starting sync trigger service');

    // Listen to connectivity changes
    _connectivitySubscription = _connectivityService.stateStream.listen(
      _handleConnectivityChange,
      onError: (error) {
        _logger.e('Connectivity stream error', error: error);
      },
    );

    // Initial sync if online
    if (_connectivityService.isOnline) {
      _triggerSync('initial', force: false);
    }
  }

  /// Stop listening to triggers
  void stop() {
    _logger.i('Stopping sync trigger service');
    _connectivitySubscription?.cancel();
    _reconnectTimer?.cancel();
  }

  // ============================================================================
  // Trigger Handlers
  // ============================================================================

  /// Handle connectivity state change
  void _handleConnectivityChange(ConnectivityState state) {
    _logger.i('Connectivity changed: ${state.status.name} (${state.networkType.name})');

    // Trigger sync when coming online
    if (state.justCameOnline && config.syncOnReconnect) {
      _scheduleReconnectSync(state.networkType);
    }
  }

  /// Schedule sync after reconnect with delay
  void _scheduleReconnectSync(NetworkType networkType) {
    // Cancel any pending sync
    _reconnectTimer?.cancel();

    // Check WiFi-only restriction
    if (config.wifiOnly && !networkType.isWifi) {
      _logger.i('Skipping auto-sync: not on WiFi');
      return;
    }

    _logger.i('Scheduling sync in ${config.reconnectDelay.inSeconds}s');

    _reconnectTimer = Timer(config.reconnectDelay, () {
      _triggerSync('reconnect');
    });
  }

  /// Trigger sync on app resume
  Future<void> onAppResume() async {
    if (!config.syncOnResume) return;

    _logger.i('App resumed');

    // Check if online
    if (!_connectivityService.isOnline) {
      _logger.i('Skipping sync: offline');
      return;
    }

    // Check WiFi-only restriction
    if (config.wifiOnly && !_connectivityService.isWifi) {
      _logger.i('Skipping sync: not on WiFi');
      return;
    }

    await _triggerSync('resume');
  }

  /// Trigger sync with reason
  Future<SyncResult?> _triggerSync(String reason, {bool force = false}) async {
    try {
      // Check min interval (unless forced)
      if (!force && _lastAutoSync != null) {
        final timeSinceLastSync = DateTime.now().difference(_lastAutoSync!);
        if (timeSinceLastSync < config.minSyncInterval) {
          _logger.i('Skipping sync: too soon since last sync (${timeSinceLastSync.inSeconds}s ago)');
          return null;
        }
      }

      _logger.i('Triggering auto-sync (reason: $reason)');

      final result = await _syncManager.sync(force: force);

      _lastAutoSync = DateTime.now();

      if (result.success) {
        _logger.i('Auto-sync completed: ${result.successful} changes synced');
      } else {
        _logger.w('Auto-sync failed: ${result.errorMessage}');
      }

      return result;
    } catch (e, stack) {
      _logger.e('Auto-sync error', error: e, stackTrace: stack);
      return null;
    }
  }

  // ============================================================================
  // Manual Triggers
  // ============================================================================

  /// Manually trigger sync
  Future<SyncResult?> triggerManualSync() async {
    _logger.i('Manual sync triggered');
    return await _triggerSync('manual', force: true);
  }

  /// Trigger sync if needed
  Future<SyncResult?> triggerSyncIfNeeded() async {
    // Check if online
    if (!_connectivityService.isOnline) {
      _logger.i('Cannot sync: offline');
      return null;
    }

    // Check if sync needed
    final needsSync = await _syncManager.needsSync();
    if (!needsSync) {
      _logger.i('Sync not needed');
      return null;
    }

    return await _triggerSync('on_demand');
  }

  // ============================================================================
  // Status
  // ============================================================================

  /// Get time since last auto-sync
  Duration? get timeSinceLastSync {
    if (_lastAutoSync == null) return null;
    return DateTime.now().difference(_lastAutoSync!);
  }

  /// Check if sync is allowed (considers WiFi-only setting)
  bool get isSyncAllowed {
    if (!_connectivityService.isOnline) return false;
    if (config.wifiOnly && !_connectivityService.isWifi) return false;
    return true;
  }

  // ============================================================================
  // Lifecycle
  // ============================================================================

  void dispose() {
    stop();
  }
}

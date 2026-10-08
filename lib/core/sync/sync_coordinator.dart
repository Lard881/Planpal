import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'sync_service.dart';
import 'outbox_service.dart';
import '../utils/logger.dart';

/// Sync coordinator that manages automatic sync triggers
/// 
/// Triggers sync on:
/// 1. App start
/// 2. After login
/// 3. Workspace switch
/// 4. Connectivity returns
/// 5. Every 2 minutes (background)
class SyncCoordinator {
  final SyncService _syncService;
  final OutboxService _outboxService;
  final Connectivity _connectivity;
  
  Timer? _periodicTimer;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  String? _currentWorkspaceId;
  bool _isInitialized = false;

  SyncCoordinator({
    required SyncService syncService,
    required OutboxService outboxService,
    Connectivity? connectivity,
  })  : _syncService = syncService,
        _outboxService = outboxService,
        _connectivity = connectivity ?? Connectivity();

  /// Initialize the coordinator
  /// 
  /// Sets up periodic sync and connectivity monitoring
  Future<void> initialize({String? workspaceId}) async {
    if (_isInitialized) {
      logger.w('🔄 SyncCoordinator already initialized');
      return;
    }

    logger.i('🔄 Initializing SyncCoordinator');
    
    _currentWorkspaceId = workspaceId;
    _isInitialized = true;

    // Set up connectivity listener
    _setupConnectivityListener();

    // Set up periodic sync (every 2 minutes)
    _setupPeriodicSync();

    // Trigger initial sync
    if (workspaceId != null) {
      await triggerSync();
    }
  }

  /// Dispose the coordinator
  void dispose() {
    logger.i('🔄 Disposing SyncCoordinator');
    
    _periodicTimer?.cancel();
    _periodicTimer = null;
    
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
    
    _isInitialized = false;
  }

  /// Set current workspace
  /// 
  /// Triggers sync for the new workspace
  Future<void> setWorkspace(String workspaceId) async {
    if (_currentWorkspaceId == workspaceId) {
      return;
    }

    logger.i('🔄 Workspace switched to: $workspaceId');
    _currentWorkspaceId = workspaceId;

    // Trigger sync for new workspace
    await triggerSync();
  }

  /// Manually trigger a sync cycle
  /// 
  /// Returns true if sync was successful
  Future<bool> triggerSync() async {
    if (_currentWorkspaceId == null) {
      logger.w('🔄 No workspace set, skipping sync');
      return false;
    }

    if (!await _isConnected()) {
      logger.d('🔄 Offline, skipping sync');
      return false;
    }

    logger.i('🔄 Triggering sync cycle');

    try {
      // First, push any pending changes
      final pushedCount = await _outboxService.pushChanges();
      logger.d('🔄 Pushed $pushedCount items');

      // Then, pull latest changes from server
      final pullSuccess = await _syncService.pullChanges(_currentWorkspaceId!);
      logger.d('🔄 Pull ${pullSuccess ? "succeeded" : "failed"}');

      return pullSuccess;
    } catch (e, stackTrace) {
      logger.e('🔄 Sync cycle failed', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Trigger after login
  /// 
  /// Called by auth service after successful login
  Future<void> triggerAfterLogin(String workspaceId) async {
    logger.i('🔄 Sync trigger: after login');
    _currentWorkspaceId = workspaceId;
    
    if (!_isInitialized) {
      await initialize(workspaceId: workspaceId);
    }
    
    await triggerSync();
  }

  /// Trigger on app start
  /// 
  /// Called during app initialization
  Future<void> triggerOnStart(String? workspaceId) async {
    logger.i('🔄 Sync trigger: app start');
    
    if (workspaceId != null) {
      _currentWorkspaceId = workspaceId;
      
      if (!_isInitialized) {
        await initialize(workspaceId: workspaceId);
      }
      
      await triggerSync();
    }
  }

  /// Set up connectivity listener
  void _setupConnectivityListener() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) async {
        final isConnected = results.any((result) => 
          result == ConnectivityResult.mobile || 
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet
        );

        if (isConnected) {
          logger.i('🔄 Connectivity restored - triggering sync');
          await triggerSync();
        } else {
          logger.d('🔄 Connectivity lost');
        }
      },
    );
  }

  /// Set up periodic sync timer
  void _setupPeriodicSync() {
    // Sync every 2 minutes
    _periodicTimer = Timer.periodic(
      const Duration(minutes: 2),
      (_) async {
        logger.d('🔄 Periodic sync trigger');
        await triggerSync();
      },
    );
  }

  /// Check if device is connected
  Future<bool> _isConnected() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.any((result) =>
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet
      );
    } catch (e) {
      logger.w('🔄 Failed to check connectivity', error: e);
      return false;
    }
  }

  /// Get pending items count
  Future<int> getPendingCount() => _outboxService.getPendingCount();

  /// Get failed items count
  Future<int> getFailedCount() => _outboxService.getFailedCount();

  /// Check if sync is in progress
  bool get isSyncing => _syncService.isSyncing || _outboxService.isPushing;

  /// Get last sync time
  DateTime? get lastSyncTime => _syncService.lastSyncTime;
}

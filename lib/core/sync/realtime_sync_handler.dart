import 'dart:async';
import 'package:flutter/foundation.dart';
import 'realtime_service.dart';
import 'sync_engine.dart';

/// Coordinates real-time changes with sync engine
/// Automatically triggers sync when remote changes are detected
class RealtimeSyncHandler {
  final RealtimeService _realtimeService;
  final SyncEngine _syncEngine;
  final _subscriptions = <StreamSubscription>[];
  
  // Debounce multiple rapid changes
  Timer? _debounceTimer;
  final Set<String> _pendingEntityTypes = {};
  final Duration _debounceDelay;

  RealtimeSyncHandler({
    required RealtimeService realtimeService,
    required SyncEngine syncEngine,
    Duration debounceDelay = const Duration(milliseconds: 500),
  })  : _realtimeService = realtimeService,
        _syncEngine = syncEngine,
        _debounceDelay = debounceDelay;

  /// Start listening to real-time changes and trigger syncs
  void startListening() {
    debugPrint('[RealtimeSyncHandler] Starting realtime sync handler');

    // Listen to task changes
    _subscriptions.add(
      _realtimeService.taskChanges.listen(
        (change) => _handleChange(change),
        onError: (e) => debugPrint('[RealtimeSyncHandler] Task change stream error: $e'),
      ),
    );

    // Listen to project changes
    _subscriptions.add(
      _realtimeService.projectChanges.listen(
        (change) => _handleChange(change),
        onError: (e) => debugPrint('[RealtimeSyncHandler] Project change stream error: $e'),
      ),
    );

    // Listen to comment changes
    _subscriptions.add(
      _realtimeService.commentChanges.listen(
        (change) => _handleChange(change),
        onError: (e) => debugPrint('[RealtimeSyncHandler] Comment change stream error: $e'),
      ),
    );

    // Listen to attachment changes
    _subscriptions.add(
      _realtimeService.attachmentChanges.listen(
        (change) => _handleChange(change),
        onError: (e) => debugPrint('[RealtimeSyncHandler] Attachment change stream error: $e'),
      ),
    );

    debugPrint('[RealtimeSyncHandler] ✅ Realtime sync handler started');
  }

  /// Handle a real-time change event
  void _handleChange(RealtimeChange change) {
    // Verify workspace matches
    if (change.workspaceId != _syncEngine.currentWorkspaceId) {
      debugPrint('[RealtimeSyncHandler] Ignoring change from different workspace: ${change.workspaceId}');
      return;
    }

    debugPrint('[RealtimeSyncHandler] Realtime change detected: ${change.entityType} ${change.eventType} ${change.entityId}');
    
    // Add to pending entity types
    _pendingEntityTypes.add(change.entityType);
    
    // Debounce: wait for rapid changes to settle before syncing
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDelay, () {
      _triggerSync();
    });
  }

  /// Trigger a sync after debounce period
  void _triggerSync() {
    if (_pendingEntityTypes.isEmpty) return;

    final entityTypes = List<String>.from(_pendingEntityTypes);
    _pendingEntityTypes.clear();

    debugPrint('[RealtimeSyncHandler] Triggering sync for entity types: $entityTypes');
    
    // Trigger full sync to pull latest changes
    _syncEngine.sync().catchError((e) {
      debugPrint('[RealtimeSyncHandler] Sync failed after realtime change: $e');
    });
  }

  /// Subscribe to a workspace
  Future<void> subscribeToWorkspace(String workspaceId) async {
    debugPrint('[RealtimeSyncHandler] Subscribing realtime handler to workspace: $workspaceId');
    await _realtimeService.subscribeToWorkspace(workspaceId);
  }

  /// Unsubscribe from all realtime changes
  Future<void> unsubscribeAll() async {
    debugPrint('[RealtimeSyncHandler] Unsubscribing realtime handler');
    _debounceTimer?.cancel();
    _pendingEntityTypes.clear();
    await _realtimeService.unsubscribeAll();
  }

  /// Stop listening and clean up
  void stopListening() {
    debugPrint('[RealtimeSyncHandler] Stopping realtime sync handler');
    _debounceTimer?.cancel();
    _pendingEntityTypes.clear();
    
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
    
    debugPrint('[RealtimeSyncHandler] ✅ Realtime sync handler stopped');
  }

  /// Dispose of the handler
  void dispose() {
    stopListening();
    _realtimeService.dispose();
  }
}

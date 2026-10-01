import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

/// Manages real-time subscriptions to Supabase database changes
/// Automatically syncs data when changes occur on the server
class RealtimeService {
  final SupabaseService _supabase;
  final Map<String, RealtimeChannel> _channels = {};
  String? _currentWorkspaceId;
  
  // Callbacks for different entity types
  final _taskChangeController = StreamController<RealtimeChange>.broadcast();
  final _projectChangeController = StreamController<RealtimeChange>.broadcast();
  final _commentChangeController = StreamController<RealtimeChange>.broadcast();
  final _attachmentChangeController = StreamController<RealtimeChange>.broadcast();
  
  Stream<RealtimeChange> get taskChanges => _taskChangeController.stream;
  Stream<RealtimeChange> get projectChanges => _projectChangeController.stream;
  Stream<RealtimeChange> get commentChanges => _commentChangeController.stream;
  Stream<RealtimeChange> get attachmentChanges => _attachmentChangeController.stream;

  RealtimeService({SupabaseService? supabaseService})
      : _supabase = supabaseService ?? SupabaseService.instance;

  /// Subscribe to changes for a specific workspace
  Future<void> subscribeToWorkspace(String workspaceId) async {
    if (_currentWorkspaceId == workspaceId && _channels.isNotEmpty) {
      debugPrint('[RealtimeService] Already subscribed to workspace: $workspaceId');
      return;
    }

    // Unsubscribe from previous workspace
    await unsubscribeAll();
    
    _currentWorkspaceId = workspaceId;
    debugPrint('[RealtimeService] Subscribing to realtime changes for workspace: $workspaceId');

    try {
      // Subscribe to each entity type
      await _subscribeToTasks(workspaceId);
      await _subscribeToProjects(workspaceId);
      await _subscribeToComments(workspaceId);
      await _subscribeToAttachments(workspaceId);
      
      debugPrint('[RealtimeService] ✅ Realtime subscriptions active for workspace: $workspaceId');
    } catch (e, stack) {
      debugPrint('[RealtimeService] Failed to subscribe to realtime changes: $e\n$stack');
      rethrow;
    }
  }

  /// Subscribe to task changes
  Future<void> _subscribeToTasks(String workspaceId) async {
    final channel = _supabase.client
        .channel('tasks:$workspaceId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'tasks',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'workspace_id',
            value: workspaceId,
          ),
          callback: (payload) {
            _handleTaskChange(payload);
          },
        )
        .subscribe();

    _channels['tasks'] = channel;
    debugPrint('[RealtimeService] Subscribed to tasks table for workspace: $workspaceId');
  }

  /// Subscribe to project changes
  Future<void> _subscribeToProjects(String workspaceId) async {
    final channel = _supabase.client
        .channel('projects:$workspaceId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'projects',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'workspace_id',
            value: workspaceId,
          ),
          callback: (payload) {
            _handleProjectChange(payload);
          },
        )
        .subscribe();

    _channels['projects'] = channel;
    debugPrint('[RealtimeService] Subscribed to projects table for workspace: $workspaceId');
  }

  /// Subscribe to comment changes
  Future<void> _subscribeToComments(String workspaceId) async {
    final channel = _supabase.client
        .channel('comments:$workspaceId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'comments',
          callback: (payload) {
            _handleCommentChange(payload);
          },
        )
        .subscribe();

    _channels['comments'] = channel;
    debugPrint('[RealtimeService] Subscribed to comments table for workspace: $workspaceId');
  }

  /// Subscribe to attachment changes
  Future<void> _subscribeToAttachments(String workspaceId) async {
    final channel = _supabase.client
        .channel('attachments:$workspaceId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'attachments',
          callback: (payload) {
            _handleAttachmentChange(payload);
          },
        )
        .subscribe();

    _channels['attachments'] = channel;
    debugPrint('[RealtimeService] Subscribed to attachments table for workspace: $workspaceId');
  }

  /// Handle task change events
  void _handleTaskChange(PostgresChangePayload payload) {
    try {
      final change = RealtimeChange(
        entityType: 'tasks',
        eventType: _mapEventType(payload.eventType),
        newRecord: payload.newRecord,
        oldRecord: payload.oldRecord,
        timestamp: DateTime.now(),
      );

      _taskChangeController.add(change);
      debugPrint('[RealtimeService] Task ${change.eventType}: ${change.entityId}');
    } catch (e) {
      debugPrint('[RealtimeService] Error handling task change: $e');
    }
  }

  /// Handle project change events
  void _handleProjectChange(PostgresChangePayload payload) {
    try {
      final change = RealtimeChange(
        entityType: 'projects',
        eventType: _mapEventType(payload.eventType),
        newRecord: payload.newRecord,
        oldRecord: payload.oldRecord,
        timestamp: DateTime.now(),
      );

      _projectChangeController.add(change);
      debugPrint('[RealtimeService] Project ${change.eventType}: ${change.entityId}');
    } catch (e) {
      debugPrint('[RealtimeService] Error handling project change: $e');
    }
  }

  /// Handle comment change events
  void _handleCommentChange(PostgresChangePayload payload) {
    try {
      final change = RealtimeChange(
        entityType: 'comments',
        eventType: _mapEventType(payload.eventType),
        newRecord: payload.newRecord,
        oldRecord: payload.oldRecord,
        timestamp: DateTime.now(),
      );

      _commentChangeController.add(change);
      debugPrint('[RealtimeService] Comment ${change.eventType}: ${change.entityId}');
    } catch (e) {
      debugPrint('[RealtimeService] Error handling comment change: $e');
    }
  }

  /// Handle attachment change events
  void _handleAttachmentChange(PostgresChangePayload payload) {
    try {
      final change = RealtimeChange(
        entityType: 'attachments',
        eventType: _mapEventType(payload.eventType),
        newRecord: payload.newRecord,
        oldRecord: payload.oldRecord,
        timestamp: DateTime.now(),
      );

      _attachmentChangeController.add(change);
      debugPrint('[RealtimeService] Attachment ${change.eventType}: ${change.entityId}');
    } catch (e) {
      debugPrint('[RealtimeService] Error handling attachment change: $e');
    }
  }

  /// Map Supabase event type to our event type
  RealtimeEventType _mapEventType(PostgresChangeEvent event) {
    switch (event) {
      case PostgresChangeEvent.insert:
        return RealtimeEventType.insert;
      case PostgresChangeEvent.update:
        return RealtimeEventType.update;
      case PostgresChangeEvent.delete:
        return RealtimeEventType.delete;
      default:
        return RealtimeEventType.update;
    }
  }

  /// Unsubscribe from all channels
  Future<void> unsubscribeAll() async {
    if (_channels.isEmpty) return;

    debugPrint('[RealtimeService] Unsubscribing from ${_channels.length} realtime channels');

    for (final channel in _channels.values) {
      await _supabase.client.removeChannel(channel);
    }

    _channels.clear();
    _currentWorkspaceId = null;
    
    debugPrint('[RealtimeService] ✅ All realtime subscriptions removed');
  }

  /// Dispose of the service
  void dispose() {
    unsubscribeAll();
    _taskChangeController.close();
    _projectChangeController.close();
    _commentChangeController.close();
    _attachmentChangeController.close();
  }
}

/// Represents a real-time change event
class RealtimeChange {
  final String entityType;
  final RealtimeEventType eventType;
  final Map<String, dynamic>? newRecord;
  final Map<String, dynamic>? oldRecord;
  final DateTime timestamp;

  RealtimeChange({
    required this.entityType,
    required this.eventType,
    this.newRecord,
    this.oldRecord,
    required this.timestamp,
  });

  /// Get entity ID from the change
  String? get entityId {
    final record = newRecord ?? oldRecord;
    return record?['id'] as String?;
  }

  /// Get workspace ID from the change
  String? get workspaceId {
    final record = newRecord ?? oldRecord;
    return record?['workspace_id'] as String?;
  }

  @override
  String toString() {
    return 'RealtimeChange(type: $entityType, event: $eventType, id: $entityId)';
  }
}

/// Type of realtime event
enum RealtimeEventType {
  insert,
  update,
  delete,
}

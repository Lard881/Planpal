import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notification.dart';
import '../repositories/notification_repository.dart';

/// Callback type for when a new notification is received
typedef OnNotificationReceived = void Function(AppNotification notification);

/// Service for handling real-time notification updates from Supabase
class NotificationRealtimeService {
  final SupabaseClient _supabase;
  final NotificationRepository _repository;
  final String _userId;
  
  /// Optional callback for when new notifications are received (for local notifications)
  final OnNotificationReceived? onNotificationReceived;

  RealtimeChannel? _channel;
  bool _isListening = false;

  NotificationRealtimeService({
    required SupabaseClient supabase,
    required NotificationRepository repository,
    required String userId,
    this.onNotificationReceived,
  })  : _supabase = supabase,
        _repository = repository,
        _userId = userId;

  /// Start listening to real-time notification updates
  Future<void> startListening() async {
    if (_isListening) {
      return;
    }

    // Subscribe to notifications table for current user
    _channel = _supabase.channel('notifications:$_userId')
      ..onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'notifications',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'user_id',
          value: _userId,
        ),
        callback: _handleInsert,
      )
      ..onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'notifications',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'user_id',
          value: _userId,
        ),
        callback: _handleUpdate,
      )
      ..onPostgresChanges(
        event: PostgresChangeEvent.delete,
        schema: 'public',
        table: 'notifications',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'user_id',
          value: _userId,
        ),
        callback: _handleDelete,
      )
      ..subscribe();

    _isListening = true;
  }

  /// Stop listening to real-time updates
  Future<void> stopListening() async {
    if (!_isListening || _channel == null) {
      return;
    }

    await _supabase.removeChannel(_channel!);
    _channel = null;
    _isListening = false;
  }

  /// Handle new notification insert
  void _handleInsert(PostgresChangePayload payload) {
    try {
      final notification = AppNotification.fromJson(payload.newRecord);
      _repository.upsertNotification(notification);
      
      // Trigger callback for local notifications (Windows, etc.)
      if (onNotificationReceived != null) {
        onNotificationReceived!(notification);
      }
    } catch (e) {
      // Log error but don't crash
      print('Error handling notification insert: $e');
    }
  }

  /// Handle notification update
  void _handleUpdate(PostgresChangePayload payload) {
    try {
      final notification = AppNotification.fromJson(payload.newRecord);
      _repository.upsertNotification(notification);
    } catch (e) {
      print('Error handling notification update: $e');
    }
  }

  /// Handle notification delete
  void _handleDelete(PostgresChangePayload payload) {
    try {
      final id = payload.oldRecord['id'] as String;
      _repository.deleteNotificationLocal(id);
    } catch (e) {
      print('Error handling notification delete: $e');
    }
  }

  /// Whether the service is currently listening
  bool get isListening => _isListening;

  /// Dispose and cleanup
  Future<void> dispose() async {
    await stopListening();
  }
}

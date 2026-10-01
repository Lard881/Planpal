import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../core/utils/logger.dart';
import '../models/analytics_event.dart';
import '../repositories/analytics_repository.dart';

/// Analytics event tracking service with batching and offline queue
class AnalyticsTrackingService {
  final AnalyticsRepository _repository;
  
  // Event queue for batching
  final List<AnalyticsEventBatch> _eventQueue = [];
  
  // Batch configuration
  static const int _maxBatchSize = 100;
  static const Duration _batchInterval = Duration(seconds: 30);
  
  // Batch timer
  Timer? _batchTimer;
  
  // Tracking enabled flag
  bool _isEnabled = true;
  
  AnalyticsTrackingService({
    required AnalyticsRepository repository,
  }) : _repository = repository;

  /// Initialize the tracking service
  void initialize() {
    logger.info('Analytics tracking service initialized');
    _startBatchTimer();
  }

  /// Track an analytics event
  Future<void> trackEvent({
    required AnalyticsEventType eventType,
    String? workspaceId,
    Map<String, dynamic>? eventData,
  }) async {
    if (!_isEnabled) {
      logger.debug('Analytics tracking disabled, skipping event: ${eventType.value}');
      return;
    }

    try {
      final event = AnalyticsEventBatch(
        eventType: eventType,
        workspaceId: workspaceId,
        eventData: eventData ?? {},
        createdAt: DateTime.now(),
      );

      _eventQueue.add(event);
      logger.debug('Event queued: ${eventType.value} (queue size: ${_eventQueue.length})');

      // If queue is full, flush immediately
      if (_eventQueue.length >= _maxBatchSize) {
        await _flushQueue();
      }
    } catch (e) {
      logger.error('Error queuing analytics event', error: e);
    }
  }

  /// Track task created event
  Future<void> trackTaskCreated({
    required String taskId,
    required String workspaceId,
    String? priority,
    DateTime? dueDate,
  }) async {
    await trackEvent(
      eventType: AnalyticsEventType.taskCreated,
      workspaceId: workspaceId,
      eventData: {
        'task_id': taskId,
        if (priority != null) 'priority': priority,
        if (dueDate != null) 'due_date': dueDate.toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track task completed event
  Future<void> trackTaskCompleted({
    required String taskId,
    required String workspaceId,
    required DateTime createdAt,
    String? priority,
  }) async {
    final completionTime = DateTime.now().difference(createdAt);
    
    await trackEvent(
      eventType: AnalyticsEventType.taskCompleted,
      workspaceId: workspaceId,
      eventData: {
        'task_id': taskId,
        'created_at': createdAt.toIso8601String(),
        'completion_time_hours': completionTime.inHours,
        if (priority != null) 'priority': priority,
      },
    );
  }

  /// Track task updated event
  Future<void> trackTaskUpdated({
    required String taskId,
    required String workspaceId,
    List<String>? changedFields,
  }) async {
    await trackEvent(
      eventType: AnalyticsEventType.taskUpdated,
      workspaceId: workspaceId,
      eventData: {
        'task_id': taskId,
        if (changedFields != null) 'changed_fields': changedFields,
      },
    );
  }

  /// Track task deleted event
  Future<void> trackTaskDeleted({
    required String taskId,
    required String workspaceId,
  }) async {
    await trackEvent(
      eventType: AnalyticsEventType.taskDeleted,
      workspaceId: workspaceId,
      eventData: {'task_id': taskId},
    );
  }

  /// Track search performed event
  Future<void> trackSearchPerformed({
    required String query,
    required int resultsCount,
    String? workspaceId,
    String? filterType,
  }) async {
    await trackEvent(
      eventType: AnalyticsEventType.searchPerformed,
      workspaceId: workspaceId,
      eventData: {
        'query': query,
        'results_count': resultsCount,
        if (filterType != null) 'filter_type': filterType,
      },
    );
  }

  /// Track attachment uploaded event
  Future<void> trackAttachmentUploaded({
    required String attachmentId,
    required String taskId,
    required String workspaceId,
    required String fileType,
    required int fileSizeBytes,
  }) async {
    await trackEvent(
      eventType: AnalyticsEventType.attachmentUploaded,
      workspaceId: workspaceId,
      eventData: {
        'attachment_id': attachmentId,
        'task_id': taskId,
        'file_type': fileType,
        'file_size_bytes': fileSizeBytes,
      },
    );
  }

  /// Track comment added event
  Future<void> trackCommentAdded({
    required String commentId,
    required String taskId,
    required String workspaceId,
  }) async {
    await trackEvent(
      eventType: AnalyticsEventType.commentAdded,
      workspaceId: workspaceId,
      eventData: {
        'comment_id': commentId,
        'task_id': taskId,
      },
    );
  }

  /// Track label applied event
  Future<void> trackLabelApplied({
    required String labelId,
    required String taskId,
    required String workspaceId,
  }) async {
    await trackEvent(
      eventType: AnalyticsEventType.labelApplied,
      workspaceId: workspaceId,
      eventData: {
        'label_id': labelId,
        'task_id': taskId,
      },
    );
  }

  /// Track project created event
  Future<void> trackProjectCreated({
    required String projectId,
    required String workspaceId,
  }) async {
    await trackEvent(
      eventType: AnalyticsEventType.projectCreated,
      workspaceId: workspaceId,
      eventData: {'project_id': projectId},
    );
  }

  /// Track workspace joined event
  Future<void> trackWorkspaceJoined({
    required String workspaceId,
    required String role,
  }) async {
    await trackEvent(
      eventType: AnalyticsEventType.workspaceJoined,
      workspaceId: workspaceId,
      eventData: {'role': role},
    );
  }

  /// Track reminder set event
  Future<void> trackReminderSet({
    required String reminderId,
    required String taskId,
    required String workspaceId,
    required DateTime reminderTime,
  }) async {
    await trackEvent(
      eventType: AnalyticsEventType.reminderSet,
      workspaceId: workspaceId,
      eventData: {
        'reminder_id': reminderId,
        'task_id': taskId,
        'reminder_time': reminderTime.toIso8601String(),
      },
    );
  }

  /// Track filter applied event
  Future<void> trackFilterApplied({
    required String filterType,
    String? workspaceId,
    Map<String, dynamic>? filterValues,
  }) async {
    await trackEvent(
      eventType: AnalyticsEventType.filterApplied,
      workspaceId: workspaceId,
      eventData: {
        'filter_type': filterType,
        if (filterValues != null) 'filter_values': filterValues,
      },
    );
  }

  /// Track export performed event
  Future<void> trackExportPerformed({
    required String exportType,
    required int itemCount,
    String? workspaceId,
  }) async {
    await trackEvent(
      eventType: AnalyticsEventType.exportPerformed,
      workspaceId: workspaceId,
      eventData: {
        'export_type': exportType,
        'item_count': itemCount,
      },
    );
  }

  /// Track notification clicked event
  Future<void> trackNotificationClicked({
    required String notificationId,
    required String notificationType,
    String? workspaceId,
  }) async {
    await trackEvent(
      eventType: AnalyticsEventType.notificationClicked,
      workspaceId: workspaceId,
      eventData: {
        'notification_id': notificationId,
        'notification_type': notificationType,
      },
    );
  }

  /// Track page viewed event
  Future<void> trackPageViewed({
    required String pageName,
    String? workspaceId,
    Map<String, dynamic>? pageMetadata,
  }) async {
    await trackEvent(
      eventType: AnalyticsEventType.pageViewed,
      workspaceId: workspaceId,
      eventData: {
        'page_name': pageName,
        if (pageMetadata != null) ...pageMetadata,
      },
    );
  }

  /// Flush the event queue immediately
  Future<void> flush() async {
    await _flushQueue();
  }

  /// Enable or disable tracking
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
    logger.info('Analytics tracking ${enabled ? 'enabled' : 'disabled'}');
    
    if (enabled) {
      _startBatchTimer();
    } else {
      _stopBatchTimer();
      _eventQueue.clear();
    }
  }

  /// Check if tracking is enabled
  bool get isEnabled => _isEnabled;

  /// Get current queue size
  int get queueSize => _eventQueue.length;

  /// Start batch timer
  void _startBatchTimer() {
    _stopBatchTimer(); // Stop existing timer if any
    
    _batchTimer = Timer.periodic(_batchInterval, (timer) {
      if (_eventQueue.isNotEmpty) {
        _flushQueue();
      }
    });
  }

  /// Stop batch timer
  void _stopBatchTimer() {
    _batchTimer?.cancel();
    _batchTimer = null;
  }

  /// Flush event queue to backend
  Future<void> _flushQueue() async {
    if (_eventQueue.isEmpty) return;

    // Take up to max batch size
    final batch = _eventQueue.take(_maxBatchSize).toList();
    _eventQueue.removeRange(0, batch.length);

    try {
      logger.debug('Flushing ${batch.length} events to backend');
      await _repository.logEventsBatch(events: batch);
      logger.info('Successfully logged ${batch.length} analytics events');
    } catch (e) {
      logger.error('Failed to flush analytics events', error: e);
      
      // Re-add events to queue on failure (offline scenario)
      _eventQueue.insertAll(0, batch);
      
      // Limit queue size to prevent memory issues
      if (_eventQueue.length > _maxBatchSize * 3) {
        logger.warning('Analytics queue too large, dropping oldest events');
        _eventQueue.removeRange(0, _eventQueue.length - _maxBatchSize * 2);
      }
    }
  }

  /// Dispose the service
  void dispose() {
    _stopBatchTimer();
    // Attempt to flush remaining events
    if (_eventQueue.isNotEmpty) {
      _flushQueue().catchError((e) {
        logger.error('Failed to flush events on dispose', error: e);
      });
    }
    logger.info('Analytics tracking service disposed');
  }
}

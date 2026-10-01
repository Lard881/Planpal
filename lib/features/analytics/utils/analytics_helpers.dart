import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/analytics_providers.dart';
import '../models/analytics_event.dart';

/// Helper functions for analytics tracking
class AnalyticsHelpers {
  /// Track task created
  static Future<void> trackTaskCreated(
    WidgetRef ref, {
    required String taskId,
    required String workspaceId,
    String? priority,
    DateTime? dueDate,
  }) async {
    final service = ref.read(analyticsTrackingServiceProvider);
    await service.trackTaskCreated(
      taskId: taskId,
      workspaceId: workspaceId,
      priority: priority,
      dueDate: dueDate,
    );
  }

  /// Track task completed
  static Future<void> trackTaskCompleted(
    WidgetRef ref, {
    required String taskId,
    required String workspaceId,
    required DateTime createdAt,
    String? priority,
  }) async {
    final service = ref.read(analyticsTrackingServiceProvider);
    await service.trackTaskCompleted(
      taskId: taskId,
      workspaceId: workspaceId,
      createdAt: createdAt,
      priority: priority,
    );
  }

  /// Track task updated
  static Future<void> trackTaskUpdated(
    WidgetRef ref, {
    required String taskId,
    required String workspaceId,
    List<String>? changedFields,
  }) async {
    final service = ref.read(analyticsTrackingServiceProvider);
    await service.trackTaskUpdated(
      taskId: taskId,
      workspaceId: workspaceId,
      changedFields: changedFields,
    );
  }

  /// Track task deleted
  static Future<void> trackTaskDeleted(
    WidgetRef ref, {
    required String taskId,
    required String workspaceId,
  }) async {
    final service = ref.read(analyticsTrackingServiceProvider);
    await service.trackTaskDeleted(
      taskId: taskId,
      workspaceId: workspaceId,
    );
  }

  /// Track search performed
  static Future<void> trackSearchPerformed(
    WidgetRef ref, {
    required String query,
    required int resultsCount,
    String? workspaceId,
    String? filterType,
  }) async {
    final service = ref.read(analyticsTrackingServiceProvider);
    await service.trackSearchPerformed(
      query: query,
      resultsCount: resultsCount,
      workspaceId: workspaceId,
      filterType: filterType,
    );
  }

  /// Track attachment uploaded
  static Future<void> trackAttachmentUploaded(
    WidgetRef ref, {
    required String attachmentId,
    required String taskId,
    required String workspaceId,
    required String fileType,
    required int fileSizeBytes,
  }) async {
    final service = ref.read(analyticsTrackingServiceProvider);
    await service.trackAttachmentUploaded(
      attachmentId: attachmentId,
      taskId: taskId,
      workspaceId: workspaceId,
      fileType: fileType,
      fileSizeBytes: fileSizeBytes,
    );
  }

  /// Track comment added
  static Future<void> trackCommentAdded(
    WidgetRef ref, {
    required String commentId,
    required String taskId,
    required String workspaceId,
  }) async {
    final service = ref.read(analyticsTrackingServiceProvider);
    await service.trackCommentAdded(
      commentId: commentId,
      taskId: taskId,
      workspaceId: workspaceId,
    );
  }

  /// Track label applied
  static Future<void> trackLabelApplied(
    WidgetRef ref, {
    required String labelId,
    required String taskId,
    required String workspaceId,
  }) async {
    final service = ref.read(analyticsTrackingServiceProvider);
    await service.trackLabelApplied(
      labelId: labelId,
      taskId: taskId,
      workspaceId: workspaceId,
    );
  }

  /// Track project created
  static Future<void> trackProjectCreated(
    WidgetRef ref, {
    required String projectId,
    required String workspaceId,
  }) async {
    final service = ref.read(analyticsTrackingServiceProvider);
    await service.trackProjectCreated(
      projectId: projectId,
      workspaceId: workspaceId,
    );
  }

  /// Track workspace joined
  static Future<void> trackWorkspaceJoined(
    WidgetRef ref, {
    required String workspaceId,
    required String role,
  }) async {
    final service = ref.read(analyticsTrackingServiceProvider);
    await service.trackWorkspaceJoined(
      workspaceId: workspaceId,
      role: role,
    );
  }

  /// Track reminder set
  static Future<void> trackReminderSet(
    WidgetRef ref, {
    required String reminderId,
    required String taskId,
    required String workspaceId,
    required DateTime reminderTime,
  }) async {
    final service = ref.read(analyticsTrackingServiceProvider);
    await service.trackReminderSet(
      reminderId: reminderId,
      taskId: taskId,
      workspaceId: workspaceId,
      reminderTime: reminderTime,
    );
  }

  /// Track filter applied
  static Future<void> trackFilterApplied(
    WidgetRef ref, {
    required String filterType,
    String? workspaceId,
    Map<String, dynamic>? filterValues,
  }) async {
    final service = ref.read(analyticsTrackingServiceProvider);
    await service.trackFilterApplied(
      filterType: filterType,
      workspaceId: workspaceId,
      filterValues: filterValues,
    );
  }

  /// Track export performed
  static Future<void> trackExportPerformed(
    WidgetRef ref, {
    required String exportType,
    required int itemCount,
    String? workspaceId,
  }) async {
    final service = ref.read(analyticsTrackingServiceProvider);
    await service.trackExportPerformed(
      exportType: exportType,
      itemCount: itemCount,
      workspaceId: workspaceId,
    );
  }

  /// Track notification clicked
  static Future<void> trackNotificationClicked(
    WidgetRef ref, {
    required String notificationId,
    required String notificationType,
    String? workspaceId,
  }) async {
    final service = ref.read(analyticsTrackingServiceProvider);
    await service.trackNotificationClicked(
      notificationId: notificationId,
      notificationType: notificationType,
      workspaceId: workspaceId,
    );
  }

  /// Track page viewed
  static Future<void> trackPageViewed(
    WidgetRef ref, {
    required String pageName,
    String? workspaceId,
    Map<String, dynamic>? pageMetadata,
  }) async {
    final service = ref.read(analyticsTrackingServiceProvider);
    await service.trackPageViewed(
      pageName: pageName,
      workspaceId: workspaceId,
      pageMetadata: pageMetadata,
    );
  }

  /// Flush events immediately
  static Future<void> flush(WidgetRef ref) async {
    final service = ref.read(analyticsTrackingServiceProvider);
    await service.flush();
  }
}

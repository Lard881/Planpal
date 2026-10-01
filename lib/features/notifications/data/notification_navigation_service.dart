import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/notification.dart';
import '../../../core/db/app_database.dart';

/// Service for handling notification navigation to target screens
class NotificationNavigationService {
  /// Navigate to the entity referenced in the notification
  static Future<void> navigateToNotification(
    BuildContext context,
    NotificationData notification,
  ) async {
    final entityType = notification.entityType;
    final entityId = notification.entityId;

    if (entityType == null || entityId == null) {
      // No entity to navigate to (e.g., system notifications)
      _showNoNavigationSnackBar(context);
      return;
    }

    try {
      switch (entityType) {
        case 'task':
          await _navigateToTask(context, entityId);
          break;
        case 'comment':
          await _navigateToComment(context, entityId, notification);
          break;
        case 'project':
          await _navigateToProject(context, entityId);
          break;
        case 'event':
          await _navigateToEvent(context, entityId);
          break;
        case 'chat':
          await _navigateToChat(context, entityId);
          break;
        case 'workspace':
          await _navigateToWorkspace(context, entityId);
          break;
        default:
          _showUnsupportedEntitySnackBar(context, entityType);
      }
    } catch (e) {
      _showNavigationErrorSnackBar(context, e);
    }
  }

  /// Navigate to task detail screen
  static Future<void> _navigateToTask(
    BuildContext context,
    String taskId,
  ) async {
    if (!context.mounted) return;
    
    // Using go_router navigation
    context.push('/tasks/$taskId');
  }

  /// Navigate to comment (which is within a task)
  static Future<void> _navigateToComment(
    BuildContext context,
    String commentId,
    NotificationData notification,
  ) async {
    // Comments are shown within task detail screen
    // We need to find the task that contains this comment
    // For now, if the notification body mentions a task, extract it
    // Otherwise, show the comment ID in a snackbar
    
    // TODO: Fetch comment from API to get task_id
    // For now, just show a message
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Comment navigation - commentId: $commentId'),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {},
        ),
      ),
    );
  }

  /// Navigate to project screen
  static Future<void> _navigateToProject(
    BuildContext context,
    String projectId,
  ) async {
    if (!context.mounted) return;
    
    context.push('/projects/$projectId');
  }

  /// Navigate to event/calendar screen
  static Future<void> _navigateToEvent(
    BuildContext context,
    String eventId,
  ) async {
    if (!context.mounted) return;
    
    // Navigate to calendar with event highlighted
    context.push('/calendar?eventId=$eventId');
  }

  /// Navigate to chat screen
  static Future<void> _navigateToChat(
    BuildContext context,
    String chatId,
  ) async {
    if (!context.mounted) return;
    
    context.push('/chat/$chatId');
  }

  /// Navigate to workspace screen
  static Future<void> _navigateToWorkspace(
    BuildContext context,
    String workspaceId,
  ) async {
    if (!context.mounted) return;
    
    context.push('/workspaces/$workspaceId');
  }

  /// Show snackbar for notifications without navigation targets
  static void _showNoNavigationSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This notification has no associated content'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Show snackbar for unsupported entity types
  static void _showUnsupportedEntitySnackBar(
    BuildContext context,
    String entityType,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigation not implemented for: $entityType'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  /// Show snackbar for navigation errors
  static void _showNavigationErrorSnackBar(
    BuildContext context,
    Object error,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to navigate: $error'),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {},
          textColor: Colors.white,
        ),
      ),
    );
  }

  /// Get a user-friendly description of where the notification will navigate
  static String getNavigationDescription(NotificationData notification) {
    final entityType = notification.entityType;
    
    if (entityType == null) {
      return 'No action available';
    }

    switch (entityType) {
      case 'task':
        return 'Open task';
      case 'comment':
        return 'View comment';
      case 'project':
        return 'Open project';
      case 'event':
        return 'View event';
      case 'chat':
        return 'Open chat';
      case 'workspace':
        return 'Open workspace';
      default:
        return 'Open $entityType';
    }
  }

  /// Check if a notification has a valid navigation target
  static bool hasNavigationTarget(NotificationData notification) {
    return notification.entityType != null && notification.entityId != null;
  }
}

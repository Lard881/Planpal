import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Attachment repository provider (stub)
final attachmentRepositoryProvider = Provider<AttachmentRepository>((ref) {
  return AttachmentRepository();
});

/// Notification repository provider (stub)  
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});

/// Stub attachment repository
class AttachmentRepository {
  Future<void> deleteAttachment(String id) async {
    // TODO: Implement
  }
  
  Future<String?> getDownloadUrl(String id) async {
    // TODO: Implement
    return null;
  }
  
  Future<List<dynamic>> getTaskAttachments(String taskId) async {
    // TODO: Implement  
    return [];
  }
  
  Future<List<dynamic>> getTaskLinks(String taskId) async {
    // TODO: Implement
    return [];
  }
  
  Future<void> deleteLink(String id) async {
    // TODO: Implement
  }
}

/// Stub notification repository
class NotificationRepository {
  Future<void> markAsRead(String id) async {
    // TODO: Implement
  }
  
  Future<void> deleteNotification(String id) async {
    // TODO: Implement
  }
}

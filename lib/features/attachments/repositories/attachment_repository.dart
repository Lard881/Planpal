import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import '../../../core/db/app_database.dart' hide TaskLink;
import '../../../core/db/app_database.dart' as app_db show TaskLink;
import '../../../core/network/api_client.dart';
import '../models/attachment.dart';
import '../models/task_link.dart';
import '../models/link_metadata.dart' as link_meta show LinkMetadata;

/// Repository for managing attachments and links with offline support
class AttachmentRepository {
  final AppDatabase _database;
  final ApiClient _apiClient;

  AttachmentRepository({
    required AppDatabase database,
    required ApiClient apiClient,
  })  : _database = database,
        _apiClient = apiClient;

  // ============================================================================
  // ATTACHMENTS - API METHODS
  // ============================================================================

  /// Get all attachments for a task from API
  Future<List<Attachment>> getTaskAttachments(String taskId) async {
    try {
      final response = await _apiClient.get('/tasks/$taskId/attachments');
      
      final attachmentsJson = response.data['attachments'] as List<dynamic>;
      final attachments = attachmentsJson
          .map((json) => Attachment.fromJson(json as Map<String, dynamic>))
          .toList();

      // Cache in local database
      await _cacheAttachments(attachments);

      return attachments;
    } catch (e) {
      debugPrint('[AttachmentRepository] Error fetching attachments: $e');
      
      // Fallback to local cache
      return await getTaskAttachmentsLocal(taskId);
    }
  }

  /// Get single attachment from API
  Future<Attachment?> getAttachment(String attachmentId) async {
    try {
      final response = await _apiClient.get('/attachments/$attachmentId');
      
      final attachment = Attachment.fromJson(
        response.data['attachment'] as Map<String, dynamic>,
      );

      // Cache in local database
      await _cacheAttachment(attachment);

      return attachment;
    } catch (e) {
      debugPrint('[AttachmentRepository] Error fetching attachment: $e');
      
      // Fallback to local cache
      return await getAttachmentLocal(attachmentId);
    }
  }

  /// Get download URL for attachment
  Future<String?> getDownloadUrl(String attachmentId) async {
    try {
      final response = await _apiClient.get('/attachments/$attachmentId/download');
      
      return response.data['download_url'] as String?;
    } catch (e) {
      debugPrint('[AttachmentRepository] Error getting download URL: $e');
      return null;
    }
  }

  /// Delete attachment
  Future<bool> deleteAttachment(String attachmentId) async {
    try {
      await _apiClient.delete('/attachments/$attachmentId');
      
      // Soft delete in local database
      await _deleteAttachmentLocal(attachmentId);

      return true;
    } catch (e) {
      debugPrint('[AttachmentRepository] Error deleting attachment: $e');
      return false;
    }
  }

  // ============================================================================
  // ATTACHMENTS - LOCAL DATABASE METHODS
  // ============================================================================

  /// Get attachments for task from local database
  Future<List<Attachment>> getTaskAttachmentsLocal(String taskId) async {
    final query = _database.select(_database.taskAttachments)
      ..where((a) => a.taskId.equals(taskId))
      ..where((a) => a.deletedAt.isNull())
      ..orderBy([
        (a) => drift.OrderingTerm.desc(a.createdAt),
      ]);

    final rows = await query.get();

    return rows.map((row) => _attachmentFromDrift(row)).toList();
  }

  /// Get single attachment from local database
  Future<Attachment?> getAttachmentLocal(String attachmentId) async {
    final query = _database.select(_database.taskAttachments)
      ..where((a) => a.id.equals(attachmentId))
      ..where((a) => a.deletedAt.isNull());

    final row = await query.getSingleOrNull();

    return row != null ? _attachmentFromDrift(row) : null;
  }

  /// Cache attachments in local database
  Future<void> _cacheAttachments(List<Attachment> attachments) async {
    await _database.batch((batch) {
      for (final attachment in attachments) {
        batch.insert(
          _database.taskAttachments,
          _attachmentToDrift(attachment),
          mode: drift.InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// Cache single attachment in local database
  Future<void> _cacheAttachment(Attachment attachment) async {
    await _database.into(_database.taskAttachments).insert(
          _attachmentToDrift(attachment),
          mode: drift.InsertMode.insertOrReplace,
        );
  }

  /// Soft delete attachment in local database
  Future<void> _deleteAttachmentLocal(String attachmentId) async {
    await (_database.update(_database.taskAttachments)
          ..where((a) => a.id.equals(attachmentId)))
        .write(
      TaskAttachmentsCompanion(
        deletedAt: drift.Value(DateTime.now()),
      ),
    );
  }

  // ============================================================================
  // LINKS - API METHODS
  // ============================================================================

  /// Get all links for a task from API
  Future<List<TaskLink>> getTaskLinks(String taskId) async {
    try {
      final response = await _apiClient.get('/tasks/$taskId/links');
      
      final linksJson = response.data['links'] as List<dynamic>;
      final links = linksJson
          .map((json) => TaskLink.fromJson(json as Map<String, dynamic>))
          .toList();

      // Cache in local database
      await _cacheLinks(links);

      return links;
    } catch (e) {
      debugPrint('[AttachmentRepository] Error fetching links: $e');
      
      // Fallback to local cache
      return await getTaskLinksLocal(taskId);
    }
  }

  /// Get single link from API
  Future<TaskLink?> getLink(String linkId) async {
    try {
      final response = await _apiClient.get('/links/$linkId');
      
      final link = TaskLink.fromJson(response.data['link'] as Map<String, dynamic>);

      // Cache in local database
      await _cacheLink(link);

      return link;
    } catch (e) {
      debugPrint('[AttachmentRepository] Error fetching link: $e');
      
      // Fallback to local cache
      return await getLinkLocal(linkId);
    }
  }

  /// Create link
  Future<TaskLink?> createLink({
    required String taskId,
    required String url,
    String? title,
    String? description,
    String? faviconUrl,
  }) async {
    try {
      final response = await _apiClient.post(
        '/tasks/$taskId/links',
        data: {
          'url': url,
          if (title != null) 'title': title,
          if (description != null) 'description': description,
          if (faviconUrl != null) 'favicon_url': faviconUrl,
        },
      );

      final data = response.data['link'] as Map<String, dynamic>;
      final link = TaskLink.fromJson(data);

      // Cache in local database
      await _cacheLink(link);

      return link;
    } catch (e) {
      debugPrint('[AttachmentRepository] Error creating link: $e');
      return null;
    }
  }

  /// Update link
  Future<TaskLink?> updateLink({
    required String linkId,
    String? title,
    String? description,
    String? faviconUrl,
  }) async {
    try {
      final response = await _apiClient.patch(
        '/links/$linkId',
        data: {
          if (title != null) 'title': title,
          if (description != null) 'description': description,
          if (faviconUrl != null) 'favicon_url': faviconUrl,
        },
      );

      final data = response.data['link'] as Map<String, dynamic>;
      final link = TaskLink.fromJson(data);

      // Update in local database
      await _cacheLink(link);

      return link;
    } catch (e) {
      debugPrint('[AttachmentRepository] Error updating link: $e');
      return null;
    }
  }

  /// Delete link
  Future<bool> deleteLink(String linkId) async {
    try {
      await _apiClient.delete('/links/$linkId');
      
      // Soft delete in local database
      await _deleteLinkLocal(linkId);

      return true;
    } catch (e) {
      debugPrint('[AttachmentRepository] Error deleting link: $e');
      return false;
    }
  }

  /// Fetch link metadata from URL
  Future<link_meta.LinkMetadata?> fetchLinkMetadata(String url) async {
    try {
      final response = await _apiClient.post(
        '/links/fetch-metadata',
        data: {'url': url},
      );

      return link_meta.LinkMetadata.fromJson(
        response.data['metadata'] as Map<String, dynamic>,
      );
    } catch (e) {
      debugPrint('[AttachmentRepository] Error fetching link metadata: $e');
      return null;
    }
  }

  // ============================================================================
  // LINKS - LOCAL DATABASE METHODS
  // ============================================================================

  /// Get links for task from local database
  Future<List<TaskLink>> getTaskLinksLocal(String taskId) async {
    final query = _database.select(_database.taskLinks)
      ..where((l) => l.taskId.equals(taskId))
      ..where((l) => l.deletedAt.isNull())
      ..orderBy([
        (l) => drift.OrderingTerm.desc(l.createdAt),
      ]);

    final rows = await query.get();

    return rows.map((row) => _linkFromDrift(row)).toList();
  }

  /// Get single link from local database
  Future<TaskLink?> getLinkLocal(String linkId) async {
    final query = _database.select(_database.taskLinks)
      ..where((l) => l.id.equals(linkId))
      ..where((l) => l.deletedAt.isNull());

    final row = await query.getSingleOrNull();

    return row != null ? _linkFromDrift(row) : null;
  }

  /// Cache links in local database
  Future<void> _cacheLinks(List<TaskLink> links) async {
    await _database.batch((batch) {
      for (final link in links) {
        batch.insert(
          _database.taskLinks,
          _linkToDrift(link),
          mode: drift.InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// Cache single link in local database
  Future<void> _cacheLink(TaskLink link) async {
    await _database.into(_database.taskLinks).insert(
          _linkToDrift(link),
          mode: drift.InsertMode.insertOrReplace,
        );
  }

  /// Soft delete link in local database
  Future<void> _deleteLinkLocal(String linkId) async {
    await (_database.update(_database.taskLinks)
          ..where((l) => l.id.equals(linkId)))
        .write(
      TaskLinksCompanion(
        deletedAt: drift.Value(DateTime.now()),
      ),
    );
  }

  // ============================================================================
  // HELPER METHODS - CONVERSIONS
  // ============================================================================

  /// Convert Drift row to Attachment model
  Attachment _attachmentFromDrift(TaskAttachment row) {
    return Attachment(
      id: row.id,
      taskId: row.taskId,
      workspaceId: row.workspaceId,
      uploadedBy: row.uploadedBy,
      fileName: row.fileName,
      fileSize: row.fileSize.toInt(), // Convert BigInt to int
      mimeType: row.mimeType,
      storagePath: row.storagePath,
      thumbnailPath: row.thumbnailPath,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  /// Convert Attachment model to Drift companion
  TaskAttachmentsCompanion _attachmentToDrift(Attachment attachment) {
    return TaskAttachmentsCompanion.insert(
      id: attachment.id,
      taskId: attachment.taskId,
      workspaceId: attachment.workspaceId,
      uploadedBy: attachment.uploadedBy,
      fileName: attachment.fileName,
      fileSize: BigInt.from(attachment.fileSize), // Convert int to BigInt
      mimeType: attachment.mimeType,
      storagePath: attachment.storagePath,
      thumbnailPath: drift.Value(attachment.thumbnailPath),
      createdAt: attachment.createdAt,
      updatedAt: attachment.updatedAt,
      deletedAt: drift.Value(attachment.deletedAt),
    );
  }

  /// Convert Drift TaskLink to API TaskLink model
  TaskLink _linkFromDrift(app_db.TaskLink row) {
    return TaskLink(
      id: row.id,
      taskId: row.taskId,
      workspaceId: row.workspaceId,
      addedBy: row.addedBy,
      url: row.url,
      title: row.title,
      description: row.description,
      faviconUrl: row.faviconUrl,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  /// Convert API TaskLink to Drift companion
  TaskLinksCompanion _linkToDrift(TaskLink link) {
    return TaskLinksCompanion.insert(
      id: link.id,
      taskId: link.taskId,
      workspaceId: '', // TODO: Get from context
      addedBy: '', // TODO: Get from current user
      url: link.url,
      title: drift.Value(link.title),
      description: drift.Value(link.description),
      faviconUrl: drift.Value(link.faviconUrl),
      createdAt: link.createdAt,
      updatedAt: link.createdAt, // Same as created initially
      deletedAt: const drift.Value(null),
    );
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Get attachment count for a task
  Future<int> getAttachmentCount(String taskId) async {
    final query = _database.select(_database.taskAttachments)
      ..where((a) => a.taskId.equals(taskId))
      ..where((a) => a.deletedAt.isNull());

    final count = await query.get();
    return count.length;
  }

  /// Get link count for a task
  Future<int> getLinkCount(String taskId) async {
    final query = _database.select(_database.taskLinks)
      ..where((l) => l.taskId.equals(taskId))
      ..where((l) => l.deletedAt.isNull());

    final count = await query.get();
    return count.length;
  }

  /// Clear all cached attachments and links
  Future<void> clearCache() async {
    await _database.delete(_database.taskAttachments).go();
    await _database.delete(_database.taskLinks).go();
  }

  /// Clear cache for specific task
  Future<void> clearTaskCache(String taskId) async {
    await (_database.delete(_database.taskAttachments)
          ..where((a) => a.taskId.equals(taskId)))
        .go();
    
    await (_database.delete(_database.taskLinks)
          ..where((l) => l.taskId.equals(taskId)))
        .go();
  }
}

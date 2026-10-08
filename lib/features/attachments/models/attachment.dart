import 'package:freezed_annotation/freezed_annotation.dart';

part 'attachment.freezed.dart';
part 'attachment.g.dart';

/// File attachment model
/// Represents a file uploaded to cloud storage and attached to a task
@freezed
class Attachment with _$Attachment {
  const factory Attachment({
    required String id,
    required String taskId,
    required String workspaceId,
    required String uploadedBy,
    required String fileName,
    required int fileSize,
    required String mimeType,
    required String storagePath,
    String? thumbnailPath,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _Attachment;

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);
}

/// Extension for attachment helper methods
extension AttachmentX on Attachment {
  /// Check if attachment is an image
  bool get isImage {
    return mimeType.startsWith('image/');
  }

  /// Check if attachment is a document
  bool get isDocument {
    const documentTypes = [
      'application/pdf',
      'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'application/vnd.ms-excel',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'application/vnd.ms-powerpoint',
      'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    ];
    return documentTypes.contains(mimeType);
  }

  /// Check if attachment is a PDF
  bool get isPdf {
    return mimeType == 'application/pdf';
  }

  /// Check if attachment is text
  bool get isText {
    return mimeType.startsWith('text/') || mimeType == 'application/json';
  }

  /// Check if attachment is an archive
  bool get isArchive {
    return mimeType == 'application/zip' ||
        mimeType == 'application/x-zip-compressed';
  }

  /// Get file extension from filename
  String get fileExtension {
    final parts = fileName.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }

  /// Get formatted file size
  String get formattedFileSize {
    if (fileSize < 1024) {
      return '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    } else if (fileSize < 1024 * 1024 * 1024) {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(fileSize / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Get icon name for file type
  String get fileTypeIcon {
    if (isImage) return '🖼️';
    if (isPdf) return '📄';
    if (isDocument) {
      if (mimeType.contains('word')) return '📝';
      if (mimeType.contains('excel')) return '📊';
      if (mimeType.contains('powerpoint')) return '📽️';
      return '📄';
    }
    if (isText) return '📝';
    if (isArchive) return '📦';
    return '📎';
  }

  /// Check if thumbnail is available
  bool get hasThumbnail {
    return thumbnailPath != null && thumbnailPath!.isNotEmpty;
  }

  /// Get display name (truncated if too long)
  String getDisplayName({int maxLength = 30}) {
    if (fileName.length <= maxLength) {
      return fileName;
    }
    final ext = fileExtension;
    final nameWithoutExt = fileName.substring(0, fileName.length - ext.length - 1);
    final truncated = nameWithoutExt.substring(0, maxLength - ext.length - 4);
    return '$truncated...$ext';
  }

  /// Check if file can be previewed in-app
  bool get canPreview {
    return isImage || isPdf;
  }

  /// Get file category for grouping
  AttachmentCategory get category {
    if (isImage) return AttachmentCategory.image;
    if (isDocument) return AttachmentCategory.document;
    if (isText) return AttachmentCategory.text;
    if (isArchive) return AttachmentCategory.archive;
    return AttachmentCategory.other;
  }
}

/// Attachment category enum
enum AttachmentCategory {
  image,
  document,
  text,
  archive,
  other;

  String get displayName {
    switch (this) {
      case AttachmentCategory.image:
        return 'Images';
      case AttachmentCategory.document:
        return 'Documents';
      case AttachmentCategory.text:
        return 'Text Files';
      case AttachmentCategory.archive:
        return 'Archives';
      case AttachmentCategory.other:
        return 'Other';
    }
  }
}

/// Upload progress state
@freezed
class UploadProgress with _$UploadProgress {
  const factory UploadProgress({
    required String fileName,
    required int totalBytes,
    required int uploadedBytes,
    required UploadStatus status,
    String? error,
  }) = _UploadProgress;

  const UploadProgress._();

  /// Get progress percentage (0-100)
  double get percentage {
    if (totalBytes == 0) return 0;
    return (uploadedBytes / totalBytes * 100).clamp(0, 100);
  }

  /// Check if upload is complete
  bool get isComplete => status == UploadStatus.completed;

  /// Check if upload failed
  bool get isFailed => status == UploadStatus.failed;

  /// Check if upload is in progress
  bool get isInProgress => status == UploadStatus.uploading;
}

/// Upload status enum
enum UploadStatus {
  queued,
  uploading,
  completed,
  failed,
  cancelled;

  String get displayName {
    switch (this) {
      case UploadStatus.queued:
        return 'Queued';
      case UploadStatus.uploading:
        return 'Uploading';
      case UploadStatus.completed:
        return 'Completed';
      case UploadStatus.failed:
        return 'Failed';
      case UploadStatus.cancelled:
        return 'Cancelled';
    }
  }
}

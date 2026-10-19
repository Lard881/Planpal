// app/lib/features/documents/models/document_models.dart

class FolderModel {
  final String id;
  final String workspaceId;
  final String? parentId;
  final String name;
  final int fileCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FolderModel({
    required this.id,
    required this.workspaceId,
    this.parentId,
    required this.name,
    this.fileCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FolderModel.fromJson(Map<String, dynamic> j) => FolderModel(
    id: j['id'] as String,
    workspaceId: j['workspace_id'] as String,
    parentId: j['parent_id'] as String?,
    name: j['name'] as String,
    fileCount: j['file_count'] as int? ?? j['fileCount'] as int? ?? 0,
    createdAt: DateTime.parse(j['created_at'] as String),
    updatedAt: DateTime.parse(j['updated_at'] as String),
  );
}

class DocumentModel {
  final String id;
  final String workspaceId;
  final String? folderId;
  final String kind; // 'file' | 'written'
  final String title;
  final String? fileId;
  final Map<String, dynamic>? content; // Quill delta JSON
  final String contentText;
  final String createdBy;
  final String? createdByName;
  final DateTime createdAt;
  final DateTime updatedAt;
  // File-specific
  final String? mimeType;
  final int? sizeBytes;
  final String? storagePath;

  const DocumentModel({
    required this.id,
    required this.workspaceId,
    this.folderId,
    required this.kind,
    required this.title,
    this.fileId,
    this.content,
    this.contentText = '',
    required this.createdBy,
    this.createdByName,
    required this.createdAt,
    required this.updatedAt,
    this.mimeType,
    this.sizeBytes,
    this.storagePath,
  });

  bool get isWritten => kind == 'written';
  bool get isFile => kind == 'file';
  bool get isImage =>
      mimeType?.startsWith('image/') == true ||
      const {'jpg', 'jpeg', 'png', 'gif', 'webp'}.contains(extension);

  String get extension {
    final parts = title.split('.');
    if (parts.length > 1) {
      return parts.last.toLowerCase();
    }
    if (mimeType != null) {
      if (mimeType!.contains('pdf')) {
        return 'pdf';
      }
      if (mimeType!.contains('word') || mimeType!.contains('doc')) {
        return 'doc';
      }
      if (mimeType!.contains('excel') || mimeType!.contains('sheet')) {
        return 'xls';
      }
      if (mimeType!.contains('image')) {
        return 'img';
      }
    }
    return isWritten ? 'doc' : 'file';
  }

  String get sizeLabel {
    if (sizeBytes == null) return '';
    if (sizeBytes! < 1024) return '${sizeBytes}B';
    if (sizeBytes! < 1024 * 1024) {
      return '${(sizeBytes! / 1024).toStringAsFixed(1)}KB';
    }
    return '${(sizeBytes! / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  String relativeTime() {
    final now = DateTime.now();
    final diff = now.difference(updatedAt);
    if (diff.inMinutes < 60) return 'Edited ${diff.inMinutes}m ago';
    if (diff.inHours < 24) return 'Edited ${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Edited Yesterday';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return 'Edited ${months[updatedAt.month - 1]} ${updatedAt.day}';
  }

  factory DocumentModel.fromJson(Map<String, dynamic> j) {
    final file = j['file'] as Map<String, dynamic>?;
    final createdByProfile = j['created_by_profile'] as Map<String, dynamic>?;
    return DocumentModel(
      id: j['id'] as String,
      workspaceId: j['workspace_id'] as String,
      folderId: j['folder_id'] as String?,
      kind: j['kind'] as String? ?? 'written',
      title: j['title'] as String,
      fileId: j['file_id'] as String?,
      content: j['content'] as Map<String, dynamic>?,
      contentText: j['content_text'] as String? ?? '',
      createdBy: j['created_by'] as String,
      createdByName: createdByProfile?['full_name'] as String?,
      createdAt: DateTime.parse(j['created_at'] as String),
      updatedAt: DateTime.parse(j['updated_at'] as String),
      mimeType: file?['mime_type'] as String?,
      sizeBytes: file?['size_bytes'] as int?,
      storagePath: file?['storage_path'] as String?,
    );
  }
}

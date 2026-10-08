import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/db/app_database.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/sync/outbox_service.dart';
import '../../../core/errors/app_failure.dart';
import '../../sync/providers/sync_providers.dart';

const uuid = Uuid();

/// Document repository
class DocumentRepository {
  final AppDatabase _db;
  final ApiClient _apiClient;
  final OutboxService _outboxService;

  DocumentRepository(this._db, this._apiClient, this._outboxService);

  // ========== FILES ==========

  /// Get all files in workspace
  Stream<List<File>> watchFiles(String workspaceId) {
    return (_db.select(_db.files)
          ..where((f) => f.workspaceId.equals(workspaceId))
          ..where((f) => f.deletedAt.isNull())
          ..orderBy([
            (f) => OrderingTerm(expression: f.createdAt, mode: OrderingMode.desc)
          ]))
        .watch();
  }

  /// Get file by ID
  Future<File?> getFile(String fileId) {
    return (_db.select(_db.files)..where((f) => f.id.equals(fileId)))
        .getSingleOrNull();
  }

  /// Create file record (called after upload)
  Future<File> createFile({
    required String id,
    required String workspaceId,
    required String name,
    required String mimeType,
    required int sizeBytes,
    required String path,
    required String uploadedBy,
  }) async {
    final now = DateTime.now();

    final file = FilesCompanion(
      id: Value(id),
      workspaceId: Value(workspaceId),
      name: Value(name),
      mimeType: Value(mimeType),
      sizeBytes: Value(BigInt.from(sizeBytes)),
      path: Value(path),
      uploadedBy: Value(uploadedBy),
      createdAt: Value(now),
      updatedAt: Value(now),
      syncStatus: const Value('synced'), // Already created on server
    );

    await _db.into(_db.files).insert(file);

    final created = await getFile(id);
    return created!;
  }

  /// Delete file
  Future<void> deleteFile(String fileId) async {
    final now = DateTime.now();

    await (_db.update(_db.files)..where((f) => f.id.equals(fileId)))
        .write(FilesCompanion(
      deletedAt: Value(now),
      syncStatus: const Value('pending'),
    ));

    // Queue for sync
    await _outboxService.enqueue(
      entityType: 'file',
      entityId: fileId,
      operation: 'delete',
      payload: {'id': fileId},
    );
  }

  /// Get download URL
  Future<String> getDownloadUrl(String fileId) async {
    final response = await _apiClient.get('/files/$fileId/download-url');
    return response.data['downloadUrl'] as String;
  }

  // ========== FOLDERS ==========

  /// Get all folders in workspace
  Stream<List<Folder>> watchFolders(String workspaceId, {String? parentId}) {
    final query = _db.select(_db.folders)
      ..where((f) => f.workspaceId.equals(workspaceId))
      ..where((f) => f.deletedAt.isNull());

    if (parentId != null) {
      query.where((f) => f.parentId.equals(parentId));
    } else {
      query.where((f) => f.parentId.isNull());
    }

    query.orderBy([
      (f) => OrderingTerm(expression: f.name, mode: OrderingMode.asc),
    ]);

    return query.watch();
  }

  /// Get folder by ID
  Future<Folder?> getFolder(String folderId) {
    return (_db.select(_db.folders)..where((f) => f.id.equals(folderId)))
        .getSingleOrNull();
  }

  /// Create folder
  Future<Folder> createFolder({
    required String workspaceId,
    required String name,
    String? parentId,
    required String createdBy,
  }) async {
    final id = uuid.v4();
    final now = DateTime.now();

    final folder = FoldersCompanion(
      id: Value(id),
      workspaceId: Value(workspaceId),
      name: Value(name),
      parentId: Value(parentId),
      createdBy: Value(createdBy),
      createdAt: Value(now),
      updatedAt: Value(now),
      syncStatus: const Value('pending'),
    );

    await _db.into(_db.folders).insert(folder);

    // Queue for sync
    await _outboxService.enqueue(
      entityType: 'folder',
      entityId: id,
      operation: 'create',
      payload: {
        'id': id,
        'workspace_id': workspaceId,
        'name': name,
        if (parentId != null) 'parent_id': parentId,
        'created_by': createdBy,
      },
    );

    final created = await getFolder(id);
    return created!;
  }

  /// Update folder
  Future<void> updateFolder({
    required String folderId,
    String? name,
    String? parentId,
  }) async {
    final now = DateTime.now();
    final updates = <String, dynamic>{};

    if (name != null) updates['name'] = name;
    if (parentId != null) updates['parent_id'] = parentId;

    await (_db.update(_db.folders)..where((f) => f.id.equals(folderId)))
        .write(FoldersCompanion(
      name: name != null ? Value(name) : const Value.absent(),
      parentId: parentId != null ? Value(parentId) : const Value.absent(),
      updatedAt: Value(now),
      syncStatus: const Value('pending'),
    ));

    // Queue for sync
    await _outboxService.enqueue(
      entityType: 'folder',
      entityId: folderId,
      operation: 'update',
      payload: {'id': folderId, ...updates},
    );
  }

  /// Delete folder
  Future<void> deleteFolder(String folderId) async {
    final now = DateTime.now();

    await (_db.update(_db.folders)..where((f) => f.id.equals(folderId)))
        .write(FoldersCompanion(
      deletedAt: Value(now),
      syncStatus: const Value('pending'),
    ));

    // Queue for sync
    await _outboxService.enqueue(
      entityType: 'folder',
      entityId: folderId,
      operation: 'delete',
      payload: {'id': folderId},
    );
  }

  // ========== DOCUMENTS ==========

  /// Get all documents in workspace
  Stream<List<Document>> watchDocuments(
    String workspaceId, {
    String? folderId,
    String? kind,
  }) {
    final query = _db.select(_db.documents)
      ..where((d) => d.workspaceId.equals(workspaceId))
      ..where((d) => d.deletedAt.isNull());

    if (folderId != null) {
      query.where((d) => d.folderId.equals(folderId));
    }

    if (kind != null) {
      query.where((d) => d.kind.equals(kind));
    }

    query.orderBy([
      (d) => OrderingTerm(expression: d.title, mode: OrderingMode.asc),
    ]);

    return query.watch();
  }

  /// Get recent documents
  Stream<List<Document>> watchRecentDocuments(String workspaceId, {int limit = 12}) {
    return (_db.select(_db.documents)
          ..where((d) => d.workspaceId.equals(workspaceId))
          ..where((d) => d.deletedAt.isNull())
          ..orderBy([
            (d) => OrderingTerm(expression: d.updatedAt, mode: OrderingMode.desc)
          ])
          ..limit(limit))
        .watch();
  }

  /// Get document by ID
  Future<Document?> getDocument(String documentId) {
    return (_db.select(_db.documents)..where((d) => d.id.equals(documentId)))
        .getSingleOrNull();
  }

  /// Create file document (after file upload)
  Future<Document> createFileDocument({
    required String workspaceId,
    required String title,
    required String fileId,
    String? folderId,
    required String createdBy,
  }) async {
    final id = uuid.v4();
    final now = DateTime.now();

    final document = DocumentsCompanion(
      id: Value(id),
      workspaceId: Value(workspaceId),
      kind: const Value('file'),
      title: Value(title),
      folderId: Value(folderId),
      fileId: Value(fileId),
      createdBy: Value(createdBy),
      createdAt: Value(now),
      updatedAt: Value(now),
      syncStatus: const Value('pending'),
    );

    await _db.into(_db.documents).insert(document);

    // Queue for sync
    await _outboxService.enqueue(
      entityType: 'document',
      entityId: id,
      operation: 'create',
      payload: {
        'id': id,
        'workspace_id': workspaceId,
        'kind': 'file',
        'title': title,
        if (folderId != null) 'folder_id': folderId,
        'file_id': fileId,
        'created_by': createdBy,
      },
    );

    final created = await getDocument(id);
    return created!;
  }

  /// Create written document
  Future<Document> createWrittenDocument({
    required String workspaceId,
    required String title,
    required String content,
    String? contentText,
    String? folderId,
    required String createdBy,
  }) async {
    final id = uuid.v4();
    final now = DateTime.now();

    final document = DocumentsCompanion(
      id: Value(id),
      workspaceId: Value(workspaceId),
      kind: const Value('written'),
      title: Value(title),
      folderId: Value(folderId),
      content: Value(content),
      contentText: Value(contentText),
      createdBy: Value(createdBy),
      createdAt: Value(now),
      updatedAt: Value(now),
      syncStatus: const Value('pending'),
    );

    await _db.into(_db.documents).insert(document);

    // Queue for sync
    await _outboxService.enqueue(
      entityType: 'document',
      entityId: id,
      operation: 'create',
      payload: {
        'id': id,
        'workspace_id': workspaceId,
        'kind': 'written',
        'title': title,
        if (folderId != null) 'folder_id': folderId,
        'content': content,
        if (contentText != null) 'content_text': contentText,
        'created_by': createdBy,
      },
    );

    final created = await getDocument(id);
    return created!;
  }

  /// Update document
  Future<void> updateDocument({
    required String documentId,
    String? title,
    String? folderId,
    String? content,
    String? contentText,
  }) async {
    final now = DateTime.now();
    final updates = <String, dynamic>{'id': documentId};

    if (title != null) updates['title'] = title;
    if (folderId != null) updates['folder_id'] = folderId;
    if (content != null) {
      updates['content'] = content;
      if (contentText != null) updates['content_text'] = contentText;
    }

    await (_db.update(_db.documents)..where((d) => d.id.equals(documentId)))
        .write(DocumentsCompanion(
      title: title != null ? Value(title) : const Value.absent(),
      folderId: folderId != null ? Value(folderId) : const Value.absent(),
      content: content != null ? Value(content) : const Value.absent(),
      contentText: contentText != null ? Value(contentText) : const Value.absent(),
      updatedAt: Value(now),
      syncStatus: const Value('pending'),
    ));

    // Queue for sync
    await _outboxService.enqueue(
      entityType: 'document',
      entityId: documentId,
      operation: 'update',
      payload: updates,
    );
  }

  /// Delete document
  Future<void> deleteDocument(String documentId) async {
    final now = DateTime.now();

    await (_db.update(_db.documents)..where((d) => d.id.equals(documentId)))
        .write(DocumentsCompanion(
      deletedAt: Value(now),
      syncStatus: const Value('pending'),
    ));

    // Queue for sync
    await _outboxService.enqueue(
      entityType: 'document',
      entityId: documentId,
      operation: 'delete',
      payload: {'id': documentId},
    );
  }
}

/// Provider
final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final apiClient = ref.watch(apiClientProvider);
  final outboxService = ref.watch(outboxServiceProvider);
  return DocumentRepository(db, apiClient, outboxService);
});

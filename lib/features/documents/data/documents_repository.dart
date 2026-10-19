// app/lib/features/documents/data/documents_repository.dart
import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/db/app_database.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_mapper.dart';
import '../../../core/network/app_failure.dart';
import '../../../core/sync/sync_engine.dart';
import '../models/document_models.dart';

const _maxFileSizeBytes = 25 * 1024 * 1024; // 25 MB
const _fileMimeTypes = {
  'jpg': 'image/jpeg',
  'jpeg': 'image/jpeg',
  'png': 'image/png',
  'gif': 'image/gif',
  'webp': 'image/webp',
  'pdf': 'application/pdf',
  'doc': 'application/msword',
  'docx':
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  'xls': 'application/vnd.ms-excel',
  'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  'txt': 'text/plain',
  'csv': 'text/csv',
  'zip': 'application/zip',
};

String mimeTypeForFileName(String fileName) {
  final extension = fileName.split('.').last.toLowerCase();
  return _fileMimeTypes[extension] ?? 'application/octet-stream';
}

class DocumentsRepository {
  final Dio _dio;
  final AppDatabase _db;
  final SyncEngine _sync;
  DocumentsRepository(this._dio, this._db, this._sync);

  Future<void> _cacheFolder(FolderModel folder) async {
    final previous = await (_db.select(
      _db.folders,
    )..where((row) => row.id.equals(folder.id))).getSingleOrNull();
    await _db
        .into(_db.folders)
        .insertOnConflictUpdate(
          FoldersCompanion(
            id: Value(folder.id),
            workspaceId: Value(folder.workspaceId),
            parentId: Value(folder.parentId),
            name: Value(folder.name),
            fileCount: Value(folder.fileCount),
            createdBy: Value(previous?.createdBy ?? ''),
            createdAt: Value(previous?.createdAt ?? folder.createdAt),
            updatedAt: Value(folder.updatedAt),
            deletedAt: Value(previous?.deletedAt),
          ),
        );
  }

  Future<FolderModel?> _cachedFolderById(String folderId) async {
    final row = await (_db.select(
      _db.folders,
    )..where((folder) => folder.id.equals(folderId))).getSingleOrNull();
    if (row == null || row.deletedAt != null) return null;
    return FolderModel(
      id: row.id,
      workspaceId: row.workspaceId,
      parentId: row.parentId,
      name: row.name,
      fileCount: row.fileCount,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  Future<void> _cacheDocument(
    DocumentModel document, {
    bool preserveMissingContentText = false,
  }) async {
    final previous = await (_db.select(
      _db.documents,
    )..where((row) => row.id.equals(document.id))).getSingleOrNull();
    await _db
        .into(_db.documents)
        .insertOnConflictUpdate(
          DocumentsCompanion(
            id: Value(document.id),
            workspaceId: Value(document.workspaceId),
            folderId: Value(document.folderId),
            kind: Value(document.kind),
            title: Value(document.title),
            fileId: Value(document.fileId),
            mimeType: Value(document.mimeType ?? previous?.mimeType),
            sizeBytes: Value(document.sizeBytes ?? previous?.sizeBytes),
            storagePath: Value(document.storagePath ?? previous?.storagePath),
            content: Value(
              document.content == null
                  ? previous?.content
                  : jsonEncode(document.content),
            ),
            contentText: Value(
              preserveMissingContentText && document.contentText.isEmpty
                  ? previous?.contentText ?? ''
                  : document.contentText,
            ),
            createdBy: Value(document.createdBy),
            createdAt: Value(previous?.createdAt ?? document.createdAt),
            updatedAt: Value(document.updatedAt),
            deletedAt: Value(previous?.deletedAt),
          ),
        );
  }

  Future<DocumentModel?> _cachedDocumentById(String documentId) async {
    final row = await (_db.select(
      _db.documents,
    )..where((document) => document.id.equals(documentId))).getSingleOrNull();
    if (row == null || row.deletedAt != null) return null;
    return DocumentModel(
      id: row.id,
      workspaceId: row.workspaceId,
      folderId: row.folderId,
      kind: row.kind,
      title: row.title,
      fileId: row.fileId,
      mimeType: row.mimeType,
      sizeBytes: row.sizeBytes,
      storagePath: row.storagePath,
      content: row.content == null
          ? null
          : jsonDecode(row.content!) as Map<String, dynamic>,
      contentText: row.contentText,
      createdBy: row.createdBy,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  Future<bool> _hasPendingMutation(String entityId) async => (await (_db.select(
    _db.outboxEntries,
  )..where((entry) => entry.entityId.equals(entityId))).get()).isNotEmpty;

  Future<void> _markFolderDeleted(String folderId) async {
    await (_db.update(_db.folders)
          ..where((folder) => folder.id.equals(folderId)))
        .write(FoldersCompanion(deletedAt: Value(DateTime.now())));
  }

  Future<void> _markDocumentDeleted(String documentId) async {
    await (_db.update(_db.documents)
          ..where((document) => document.id.equals(documentId)))
        .write(DocumentsCompanion(deletedAt: Value(DateTime.now())));
  }

  Future<List<FolderModel>> _cachedFolders(
    String workspaceId,
    String? parentId,
  ) async {
    final rows =
        await (_db.select(_db.folders)
              ..where(
                (row) =>
                    row.workspaceId.equals(workspaceId) &
                    row.deletedAt.isNull() &
                    (parentId == null
                        ? row.parentId.isNull()
                        : row.parentId.equals(parentId)),
              )
              ..orderBy([(row) => OrderingTerm.asc(row.name)]))
            .get();
    return rows
        .map(
          (row) => FolderModel(
            id: row.id,
            workspaceId: row.workspaceId,
            parentId: row.parentId,
            name: row.name,
            fileCount: row.fileCount,
            createdAt: row.createdAt,
            updatedAt: row.updatedAt,
          ),
        )
        .toList();
  }

  Future<List<DocumentModel>> _cachedDocuments(
    String workspaceId, {
    String? folderId,
    bool recent = false,
  }) async {
    final query = _db.select(_db.documents)
      ..where(
        (row) =>
            row.workspaceId.equals(workspaceId) &
            row.deletedAt.isNull() &
            (recent
                ? const Constant(true)
                : folderId == null
                ? row.folderId.isNull()
                : row.folderId.equals(folderId)),
      )
      ..orderBy([(row) => OrderingTerm.desc(row.updatedAt)]);
    if (recent) query.limit(12);
    final rows = await query.get();
    return rows
        .map(
          (row) => DocumentModel(
            id: row.id,
            workspaceId: row.workspaceId,
            folderId: row.folderId,
            kind: row.kind,
            title: row.title,
            fileId: row.fileId,
            mimeType: row.mimeType,
            sizeBytes: row.sizeBytes,
            storagePath: row.storagePath,
            content: row.content == null
                ? null
                : jsonDecode(row.content!) as Map<String, dynamic>,
            contentText: row.contentText,
            createdBy: row.createdBy,
            createdAt: row.createdAt,
            updatedAt: row.updatedAt,
          ),
        )
        .toList();
  }

  // ── Folders ──────────────────────────────────────────────────────────────
  Future<(List<FolderModel>, AppFailure?)> getFolders(
    String workspaceId, {
    String? parentId,
  }) async {
    try {
      final params = <String, dynamic>{};
      if (parentId != null) params['parentId'] = parentId;
      final res = await _dio.get(
        '/workspaces/$workspaceId/folders',
        queryParameters: params,
      );
      final list = (res.data['folders'] as List)
          .map((f) => FolderModel.fromJson(f as Map<String, dynamic>))
          .toList();
      final cachedFolders = await _cachedFolders(workspaceId, parentId);
      final cachedById = {
        for (final folder in cachedFolders) folder.id: folder,
      };
      final remoteIds = list.map((folder) => folder.id).toSet();
      final visible = <FolderModel>[];
      for (final folder in list) {
        final cached = await (_db.select(
          _db.folders,
        )..where((row) => row.id.equals(folder.id))).getSingleOrNull();
        if (cached?.deletedAt != null) continue;
        if (await _hasPendingMutation(folder.id)) {
          final local =
              cachedById[folder.id] ?? await _cachedFolderById(folder.id);
          if (local != null && local.parentId == parentId) {
            visible.add(local);
          } else if (local == null) {
            await _cacheFolder(folder);
            visible.add(folder);
          }
          continue;
        }
        await _cacheFolder(folder);
        visible.add(folder);
      }
      for (final cached in cachedFolders) {
        if (remoteIds.contains(cached.id)) continue;
        if (await _hasPendingMutation(cached.id)) {
          visible.add(cached);
        } else {
          await (_db.delete(
            _db.folders,
          )..where((row) => row.id.equals(cached.id))).go();
        }
      }
      visible.sort((first, second) => first.name.compareTo(second.name));
      return (visible, null);
    } on DioException catch (e) {
      return (await _cachedFolders(workspaceId, parentId), mapDioError(e));
    }
  }

  Future<(FolderModel?, AppFailure?)> createFolder(
    String workspaceId,
    String name, {
    String? parentId,
  }) async {
    final id = const Uuid().v4();
    final now = DateTime.now();
    final localFolder = FolderModel(
      id: id,
      workspaceId: workspaceId,
      parentId: parentId,
      name: name,
      createdAt: now,
      updatedAt: now,
    );
    await _cacheFolder(localFolder);
    try {
      final res = await _dio.post(
        '/workspaces/$workspaceId/folders',
        data: {
          'id': id,
          'name': name,
          if (parentId != null) 'parentId': parentId,
        },
      );
      final folder = FolderModel.fromJson(
        res.data['folder'] as Map<String, dynamic>,
      );
      await _cacheFolder(folder);
      return (folder, null);
    } on DioException catch (e) {
      final failure = mapDioError(e);
      if (_isTemporaryFailure(failure)) {
        await _sync.queueCreate('workspaces/$workspaceId/folders', id, {
          'id': id,
          'workspaceId': workspaceId,
          'name': name,
          if (parentId != null) 'parentId': parentId,
        });
        return (localFolder, null);
      }
      await (_db.delete(_db.folders)..where((row) => row.id.equals(id))).go();
      return (null, failure);
    }
  }

  Future<AppFailure?> deleteFolder(String folderId) async {
    try {
      await _dio.delete('/folders/$folderId');
      await _markFolderDeleted(folderId);
      return null;
    } on DioException catch (e) {
      final failure = mapDioError(e);
      if (failure is NotFoundFailure) {
        await _markFolderDeleted(folderId);
        return null;
      }
      if (!_isTemporaryFailure(failure)) return failure;

      await _markFolderDeleted(folderId);
      await _sync.queueDelete('folders', folderId);
      return null;
    }
  }

  Future<(FolderModel?, AppFailure?)> updateFolder(
    String folderId, {
    String? name,
    String? parentId,
    bool moveToRoot = false,
  }) async {
    final existing = await (_db.select(
      _db.folders,
    )..where((row) => row.id.equals(folderId))).getSingleOrNull();
    if (existing == null) return (null, const NotFoundFailure());
    final nextName = name ?? existing.name;
    final nextParentId = moveToRoot ? null : (parentId ?? existing.parentId);
    final changed = FolderModel(
      id: existing.id,
      workspaceId: existing.workspaceId,
      parentId: nextParentId,
      name: nextName,
      fileCount: existing.fileCount,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );
    try {
      final response = await _dio.patch(
        '/folders/$folderId',
        data: {
          if (name != null) 'name': name,
          if (parentId != null) 'parentId': parentId,
          if (moveToRoot) 'parentId': null,
        },
      );
      final folder = FolderModel.fromJson(
        response.data['folder'] as Map<String, dynamic>,
      );
      await _cacheFolder(folder);
      return (folder, null);
    } on DioException catch (e) {
      final failure = mapDioError(e);
      if (failure is NotFoundFailure) {
        await (_db.delete(
          _db.folders,
        )..where((row) => row.id.equals(folderId))).go();
        return (null, failure);
      }
      if (_isTemporaryFailure(failure)) {
        await _cacheFolder(changed);
        await _sync.queueUpdate('folders', folderId, {
          if (name != null) 'name': name,
          if (parentId != null || moveToRoot)
            'parentId': moveToRoot ? null : parentId,
          '_previous': {'name': existing.name, 'parentId': existing.parentId},
        });
        return (changed, null);
      }
      return (null, failure);
    }
  }

  // ── Documents ─────────────────────────────────────────────────────────────
  Future<(List<DocumentModel>, AppFailure?)> getDocuments(
    String workspaceId, {
    String? folderId,
    bool recent = false,
  }) async {
    try {
      final params = <String, dynamic>{};
      if (folderId != null) params['folderId'] = folderId;
      if (recent) params['recent'] = 'true';
      final res = await _dio.get(
        '/workspaces/$workspaceId/documents',
        queryParameters: params,
      );
      final list = (res.data['documents'] as List)
          .map((d) => DocumentModel.fromJson(d as Map<String, dynamic>))
          .toList();
      final cachedDocuments = await _cachedDocuments(
        workspaceId,
        folderId: folderId,
        recent: recent,
      );
      final cachedById = {
        for (final document in cachedDocuments) document.id: document,
      };
      final remoteIds = list.map((document) => document.id).toSet();
      final visible = <DocumentModel>[];
      for (final document in list) {
        final cached = await (_db.select(
          _db.documents,
        )..where((row) => row.id.equals(document.id))).getSingleOrNull();
        if (cached?.deletedAt != null) continue;
        if (await _hasPendingMutation(document.id)) {
          final local =
              cachedById[document.id] ?? await _cachedDocumentById(document.id);
          if (local != null) {
            if (recent || local.folderId == folderId) {
              visible.add(local);
            }
            continue;
          }
        }
        await _cacheDocument(document, preserveMissingContentText: true);
        visible.add(document);
      }
      final oldestRemote = list.isEmpty
          ? null
          : list.reduce(
              (oldest, document) =>
                  document.updatedAt.isBefore(oldest.updatedAt)
                  ? document
                  : oldest,
            );
      for (final cached in cachedDocuments) {
        if (remoteIds.contains(cached.id)) continue;
        if (await _hasPendingMutation(cached.id)) {
          visible.add(cached);
          continue;
        }
        final isOutsideRecentWindow =
            recent &&
            list.length >= 12 &&
            oldestRemote != null &&
            cached.updatedAt.isBefore(oldestRemote.updatedAt);
        if (!isOutsideRecentWindow) {
          await (_db.delete(
            _db.documents,
          )..where((row) => row.id.equals(cached.id))).go();
        }
      }
      visible.sort(
        (first, second) => second.updatedAt.compareTo(first.updatedAt),
      );
      if (recent && visible.length > 12) {
        visible.removeRange(12, visible.length);
      }
      return (visible, null);
    } on DioException catch (e) {
      return (
        await _cachedDocuments(workspaceId, folderId: folderId, recent: recent),
        mapDioError(e),
      );
    }
  }

  Future<(DocumentModel?, AppFailure?)> getDocument(String documentId) async {
    final cached = await (_db.select(
      _db.documents,
    )..where((item) => item.id.equals(documentId))).getSingleOrNull();
    if (cached?.deletedAt != null) {
      return (null, const NotFoundFailure());
    }
    try {
      final res = await _dio.get('/documents/$documentId');
      final document = DocumentModel.fromJson(
        res.data['document'] as Map<String, dynamic>,
      );
      await _cacheDocument(document);
      return (document, null);
    } on DioException catch (e) {
      final failure = mapDioError(e);
      if (failure is NotFoundFailure) {
        await _markDocumentDeleted(documentId);
        return (null, failure);
      }
      final row =
          await (_db.select(_db.documents)..where(
                (item) => item.id.equals(documentId) & item.deletedAt.isNull(),
              ))
              .getSingleOrNull();
      if (row == null) return (null, mapDioError(e));
      return (
        DocumentModel(
          id: row.id,
          workspaceId: row.workspaceId,
          folderId: row.folderId,
          kind: row.kind,
          title: row.title,
          fileId: row.fileId,
          mimeType: row.mimeType,
          sizeBytes: row.sizeBytes,
          storagePath: row.storagePath,
          content: row.content == null
              ? null
              : jsonDecode(row.content!) as Map<String, dynamic>,
          contentText: row.contentText,
          createdBy: row.createdBy,
          createdAt: row.createdAt,
          updatedAt: row.updatedAt,
        ),
        mapDioError(e),
      );
    }
  }

  Future<(DocumentModel?, AppFailure?)> createWrittenDocument(
    String workspaceId,
    String title, {
    String? folderId,
  }) async {
    final now = DateTime.now();
    final id = const Uuid().v4();
    final content = {
      'ops': [
        {'insert': '\n'},
      ],
    };
    try {
      final res = await _dio.post(
        '/workspaces/$workspaceId/documents',
        data: {
          'id': id,
          'kind': 'written',
          'title': title,
          if (folderId != null) 'folderId': folderId,
          'content': content,
          'contentText': '',
        },
      );
      final document = DocumentModel.fromJson(
        res.data['document'] as Map<String, dynamic>,
      );
      await _cacheDocument(document);
      return (document, null);
    } on DioException catch (e) {
      final failure = mapDioError(e);
      if (_isTemporaryFailure(failure)) {
        final document = DocumentModel(
          id: id,
          workspaceId: workspaceId,
          folderId: folderId,
          kind: 'written',
          title: title,
          content: content,
          createdBy: '',
          createdAt: now,
          updatedAt: now,
        );
        await _cacheDocument(document);
        await _sync.queueCreate('documents', id, {
          'id': id,
          'workspaceId': workspaceId,
          'kind': 'written',
          'title': title,
          'folderId': folderId,
          'content': content,
          'contentText': '',
        });
        return (document, null);
      }
      return (null, failure);
    }
  }

  Future<(DocumentModel?, AppFailure?)> createFileDocument(
    String workspaceId, {
    required String title,
    required String fileId,
    String? folderId,
    required String mimeType,
    required int sizeBytes,
  }) async {
    try {
      final response = await _dio.post(
        '/workspaces/$workspaceId/documents',
        data: {
          'kind': 'file',
          'title': title,
          'fileId': fileId,
          if (folderId != null) 'folderId': folderId,
        },
      );
      final document = DocumentModel.fromJson(
        response.data['document'] as Map<String, dynamic>,
      );
      final enriched = DocumentModel(
        id: document.id,
        workspaceId: document.workspaceId,
        folderId: document.folderId,
        kind: document.kind,
        title: document.title,
        fileId: document.fileId,
        content: document.content,
        contentText: document.contentText,
        createdBy: document.createdBy,
        createdByName: document.createdByName,
        createdAt: document.createdAt,
        updatedAt: document.updatedAt,
        mimeType: mimeType,
        sizeBytes: sizeBytes,
      );
      await _cacheDocument(enriched);
      return (enriched, null);
    } on DioException catch (e) {
      return (null, mapDioError(e));
    }
  }

  Future<AppFailure?> updateDocument(
    String documentId, {
    String? title,
    Map<String, dynamic>? content,
    String? contentText,
    String? folderId,
    bool moveToRoot = false,
  }) async {
    final existing = await (_db.select(
      _db.documents,
    )..where((row) => row.id.equals(documentId))).getSingleOrNull();
    final updatedAt = DateTime.now();
    try {
      final data = <String, dynamic>{};
      if (title != null) data['title'] = title;
      if (folderId != null) data['folderId'] = folderId;
      if (moveToRoot) data['folderId'] = null;
      if (content != null) data['content'] = content;
      if (contentText != null) data['contentText'] = contentText;
      final response = await _dio.patch('/documents/$documentId', data: data);
      final document = DocumentModel.fromJson(
        response.data['document'] as Map<String, dynamic>,
      );
      await _cacheDocument(document);
      return null;
    } on DioException catch (e) {
      final failure = mapDioError(e);
      if (failure is NotFoundFailure) {
        if (existing != null) await _markDocumentDeleted(documentId);
        return failure;
      }
      if (existing != null && _isTemporaryFailure(failure)) {
        final nextContent =
            content ??
            (existing.content == null
                ? null
                : jsonDecode(existing.content!) as Map<String, dynamic>);
        await (_db.update(
          _db.documents,
        )..where((row) => row.id.equals(documentId))).write(
          DocumentsCompanion(
            title: title == null ? const Value.absent() : Value(title),
            folderId: moveToRoot
                ? const Value(null)
                : folderId == null
                ? const Value.absent()
                : Value(folderId),
            content: nextContent == null
                ? const Value.absent()
                : Value(jsonEncode(nextContent)),
            contentText: contentText == null
                ? const Value.absent()
                : Value(contentText),
            updatedAt: Value(updatedAt),
          ),
        );
        await _sync.queueUpdate('documents', documentId, {
          if (title != null) 'title': title,
          if (folderId != null || moveToRoot)
            'folderId': moveToRoot ? null : folderId,
          if (content != null) 'content': content,
          if (contentText != null) 'contentText': contentText,
          '_previous': {
            'title': existing.title,
            'folderId': existing.folderId,
            'content': existing.content,
            'contentText': existing.contentText,
          },
        });
        return null;
      }
      return failure;
    }
  }

  Future<AppFailure?> deleteDocument(String documentId) async {
    try {
      await _dio.delete('/documents/$documentId');
      await _markDocumentDeleted(documentId);
      return null;
    } on DioException catch (e) {
      final failure = mapDioError(e);
      if (failure is NotFoundFailure) {
        await _markDocumentDeleted(documentId);
        return null;
      }
      if (_isTemporaryFailure(failure)) {
        await _markDocumentDeleted(documentId);
        await _sync.queueDelete('documents', documentId);
        return null;
      }
      return failure;
    }
  }

  bool _isTemporaryFailure(AppFailure failure) =>
      failure is NetworkFailure ||
      failure is ServerUnreachableFailure ||
      failure is TimeoutFailure ||
      failure is ServerFailure;

  // ── File upload ───────────────────────────────────────────────────────────
  Future<(String?, AppFailure?)> uploadFile(
    String workspaceId,
    File file,
    String mimeType, {
    void Function(int sent, int total)? onProgress,
    CancelToken? cancelToken,
  }) async {
    final size = await file.length();
    if (size > _maxFileSizeBytes) {
      return (
        null,
        const ValidationFailure('File is too large. Maximum size is 25 MB.'),
      );
    }

    String? fileId;
    try {
      // Step 1: get signed upload URL
      final urlRes = await _dio.post(
        '/workspaces/$workspaceId/files/upload-url',
        data: {
          'name': file.path.split(Platform.pathSeparator).last,
          'mimeType': mimeType,
          'sizeBytes': size,
        },
        cancelToken: cancelToken,
      );
      final uploadUrl = urlRes.data['uploadUrl'] as String;
      fileId = urlRes.data['fileId'] as String;

      // Step 2: upload directly to storage (no auth header needed)
      final uploadDio = Dio();
      await uploadDio.put(
        uploadUrl,
        data: file.openRead(),
        options: Options(
          headers: {'Content-Type': mimeType, 'Content-Length': size},
        ),
        onSendProgress: onProgress,
        cancelToken: cancelToken,
      );

      return (fileId, null);
    } on DioException catch (e) {
      if (fileId != null) {
        final cleanupFailure = await deleteFile(fileId);
        if (cleanupFailure != null) return (null, cleanupFailure);
      }
      if (CancelToken.isCancel(e)) return (null, null);

      final data = e.response?.data;
      final Map? errMap = (data is Map) ? data['error'] as Map? : null;
      final code = errMap?['code'] as String?;
      if (code == 'FILE_TOO_LARGE') {
        return (
          null,
          const ValidationFailure('File is too large. Maximum size is 25 MB.'),
        );
      }
      if (code == 'FILE_TYPE_NOT_ALLOWED') {
        return (
          null,
          const ValidationFailure('This file type is not allowed.'),
        );
      }
      return (null, mapDioError(e));
    }
  }

  Future<(String?, AppFailure?)> getDownloadUrl(String fileId) async {
    try {
      final res = await _dio.get('/files/$fileId/download-url');
      return (res.data['downloadUrl'] as String, null);
    } on DioException catch (e) {
      return (null, mapDioError(e));
    }
  }

  Future<(String?, AppFailure?)> getTextFileContents(String downloadUrl) async {
    try {
      final response = await Dio().get<String>(
        downloadUrl,
        options: Options(responseType: ResponseType.plain),
      );
      return (response.data, null);
    } on DioException catch (e) {
      return (null, mapDioError(e));
    }
  }

  Future<AppFailure?> downloadFile(String downloadUrl, String path) async {
    try {
      await Dio().download(downloadUrl, path);
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    } on FileSystemException catch (e) {
      return UnknownFailure(e.message);
    }
  }

  Future<AppFailure?> deleteFile(String fileId) async {
    try {
      await _dio.delete('/files/$fileId');
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }
}

final documentsRepositoryProvider = Provider<DocumentsRepository>((ref) {
  return DocumentsRepository(
    ref.watch(apiClientProvider).dio,
    ref.watch(appDatabaseProvider),
    ref.watch(syncEngineProvider.notifier),
  );
});

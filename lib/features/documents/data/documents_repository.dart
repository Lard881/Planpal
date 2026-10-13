// app/lib/features/documents/data/documents_repository.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_mapper.dart';
import '../../../core/network/app_failure.dart';
import '../models/document_models.dart';

const _maxFileSizeBytes = 25 * 1024 * 1024; // 25 MB

class DocumentsRepository {
  final Dio _dio;
  DocumentsRepository(this._dio);

  // ── Folders ──────────────────────────────────────────────────────────────
  Future<(List<FolderModel>, AppFailure?)> getFolders(
      String workspaceId, {String? parentId}) async {
    try {
      final params = <String, dynamic>{};
      if (parentId != null) params['parentId'] = parentId;
      final res = await _dio.get(
          '/workspaces/$workspaceId/folders', queryParameters: params);
      final list = (res.data['folders'] as List)
          .map((f) => FolderModel.fromJson(f as Map<String, dynamic>))
          .toList();
      return (list, null);
    } on DioException catch (e) {
      return (<FolderModel>[], mapDioError(e));
    }
  }

  Future<(FolderModel?, AppFailure?)> createFolder(
      String workspaceId, String name, {String? parentId}) async {
    try {
      final res = await _dio.post('/workspaces/$workspaceId/folders',
          data: {'name': name, if (parentId != null) 'parent_id': parentId});
      return (FolderModel.fromJson(res.data['folder'] as Map<String, dynamic>), null);
    } on DioException catch (e) {
      return (null, mapDioError(e));
    }
  }

  Future<AppFailure?> deleteFolder(String workspaceId, String folderId) async {
    try {
      await _dio.delete('/workspaces/$workspaceId/folders/$folderId');
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }

  // ── Documents ─────────────────────────────────────────────────────────────
  Future<(List<DocumentModel>, AppFailure?)> getDocuments(
      String workspaceId, {String? folderId, bool recent = false}) async {
    try {
      final params = <String, dynamic>{};
      if (folderId != null) params['folderId'] = folderId;
      if (recent) params['recent'] = 'true';
      final res = await _dio.get(
          '/workspaces/$workspaceId/documents', queryParameters: params);
      final list = (res.data['documents'] as List)
          .map((d) => DocumentModel.fromJson(d as Map<String, dynamic>))
          .toList();
      return (list, null);
    } on DioException catch (e) {
      return (<DocumentModel>[], mapDioError(e));
    }
  }

  Future<(DocumentModel?, AppFailure?)> getDocument(String documentId) async {
    try {
      final res = await _dio.get('/documents/$documentId');
      return (DocumentModel.fromJson(res.data['document'] as Map<String, dynamic>), null);
    } on DioException catch (e) {
      return (null, mapDioError(e));
    }
  }

  Future<(DocumentModel?, AppFailure?)> createWrittenDocument(
      String workspaceId, String title, {String? folderId}) async {
    try {
      final res = await _dio.post('/workspaces/$workspaceId/documents', data: {
        'kind': 'written',
        'title': title,
        if (folderId != null) 'folder_id': folderId,
        'content': {'ops': [{'insert': '\n'}]},
        'content_text': '',
      });
      return (DocumentModel.fromJson(res.data['document'] as Map<String, dynamic>), null);
    } on DioException catch (e) {
      return (null, mapDioError(e));
    }
  }

  Future<AppFailure?> updateDocument(String documentId,
      {String? title, Map<String, dynamic>? content, String? contentText}) async {
    try {
      final data = <String, dynamic>{};
      if (title != null) data['title'] = title;
      if (content != null) data['content'] = content;
      if (contentText != null) data['content_text'] = contentText;
      await _dio.patch('/documents/$documentId', data: data);
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }

  Future<AppFailure?> deleteDocument(String documentId) async {
    try {
      await _dio.delete('/documents/$documentId');
      return null;
    } on DioException catch (e) {
      return mapDioError(e);
    }
  }

  // ── File upload ───────────────────────────────────────────────────────────
  Future<(String?, AppFailure?)> uploadFile(
    String workspaceId,
    File file,
    String mimeType, {
    void Function(int sent, int total)? onProgress,
  }) async {
    final size = await file.length();
    if (size > _maxFileSizeBytes) {
      return (null, const ValidationFailure(
          'File is too large. Maximum size is 25 MB.'));
    }

    try {
      // Step 1: get signed upload URL
      final urlRes = await _dio.post(
        '/workspaces/$workspaceId/files/upload-url',
        data: {
          'name': file.path.split('/').last,
          'mime_type': mimeType,
          'size_bytes': size,
        },
      );
      final uploadUrl = urlRes.data['upload_url'] as String;
      final fileId = urlRes.data['file_id'] as String;

      // Step 2: upload directly to storage (no auth header needed)
      final uploadDio = Dio();
      await uploadDio.put(
        uploadUrl,
        data: file.openRead(),
        options: Options(
          headers: {
            'Content-Type': mimeType,
            'Content-Length': size,
          },
        ),
        onSendProgress: onProgress,
      );

      return (fileId, null);
    } on DioException catch (e) {
      final data = e.response?.data;
      final Map? errMap = (data is Map) ? data['error'] as Map? : null;
      final code = errMap?['code'] as String?;
      if (code == 'FILE_TOO_LARGE') {
        return (null, const ValidationFailure(
            'File is too large. Maximum size is 25 MB.'));
      }
      if (code == 'FILE_TYPE_NOT_ALLOWED') {
        return (null, const ValidationFailure(
            'This file type is not allowed.'));
      }
      return (null, mapDioError(e));
    }
  }

  Future<(String?, AppFailure?)> getDownloadUrl(String fileId) async {
    try {
      final res = await _dio.get('/files/$fileId/download-url');
      return (res.data['download_url'] as String, null);
    } on DioException catch (e) {
      return (null, mapDioError(e));
    }
  }
}

final documentsRepositoryProvider = Provider<DocumentsRepository>((ref) {
  return DocumentsRepository(ref.watch(apiClientProvider).dio);
});

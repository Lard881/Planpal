// app/lib/features/documents/providers/documents_providers.dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/app_failure.dart';
import '../data/documents_repository.dart';
import '../models/document_models.dart';
import '../../workspaces/providers/workspace_providers.dart';

class DocumentsState {
  final List<FolderModel> folders;
  final List<DocumentModel> recentDocs;
  final bool loading;
  final String? error;
  final String? currentFolderId;
  final List<FolderModel> folderPath;
  final bool gridView;

  const DocumentsState({
    this.folders = const [],
    this.recentDocs = const [],
    this.loading = false,
    this.error,
    this.currentFolderId,
    this.folderPath = const [],
    this.gridView = true,
  });

  DocumentsState copyWith({
    List<FolderModel>? folders,
    List<DocumentModel>? recentDocs,
    bool? loading,
    String? error,
    String? currentFolderId,
    List<FolderModel>? folderPath,
    bool? gridView,
    bool clearError = false,
    bool clearCurrentFolder = false,
  }) => DocumentsState(
    folders: folders ?? this.folders,
    recentDocs: recentDocs ?? this.recentDocs,
    loading: loading ?? this.loading,
    error: clearError ? null : (error ?? this.error),
    currentFolderId: clearCurrentFolder
        ? null
        : currentFolderId ?? this.currentFolderId,
    folderPath: folderPath ?? this.folderPath,
    gridView: gridView ?? this.gridView,
  );
}

class DocumentsNotifier extends StateNotifier<DocumentsState> {
  final DocumentsRepository _repo;
  final String workspaceId;

  DocumentsNotifier(this._repo, this.workspaceId)
    : super(const DocumentsState()) {
    load();
  }

  Future<void> load({String? folderId, bool resetFolder = false}) async {
    if (workspaceId.isEmpty) return; // Guard
    final targetFolderId = resetFolder
        ? null
        : folderId ?? state.currentFolderId;
    state = state.copyWith(
      loading: true,
      clearError: true,
      currentFolderId: targetFolderId,
      clearCurrentFolder: targetFolderId == null,
    );
    final (folders, fErr) = await _repo.getFolders(
      workspaceId,
      parentId: targetFolderId,
    );
    final (docs, dErr) = await _repo.getDocuments(
      workspaceId,
      folderId: targetFolderId,
      recent: targetFolderId == null,
    );
    state = state.copyWith(
      folders: folders,
      recentDocs: docs,
      loading: false,
      error: fErr?.message ?? dErr?.message,
    );
  }

  Future<void> openFolder(FolderModel folder) async {
    final path = [...state.folderPath, folder];
    state = state.copyWith(folderPath: path);
    await load(folderId: folder.id);
  }

  Future<void> goUpFolder() async {
    if (state.folderPath.isEmpty) return;
    final path = state.folderPath.sublist(0, state.folderPath.length - 1);
    state = state.copyWith(folderPath: path);
    await load(
      folderId: path.isEmpty ? null : path.last.id,
      resetFolder: path.isEmpty,
    );
  }

  Future<void> refresh() => load();

  void setGridView(bool value) => state = state.copyWith(gridView: value);

  Future<void> renameDocument(String id, String title) async {
    final failure = await _repo.updateDocument(id, title: title);
    if (failure == null) {
      await load();
    } else {
      state = state.copyWith(error: failure.message);
    }
  }

  Future<void> moveDocument(
    DocumentModel document, {
    String? folderId,
    bool moveToRoot = false,
  }) async {
    final failure = await _repo.updateDocument(
      document.id,
      folderId: folderId,
      moveToRoot: moveToRoot,
    );
    if (failure == null) {
      await load();
    } else {
      state = state.copyWith(error: failure.message);
    }
  }

  Future<void> renameFolder(FolderModel folder, String name) async {
    final (updated, failure) = await _repo.updateFolder(
      folder.id,
      name: name,
      parentId: folder.parentId,
    );
    if (updated != null) {
      state = state.copyWith(
        folders: state.folders
            .map((item) => item.id == folder.id ? updated : item)
            .toList(),
        folderPath: state.folderPath
            .map((item) => item.id == folder.id ? updated : item)
            .toList(),
      );
    } else if (failure != null) {
      state = state.copyWith(error: failure.message);
    }
  }

  Future<void> createFolder(String name) async {
    final (folder, err) = await _repo.createFolder(
      workspaceId,
      name,
      parentId: state.currentFolderId,
    );
    if (folder != null) {
      state = state.copyWith(folders: [...state.folders, folder]);
    } else if (err != null) {
      state = state.copyWith(error: err.message);
    }
  }

  Future<AppFailure?> uploadFile(
    File file,
    String fileName, {
    void Function(int sent, int total)? onProgress,
    CancelToken? cancelToken,
  }) async {
    final (fileId, uploadFailure) = await _repo.uploadFile(
      workspaceId,
      file,
      mimeTypeForFileName(fileName),
      onProgress: onProgress,
      cancelToken: cancelToken,
    );
    if (fileId == null || uploadFailure != null) {
      if (uploadFailure != null) {
        state = state.copyWith(error: uploadFailure.message);
      }
      return uploadFailure;
    }
    final (document, createFailure) = await _repo.createFileDocument(
      workspaceId,
      title: fileName,
      fileId: fileId,
      folderId: state.currentFolderId,
      mimeType: mimeTypeForFileName(fileName),
      sizeBytes: await file.length(),
    );
    if (document == null || createFailure != null) {
      final cleanupFailure = await _repo.deleteFile(fileId);
      final failure = createFailure ?? cleanupFailure;
      if (failure != null) state = state.copyWith(error: failure.message);
      return failure;
    }
    state = state.copyWith(
      recentDocs: [document, ...state.recentDocs],
      clearError: true,
    );
    return null;
  }

  Future<(String?, String?)> createWrittenDocument(String title) async {
    final (doc, err) = await _repo.createWrittenDocument(
      workspaceId,
      title,
      folderId: state.currentFolderId,
    );
    if (doc != null) {
      state = state.copyWith(recentDocs: [doc, ...state.recentDocs]);
      return (doc.id, null);
    }
    return (null, err?.message);
  }

  Future<void> deleteDocument(String documentId) async {
    final failure = await _repo.deleteDocument(documentId);
    if (failure == null) {
      state = state.copyWith(
        recentDocs: state.recentDocs
            .where((document) => document.id != documentId)
            .toList(),
      );
    } else {
      state = state.copyWith(error: failure.message);
    }
  }

  Future<void> deleteFolder(String folderId) async {
    final err = await _repo.deleteFolder(workspaceId, folderId);
    if (err == null) {
      state = state.copyWith(
        folders: state.folders.where((f) => f.id != folderId).toList(),
      );
    } else {
      state = state.copyWith(error: err.message);
    }
  }
}

final documentsProvider =
    StateNotifierProvider.autoDispose<DocumentsNotifier, DocumentsState>((ref) {
      final wsId = ref.watch(currentWorkspaceIdProvider) ?? '';
      return DocumentsNotifier(ref.watch(documentsRepositoryProvider), wsId);
    });

final documentDetailProvider = FutureProvider.family
    .autoDispose<DocumentModel?, String>((ref, docId) async {
      final (doc, _) = await ref
          .watch(documentsRepositoryProvider)
          .getDocument(docId);
      return doc;
    });

// app/lib/features/documents/providers/documents_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/documents_repository.dart';
import '../models/document_models.dart';
import '../../workspaces/providers/workspace_providers.dart';

class DocumentsState {
  final List<FolderModel> folders;
  final List<DocumentModel> recentDocs;
  final bool loading;
  final String? error;
  final String? currentFolderId;

  const DocumentsState({
    this.folders = const [],
    this.recentDocs = const [],
    this.loading = false,
    this.error,
    this.currentFolderId,
  });

  DocumentsState copyWith({
    List<FolderModel>? folders, List<DocumentModel>? recentDocs,
    bool? loading, String? error, String? currentFolderId,
    bool clearError = false,
  }) => DocumentsState(
    folders: folders ?? this.folders,
    recentDocs: recentDocs ?? this.recentDocs,
    loading: loading ?? this.loading,
    error: clearError ? null : (error ?? this.error),
    currentFolderId: currentFolderId ?? this.currentFolderId,
  );
}

class DocumentsNotifier extends StateNotifier<DocumentsState> {
  final DocumentsRepository _repo;
  final String workspaceId;

  DocumentsNotifier(this._repo, this.workspaceId)
      : super(const DocumentsState()) {
    load();
  }

  Future<void> load({String? folderId}) async {
    if (workspaceId.isEmpty) return; // Guard
    state = state.copyWith(loading: true, clearError: true,
        currentFolderId: folderId);
    final (folders, fErr) = await _repo.getFolders(workspaceId,
        parentId: folderId);
    final (docs, dErr) = await _repo.getDocuments(workspaceId,
        folderId: folderId, recent: folderId == null);
    state = state.copyWith(
      folders: folders,
      recentDocs: docs,
      loading: false,
      error: fErr?.message ?? dErr?.message,
    );
  }

  Future<void> createFolder(String name) async {
    final (folder, err) = await _repo.createFolder(workspaceId, name,
        parentId: state.currentFolderId);
    if (folder != null) {
      state = state.copyWith(folders: [...state.folders, folder]);
    }
  }

  Future<(String?, String?)> createWrittenDocument(String title) async {
    final (doc, err) = await _repo.createWrittenDocument(workspaceId, title,
        folderId: state.currentFolderId);
    if (doc != null) {
      state = state.copyWith(recentDocs: [doc, ...state.recentDocs]);
      return (doc.id, null);
    }
    return (null, err?.message);
  }

  Future<void> deleteDocument(String documentId) async {
    await _repo.deleteDocument(documentId);
    state = state.copyWith(
      recentDocs: state.recentDocs.where((d) => d.id != documentId).toList());
  }

  Future<void> deleteFolder(String folderId) async {
    final err = await _repo.deleteFolder(workspaceId, folderId);
    if (err == null) {
      state = state.copyWith(
        folders: state.folders.where((f) => f.id != folderId).toList());
    }
  }
}

final documentsProvider =
    StateNotifierProvider.autoDispose<DocumentsNotifier, DocumentsState>((ref) {
  final wsId = ref.watch(currentWorkspaceIdProvider) ?? '';
  return DocumentsNotifier(ref.watch(documentsRepositoryProvider), wsId);
});

final documentDetailProvider =
    FutureProvider.family.autoDispose<DocumentModel?, String>((ref, docId) async {
  final (doc, _) =
      await ref.watch(documentsRepositoryProvider).getDocument(docId);
  return doc;
});

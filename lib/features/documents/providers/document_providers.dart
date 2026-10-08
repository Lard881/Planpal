import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/db/app_database.dart';
import '../../../features/workspaces/providers/workspace_providers.dart';
import '../repositories/document_repository.dart';
import '../services/file_upload_service.dart';

/// Current folder ID provider (for navigation)
final currentFolderIdProvider = StateProvider<String?>((ref) => null);

/// Current document kind filter
final documentKindFilterProvider = StateProvider<String?>((ref) => null);

/// View mode provider (grid or list)
final documentViewModeProvider = StateProvider<bool>((ref) => true); // true = grid, false = list

/// Files stream provider
final filesProvider = StreamProvider.autoDispose<List<File>>((ref) {
  final workspaceId = ref.watch(currentWorkspaceIdProvider);
  if (workspaceId == null) return Stream.value([]);

  final repo = ref.watch(documentRepositoryProvider);
  return repo.watchFiles(workspaceId);
});

/// Folders stream provider
final foldersProvider = StreamProvider.autoDispose<List<Folder>>((ref) {
  final workspaceId = ref.watch(currentWorkspaceIdProvider);
  if (workspaceId == null) return Stream.value([]);

  final parentId = ref.watch(currentFolderIdProvider);
  final repo = ref.watch(documentRepositoryProvider);
  return repo.watchFolders(workspaceId, parentId: parentId);
});

/// Documents stream provider
final documentsProvider = StreamProvider.autoDispose<List<Document>>((ref) {
  final workspaceId = ref.watch(currentWorkspaceIdProvider);
  if (workspaceId == null) return Stream.value([]);

  final folderId = ref.watch(currentFolderIdProvider);
  final kind = ref.watch(documentKindFilterProvider);
  final repo = ref.watch(documentRepositoryProvider);
  
  return repo.watchDocuments(workspaceId, folderId: folderId, kind: kind);
});

/// Recent documents stream provider
final recentDocumentsProvider = StreamProvider.autoDispose<List<Document>>((ref) {
  final workspaceId = ref.watch(currentWorkspaceIdProvider);
  if (workspaceId == null) return Stream.value([]);

  final repo = ref.watch(documentRepositoryProvider);
  return repo.watchRecentDocuments(workspaceId);
});

/// Upload tasks stream provider
final uploadTasksProvider = StreamProvider.autoDispose<List<UploadTask>>((ref) {
  final service = ref.watch(fileUploadServiceProvider);
  return service.tasksStream;
});

/// Active uploads count
final activeUploadsCountProvider = Provider.autoDispose<int>((ref) {
  final tasksAsync = ref.watch(uploadTasksProvider);
  return tasksAsync.when(
    data: (tasks) => tasks.where((t) => t.status == UploadStatus.uploading).length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// Failed uploads count
final failedUploadsCountProvider = Provider.autoDispose<int>((ref) {
  final tasksAsync = ref.watch(uploadTasksProvider);
  return tasksAsync.when(
    data: (tasks) => tasks.where((t) => t.status == UploadStatus.failed).length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// Folder breadcrumb provider
final folderBreadcrumbProvider = FutureProvider.autoDispose<List<Folder>>((ref) async {
  final currentFolderId = ref.watch(currentFolderIdProvider);
  if (currentFolderId == null) return [];

  final repo = ref.watch(documentRepositoryProvider);
  final breadcrumb = <FolderData>[];

  String? folderId = currentFolderId;
  while (folderId != null) {
    final folder = await repo.getFolder(folderId);
    if (folder == null) break;

    breadcrumb.insert(0, folder);
    folderId = folder.parentId;
  }

  return breadcrumb;
});

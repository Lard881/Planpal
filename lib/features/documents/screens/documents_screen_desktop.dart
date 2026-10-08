import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:desktop_drop/desktop_drop.dart';
import '../../../core/l10n/app_localizations.dart';
import '../providers/document_providers.dart';
import '../widgets/document_grid_item.dart';
import '../widgets/document_list_item.dart';
import '../widgets/folder_item.dart';
import '../widgets/upload_progress_sheet.dart';
import 'file_picker_screen.dart';
import 'create_folder_dialog.dart';
import 'document_editor_screen.dart';

class DocumentsScreenDesktop extends ConsumerStatefulWidget {
  const DocumentsScreenDesktop({super.key});

  @override
  ConsumerState<DocumentsScreenDesktop> createState() => _DocumentsScreenDesktopState();
}

class _DocumentsScreenDesktopState extends ConsumerState<DocumentsScreenDesktop> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isGridView = ref.watch(documentViewModeProvider);
    final currentFolderId = ref.watch(currentFolderIdProvider);
    final breadcrumbAsync = ref.watch(folderBreadcrumbProvider);
    final foldersAsync = ref.watch(foldersProvider);
    final documentsAsync = ref.watch(documentsProvider);
    final activeUploads = ref.watch(activeUploadsCountProvider);
    final failedUploads = ref.watch(failedUploadsCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(l10n.documents),
            const SizedBox(width: 16),
            // Breadcrumb in title bar
            if (currentFolderId != null)
              Expanded(
                child: breadcrumbAsync.when(
                  data: (breadcrumb) => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const Icon(Icons.chevron_right, size: 20),
                        // Root
                        TextButton(
                          onPressed: () {
                            ref.read(currentFolderIdProvider.notifier).state = null;
                          },
                          child: Text(l10n.documents),
                        ),
                        // Breadcrumb items
                        for (final folder in breadcrumb) ...[
                          const Icon(Icons.chevron_right, size: 20),
                          TextButton(
                            onPressed: () {
                              ref.read(currentFolderIdProvider.notifier).state =
                                  folder.id;
                            },
                            child: Text(folder.name),
                          ),
                        ],
                      ],
                    ),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),
          ],
        ),
        actions: [
          // View toggle
          IconButton(
            icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
            tooltip: isGridView ? 'List view' : 'Grid view',
            onPressed: () {
              ref.read(documentViewModeProvider.notifier).state = !isGridView;
            },
          ),
          // Upload status indicator
          if (activeUploads > 0 || failedUploads > 0)
            IconButton(
              icon: Badge(
                label: Text('${activeUploads + failedUploads}'),
                backgroundColor: failedUploads > 0 ? Colors.red : Colors.blue,
                child: const Icon(Icons.cloud_upload_outlined),
              ),
              tooltip: l10n.uploads,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: SizedBox(
                      width: 600,
                      height: 500,
                      child: const UploadProgressSheet(),
                    ),
                  ),
                );
              },
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 200,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DocumentEditorScreen(
                            folderId: currentFolderId,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.description),
                    label: const Text('New Document'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FilePickerScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.upload_file),
                    label: Text(l10n.uploadFile),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const CreateFolderDialog(),
                      );
                    },
                    icon: const Icon(Icons.create_new_folder),
                    label: Text(l10n.createFolder),
                  ),
                ),
                const Divider(height: 32),
                // Quick filters
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: Text(l10n.recent),
                  selected: currentFolderId == null,
                  onTap: () {
                    ref.read(currentFolderIdProvider.notifier).state = null;
                  },
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: Column(
              children: [
                // Toolbar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Back button
                      if (currentFolderId != null)
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            breadcrumbAsync.whenData((breadcrumb) {
                              if (breadcrumb.length > 1) {
                                ref.read(currentFolderIdProvider.notifier).state =
                                    breadcrumb[breadcrumb.length - 2].id;
                              } else {
                                ref.read(currentFolderIdProvider.notifier).state = null;
                              }
                            });
                          },
                        ),
                      const Spacer(),
                      // Search
                      SizedBox(
                        width: 300,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: l10n.search,
                            prefixIcon: const Icon(Icons.search),
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content area with drag-and-drop
                Expanded(
                  child: DropTarget(
                    onDragEntered: (details) {
                      setState(() => _isDragging = true);
                    },
                    onDragExited: (details) {
                      setState(() => _isDragging = false);
                    },
                    onDragDone: (details) async {
                      setState(() => _isDragging = false);
                      
                      final currentFolderId = ref.read(currentFolderIdProvider);
                      final documentRepo = ref.read(documentRepositoryProvider);
                      
                      for (final file in details.files) {
                        try {
                          await documentRepo.uploadFile(
                            filePath: file.path,
                            folderId: currentFolderId,
                          );
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to upload ${file.name}: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                      
                      if (context.mounted && details.files.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Uploading ${details.files.length} file(s)...'),
                          ),
                        );
                      }
                    },
                    child: Stack(
                      children: [
                        RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(foldersProvider);
                      ref.invalidate(documentsProvider);
                    },
                    child: CustomScrollView(
                      slivers: [
                        // Folders
                        foldersAsync.when(
                          data: (folders) {
                            if (folders.isEmpty) {
                              return const SliverToBoxAdapter(child: SizedBox.shrink());
                            }

                            if (isGridView) {
                              return SliverPadding(
                                padding: const EdgeInsets.all(24),
                                sliver: SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 150,
                                    mainAxisSpacing: 16,
                                    crossAxisSpacing: 16,
                                    childAspectRatio: 1.0,
                                  ),
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final folder = folders[index];
                                      return Card(
                                        child: InkWell(
                                          onTap: () {
                                            ref
                                                .read(currentFolderIdProvider.notifier)
                                                .state = folder.id;
                                          },
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.folder,
                                                size: 48,
                                                color: Colors.amber,
                                              ),
                                              const SizedBox(height: 8),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(horizontal: 8),
                                                child: Text(
                                                  folder.name,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context).textTheme.bodyMedium,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    childCount: folders.length,
                                  ),
                                ),
                              );
                            } else {
                              return SliverPadding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      return FolderItem(
                                        folder: folders[index],
                                        onTap: () {
                                          ref.read(currentFolderIdProvider.notifier).state =
                                              folders[index].id;
                                        },
                                      );
                                    },
                                    childCount: folders.length,
                                  ),
                                ),
                              );
                            }
                          },
                          loading: () => const SliverToBoxAdapter(
                              child: Center(child: CircularProgressIndicator())),
                          error: (_, __) => SliverToBoxAdapter(
                              child: Center(child: Text(l10n.errorLoadingData))),
                        ),

                        // Documents
                        documentsAsync.when(
                          data: (documents) {
                            if (documents.isEmpty &&
                                foldersAsync.value?.isEmpty == true) {
                              return SliverFillRemaining(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open,
                                        size: 64,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        l10n.noDocuments,
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        l10n.uploadFileToGetStarted,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            if (isGridView) {
                              return SliverPadding(
                                padding: const EdgeInsets.all(24),
                                sliver: SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 150,
                                    mainAxisSpacing: 16,
                                    crossAxisSpacing: 16,
                                    childAspectRatio: 0.8,
                                  ),
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      return DocumentGridItem(document: documents[index]);
                                    },
                                    childCount: documents.length,
                                  ),
                                ),
                              );
                            } else {
                              return SliverPadding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      return DocumentListItem(document: documents[index]);
                                    },
                                    childCount: documents.length,
                                  ),
                                ),
                              );
                            }
                          },
                          loading: () => const SliverToBoxAdapter(
                              child: Center(child: CircularProgressIndicator())),
                          error: (_, __) => SliverToBoxAdapter(
                              child: Center(child: Text(l10n.errorLoadingData))),
                        ),
                      ],
                    ),
                  ),
                        ),
                        
                        // Drag overlay
                        if (_isDragging)
                          Positioned.fill(
                            child: Container(
                              color: Colors.blue.withValues(alpha: 0.1),
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(32),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Theme.of(context).colorScheme.primary,
                                      width: 2,
                                      strokeAlign: BorderSide.strokeAlignCenter,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.cloud_upload,
                                        size: 64,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Drop files here to upload',
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

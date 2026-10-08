import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../providers/document_providers.dart';
import '../widgets/document_grid_item.dart';
import '../widgets/document_list_item.dart';
import '../widgets/folder_item.dart';
import '../widgets/upload_progress_sheet.dart';
import 'file_picker_screen.dart';
import 'create_folder_dialog.dart';
import 'document_editor_screen.dart';

class DocumentsScreenMobile extends ConsumerWidget {
  const DocumentsScreenMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isGridView = ref.watch(documentViewModeProvider);
    final currentFolderId = ref.watch(currentFolderIdProvider);
    final breadcrumbAsync = ref.watch(folderBreadcrumbProvider);
    final foldersAsync = ref.watch(foldersProvider);
    final documentsAsync = ref.watch(documentsProvider);
    final recentAsync = ref.watch(recentDocumentsProvider);
    final activeUploads = ref.watch(activeUploadsCountProvider);
    final failedUploads = ref.watch(failedUploadsCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.documents),
        actions: [
          // View toggle
          IconButton(
            icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
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
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const UploadProgressSheet(),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Breadcrumb
          if (currentFolderId != null)
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: breadcrumbAsync.when(
                data: (breadcrumb) => ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // Root
                    TextButton.icon(
                      onPressed: () {
                        ref.read(currentFolderIdProvider.notifier).state = null;
                      },
                      icon: const Icon(Icons.home, size: 18),
                      label: Text(l10n.documents),
                    ),
                    // Breadcrumb items
                    for (final folder in breadcrumb) ...[
                      const Icon(Icons.chevron_right, size: 18),
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
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),

          // Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(foldersProvider);
                ref.invalidate(documentsProvider);
                ref.invalidate(recentDocumentsProvider);
              },
              child: CustomScrollView(
                slivers: [
                  // Recent (only at root)
                  if (currentFolderId == null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.recent,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            recentAsync.when(
                              data: (recent) {
                                if (recent.isEmpty) {
                                  return Text(
                                    l10n.noRecentDocuments,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  );
                                }
                                return SizedBox(
                                  height: 120,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: recent.length,
                                    itemBuilder: (context, index) {
                                      final doc = recent[index];
                                      return SizedBox(
                                        width: 100,
                                        child: DocumentGridItem(document: doc),
                                      );
                                    },
                                  ),
                                );
                              },
                              loading: () => const Center(
                                  child: CircularProgressIndicator()),
                              error: (_, __) => Text(l10n.errorLoadingData),
                            ),
                            const Divider(height: 32),
                          ],
                        ),
                      ),
                    ),

                  // Folders
                  foldersAsync.when(
                    data: (folders) {
                      if (folders.isEmpty) {
                        return const SliverToBoxAdapter(child: SizedBox.shrink());
                      }
                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    },
                    loading: () => const SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator())),
                    error: (_, __) => SliverToBoxAdapter(
                        child: Center(child: Text(l10n.errorLoadingData))),
                  ),

                  // Documents
                  documentsAsync.when(
                    data: (documents) {
                      if (documents.isEmpty && foldersAsync.value?.isEmpty == true) {
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
                          padding: const EdgeInsets.all(16),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
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
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // New document
          FloatingActionButton(
            heroTag: 'new_document',
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
            child: const Icon(Icons.description),
          ),
          const SizedBox(height: 12),
          // New folder
          FloatingActionButton(
            heroTag: 'new_folder',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const CreateFolderDialog(),
              );
            },
            child: const Icon(Icons.create_new_folder),
          ),
          const SizedBox(height: 12),
          // Upload file
          FloatingActionButton(
            heroTag: 'upload_file',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FilePickerScreen(),
                ),
              );
            },
            child: const Icon(Icons.upload_file),
          ),
        ],
      ),
    );
  }
}

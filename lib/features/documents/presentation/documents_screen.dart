// app/lib/features/documents/presentation/documents_screen.dart
import 'dart:io';
import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/connectivity/connectivity_service.dart';
import '../../../core/network/app_failure.dart';
import '../../../core/network/failure_localizer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/widgets/chips.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/planpal_button.dart';
import '../../workspaces/providers/workspace_providers.dart';
import '../models/document_models.dart';
import '../providers/documents_providers.dart';
import '../data/documents_repository.dart';

// Folder tile colors cycle — using the same values as PlanPalColors tokens
const _folderColors = [
  Color(0xFFEEF0FF), // primarySoft
  Color(0xFFEDE9FE), // violetSoft
  Color(0xFFE0F2FE), // skySoft
  Color(0xFFFEF3C7), // warningSoft
];
const _folderIconColors = [
  Color(0xFF4F46E5), // primary
  Color(0xFF8B5CF6), // violet
  Color(0xFF0EA5E9), // sky
  Color(0xFFF59E0B), // warning
];

class DocumentsScreen extends ConsumerWidget {
  final String? documentId;
  const DocumentsScreen({super.key, this.documentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (documentId != null) {
      return DocumentEditorScreen(documentId: documentId!);
    }
    return context.isDesktopLayout
        ? const _DesktopDocuments()
        : const _MobileDocuments();
  }
}

// ── DESKTOP ───────────────────────────────────────────────────────────────────
class _DesktopDocuments extends ConsumerStatefulWidget {
  const _DesktopDocuments();

  @override
  ConsumerState<_DesktopDocuments> createState() => _DesktopDocumentsState();
}

class _DesktopDocumentsState extends ConsumerState<_DesktopDocuments> {
  bool _isDragging = false;

  Future<void> _uploadDroppedFiles(DropDoneDetails details) async {
    if (!Platform.isWindows) return;
    setState(() => _isDragging = false);
    final l10n = AppLocalizations.of(context);
    final files = details.files.whereType<DropItemFile>().toList();
    if (files.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.documentDropFilesOnly)));
      return;
    }
    if (!ref.read(isOnlineProvider)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.taskAttachmentOffline)));
      return;
    }
    for (final file in files) {
      if (!mounted) return;
      await _showDocumentUploadDialog(
        context: context,
        ref: ref,
        file: File(file.path),
        fileName: file.name,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final state = ref.watch(documentsProvider);
    final wsName = ref.watch(currentWorkspaceProvider)?.name ?? 'Workspace';
    final l10n = AppLocalizations.of(context);
    final isOnline = ref.watch(isOnlineProvider);

    return Scaffold(
      backgroundColor: c.background,
      body: DropTarget(
        enable: Platform.isWindows,
        onDragEntered: (_) => setState(() => _isDragging = true),
        onDragExited: (_) => setState(() => _isDragging = false),
        onDragDone: (details) {
          unawaited(_uploadDroppedFiles(details));
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Breadcrumb
                  Row(
                    children: [
                      if (state.folderPath.isNotEmpty)
                        IconButton(
                          tooltip: l10n.btnCancel,
                          onPressed: () =>
                              ref.read(documentsProvider.notifier).goUpFolder(),
                          icon: const Icon(LucideIcons.arrowLeft),
                        ),
                      Text(
                        '$wsName / ${l10n.documentsTitle}${state.folderPath.isEmpty ? '' : ' / ${state.folderPath.map((folder) => folder.name).join(' / ')}'}',
                        style: AppText.caption.copyWith(color: c.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Header row
                  Row(
                    children: [
                      Text(
                        l10n.documentsTitle,
                        style: AppText.pageTitle.copyWith(color: c.textPrimary),
                      ),
                      const Spacer(),
                      // Grid/list toggle (fix F8)
                      Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: c.surfaceAlt,
                          borderRadius: BorderRadius.circular(
                            AppRadius.control,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _ToggleBtn(
                              icon: LucideIcons.layoutGrid,
                              selected: state.gridView,
                              onTap: () => ref
                                  .read(documentsProvider.notifier)
                                  .setGridView(true),
                            ),
                            _ToggleBtn(
                              icon: LucideIcons.list,
                              selected: !state.gridView,
                              onTap: () => ref
                                  .read(documentsProvider.notifier)
                                  .setGridView(false),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        tooltip: l10n.documentNewFolder,
                        onPressed: () => _showNewFolderDialog(context, ref),
                        icon: const Icon(LucideIcons.folderPlus),
                      ),
                      PlanPalButton(
                        label: l10n.documentUploadFile,
                        variant: PlanPalButtonVariant.outline,
                        toolbar: true,
                        icon: LucideIcons.upload,
                        onPressed: isOnline
                            ? () => _pickAndUpload(context, ref)
                            : null,
                      ),
                      const SizedBox(width: 8),
                      PlanPalButton(
                        label: l10n.btnNewDocument,
                        toolbar: true,
                        onPressed: () => _showNewDocDialog(context, ref),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (!isOnline)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        l10n.taskAttachmentOffline,
                        style: AppText.caption.copyWith(color: c.textMuted),
                      ),
                    ),
                  Expanded(
                    child: state.loading
                        ? const Center(child: CircularProgressIndicator())
                        : state.error != null &&
                              state.folders.isEmpty &&
                              state.recentDocs.isEmpty
                        ? ErrorState(message: state.error!)
                        : state.folders.isEmpty && state.recentDocs.isEmpty
                        ? EmptyState(
                            icon: LucideIcons.fileText,
                            title: l10n.emptyStateNoDocuments,
                            actionLabel: l10n.btnNewDocument,
                            onAction: () => _showNewDocDialog(context, ref),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Folders row
                                if (state.error != null)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Text(
                                      localizeFailureText(l10n, state.error!),
                                      style: AppText.caption.copyWith(
                                        color: c.warning,
                                      ),
                                    ),
                                  ),
                                if (state.folders.isNotEmpty) ...[
                                  _FoldersGrid(
                                    folders: state.folders,
                                    onOpen: (folder) => ref
                                        .read(documentsProvider.notifier)
                                        .openFolder(folder),
                                    onMenu: (folder) =>
                                        _showFolderMenu(context, ref, folder),
                                  ),
                                  const SizedBox(height: 32),
                                ],
                                // Recent Documents
                                if (state.recentDocs.isNotEmpty) ...[
                                  Text(
                                    l10n.documentsRecentTitle,
                                    style: AppText.sectionTitle.copyWith(
                                      color: c.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  if (state.gridView)
                                    _RecentDocsGrid(docs: state.recentDocs)
                                  else
                                    _RecentDocsList(docs: state.recentDocs),
                                ],
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
            if (_isDragging)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    color: c.primary.withValues(alpha: 0.12),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: c.surface,
                          borderRadius: BorderRadius.circular(AppRadius.panel),
                          border: Border.all(color: c.primary, width: 2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.upload, color: c.primary),
                            const SizedBox(width: 12),
                            Text(
                              l10n.documentDropHint,
                              style: AppText.bodyStrong.copyWith(
                                color: c.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showNewDocDialog(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.panel),
        ),
        title: Text(l10n.documentNewTitle),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(hintText: l10n.documentNewTitle),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).btnCancel),
          ),
          FilledButton(
            onPressed: () async {
              if (ctrl.text.trim().isEmpty) return;
              Navigator.pop(context);
              final (id, _) = await ref
                  .read(documentsProvider.notifier)
                  .createWrittenDocument(ctrl.text.trim());
              if (id != null && context.mounted) {
                context.push('/documents/$id');
              }
            },
            child: Text(l10n.btnCreate),
          ),
        ],
      ),
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _ToggleBtn({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.control - 2),
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: selected ? c.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.control - 2),
          boxShadow: selected ? AppShadows.card(Brightness.light) : null,
        ),
        child: Icon(
          icon,
          size: 16,
          color: selected ? c.textPrimary : c.textMuted,
        ),
      ),
    );
  }
}

class _FoldersGrid extends StatelessWidget {
  final List<FolderModel> folders;
  final ValueChanged<FolderModel> onOpen;
  final ValueChanged<FolderModel> onMenu;
  const _FoldersGrid({
    required this.folders,
    required this.onOpen,
    required this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 12,
        childAspectRatio: 5.5,
      ),
      itemCount: folders.length,
      itemBuilder: (_, i) {
        final f = folders[i];
        final colorIdx = i % 4;
        return InkWell(
          onTap: () => onOpen(f),
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: c.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _folderColors[colorIdx],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    LucideIcons.folder,
                    size: 20,
                    color: _folderIconColors[colorIdx],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        f.name,
                        style: AppText.bodyStrong.copyWith(
                          color: c.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${f.fileCount} files',
                        style: AppText.caption.copyWith(color: c.textMuted),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => onMenu(f),
                  icon: Icon(LucideIcons.moreHorizontal, color: c.textMuted),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RecentDocsGrid extends ConsumerWidget {
  final List<DocumentModel> docs;
  const _RecentDocsGrid({required this.docs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.8,
      ),
      itemCount: docs.length,
      itemBuilder: (_, i) {
        final doc = docs[i];
        return GestureDetector(
          onTap: () => _openDocument(context, ref, doc),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: c.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FileTypeBadge(extension: doc.extension),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _showDocMenu(context, ref, doc),
                      child: Icon(
                        LucideIcons.moreHorizontal,
                        size: 16,
                        color: c.textMuted,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  doc.title,
                  style: AppText.bodyStrong.copyWith(color: c.textPrimary),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                Text(
                  doc.relativeTime(),
                  style: AppText.caption.copyWith(color: c.textMuted),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDocMenu(BuildContext context, WidgetRef ref, DocumentModel doc) {
    _showDocumentMenu(context, ref, doc);
  }
}

Future<void> _pickAndUpload(BuildContext context, WidgetRef ref) async {
  final selection = await FilePicker.platform.pickFiles(type: FileType.any);
  if (selection == null || selection.files.isEmpty) return;
  final picked = selection.files.single;
  final path = picked.path;
  if (path == null) return;
  if (!context.mounted) return;
  await _showDocumentUploadDialog(
    context: context,
    ref: ref,
    file: File(path),
    fileName: picked.name,
  );
}

Future<void> _showDocumentUploadDialog({
  required BuildContext context,
  required WidgetRef ref,
  required File file,
  required String fileName,
}) => showDialog<void>(
  context: context,
  barrierDismissible: false,
  builder: (_) => _DocumentUploadDialog(
    fileName: fileName,
    upload: (cancelToken, onProgress) => ref
        .read(documentsProvider.notifier)
        .uploadFile(
          file,
          fileName,
          cancelToken: cancelToken,
          onProgress: onProgress,
        ),
  ),
);

class _DocumentUploadDialog extends ConsumerStatefulWidget {
  final String fileName;
  final Future<AppFailure?> Function(
    CancelToken cancelToken,
    void Function(int sent, int total) onProgress,
  )
  upload;

  const _DocumentUploadDialog({required this.fileName, required this.upload});

  @override
  ConsumerState<_DocumentUploadDialog> createState() =>
      _DocumentUploadDialogState();
}

class _DocumentUploadDialogState extends ConsumerState<_DocumentUploadDialog> {
  CancelToken? _cancelToken;
  AppFailure? _failure;
  double _progress = 0;
  bool _uploading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startUpload());
  }

  Future<void> _startUpload() async {
    final cancelToken = CancelToken();
    setState(() {
      _cancelToken = cancelToken;
      _failure = null;
      _progress = 0;
      _uploading = true;
    });

    final failure = await widget.upload(cancelToken, (sent, total) {
      if (!mounted || total <= 0) return;
      setState(() => _progress = (sent / total).clamp(0, 1));
    });

    if (!mounted) return;
    if (failure == null) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _failure = failure;
      _uploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.documentUploadFile),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.fileName),
          const SizedBox(height: 12),
          if (_uploading)
            LinearProgressIndicator(value: _progress == 0 ? null : _progress),
          if (_failure != null) ...[
            const SizedBox(height: 12),
            Text(_failure!.localizedMessage(context)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_uploading) {
              _cancelToken?.cancel();
            } else {
              Navigator.of(context).pop();
            }
          },
          child: Text(l10n.btnCancel),
        ),
        if (_failure != null)
          FilledButton(onPressed: _startUpload, child: Text(l10n.btnRetry)),
      ],
    );
  }
}

Future<void> _openDocument(
  BuildContext context,
  WidgetRef ref,
  DocumentModel document,
) async {
  if (document.isWritten) {
    context.push('/documents/${document.id}');
    return;
  }
  if (document.fileId == null) return;
  final (url, failure) = await ref
      .read(documentsRepositoryProvider)
      .getDownloadUrl(document.fileId!);
  if (!context.mounted) return;
  if (failure != null || url == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          failure?.localizedMessage(context) ??
              AppLocalizations.of(context).errorGeneric,
        ),
      ),
    );
    return;
  }
  if (document.mimeType?.startsWith('image/') == true) {
    await showDialog<void>(
      context: context,
      builder: (_) =>
          Dialog(child: InteractiveViewer(child: Image.network(url))),
    );
  } else {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}

void _showDocumentMenu(
  BuildContext context,
  WidgetRef ref,
  DocumentModel document,
) {
  final colors = context.colors;
  final l10n = AppLocalizations.of(context);
  showModalBottomSheet<void>(
    context: context,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(LucideIcons.externalLink),
            title: Text(l10n.btnOpen),
            onTap: () {
              Navigator.pop(sheetContext);
              _openDocument(context, ref, document);
            },
          ),
          ListTile(
            leading: const Icon(LucideIcons.fileEdit),
            title: Text(l10n.btnRename),
            onTap: () {
              Navigator.pop(sheetContext);
              _renameDocument(context, ref, document);
            },
          ),
          ListTile(
            leading: const Icon(LucideIcons.folderInput),
            title: Text(l10n.btnMove),
            onTap: () {
              Navigator.pop(sheetContext);
              _moveDocument(context, ref, document);
            },
          ),
          ListTile(
            leading: Icon(LucideIcons.trash2, color: colors.danger),
            title: Text(l10n.btnDelete, style: TextStyle(color: colors.danger)),
            onTap: () {
              Navigator.pop(sheetContext);
              ref.read(documentsProvider.notifier).deleteDocument(document.id);
            },
          ),
        ],
      ),
    ),
  );
}

void _showFolderMenu(BuildContext context, WidgetRef ref, FolderModel folder) {
  final colors = context.colors;
  final l10n = AppLocalizations.of(context);
  showModalBottomSheet<void>(
    context: context,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(LucideIcons.fileEdit),
            title: Text(l10n.btnRename),
            onTap: () {
              Navigator.pop(sheetContext);
              _renameFolder(context, ref, folder);
            },
          ),
          ListTile(
            leading: const Icon(LucideIcons.folderInput),
            title: Text(l10n.btnMove),
            onTap: () async {
              Navigator.pop(sheetContext);
              final state = ref.read(documentsProvider);
              final parentId = await _chooseFolder(
                context,
                state.folders.where((item) => item.id != folder.id).toList(),
                l10n,
              );
              if (parentId == _moveToRoot) {
                final (updated, failure) = await ref
                    .read(documentsRepositoryProvider)
                    .updateFolder(
                      folder.id,
                      name: folder.name,
                      moveToRoot: true,
                    );
                if (updated != null) {
                  await ref.read(documentsProvider.notifier).refresh();
                } else if (failure != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(failure.localizedMessage(context))),
                  );
                }
              } else if (parentId != null) {
                final (updated, failure) = await ref
                    .read(documentsRepositoryProvider)
                    .updateFolder(
                      folder.id,
                      name: folder.name,
                      parentId: parentId,
                    );
                if (updated != null) {
                  await ref.read(documentsProvider.notifier).refresh();
                } else if (failure != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(failure.localizedMessage(context))),
                  );
                }
              }
            },
          ),
          ListTile(
            leading: Icon(LucideIcons.trash2, color: colors.danger),
            title: Text(l10n.btnDelete, style: TextStyle(color: colors.danger)),
            onTap: () {
              Navigator.pop(sheetContext);
              ref.read(documentsProvider.notifier).deleteFolder(folder.id);
            },
          ),
        ],
      ),
    ),
  );
}

const _moveToRoot = '__root__';

Future<String?> _chooseFolder(
  BuildContext context,
  List<FolderModel> folders,
  AppLocalizations l10n,
) => showDialog<String>(
  context: context,
  builder: (dialogContext) => SimpleDialog(
    title: Text(l10n.btnMove),
    children: [
      SimpleDialogOption(
        onPressed: () => Navigator.pop(dialogContext, _moveToRoot),
        child: Text(l10n.documentsTitle),
      ),
      ...folders.map(
        (folder) => SimpleDialogOption(
          onPressed: () => Navigator.pop(dialogContext, folder.id),
          child: Text(folder.name),
        ),
      ),
    ],
  ),
);

Future<void> _moveDocument(
  BuildContext context,
  WidgetRef ref,
  DocumentModel document,
) async {
  final state = ref.read(documentsProvider);
  final folderId = await _chooseFolder(
    context,
    state.folders,
    AppLocalizations.of(context),
  );
  if (folderId == null) return;
  await ref
      .read(documentsProvider.notifier)
      .moveDocument(
        document,
        folderId: folderId == _moveToRoot ? null : folderId,
        moveToRoot: folderId == _moveToRoot,
      );
}

Future<void> _renameDocument(
  BuildContext context,
  WidgetRef ref,
  DocumentModel document,
) async {
  final controller = TextEditingController(text: document.title);
  final title = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(AppLocalizations.of(context).btnRename),
      content: TextField(controller: controller, autofocus: true),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(AppLocalizations.of(context).btnCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
          child: Text(AppLocalizations.of(context).btnSave),
        ),
      ],
    ),
  );
  controller.dispose();
  if (title != null && title.isNotEmpty) {
    await ref
        .read(documentsProvider.notifier)
        .renameDocument(document.id, title);
  }
}

Future<void> _renameFolder(
  BuildContext context,
  WidgetRef ref,
  FolderModel folder,
) async {
  final controller = TextEditingController(text: folder.name);
  final name = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(AppLocalizations.of(context).documentNewFolderTitle),
      content: TextField(controller: controller, autofocus: true),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(AppLocalizations.of(context).btnCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
          child: Text(AppLocalizations.of(context).btnSave),
        ),
      ],
    ),
  );
  controller.dispose();
  if (name != null && name.isNotEmpty) {
    await ref.read(documentsProvider.notifier).renameFolder(folder, name);
  }
}

Future<void> _showNewFolderDialog(BuildContext context, WidgetRef ref) async {
  final controller = TextEditingController();
  final name = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(AppLocalizations.of(context).documentNewFolderTitle),
      content: TextField(controller: controller, autofocus: true),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(AppLocalizations.of(context).btnCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
          child: Text(AppLocalizations.of(context).btnCreate),
        ),
      ],
    ),
  );
  controller.dispose();
  if (name != null && name.isNotEmpty) {
    await ref.read(documentsProvider.notifier).createFolder(name);
  }
}

class _RecentDocsList extends ConsumerWidget {
  final List<DocumentModel> docs;
  const _RecentDocsList({required this.docs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    return Column(
      children: docs
          .map(
            (document) => ListTile(
              leading: FileTypeBadge(extension: document.extension),
              title: Text(document.title),
              subtitle: Text(document.relativeTime()),
              trailing: Icon(LucideIcons.chevronRight, color: colors.textMuted),
              onTap: () => _openDocument(context, ref, document),
            ),
          )
          .toList(),
    );
  }
}

// ── MOBILE ────────────────────────────────────────────────────────────────────
class _MobileDocuments extends ConsumerWidget {
  const _MobileDocuments();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final state = ref.watch(documentsProvider);
    final l10n = AppLocalizations.of(context);
    final isOnline = ref.watch(isOnlineProvider);

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(documentsProvider.notifier).refresh(),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      if (state.folderPath.isNotEmpty)
                        IconButton(
                          onPressed: () =>
                              ref.read(documentsProvider.notifier).goUpFolder(),
                          icon: const Icon(LucideIcons.arrowLeft),
                        ),
                      Text(
                        l10n.documentsTitle,
                        style: AppText.pageTitleMobile.copyWith(
                          color: c.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () =>
                            _showMobileMenu(context, ref, isOnline: isOnline),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: c.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Search (fix F7)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: c.surfaceAlt,
                      borderRadius: BorderRadius.circular(AppRadius.control),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Icon(LucideIcons.search, size: 16, color: c.textMuted),
                        const SizedBox(width: 8),
                        Text(
                          'Search files...',
                          style: AppText.body.copyWith(color: c.textMuted),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (state.loading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else ...[
                // Folders grid (2 per row)
                if (state.folders.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 3.2,
                          ),
                      delegate: SliverChildBuilderDelegate((_, i) {
                        final f = state.folders[i];
                        final colorIdx = i % 4;
                        return InkWell(
                          onTap: () => ref
                              .read(documentsProvider.notifier)
                              .openFolder(f),
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: c.surface,
                              borderRadius: BorderRadius.circular(
                                AppRadius.card,
                              ),
                              border: Border.all(color: c.border),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.folder,
                                  size: 20,
                                  color: _folderIconColors[colorIdx],
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        f.name,
                                        style: AppText.bodyStrong.copyWith(
                                          color: c.textPrimary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${f.fileCount} files',
                                        style: AppText.caption.copyWith(
                                          color: c.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      _showFolderMenu(context, ref, f),
                                  icon: Icon(
                                    LucideIcons.moreHorizontal,
                                    color: c.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }, childCount: state.folders.length),
                    ),
                  ),
                if (state.error != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        localizeFailureText(l10n, state.error!),
                        style: AppText.caption.copyWith(color: c.warning),
                      ),
                    ),
                  ),
                // Recent section
                if (state.recentDocs.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                      child: Text(
                        'Recent',
                        style: AppText.sectionTitle.copyWith(
                          color: c.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((_, i) {
                        final doc = state.recentDocs[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _MobileDocRow(doc: doc, ref: ref),
                        );
                      }, childCount: state.recentDocs.length),
                    ),
                  ),
                ],
                if (state.folders.isEmpty && state.recentDocs.isEmpty)
                  SliverFillRemaining(
                    child: state.error != null
                        ? ErrorState(message: state.error!)
                        : EmptyState(
                            icon: LucideIcons.fileText,
                            title: l10n.emptyStateNoDocuments,
                            actionLabel: l10n.btnNewDocument,
                            onAction: () => _showNewDocDialog(context, ref),
                          ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showMobileMenu(
    BuildContext context,
    WidgetRef ref, {
    required bool isOnline,
  }) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(LucideIcons.filePlus),
              title: Text(l10n.btnNewDocument),
              onTap: () {
                Navigator.pop(context);
                _showNewDocDialog(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.upload),
              title: Text(l10n.documentUploadFile),
              subtitle: isOnline ? null : Text(l10n.taskAttachmentOffline),
              onTap: isOnline
                  ? () {
                      Navigator.pop(context);
                      _pickAndUpload(context, ref);
                    }
                  : null,
            ),
            ListTile(
              leading: const Icon(LucideIcons.folderPlus),
              title: Text(l10n.documentNewFolder),
              onTap: () {
                Navigator.pop(context);
                _showNewFolderDialog(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNewDocDialog(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.documentNewTitle),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(hintText: l10n.documentNewTitle),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.btnCancel),
          ),
          FilledButton(
            onPressed: () async {
              if (ctrl.text.trim().isEmpty) return;
              Navigator.pop(context);
              final (id, _) = await ref
                  .read(documentsProvider.notifier)
                  .createWrittenDocument(ctrl.text.trim());
              if (id != null && context.mounted) {
                context.push('/documents/$id');
              }
            },
            child: Text(l10n.btnCreate),
          ),
        ],
      ),
    );
  }
}

class _MobileDocRow extends StatelessWidget {
  final DocumentModel doc;
  final WidgetRef ref;
  const _MobileDocRow({required this.doc, required this.ref});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: () => _openDocument(context, ref, doc),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: c.border),
        ),
        child: Row(
          children: [
            FileTypeBadge(extension: doc.extension),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                doc.title,
                style: AppText.bodyMedium.copyWith(color: c.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              onPressed: () => _showDocumentMenu(context, ref, doc),
              icon: Icon(LucideIcons.moreHorizontal, color: c.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Document Editor ───────────────────────────────────────────────────────────
class DocumentEditorScreen extends ConsumerWidget {
  final String documentId;
  const DocumentEditorScreen({super.key, required this.documentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docAsync = ref.watch(documentDetailProvider(documentId));

    return docAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        body: ErrorState(
          message: e is AppFailure
              ? e.localizedMessage(context)
              : AppLocalizations.of(context).errorGeneric,
        ),
      ),
      data: (doc) {
        if (doc == null) {
          return const Scaffold(
            body: EmptyState(
              icon: LucideIcons.fileX,
              title: 'Document not found',
            ),
          );
        }
        return _QuillEditorContent(doc: doc, widgetRef: ref);
      },
    );
  }
}

// ── Document Editor with flutter_quill ───────────────────────────────────────
class _QuillEditorContent extends StatefulWidget {
  final DocumentModel doc;
  final WidgetRef widgetRef;
  const _QuillEditorContent({required this.doc, required this.widgetRef});
  @override
  State<_QuillEditorContent> createState() => _QuillEditorContentState();
}

class _QuillEditorContentState extends State<_QuillEditorContent> {
  late TextEditingController _titleCtrl;
  late quill.QuillController _quillCtrl;
  bool _saving = false;
  Timer? _saveTimer;
  String _saveStatus = '';
  final _focusNode = FocusNode();
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.doc.title);
    final content = widget.doc.content;
    if (content != null && content['ops'] != null) {
      try {
        _quillCtrl = quill.QuillController(
          document: quill.Document.fromJson(content['ops'] as List),
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (_) {
        _quillCtrl = quill.QuillController.basic();
      }
    } else {
      _quillCtrl = quill.QuillController.basic();
    }
    _quillCtrl.document.changes.listen((_) {
      if (mounted) {
        setState(() {
          _saveStatus = AppLocalizations.of(context).documentWaitingToSync;
        });
        _saveTimer?.cancel();
        _saveTimer = Timer(const Duration(seconds: 2), _save);
      }
    });
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    _titleCtrl.dispose();
    _quillCtrl.dispose();
    _focusNode.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    _saveTimer?.cancel();
    setState(() {
      _saving = true;
      _saveStatus = AppLocalizations.of(context).documentSaving;
    });
    final deltaJson = _quillCtrl.document.toDelta().toJson();
    final plainText = _quillCtrl.document.toPlainText();
    final failure = await widget.widgetRef
        .read(documentsRepositoryProvider)
        .updateDocument(
          widget.doc.id,
          title: _titleCtrl.text.trim(),
          content: {'ops': deltaJson},
          contentText: plainText,
        );
    if (mounted) {
      final l10n = AppLocalizations.of(context);
      setState(() {
        _saving = false;
        _saveStatus = failure != null
            ? failure.localizedMessage(context)
            : widget.widgetRef.read(isOnlineProvider)
            ? l10n.documentSaved
            : l10n.documentSavedLocally;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final doc = widget.doc;
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header (fix F11 — no Share)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              color: c.surface,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: c.surface,
                        borderRadius: BorderRadius.circular(AppRadius.control),
                        border: Border.all(color: c.border),
                      ),
                      child: Icon(
                        LucideIcons.arrowLeft,
                        size: 18,
                        color: c.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Documents / ${doc.title}',
                      style: AppText.body.copyWith(color: c.textMuted),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _saveStatus,
                    style: AppText.caption.copyWith(
                      color:
                          _saveStatus == l10n.documentSaved ||
                              _saveStatus == l10n.documentSavedLocally
                          ? c.success
                          : c.textMuted,
                    ),
                  ),
                  const SizedBox(width: 8),
                  PlanPalButton(
                    label: l10n.documentEditorSave,
                    toolbar: true,
                    loading: _saving,
                    onPressed: _save,
                  ),
                ],
              ),
            ),
            // Quill toolbar
            Container(
              decoration: BoxDecoration(
                color: c.surface,
                border: Border(
                  bottom: BorderSide(color: c.border),
                  top: BorderSide(color: c.border),
                ),
              ),
              child: quill.QuillSimpleToolbar(
                controller: _quillCtrl,
                config: const quill.QuillSimpleToolbarConfig(
                  showFontFamily: false,
                  showFontSize: false,
                  showBackgroundColorButton: false,
                  showColorButton: false,
                  showAlignmentButtons: false,
                  showIndent: false,
                  showSubscript: false,
                  showSuperscript: false,
                  showSearchButton: false,
                  showInlineCode: false,
                  showCodeBlock: false,
                  showSmallButton: false,
                ),
              ),
            ),
            // Editor
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollCtrl,
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _titleCtrl,
                          style: AppText.pageTitle.copyWith(
                            color: c.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Untitled',
                            hintStyle: AppText.pageTitle.copyWith(
                              color: c.textMuted,
                            ),
                            border: InputBorder.none,
                            filled: false,
                          ),
                          onChanged: (_) {
                            setState(
                              () => _saveStatus = l10n.documentWaitingToSync,
                            );
                            _saveTimer?.cancel();
                            _saveTimer = Timer(
                              const Duration(seconds: 2),
                              _save,
                            );
                          },
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${doc.relativeTime()} · ${doc.createdByName ?? ''}',
                          style: AppText.caption.copyWith(color: c.textMuted),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          constraints: const BoxConstraints(minHeight: 300),
                          decoration: BoxDecoration(
                            color: c.surface,
                            borderRadius: BorderRadius.circular(AppRadius.card),
                            border: Border.all(color: c.border),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: quill.QuillEditor(
                            controller: _quillCtrl,
                            focusNode: _focusNode,
                            scrollController: _scrollCtrl,
                            config: quill.QuillEditorConfig(
                              placeholder: l10n.documentEditorStartWriting,
                              scrollable: false,
                              autoFocus: false,
                              expands: false,
                              padding: EdgeInsets.zero,
                            ),
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
    );
  }
}

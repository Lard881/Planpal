// app/lib/features/documents/presentation/documents_screen.dart
import 'dart:io';
import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pdfrx/pdfrx.dart';
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
  final DocumentModel? initialDocument;
  const DocumentsScreen({super.key, this.documentId, this.initialDocument});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (documentId != null) {
      return DocumentEditorScreen(
        documentId: documentId!,
        initialDocument: initialDocument,
      );
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
    final wsName = ref.watch(currentWorkspaceProvider)?.name;
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
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              if (wsName != null) ...[
                                Text(
                                  wsName,
                                  style: AppText.caption.copyWith(
                                    color: c.textMuted,
                                  ),
                                ),
                                const Text(' / '),
                              ],
                              TextButton(
                                onPressed: state.folderPath.isEmpty
                                    ? null
                                    : () => ref
                                          .read(documentsProvider.notifier)
                                          .goToFolderPath(0),
                                child: Text(l10n.documentsTitle),
                              ),
                              for (
                                var index = 0;
                                index < state.folderPath.length;
                                index++
                              ) ...[
                                Text(
                                  ' / ',
                                  style: TextStyle(color: c.textMuted),
                                ),
                                TextButton(
                                  onPressed:
                                      index == state.folderPath.length - 1
                                      ? null
                                      : () => ref
                                            .read(documentsProvider.notifier)
                                            .goToFolderPath(index + 1),
                                  child: Text(state.folderPath[index].name),
                                ),
                              ],
                            ],
                          ),
                        ),
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
                              tooltip: l10n.documentsGridView,
                              selected: state.gridView,
                              onTap: () => ref
                                  .read(documentsProvider.notifier)
                                  .setGridView(true),
                            ),
                            _ToggleBtn(
                              icon: LucideIcons.list,
                              tooltip: l10n.documentsListView,
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
                    child:
                        state.loading &&
                            state.folders.isEmpty &&
                            state.recentDocs.isEmpty
                        ? const ContentLoadingSkeleton(
                            kind: LoadingSkeletonKind.cards,
                            padding: EdgeInsets.zero,
                          )
                        : state.error != null &&
                              state.folders.isEmpty &&
                              state.recentDocs.isEmpty
                        ? ErrorState(
                            message: state.error!,
                            retryLabel: l10n.btnRetry,
                            onRetry: () =>
                                ref.read(documentsProvider.notifier).refresh(),
                          )
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
                                  state.gridView
                                      ? _FoldersGrid(
                                          folders: state.folders,
                                          onOpen: (folder) => ref
                                              .read(documentsProvider.notifier)
                                              .openFolder(folder),
                                          onMenu: (folder) => _showFolderMenu(
                                            context,
                                            ref,
                                            folder,
                                          ),
                                        )
                                      : _FoldersList(
                                          folders: state.folders,
                                          onOpen: (folder) => ref
                                              .read(documentsProvider.notifier)
                                              .openFolder(folder),
                                          onMenu: (folder) => _showFolderMenu(
                                            context,
                                            ref,
                                            folder,
                                          ),
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
      builder: (dialogContext) => AlertDialog(
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
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.btnCancel),
          ),
          FilledButton(
            onPressed: () async {
              final title = ctrl.text.trim();
              if (title.isEmpty) return;
              Navigator.pop(dialogContext);
              final (document, failure) = await ref
                  .read(documentsProvider.notifier)
                  .createWrittenDocument(title);
              if (document != null && context.mounted) {
                context.push('/documents/${document.id}', extra: document);
              } else if (failure != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localizeFailureText(l10n, failure))),
                );
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
  final String tooltip;
  final bool selected;
  final VoidCallback onTap;
  const _ToggleBtn({
    required this.icon,
    required this.tooltip,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Tooltip(
      message: tooltip,
      child: InkWell(
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
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 350,
        crossAxisSpacing: 16,
        mainAxisSpacing: 12,
        mainAxisExtent: 98,
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
                        AppLocalizations.of(
                          context,
                        ).documentsFolderFileCount(f.fileCount),
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

class _FoldersList extends StatelessWidget {
  final List<FolderModel> folders;
  final ValueChanged<FolderModel> onOpen;
  final ValueChanged<FolderModel> onMenu;

  const _FoldersList({
    required this.folders,
    required this.onOpen,
    required this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        for (final folder in folders)
          ListTile(
            leading: Icon(LucideIcons.folder, color: colors.primary),
            title: Text(
              folder.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(l10n.documentsFolderFileCount(folder.fileCount)),
            trailing: IconButton(
              tooltip: l10n.btnDetails,
              onPressed: () => onMenu(folder),
              icon: Icon(LucideIcons.moreHorizontal, color: colors.textMuted),
            ),
            onTap: () => onOpen(folder),
          ),
      ],
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
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 350,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.8,
      ),
      itemCount: docs.length,
      itemBuilder: (_, i) {
        final doc = docs[i];
        return GestureDetector(
          onTap: () => _openDocument(context, doc),
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
                if (doc.sizeLabel.isNotEmpty)
                  Text(
                    doc.sizeLabel,
                    style: AppText.caption.copyWith(color: c.textMuted),
                  )
                else
                  Text(
                    DateFormat.yMMMd(
                      Localizations.localeOf(context).toString(),
                    ).format(doc.updatedAt),
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

void _openDocument(BuildContext context, DocumentModel document) {
  context.push('/documents/${document.id}', extra: document);
}

Future<bool> _confirmDocumentDeletion(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  return await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l10n.confirmDeleteTitle),
          content: Text(l10n.confirmDeleteBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.btnCancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.btnDelete),
            ),
          ],
        ),
      ) ??
      false;
}

Future<void> _downloadDocument(
  BuildContext context,
  WidgetRef ref,
  DocumentModel document,
) async {
  final l10n = AppLocalizations.of(context);
  if (!ref.read(isOnlineProvider)) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.taskAttachmentOffline)));
    return;
  }
  if (document.fileId == null) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
    return;
  }

  final (url, urlFailure) = await ref
      .read(documentsRepositoryProvider)
      .getDownloadUrl(document.fileId!);
  if (!context.mounted) return;
  if (urlFailure != null || url == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          urlFailure?.localizedMessage(context) ?? l10n.errorGeneric,
        ),
      ),
    );
    return;
  }

  String? path;
  try {
    path = await FilePicker.platform.saveFile(
      dialogTitle: l10n.btnDownload,
      fileName: document.title,
    );
  } on PlatformException {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
    return;
  }
  if (path == null || path.isEmpty || !context.mounted) return;

  final failure = await ref
      .read(documentsRepositoryProvider)
      .downloadFile(url, path);
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        failure?.localizedMessage(context) ?? l10n.documentDownloadComplete,
      ),
    ),
  );
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
              _openDocument(context, document);
            },
          ),
          if (document.isFile)
            ListTile(
              leading: const Icon(LucideIcons.download),
              title: Text(l10n.btnDownload),
              onTap: () {
                Navigator.pop(sheetContext);
                _downloadDocument(context, ref, document);
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
            onTap: () async {
              Navigator.pop(sheetContext);
              if (!await _confirmDocumentDeletion(context) ||
                  !context.mounted) {
                return;
              }
              final failure = await ref
                  .read(documentsProvider.notifier)
                  .deleteDocument(document.id);
              if (failure != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(failure.localizedMessage(context))),
                );
              }
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
              final parentId = await _chooseFolder(
                context,
                ref.read(documentsRepositoryProvider),
                ref.read(documentsProvider.notifier).workspaceId,
                l10n,
                excludedFolderId: folder.id,
              );
              if (parentId == null || !context.mounted) return;
              final (updated, failure) = await ref
                  .read(documentsRepositoryProvider)
                  .updateFolder(
                    folder.id,
                    name: folder.name,
                    parentId: parentId == _moveToRoot ? null : parentId,
                    moveToRoot: parentId == _moveToRoot,
                  );
              if (updated != null) {
                await ref.read(documentsProvider.notifier).refresh();
              } else if (failure != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(failure.localizedMessage(context))),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(LucideIcons.trash2, color: colors.danger),
            title: Text(l10n.btnDelete, style: TextStyle(color: colors.danger)),
            onTap: () async {
              Navigator.pop(sheetContext);
              if (!await _confirmDocumentDeletion(context) ||
                  !context.mounted) {
                return;
              }
              final failure = await ref
                  .read(documentsProvider.notifier)
                  .deleteFolder(folder.id);
              if (failure != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(failure.localizedMessage(context))),
                );
              }
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
  DocumentsRepository repository,
  String workspaceId,
  AppLocalizations l10n, {
  String? excludedFolderId,
}) => showDialog<String>(
  context: context,
  builder: (_) => _FolderDestinationDialog(
    repository: repository,
    workspaceId: workspaceId,
    title: l10n.btnMove,
    excludedFolderId: excludedFolderId,
  ),
);

Future<void> _moveDocument(
  BuildContext context,
  WidgetRef ref,
  DocumentModel document,
) async {
  final folderId = await _chooseFolder(
    context,
    ref.read(documentsRepositoryProvider),
    ref.read(documentsProvider.notifier).workspaceId,
    AppLocalizations.of(context),
  );
  if (folderId == null || !context.mounted) return;
  final failure = await ref
      .read(documentsProvider.notifier)
      .moveDocument(
        document,
        folderId: folderId == _moveToRoot ? null : folderId,
        moveToRoot: folderId == _moveToRoot,
      );
  if (failure != null && context.mounted) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(failure.localizedMessage(context))));
  }
}

class _FolderDestinationDialog extends StatefulWidget {
  final DocumentsRepository repository;
  final String workspaceId;
  final String title;
  final String? excludedFolderId;

  const _FolderDestinationDialog({
    required this.repository,
    required this.workspaceId,
    required this.title,
    this.excludedFolderId,
  });

  @override
  State<_FolderDestinationDialog> createState() =>
      _FolderDestinationDialogState();
}

class _FolderDestinationDialogState extends State<_FolderDestinationDialog> {
  List<FolderModel> _path = [];
  List<FolderModel> _folders = [];
  AppFailure? _failure;
  bool _loading = true;

  String? get _parentId => _path.isEmpty ? null : _path.last.id;

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  Future<void> _loadFolders() async {
    setState(() {
      _loading = true;
      _failure = null;
    });
    final (folders, failure) = await widget.repository.getFolders(
      widget.workspaceId,
      parentId: _parentId,
    );
    if (!mounted) return;
    setState(() {
      _folders = folders
          .where((folder) => folder.id != widget.excludedFolderId)
          .toList();
      _failure = failure;
      _loading = false;
    });
  }

  Future<void> _openFolder(FolderModel folder) async {
    setState(() => _path = [..._path, folder]);
    await _loadFolders();
  }

  Future<void> _goUp() async {
    if (_path.isEmpty) return;
    setState(() => _path = _path.sublist(0, _path.length - 1));
    await _loadFolders();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Row(
        children: [
          if (_path.isNotEmpty)
            IconButton(
              tooltip: l10n.btnCancel,
              onPressed: _loading ? null : _goUp,
              icon: const Icon(LucideIcons.arrowLeft),
            ),
          Expanded(
            child: Text(
              _path.isEmpty ? widget.title : _path.last.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 420,
        height: 360,
        child: _loading
            ? const ContentLoadingSkeleton(
                kind: LoadingSkeletonKind.rows,
                padding: EdgeInsets.zero,
              )
            : Column(
                children: [
                  if (_failure != null)
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _failure!.localizedMessage(context),
                            style: AppText.caption.copyWith(
                              color: colors.warning,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _loadFolders,
                          child: Text(l10n.btnRetry),
                        ),
                      ],
                    ),
                  Expanded(
                    child: ListView(
                      children: [
                        if (_path.isEmpty)
                          ListTile(
                            leading: Icon(
                              LucideIcons.folder,
                              color: colors.primary,
                            ),
                            title: Text(l10n.documentsTitle),
                            trailing: IconButton(
                              tooltip: l10n.btnMove,
                              onPressed: () =>
                                  Navigator.pop(context, _moveToRoot),
                              icon: const Icon(LucideIcons.check),
                            ),
                            onTap: () => Navigator.pop(context, _moveToRoot),
                          ),
                        if (_path.isNotEmpty)
                          ListTile(
                            leading: Icon(
                              LucideIcons.folder,
                              color: colors.primary,
                            ),
                            title: Text(_path.last.name),
                            trailing: IconButton(
                              tooltip: l10n.btnMove,
                              onPressed: () =>
                                  Navigator.pop(context, _path.last.id),
                              icon: const Icon(LucideIcons.check),
                            ),
                            onTap: () => Navigator.pop(context, _path.last.id),
                          ),
                        for (final folder in _folders)
                          ListTile(
                            leading: Icon(
                              LucideIcons.folder,
                              color: colors.primary,
                            ),
                            title: Text(
                              folder.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              tooltip: l10n.btnMove,
                              onPressed: () =>
                                  Navigator.pop(context, folder.id),
                              icon: const Icon(LucideIcons.check),
                            ),
                            onTap: () => _openFolder(folder),
                          ),
                        if (_folders.isEmpty && _path.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              l10n.emptyStateNoDocuments,
                              style: AppText.body.copyWith(
                                color: colors.textMuted,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.btnCancel),
        ),
      ],
    );
  }
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
    final failure = await ref
        .read(documentsProvider.notifier)
        .renameDocument(document.id, title);
    if (failure != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failure.localizedMessage(context))),
      );
    }
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
    final failure = await ref
        .read(documentsProvider.notifier)
        .renameFolder(folder, name);
    if (failure != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failure.localizedMessage(context))),
      );
    }
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
    final failure = await ref
        .read(documentsProvider.notifier)
        .createFolder(name);
    if (failure != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failure.localizedMessage(context))),
      );
    }
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
              subtitle: Text(
                document.sizeLabel.isNotEmpty
                    ? document.sizeLabel
                    : DateFormat.yMMMd(
                        Localizations.localeOf(context).toString(),
                      ).format(document.updatedAt),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: AppLocalizations.of(context).btnDetails,
                    onPressed: () => _showDocumentMenu(context, ref, document),
                    icon: Icon(
                      LucideIcons.moreHorizontal,
                      color: colors.textMuted,
                    ),
                  ),
                  Icon(LucideIcons.chevronRight, color: colors.textMuted),
                ],
              ),
              onTap: () => _openDocument(context, document),
            ),
          )
          .toList(),
    );
  }
}

// ── MOBILE ────────────────────────────────────────────────────────────────────
class _MobileDocuments extends ConsumerStatefulWidget {
  const _MobileDocuments();

  @override
  ConsumerState<_MobileDocuments> createState() => _MobileDocumentsState();
}

class _MobileDocumentsState extends ConsumerState<_MobileDocuments> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final state = ref.watch(documentsProvider);
    final l10n = AppLocalizations.of(context);
    final isOnline = ref.watch(isOnlineProvider);
    final normalizedQuery = _query.trim().toLowerCase();
    final visibleFolders = state.folders
        .where((folder) => folder.name.toLowerCase().contains(normalizedQuery))
        .toList();
    final visibleDocuments = state.recentDocs
        .where(
          (document) => document.title.toLowerCase().contains(normalizedQuery),
        )
        .toList();

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
                      Expanded(
                        child: Text(
                          state.folderPath.isEmpty
                              ? l10n.documentsTitle
                              : state.folderPath.last.name,
                          style: AppText.pageTitleMobile.copyWith(
                            color: c.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        tooltip: l10n.documentNewTitle,
                        onPressed: () =>
                            _showMobileMenu(context, ref, isOnline: isOnline),
                        icon: const Icon(Icons.add),
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
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                    decoration: InputDecoration(
                      hintText: l10n.searchFiles,
                      prefixIcon: Icon(
                        LucideIcons.search,
                        size: 18,
                        color: c.textMuted,
                      ),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              tooltip: l10n.btnCancel,
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _query = '');
                              },
                              icon: const Icon(LucideIcons.x),
                            ),
                    ),
                  ),
                ),
              ),
              if (!isOnline)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Text(
                      l10n.taskAttachmentOffline,
                      style: AppText.caption.copyWith(color: c.textMuted),
                    ),
                  ),
                ),
              if (state.loading &&
                  state.folders.isEmpty &&
                  state.recentDocs.isEmpty)
                const SliverFillRemaining(
                  child: ContentLoadingSkeleton(
                    kind: LoadingSkeletonKind.cards,
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 24),
                  ),
                )
              else ...[
                // Folders grid (2 per row)
                if (visibleFolders.isNotEmpty)
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
                        final f = visibleFolders[i];
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
                                        l10n.documentsFolderFileCount(
                                          f.fileCount,
                                        ),
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
                      }, childCount: visibleFolders.length),
                    ),
                  ),
                if (state.error != null &&
                    state.folders.isEmpty &&
                    state.recentDocs.isEmpty)
                  SliverFillRemaining(
                    child: ErrorState(
                      message: localizeFailureText(l10n, state.error!),
                      retryLabel: l10n.btnRetry,
                      onRetry: () =>
                          ref.read(documentsProvider.notifier).refresh(),
                    ),
                  )
                else if (state.error != null)
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
                if (visibleDocuments.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                      child: Text(
                        l10n.documentsRecent,
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
                        final doc = visibleDocuments[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _MobileDocRow(doc: doc, ref: ref),
                        );
                      }, childCount: visibleDocuments.length),
                    ),
                  ),
                ],
                if (visibleFolders.isEmpty &&
                    visibleDocuments.isEmpty &&
                    state.error == null &&
                    !state.loading)
                  SliverFillRemaining(
                    child: EmptyState(
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
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.documentNewTitle),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(hintText: l10n.documentNewTitle),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.btnCancel),
          ),
          FilledButton(
            onPressed: () async {
              final title = ctrl.text.trim();
              if (title.isEmpty) return;
              Navigator.pop(dialogContext);
              final (document, failure) = await ref
                  .read(documentsProvider.notifier)
                  .createWrittenDocument(title);
              if (document != null && context.mounted) {
                context.push('/documents/${document.id}', extra: document);
              } else if (failure != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localizeFailureText(l10n, failure))),
                );
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
      onTap: () => _openDocument(context, doc),
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
  final DocumentModel? initialDocument;
  const DocumentEditorScreen({
    super.key,
    required this.documentId,
    this.initialDocument,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (initialDocument?.id == documentId) {
      return _QuillEditorContent(doc: initialDocument!, widgetRef: ref);
    }
    final docAsync = ref.watch(documentDetailProvider(documentId));

    return docAsync.when(
      loading: () => const Scaffold(
        body: ContentLoadingSkeleton(
          kind: LoadingSkeletonKind.detail,
          padding: EdgeInsets.all(24),
        ),
      ),
      error: (e, _) => Scaffold(
        body: ErrorState(
          message: e is AppFailure
              ? e.localizedMessage(context)
              : AppLocalizations.of(context).errorGeneric,
        ),
      ),
      data: (doc) {
        if (doc == null) {
          return Scaffold(
            body: EmptyState(
              icon: LucideIcons.fileX,
              title: AppLocalizations.of(context).errorNotFound,
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
  bool _dirty = false;
  int _changeVersion = 0;
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
          _dirty = true;
          _changeVersion++;
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
    if (!_dirty || _saving) return;
    _saveTimer?.cancel();
    final savedVersion = _changeVersion;
    final title = _titleCtrl.text.trim();
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
          title: title,
          content: {'ops': deltaJson},
          contentText: plainText,
        );
    if (mounted) {
      final l10n = AppLocalizations.of(context);
      setState(() {
        _saving = false;
        if (failure == null && savedVersion == _changeVersion) {
          _dirty = false;
        }
        _saveStatus = failure != null
            ? failure.localizedMessage(context)
            : l10n.documentSavedLocally;
      });
      if (failure == null && _dirty) _scheduleSave();
    }
  }

  @override
  Widget build(BuildContext context) {
    final doc = widget.doc;
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final isWritten = doc.isWritten;
    final editorTitle = isWritten ? _titleCtrl.text : doc.title;
    final navigator = Navigator.of(context);
    return PopScope(
      canPop: !_dirty && !_saving,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _save();
        if (!mounted || _dirty || _saving) return;
        await WidgetsBinding.instance.endOfFrame;
        if (mounted && navigator.mounted && !_dirty && !_saving) {
          navigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: c.background,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: l10n.btnCancel,
                      onPressed: () => context.pop(),
                      icon: Icon(LucideIcons.arrowLeft, color: c.textMuted),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${l10n.documentsTitle} / $editorTitle',
                        style: AppText.body.copyWith(color: c.textMuted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isWritten && _saveStatus.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          _saveStatus,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.caption.copyWith(
                            color: _saveStatus == l10n.documentSavedLocally
                                ? c.success
                                : c.textMuted,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(width: 12),
                    if (isWritten)
                      PlanPalButton(
                        label: l10n.documentEditorSave,
                        toolbar: true,
                        loading: _saving,
                        onPressed: _save,
                      )
                    else
                      OutlinedButton.icon(
                        onPressed: () =>
                            _downloadDocument(context, widget.widgetRef, doc),
                        icon: const Icon(LucideIcons.download, size: 16),
                        label: Text(l10n.btnDownload),
                      ),
                  ],
                ),
              ),
              if (isWritten)
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 940),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(24, 8, 24, 4),
                      decoration: BoxDecoration(
                        color: c.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: c.border),
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
                          showUndo: false,
                          showRedo: false,
                        ),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 940),
                      child: isWritten
                          ? Container(
                              constraints: const BoxConstraints(minHeight: 430),
                              decoration: BoxDecoration(
                                color: c.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: c.border),
                                boxShadow:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? const []
                                    : [
                                        BoxShadow(
                                          color: c.textPrimary.withValues(
                                            alpha: 0.06,
                                          ),
                                          blurRadius: 24,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                              ),
                              padding: const EdgeInsets.fromLTRB(
                                32,
                                28,
                                32,
                                32,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextField(
                                    controller: _titleCtrl,
                                    style: AppText.pageTitle.copyWith(
                                      color: c.textPrimary,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: l10n.documentNewTitle,
                                      hintStyle: AppText.pageTitle.copyWith(
                                        color: c.textMuted,
                                      ),
                                      border: InputBorder.none,
                                      filled: false,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    onChanged: (_) {
                                      setState(() {
                                        _dirty = true;
                                        _changeVersion++;
                                        _saveStatus =
                                            l10n.documentWaitingToSync;
                                      });
                                      _scheduleSave();
                                    },
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    [
                                      DateFormat.yMMMd(
                                        Localizations.localeOf(
                                          context,
                                        ).toString(),
                                      ).format(doc.updatedAt),
                                      if (doc.createdByName?.isNotEmpty == true)
                                        doc.createdByName!,
                                    ].join(' · '),
                                    style: AppText.caption.copyWith(
                                      color: c.textMuted,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  quill.QuillEditor(
                                    controller: _quillCtrl,
                                    focusNode: _focusNode,
                                    scrollController: _scrollCtrl,
                                    config: quill.QuillEditorConfig(
                                      placeholder:
                                          l10n.documentEditorStartWriting,
                                      scrollable: false,
                                      autoFocus: false,
                                      expands: false,
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : _UploadedFilePreview(
                              document: doc,
                              widgetRef: widget.widgetRef,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 2), _save);
  }
}

class _UploadedFilePreview extends ConsumerStatefulWidget {
  final DocumentModel document;
  final WidgetRef widgetRef;

  const _UploadedFilePreview({required this.document, required this.widgetRef});

  @override
  ConsumerState<_UploadedFilePreview> createState() =>
      _UploadedFilePreviewState();
}

class _UploadedFilePreviewState extends ConsumerState<_UploadedFilePreview> {
  String? _downloadUrl;
  String? _textContents;
  AppFailure? _failure;
  bool _loading = true;

  bool get _isTextFile =>
      widget.document.mimeType?.startsWith('text/') == true ||
      const {
        'txt',
        'csv',
        'md',
        'log',
        'json',
      }.contains(widget.document.extension);
  bool get _isPdf =>
      widget.document.mimeType == 'application/pdf' ||
      widget.document.extension == 'pdf';
  bool get _isPreviewable =>
      widget.document.isImage ||
      _isPdf ||
      (_isTextFile && (widget.document.sizeBytes ?? 0) <= 1024 * 1024);

  @override
  void initState() {
    super.initState();
    if (_isPreviewable) unawaited(_loadPreview());
  }

  Future<void> _loadPreview() async {
    final fileId = widget.document.fileId;
    if (fileId == null) {
      setState(() {
        _failure = const NotFoundFailure();
        _loading = false;
      });
      return;
    }
    if (!widget.widgetRef.read(isOnlineProvider)) {
      setState(() => _loading = false);
      return;
    }
    final repository = widget.widgetRef.read(documentsRepositoryProvider);
    final (url, urlFailure) = await repository.getDownloadUrl(fileId);
    if (!mounted) return;
    if (urlFailure != null || url == null) {
      setState(() {
        _failure = urlFailure ?? const UnknownFailure();
        _loading = false;
      });
      return;
    }
    if (_isTextFile) {
      final (contents, contentFailure) = await repository.getTextFileContents(
        url,
      );
      if (!mounted) return;
      setState(() {
        _downloadUrl = url;
        _textContents = contents;
        _failure = contentFailure;
        _loading = false;
      });
      return;
    }
    setState(() {
      _downloadUrl = url;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final isOnline = ref.watch(isOnlineProvider);
    ref.listen(isOnlineProvider, (previous, next) {
      if (next && previous != true) {
        setState(() => _loading = true);
        unawaited(_loadPreview());
      }
    });
    return Container(
      constraints: const BoxConstraints(minHeight: 430),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.border),
      ),
      padding: const EdgeInsets.all(24),
      child: !_isPreviewable
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FileTypeBadge(extension: widget.document.extension),
                  const SizedBox(height: 16),
                  Text(
                    widget.document.title,
                    style: AppText.sectionTitle.copyWith(color: c.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => _downloadDocument(
                      context,
                      widget.widgetRef,
                      widget.document,
                    ),
                    icon: const Icon(LucideIcons.download, size: 16),
                    label: Text(l10n.btnDownload),
                  ),
                ],
              ),
            )
          : _loading
          ? const Center(child: CircularProgressIndicator())
          : _failure != null
          ? Center(
              child: Text(
                _failure!.localizedMessage(context),
                style: AppText.body.copyWith(color: c.textMuted),
                textAlign: TextAlign.center,
              ),
            )
          : !isOnline
          ? Center(
              child: Text(
                l10n.taskAttachmentOffline,
                style: AppText.body.copyWith(color: c.textMuted),
              ),
            )
          : _isTextFile
          ? SelectableText(
              _textContents ?? '',
              style: AppText.body.copyWith(color: c.textPrimary),
            )
          : _isPdf
          ? SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.68,
              child: PdfViewer.uri(Uri.parse(_downloadUrl!)),
            )
          : Center(
              child: InteractiveViewer(
                child: Image.network(
                  _downloadUrl!,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Center(
                    child: Text(
                      l10n.errorGeneric,
                      style: AppText.body.copyWith(color: c.textMuted),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

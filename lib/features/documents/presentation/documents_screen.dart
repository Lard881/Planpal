// app/lib/features/documents/presentation/documents_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
class _DesktopDocuments extends ConsumerWidget {
  const _DesktopDocuments();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final state = ref.watch(documentsProvider);
    final wsName = ref.watch(currentWorkspaceProvider)?.name ?? 'Workspace';

    return Scaffold(
      backgroundColor: c.background,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb
            Text('$wsName / Documents',
              style: AppText.caption.copyWith(color: c.textMuted)),
            const SizedBox(height: 8),
            // Header row
            Row(
              children: [
                Text('Documents',
                  style: AppText.pageTitle.copyWith(color: c.textPrimary)),
                const Spacer(),
                // Grid/list toggle (fix F8)
                Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: c.surfaceAlt,
                    borderRadius: BorderRadius.circular(AppRadius.control),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ToggleBtn(icon: LucideIcons.layoutGrid, selected: true),
                      _ToggleBtn(icon: LucideIcons.list, selected: false),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                PlanPalButton(
                  label: 'Upload File',
                  variant: PlanPalButtonVariant.outline,
                  toolbar: true,
                  icon: LucideIcons.upload,
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                PlanPalButton(
                  label: '+ New Document',
                  toolbar: true,
                  onPressed: () => _showNewDocDialog(context, ref),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: state.loading
                  ? const Center(child: CircularProgressIndicator())
                  : state.folders.isEmpty && state.recentDocs.isEmpty
                      ? EmptyState(
                          icon: LucideIcons.fileText,
                          title: 'No documents yet',
                          actionLabel: '+ New Document',
                          onAction: () => _showNewDocDialog(context, ref),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Folders row
                              if (state.folders.isNotEmpty) ...[
                                _FoldersGrid(folders: state.folders),
                                const SizedBox(height: 32),
                              ],
                              // Recent Documents
                              if (state.recentDocs.isNotEmpty) ...[
                                Text('Recent Documents',
                                  style: AppText.sectionTitle.copyWith(
                                    color: c.textPrimary)),
                                const SizedBox(height: 16),
                                _RecentDocsGrid(docs: state.recentDocs),
                              ],
                            ],
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
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.panel)),
        title: const Text('New Document'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(hintText: 'Document title'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              if (ctrl.text.trim().isEmpty) return;
              Navigator.pop(context);
              final (id, _) = await ref.read(documentsProvider.notifier)
                  .createWrittenDocument(ctrl.text.trim());
              if (id != null && context.mounted) {
                context.push('/documents/$id');
              }
            },
            child: const Text('Create')),
        ],
      ),
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  final IconData icon;
  final bool selected;
  const _ToggleBtn({required this.icon, required this.selected});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: 36, height: 36,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: selected ? c.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.control - 2),
        boxShadow: selected ? AppShadows.card(Brightness.light) : null,
      ),
      child: Icon(icon, size: 16,
        color: selected ? c.textPrimary : c.textMuted),
    );
  }
}

class _FoldersGrid extends StatelessWidget {
  final List<FolderModel> folders;
  const _FoldersGrid({required this.folders});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, crossAxisSpacing: 16,
        mainAxisSpacing: 12, childAspectRatio: 5.5,
      ),
      itemCount: folders.length,
      itemBuilder: (_, i) {
        final f = folders[i];
        final colorIdx = i % 4;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: c.border),
          ),
          child: Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: _folderColors[colorIdx],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(LucideIcons.folder, size: 20,
                  color: _folderIconColors[colorIdx]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(f.name,
                      style: AppText.bodyStrong.copyWith(color: c.textPrimary),
                      overflow: TextOverflow.ellipsis),
                    Text('${f.fileCount} files',
                      style: AppText.caption.copyWith(color: c.textMuted)),
                  ],
                ),
              ),
            ],
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
        crossAxisCount: 4, crossAxisSpacing: 16,
        mainAxisSpacing: 16, childAspectRatio: 1.8,
      ),
      itemCount: docs.length,
      itemBuilder: (_, i) {
        final doc = docs[i];
        return Container(
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
                    child: Icon(LucideIcons.moreHorizontal,
                      size: 16, color: c.textMuted),
                  ),
                ],
              ),
              const Spacer(),
              Text(doc.title,
                style: AppText.bodyStrong.copyWith(color: c.textPrimary),
                overflow: TextOverflow.ellipsis, maxLines: 1),
              const SizedBox(height: 4),
              Text(doc.relativeTime(),
                style: AppText.caption.copyWith(color: c.textMuted)),
            ],
          ),
        );
      },
    );
  }

  void _showDocMenu(BuildContext context, WidgetRef ref, DocumentModel doc) {
    final c = context.colors;
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (doc.isWritten)
              ListTile(
                leading: const Icon(LucideIcons.fileEdit),
                title: const Text('Open'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/documents/${doc.id}');
                },
              ),
            ListTile(
              leading: Icon(LucideIcons.trash2, color: c.danger),
              title: Text('Delete',
                style: TextStyle(color: c.danger)),
              onTap: () {
                Navigator.pop(context);
                ref.read(documentsProvider.notifier).deleteDocument(doc.id);
              },
            ),
          ],
        ),
      ),
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

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(documentsProvider.notifier).load(),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Text('Documents',
                        style: AppText.pageTitleMobile.copyWith(
                          color: c.textPrimary)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _showMobileMenu(context, ref),
                        child: Container(
                          width: 36, height: 36,
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                        Text('Search files...',
                          style: AppText.body.copyWith(color: c.textMuted)),
                      ],
                    ),
                  ),
                ),
              ),
              if (state.loading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()))
              else ...[
                // Folders grid (2 per row)
                if (state.folders.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, crossAxisSpacing: 12,
                        mainAxisSpacing: 12, childAspectRatio: 3.2,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (_, i) {
                          final f = state.folders[i];
                          final colorIdx = i % 4;
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: c.surface,
                              borderRadius: BorderRadius.circular(AppRadius.card),
                              border: Border.all(color: c.border),
                            ),
                            child: Row(
                              children: [
                                Icon(LucideIcons.folder, size: 20,
                                  color: _folderIconColors[colorIdx]),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(f.name,
                                        style: AppText.bodyStrong.copyWith(
                                          color: c.textPrimary),
                                        overflow: TextOverflow.ellipsis),
                                      Text('${f.fileCount} files',
                                        style: AppText.caption.copyWith(
                                          color: c.textMuted)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: state.folders.length,
                      ),
                    ),
                  ),
                // Recent section
                if (state.recentDocs.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                      child: Text('Recent',
                        style: AppText.sectionTitle.copyWith(
                          color: c.textPrimary)),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) {
                          final doc = state.recentDocs[i];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _MobileDocRow(doc: doc, ref: ref),
                          );
                        },
                        childCount: state.recentDocs.length,
                      ),
                    ),
                  ),
                ],
                if (state.folders.isEmpty && state.recentDocs.isEmpty)
                  const SliverFillRemaining(
                    child: EmptyState(
                      icon: LucideIcons.fileText,
                      title: 'No documents yet',
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showMobileMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(LucideIcons.filePlus),
              title: const Text('New Document'),
              onTap: () {
                Navigator.pop(context);
                _showNewDocDialog(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.upload),
              title: const Text('Upload File'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(LucideIcons.folderPlus),
              title: const Text('New Folder'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewDocDialog(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Document'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(hintText: 'Document title'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              if (ctrl.text.trim().isEmpty) return;
              Navigator.pop(context);
              final (id, _) = await ref.read(documentsProvider.notifier)
                  .createWrittenDocument(ctrl.text.trim());
              if (id != null && context.mounted) {
                context.push('/documents/$id');
              }
            },
            child: const Text('Create')),
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
      onTap: doc.isWritten ? () => context.push('/documents/${doc.id}') : null,
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
              child: Text(doc.title,
                style: AppText.bodyMedium.copyWith(color: c.textPrimary),
                overflow: TextOverflow.ellipsis),
            ),
            Icon(LucideIcons.moreHorizontal, size: 18, color: c.textMuted),
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
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: ErrorState(message: e.toString())),
      data: (doc) {
        if (doc == null) return const Scaffold(
          body: EmptyState(icon: LucideIcons.fileX, title: 'Document not found'));
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
  String _saveStatus = 'Saved';
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
      if (mounted) setState(() => _saveStatus = 'Waiting to sync');
    });
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _quillCtrl.dispose();
    _focusNode.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() { _saving = true; _saveStatus = 'Saving...'; });
    final deltaJson = _quillCtrl.document.toDelta().toJson();
    final plainText = _quillCtrl.document.toPlainText();
    await widget.widgetRef.read(documentsRepositoryProvider).updateDocument(
      widget.doc.id,
      title: _titleCtrl.text.trim(),
      content: {'ops': deltaJson},
      contentText: plainText,
    );
    if (mounted) setState(() { _saving = false; _saveStatus = 'Saved'; });
  }

  @override
  Widget build(BuildContext context) {
    final doc = widget.doc;
    final c = context.colors;
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
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: c.surface,
                        borderRadius: BorderRadius.circular(AppRadius.control),
                        border: Border.all(color: c.border),
                      ),
                      child: Icon(LucideIcons.arrowLeft, size: 18, color: c.textPrimary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Documents / ${doc.title}',
                      style: AppText.body.copyWith(color: c.textMuted),
                      overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: 8),
                  Text(_saveStatus,
                    style: AppText.caption.copyWith(
                      color: _saveStatus == 'Saved' ? c.success : c.textMuted)),
                  const SizedBox(width: 8),
                  PlanPalButton(label: 'Save', toolbar: true, loading: _saving, onPressed: _save),
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
                  showClipboardPaste: false,
                  showClipboardCopy: false,
                  showClipboardCut: false,
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
                          style: AppText.pageTitle.copyWith(color: c.textPrimary),
                          decoration: InputDecoration(
                            hintText: 'Untitled',
                            hintStyle: AppText.pageTitle.copyWith(color: c.textMuted),
                            border: InputBorder.none, filled: false),
                          onChanged: (_) => setState(() => _saveStatus = 'Waiting to sync'),
                        ),
                        const SizedBox(height: 4),
                        Text('${doc.relativeTime()} · ${doc.createdByName ?? ''}',
                          style: AppText.caption.copyWith(color: c.textMuted)),
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
                              placeholder: 'Start writing...',
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

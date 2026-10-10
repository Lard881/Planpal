import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../features/auth/presentation/auth_providers.dart';
import '../../../features/workspaces/providers/workspace_providers.dart';
import '../repositories/document_repository.dart';

class DocumentEditorScreen extends ConsumerStatefulWidget {
  final String? documentId; // null for new document
  final String? initialTitle;
  final String? folderId;

  const DocumentEditorScreen({
    super.key,
    this.documentId,
    this.initialTitle,
    this.folderId,
  });

  @override
  ConsumerState<DocumentEditorScreen> createState() =>
      _DocumentEditorScreenState();
}

class _DocumentEditorScreenState extends ConsumerState<DocumentEditorScreen> {
  late QuillController _controller;
  final TextEditingController _titleController = TextEditingController();
  Timer? _autoSaveTimer;
  bool _isLoading = true;
  bool _isSaving = false;
  DateTime? _lastSaved;
  String? _currentDocumentId;

  @override
  void initState() {
    super.initState();
    _currentDocumentId = widget.documentId;
    _titleController.text = widget.initialTitle ?? 'Untitled';
    _loadDocument();

    // Auto-save every 5 seconds
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_isSaving) {
        _save(showSnackbar: false);
      }
    });
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _controller.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _loadDocument() async {
    try {
      if (widget.documentId != null) {
        final doc = await ref
            .read(documentRepositoryProvider)
            .getDocument(widget.documentId!);

        if (doc != null && doc.content != null) {
          final delta = Delta.fromJson(jsonDecode(doc.content!) as List);
          _controller = QuillController(
            document: Document.fromDelta(delta),
            selection: const TextSelection.collapsed(offset: 0),
          );
          _titleController.text = doc.title;
        } else {
          _controller = QuillController.basic();
        }
      } else {
        _controller = QuillController.basic();
      }

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading document: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      _controller = QuillController.basic();
    }
  }

  Future<void> _save({bool showSnackbar = true}) async {
    if (_isSaving) return;

    final workspaceId = ref.read(currentWorkspaceIdProvider);
    final userId = ref.read(currentUserIdProvider);
    if (workspaceId == null || userId == null) return;

    setState(() => _isSaving = true);

    try {
      final title = _titleController.text.trim();
      if (title.isEmpty) {
        if (showSnackbar && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.documentNameRequired),
              backgroundColor: Colors.orange,
            ),
          );
        }
        setState(() => _isSaving = false);
        return;
      }

      final delta = _controller.document.toDelta();
      final content = jsonEncode(delta.toJson());
      final plainText = _controller.document.toPlainText();

      final repo = ref.read(documentRepositoryProvider);

      if (_currentDocumentId == null) {
        // Create new document
        final doc = await repo.createWrittenDocument(
          workspaceId: workspaceId,
          title: title,
          content: content,
          contentText: plainText,
          folderId: widget.folderId,
          createdBy: userId,
        );
        _currentDocumentId = doc.id;
      } else {
        // Update existing document
        await repo.updateDocument(
          documentId: _currentDocumentId!,
          title: title,
          content: content,
          contentText: plainText,
        );
      }

      setState(() {
        _lastSaved = DateTime.now();
        _isSaving = false;
      });

      if (showSnackbar && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.documentSaved),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.loading),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _titleController,
          style: Theme.of(context).textTheme.titleLarge,
          decoration: InputDecoration(
            hintText: l10n.documentName,
            border: InputBorder.none,
          ),
        ),
        actions: [
          // Save status
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else if (_lastSaved != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  l10n.savedAt(_formatTime(_lastSaved!)),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          // Save button
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: l10n.save,
            onPressed: () => _save(showSnackbar: true),
          ),
        ],
      ),
      body: Column(
        children: [
          // Toolbar
          QuillToolbar.simple(
            controller: _controller,
          ),
          const Divider(height: 1),
          // Editor
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: QuillEditor.basic(
                controller: _controller,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inSeconds < 60) {
      return 'just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}

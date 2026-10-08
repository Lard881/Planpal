import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../repositories/document_repository.dart';

class RenameDialog extends ConsumerStatefulWidget {
  final String entityType; // 'folder' or 'document'
  final String entityId;
  final String currentName;

  const RenameDialog({
    super.key,
    required this.entityType,
    required this.entityId,
    required this.currentName,
  });

  @override
  ConsumerState<RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends ConsumerState<RenameDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _rename() async {
    if (!_formKey.currentState!.validate()) return;

    final newName = _nameController.text.trim();
    if (newName == widget.currentName) {
      Navigator.of(context).pop();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(documentRepositoryProvider);

      if (widget.entityType == 'folder') {
        await repo.updateFolder(
          folderId: widget.entityId,
          name: newName,
        );
      } else {
        await repo.updateDocument(
          documentId: widget.entityId,
          title: newName,
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.entityType == 'folder'
                  ? AppLocalizations.of(context)!.folderRenamed
                  : AppLocalizations.of(context)!.documentRenamed,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.rename),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: widget.entityType == 'folder'
                ? l10n.folderName
                : l10n.documentName,
          ),
          autofocus: true,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return widget.entityType == 'folder'
                  ? l10n.folderNameRequired
                  : l10n.documentNameRequired;
            }
            if (value.length > 200) {
              return l10n.nameTooLong;
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _rename,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.rename),
        ),
      ],
    );
  }
}

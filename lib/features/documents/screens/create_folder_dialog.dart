import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../features/auth/presentation/auth_providers.dart';
import '../../../features/workspaces/providers/workspace_providers.dart';
import '../providers/document_providers.dart';
import '../repositories/document_repository.dart';

class CreateFolderDialog extends ConsumerStatefulWidget {
  const CreateFolderDialog({super.key});

  @override
  ConsumerState<CreateFolderDialog> createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends ConsumerState<CreateFolderDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createFolder() async {
    if (!_formKey.currentState!.validate()) return;

    final workspaceId = ref.read(currentWorkspaceIdProvider);
    final parentId = ref.read(currentFolderIdProvider);
    final userId = ref.read(currentUserIdProvider);

    if (workspaceId == null || userId == null) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(documentRepositoryProvider).createFolder(
            workspaceId: workspaceId,
            name: _nameController.text.trim(),
            parentId: parentId,
            createdBy: userId,
          );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.folderCreated),
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
      title: Text(l10n.createFolder),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: l10n.folderName,
            hintText: l10n.enterFolderName,
          ),
          autofocus: true,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.folderNameRequired;
            }
            if (value.length > 200) {
              return l10n.folderNameTooLong;
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
          onPressed: _isLoading ? null : _createFolder,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.create),
        ),
      ],
    );
  }
}

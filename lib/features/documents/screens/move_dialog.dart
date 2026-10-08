import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../features/workspaces/providers/workspace_providers.dart';
import '../providers/document_providers.dart';
import '../repositories/document_repository.dart';

class MoveDialog extends ConsumerStatefulWidget {
  final String entityType; // 'folder' or 'document'
  final String entityId;
  final String? currentFolderId;

  const MoveDialog({
    super.key,
    required this.entityType,
    required this.entityId,
    this.currentFolderId,
  });

  @override
  ConsumerState<MoveDialog> createState() => _MoveDialogState();
}

class _MoveDialogState extends ConsumerState<MoveDialog> {
  String? _selectedFolderId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedFolderId = widget.currentFolderId;
  }

  Future<void> _move() async {
    if (_selectedFolderId == widget.currentFolderId) {
      Navigator.of(context).pop();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(documentRepositoryProvider);

      if (widget.entityType == 'folder') {
        await repo.updateFolder(
          folderId: widget.entityId,
          parentId: _selectedFolderId,
        );
      } else {
        await repo.updateDocument(
          documentId: widget.entityId,
          folderId: _selectedFolderId,
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.entityType == 'folder'
                  ? AppLocalizations.of(context)!.folderMoved
                  : AppLocalizations.of(context)!.documentMoved,
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
    final workspaceId = ref.watch(currentWorkspaceIdProvider);

    if (workspaceId == null) {
      return AlertDialog(
        title: Text(l10n.error),
        content: Text(l10n.noWorkspaceSelected),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      );
    }

    // Get all folders in workspace (excluding the folder being moved to prevent circular refs)
    final foldersAsync = ref.watch(foldersProvider);

    return AlertDialog(
      title: Text(l10n.moveToFolder),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Root folder option
            RadioListTile<String?>(
              value: null,
              groupValue: _selectedFolderId,
              onChanged: (value) {
                setState(() => _selectedFolderId = value);
              },
              title: Row(
                children: [
                  const Icon(Icons.home, size: 20),
                  const SizedBox(width: 8),
                  Text(l10n.rootFolder),
                ],
              ),
            ),
            const Divider(),
            // Folders list
            Flexible(
              child: foldersAsync.when(
                data: (folders) {
                  final availableFolders = folders
                      .where((f) => f.id != widget.entityId) // Exclude self
                      .toList();

                  if (availableFolders.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        l10n.noFoldersAvailable,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: availableFolders.length,
                    itemBuilder: (context, index) {
                      final folder = availableFolders[index];
                      return RadioListTile<String?>(
                        value: folder.id,
                        groupValue: _selectedFolderId,
                        onChanged: (value) {
                          setState(() => _selectedFolderId = value);
                        },
                        title: Row(
                          children: [
                            const Icon(Icons.folder, size: 20, color: Colors.amber),
                            const SizedBox(width: 8),
                            Expanded(child: Text(folder.name)),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => Center(child: Text(l10n.errorLoadingData)),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _move,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.move),
        ),
      ],
    );
  }
}

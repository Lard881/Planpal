import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/db/app_database.dart';
import '../../../core/l10n/app_localizations.dart';
import '../repositories/document_repository.dart';
import '../screens/rename_dialog.dart';
import '../screens/move_dialog.dart';

class FolderOptionsMenu extends ConsumerWidget {
  final Folder folder;

  const FolderOptionsMenu({
    super.key,
    required this.folder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<String>(
      onSelected: (value) async {
        switch (value) {
          case 'rename':
            showDialog(
              context: context,
              builder: (context) => RenameDialog(
                entityType: 'folder',
                entityId: folder.id,
                currentName: folder.name,
              ),
            );
            break;
          case 'move':
            showDialog(
              context: context,
              builder: (context) => MoveDialog(
                entityType: 'folder',
                entityId: folder.id,
                currentFolderId: folder.parentId,
              ),
            );
            break;
          case 'delete':
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(l10n.delete),
                content: Text(l10n.confirmDeleteFolder),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(l10n.cancel),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text(l10n.delete),
                  ),
                ],
              ),
            );

            if (confirmed == true && context.mounted) {
              try {
                await ref
                    .read(documentRepositoryProvider)
                    .deleteFolder(folder.id);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.folderDeleted)),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            }
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'rename',
          child: Row(
            children: [
              const Icon(Icons.edit),
              const SizedBox(width: 12),
              Text(l10n.rename),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'move',
          child: Row(
            children: [
              const Icon(Icons.drive_file_move),
              const SizedBox(width: 12),
              Text(l10n.move),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete, color: Colors.red),
              const SizedBox(width: 12),
              Text(l10n.delete, style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }
}

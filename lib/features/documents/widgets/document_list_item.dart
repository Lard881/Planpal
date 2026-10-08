import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/db/app_database.dart';
import '../widgets/document_options_menu.dart';
import '../screens/document_editor_screen.dart';
import '../screens/file_preview_screen.dart';

class DocumentListItem extends StatelessWidget {
  final Document document;

  const DocumentListItem({
    super.key,
    required this.document,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        _getIcon(),
        color: _getIconColor(),
        size: 32,
      ),
      title: Text(document.title),
      subtitle: Text(
        DateFormat.yMMMd().add_jm().format(document.updatedAt),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: DocumentOptionsMenu(document: document),
      onTap: () {
        if (document.kind == 'written') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DocumentEditorScreen(
                documentId: document.id,
                initialTitle: document.title,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilePreviewScreen(document: document),
            ),
          );
        }
      },
    );
  }

  IconData _getIcon() {
    if (document.kind == 'written') {
      return Icons.description;
    }
    return Icons.insert_drive_file;
  }

  Color _getIconColor() {
    if (document.kind == 'written') {
      return Colors.blue;
    }
    return Colors.grey;
  }
}

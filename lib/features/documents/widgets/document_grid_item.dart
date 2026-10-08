import 'package:flutter/material.dart';
import '../../../core/db/app_database.dart';
import '../screens/document_editor_screen.dart';
import '../screens/file_preview_screen.dart';

class DocumentGridItem extends StatelessWidget {
  final Document document;

  const DocumentGridItem({
    super.key,
    required this.document,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icon
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Icon(
                  _getIcon(),
                  size: 48,
                  color: _getIconColor(),
                ),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                document.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    if (document.kind == 'written') {
      return Icons.description;
    }
    // File document - determine by extension/mime
    return Icons.insert_drive_file;
  }

  Color _getIconColor() {
    if (document.kind == 'written') {
      return Colors.blue;
    }
    return Colors.grey;
  }
}

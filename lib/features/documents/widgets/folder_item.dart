import 'package:flutter/material.dart';
import '../../../core/db/app_database.dart';
import 'package:intl/intl.dart';

class FolderItem extends StatelessWidget {
  final Folder folder;
  final VoidCallback onTap;

  const FolderItem({
    super.key,
    required this.folder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.folder, color: Colors.amber, size: 32),
      title: Text(folder.name),
      subtitle: Text(
        DateFormat.yMMMd().format(folder.createdAt),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

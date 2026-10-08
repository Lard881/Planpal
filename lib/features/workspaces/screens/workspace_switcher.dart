import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';

/// Workspace Switcher Widget
/// Shows current workspace and allows switching between Personal and Team workspaces
class WorkspaceSwitcher extends ConsumerWidget {
  const WorkspaceSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Get current workspace from provider
    final currentWorkspace = 'Personal Workspace';
    
    return PopupMenuButton<String>(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.workspaces, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              currentWorkspace,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'personal',
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('Personal Workspace'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: 'team1',
          child: ListTile(
            leading: Icon(Icons.groups),
            title: Text('Team Workspace'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'create',
          child: ListTile(
            leading: Icon(Icons.add_circle),
            title: Text('Create Workspace'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: 'join',
          child: ListTile(
            leading: Icon(Icons.login),
            title: Text('Join Workspace'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 'create') {
          Navigator.pushNamed(context, '/workspace/create');
        } else if (value == 'join') {
          Navigator.pushNamed(context, '/workspace/join');
        } else {
          // TODO: Switch workspace
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Switched to $value')),
          );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';

/// Members Management Screen
/// Shows all workspace members with their roles and allows admin actions
class MembersScreen extends ConsumerWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Get members from repository
    final members = _getDummyMembers();
    final currentUserRole = 'admin'; // TODO: Get from provider

    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
        actions: [
          if (currentUserRole == 'admin')
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () {
                Navigator.pushNamed(context, '/workspace/invite');
              },
              tooltip: 'Invite Members',
            ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: members.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final member = members[index];
          final isCurrentUser = member['isCurrentUser'] as bool;
          
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Text(
                (member['name'] as String).substring(0, 1).toUpperCase(),
                style: const TextStyle(color: AppColors.onPrimary),
              ),
            ),
            title: Row(
              children: [
                Text(member['name'] as String),
                if (isCurrentUser) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'You',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            subtitle: Text(member['email'] as String),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Role Chip
                _buildRoleChip(member['role'] as String),
                if (currentUserRole == 'admin' && !isCurrentUser) ...[
                  const SizedBox(width: 8),
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'change_role',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Change Role'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'remove',
                        child: ListTile(
                          leading: Icon(Icons.remove_circle, color: Colors.red),
                          title: Text('Remove', style: TextStyle(color: Colors.red)),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'change_role') {
                        _showChangeRoleDialog(context, member['name'] as String);
                      } else if (value == 'remove') {
                        _showRemoveMemberDialog(context, member['name'] as String);
                      }
                    },
                  ),
                ],
              ],
            ),
          );
        },
      ),
      floatingActionButton: currentUserRole == 'admin'
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, '/workspace/invite');
              },
              icon: const Icon(Icons.person_add),
              label: const Text('Invite'),
            )
          : null,
    );
  }

  Widget _buildRoleChip(String role) {
    Color color;
    switch (role) {
      case 'admin':
        color = AppColors.danger;
        break;
      case 'member':
        color = AppColors.success;
        break;
      case 'guest':
        color = AppColors.warning;
        break;
      default:
        color = AppColors.textMuted;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        role.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  void _showChangeRoleDialog(BuildContext context, String memberName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change role for $memberName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Admin'),
              subtitle: const Text('Full access to workspace'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Update member role
              },
            ),
            ListTile(
              title: const Text('Member'),
              subtitle: const Text('Can create and edit content'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Update member role
              },
            ),
            ListTile(
              title: const Text('Guest'),
              subtitle: const Text('Limited access'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Update member role
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRemoveMemberDialog(BuildContext context, String memberName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove member'),
        content: Text('Are you sure you want to remove $memberName from this workspace?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Remove member
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$memberName has been removed')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getDummyMembers() {
    return [
      {
        'name': 'Current User',
        'email': 'lordadjei881@gmail.com',
        'role': 'admin',
        'isCurrentUser': true,
      },
      {
        'name': 'John Doe',
        'email': 'john@example.com',
        'role': 'member',
        'isCurrentUser': false,
      },
      {
        'name': 'Jane Smith',
        'email': 'jane@example.com',
        'role': 'member',
        'isCurrentUser': false,
      },
      {
        'name': 'Guest User',
        'email': 'guest@example.com',
        'role': 'guest',
        'isCurrentUser': false,
      },
    ];
  }
}

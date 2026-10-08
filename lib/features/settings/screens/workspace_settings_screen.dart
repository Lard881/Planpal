import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../workspaces/providers/workspace_provider.dart';

class WorkspaceSettingsScreen extends ConsumerStatefulWidget {
  const WorkspaceSettingsScreen({super.key});

  @override
  ConsumerState<WorkspaceSettingsScreen> createState() =>
      _WorkspaceSettingsScreenState();
}

class _WorkspaceSettingsScreenState
    extends ConsumerState<WorkspaceSettingsScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isPublic = false;
  bool _allowInvites = true;
  bool _requireApproval = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workspaceAsync = ref.watch(currentWorkspaceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workspace Settings'),
      ),
      body: workspaceAsync == null
          ? const Center(child: Text('No workspace selected'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Basic info
                Text(
                  'Basic Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Workspace Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.workspaces),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.description),
                            alignLabelWithHint: true,
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Privacy settings
                Text(
                  'Privacy',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Column(
                    children: [
                      SwitchListTile(
                        value: _isPublic,
                        onChanged: (value) {
                          setState(() {
                            _isPublic = value;
                          });
                        },
                        title: const Text('Public Workspace'),
                        subtitle: const Text(
                          'Anyone can view and join this workspace',
                        ),
                        secondary: const Icon(Icons.public),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Member settings
                Text(
                  'Member Management',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Column(
                    children: [
                      SwitchListTile(
                        value: _allowInvites,
                        onChanged: (value) {
                          setState(() {
                            _allowInvites = value;
                          });
                        },
                        title: const Text('Allow Member Invites'),
                        subtitle: const Text(
                          'Members can invite others to join',
                        ),
                        secondary: const Icon(Icons.person_add),
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        value: _requireApproval,
                        onChanged: (value) {
                          setState(() {
                            _requireApproval = value;
                          });
                        },
                        title: const Text('Require Approval'),
                        subtitle: const Text(
                          'Admin approval required for new members',
                        ),
                        secondary: const Icon(Icons.admin_panel_settings),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.people),
                        title: const Text('Member Roles'),
                        subtitle: const Text('Configure role permissions'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Navigate to roles settings
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Workspace features
                Text(
                  'Features',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.integration_instructions),
                        title: const Text('Integrations'),
                        subtitle: const Text('Connect external services'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Navigate to integrations
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.storage),
                        title: const Text('Storage & Data'),
                        subtitle: const Text('1.2 GB of 5 GB used'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Navigate to storage settings
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.backup),
                        title: const Text('Backup & Export'),
                        subtitle: const Text('Configure automatic backups'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.pushNamed(context, '/analytics/export');
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Billing (placeholder)
                Text(
                  'Billing',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.credit_card),
                        title: const Text('Subscription'),
                        subtitle: const Text('Free Plan - Upgrade available'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Navigate to subscription
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.receipt),
                        title: const Text('Billing History'),
                        subtitle: const Text('View invoices and receipts'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Navigate to billing history
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Danger zone
                Text(
                  'Danger Zone',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.archive, color: Colors.orange),
                        title: const Text('Archive Workspace'),
                        subtitle: const Text('Make workspace read-only'),
                        onTap: () => _showArchiveDialog(context),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.exit_to_app, color: Colors.orange),
                        title: const Text('Leave Workspace'),
                        subtitle: const Text('You will lose access'),
                        onTap: () => _showLeaveDialog(context),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading:
                            const Icon(Icons.delete_forever, color: Colors.red),
                        title: const Text(
                          'Delete Workspace',
                          style: TextStyle(color: Colors.red),
                        ),
                        subtitle: const Text('Permanently delete all data'),
                        onTap: () => _showDeleteDialog(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Save button
                FilledButton(
                  onPressed: _saveSettings,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text('Save Changes'),
                ),
              ],
            ),
    );
  }

  void _showArchiveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Archive Workspace'),
        content: const Text(
          'This will make the workspace read-only. Members can view but not edit content.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Workspace archived')),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Archive'),
          ),
        ],
      ),
    );
  }

  void _showLeaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Workspace'),
        content: const Text(
          'Are you sure you want to leave this workspace? You will need an invitation to rejoin.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // Perform leave action
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Workspace'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This action cannot be undone. This will permanently delete:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• All tasks and projects'),
            Text('• All documents and files'),
            Text('• All chat messages'),
            Text('• All team data'),
            SizedBox(height: 16),
            Text('Type "DELETE" to confirm:'),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'DELETE',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // Perform delete
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete Forever'),
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workspace settings saved')),
    );
  }
}

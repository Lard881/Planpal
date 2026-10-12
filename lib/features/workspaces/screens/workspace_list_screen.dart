import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/workspace_providers.dart';
import 'create_workspace_screen.dart';
import 'join_workspace_screen.dart';
import 'workspace_detail_screen.dart';
import '../../../shared/widgets/loading_skeleton.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_state.dart';

/// Screen showing all user's workspaces with ability to switch between them
class WorkspaceListScreen extends ConsumerWidget {
  const WorkspaceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspacesAsync = ref.watch(workspacesProvider);
    final currentWorkspaceId = ref.watch(currentWorkspaceIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workspaces'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showCreateOrJoinDialog(context);
            },
            tooltip: 'Create or Join Workspace',
          ),
        ],
      ),
      body: workspacesAsync.when(
        data: (workspaces) {
          if (workspaces.isEmpty) {
            return EmptyState(
              icon: Icons.workspaces_outline,
              title: 'No workspaces',
              message: 'Create your first workspace to get started.',
              actionLabel: 'Create Workspace',
              onAction: () => _showCreateOrJoinDialog(context),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: workspaces.length,
            itemBuilder: (context, index) {
              final workspace = workspaces[index];
              final isSelected = workspace.id == currentWorkspaceId;
              final isPersonal = workspace.type == 'personal';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: isSelected ? 2 : 0,
                color: isSelected
                    ? Theme.of(context).colorScheme.primaryContainer
                    : null,
                child: ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getWorkspaceColor(workspace.id),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        workspace.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    workspace.name,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    isPersonal ? 'Personal Workspace' : 'Team Workspace',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : const Icon(Icons.chevron_right),
                  onTap: () {
                    if (!isSelected) {
                      ref.read(currentWorkspaceIdProvider.notifier).setWorkspace(workspace.id);
                      Navigator.of(context).pop();
                    } else {
                      // Navigate to workspace details
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              WorkspaceDetailScreen(workspace: workspace),
                        ),
                      );
                    }
                  },
                  onLongPress: !isPersonal
                      ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  WorkspaceDetailScreen(workspace: workspace),
                            ),
                          );
                        }
                      : null,
                ),
              );
            },
          );
        },
        loading: () => const SkeletonList(itemHeight: 72),
        error: (error, stack) => ErrorState(
          message: '$error',
          onRetry: () => ref.invalidate(workspacesProvider),
        ),
      ),
    );
  }

  void _showCreateOrJoinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Workspace'),
        content: const Text('Would you like to create a new workspace or join an existing one?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateWorkspaceScreen(),
                ),
              );
            },
            child: const Text('Create New'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const JoinWorkspaceScreen(),
                ),
              );
            },
            child: const Text('Join Existing'),
          ),
        ],
      ),
    );
  }

  Color _getWorkspaceColor(String workspaceId) {
    final hash = workspaceId.hashCode;
    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.green,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.cyan,
    ];
    return colors[hash.abs() % colors.length];
  }
}

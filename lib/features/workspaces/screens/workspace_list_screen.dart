import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart' hide currentWorkspaceIdProvider;
import '../providers/workspace_providers.dart';
import 'create_workspace_screen.dart';
import 'join_workspace_screen.dart';
import 'workspace_detail_screen.dart';

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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.workspaces_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No workspaces',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first workspace to get started',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateOrJoinDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Workspace'),
                  ),
                ],
              ),
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
                          .withOpacity(0.6),
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
                      ref.read(currentWorkspaceIdProvider.notifier).state =
                          workspace.id;
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load workspaces',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(workspacesProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
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

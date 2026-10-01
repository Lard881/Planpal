import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/planpal_card.dart';
import '../widgets/create_project_dialog.dart';

/// Projects screen showing all projects in a workspace
class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  bool _showArchived = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          // Toggle archived
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'toggle_archived') {
                setState(() => _showArchived = !_showArchived);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'toggle_archived',
                child: Row(
                  children: [
                    Icon(_showArchived ? Icons.visibility_off : Icons.visibility),
                    const SizedBox(width: 8),
                    Text(_showArchived ? 'Hide Archived' : 'Show Archived'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildProjectList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createProject,
        icon: const Icon(Icons.add),
        label: const Text('New Project'),
      ),
    );
  }

  Widget _buildProjectList() {
    final workspaceId = ref.watch(currentWorkspaceIdProvider);

    if (workspaceId == null) {
      return const EmptyState(
        icon: Icons.workspace_premium,
        title: 'No workspace selected',
        message: 'Please select or create a workspace to view projects',
      );
    }

    final projectRepository = ref.watch(projectRepositoryProvider);
    final projectsStream = projectRepository.watchProjects(
      workspaceId,
      includeArchived: _showArchived,
    );

    return StreamBuilder(
      stream: projectsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return ErrorState(
            title: 'Failed to load projects',
            message: snapshot.error.toString(),
            onRetry: () => setState(() {}),
          );
        }

        final projects = snapshot.data ?? [];

        if (projects.isEmpty) {
          return EmptyState(
            icon: Icons.folder_open,
            title: _showArchived ? 'No archived projects' : 'No projects yet',
            message: _showArchived
                ? 'Archived projects will appear here'
                : 'Create your first project to organize your tasks',
            actionLabel: _showArchived ? null : 'Create Project',
            onAction: _showArchived ? null : _createProject,
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 350,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.5,
          ),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return _ProjectCard(
              project: project,
              onTap: () => _openProject(project.id),
              onArchive: () => _archiveProject(project.id, !project.isArchived),
              onDelete: () => _deleteProject(project.id, project.name),
            );
          },
        );
      },
    );
  }

  void _createProject() {
    showDialog(
      context: context,
      builder: (context) => const CreateProjectDialog(),
    );
  }

  void _openProject(String projectId) {
    Navigator.pushNamed(context, '/projects/$projectId');
  }

  Future<void> _archiveProject(String projectId, bool archive) async {
    final projectRepository = ref.read(projectRepositoryProvider);
    await projectRepository.archiveProject(projectId, archive);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(archive ? 'Project archived' : 'Project restored'),
        ),
      );
    }
  }

  Future<void> _deleteProject(String projectId, String projectName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: Text('Are you sure you want to delete "$projectName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final projectRepository = ref.read(projectRepositoryProvider);
        await projectRepository.deleteProject(projectId);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Project deleted')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete project: $e')),
          );
        }
      }
    }
  }
}

/// Project card widget
class _ProjectCard extends StatelessWidget {
  final dynamic project;
  final VoidCallback onTap;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

  const _ProjectCard({
    required this.project,
    required this.onTap,
    required this.onArchive,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _parseColor(project.color) ?? AppColors.primary;
    final isArchived = project.isArchived as bool;

    return PlanPalCard(
      onTap: onTap,
      child: Stack(
        children: [
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and color
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getIcon(project.icon),
                      color: color,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  // Archive status
                  if (isArchived)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.grey200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Archived',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.grey700,
                        ),
                      ),
                    ),
                  // Menu
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'archive') {
                        onArchive();
                      } else if (value == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'archive',
                        child: Row(
                          children: [
                            Icon(isArchived ? Icons.unarchive : Icons.archive),
                            const SizedBox(width: 8),
                            Text(isArchived ? 'Restore' : 'Archive'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Project name
              Text(
                project.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.grey900,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              if (project.description != null && project.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  project.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const Spacer(),

              // Task count
              Row(
                children: [
                  Icon(Icons.task, size: 16, color: AppColors.grey600),
                  const SizedBox(width: 4),
                  Text(
                    '${project.taskCount ?? 0} tasks',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Color accent line
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color? _parseColor(String? colorStr) {
    if (colorStr == null || colorStr.isEmpty) return null;
    try {
      return Color(int.parse(colorStr.replaceFirst('#', '0xFF')));
    } catch (e) {
      return null;
    }
  }

  IconData _getIcon(String? iconStr) {
    switch (iconStr?.toLowerCase()) {
      case 'work':
        return Icons.work;
      case 'home':
        return Icons.home;
      case 'school':
        return Icons.school;
      case 'shopping':
        return Icons.shopping_cart;
      case 'health':
        return Icons.favorite;
      default:
        return Icons.folder;
    }
  }
}

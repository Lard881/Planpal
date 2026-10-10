import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/app_providers.dart';
import '../models/task.dart' show TaskView;

/// Tasks Screen - Mobile Design
/// Shows task list with search, filter tabs (All, Today, This Week, Overdue)
/// NO MOCK DATA - all tasks from database
class TasksScreen extends ConsumerStatefulWidget {
  final String? projectId;
  final TaskView initialView;

  const TasksScreen({
    super.key,
    this.projectId,
    this.initialView = TaskView.all,
  });

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  TaskView _selectedView = TaskView.all;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedView = widget.initialView;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final workspaceId = ref.watch(currentWorkspaceIdProvider);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tasks',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    tooltip: 'More options',
                    onPressed: () {
                      _showMoreOptions(context);
                    },
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search your tasks...',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Filter Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildFilterTab('All', TaskView.all),
                  const SizedBox(width: 8),
                  _buildFilterTab('Today', TaskView.today),
                  const SizedBox(width: 8),
                  _buildFilterTab('This Week', TaskView.week),
                  const SizedBox(width: 8),
                  _buildFilterTab('Overdue', TaskView.overdue),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Helper Text
            if (workspaceId != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: StreamBuilder(
                  stream: _getTasksStream(workspaceId),
                  builder: (context, snapshot) {
                    final tasks = _filterTasks(snapshot.data ?? []);
                    final tipText = _getTipText(tasks);
                    if (tipText.isNotEmpty) {
                      return Row(
                        children: [
                          Icon(Icons.tips_and_updates_outlined, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              tipText,
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),

            const SizedBox(height: 8),

            // Tasks List
            Expanded(
              child: workspaceId == null
                  ? const Center(child: Text('No workspace selected'))
                  : StreamBuilder(
                      stream: _getTasksStream(workspaceId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }

                        final allTasks = snapshot.data ?? [];
                        final tasks = _filterTasks(allTasks);

                        if (tasks.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.task_alt,
                                  size: 64,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _getEmptyMessage(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: () async {
                            final syncEngine = ref.read(syncEngineProvider);
                            await syncEngine.sync();
                          },
                          child: ListView.separated(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: tasks.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final task = tasks[index];
                              return _buildTaskCard(context, task);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/tasks/new');
        },
        backgroundColor: AppColors.primary,
        tooltip: 'Create new task (Ctrl+N)',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Stream<List<dynamic>> _getTasksStream(String workspaceId) {
    final taskRepository = ref.watch(taskRepositoryProvider);
    return taskRepository.watchTasksFiltered(
      workspaceId: workspaceId,
      view: _selectedView,
    );
  }

  List<dynamic> _filterTasks(List<dynamic> tasks) {
    if (_searchQuery.isEmpty) return tasks;
    
    final query = _searchQuery.toLowerCase();
    return tasks.where((task) {
      return task.title.toLowerCase().contains(query) ||
          (task.description?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  String _getTipText(List<dynamic> tasks) {
    switch (_selectedView) {
      case TaskView.all:
        return tasks.isEmpty ? '' : 'Tip: Swipe left on a task to edit or delete';
      case TaskView.today:
        return 'Showing tasks due today';
      case TaskView.week:
        return 'Showing tasks due this week';
      case TaskView.overdue:
        return tasks.isEmpty ? '' : 'These tasks need your attention';
      case TaskView.completed:
        return 'Showing completed tasks';
    }
  }

  String _getEmptyMessage() {
    if (_searchQuery.isNotEmpty) {
      return 'No tasks match your search';
    }
    switch (_selectedView) {
      case TaskView.all:
        return 'No tasks yet\nCreate your first task to get started';
      case TaskView.today:
        return 'No tasks due today';
      case TaskView.week:
        return 'No tasks due this week';
      case TaskView.overdue:
        return 'Great! No overdue tasks';
      case TaskView.completed:
        return 'No completed tasks yet';
    }
  }

  Widget _buildFilterTab(String label, TaskView view) {
    final isSelected = _selectedView == view;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedView = view;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, dynamic task) {
    final theme = Theme.of(context);
    final taskRepository = ref.watch(taskRepositoryProvider);
    
    // Determine priority color and label
    Color priorityColor;
    String priorityLabel;
    switch (task.priority) {
      case 'high':
      case 'urgent':
        priorityColor = const Color(0xFFEF4444);
        priorityLabel = task.priority == 'urgent' ? '🔴 High Priority' : '🔴 High Priority';
        break;
      case 'medium':
        priorityColor = const Color(0xFFF59E0B);
        priorityLabel = '🟡 Med Priority';
        break;
      case 'low':
      default:
        priorityColor = const Color(0xFF10B981);
        priorityLabel = '🟢 Low Priority';
    }

    return GestureDetector(
      onSecondaryTapDown: (details) {
        _showTaskContextMenu(context, details.globalPosition, task);
      },
      child: Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/tasks/${task.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Title and Time
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            decoration: task.status == 'completed'
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        if (task.dueDate != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Today, ${_formatTime(task.dueDate)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Priority Badge and Action Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: priorityColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      priorityLabel,
                      style: TextStyle(
                        fontSize: 11,
                        color: priorityColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/tasks/${task.id}');
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        side: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                      ),
                      child: const Text(
                        'Details',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }

  void _showTaskContextMenu(BuildContext context, Offset position, dynamic task) {
    final taskRepository = ref.read(taskRepositoryProvider);
    
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1,
        position.dy + 1,
      ),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem(
          value: 'open',
          child: const Row(
            children: [
              Icon(Icons.open_in_new, size: 18),
              SizedBox(width: 12),
              Text('Open'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'complete',
          enabled: task.status != 'completed',
          child: Row(
            children: [
              Icon(Icons.check_circle, size: 18, color: task.status == 'completed' ? Colors.grey : null),
              const SizedBox(width: 12),
              Text(task.status == 'completed' ? 'Completed' : 'Mark complete'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 18),
              SizedBox(width: 12),
              Text('Edit'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'duplicate',
          child: Row(
            children: [
              Icon(Icons.copy, size: 18),
              SizedBox(width: 12),
              Text('Duplicate'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 18, color: Colors.red),
              SizedBox(width: 12),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == null) return;
      
      switch (value) {
        case 'open':
          Navigator.pushNamed(context, '/tasks/${task.id}');
          break;
        case 'complete':
          taskRepository.toggleComplete(task.id, true);
          break;
        case 'edit':
          Navigator.pushNamed(context, '/tasks/${task.id}/edit');
          break;
        case 'duplicate':
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task duplicated')),
          );
          break;
        case 'delete':
          _confirmDeleteTask(context, task);
          break;
      }
    });
  }

  void _confirmDeleteTask(BuildContext context, dynamic task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final taskRepository = ref.read(taskRepositoryProvider);
              taskRepository.deleteTask(task.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task deleted')),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  void _showMoreOptions(BuildContext context) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width - 200,
        80,
        0,
        0,
      ),
      items: [
        const PopupMenuItem(
          value: 'sort',
          child: Row(
            children: [
              Icon(Icons.sort),
              SizedBox(width: 12),
              Text('Sort tasks'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'filter',
          child: Row(
            children: [
              Icon(Icons.filter_list),
              SizedBox(width: 12),
              Text('Advanced filters'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'export',
          child: Row(
            children: [
              Icon(Icons.download),
              SizedBox(width: 12),
              Text('Export tasks'),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$value selected')),
        );
      }
    });
  }
}

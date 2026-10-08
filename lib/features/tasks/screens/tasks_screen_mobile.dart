import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/task_providers.dart';
import '../models/task.dart' show TaskView;
import '../widgets/task_tile.dart';
import 'task_detail_screen.dart';
import 'new_task_screen.dart';

/// S7.14: Tasks Screen - Mobile
/// Features: chips, search, tiles, swipe to edit/delete, pull to refresh
class TasksScreenMobile extends ConsumerStatefulWidget {
  const TasksScreenMobile({super.key});

  @override
  ConsumerState<TasksScreenMobile> createState() => _TasksScreenMobileState();
}

class _TasksScreenMobileState extends ConsumerState<TasksScreenMobile> {
  TaskView _selectedView = TaskView.all;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final workspaceId = ref.watch(currentWorkspaceIdProvider);

    if (workspaceId == null) {
      return Scaffold(
        body: Center(
          child: Text('No workspace selected', style: theme.textTheme.bodyLarge),
        ),
      );
    }

    final tasksAsync = ref.watch(filteredTasksProvider(
      workspaceId: workspaceId,
      view: _selectedView,
      searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
    ));

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
                  Text(
                    'Tasks',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () => _showFilterBottomSheet(context),
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
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    prefixIcon: const Icon(Icons.search, size: 20),
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

            // View Filter Chips
            SizedBox(
              height: 40,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFilterChip('All', TaskView.all, tasksAsync),
                  const SizedBox(width: 8),
                  _buildFilterChip('Today', TaskView.today, tasksAsync),
                  const SizedBox(width: 8),
                  _buildFilterChip('This Week', TaskView.week, tasksAsync),
                  const SizedBox(width: 8),
                  _buildFilterChip('Overdue', TaskView.overdue, tasksAsync),
                  const SizedBox(width: 8),
                  _buildFilterChip('Completed', TaskView.completed, tasksAsync),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Task List
            Expanded(
              child: tasksAsync.when(
                data: (tasks) {
                  if (tasks.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      // Pull to refresh triggers sync
                      ref.invalidate(filteredTasksProvider(
                        workspaceId: workspaceId,
                        view: _selectedView,
                        searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
                      ));
                      await Future.delayed(const Duration(seconds: 1));
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: tasks.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return _buildTaskTile(context, task);
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => _buildErrorState(error.toString()),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NewTaskScreen(workspaceId: workspaceId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Filter chip with task count badge
  Widget _buildFilterChip(
    String label,
    TaskView view,
    AsyncValue<List<dynamic>> tasksAsync,
  ) {
    final isSelected = _selectedView == view;
    final theme = Theme.of(context);

    // Count tasks for this view (approximate)
    final count = tasksAsync.maybeWhen(
      data: (tasks) => view == _selectedView ? tasks.length : null,
      orElse: () => null,
    );

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (count != null) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedView = view;
        });
      },
    );
  }

  /// Task tile with swipe to edit/delete
  Widget _buildTaskTile(BuildContext context, dynamic task) {
    return Slidable(
      key: ValueKey(task.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => _editTask(context, task),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (_) => _deleteTask(task),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: TaskTile(
        task: task,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TaskDetailScreen(taskId: task.id),
            ),
          );
        },
        onToggleComplete: () => _toggleComplete(task),
      ),
    );
  }

  /// Empty state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first task to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  /// Error state
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading tasks',
            style: TextStyle(
              fontSize: 18,
              color: Colors.red[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              setState(() {}); // Retry
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// Show filter bottom sheet
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter & Sort',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // TODO: Add more filter options (status, priority, assignee)
              ListTile(
                leading: const Icon(Icons.sort),
                title: const Text('Sort by due date'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Filter by assignee'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Toggle task completion
  void _toggleComplete(dynamic task) {
    ref.read(taskRepositoryProvider).toggleComplete(
          task.id,
          task.status != 'completed',
        );
  }

  /// Edit task
  void _editTask(BuildContext context, dynamic task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewTaskScreen(
          workspaceId: task.workspaceId,
          taskToEdit: task,
        ),
      ),
    );
  }

  /// Delete task with confirmation
  Future<void> _deleteTask(dynamic task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
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

    if (confirmed == true) {
      await ref.read(taskRepositoryProvider).deleteTask(task.id);
    }
  }
}

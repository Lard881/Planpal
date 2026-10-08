import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/task_providers.dart';
import '../models/task.dart' show TaskView;
import '../../../core/db/app_database.dart';
import 'task_detail_screen.dart';
import 'new_task_screen.dart';
import 'package:intl/intl.dart';

/// S7.15: Tasks Screen - Desktop
/// Features: filter bar, sortable table, row selection, bulk bar with confirm
class TasksScreenDesktop extends ConsumerStatefulWidget {
  const TasksScreenDesktop({super.key});

  @override
  ConsumerState<TasksScreenDesktop> createState() =>
      _TasksScreenDesktopState();
}

class _TasksScreenDesktopState extends ConsumerState<TasksScreenDesktop> {
  TaskView _selectedView = TaskView.all;
  String _searchQuery = '';
  String? _selectedStatus;
  String? _selectedPriority;
  String _sortColumn = 'created_at';
  bool _sortAscending = false;
  
  final Set<String> _selectedTaskIds = {};
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
      status: _selectedStatus,
    ));

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          // Header with title and actions
          _buildHeader(theme, workspaceId),

          // Filter bar
          _buildFilterBar(theme),

          const Divider(height: 1),

          // Bulk action bar (shows when items selected)
          if (_selectedTaskIds.isNotEmpty) _buildBulkActionBar(theme),

          // Table
          Expanded(
            child: tasksAsync.when(
              data: (tasks) => _buildTaskTable(theme, tasks),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorState(error.toString()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, String workspaceId) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Text(
            'Tasks',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          // Search
          SizedBox(
            width: 300,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewTaskScreen(workspaceId: workspaceId),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('New Task'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
      child: Row(
        children: [
          // View filter
          SegmentedButton<TaskView>(
            segments: const [
              ButtonSegment(value: TaskView.all, label: Text('All')),
              ButtonSegment(value: TaskView.today, label: Text('Today')),
              ButtonSegment(value: TaskView.week, label: Text('This Week')),
              ButtonSegment(value: TaskView.overdue, label: Text('Overdue')),
              ButtonSegment(
                  value: TaskView.completed, label: Text('Completed')),
            ],
            selected: {_selectedView},
            onSelectionChanged: (Set<TaskView> newSelection) {
              setState(() {
                _selectedView = newSelection.first;
                _selectedTaskIds.clear();
              });
            },
          ),
          const SizedBox(width: 16),
          // Status filter
          SizedBox(
            width: 150,
            child: DropdownButtonFormField<String?>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('All')),
                const DropdownMenuItem(value: 'todo', child: Text('To Do')),
                const DropdownMenuItem(
                    value: 'in_progress', child: Text('In Progress')),
                const DropdownMenuItem(value: 'backlog', child: Text('Backlog')),
                const DropdownMenuItem(
                    value: 'completed', child: Text('Completed')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value;
                });
              },
            ),
          ),
          const SizedBox(width: 16),
          // Priority filter
          SizedBox(
            width: 150,
            child: DropdownButtonFormField<String?>(
              value: _selectedPriority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('All')),
                const DropdownMenuItem(value: 'low', child: Text('Low')),
                const DropdownMenuItem(value: 'medium', child: Text('Medium')),
                const DropdownMenuItem(value: 'high', child: Text('High')),
                const DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value;
                });
              },
            ),
          ),
          const Spacer(),
          Text(
            '${_selectedTaskIds.length} selected',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildBulkActionBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: theme.colorScheme.primaryContainer,
      child: Row(
        children: [
          Text(
            '${_selectedTaskIds.length} task(s) selected',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () => _bulkComplete(),
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Mark Complete'),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () => _bulkDelete(),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedTaskIds.clear();
              });
            },
            child: const Text('Clear Selection'),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTable(ThemeData theme, List<Task> tasks) {
    if (tasks.isEmpty) {
      return _buildEmptyState();
    }

    // Apply local filters
    var filteredTasks = tasks;
    if (_selectedPriority != null) {
      filteredTasks =
          filteredTasks.where((t) => t.priority == _selectedPriority).toList();
    }

    // Apply sorting
    filteredTasks.sort((a, b) {
      int compare = 0;
      switch (_sortColumn) {
        case 'title':
          compare = a.title.compareTo(b.title);
          break;
        case 'status':
          compare = a.status.compareTo(b.status);
          break;
        case 'priority':
          compare = _comparePriority(a.priority, b.priority);
          break;
        case 'due_at':
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          compare = a.dueDate!.compareTo(b.dueDate!);
          break;
        case 'created_at':
        default:
          compare = a.createdAt.compareTo(b.createdAt);
          break;
      }
      return _sortAscending ? compare : -compare;
    });

    return SingleChildScrollView(
      child: DataTable(
        showCheckboxColumn: true,
        sortColumnIndex: _getSortColumnIndex(),
        sortAscending: _sortAscending,
        columns: [
          DataColumn(
            label: const Text('Title'),
            onSort: (columnIndex, ascending) => _onSort('title', ascending),
          ),
          DataColumn(
            label: const Text('Status'),
            onSort: (columnIndex, ascending) => _onSort('status', ascending),
          ),
          DataColumn(
            label: const Text('Priority'),
            onSort: (columnIndex, ascending) => _onSort('priority', ascending),
          ),
          DataColumn(
            label: const Text('Due Date'),
            onSort: (columnIndex, ascending) => _onSort('due_at', ascending),
          ),
          DataColumn(
            label: const Text('Assignee'),
          ),
          const DataColumn(
            label: Text('Actions'),
          ),
        ],
        rows: filteredTasks.map((task) {
          final isSelected = _selectedTaskIds.contains(task.id);
          return DataRow(
            selected: isSelected,
            onSelectChanged: (selected) {
              setState(() {
                if (selected == true) {
                  _selectedTaskIds.add(task.id);
                } else {
                  _selectedTaskIds.remove(task.id);
                }
              });
            },
            cells: [
              DataCell(
                InkWell(
                  onTap: () => _openTaskDetail(task),
                  child: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.status == 'completed'
                          ? TextDecoration.lineThrough
                          : null,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataCell(_buildStatusChip(task.status, theme)),
              DataCell(_buildPriorityChip(task.priority, theme)),
              DataCell(Text(task.dueDate != null
                  ? DateFormat('MMM d, yyyy').format(task.dueDate!)
                  : '-')),
              DataCell(Text(task.assigneeId ?? '-')),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      onPressed: () => _editTask(task),
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 18),
                      onPressed: () => _deleteTask(task),
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatusChip(String status, ThemeData theme) {
    final color = _getStatusColor(status);
    final label = status.toUpperCase().replaceAll('_', ' ');

    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color, width: 1),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildPriorityChip(String priority, ThemeData theme) {
    final color = _getPriorityColor(priority);
    final label = priority.toUpperCase();

    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color, width: 1),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No tasks found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text('Error loading tasks', style: TextStyle(color: Colors.red[600])),
          const SizedBox(height: 8),
          Text(error, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.blue;
      case 'todo':
        return Colors.orange;
      case 'backlog':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.blue;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  int _comparePriority(String a, String b) {
    const priority = {'urgent': 4, 'high': 3, 'medium': 2, 'low': 1};
    return (priority[a.toLowerCase()] ?? 0)
        .compareTo(priority[b.toLowerCase()] ?? 0);
  }

  int? _getSortColumnIndex() {
    switch (_sortColumn) {
      case 'title':
        return 0;
      case 'status':
        return 1;
      case 'priority':
        return 2;
      case 'due_at':
        return 3;
      default:
        return null;
    }
  }

  void _onSort(String column, bool ascending) {
    setState(() {
      _sortColumn = column;
      _sortAscending = ascending;
    });
  }

  void _openTaskDetail(Task task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(taskId: task.id),
      ),
    );
  }

  void _editTask(Task task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewTaskScreen(
          workspaceId: task.workspaceId,
          taskToEdit: task,
        ),
      ),
    );
  }

  Future<void> _deleteTask(Task task) async {
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

  Future<void> _bulkComplete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark Complete'),
        content: Text(
            'Mark ${_selectedTaskIds.length} task(s) as complete?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Mark Complete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref
          .read(taskRepositoryProvider)
          .bulkComplete(_selectedTaskIds.toList());
      setState(() {
        _selectedTaskIds.clear();
      });
    }
  }

  Future<void> _bulkDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Tasks'),
        content: Text(
            'Are you sure you want to delete ${_selectedTaskIds.length} task(s)? This cannot be undone.'),
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
      await ref
          .read(taskRepositoryProvider)
          .bulkDelete(_selectedTaskIds.toList());
      setState(() {
        _selectedTaskIds.clear();
      });
    }
  }
}

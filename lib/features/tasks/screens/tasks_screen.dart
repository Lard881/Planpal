import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/planpal_card.dart';
import '../../../shared/widgets/planpal_chip.dart';
import '../models/task.dart';
import '../widgets/task_filter_bar.dart';
import '../widgets/task_list_tile.dart';
import '../../labels/models/label.dart';

/// Main tasks screen with adaptive layout for mobile and desktop
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
  late TaskView _currentView;
  String? _selectedStatus;
  String? _selectedPriority;
  List<String> _selectedLabelIds = [];
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentView = widget.initialView;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final breakpoint = Breakpoints.getBreakpoint(context);
    final isMobile = breakpoint == BreakpointType.mobile;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        actions: [
          // Search button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearch,
          ),
          // Filter button (mobile only)
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: _showFilterSheet,
            ),
        ],
      ),
      body: Column(
        children: [
          // Desktop filter bar
          if (!isMobile)
            TaskFilterBar(
              currentView: _currentView,
              selectedStatus: _selectedStatus,
              selectedPriority: _selectedPriority,
              onViewChanged: (view) => setState(() => _currentView = view),
              onStatusChanged: (status) => setState(() => _selectedStatus = status),
              onPriorityChanged: (priority) => setState(() => _selectedPriority = priority),
            ),

          // Mobile view chips
          if (isMobile) _buildMobileViewChips(),

          // Active filters display
          if (_selectedStatus != null || _selectedPriority != null || _selectedLabelIds.isNotEmpty)
            _buildActiveFilters(),

          // Task list
          Expanded(
            child: _buildTaskList(isMobile),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewTask,
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
    );
  }

  String _getTitle() {
    if (widget.projectId != null) {
      return 'Project Tasks';
    }
    switch (_currentView) {
      case TaskView.today:
        return 'Today';
      case TaskView.week:
        return 'This Week';
      case TaskView.overdue:
        return 'Overdue';
      case TaskView.completed:
        return 'Completed';
      case TaskView.all:
        return 'All Tasks';
    }
  }

  Widget _buildMobileViewChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: TaskView.values.map((view) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: PlanPalChip(
              label: _getViewLabel(view),
              isSelected: view == _currentView,
              onTap: () => setState(() => _currentView = view),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getViewLabel(TaskView view) {
    switch (view) {
      case TaskView.all:
        return 'All';
      case TaskView.today:
        return 'Today';
      case TaskView.week:
        return 'Week';
      case TaskView.overdue:
        return 'Overdue';
      case TaskView.completed:
        return 'Done';
    }
  }

  Widget _buildActiveFilters() {
    final labelRepository = ref.watch(labelRepositoryProvider);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          Icon(
            Icons.filter_list,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if (_selectedStatus != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(
                        label: Text('Status: $_selectedStatus'),
                        onDeleted: () => setState(() => _selectedStatus = null),
                        deleteIcon: const Icon(Icons.close, size: 16),
                      ),
                    ),
                  if (_selectedPriority != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(
                        label: Text('Priority: $_selectedPriority'),
                        onDeleted: () => setState(() => _selectedPriority = null),
                        deleteIcon: const Icon(Icons.close, size: 16),
                      ),
                    ),
                  // Label filter chips
                  ..._selectedLabelIds.map((labelId) {
                    return StreamBuilder<List<dynamic>>(
                      stream: labelRepository.watchLocalLabels(
                        ref.watch(currentWorkspaceIdProvider)!,
                      ),
                      builder: (context, snapshot) {
                        final labels = snapshot.data ?? [];
                        final label = labels.cast<dynamic>().firstWhere(
                          (l) => l.id == labelId,
                          orElse: () => null,
                        );
                        
                        if (label == null) return const SizedBox.shrink();
                        
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Chip(
                            label: Text(label.name),
                            backgroundColor: label.colorValue,
                            labelStyle: TextStyle(color: label.textColor),
                            onDeleted: () {
                              setState(() {
                                _selectedLabelIds.remove(labelId);
                              });
                            },
                            deleteIcon: Icon(
                              Icons.close,
                              size: 16,
                              color: label.textColor,
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedStatus = null;
                _selectedPriority = null;
                _selectedLabelIds = [];
              });
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(bool isMobile) {
    final workspaceId = ref.watch(currentWorkspaceIdProvider);
    
    if (workspaceId == null) {
      return const EmptyState(
        icon: Icons.workspace_premium,
        title: 'No workspace selected',
        message: 'Please select or create a workspace to view tasks',
      );
    }

    final taskRepository = ref.watch(taskRepositoryProvider);
    final tasksStream = taskRepository.watchTasksFiltered(
      workspaceId: workspaceId,
      projectId: widget.projectId,
      status: _selectedStatus,
      view: _currentView,
    );

    return StreamBuilder(
      stream: tasksStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return ErrorState(
            title: 'Failed to load tasks',
            message: snapshot.error.toString(),
            onRetry: () => setState(() {}),
          );
        }

        final tasks = snapshot.data ?? [];

        // Apply search filter
        var filteredTasks = _searchQuery.isEmpty
            ? tasks
            : tasks.where((task) {
                final query = _searchQuery.toLowerCase();
                return task.title.toLowerCase().contains(query) ||
                    (task.description?.toLowerCase().contains(query) ?? false);
              }).toList();

        // Apply priority filter
        if (_selectedPriority != null) {
          filteredTasks = filteredTasks.where((task) => task.priority == _selectedPriority).toList();
        }

        // Apply label filter
        if (_selectedLabelIds.isNotEmpty) {
          final labelRepository = ref.read(labelRepositoryProvider);
          filteredTasks = filteredTasks.where((task) {
            // This is a simplified check - ideally we'd join with task_labels
            // For now, we'll need to check each task's labels
            return true; // TODO: implement proper label filtering
          }).toList();
        }

        final finalTasks = filteredTasks;

        if (finalTasks.isEmpty) {
          return EmptyState(
            icon: Icons.task_alt,
            title: 'No tasks found',
            message: _getEmptyMessage(),
            actionLabel: 'Create Task',
            onAction: _createNewTask,
          );
        }

        if (isMobile) {
          return _buildMobileList(finalTasks);
        } else {
          return _buildDesktopList(finalTasks);
        }
      },
    );
  }

  String _getEmptyMessage() {
    if (_searchQuery.isNotEmpty) {
      return 'No tasks match your search';
    }
    if (_selectedStatus != null || _selectedPriority != null || _selectedLabelIds.isNotEmpty) {
      return 'No tasks match your filters';
    }
    switch (_currentView) {
      case TaskView.today:
        return 'No tasks due today';
      case TaskView.week:
        return 'No tasks due this week';
      case TaskView.overdue:
        return 'No overdue tasks';
      case TaskView.completed:
        return 'No completed tasks';
      case TaskView.all:
        return 'Create your first task to get started';
    }
  }

  Widget _buildMobileList(List<dynamic> tasks) {
    return RefreshIndicator(
      onRefresh: _refreshTasks,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TaskListTile(
              task: task,
              onTap: () => _openTaskDetail(task.id),
              onToggleComplete: () => _toggleTaskComplete(task),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDesktopList(List<dynamic> tasks) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TaskListTile(
            task: task,
            onTap: () => _openTaskDetail(task.id),
            onToggleComplete: () => _toggleTaskComplete(task),
            showProject: widget.projectId == null,
          ),
        );
      },
    );
  }

  void _showSearch() {
    showSearch(
      context: context,
      delegate: TaskSearchDelegate(
        onQueryChanged: (query) => setState(() => _searchQuery = query),
      ),
    );
  }

  void _showFilterSheet() {
    final currentWorkspaceId = ref.read(currentWorkspaceIdProvider);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TaskFilterSheet(
        workspaceId: currentWorkspaceId,
        selectedStatus: _selectedStatus,
        selectedPriority: _selectedPriority,
        selectedLabelIds: _selectedLabelIds,
        onStatusChanged: (status) {
          setState(() => _selectedStatus = status);
          Navigator.pop(context);
        },
        onPriorityChanged: (priority) {
          setState(() => _selectedPriority = priority);
          Navigator.pop(context);
        },
        onLabelsChanged: (labelIds) {
          setState(() => _selectedLabelIds = labelIds);
          Navigator.pop(context);
        },
        onClearFilters: () {
          setState(() {
            _selectedStatus = null;
            _selectedPriority = null;
            _selectedLabelIds = [];
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _refreshTasks() async {
    // Trigger sync
    final syncEngine = ref.read(syncEngineProvider);
    await syncEngine.sync();
  }

  void _toggleTaskComplete(dynamic task) {
    final taskRepository = ref.read(taskRepositoryProvider);
    final isCompleted = task.status == 'completed';
    taskRepository.toggleComplete(task.id, !isCompleted);
  }

  void _openTaskDetail(String taskId) {
    Navigator.pushNamed(context, '/tasks/$taskId');
  }

  void _createNewTask() {
    Navigator.pushNamed(
      context,
      '/tasks/new',
      arguments: {'projectId': widget.projectId},
    );
  }
}

/// Search delegate for tasks
class TaskSearchDelegate extends SearchDelegate<String> {
  final ValueChanged<String> onQueryChanged;

  TaskSearchDelegate({required this.onQueryChanged});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          onQueryChanged('');
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onQueryChanged(query);
    close(context, query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

/// Filter bottom sheet for mobile
class TaskFilterSheet extends ConsumerWidget {
  final String? workspaceId;
  final String? selectedStatus;
  final String? selectedPriority;
  final List<String> selectedLabelIds;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onPriorityChanged;
  final ValueChanged<List<String>> onLabelsChanged;
  final VoidCallback onClearFilters;

  const TaskFilterSheet({
    super.key,
    this.workspaceId,
    this.selectedStatus,
    this.selectedPriority,
    required this.selectedLabelIds,
    required this.onStatusChanged,
    required this.onPriorityChanged,
    required this.onLabelsChanged,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextButton(
                onPressed: onClearFilters,
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Status',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: const Text('To Do'),
                selected: selectedStatus == 'todo',
                onSelected: (selected) => onStatusChanged(selected ? 'todo' : null),
              ),
              FilterChip(
                label: const Text('In Progress'),
                selected: selectedStatus == 'in_progress',
                onSelected: (selected) => onStatusChanged(selected ? 'in_progress' : null),
              ),
              FilterChip(
                label: const Text('Blocked'),
                selected: selectedStatus == 'blocked',
                onSelected: (selected) => onStatusChanged(selected ? 'blocked' : null),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Priority',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: const Text('Low'),
                selected: selectedPriority == 'low',
                onSelected: (selected) => onPriorityChanged(selected ? 'low' : null),
              ),
              FilterChip(
                label: const Text('Medium'),
                selected: selectedPriority == 'medium',
                onSelected: (selected) => onPriorityChanged(selected ? 'medium' : null),
              ),
              FilterChip(
                label: const Text('High'),
                selected: selectedPriority == 'high',
                onSelected: (selected) => onPriorityChanged(selected ? 'high' : null),
              ),
              FilterChip(
                label: const Text('Urgent'),
                selected: selectedPriority == 'urgent',
                onSelected: (selected) => onPriorityChanged(selected ? 'urgent' : null),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Labels section
          if (workspaceId != null) ...[
            Text(
              'Labels',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _buildLabelFilters(context, ref),
          ],
        ],
      ),
    );
  }

  Widget _buildLabelFilters(BuildContext context, WidgetRef ref) {
    final labelRepository = ref.watch(labelRepositoryProvider);

    return StreamBuilder<List<dynamic>>(
      stream: labelRepository.watchLocalLabels(workspaceId!),
      builder: (context, snapshot) {
        final labels = snapshot.data ?? [];

        if (labels.isEmpty) {
          return Text(
            'No labels available',
            style: TextStyle(
              color: Theme.of(context).colorScheme.outline,
              fontSize: 14,
            ),
          );
        }

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: labels.map((label) {
            final isSelected = selectedLabelIds.contains(label.id);
            return FilterChip(
              label: Text(label.name),
              selected: isSelected,
              backgroundColor: label.colorValue.withValues(alpha: 0.2),
              selectedColor: label.colorValue,
              checkmarkColor: label.textColor,
              labelStyle: TextStyle(
                color: isSelected ? label.textColor : null,
              ),
              onSelected: (selected) {
                final newIds = List<String>.from(selectedLabelIds);
                if (selected) {
                  newIds.add(label.id);
                } else {
                  newIds.remove(label.id);
                }
                onLabelsChanged(newIds);
              },
            );
          }).toList(),
        );
      },
    );
  }
}

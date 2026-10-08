import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../../core/db/app_database.dart';
import '../providers/task_providers.dart';
import '../../../features/sync/providers/sync_providers.dart';
import 'package:intl/intl.dart';

/// S7.17: Task Detail Screen
/// Status change, inline edit with autosave, "Saved / Waiting to sync" indicator
class TaskDetailScreen extends ConsumerStatefulWidget {
  final String taskId;

  const TaskDetailScreen({
    super.key,
    required this.taskId,
  });

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Timer? _autosaveTimer;
  bool _hasUnsavedChanges = false;
  bool _isSaving = false;
  DateTime? _lastSaved;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _autosaveTimer?.cancel();
    super.dispose();
  }

  void _onFieldChanged() {
    setState(() {
      _hasUnsavedChanges = true;
    });

    // Debounce autosave (wait 2 seconds after user stops typing)
    _autosaveTimer?.cancel();
    _autosaveTimer = Timer(const Duration(seconds: 2), () {
      _autoSave();
    });
  }

  Future<void> _autoSave() async {
    if (!_hasUnsavedChanges) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await ref.read(taskRepositoryProvider).updateTask(
            widget.taskId,
            TasksCompanion(
              title: Value(_titleController.text.trim()),
              description: Value(_descriptionController.text.trim()),
            ),
          );

      if (mounted) {
        setState(() {
          _hasUnsavedChanges = false;
          _isSaving = false;
          _lastSaved = DateTime.now();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskAsync = ref.watch(watchTaskProvider(widget.taskId));
    
    // Check if task has pending sync
    final outboxAsync = ref.watch(outboxItemsProvider);
    final hasPendingSync = outboxAsync.maybeWhen(
      data: (items) => items.any((item) => item.entityId == widget.taskId),
      orElse: () => false,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          // Sync status indicator
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: _buildSyncStatus(hasPendingSync, theme),
            ),
          ),
        ],
      ),
      body: taskAsync.when(
        data: (task) {
          if (task == null) {
            return const Center(child: Text('Task not found'));
          }

          // Initialize controllers if empty
          if (_titleController.text.isEmpty) {
            _titleController.text = task.title;
            _descriptionController.text = task.description;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title (inline editable)
                TextField(
                  controller: _titleController,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Task title',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  onChanged: (_) => _onFieldChanged(),
                ),

                const SizedBox(height: 8),

                // Status chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildStatusChip(task, theme),
                    _buildPriorityChip(task, theme),
                    if (task.dueDate != null) _buildDueDateChip(task, theme),
                  ],
                ),

                const SizedBox(height: 24),

                // Status change dropdown
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.radio_button_checked),
                    title: const Text('Status'),
                    trailing: DropdownButton<String>(
                      value: task.status,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: 'backlog', child: Text('Backlog')),
                        DropdownMenuItem(value: 'todo', child: Text('To Do')),
                        DropdownMenuItem(
                            value: 'in_progress', child: Text('In Progress')),
                        DropdownMenuItem(
                            value: 'completed', child: Text('Completed')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          _changeStatus(value);
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Priority change dropdown
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.flag),
                    title: const Text('Priority'),
                    trailing: DropdownButton<String>(
                      value: task.priority,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: 'low', child: Text('Low')),
                        DropdownMenuItem(value: 'medium', child: Text('Medium')),
                        DropdownMenuItem(value: 'high', child: Text('High')),
                        DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          _changePriority(value);
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Due date
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Due Date'),
                    subtitle: Text(
                      task.dueDate != null
                          ? DateFormat('MMM d, yyyy h:mm a').format(task.dueDate!)
                          : 'No due date',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _changeDueDate(task.dueDate),
                  ),
                ),

                const SizedBox(height: 24),

                // Description (inline editable)
                Text(
                  'Description',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Add a description...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 8,
                  onChanged: (_) => _onFieldChanged(),
                ),

                const SizedBox(height: 24),

                // Metadata
                _buildMetadataSection(task, theme),

                const SizedBox(height: 24),

                // Subtasks section (placeholder for S7.18)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.checklist),
                    title: const Text('Subtasks'),
                    subtitle: const Text('Coming in S7.18'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Subtasks coming in S7.18')),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 8),

                // Comments section (placeholder for S7.19)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.comment),
                    title: const Text('Comments'),
                    subtitle: const Text('Coming in S7.19'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Comments coming in S7.19')),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 8),

                // Attachments section (placeholder for S7.20)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.attach_file),
                    title: const Text('Attachments'),
                    subtitle: const Text('Coming in S7.20'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Attachments coming in S7.20')),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildSyncStatus(bool hasPendingSync, ThemeData theme) {
    if (_isSaving) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
          const Text('Saving...', style: TextStyle(fontSize: 12)),
        ],
      );
    }

    if (hasPendingSync) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_upload, size: 16, color: Colors.orange[700]),
          const SizedBox(width: 4),
          const Text('Waiting to sync', style: TextStyle(fontSize: 12)),
        ],
      );
    }

    if (_lastSaved != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.green[700]),
          const SizedBox(width: 4),
          const Text('Saved', style: TextStyle(fontSize: 12)),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildStatusChip(Task task, ThemeData theme) {
    final color = _getStatusColor(task.status);
    final label = task.status.toUpperCase().replaceAll('_', ' ');

    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color, width: 1),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildPriorityChip(Task task, ThemeData theme) {
    final color = _getPriorityColor(task.priority);
    final label = task.priority.toUpperCase();

    return Chip(
      avatar: Icon(Icons.flag, size: 16, color: color),
      label: Text(label),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color, width: 1),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildDueDateChip(Task task, ThemeData theme) {
    final now = DateTime.now();
    final isOverdue = task.dueDate!.isBefore(now) && task.status != 'completed';
    final color = isOverdue ? Colors.red : Colors.blue;

    return Chip(
      avatar: Icon(Icons.calendar_today, size: 16, color: color),
      label: Text(DateFormat('MMM d').format(task.dueDate!)),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color, width: 1),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildMetadataSection(Task task, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Details',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildMetadataRow('Created', DateFormat('MMM d, yyyy').format(task.createdAt)),
        _buildMetadataRow('Updated', DateFormat('MMM d, yyyy').format(task.updatedAt)),
        if (task.completedAt != null)
          _buildMetadataRow(
              'Completed', DateFormat('MMM d, yyyy').format(task.completedAt!)),
      ],
    );
  }

  Widget _buildMetadataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
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

  Future<void> _changeStatus(String newStatus) async {
    await ref.read(taskRepositoryProvider).updateTask(
          widget.taskId,
          TasksCompanion(
            status: Value(newStatus),
            completedAt: Value(newStatus == 'completed' ? DateTime.now() : null),
          ),
        );

    setState(() {
      _lastSaved = DateTime.now();
    });
  }

  Future<void> _changePriority(String newPriority) async {
    await ref.read(taskRepositoryProvider).updateTask(
          widget.taskId,
          TasksCompanion(priority: Value(newPriority)),
        );

    setState(() {
      _lastSaved = DateTime.now();
    });
  }

  Future<void> _changeDueDate(DateTime? currentDueDate) async {
    final date = await showDatePicker(
      context: context,
      initialDate: currentDueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: currentDueDate != null
            ? TimeOfDay.fromDateTime(currentDueDate)
            : TimeOfDay.now(),
      );

      if (time != null) {
        final newDueDate = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );

        await ref.read(taskRepositoryProvider).updateTask(
              widget.taskId,
              TasksCompanion(dueDate: Value(newDueDate)),
            );

        setState(() {
          _lastSaved = DateTime.now();
        });
      }
    }
  }
}

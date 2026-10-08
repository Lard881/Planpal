import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../core/db/app_database.dart';
import '../providers/task_providers.dart';
import 'package:intl/intl.dart';

/// S7.16: New Task Screen/Dialog
/// All fields, attachments disabled offline with explanation
class NewTaskScreen extends ConsumerStatefulWidget {
  final String workspaceId;
  final Task? taskToEdit;

  const NewTaskScreen({
    super.key,
    required this.workspaceId,
    this.taskToEdit,
  });

  @override
  ConsumerState<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends ConsumerState<NewTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _status = 'todo';
  String _priority = 'medium';
  DateTime? _dueDate;
  String? _assigneeId;
  String? _labelId;
  bool _isOnline = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.taskToEdit != null) {
      _titleController.text = widget.taskToEdit!.title;
      _descriptionController.text = widget.taskToEdit!.description;
      _status = widget.taskToEdit!.status;
      _priority = widget.taskToEdit!.priority;
      _dueDate = widget.taskToEdit!.dueDate;
      _assigneeId = widget.taskToEdit!.assigneeId;
      _labelId = widget.taskToEdit!.labelId;
    }
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isOnline = connectivityResult != ConnectivityResult.none;
    });

    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((result) {
      if (mounted) {
        setState(() {
          _isOnline = result != ConnectivityResult.none;
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.taskToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'New Task'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveTask,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title *',
                  hintText: 'Enter task title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  if (value.length > 500) {
                    return 'Title must be less than 500 characters';
                  }
                  return null;
                },
                maxLength: 500,
              ),

              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter task description',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                maxLength: 5000,
              ),

              const SizedBox(height: 16),

              // Status
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'backlog', child: Text('Backlog')),
                  DropdownMenuItem(value: 'todo', child: Text('To Do')),
                  DropdownMenuItem(
                      value: 'in_progress', child: Text('In Progress')),
                  DropdownMenuItem(value: 'completed', child: Text('Completed')),
                ],
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Priority
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'low', child: Text('Low')),
                  DropdownMenuItem(value: 'medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'high', child: Text('High')),
                  DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
                ],
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Due Date
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Due Date'),
                subtitle: Text(
                  _dueDate != null
                      ? DateFormat('MMM d, yyyy h:mm a').format(_dueDate!)
                      : 'No due date set',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_dueDate != null)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _dueDate = null;
                          });
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: _pickDueDate,
                    ),
                  ],
                ),
              ),

              const Divider(),

              const SizedBox(height: 16),

              // Assignee (TODO: Add member picker)
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Assignee',
                  hintText: 'Select assignee',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.person),
                ),
                readOnly: true,
                onTap: () {
                  // TODO: S7.21 - Show member picker
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Member picker coming in S7.21')),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Label (TODO: Add label picker)
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Label',
                  hintText: 'Select label',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.label),
                ),
                readOnly: true,
                onTap: () {
                  // TODO: S7.21 - Show label picker
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Label picker coming in S7.21')),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Attachments (disabled offline)
              Card(
                color: _isOnline
                    ? theme.colorScheme.surfaceVariant
                    : theme.colorScheme.errorContainer.withOpacity(0.1),
                child: ListTile(
                  leading: Icon(
                    Icons.attach_file,
                    color: _isOnline ? null : theme.colorScheme.error,
                  ),
                  title: const Text('Attachments'),
                  subtitle: Text(
                    _isOnline
                        ? 'Add files to this task'
                        : 'Attachments require an internet connection',
                    style: TextStyle(
                      color: _isOnline ? null : theme.colorScheme.error,
                    ),
                  ),
                  trailing: Icon(
                    _isOnline ? Icons.chevron_right : Icons.wifi_off,
                    color: _isOnline ? null : theme.colorScheme.error,
                  ),
                  enabled: _isOnline,
                  onTap: _isOnline
                      ? () {
                          // TODO: S7.20 - Show attachment picker
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Attachment picker coming in S7.20')),
                          );
                        }
                      : null,
                ),
              ),

              if (!_isOnline) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.error.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: theme.colorScheme.error, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You\'re offline. The task will be saved locally and synced when you reconnect.',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveTask,
                  child: _isSaving
                      ? const CircularProgressIndicator()
                      : Text(isEditing ? 'Update Task' : 'Create Task'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: _dueDate != null
            ? TimeOfDay.fromDateTime(_dueDate!)
            : TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _dueDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final repository = ref.read(taskRepositoryProvider);

      if (widget.taskToEdit != null) {
        // Update existing task
        await repository.updateTask(
          widget.taskToEdit!.id,
          TasksCompanion(
            title: Value(_titleController.text.trim()),
            description: Value(_descriptionController.text.trim()),
            status: Value(_status),
            priority: Value(_priority),
            dueDate: Value(_dueDate),
            assigneeId: Value(_assigneeId),
            labelId: Value(_labelId),
          ),
        );
      } else {
        // Create new task
        await repository.createTask(
          workspaceId: widget.workspaceId,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          status: _status,
          priority: _priority,
          dueDate: _dueDate,
          assigneeId: _assigneeId,
          labelId: _labelId,
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.taskToEdit != null
                  ? 'Task updated successfully'
                  : 'Task created successfully',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}

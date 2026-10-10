import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';

/// Create/Edit Task Screen
/// Allows creating new tasks or editing existing ones with all fields
class CreateEditTaskScreen extends ConsumerStatefulWidget {
  final String? taskId; // null for create, set for edit
  
  const CreateEditTaskScreen({super.key, this.taskId});

  @override
  ConsumerState<CreateEditTaskScreen> createState() => _CreateEditTaskScreenState();
}

class _CreateEditTaskScreenState extends ConsumerState<CreateEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _selectedPriority = 'medium';
  String _selectedStatus = 'todo';
  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  String? _selectedAssignee;
  String? _selectedLabel;
  int? _reminderMinutes;
  bool _isLoading = false;

  bool get _isEditMode => widget.taskId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _loadTask();
    }
  }

  Future<void> _loadTask() async {
    // TODO: Load task data from repository
    setState(() {
      _titleController.text = 'Sample Task';
      _descriptionController.text = 'Task description here';
      _selectedPriority = 'high';
      _selectedStatus = 'in_progress';
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Save task to repository
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditMode ? 'Task updated!' : 'Task created!'),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save task: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Task' : 'New Task'),
        actions: [
          if (_isEditMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(),
              tooltip: 'Delete task',
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title *',
                hintText: 'What needs to be done?',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Add details...',
                prefixIcon: Icon(Icons.notes),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 24),

            // Priority
            _buildDropdownField(
              label: 'Priority',
              icon: Icons.flag,
              value: _selectedPriority,
              items: [
                _DropdownItem('high', 'High', AppColors.danger),
                _DropdownItem('medium', 'Medium', AppColors.warning),
                _DropdownItem('low', 'Low', AppColors.success),
              ],
              onChanged: (value) => setState(() => _selectedPriority = value!),
            ),
            const SizedBox(height: 16),

            // Status
            _buildDropdownField(
              label: 'Status',
              icon: Icons.circle,
              value: _selectedStatus,
              items: [
                _DropdownItem('todo', 'To Do', AppColors.textMuted),
                _DropdownItem('in_progress', 'In Progress', AppColors.primary),
                _DropdownItem('completed', 'Completed', AppColors.success),
              ],
              onChanged: (value) => setState(() => _selectedStatus = value!),
            ),
            const SizedBox(height: 16),

            // Due Date
            _buildDateTimeField(),
            const SizedBox(height: 16),

            // Assignee
            _buildAssigneeField(),
            const SizedBox(height: 16),

            // Label
            _buildLabelField(),
            const SizedBox(height: 16),

            // Reminder
            _buildReminderField(),
            const SizedBox(height: 32),

            // Offline Note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, 
                    size: 20, 
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Attachments can only be added when online',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton(
              onPressed: _isLoading ? null : _saveTask,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_isEditMode ? 'Update Task' : 'Create Task'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String value,
    required List<_DropdownItem> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item.value,
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: item.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(item.label),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDateTimeField() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _dueDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: _dueTime ?? TimeOfDay.now(),
          );
          setState(() {
            _dueDate = date;
            _dueTime = time;
          });
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Due Date & Time',
          prefixIcon: Icon(Icons.calendar_today),
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
        child: Text(
          _dueDate == null
              ? 'Not set'
              : '${_dueDate!.toString().split(' ')[0]} at ${_dueTime?.format(context) ?? 'No time'}',
        ),
      ),
    );
  }

  Widget _buildAssigneeField() {
    return InkWell(
      onTap: () {
        // TODO: Show assignee picker
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Assign to'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const CircleAvatar(child: Text('U')),
                  title: const Text('Unassigned'),
                  onTap: () {
                    setState(() => _selectedAssignee = null);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(child: Text('J')),
                  title: const Text('John Doe'),
                  onTap: () {
                    setState(() => _selectedAssignee = 'John Doe');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Assignee',
          prefixIcon: Icon(Icons.person),
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
        child: Text(_selectedAssignee ?? 'Unassigned'),
      ),
    );
  }

  Widget _buildLabelField() {
    return InkWell(
      onTap: () {
        // TODO: Show label picker
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Select Label'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppColors.danger,
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: const Text('Urgent'),
                  onTap: () {
                    setState(() => _selectedLabel = 'Urgent');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: const Text('Work'),
                  onTap: () {
                    setState(() => _selectedLabel = 'Work');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Label',
          prefixIcon: Icon(Icons.label),
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
        child: Text(_selectedLabel ?? 'None'),
      ),
    );
  }

  Widget _buildReminderField() {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Set Reminder'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('No reminder'),
                  onTap: () {
                    setState(() => _reminderMinutes = null);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('15 minutes before'),
                  onTap: () {
                    setState(() => _reminderMinutes = 15);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('1 hour before'),
                  onTap: () {
                    setState(() => _reminderMinutes = 60);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('1 day before'),
                  onTap: () {
                    setState(() => _reminderMinutes = 1440);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Reminder',
          prefixIcon: Icon(Icons.notifications),
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
        child: Text(_reminderMinutes == null
            ? 'None'
            : _reminderMinutes! < 60
                ? '$_reminderMinutes minutes before'
                : _reminderMinutes! < 1440
                    ? '${_reminderMinutes! ~/ 60} hour(s) before'
                    : '${_reminderMinutes! ~/ 1440} day(s) before'),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Delete task
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _DropdownItem {
  final String value;
  final String label;
  final Color color;

  _DropdownItem(this.value, this.label, this.color);
}

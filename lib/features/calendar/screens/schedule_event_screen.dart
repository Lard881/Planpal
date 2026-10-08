import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../tasks/repositories/task_repository.dart';
import '../../workspaces/providers/workspace_provider.dart';

class ScheduleEventScreen extends ConsumerStatefulWidget {
  final DateTime? initialDate;

  const ScheduleEventScreen({
    super.key,
    this.initialDate,
  });

  @override
  ConsumerState<ScheduleEventScreen> createState() => _ScheduleEventScreenState();
}

class _ScheduleEventScreenState extends ConsumerState<ScheduleEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  TimeOfDay? _endTime;
  TaskPriority _priority = TaskPriority.medium;
  bool _allDay = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _selectedTime = TimeOfDay.now();
    _endTime = TimeOfDay(
      hour: (TimeOfDay.now().hour + 1) % 24,
      minute: TimeOfDay.now().minute,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Event'),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveEvent,
              child: const Text('SAVE'),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Event Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Event Title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.event),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter an event title';
                }
                return null;
              },
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 24),

            // Date & Time Section
            Text(
              'Date & Time',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            // Date Picker
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Date'),
                subtitle: Text(_formatDate(_selectedDate)),
                onTap: _pickDate,
              ),
            ),
            const SizedBox(height: 8),

            // All Day Toggle
            Card(
              child: SwitchListTile(
                secondary: const Icon(Icons.access_time),
                title: const Text('All Day Event'),
                value: _allDay,
                onChanged: (value) {
                  setState(() {
                    _allDay = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 8),

            // Start Time
            if (!_allDay) ...[
              Card(
                child: ListTile(
                  leading: const Icon(Icons.schedule),
                  title: const Text('Start Time'),
                  subtitle: Text(_formatTime(_selectedTime)),
                  onTap: () => _pickTime(isStartTime: true),
                ),
              ),
              const SizedBox(height: 8),

              // End Time
              Card(
                child: ListTile(
                  leading: const Icon(Icons.schedule),
                  title: const Text('End Time'),
                  subtitle: Text(_formatTime(_endTime)),
                  onTap: () => _pickTime(isStartTime: false),
                ),
              ),
              const SizedBox(height: 24),
            ] else
              const SizedBox(height: 16),

            // Priority Section
            Text(
              'Priority',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _PriorityOption(
                      priority: TaskPriority.low,
                      isSelected: _priority == TaskPriority.low,
                      onTap: () => setState(() => _priority = TaskPriority.low),
                    ),
                    const Divider(),
                    _PriorityOption(
                      priority: TaskPriority.medium,
                      isSelected: _priority == TaskPriority.medium,
                      onTap: () => setState(() => _priority = TaskPriority.medium),
                    ),
                    const Divider(),
                    _PriorityOption(
                      priority: TaskPriority.high,
                      isSelected: _priority == TaskPriority.high,
                      onTap: () => setState(() => _priority = TaskPriority.high),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Save Button
            FilledButton.icon(
              onPressed: _isLoading ? null : _saveEvent,
              icon: const Icon(Icons.check),
              label: const Text('Schedule Event'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _pickTime({required bool isStartTime}) async {
    final time = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? (_selectedTime ?? TimeOfDay.now())
          : (_endTime ?? TimeOfDay.now()),
    );

    if (time != null) {
      setState(() {
        if (isStartTime) {
          _selectedTime = time;
          // Auto-adjust end time if needed
          if (_endTime != null) {
            final startMinutes = time.hour * 60 + time.minute;
            final endMinutes = _endTime!.hour * 60 + _endTime!.minute;
            if (endMinutes <= startMinutes) {
              _endTime = TimeOfDay(
                hour: (time.hour + 1) % 24,
                minute: time.minute,
              );
            }
          }
        } else {
          _endTime = time;
        }
      });
    }
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final currentWorkspace = ref.read(currentWorkspaceProvider);
      if (currentWorkspace == null) {
        throw Exception('No workspace selected');
      }

      // Combine date and time
      DateTime dueDate;
      if (_allDay) {
        dueDate = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
        );
      } else {
        dueDate = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime?.hour ?? 0,
          _selectedTime?.minute ?? 0,
        );
      }

      // Create task as event
      final taskCompanion = TasksCompanion.insert(
        workspaceId: currentWorkspace.id,
        title: _titleController.text.trim(),
        description: Value(_descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim()),
        status: TaskStatus.todo,
        priority: _priority,
        dueDate: Value(dueDate),
        tags: const Value([]), // Could add event tags
      );

      await ref.read(taskRepositoryProvider).createTask(taskCompanion);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event scheduled successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to schedule event: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == DateTime(now.year, now.month, now.day)) {
      return 'Today';
    } else if (dateOnly == tomorrow) {
      return 'Tomorrow';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Select time';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _PriorityOption extends StatelessWidget {
  final TaskPriority priority;
  final bool isSelected;
  final VoidCallback onTap;

  const _PriorityOption({
    required this.priority,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getPriorityColor(priority);
    final name = priority.name.toUpperCase();

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? color : Colors.grey,
            ),
            const SizedBox(width: 16),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              name,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }
}

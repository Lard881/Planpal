import 'package:flutter/material.dart';
import '../models/reminder_type.dart';

/// A widget for picking reminder settings (relative or absolute)
class ReminderPicker extends StatefulWidget {
  final ReminderData initialReminder;
  final DateTime? taskDueDate;
  final ValueChanged<ReminderData> onReminderChanged;

  const ReminderPicker({
    Key? key,
    required this.initialReminder,
    this.taskDueDate,
    required this.onReminderChanged,
  }) : super(key: key);

  @override
  State<ReminderPicker> createState() => _ReminderPickerState();
}

class _ReminderPickerState extends State<ReminderPicker> {
  late ReminderType _selectedType;
  int? _selectedMinutes;
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialReminder.type;
    _selectedMinutes = widget.initialReminder.minutesBefore;
    _selectedDateTime = widget.initialReminder.reminderAt;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Set Reminder',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Reminder type tabs
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SegmentedButton<ReminderType>(
            segments: [
              ButtonSegment(
                value: ReminderType.none,
                label: const Text('None'),
                icon: const Icon(Icons.notifications_off_outlined, size: 18),
              ),
              if (widget.taskDueDate != null)
                ButtonSegment(
                  value: ReminderType.relative,
                  label: const Text('Before Due'),
                  icon: const Icon(Icons.schedule_outlined, size: 18),
                ),
              ButtonSegment(
                value: ReminderType.absolute,
                label: const Text('Specific Time'),
                icon: const Icon(Icons.alarm_outlined, size: 18),
              ),
            ],
            selected: {_selectedType},
            onSelectionChanged: (Set<ReminderType> selection) {
              setState(() {
                _selectedType = selection.first;
                _updateReminder();
              });
            },
          ),
        ),

        // Reminder options based on type
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _buildReminderOptions(),
        ),

        const SizedBox(height: 16),

        // Action buttons
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () {
                  _updateReminder();
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReminderOptions() {
    switch (_selectedType) {
      case ReminderType.none:
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'No reminder will be sent for this task.',
            style: TextStyle(color: Colors.grey),
          ),
        );

      case ReminderType.relative:
        return _buildRelativeOptions();

      case ReminderType.absolute:
        return _buildAbsoluteOptions();
    }
  }

  Widget _buildRelativeOptions() {
    if (widget.taskDueDate == null) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Task needs a due date for relative reminders.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Remind me before due date:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: RelativeReminderPreset.values
              .where((preset) => preset != RelativeReminderPreset.custom)
              .map((preset) {
            final isSelected = _selectedMinutes == preset.minutes;
            return ChoiceChip(
              label: Text(preset.label),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedMinutes = preset.minutes;
                  });
                }
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        // Custom minutes option
        ListTile(
          leading: const Icon(Icons.edit_outlined),
          title: const Text('Custom'),
          subtitle: _selectedMinutes != null &&
                  RelativeReminderPreset.fromMinutes(_selectedMinutes!) == null
              ? Text(_formatMinutes(_selectedMinutes!))
              : const Text('Set custom time'),
          onTap: () => _showCustomMinutesPicker(),
        ),
      ],
    );
  }

  Widget _buildAbsoluteOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Remind me on:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        ListTile(
          leading: const Icon(Icons.calendar_today_outlined),
          title: Text(
            _selectedDateTime != null
                ? _formatDate(_selectedDateTime!)
                : 'Select date',
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _pickDate(),
        ),
        if (_selectedDateTime != null)
          ListTile(
            leading: const Icon(Icons.access_time_outlined),
            title: Text(_formatTime(_selectedDateTime!)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _pickTime(),
          ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initialDate = _selectedDateTime ?? now;
    
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 2)),
    );

    if (date != null) {
      setState(() {
        if (_selectedDateTime != null) {
          // Keep existing time
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            _selectedDateTime!.hour,
            _selectedDateTime!.minute,
          );
        } else {
          // Default to 9:00 AM
          _selectedDateTime = DateTime(date.year, date.month, date.day, 9, 0);
        }
      });
    }
  }

  Future<void> _pickTime() async {
    if (_selectedDateTime == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime!),
    );

    if (time != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime!.year,
          _selectedDateTime!.month,
          _selectedDateTime!.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  Future<void> _showCustomMinutesPicker() async {
    final controller = TextEditingController(
      text: _selectedMinutes?.toString() ?? '',
    );

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Custom Reminder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Minutes before due date',
                hintText: 'e.g., 45',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final minutes = int.tryParse(controller.text);
              if (minutes != null && minutes > 0) {
                Navigator.pop(context, minutes);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        _selectedMinutes = result;
      });
    }
  }

  void _updateReminder() {
    ReminderData reminder;
    
    switch (_selectedType) {
      case ReminderType.none:
        reminder = const ReminderData.none();
        break;
      case ReminderType.relative:
        reminder = ReminderData.relative(_selectedMinutes);
        break;
      case ReminderType.absolute:
        reminder = ReminderData.absolute(_selectedDateTime);
        break;
    }
    
    widget.onReminderChanged(reminder);
  }

  String _formatMinutes(int minutes) {
    if (minutes < 60) {
      return '$minutes minute${minutes == 1 ? '' : 's'} before';
    } else if (minutes < 1440) {
      final hours = minutes ~/ 60;
      return '$hours hour${hours == 1 ? '' : 's'} before';
    } else {
      final days = minutes ~/ 1440;
      return '$days day${days == 1 ? '' : 's'} before';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate == today) {
      return 'Today';
    } else if (targetDate == tomorrow) {
      return 'Tomorrow';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calendar_providers.dart';
import 'package:intl/intl.dart';

/// S8.8: Schedule Event Dialog
/// All fields, attendees, reminder
class ScheduleEventDialog extends ConsumerStatefulWidget {
  final String workspaceId;
  final DateTime initialDate;

  const ScheduleEventDialog({
    super.key,
    required this.workspaceId,
    required this.initialDate,
  });

  @override
  ConsumerState<ScheduleEventDialog> createState() => _ScheduleEventDialogState();
}

class _ScheduleEventDialogState extends ConsumerState<ScheduleEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  late DateTime _startsAt;
  late DateTime _endsAt;
  bool _allDay = false;
  Color _color = Colors.blue;
  int? _reminderMinutes;
  final List<String> _attendeeIds = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _startsAt = widget.initialDate;
    _endsAt = _startsAt.add(const Duration(hours: 1));
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

    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Schedule Event', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 24),

                // Title
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Event Title *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                  maxLength: 200,
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  maxLength: 2000,
                ),
                const SizedBox(height: 16),

                // Start date/time
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('Starts'),
                        subtitle: Text(DateFormat('MMM d, h:mm a').format(_startsAt)),
                        onTap: () => _pickDateTime(true),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('Ends'),
                        subtitle: Text(DateFormat('MMM d, h:mm a').format(_endsAt)),
                        onTap: () => _pickDateTime(false),
                      ),
                    ),
                  ],
                ),

                // All day
                CheckboxListTile(
                  title: const Text('All day event'),
                  value: _allDay,
                  onChanged: (value) => setState(() => _allDay = value ?? false),
                ),

                const SizedBox(height: 16),

                // Color picker
                Wrap(
                  spacing: 8,
                  children: [Colors.blue, Colors.red, Colors.green, Colors.purple, Colors.orange]
                      .map((c) => _buildColorChip(c))
                      .toList(),
                ),

                const SizedBox(height: 16),

                // Reminder
                DropdownButtonFormField<int?>(
                  value: _reminderMinutes,
                  decoration: const InputDecoration(
                    labelText: 'Reminder',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('No reminder')),
                    DropdownMenuItem(value: 15, child: Text('15 minutes before')),
                    DropdownMenuItem(value: 30, child: Text('30 minutes before')),
                    DropdownMenuItem(value: 60, child: Text('1 hour before')),
                    DropdownMenuItem(value: 1440, child: Text('1 day before')),
                  ],
                  onChanged: (value) => setState(() => _reminderMinutes = value),
                ),

                const SizedBox(height: 16),

                // Attendees (placeholder for S8.8 full implementation)
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Attendees',
                    hintText: 'Add attendees',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.person_add),
                  ),
                  readOnly: true,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Attendee picker coming soon')),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _isSaving ? null : _saveEvent,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorChip(Color color) {
    final isSelected = _color == color;
    return GestureDetector(
      onTap: () => setState(() => _color = color),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.black, width: 3) : null,
        ),
      ),
    );
  }

  Future<void> _pickDateTime(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStart ? _startsAt : _endsAt,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(isStart ? _startsAt : _endsAt),
      );

      if (time != null) {
        final newDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        setState(() {
          if (isStart) {
            _startsAt = newDateTime;
            if (_endsAt.isBefore(_startsAt)) {
              _endsAt = _startsAt.add(const Duration(hours: 1));
            }
          } else {
            _endsAt = newDateTime;
          }
        });
      }
    }
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      await ref.read(eventRepositoryProvider).createEvent(
            workspaceId: widget.workspaceId,
            title: _titleController.text.trim(),
            startsAt: _startsAt,
            endsAt: _endsAt,
            allDay: _allDay,
            description: _descriptionController.text.trim(),
            color: '#${_color.value.toRadixString(16).substring(2, 8)}',
            attendeeIds: _attendeeIds,
          );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event created')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}

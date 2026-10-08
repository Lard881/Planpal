import 'package:flutter/material.dart';

/// Date/Time picker field component
class DateTimePickerField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final bool isRequired;
  final String? errorText;
  final bool includeTime;

  const DateTimePickerField({
    super.key,
    required this.label,
    this.value,
    required this.onChanged,
    this.isRequired = false,
    this.errorText,
    this.includeTime = true,
  });

  Future<void> _pickDateTime(BuildContext context) async {
    final initialDate = value ?? DateTime.now();

    // Pick date
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    if (!includeTime) {
      onChanged(pickedDate);
      return;
    }

    // Pick time if needed
    if (context.mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null) {
        onChanged(DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        ));
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    if (includeTime) {
      return '${dateTime.month}/${dateTime.day}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
    return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // Picker field
        InkWell(
          onTap: () => _pickDateTime(context),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(
                color: errorText != null
                    ? theme.colorScheme.error
                    : theme.colorScheme.outline.withOpacity(0.3),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  includeTime ? Icons.event : Icons.calendar_today,
                  size: 20,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value != null
                        ? _formatDateTime(value!)
                        : includeTime
                            ? 'Select date and time'
                            : 'Select date',
                    style: TextStyle(
                      fontSize: 14,
                      color: value != null
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ),
                if (value != null)
                  GestureDetector(
                    onTap: () => onChanged(null),
                    child: Icon(
                      Icons.clear,
                      size: 20,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Error text
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            errorText!,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }
}

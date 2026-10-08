import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class RangeSelector extends StatelessWidget {
  final String currentRange;
  final Function(String) onRangeChanged;

  const RangeSelector({
    super.key,
    required this.currentRange,
    required this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Time Range:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: '7d',
                label: Text('7 Days'),
              ),
              ButtonSegment(
                value: '30d',
                label: Text('30 Days'),
              ),
              ButtonSegment(
                value: '90d',
                label: Text('90 Days'),
              ),
            ],
            selected: {currentRange},
            onSelectionChanged: (Set<String> selection) {
              onRangeChanged(selection.first);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primary;
                }
                return Colors.transparent;
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.onPrimary;
                }
                return AppColors.textPrimary;
              }),
            ),
          ),
        ),
      ],
    );
  }
}

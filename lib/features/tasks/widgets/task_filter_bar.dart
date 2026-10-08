import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/planpal_chip.dart';
import '../models/task.dart';

/// Desktop filter bar for task list
class TaskFilterBar extends StatelessWidget {
  final TaskView currentView;
  final String? selectedStatus;
  final String? selectedPriority;
  final ValueChanged<TaskView> onViewChanged;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onPriorityChanged;

  const TaskFilterBar({
    super.key,
    required this.currentView,
    this.selectedStatus,
    this.selectedPriority,
    required this.onViewChanged,
    required this.onStatusChanged,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        border: Border(
          bottom: BorderSide(color: AppColors.grey200),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // View selector
          Row(
            children: [
              Text(
                'View:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: TaskView.values.map((view) {
                    return PlanPalChip(
                      label: _getViewLabel(view),
                      icon: _getViewIcon(view),
                      isSelected: view == currentView,
                      onTap: () => onViewChanged(view),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Filters
          Row(
            children: [
              // Status filter
              Text(
                'Status:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(width: 12),
              _buildStatusDropdown(),
              
              const SizedBox(width: 24),
              
              // Priority filter
              Text(
                'Priority:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(width: 12),
              _buildPriorityDropdown(),
              
              const Spacer(),
              
              // Clear filters button
              if (selectedStatus != null || selectedPriority != null)
                TextButton.icon(
                  onPressed: () {
                    onStatusChanged(null);
                    onPriorityChanged(null);
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear Filters'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _getViewLabel(TaskView view) {
    switch (view) {
      case TaskView.all:
        return 'All Tasks';
      case TaskView.today:
        return 'Today';
      case TaskView.week:
        return 'This Week';
      case TaskView.overdue:
        return 'Overdue';
      case TaskView.completed:
        return 'Completed';
    }
  }

  IconData _getViewIcon(TaskView view) {
    switch (view) {
      case TaskView.all:
        return Icons.list;
      case TaskView.today:
        return Icons.today;
      case TaskView.week:
        return Icons.date_range;
      case TaskView.overdue:
        return Icons.warning;
      case TaskView.completed:
        return Icons.check_circle;
    }
  }

  Widget _buildStatusDropdown() {
    return DropdownButton<String?>(
      value: selectedStatus,
      hint: const Text('All Statuses'),
      underline: Container(),
      items: [
        const DropdownMenuItem(value: null, child: Text('All Statuses')),
        const DropdownMenuItem(value: 'todo', child: Text('To Do')),
        const DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
        const DropdownMenuItem(value: 'blocked', child: Text('Blocked')),
        const DropdownMenuItem(value: 'completed', child: Text('Completed')),
      ],
      onChanged: onStatusChanged,
    );
  }

  Widget _buildPriorityDropdown() {
    return DropdownButton<String?>(
      value: selectedPriority,
      hint: const Text('All Priorities'),
      underline: Container(),
      items: [
        const DropdownMenuItem(value: null, child: Text('All Priorities')),
        const DropdownMenuItem(value: 'low', child: Text('Low')),
        const DropdownMenuItem(value: 'medium', child: Text('Medium')),
        const DropdownMenuItem(value: 'high', child: Text('High')),
        const DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
      ],
      onChanged: onPriorityChanged,
    );
  }
}

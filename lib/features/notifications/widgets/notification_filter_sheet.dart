import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../models/notification.dart';

/// Bottom sheet for filtering notifications
class NotificationFilterSheet extends ConsumerStatefulWidget {
  final NotificationType? selectedType;
  final String? currentWorkspaceId;
  final Function(NotificationType?, String?) onApply;

  const NotificationFilterSheet({
    super.key,
    required this.selectedType,
    required this.currentWorkspaceId,
    required this.onApply,
  });

  @override
  ConsumerState<NotificationFilterSheet> createState() =>
      _NotificationFilterSheetState();
}

class _NotificationFilterSheetState
    extends ConsumerState<NotificationFilterSheet> {
  late NotificationType? _selectedType;
  late bool _filterByWorkspace;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.selectedType;
    _filterByWorkspace = widget.currentWorkspaceId != null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 16),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Filter Notifications',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clearFilters,
                  child: const Text('Clear'),
                ),
              ],
            ),
          ),

          const Divider(),

          // Filters
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notification type filter
                  Text(
                    'Notification Type',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  _buildTypeSelector(),

                  const SizedBox(height: 24),

                  // Workspace filter
                  SwitchListTile(
                    title: const Text('Current workspace only'),
                    subtitle: const Text(
                      'Show notifications from current workspace',
                    ),
                    value: _filterByWorkspace,
                    onChanged: (value) {
                      setState(() => _filterByWorkspace = value);
                    },
                  ),
                ],
              ),
            ),
          ),

          // Apply button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _applyFilters,
                child: const Text('Apply Filters'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildTypeChip(null, 'All'),
        ...NotificationType.values.map((type) => _buildTypeChip(
              type,
              _getTypeLabel(type),
            )),
      ],
    );
  }

  Widget _buildTypeChip(NotificationType? type, String label) {
    final isSelected = _selectedType == type;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedType = selected ? type : null;
        });
      },
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedType = null;
      _filterByWorkspace = false;
    });
  }

  void _applyFilters() {
    final workspaceId = _filterByWorkspace
        ? ref.read(currentWorkspaceIdProvider)
        : null;

    widget.onApply(_selectedType, workspaceId);
    Navigator.of(context).pop();
  }

  String _getTypeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.taskAssigned:
        return 'Task Assigned';
      case NotificationType.taskUpdated:
        return 'Task Updated';
      case NotificationType.taskComment:
        return 'Comments';
      case NotificationType.mention:
        return 'Mentions';
      case NotificationType.deadlineApproaching:
        return 'Deadlines';
      case NotificationType.taskOverdue:
        return 'Overdue';
      case NotificationType.eventReminder:
        return 'Events';
      case NotificationType.chatMessage:
        return 'Chat';
      case NotificationType.memberJoined:
        return 'New Members';
      case NotificationType.system:
        return 'System';
    }
  }
}

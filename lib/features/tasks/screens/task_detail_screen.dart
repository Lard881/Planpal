import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/planpal_button.dart';
import '../../../shared/widgets/planpal_text_field.dart';
import '../../../shared/widgets/planpal_chip.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../../core/db/app_database.dart';
import '../../comments/widgets/comments_section.dart';
import '../../activities/widgets/activity_timeline.dart';
import '../../labels/models/label.dart';
import '../../labels/widgets/label_chip.dart';
import '../../reminders/models/reminder_type.dart';
import '../../reminders/widgets/reminder_display.dart';
import '../../reminders/widgets/reminder_picker.dart';
import '../../attachments/widgets/widgets.dart';
import 'package:file_picker/file_picker.dart';

/// Task detail screen with inline editing
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
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isEditing = false;
  bool _isSaving = false;
  String? _selectedStatus;
  String? _selectedPriority;
  DateTime? _selectedDueDate;
  ReminderData _selectedReminder = const ReminderData.none();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskRepository = ref.watch(taskRepositoryProvider);
    final taskStream = taskRepository.watchTask(widget.taskId);

    return StreamBuilder<TaskData?>(
      stream: taskStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Task')),
            body: ErrorState(
              title: 'Failed to load task',
              message: snapshot.error.toString(),
            ),
          );
        }

        final task = snapshot.data;

        if (task == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Task')),
            body: const ErrorState(
              title: 'Task not found',
              message: 'This task may have been deleted',
            ),
          );
        }

        // Initialize controllers with task data
        if (!_isEditing) {
          _titleController.text = task.title;
          _descriptionController.text = task.description ?? '';
          _selectedStatus = task.status;
          _selectedPriority = task.priority;
          _selectedDueDate = task.dueDate;
          
          // Initialize reminder data
          if (task.reminderAt != null) {
            _selectedReminder = ReminderData.absolute(task.reminderAt);
          } else if (task.reminderMinutesBefore != null) {
            _selectedReminder = ReminderData.relative(task.reminderMinutesBefore);
          } else {
            _selectedReminder = const ReminderData.none();
          }
        }

        return LoadingOverlay(
          isLoading: _isSaving,
          message: 'Saving...',
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Task Details'),
              actions: [
                if (!_isEditing)
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => setState(() => _isEditing = true),
                  ),
                if (_isEditing)
                  TextButton(
                    onPressed: _saveChanges,
                    child: const Text('Save'),
                  ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      _confirmDelete(task);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete Task', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status indicator
                  _buildStatusIndicator(task),
                  const SizedBox(height: 24),

                  // Title
                  _buildTitleField(),
                  const SizedBox(height: 24),

                  // Description
                  _buildDescriptionField(),
                  const SizedBox(height: 24),

                  // Status
                  _buildStatusSelector(),
                  const SizedBox(height: 24),

                  // Priority
                  _buildPrioritySelector(),
                  const SizedBox(height: 24),

                  // Due date
                  _buildDueDatePicker(),
                  const SizedBox(height: 24),

                  // Labels
                  _buildLabelsSection(task),
                  const SizedBox(height: 24),

                  // Reminder
                  _buildReminderSection(task),
                  const SizedBox(height: 24),

                  // Attachments Section
                  _buildAttachmentsSection(),
                  const SizedBox(height: 24),

                  // Links Section
                  _buildLinksSection(),
                  const SizedBox(height: 24),

                  // Metadata
                  _buildMetadata(task),
                  const SizedBox(height: 32),

                  // Activity Timeline
                  _buildActivityTimeline(),
                  const SizedBox(height: 24),

                  // Comments Section
                  _buildCommentsSection(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActivityTimeline() {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.grey300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Activity',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ActivityTimeline(
              taskId: widget.taskId,
              compact: false,
              maxItems: 50,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.grey300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.comment, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Comments',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CommentsSection(taskId: widget.taskId),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(TaskData task) {
    final isCompleted = task.status == 'completed';
    final isOverdue = task.dueDate != null &&
        task.dueDate!.isBefore(DateTime.now()) &&
        !isCompleted;

    return Card(
      color: isCompleted
          ? AppColors.success.withOpacity(0.1)
          : isOverdue
              ? AppColors.error.withOpacity(0.1)
              : AppColors.info.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              isCompleted
                  ? Icons.check_circle
                  : isOverdue
                      ? Icons.warning
                      : Icons.info,
              color: isCompleted
                  ? AppColors.success
                  : isOverdue
                      ? AppColors.error
                      : AppColors.info,
            ),
            const SizedBox(width: 12),
            Text(
              isCompleted
                  ? 'Task completed'
                  : isOverdue
                      ? 'Task is overdue'
                      : 'Task in progress',
              style: TextStyle(
                color: isCompleted
                    ? AppColors.success
                    : isOverdue
                        ? AppColors.error
                        : AppColors.info,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        PlanPalTextField(
          controller: _titleController,
          hintText: 'Task title',
          enabled: _isEditing,
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        PlanPalTextField(
          controller: _descriptionController,
          hintText: 'Add a description...',
          maxLines: 5,
          enabled: _isEditing,
        ),
      ],
    );
  }

  Widget _buildStatusSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildStatusChip('todo', 'To Do', Icons.circle_outlined),
            _buildStatusChip('in_progress', 'In Progress', Icons.timelapse),
            _buildStatusChip('blocked', 'Blocked', Icons.block),
            _buildStatusChip('completed', 'Completed', Icons.check_circle),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status, String label, IconData icon) {
    final isSelected = _selectedStatus == status;
    return PlanPalChip(
      label: label,
      icon: icon,
      isSelected: isSelected,
      onTap: _isEditing ? () => setState(() => _selectedStatus = status) : null,
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPriorityChip('low', 'Low'),
            _buildPriorityChip('medium', 'Medium'),
            _buildPriorityChip('high', 'High'),
            _buildPriorityChip('urgent', 'Urgent'),
          ],
        ),
      ],
    );
  }

  Widget _buildPriorityChip(String priority, String label) {
    final isSelected = _selectedPriority == priority;
    return PriorityChip(
      priority: label,
      onTap: _isEditing ? () => setState(() => _selectedPriority = priority) : null,
    );
  }

  Widget _buildDueDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Due Date',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: _isEditing ? _pickDueDate : null,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: AppColors.grey600),
                const SizedBox(width: 12),
                Text(
                  _selectedDueDate != null
                      ? _formatDate(_selectedDueDate!)
                      : 'No due date',
                  style: TextStyle(color: AppColors.grey700),
                ),
                const Spacer(),
                if (_selectedDueDate != null && _isEditing)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => _selectedDueDate = null),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabelsSection(TaskData task) {
    final labelRepository = ref.watch(labelRepositoryProvider);
    final currentWorkspaceId = ref.watch(currentWorkspaceIdProvider);

    if (currentWorkspaceId == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Labels',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            if (_isEditing)
              TextButton.icon(
                onPressed: () => _showLabelPicker(currentWorkspaceId),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        StreamBuilder<List<Label>>(
          stream: labelRepository.watchLocalTaskLabels(widget.taskId),
          builder: (context, snapshot) {
            final labels = snapshot.data ?? [];

            if (labels.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.grey300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.label_outline, color: AppColors.grey600, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      _isEditing ? 'No labels - tap Add to create' : 'No labels',
                      style: TextStyle(color: AppColors.grey600),
                    ),
                  ],
                ),
              );
            }

            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: labels.map((label) {
                return LabelChip(
                  label: label,
                  onDeleted: _isEditing
                      ? () => _removeLabel(label.id)
                      : null,
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Future<void> _showLabelPicker(String workspaceId) async {
    final labelRepository = ref.read(labelRepositoryProvider);
    
    // Get current labels
    final currentLabels = await labelRepository
        .watchLocalTaskLabels(widget.taskId)
        .first;
    final currentLabelIds = currentLabels.map((l) => l.id).toList();

    if (!mounted) return;

    // Show bottom sheet with label picker
    final selectedIds = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return _LabelPickerSheet(
            workspaceId: workspaceId,
            taskId: widget.taskId,
            initialSelectedIds: currentLabelIds,
            scrollController: scrollController,
          );
        },
      ),
    );

    if (selectedIds != null) {
      await _updateTaskLabels(selectedIds);
    }
  }

  Future<void> _removeLabel(String labelId) async {
    try {
      final labelRepository = ref.read(labelRepositoryProvider);
      await labelRepository.removeLabelFromTask(
        taskId: widget.taskId,
        labelId: labelId,
      );
      await labelRepository.removeTaskLabelLocally(widget.taskId, labelId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove label: $e')),
        );
      }
    }
  }

  Future<void> _updateTaskLabels(List<String> labelIds) async {
    try {
      final labelRepository = ref.read(labelRepositoryProvider);
      await labelRepository.updateTaskLabels(
        taskId: widget.taskId,
        labelIds: labelIds,
      );
      await labelRepository.saveTaskLabelsLocally(widget.taskId, labelIds);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update labels: $e')),
        );
      }
    }
  }

  Widget _buildReminderSection(TaskData task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reminder',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        ReminderDisplay(
          reminder: _selectedReminder,
          taskDueDate: _selectedDueDate,
          isEditing: _isEditing,
          onTap: _isEditing ? () => _showReminderPicker(task) : null,
          onClear: _isEditing && _selectedReminder.type != ReminderType.none
              ? () {
                  setState(() {
                    _selectedReminder = const ReminderData.none();
                  });
                }
              : null,
        ),
      ],
    );
  }

  Future<void> _showReminderPicker(TaskData task) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ReminderPicker(
          initialReminder: _selectedReminder,
          taskDueDate: _selectedDueDate,
          onReminderChanged: (reminder) {
            setState(() {
              _selectedReminder = reminder;
            });
          },
        ),
      ),
    );
  }

  Widget _buildAttachmentsSection() {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.grey300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.attach_file, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Attachments',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                if (_isEditing)
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _handleAddAttachment,
                    tooltip: 'Add attachment',
                  ),
              ],
            ),
            const SizedBox(height: 16),
            AttachmentList(
              taskId: widget.taskId,
              showAddButton: false, // We're using the header button
              onAddPressed: _handleAddAttachment,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinksSection() {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.grey300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.link, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Links',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                if (_isEditing)
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _handleAddLink,
                    tooltip: 'Add link',
                  ),
              ],
            ),
            const SizedBox(height: 16),
            LinkList(
              taskId: widget.taskId,
              showAddButton: false, // We're using the header button
              onAddPressed: _handleAddLink,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAddAttachment() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'jpg', 'jpeg', 'png', 'gif', 'webp', 'svg',
        'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx',
        'txt', 'csv', 'json', 'zip',
      ],
    );

    if (result == null || !mounted) return;

    // Show upload dialog
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _UploadDialog(
        taskId: widget.taskId,
        files: result.files,
      ),
    );
  }

  Future<void> _handleAddLink() async {
    final urlController = TextEditingController();
    
    final url = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Link'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PlanPalTextField(
              controller: urlController,
              hintText: 'https://example.com',
              keyboardType: TextInputType.url,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final text = urlController.text.trim();
              if (text.isNotEmpty) {
                Navigator.of(context).pop(text);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (url == null || !mounted) return;

    try {
      final attachmentRepository = ref.read(attachmentRepositoryProvider);
      
      // Fetch metadata first
      final metadata = await attachmentRepository.fetchLinkMetadata(url);
      
      // Create the link
      await attachmentRepository.createLink(
        taskId: widget.taskId,
        url: url,
        title: metadata.title,
        description: metadata.description,
        faviconUrl: metadata.faviconUrl,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Link added successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add link: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Widget _buildMetadata(TaskData task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Details',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        _buildMetadataRow('Created', _formatDateTime(task.createdAt)),
        _buildMetadataRow('Updated', _formatDateTime(task.updatedAt)),
        if (task.completedAt != null)
          _buildMetadataRow('Completed', _formatDateTime(task.completedAt!)),
      ],
    );
  }

  Widget _buildMetadataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: AppColors.grey600),
            ),
          ),
          Text(
            value,
            style: TextStyle(color: AppColors.grey900, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (date != null) {
      setState(() => _selectedDueDate = date);
    }
  }

  Future<void> _saveChanges() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final taskRepository = ref.read(taskRepositoryProvider);
      
      await taskRepository.updateTask(
        widget.taskId,
        TasksCompanion(
          title: drift.Value(_titleController.text.trim()),
          description: drift.Value(_descriptionController.text.trim().isNotEmpty
              ? _descriptionController.text.trim()
              : null),
          status: drift.Value(_selectedStatus ?? 'todo'),
          priority: drift.Value(_selectedPriority),
          dueDate: drift.Value(_selectedDueDate),
          reminderMinutesBefore: drift.Value(_selectedReminder.minutesBefore),
          reminderAt: drift.Value(_selectedReminder.reminderAt),
        ),
      );

      setState(() {
        _isEditing = false;
        _isSaving = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task updated successfully')),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update task: $e')),
        );
      }
    }
  }

  Future<void> _confirmDelete(TaskData task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final taskRepository = ref.read(taskRepositoryProvider);
      await taskRepository.deleteTask(widget.taskId);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task deleted')),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    return '${date.month}/${date.day}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

/// Bottom sheet for picking labels
class _LabelPickerSheet extends ConsumerStatefulWidget {
  final String workspaceId;
  final String taskId;
  final List<String> initialSelectedIds;
  final ScrollController scrollController;

  const _LabelPickerSheet({
    required this.workspaceId,
    required this.taskId,
    required this.initialSelectedIds,
    required this.scrollController,
  });

  @override
  ConsumerState<_LabelPickerSheet> createState() => _LabelPickerSheetState();
}

class _LabelPickerSheetState extends ConsumerState<_LabelPickerSheet> {
  late List<String> _selectedIds;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _selectedIds = List.from(widget.initialSelectedIds);
  }

  @override
  Widget build(BuildContext context) {
    final labelRepository = ref.watch(labelRepositoryProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.grey300),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Labels',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _hasChanges
                          ? () => Navigator.of(context).pop(_selectedIds)
                          : null,
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Label list
          Expanded(
            child: StreamBuilder<List<Label>>(
              stream: labelRepository.watchLocalLabels(widget.workspaceId),
              builder: (context, snapshot) {
                final labels = snapshot.data ?? [];

                if (labels.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.label_outline,
                          size: 64,
                          color: AppColors.grey600,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No labels available',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create labels in workspace settings',
                          style: TextStyle(color: AppColors.grey600),
                        ),
                      ],
                    ),
                  );
                }

                return ListView(
                  controller: widget.scrollController,
                  padding: const EdgeInsets.all(16),
                  children: labels.map((label) {
                    final isSelected = _selectedIds.contains(label.id);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: CheckboxListTile(
                        value: isSelected,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              _selectedIds.add(label.id);
                            } else {
                              _selectedIds.remove(label.id);
                            }
                            _hasChanges = true;
                          });
                        },
                        title: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: label.colorValue,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              label.name,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Upload dialog for file attachments
class _UploadDialog extends ConsumerStatefulWidget {
  final String taskId;
  final List<PlatformFile> files;

  const _UploadDialog({
    required this.taskId,
    required this.files,
  });

  @override
  ConsumerState<_UploadDialog> createState() => _UploadDialogState();
}

class _UploadDialogState extends ConsumerState<_UploadDialog> {
  final Map<String, double> _uploadProgress = {};
  final Map<String, String?> _uploadErrors = {};
  bool _isUploading = true;
  int _completedCount = 0;

  @override
  void initState() {
    super.initState();
    _startUpload();
  }

  Future<void> _startUpload() async {
    final fileUploadService = ref.read(fileUploadServiceProvider);
    final thumbnailService = ref.read(thumbnailServiceProvider);
    final currentWorkspaceId = ref.read(currentWorkspaceIdProvider);

    if (currentWorkspaceId == null) {
      setState(() {
        _isUploading = false;
        for (final file in widget.files) {
          _uploadErrors[file.name] = 'No workspace selected';
        }
      });
      return;
    }

    for (final platformFile in widget.files) {
      if (platformFile.path == null) {
        setState(() {
          _uploadErrors[platformFile.name] = 'File path is null';
        });
        continue;
      }

      final file = File(platformFile.path!);

      try {
        // Initialize progress
        setState(() {
          _uploadProgress[platformFile.name] = 0.0;
        });

        // Generate thumbnail for images
        File? thumbnail;
        if (platformFile.extension != null &&
            ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(platformFile.extension!.toLowerCase())) {
          final thumbnailResult = await thumbnailService.generateThumbnail(file);
          thumbnail = thumbnailResult?.file;
        }

        // Upload file
        await fileUploadService.uploadFile(
          file: file,
          taskId: widget.taskId,
          workspaceId: currentWorkspaceId,
          thumbnailFile: thumbnail,
          onProgress: (progress) {
            if (mounted) {
              setState(() {
                _uploadProgress[platformFile.name] = progress;
              });
            }
          },
        );

        // Mark as complete
        setState(() {
          _uploadProgress[platformFile.name] = 1.0;
          _completedCount++;
        });
      } catch (e) {
        setState(() {
          _uploadErrors[platformFile.name] = e.toString();
        });
      }
    }

    setState(() {
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalFiles = widget.files.length;
    final hasErrors = _uploadErrors.values.any((error) => error != null);

    return AlertDialog(
      title: Text(_isUploading ? 'Uploading Files' : 'Upload Complete'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isUploading)
              Text('Uploading $_completedCount of $totalFiles files...'),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.files.length,
                itemBuilder: (context, index) {
                  final file = widget.files[index];
                  final progress = _uploadProgress[file.name] ?? 0.0;
                  final error = _uploadErrors[file.name];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              error != null
                                  ? Icons.error
                                  : progress >= 1.0
                                      ? Icons.check_circle
                                      : Icons.upload_file,
                              size: 20,
                              color: error != null
                                  ? theme.colorScheme.error
                                  : progress >= 1.0
                                      ? AppColors.success
                                      : AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                file.name,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (error == null)
                              Text(
                                '${(progress * 100).toInt()}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.grey600,
                                ),
                              ),
                          ],
                        ),
                        if (error == null) ...[
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: AppColors.grey300,
                          ),
                        ],
                        if (error != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            error,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.error,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (!_isUploading)
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(hasErrors ? 'Close' : 'Done'),
          ),
      ],
    );
  }
}

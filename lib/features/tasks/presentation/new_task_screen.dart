// app/lib/features/tasks/presentation/new_task_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/widgets/planpal_button.dart';
import '../../../core/widgets/planpal_text_field.dart';
import '../../workspaces/providers/workspace_providers.dart';
import '../data/task_repository.dart';
import '../providers/task_providers.dart';

class NewTaskScreen extends ConsumerStatefulWidget {
  const NewTaskScreen({super.key});
  @override
  ConsumerState<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends ConsumerState<NewTaskScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _subtaskCtrl = TextEditingController();
  String _priority = 'medium';
  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  String? _assigneeId;
  String? _labelId;
  final List<String> _subtasks = [];
  bool _loading = false;
  String? _titleError;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _subtaskCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_titleCtrl.text.trim().isEmpty) {
      setState(() => _titleError = 'Task name is required.');
      return;
    }
    setState(() { _loading = true; _titleError = null; });
    final wsId = ref.read(currentWorkspaceIdProvider) ?? '';

    DateTime? dueAt;
    if (_dueDate != null) {
      final t = _dueTime ?? const TimeOfDay(hour: 10, minute: 0);
      dueAt = DateTime(_dueDate!.year, _dueDate!.month, _dueDate!.day,
          t.hour, t.minute);
    }

    final (_, err) = await ref.read(taskRepositoryProvider).createTask(
      wsId,
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      priority: _priority,
      dueAt: dueAt,
      assigneeId: _assigneeId,
      labelId: _labelId,
      subtaskTitles: _subtasks,
    );

    if (!mounted) return;
    setState(() => _loading = false);
    if (err == null) {
      ref.invalidate(taskListProvider(wsId));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isDesktop = context.isDesktopLayout;

    if (isDesktop) {
      return Scaffold(
        backgroundColor: c.scrim,
        body: Center(
          child: Container(
            width: 480,
            constraints: const BoxConstraints(maxHeight: 700),
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(AppRadius.panel),
            ),
            child: Column(
              children: [
                // Dialog header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
                  child: Row(
                    children: [
                      Text('New Task',
                        style: AppText.cardTitle.copyWith(color: c.textPrimary)),
                      const Spacer(),
                      IconButton(
                        icon: Icon(LucideIcons.x, color: c.textMuted),
                        onPressed: () => context.pop(),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: _buildForm(c),
                )),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: PlanPalButton(
                    label: 'Create Task',
                    onPressed: _submit,
                    loading: _loading,
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Mobile full screen
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: c.surface,
                        borderRadius: BorderRadius.circular(AppRadius.control),
                        border: Border.all(color: c.border),
                      ),
                      child: Icon(LucideIcons.x, size: 18, color: c.textPrimary),
                    ),
                  ),
                  Expanded(
                    child: Center(child: Text('New Task',
                      style: AppText.cardTitle.copyWith(color: c.textPrimary))),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildForm(c),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: PlanPalButton(
                label: 'Create Task',
                onPressed: _submit,
                loading: _loading,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(PlanPalColors c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PlanPalTextField(
          label: 'Task Name',
          hint: 'Plan team offsite',
          controller: _titleCtrl,
          errorText: _titleError,
          textInputAction: TextInputAction.next,
          onChanged: (_) => setState(() => _titleError = null),
        ),
        const SizedBox(height: 16),
        PlanPalTextField(
          label: 'Description',
          hint: 'Venue, date, agenda...',
          controller: _descCtrl,
          maxLines: 3,
          textInputAction: TextInputAction.newline,
        ),
        const SizedBox(height: 16),
        // Due Date + Time side by side
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Due Date',
                    style: AppText.label.copyWith(color: c.textPrimary)),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: _dueDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (d != null) setState(() => _dueDate = d);
                    },
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: c.surfaceAlt,
                        borderRadius: BorderRadius.circular(AppRadius.control),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _dueDate != null
                              ? '${_months[_dueDate!.month - 1]} ${_dueDate!.day}'
                              : 'Oct 18',
                          style: AppText.body.copyWith(
                            color: _dueDate != null ? c.textPrimary : c.textMuted),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Time',
                    style: AppText.label.copyWith(color: c.textPrimary)),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () async {
                      final t = await showTimePicker(
                        context: context,
                        initialTime: _dueTime ?? const TimeOfDay(hour: 10, minute: 0),
                      );
                      if (t != null) setState(() => _dueTime = t);
                    },
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: c.surfaceAlt,
                        borderRadius: BorderRadius.circular(AppRadius.control),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _dueTime != null
                              ? _dueTime!.format(context)
                              : '10:00 AM',
                          style: AppText.body.copyWith(
                            color: _dueTime != null ? c.textPrimary : c.textMuted),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Priority segmented control
        Text('Priority', style: AppText.label.copyWith(color: c.textPrimary)),
        const SizedBox(height: 6),
        _PrioritySegmented(
          value: _priority,
          onChanged: (v) => setState(() => _priority = v),
        ),
        const SizedBox(height: 16),
        // Assignee
        Text('Assignee', style: AppText.label.copyWith(color: c.textPrimary)),
        const SizedBox(height: 6),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: c.surfaceAlt,
            borderRadius: BorderRadius.circular(AppRadius.control),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Assignee (optional)',
              style: AppText.body.copyWith(color: c.textMuted)),
          ),
        ),
        const SizedBox(height: 16),
        // Label
        Text('Label', style: AppText.label.copyWith(color: c.textPrimary)),
        const SizedBox(height: 6),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: c.surfaceAlt,
            borderRadius: BorderRadius.circular(AppRadius.control),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Label (optional)',
              style: AppText.body.copyWith(color: c.textMuted)),
          ),
        ),
        const SizedBox(height: 16),
        // Subtasks
        ..._subtasks.map((s) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(LucideIcons.circle, size: 16, color: c.textMuted),
              const SizedBox(width: 8),
              Expanded(child: Text(s, style: AppText.body.copyWith(color: c.textPrimary))),
              GestureDetector(
                onTap: () => setState(() => _subtasks.remove(s)),
                child: Icon(LucideIcons.x, size: 16, color: c.textMuted),
              ),
            ],
          ),
        )),
        // Add subtask dashed button
        GestureDetector(
          onTap: () => _showAddSubtaskDialog(),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              border: Border.all(color: c.border, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(AppRadius.control),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.plus, size: 16, color: c.textMuted),
                const SizedBox(width: 8),
                Text('Add Subtask',
                  style: AppText.bodyMedium.copyWith(color: c.textMuted)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAddSubtaskDialog() {
    _subtaskCtrl.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add subtask'),
        content: TextField(
          controller: _subtaskCtrl,
          decoration: const InputDecoration(hintText: 'Subtask title'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (_subtaskCtrl.text.trim().isNotEmpty) {
                setState(() => _subtasks.add(_subtaskCtrl.text.trim()));
              }
              Navigator.pop(context);
            },
            child: const Text('Add')),
        ],
      ),
    );
  }

  static const _months = ['Jan','Feb','Mar','Apr','May','Jun',
                           'Jul','Aug','Sep','Oct','Nov','Dec'];
}

class _PrioritySegmented extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const _PrioritySegmented({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    const options = ['high', 'medium', 'low'];
    const labels = ['High', 'Medium', 'Low'];

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: c.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.control),
      ),
      child: Row(
        children: List.generate(3, (i) {
          final selected = value == options[i];
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(options[i]),
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: selected ? c.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.control - 3),
                  boxShadow: selected ? AppShadows.card(Brightness.light) : null,
                ),
                child: Center(
                  child: Text(labels[i],
                    style: AppText.bodyMedium.copyWith(
                      color: selected ? c.textPrimary : c.textMuted,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    )),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

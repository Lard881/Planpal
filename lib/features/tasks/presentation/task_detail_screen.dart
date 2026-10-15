// app/lib/features/tasks/presentation/task_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/chips.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/l10n/app_localizations.dart';
import '../data/task_repository.dart';
import '../models/task_model.dart';
import '../providers/task_providers.dart';

class TaskDetailScreen extends ConsumerWidget {
  final String taskId;
  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final taskAsync = ref.watch(taskDetailProvider(taskId));

    return taskAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        body: ErrorState(message: e.toString())),
      data: (task) {
        if (task == null) {
          return Scaffold(
            body: EmptyState(
              icon: LucideIcons.alertCircle,
              title: l10n.emptyStateTaskNotFound));
        }
        return _TaskDetailContent(task: task);
      },
    );
  }
}

class _TaskDetailContent extends ConsumerStatefulWidget {
  final TaskModel task;
  const _TaskDetailContent({required this.task});
  @override
  ConsumerState<_TaskDetailContent> createState() => _TaskDetailContentState();
}

class _TaskDetailContentState extends ConsumerState<_TaskDetailContent> {
  late TextEditingController _commentCtrl;

  @override
  void initState() {
    super.initState();
    _commentCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendComment() async {
    final body = _commentCtrl.text.trim();
    if (body.isEmpty) return;
    await ref.read(taskRepositoryProvider).addComment(widget.task.id, body);
    _commentCtrl.clear();
    ref.invalidate(taskDetailProvider(widget.task.id));
  }

  Future<void> _toggleSubtask(SubtaskModel subtask) async {
    await ref.read(taskRepositoryProvider)
        .updateSubtask(subtask.id, isDone: !subtask.isDone);
    ref.invalidate(taskDetailProvider(widget.task.id));
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final doneCount = task.subtasks.where((s) => s.isDone).length;
    final totalCount = task.subtasks.length;
    final isOverdue = task.isOverdue;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
                        child: Icon(LucideIcons.arrowLeft,
                          size: 18, color: c.textPrimary),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(l10n.tasksDetailTitle,
                          style: AppText.cardTitle.copyWith(color: c.textPrimary))),
                    ),
                    Icon(LucideIcons.moreHorizontal, color: c.textMuted),
                  ],
                ),
              ),
            ),
            // Priority + Status chips
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    PriorityChip(priority: task.priority),
                    const SizedBox(width: 8),
                    StatusChip(status: isOverdue ? 'overdue' : task.status),
                  ],
                ),
              ),
            ),
            // Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(task.title,
                  style: AppText.pageTitle.copyWith(color: c.textPrimary)),
              ),
            ),
            // Due date
            if (task.dueAt != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    'Due ${_formatDue(task.dueAt!)}',
                    style: AppText.body.copyWith(
                      color: isOverdue ? c.danger : c.textMuted)),
                ),
              ),
            // Description card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.tasksDescriptionLabel,
                        style: AppText.cardTitle.copyWith(color: c.textPrimary)),
                      const SizedBox(height: 8),
                      Text(
                        task.description.isEmpty
                            ? l10n.tasksNoDescription
                            : task.description,
                        style: AppText.body.copyWith(
                          color: task.description.isEmpty
                              ? c.textMuted : c.textPrimary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Subtasks card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            totalCount > 0
                                ? l10n.tasksSubtasksLabel(doneCount, totalCount)
                                : l10n.tasksSubtasksTitle,
                            style: AppText.cardTitle.copyWith(color: c.textPrimary)),
                          const Spacer(),
                          TextButton(
                            onPressed: () => _showAddSubtask(context, l10n),
                            child: Text(l10n.btnAdd,
                              style: AppText.bodyMedium.copyWith(color: c.primary)),
                          ),
                        ],
                      ),
                      if (totalCount > 0) ...[
                        const SizedBox(height: 8),
                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: totalCount > 0 ? doneCount / totalCount : 0,
                            minHeight: 6,
                            backgroundColor: c.surfaceAlt,
                            valueColor: AlwaysStoppedAnimation(c.primary),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...task.subtasks.map((s) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onTap: () => _toggleSubtask(s),
                            child: Row(
                              children: [
                                Container(
                                  width: 22, height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: s.isDone ? c.primary : Colors.transparent,
                                    border: s.isDone ? null : Border.all(
                                      color: c.border, width: 1.5),
                                  ),
                                  child: s.isDone
                                      ? const Icon(Icons.check, size: 12,
                                          color: Colors.white)
                                      : null,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(s.title,
                                    style: AppText.body.copyWith(
                                      color: s.isDone ? c.textMuted : c.textPrimary,
                                      decoration: s.isDone
                                          ? TextDecoration.lineThrough : null,
                                    )),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            // Assignee & Label card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.tasksAssigneeLabel,
                        style: AppText.cardTitle.copyWith(color: c.textPrimary)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          if (task.assigneeId != null) ...[
                            Avatar(
                              userId: task.assigneeId!,
                              name: task.assigneeName ?? '',
                              avatarUrl: task.assigneeAvatarUrl,
                              size: 32,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(task.assigneeName ?? l10n.tasksUnassigned,
                                style: AppText.bodyMedium.copyWith(
                                  color: c.textPrimary))),
                          ] else
                            Expanded(
                              child: Text(l10n.tasksUnassigned,
                                style: AppText.body.copyWith(color: c.textMuted))),
                          if (task.labelId != null && task.labelName != null)
                            LabelChip(
                              name: task.labelName!,
                              color: task.labelColor != null
                                  ? _parseColor(task.labelColor!)
                                  : PlanPalColors.light.primary,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Comments card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.tasksComments,
                        style: AppText.cardTitle.copyWith(color: c.textPrimary)),
                      const SizedBox(height: 12),
                      ...task.comments.map((comment) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: c.surfaceAlt,
                            borderRadius: BorderRadius.circular(AppRadius.control),
                          ),
                          child: Text(comment.body,
                            style: AppText.body.copyWith(color: c.textPrimary)),
                        ),
                      )),
                      const SizedBox(height: 8),
                      // Comment composer
                      Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: c.surfaceAlt,
                          borderRadius: BorderRadius.circular(AppRadius.control),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _commentCtrl,
                                decoration: InputDecoration(
                                  hintText: l10n.fieldWriteComment,
                                  hintStyle: AppText.body.copyWith(color: c.textMuted),
                                  border: InputBorder.none,
                                  filled: false,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onSubmitted: (_) => _sendComment(),
                              ),
                            ),
                            IconButton(
                              icon: Icon(LucideIcons.sendHorizonal,
                                size: 18, color: c.primary),
                              onPressed: _sendComment,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSubtask(BuildContext context, AppLocalizations l10n) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.tasksAddSubtask),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(hintText: l10n.fieldSubtaskHint),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.btnCancel)),
          FilledButton(
            onPressed: () async {
              if (ctrl.text.trim().isNotEmpty) {
                await ref.read(taskRepositoryProvider)
                    .addSubtask(widget.task.id, ctrl.text.trim());
                ref.invalidate(taskDetailProvider(widget.task.id));
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(l10n.btnAdd)),
        ],
      ),
    );
  }

  String _formatDue(DateTime dt) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final ampm = dt.hour < 12 ? 'AM' : 'PM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day} · $hour:$min $ampm';
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceAll('#', '0xFF')));
    } catch (_) {
      return PlanPalColors.light.primary;
    }
  }
}

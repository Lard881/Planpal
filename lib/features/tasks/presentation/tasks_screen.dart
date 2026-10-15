// app/lib/features/tasks/presentation/tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/widgets/chips.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/planpal_button.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../workspaces/providers/workspace_providers.dart';
import '../models/task_model.dart';
import '../providers/task_providers.dart';
import '../data/task_repository.dart';

class TasksScreen extends ConsumerWidget {
  final String? taskId;
  final bool showNewTask;
  const TasksScreen({super.key, this.taskId, this.showNewTask = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = context.isDesktopLayout;
    final wsId = ref.watch(currentWorkspaceIdProvider) ?? '';

    if (isDesktop) return _DesktopTasksScreen(workspaceId: wsId);
    return _MobileTasksScreen(workspaceId: wsId);
  }
}

// ── MOBILE ────────────────────────────────────────────────────────────────────
class _MobileTasksScreen extends ConsumerStatefulWidget {
  final String workspaceId;
  const _MobileTasksScreen({required this.workspaceId});
  @override
  ConsumerState<_MobileTasksScreen> createState() => _MobileTasksScreenState();
}

class _MobileTasksScreenState extends ConsumerState<_MobileTasksScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(taskListProvider(widget.workspaceId));
    final notifier = ref.read(taskListProvider(widget.workspaceId).notifier);

    return Scaffold(
      backgroundColor: c.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/tasks/new'),
        backgroundColor: c.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => notifier.load(refresh: true),
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Text(l10n.tasksTitle,
                        style: AppText.pageTitleMobile.copyWith(color: c.textPrimary)),
                      const Spacer(),
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: c.surface,
                          borderRadius: BorderRadius.circular(AppRadius.control),
                          border: Border.all(color: c.border),
                        ),
                        child: Icon(LucideIcons.slidersHorizontal,
                          size: 18, color: c.textMuted),
                      ),
                    ],
                  ),
                ),
              ),
              // Search
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: c.surfaceAlt,
                      borderRadius: BorderRadius.circular(AppRadius.control),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Icon(LucideIcons.search, size: 16, color: c.textMuted),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            decoration: InputDecoration(
                              hintText: l10n.searchTasks,
                              hintStyle: AppText.body.copyWith(color: c.textMuted),
                              border: InputBorder.none,
                              filled: false,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (q) => notifier.setFilter(
                              state.filter.copyWith(q: q.isEmpty ? null : q)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Filter chips
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _ViewChip(l10n.all, 'all', state.filter.view, notifier, state),
                        const SizedBox(width: 8),
                        _ViewChip(l10n.today, 'today', state.filter.view, notifier, state),
                        const SizedBox(width: 8),
                        _ViewChip(l10n.thisWeek, 'week', state.filter.view, notifier, state),
                        const SizedBox(width: 8),
                        _ViewChip(l10n.overdue, 'overdue', state.filter.view, notifier, state),
                      ],
                    ),
                  ),
                ),
              ),
              // Task list
              if (state.loading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()))
              else if (state.tasks.isEmpty)
                SliverFillRemaining(
                  child: EmptyState(
                    icon: LucideIcons.checkSquare,
                    title: state.filter.hasActiveFilters
                        ? l10n.tasksNoResultsFilters
                        : l10n.emptyStateNoTasks,
                    subtitle: state.filter.hasActiveFilters
                        ? null : l10n.emptyStateNoTasksDesc,
                    actionLabel: state.filter.hasActiveFilters ? l10n.tasksClearFilters : null,
                    onAction: state.filter.hasActiveFilters
                        ? () => notifier.setFilter(state.filter.cleared()) : null,
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _MobileTaskTile(
                          task: state.tasks[i],
                          onComplete: () =>
                            notifier.quickComplete(state.tasks[i].id),
                          onTap: () =>
                            context.push('/tasks/${state.tasks[i].id}'),
                        ),
                      ),
                      childCount: state.tasks.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewChip extends StatelessWidget {
  final String label;
  final String value;
  final String current;
  final TaskListNotifier notifier;
  final TaskListState state;
  const _ViewChip(this.label, this.value, this.current, this.notifier, this.state);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final selected = current == value;
    return GestureDetector(
      onTap: () => notifier.setFilter(state.filter.copyWith(view: value)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? c.primary : c.surfaceAlt,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
          style: AppText.bodyMedium.copyWith(
            color: selected ? Colors.white : c.textMuted)),
      ),
    );
  }
}

class _MobileTaskTile extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onComplete;
  final VoidCallback onTap;
  const _MobileTaskTile({
    required this.task, required this.onComplete, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final dateStr = taskDateLabel(task);
    final isOverdue = task.isOverdue;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: c.border),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: onComplete,
              child: Container(
                width: 24, height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: task.isCompleted ? c.success : Colors.transparent,
                  border: task.isCompleted
                      ? null
                      : Border.all(color: c.border, width: 1.5),
                ),
                child: task.isCompleted
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title,
                    style: AppText.bodyStrong.copyWith(
                      color: task.isCompleted ? c.textMuted : c.textPrimary,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (dateStr.isNotEmpty)
                    RichText(
                      text: TextSpan(
                        style: AppText.caption.copyWith(color: c.textMuted),
                        children: [
                          if (isOverdue) ...[
                            TextSpan(text: '${l10n.yesterday} · ',
                              style: TextStyle(color: c.danger)),
                            TextSpan(text: l10n.statusOverdue,
                              style: TextStyle(color: c.danger)),
                          ] else
                            TextSpan(text: dateStr),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (!task.isCompleted) PriorityChip(priority: task.priority),
          ],
        ),
      ),
    );
  }
}

// ── DESKTOP ───────────────────────────────────────────────────────────────────
class _DesktopTasksScreen extends ConsumerWidget {
  final String workspaceId;
  const _DesktopTasksScreen({required this.workspaceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(taskListProvider(workspaceId));
    final notifier = ref.read(taskListProvider(workspaceId).notifier);
    final hasSelection = state.selectedIds.isNotEmpty;

    return Scaffold(
      backgroundColor: c.background,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.tasksTitle,
                        style: AppText.pageTitle.copyWith(color: c.textPrimary)),
                      Text('${state.tasks.length} tasks · ${state.dueToday} due today',
                        style: AppText.body.copyWith(color: c.textMuted)),
                    ],
                  ),
                ),
                PlanPalButton(
                  label: l10n.btnAddTask,
                  toolbar: true,
                  onPressed: () => context.push('/tasks/new'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Filter row
            Row(
              children: [
                _DesktopFilterDropdown(
                  label: 'Status',
                  value: state.filter.status ?? 'All',
                  options: const ['All', 'todo', 'in_progress', 'completed'],
                  onChanged: (v) => notifier.setFilter(state.filter.copyWith(
                    status: v == 'All' ? null : v, clearStatus: v == 'All')),
                ),
                const SizedBox(width: 8),
                _DesktopFilterDropdown(
                  label: 'Priority',
                  value: state.filter.priority ?? 'All',
                  options: const ['All', 'high', 'medium', 'low'],
                  onChanged: (v) => notifier.setFilter(state.filter.copyWith(
                    priority: v == 'All' ? null : v, clearPriority: v == 'All')),
                ),
                const SizedBox(width: 8),
                _DesktopFilterDropdown(
                  label: 'Assignee',
                  value: 'All',
                  options: const ['All'],
                  onChanged: (_) {},
                ),
                const SizedBox(width: 8),
                _DesktopFilterDropdown(
                  label: 'Sort',
                  value: state.filter.sort,
                  options: const ['due_date', 'priority', 'created', 'title'],
                  onChanged: (v) => notifier.setFilter(
                    state.filter.copyWith(sort: v)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Bulk bar
            if (hasSelection)
              _BulkBar(
                count: state.selectedIds.length,
                onMarkComplete: notifier.bulkComplete,
                onDelete: () async {
                  final confirm = await _confirmBulkDelete(context, l10n);
                  if (confirm) notifier.bulkDelete();
                },
              ),
            if (hasSelection) const SizedBox(height: 12),
            // Table
            Expanded(
              child: state.loading
                  ? const Center(child: CircularProgressIndicator())
                  : state.tasks.isEmpty
                      ? EmptyState(
                          icon: LucideIcons.checkSquare,
                          title: state.filter.hasActiveFilters
                              ? l10n.tasksNoResultsFilters
                              : l10n.emptyStateNoTasks,
                          actionLabel: state.filter.hasActiveFilters
                              ? l10n.tasksClearFilters : l10n.btnAddTask,
                          onAction: state.filter.hasActiveFilters
                              ? () => notifier.setFilter(state.filter.cleared())
                              : () => context.push('/tasks/new'),
                        )
                      : _TaskTable(
                          tasks: state.tasks,
                          selectedIds: state.selectedIds,
                          onToggleSelect: notifier.toggleSelect,
                          onTap: (id) => context.push('/tasks/$id'),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _confirmBulkDelete(BuildContext context, AppLocalizations l10n) async {
    return await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.confirmDeleteTasksTitle),
        content: Text(l10n.confirmDeleteBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.btnCancel)),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: context.colors.danger),
            child: Text(l10n.btnDelete)),
        ],
      ),
    ) ?? false;
  }
}

class _BulkBar extends StatelessWidget {
  final int count;
  final VoidCallback onMarkComplete;
  final VoidCallback onDelete;
  const _BulkBar({required this.count, required this.onMarkComplete, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          Container(
            width: 22, height: 22,
            decoration: BoxDecoration(
              color: c.primary, shape: BoxShape.circle),
            child: const Icon(Icons.check, size: 14, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Text('$count task${count == 1 ? '' : 's'} selected',
            style: AppText.bodyMedium.copyWith(color: c.textPrimary)),
          const Spacer(),
          OutlinedButton(
            onPressed: onMarkComplete,
            style: OutlinedButton.styleFrom(
              foregroundColor: c.primary,
              side: BorderSide(color: c.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.control)),
            ),
            child: Text(l10n.btnMarkComplete),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: onDelete,
            style: OutlinedButton.styleFrom(
              foregroundColor: c.danger,
              side: BorderSide(color: c.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.control)),
            ),
            child: Text(l10n.btnDeleteSelected),
          ),
        ],
      ),
    );
  }
}

class _TaskTable extends StatelessWidget {
  final List<TaskModel> tasks;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggleSelect;
  final ValueChanged<String> onTap;
  const _TaskTable({
    required this.tasks, required this.selectedIds,
    required this.onToggleSelect, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: c.border),
      ),
      child: Column(
        children: [
          // Header — column labels kept as-is per prompt
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const SizedBox(width: 36),
                Expanded(flex: 5, child: Text(l10n.fieldTaskName,
                  style: AppText.caption.copyWith(color: c.textMuted))),
                Expanded(flex: 2, child: Text(l10n.fieldAssignee,
                  style: AppText.caption.copyWith(color: c.textMuted))),
                Expanded(flex: 2, child: Text(l10n.fieldDueDate,
                  style: AppText.caption.copyWith(color: c.textMuted))),
                Expanded(flex: 1, child: Text(l10n.fieldPriority,
                  style: AppText.caption.copyWith(color: c.textMuted))),
                Expanded(flex: 2, child: Text(l10n.navTasks,
                  style: AppText.caption.copyWith(color: c.textMuted))),
              ],
            ),
          ),
          Divider(height: 1, color: c.border),
          Expanded(
            child: ListView.separated(
              itemCount: tasks.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: c.border),
              itemBuilder: (ctx, i) => _TableRow(
                task: tasks[i],
                selected: selectedIds.contains(tasks[i].id),
                onToggleSelect: () => onToggleSelect(tasks[i].id),
                onTap: () => onTap(tasks[i].id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  final TaskModel task;
  final bool selected;
  final VoidCallback onToggleSelect;
  final VoidCallback onTap;
  const _TableRow({
    required this.task, required this.selected,
    required this.onToggleSelect, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final isOverdue = task.isOverdue;
    final statusStr = isOverdue ? 'overdue' : task.status;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: selected ? c.primarySoft : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            GestureDetector(
              onTap: onToggleSelect,
              child: Container(
                width: 22, height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? c.primary : Colors.transparent,
                  border: selected ? null : Border.all(
                    color: c.presenceOffline, width: 1.5),
                ),
                child: selected
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(flex: 5,
              child: Text(task.title,
                style: AppText.bodyMedium.copyWith(color: c.textPrimary))),
            Expanded(flex: 2,
              child: task.assigneeId != null
                  ? Row(children: [
                      Avatar(
                        userId: task.assigneeId!,
                        name: task.assigneeName ?? '',
                        avatarUrl: task.assigneeAvatarUrl,
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Flexible(child: Text(task.assigneeName ?? '',
                        style: AppText.body.copyWith(color: c.textPrimary),
                        overflow: TextOverflow.ellipsis)),
                    ])
                  : Text('—', style: AppText.body.copyWith(color: c.textMuted))),
            Expanded(flex: 2,
              child: Text(
                task.dueAt != null ? _formatDate(task.dueAt!) : '—',
                style: AppText.body.copyWith(
                  color: isOverdue ? c.danger : c.textPrimary))),
            Expanded(flex: 1, child: PriorityChip(priority: task.priority)),
            Expanded(flex: 2, child: StatusChip(status: statusStr)),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[dt.month - 1]} ${dt.day}';
  }
}

class _DesktopFilterDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  const _DesktopFilterDropdown({
    required this.label, required this.value,
    required this.options, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final displayValue = value == 'in_progress' ? l10n.statusInProgress
        : value == 'due_date' ? 'Due date'
        : value[0].toUpperCase() + value.substring(1);

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.control),
        border: Border.all(color: c.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: Icon(LucideIcons.chevronDown, size: 14, color: c.textMuted),
          style: AppText.bodyMedium.copyWith(color: c.textPrimary),
          hint: Text('$label: $displayValue',
            style: AppText.bodyMedium.copyWith(color: c.textPrimary)),
          items: options.map((o) {
            final display = o == 'in_progress' ? l10n.statusInProgress
                : o == 'due_date' ? 'Due date'
                : o[0].toUpperCase() + o.substring(1);
            return DropdownMenuItem(value: o, child: Text(display));
          }).toList(),
          onChanged: (v) { if (v != null) onChanged(v); },
          selectedItemBuilder: (_) => options.map((o) {
            final display = o == 'in_progress' ? l10n.statusInProgress
                : o == 'due_date' ? 'Due date'
                : o[0].toUpperCase() + o.substring(1);
            return Text('$label: $display',
              style: AppText.bodyMedium.copyWith(color: c.textPrimary));
          }).toList(),
        ),
      ),
    );
  }
}

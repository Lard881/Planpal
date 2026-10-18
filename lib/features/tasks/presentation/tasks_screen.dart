// app/lib/features/tasks/presentation/tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/network/app_failure.dart';
import '../../../core/network/failure_localizer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/connectivity/connectivity_service.dart';
import '../../../core/widgets/chips.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/planpal_button.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../workspaces/providers/workspace_providers.dart';
import '../models/task_model.dart';
import '../models/task_permissions.dart';
import '../providers/task_providers.dart';
import '../data/task_repository.dart';

class TasksScreen extends ConsumerStatefulWidget {
  final String? taskId;
  final bool showNewTask;
  final String initialView;
  const TasksScreen({
    super.key,
    this.taskId,
    this.showNewTask = false,
    this.initialView = 'all',
  });

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      const validViews = {'all', 'today', 'week', 'overdue'};
      final initialView = validViews.contains(widget.initialView)
          ? widget.initialView
          : 'all';
      if (initialView == 'all') return;
      final workspaceId = ref.read(currentWorkspaceIdProvider) ?? '';
      ref
          .read(taskListProvider(workspaceId).notifier)
          .setFilter(TaskFilter(view: initialView));
    });
  }

  @override
  Widget build(BuildContext context) {
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
  static const _swipeHintStorageKey = 'planpal_tasks_swipe_hint_dismissed';
  static const _storage = FlutterSecureStorage();

  final _searchCtrl = TextEditingController();
  bool _swipeHintPreferenceLoaded = false;
  bool _swipeHintDismissed = false;

  @override
  void initState() {
    super.initState();
    _loadSwipeHintPreference();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadSwipeHintPreference() async {
    try {
      final dismissed = await _storage.read(key: _swipeHintStorageKey);
      if (!mounted) return;
      setState(() {
        _swipeHintDismissed = dismissed == 'true';
        _swipeHintPreferenceLoaded = true;
      });
    } on PlatformException catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'task swipe hint preference',
        ),
      );
      if (!mounted) return;
      setState(() => _swipeHintPreferenceLoaded = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).errorGeneric)),
      );
    }
  }

  Future<void> _dismissSwipeHint() async {
    try {
      await _storage.write(key: _swipeHintStorageKey, value: 'true');
      if (!mounted) return;
      setState(() => _swipeHintDismissed = true);
    } on PlatformException catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'task swipe hint preference',
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).errorGeneric)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(taskListProvider(widget.workspaceId));
    final notifier = ref.read(taskListProvider(widget.workspaceId).notifier);
    final role = ref.watch(currentWorkspaceProvider)?.role;
    final userId = Supabase.instance.client.auth.currentUser?.id;
    final canCreateTask = ref
        .watch(currentRolePermissionsProvider)
        .canCreateTask;

    return Scaffold(
      backgroundColor: c.background,
      floatingActionButton: canCreateTask
          ? FloatingActionButton(
              onPressed: () => context.push('/tasks/new'),
              backgroundColor: c.primary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
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
                      Text(
                        l10n.tasksTitle,
                        style: AppText.pageTitleMobile.copyWith(
                          color: c.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: l10n.tasksFilterTitle,
                        onPressed: () => _showFilters(state, notifier),
                        style: IconButton.styleFrom(
                          fixedSize: const Size(40, 40),
                          padding: EdgeInsets.zero,
                          backgroundColor: c.surface,
                          side: BorderSide(color: c.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppRadius.control,
                            ),
                          ),
                        ),
                        icon: Icon(
                          LucideIcons.slidersHorizontal,
                          size: 18,
                          color: c.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Search
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
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
                              hintStyle: AppText.body.copyWith(
                                color: c.textMuted,
                              ),
                              border: InputBorder.none,
                              filled: false,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (q) => notifier.setFilter(
                              state.filter.copyWith(
                                q: q.isEmpty ? null : q,
                                setQ: true,
                              ),
                            ),
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
                        _ViewChip(
                          l10n.all,
                          'all',
                          state.filter.view,
                          notifier,
                          state,
                        ),
                        const SizedBox(width: 8),
                        _ViewChip(
                          l10n.today,
                          'today',
                          state.filter.view,
                          notifier,
                          state,
                        ),
                        const SizedBox(width: 8),
                        _ViewChip(
                          l10n.thisWeek,
                          'week',
                          state.filter.view,
                          notifier,
                          state,
                        ),
                        const SizedBox(width: 8),
                        _ViewChip(
                          l10n.overdue,
                          'overdue',
                          state.filter.view,
                          notifier,
                          state,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_swipeHintPreferenceLoaded &&
                  !_swipeHintDismissed &&
                  state.tasks.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
                      decoration: BoxDecoration(
                        color: c.surfaceAlt,
                        borderRadius: BorderRadius.circular(AppRadius.control),
                      ),
                      child: Row(
                        children: [
                          Icon(LucideIcons.info, size: 18, color: c.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              l10n.tasksSwipeHint,
                              style: AppText.caption.copyWith(
                                color: c.textPrimary,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: l10n.tasksDismissSwipeHint,
                            onPressed: _dismissSwipeHint,
                            icon: Icon(
                              LucideIcons.x,
                              size: 18,
                              color: c.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              // Task list
              if (state.error != null && state.tasks.isNotEmpty)
                SliverToBoxAdapter(
                  child: _TaskListError(
                    message: state.error,
                    onRetry: () => notifier.load(refresh: true),
                  ),
                ),
              if (state.loading && state.tasks.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.error != null && state.tasks.isEmpty)
                SliverFillRemaining(
                  child: _TaskListError(
                    message: state.error,
                    onRetry: () => notifier.load(refresh: true),
                  ),
                )
              else if (state.tasks.isEmpty)
                SliverFillRemaining(
                  child: EmptyState(
                    icon: LucideIcons.checkSquare,
                    title: state.filter.hasActiveFilters
                        ? l10n.tasksNoResultsFilters
                        : l10n.emptyStateNoTasks,
                    subtitle: state.filter.hasActiveFilters
                        ? null
                        : l10n.emptyStateNoTasksDesc,
                    actionLabel: state.filter.hasActiveFilters
                        ? l10n.tasksClearFilters
                        : null,
                    onAction: state.filter.hasActiveFilters
                        ? () {
                            _searchCtrl.clear();
                            notifier.setFilter(state.filter.cleared());
                          }
                        : null,
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) {
                        if (i == state.tasks.length) {
                          if (state.loadingMore) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return Center(
                            child: TextButton(
                              onPressed: notifier.loadMore,
                              child: Text(
                                state.error == null
                                    ? AppLocalizations.of(ctx).tasksLoadMore
                                    : AppLocalizations.of(ctx).btnRetry,
                              ),
                            ),
                          );
                        }
                        final task = state.tasks[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _MobileTaskTile(
                            task: task,
                            permissions: TaskPermissions.forTask(
                              role: role,
                              userId: userId,
                              task: task,
                            ),
                            onComplete: () => notifier.quickComplete(task.id),
                            onTap: () => context.push('/tasks/${task.id}'),
                            onDelete: () =>
                                _deleteMobileTask(task, notifier, l10n),
                          ),
                        );
                      },
                      childCount:
                          state.tasks.length + (state.cursor != null ? 1 : 0),
                      addAutomaticKeepAlives: false,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showFilters(
    TaskListState state,
    TaskListNotifier notifier,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _MobileTaskFilterSheet(
        workspaceId: widget.workspaceId,
        initialFilter: state.filter,
        onApply: notifier.setFilter,
      ),
    );
  }

  Future<void> _deleteMobileTask(
    TaskModel task,
    TaskListNotifier notifier,
    AppLocalizations l10n,
  ) async {
    final failure = await ref.read(taskRepositoryProvider).deleteTask(task.id);
    if (!mounted) return;
    await notifier.load(refresh: true);
    if (!mounted) return;

    final isQueuedFailure =
        failure is NetworkFailure ||
        failure is ServerUnreachableFailure ||
        failure is TimeoutFailure;
    final message = failure == null
        ? l10n.syncSaved
        : isQueuedFailure
        ? l10n.syncWaitingShort
        : failure.localizedMessage(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _MobileTaskFilterSheet extends ConsumerStatefulWidget {
  final String workspaceId;
  final TaskFilter initialFilter;
  final ValueChanged<TaskFilter> onApply;

  const _MobileTaskFilterSheet({
    required this.workspaceId,
    required this.initialFilter,
    required this.onApply,
  });

  @override
  ConsumerState<_MobileTaskFilterSheet> createState() =>
      _MobileTaskFilterSheetState();
}

class _MobileTaskFilterSheetState
    extends ConsumerState<_MobileTaskFilterSheet> {
  late TaskFilter _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.tasksFilterTitle,
              style: AppText.cardTitle.copyWith(color: c.textPrimary),
            ),
            const SizedBox(height: 20),
            _TaskFilterDropdown(
              label: l10n.fieldStatus,
              value: _filter.status ?? 'all',
              options: [
                (value: 'all', label: l10n.all),
                (value: 'todo', label: l10n.statusTodo),
                (value: 'in_progress', label: l10n.statusInProgress),
                (value: 'completed', label: l10n.statusCompleted),
              ],
              onChanged: (value) => setState(
                () => _filter = _filter.copyWith(
                  status: value == 'all' ? null : value,
                  clearStatus: value == 'all',
                ),
              ),
            ),
            const SizedBox(height: 16),
            _TaskFilterDropdown(
              label: l10n.fieldPriority,
              value: _filter.priority ?? 'all',
              options: [
                (value: 'all', label: l10n.all),
                (value: 'high', label: l10n.priorityHigh),
                (value: 'medium', label: l10n.priorityMedium),
                (value: 'low', label: l10n.priorityLow),
              ],
              onChanged: (value) => setState(
                () => _filter = _filter.copyWith(
                  priority: value == 'all' ? null : value,
                  clearPriority: value == 'all',
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.fieldAssignee,
              style: AppText.label.copyWith(color: c.textPrimary),
            ),
            const SizedBox(height: 6),
            _AssigneeFilterDropdown(
              workspaceId: widget.workspaceId,
              selectedId: _filter.assigneeId,
              onChanged: (assigneeId) => setState(
                () => _filter = _filter.copyWith(
                  assigneeId: assigneeId,
                  clearAssignee: assigneeId == null,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _TaskFilterDropdown(
              label: l10n.tasksSortBy,
              value: _filter.sort,
              options: [
                (value: 'due_at', label: l10n.tasksSortDueDate),
                (value: 'priority', label: l10n.fieldPriority),
                (value: 'created_at', label: l10n.tasksSortCreated),
                (value: 'title', label: l10n.tasksSortTitle),
              ],
              onChanged: (sort) =>
                  setState(() => _filter = _filter.copyWith(sort: sort)),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                TextButton(
                  onPressed: () => setState(
                    () => _filter = _filter.copyWith(
                      view: 'all',
                      sort: 'due_at',
                      clearStatus: true,
                      clearPriority: true,
                      clearAssignee: true,
                    ),
                  ),
                  child: Text(l10n.tasksClearFilters),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () {
                    widget.onApply(_filter);
                    Navigator.pop(context);
                  },
                  child: Text(l10n.btnApply),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskFilterDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<({String value, String label})> options;
  final ValueChanged<String> onChanged;

  const _TaskFilterDropdown({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.label.copyWith(color: c.textPrimary)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: c.surfaceAlt,
            borderRadius: BorderRadius.circular(AppRadius.control),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              items: options
                  .map(
                    (option) => DropdownMenuItem(
                      value: option.value,
                      child: Text(option.label),
                    ),
                  )
                  .toList(),
              onChanged: (nextValue) {
                if (nextValue != null) onChanged(nextValue);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _ViewChip extends StatelessWidget {
  final String label;
  final String value;
  final String current;
  final TaskListNotifier notifier;
  final TaskListState state;
  const _ViewChip(
    this.label,
    this.value,
    this.current,
    this.notifier,
    this.state,
  );

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
        child: Text(
          label,
          style: AppText.bodyMedium.copyWith(
            color: selected ? Colors.white : c.textMuted,
          ),
        ),
      ),
    );
  }
}

class _MobileTaskTile extends StatelessWidget {
  final TaskModel task;
  final TaskPermissions permissions;
  final VoidCallback onComplete;
  final VoidCallback onTap;
  final Future<void> Function() onDelete;
  const _MobileTaskTile({
    required this.task,
    required this.permissions,
    required this.onComplete,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final dateStr = taskDateLabel(task);
    final isOverdue = task.isOverdue;

    return Dismissible(
      key: ValueKey(task.id),
      direction: permissions.canEditFields && permissions.canDelete
          ? DismissDirection.horizontal
          : permissions.canEditFields
          ? DismissDirection.startToEnd
          : permissions.canDelete
          ? DismissDirection.endToStart
          : DismissDirection.none,
      background: _SwipeActionBackground(
        label: l10n.tasksSwipeEdit,
        icon: LucideIcons.pencil,
        color: c.primary,
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: _SwipeActionBackground(
        label: l10n.btnDelete,
        icon: LucideIcons.trash2,
        color: c.danger,
        alignment: Alignment.centerRight,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onTap();
          return false;
        }
        return await showDialog<bool>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: Text(l10n.confirmDeleteTaskTitle),
                content: Text(l10n.confirmDeleteBody),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: Text(l10n.btnCancel),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(dialogContext, true),
                    style: FilledButton.styleFrom(backgroundColor: c.danger),
                    child: Text(l10n.btnDelete),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
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
                  width: 24,
                  height: 24,
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
                    Text(
                      task.title,
                      style: AppText.bodyStrong.copyWith(
                        color: task.isCompleted ? c.textMuted : c.textPrimary,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    if (dateStr.isNotEmpty)
                      RichText(
                        text: TextSpan(
                          style: AppText.caption.copyWith(color: c.textMuted),
                          children: [
                            if (isOverdue) ...[
                              TextSpan(
                                text: '${l10n.yesterday} · ',
                                style: TextStyle(color: c.danger),
                              ),
                              TextSpan(
                                text: l10n.statusOverdue,
                                style: TextStyle(color: c.danger),
                              ),
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
      ),
    );
  }
}

class _SwipeActionBackground extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Alignment alignment;

  const _SwipeActionBackground({
    required this.label,
    required this.icon,
    required this.color,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final isLeft = alignment == Alignment.centerLeft;
    return Container(
      alignment: alignment,
      padding: EdgeInsets.only(left: isLeft ? 24 : 0, right: isLeft ? 0 : 24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 4),
          Text(label, style: AppText.caption.copyWith(color: Colors.white)),
        ],
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
    final permissions = ref.watch(currentRolePermissionsProvider);

    void showBulkResult(BulkTaskActionResult result) {
      final message = result.queuedOffline
          ? l10n.syncWaitingShort
          : result.failure != null
          ? l10n.tasksBulkActionFailed
          : result.failedIds.isNotEmpty
          ? l10n.tasksBulkPartialFailure
          : l10n.syncSaved;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }

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
                      Text(
                        l10n.tasksTitle,
                        style: AppText.pageTitle.copyWith(color: c.textPrimary),
                      ),
                      Text(
                        l10n.tasksDueToday(
                          state.totalCount ?? state.tasks.length,
                          state.dueToday,
                        ),
                        style: AppText.body.copyWith(color: c.textMuted),
                      ),
                    ],
                  ),
                ),
                if (permissions.canCreateTask)
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
                  label: l10n.tasksFilterStatus,
                  value: state.filter.status ?? 'All',
                  options: const ['All', 'todo', 'in_progress', 'completed'],
                  onChanged: (v) => notifier.setFilter(
                    state.filter.copyWith(
                      status: v == 'All' ? null : v,
                      clearStatus: v == 'All',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _DesktopFilterDropdown(
                  label: l10n.tasksFilterPriority,
                  value: state.filter.priority ?? 'All',
                  options: const ['All', 'high', 'medium', 'low'],
                  onChanged: (v) => notifier.setFilter(
                    state.filter.copyWith(
                      priority: v == 'All' ? null : v,
                      clearPriority: v == 'All',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _AssigneeFilterDropdown(
                  workspaceId: workspaceId,
                  selectedId: state.filter.assigneeId,
                  onChanged: (assigneeId) => notifier.setFilter(
                    state.filter.copyWith(
                      assigneeId: assigneeId,
                      clearAssignee: assigneeId == null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _DesktopFilterDropdown(
                  label: l10n.tasksFilterSort,
                  value: state.filter.sort,
                  options: const ['due_at', 'priority', 'created_at', 'title'],
                  onChanged: (v) =>
                      notifier.setFilter(state.filter.copyWith(sort: v)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Bulk bar
            if (hasSelection)
              _BulkBar(
                count: state.selectedIds.length,
                canDelete: !permissions.isGuest,
                onMarkComplete: () async {
                  final result = await notifier.bulkComplete();
                  if (context.mounted) showBulkResult(result);
                },
                onDelete: () async {
                  final confirm = await _confirmBulkDelete(context, l10n);
                  if (!confirm || !context.mounted) return;
                  final result = await notifier.bulkDelete();
                  if (context.mounted) showBulkResult(result);
                },
              ),
            if (hasSelection) const SizedBox(height: 12),
            // Table
            if (state.error != null && state.tasks.isNotEmpty)
              _TaskListError(
                message: state.error,
                onRetry: () => notifier.load(refresh: true),
              ),
            Expanded(
              child: state.loading && state.tasks.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : state.error != null && state.tasks.isEmpty
                  ? _TaskListError(
                      message: state.error,
                      onRetry: () => notifier.load(refresh: true),
                    )
                  : state.tasks.isEmpty
                  ? EmptyState(
                      icon: LucideIcons.checkSquare,
                      title: state.filter.hasActiveFilters
                          ? l10n.tasksNoResultsFilters
                          : l10n.emptyStateNoTasks,
                      actionLabel: state.filter.hasActiveFilters
                          ? l10n.tasksClearFilters
                          : l10n.btnAddTask,
                      onAction: state.filter.hasActiveFilters
                          ? () => notifier.setFilter(state.filter.cleared())
                          : () => context.push('/tasks/new'),
                    )
                  : _TaskTable(
                      tasks: state.tasks,
                      selectedIds: state.selectedIds,
                      onToggleSelect: notifier.toggleSelect,
                      onTap: (id) => context.push('/tasks/$id'),
                      hasMore: state.cursor != null,
                      loadingMore: state.loadingMore,
                      hasError: state.error != null,
                      onLoadMore: notifier.loadMore,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _confirmBulkDelete(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(l10n.confirmDeleteTasksTitle),
            content: Text(l10n.confirmDeleteBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.btnCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                style: FilledButton.styleFrom(
                  backgroundColor: context.colors.danger,
                ),
                child: Text(l10n.btnDelete),
              ),
            ],
          ),
        ) ??
        false;
  }
}

class _BulkBar extends StatelessWidget {
  final int count;
  final bool canDelete;
  final VoidCallback onMarkComplete;
  final VoidCallback onDelete;
  const _BulkBar({
    required this.count,
    required this.canDelete,
    required this.onMarkComplete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(color: c.primary, shape: BoxShape.circle),
            child: const Icon(Icons.check, size: 14, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Text(
            l10n.tasksSelected(count),
            style: AppText.bodyMedium.copyWith(color: c.textPrimary),
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: onMarkComplete,
            style: OutlinedButton.styleFrom(
              foregroundColor: c.primary,
              side: BorderSide(color: c.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.control),
              ),
            ),
            child: Text(l10n.btnMarkComplete),
          ),
          if (canDelete) ...[
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: onDelete,
              style: OutlinedButton.styleFrom(
                foregroundColor: c.danger,
                side: BorderSide(color: c.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.control),
                ),
              ),
              child: Text(l10n.btnDeleteSelected),
            ),
          ],
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
  final bool hasMore;
  final bool loadingMore;
  final bool hasError;
  final VoidCallback onLoadMore;
  const _TaskTable({
    required this.tasks,
    required this.selectedIds,
    required this.onToggleSelect,
    required this.onTap,
    required this.hasMore,
    required this.loadingMore,
    required this.hasError,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                const SizedBox(width: 36),
                Expanded(
                  flex: 5,
                  child: Text(
                    l10n.fieldTaskName,
                    style: AppText.caption.copyWith(color: c.textMuted),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    l10n.fieldAssignee,
                    style: AppText.caption.copyWith(color: c.textMuted),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    l10n.fieldDueDate,
                    style: AppText.caption.copyWith(color: c.textMuted),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    l10n.fieldPriority,
                    style: AppText.caption.copyWith(color: c.textMuted),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    l10n.fieldStatus,
                    style: AppText.caption.copyWith(color: c.textMuted),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: c.border),
          Expanded(
            child: ListView.separated(
              itemCount: tasks.length + (hasMore ? 1 : 0),
              separatorBuilder: (_, __) => Divider(height: 1, color: c.border),
              itemBuilder: (ctx, i) {
                if (i == tasks.length) {
                  if (loadingMore) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final l10n = AppLocalizations.of(ctx);
                  return Center(
                    child: TextButton(
                      onPressed: onLoadMore,
                      child: Text(
                        hasError ? l10n.btnRetry : l10n.tasksLoadMore,
                      ),
                    ),
                  );
                }
                final task = tasks[i];
                return _TableRow(
                  task: task,
                  selected: selectedIds.contains(task.id),
                  onToggleSelect: () => onToggleSelect(task.id),
                  onTap: () => onTap(task.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskListError extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const _TaskListError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              localizeFailureText(l10n, message ?? l10n.errorGeneric),
              style: AppText.body.copyWith(color: c.danger),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 8),
          TextButton(onPressed: onRetry, child: Text(l10n.btnRetry)),
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
    required this.task,
    required this.selected,
    required this.onToggleSelect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isOverdue = task.isOverdue;
    final statusStr = isOverdue ? 'overdue' : task.status;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: selected ? c.primarySoft : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            GestureDetector(
              onTap: onToggleSelect,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? c.primary : Colors.transparent,
                  border: selected
                      ? null
                      : Border.all(color: c.presenceOffline, width: 1.5),
                ),
                child: selected
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 5,
              child: Text(
                task.title,
                style: AppText.bodyMedium.copyWith(color: c.textPrimary),
              ),
            ),
            Expanded(
              flex: 2,
              child: task.assigneeId != null
                  ? Row(
                      children: [
                        Avatar(
                          userId: task.assigneeId!,
                          name: task.assigneeName ?? '',
                          avatarUrl: task.assigneeAvatarUrl,
                          size: 32,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            task.assigneeName ?? '',
                            style: AppText.body.copyWith(color: c.textPrimary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  : Text('—', style: AppText.body.copyWith(color: c.textMuted)),
            ),
            Expanded(
              flex: 2,
              child: Text(
                task.dueAt != null ? _formatDate(task.dueAt!) : '—',
                style: AppText.body.copyWith(
                  color: isOverdue ? c.danger : c.textPrimary,
                ),
              ),
            ),
            Expanded(flex: 1, child: PriorityChip(priority: task.priority)),
            Expanded(flex: 2, child: StatusChip(status: statusStr)),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}';
  }
}

class _DesktopFilterDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  const _DesktopFilterDropdown({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    String displayFor(String option) => switch (option) {
      'All' => l10n.tasksFilterAll,
      'todo' => l10n.statusTodo,
      'in_progress' => l10n.statusInProgress,
      'completed' => l10n.statusCompleted,
      'high' => l10n.priorityHigh,
      'medium' => l10n.priorityMedium,
      'low' => l10n.priorityLow,
      'due_at' => l10n.tasksSortDueDate,
      'created_at' => l10n.tasksSortCreated,
      'title' => l10n.tasksSortTitle,
      _ => option,
    };
    final displayValue = displayFor(value);

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
          hint: Text(
            '$label: $displayValue',
            style: AppText.bodyMedium.copyWith(color: c.textPrimary),
          ),
          items: options.map((o) {
            return DropdownMenuItem(value: o, child: Text(displayFor(o)));
          }).toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
          selectedItemBuilder: (_) => options.map((o) {
            final display = displayFor(o);
            return Text(
              '$label: $display',
              style: AppText.bodyMedium.copyWith(color: c.textPrimary),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _AssigneeFilterDropdown extends ConsumerWidget {
  final String workspaceId;
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  const _AssigneeFilterDropdown({
    required this.workspaceId,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final isOnline = ref.watch(isOnlineProvider);
    final membersAsync = ref.watch(workspaceMembersProvider(workspaceId));

    return membersAsync.when(
      loading: () => _buildDropdown(context, c, l10n, const [], null),
      error: (_, __) => isOnline
          ? InkWell(
              onTap: () =>
                  ref.invalidate(workspaceMembersProvider(workspaceId)),
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(AppRadius.control),
                  border: Border.all(color: c.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${l10n.fieldAssignee}: ${l10n.errorGeneric}',
                      style: AppText.bodyMedium.copyWith(color: c.danger),
                    ),
                    const SizedBox(width: 8),
                    Icon(LucideIcons.refreshCw, size: 14, color: c.textMuted),
                  ],
                ),
              ),
            )
          : _buildDropdown(context, c, l10n, const [], null),
      data: (members) => _buildDropdown(
        context,
        c,
        l10n,
        members
            .map((member) => (id: member.userId, name: member.fullName))
            .toList(),
        selectedId,
      ),
    );
  }

  Widget _buildDropdown(
    BuildContext context,
    PlanPalColors colors,
    AppLocalizations l10n,
    List<({String id, String name})> members,
    String? value,
  ) {
    final validIds = members.map((member) => member.id).toSet();
    final selectedId = value != null && validIds.contains(value) ? value : null;
    var selectedName = l10n.all;
    if (selectedId != null) {
      final selectedMember = members.firstWhere(
        (member) => member.id == selectedId,
      );
      selectedName = selectedMember.name.trim().isEmpty
          ? l10n.fieldAssignee
          : selectedMember.name;
    }

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.control),
        border: Border.all(color: colors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: selectedId,
          icon: Icon(
            LucideIcons.chevronDown,
            size: 14,
            color: colors.textMuted,
          ),
          style: AppText.bodyMedium.copyWith(color: colors.textPrimary),
          items: [
            DropdownMenuItem<String?>(value: null, child: Text(l10n.all)),
            ...members.map(
              (member) => DropdownMenuItem<String?>(
                value: member.id,
                child: Text(
                  member.name.trim().isEmpty ? l10n.fieldAssignee : member.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
          selectedItemBuilder: (_) => [
            Text(
              '${l10n.fieldAssignee}: $selectedName',
              style: AppText.bodyMedium.copyWith(color: colors.textPrimary),
            ),
            ...members.map(
              (member) => Text(
                '${l10n.fieldAssignee}: ${member.name.trim().isEmpty ? l10n.fieldAssignee : member.name}',
                style: AppText.bodyMedium.copyWith(color: colors.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          onChanged: members.isEmpty ? null : onChanged,
        ),
      ),
    );
  }
}

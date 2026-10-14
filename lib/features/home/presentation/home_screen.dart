// app/lib/features/home/presentation/home_screen.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/widgets/chips.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/empty_state.dart';
import '../../workspaces/providers/workspace_providers.dart';
import '../../workspaces/presentation/workspace_switcher.dart';
import '../../notifications/providers/notifications_providers.dart';
import '../../tasks/providers/task_providers.dart';
import '../../tasks/models/task_model.dart';
import '../../calendar/providers/calendar_providers.dart';
import '../providers/home_providers.dart';
import '../models/home_models.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return context.isDesktopLayout
        ? const _DesktopHome()
        : const _MobileHome();
  }
}

String _greeting() {
  final h = DateTime.now().hour;
  if (h < 12) return 'Good morning';
  if (h < 17) return 'Good afternoon';
  return 'Good evening';
}

// ── DESKTOP ───────────────────────────────────────────────────────────────────
class _DesktopHome extends ConsumerWidget {
  const _DesktopHome();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final wsId = ref.watch(currentWorkspaceIdProvider) ?? '';
    final user = Supabase.instance.client.auth.currentUser;
    final firstName = (user?.userMetadata?['full_name'] as String? ?? 'there')
        .split(' ').first;

    return Scaffold(
      backgroundColor: c.background,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main column
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting
                    Text('${_greeting()}, $firstName',
                      style: AppText.pageTitle.copyWith(color: c.textPrimary)),
                    const SizedBox(height: 4),
                    Text("Let's make today productive.",
                      style: AppText.body.copyWith(color: c.textMuted)),
                    const SizedBox(height: 24),
                    // Tasks today
                    _TasksTodaySection(workspaceId: wsId, isDesktop: true),
                    const SizedBox(height: 24),
                    // Quick actions
                    _QuickActions(isDesktop: true),
                    const SizedBox(height: 24),
                    // Overview card
                    _OverviewCard(workspaceId: wsId),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),
            // Right panel
            SizedBox(
              width: LayoutMetrics.rightPanelWidth,
              child: Column(
                children: [
                  // Mini calendar
                  _MiniCalendar(),
                  const SizedBox(height: 16),
                  // Upcoming
                  _UpcomingCard(workspaceId: wsId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── MOBILE ────────────────────────────────────────────────────────────────────
class _MobileHome extends ConsumerWidget {
  const _MobileHome();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final wsId = ref.watch(currentWorkspaceIdProvider) ?? '';
    final workspace = ref.watch(currentWorkspaceProvider);
    final unread = ref.watch(unreadCountProvider);
    final user = Supabase.instance.client.auth.currentUser;
    final firstName = (user?.userMetadata?['full_name'] as String? ?? 'there')
        .split(' ').first;
    return Scaffold(
      backgroundColor: c.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/tasks/new'),
        backgroundColor: c.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(homeProvider.notifier).load(),
          child: CustomScrollView(
            slivers: [
              // Mobile header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      // Workspace tile
                      GestureDetector(
                        onTap: () => showWorkspaceSwitcherSheet(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: c.surface,
                            borderRadius: BorderRadius.circular(AppRadius.control),
                            border: Border.all(color: c.border),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32, height: 32,
                                decoration: BoxDecoration(
                                  color: c.primary, shape: BoxShape.circle),
                                child: Center(
                                  child: Text(workspace?.initial ?? 'W',
                                    style: AppText.bodyStrong.copyWith(
                                        color: Colors.white)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(workspace?.name ?? 'Workspace',
                                style: AppText.bodyStrong.copyWith(
                                    color: c.textPrimary)),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Bell
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          GestureDetector(
                            onTap: () => context.push('/notifications'),
                            child: Icon(LucideIcons.bell,
                                size: 24, color: c.textMuted),
                          ),
                          if (unread > 0)
                            Positioned(
                              top: -4, right: -4,
                              child: Container(
                                width: 8, height: 8,
                                decoration: BoxDecoration(
                                    color: c.danger, shape: BoxShape.circle),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      // User avatar
                      CurrentUserAvatar(
                        name: user?.userMetadata?['full_name'] as String? ?? '',
                        size: 32,
                      ),
                    ],
                  ),
                ),
              ),
              // Greeting
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${_greeting()}, $firstName',
                        style: AppText.pageTitleMobile.copyWith(
                            color: c.textPrimary)),
                      const SizedBox(height: 4),
                      Text("Let's make today productive.",
                        style: AppText.body.copyWith(color: c.textMuted)),
                    ],
                  ),
                ),
              ),
              // Tasks today
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: _TasksTodaySection(
                      workspaceId: wsId, isDesktop: false),
                ),
              ),
              // Quick actions
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: _QuickActions(isDesktop: false),
                ),
              ),
              // Overview
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                  child: _OverviewCard(workspaceId: wsId),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Tasks Today ───────────────────────────────────────────────────────────────
class _TasksTodaySection extends ConsumerWidget {
  final String workspaceId;
  final bool isDesktop;
  const _TasksTodaySection({
      required this.workspaceId, required this.isDesktop});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final state = ref.watch(taskListProvider(workspaceId));

    // Filter to today's tasks
    final todayTasks = state.tasks
        .where((t) => t.isToday && !t.isCompleted)
        .take(3)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Your Tasks Today',
              style: AppText.sectionTitle.copyWith(color: c.textPrimary)),
            const Spacer(),
            TextButton(
              onPressed: () => context.go('/tasks'),
              child: Text(isDesktop ? 'View All Tasks' : 'View All',
                style: AppText.bodyMedium.copyWith(color: c.primary)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (state.loading)
          const LoadingSkeleton(height: 64)
        else if (todayTasks.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: c.border),
            ),
            child: Center(
              child: Text('Nothing due today.',
                style: AppText.body.copyWith(color: c.textMuted))),
          )
        else
          ...todayTasks.map((task) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _TaskTodayCard(
              task: task,
              isDesktop: isDesktop,
              onComplete: () => ref.read(taskListProvider(workspaceId)
                  .notifier).quickComplete(task.id),
            ),
          )),
      ],
    );
  }
}

class _TaskTodayCard extends StatelessWidget {
  final TaskModel task;
  final bool isDesktop;
  final VoidCallback onComplete;
  const _TaskTodayCard({
      required this.task, required this.isDesktop, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final timeStr = task.dueAt != null ? _formatTime(task.dueAt!) : '';

    return GestureDetector(
      onTap: () => context.push('/tasks/${task.id}'),
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
                width: 22, height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: c.border, width: 1.5),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title,
                    style: AppText.bodyMedium.copyWith(color: c.textPrimary)),
                  if (timeStr.isNotEmpty)
                    Row(children: [
                      Icon(LucideIcons.clock, size: 12, color: c.textMuted),
                      const SizedBox(width: 4),
                      Text(timeStr,
                        style: AppText.caption.copyWith(color: c.textMuted)),
                    ]),
                ],
              ),
            ),
            PriorityChip(priority: task.priority),
            if (isDesktop) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: c.primarySoft,
                  borderRadius: BorderRadius.circular(AppRadius.control),
                ),
                child: Text('Details',
                  style: AppText.caption.copyWith(color: c.primary)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $ampm';
  }
}

// ── Quick Actions ─────────────────────────────────────────────────────────────
class _QuickActions extends ConsumerWidget {
  final bool isDesktop;
  const _QuickActions({required this.isDesktop});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final perms = ref.watch(currentRolePermissionsProvider);

    final actions = [
      _Action('New Task', isDesktop ? 'New Task' : 'New Task',
          LucideIcons.plus, c.primarySoft, c.primary,
          () => context.push('/tasks/new')),
      _Action('Calendar', 'Calendar',
          LucideIcons.calendar, c.violetSoft, c.violet,
          () => context.go('/calendar')),
      _Action('Analytics', isDesktop ? 'Analytics' : 'Stats',
          LucideIcons.barChart2, c.skySoft, c.sky,
          () => context.go('/analytics')),
      _Action('Documents', isDesktop ? 'Documents' : 'Docs',
          LucideIcons.fileText, c.successSoft, c.success,
          () => context.go('/documents')),
    ];

    // Hide Analytics for guests
    final visible = perms.isGuest
        ? actions.where((a) => a.key != 'Analytics').toList()
        : actions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isDesktop)
          Text('Quick Actions',
            style: AppText.sectionTitle.copyWith(color: c.textPrimary)),
        if (isDesktop) const SizedBox(height: 12),
        Row(
          children: visible.map((a) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: a == visible.last ? 0 : 12),
              child: GestureDetector(
                onTap: a.onTap,
                child: Container(
                  height: isDesktop ? 93 : 80,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: a.bg,
                    borderRadius: BorderRadius.circular(AppRadius.card),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: a.fg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(a.icon, size: 20, color: Colors.white),
                      ),
                      const Spacer(),
                      Text(a.label,
                        style: AppText.bodyMedium.copyWith(color: c.textPrimary),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }
}

class _Action {
  final String key;
  final String label;
  final IconData icon;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;
  const _Action(this.key, this.label, this.icon, this.bg, this.fg, this.onTap);
}

// ── Overview Card ─────────────────────────────────────────────────────────────
class _OverviewCard extends ConsumerWidget {
  final String workspaceId;
  const _OverviewCard({required this.workspaceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final state = ref.watch(homeProvider);
    final isDesktop = context.isDesktopLayout;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.panel),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Overview',
                style: AppText.sectionTitle.copyWith(color: c.textPrimary)),
              const Spacer(),
              Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: c.surfaceAlt,
                  borderRadius: BorderRadius.circular(AppRadius.control),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: state.range,
                    icon: Icon(LucideIcons.chevronDown,
                      size: 12, color: c.textMuted),
                    style: AppText.caption.copyWith(color: c.textPrimary),
                    items: const [
                      DropdownMenuItem(value: '7d', child: Text('7 days')),
                      DropdownMenuItem(value: '30d', child: Text('30 days')),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        ref.read(homeProvider.notifier).setRange(v);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (state.loading)
            const LoadingSkeleton(height: 80)
          else if (state.overview == null)
            const SizedBox.shrink()
          else ...[
            // Stat tiles — 4 across desktop, 2x2 mobile
            isDesktop
                ? Row(children: _statTiles(state.overview!, c, isDesktop)
                    .map((t) => Expanded(child: Padding(
                        padding: const EdgeInsets.only(right: 8), child: t)))
                    .toList())
                : Column(children: [
                    Row(children: [
                      Expanded(child: _statTiles(state.overview!, c, isDesktop)[0]),
                      const SizedBox(width: 8),
                      Expanded(child: _statTiles(state.overview!, c, isDesktop)[1]),
                    ]),
                    const SizedBox(height: 8),
                    Row(children: [
                      Expanded(child: _statTiles(state.overview!, c, isDesktop)[2]),
                      const SizedBox(width: 8),
                      Expanded(child: _statTiles(state.overview!, c, isDesktop)[3]),
                    ]),
                  ]),
            const SizedBox(height: 20),
            // Line chart
            _OverviewChart(series: state.overview!.dailySeries, isDesktop: isDesktop),
          ],
        ],
      ),
    );
  }

  List<Widget> _statTiles(HomeOverview ov, PlanPalColors c, bool isDesktop) => [
    _StatTile('${ov.completed}',
      isDesktop ? 'Tasks Completed' : 'Completed', c),
    _StatTile('${ov.inProgress}', 'In Progress', c),
    _StatTile('${ov.overdue}', 'Overdue', c),
    _StatTile('${ov.productivityPercent.toStringAsFixed(0)}%',
      'Productivity', c),
  ];
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final PlanPalColors c;
  const _StatTile(this.value, this.label, this.c);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
            style: AppText.statNumber.copyWith(color: c.textPrimary)),
          const SizedBox(height: 4),
          Text(label,
            style: AppText.caption.copyWith(color: c.textMuted)),
        ],
      ),
    );
  }
}

class _OverviewChart extends StatelessWidget {
  final List<DailyPoint> series;
  final bool isDesktop;
  const _OverviewChart({required this.series, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    if (series.isEmpty) {
      return SizedBox(
        height: 120,
        child: Center(child: Text('No data yet.',
          style: AppText.body.copyWith(color: c.textMuted))),
      );
    }

    final spots = series.asMap().entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.value.toDouble()))
        .toList();
    final maxY = spots.map((s) => s.y).fold(0.0, (a, b) => a > b ? a : b);

    return SizedBox(
      height: 140,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxY > 0 ? maxY * 1.2 : 10,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: maxY > 0 ? maxY / 4 : 25,
                getTitlesWidget: (v, _) => Text(
                  v.toInt().toString(),
                  style: AppText.caption.copyWith(color: c.textMuted)),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: isDesktop ? 1 : (series.length / 2).ceil().toDouble(),
                getTitlesWidget: (val, _) {
                  final idx = val.toInt();
                  if (idx < 0 || idx >= series.length) {
                    return const SizedBox();
                  }
                  final dt = series[idx].date;
                  const days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
                  return Text(days[dt.weekday - 1],
                    style: AppText.caption.copyWith(color: c.textMuted));
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: c.primary,
              barWidth: 2.5,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: c.primary.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Mini Calendar ─────────────────────────────────────────────────────────────
class _MiniCalendar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final calState = ref.watch(calendarProvider);
    final now = DateTime.now();
    final month = calState.focusedMonth;
    final firstOfMonth = DateTime(month.year, month.month, 1);
    final daysInMonth =
        DateTime(month.year, month.month + 1, 0).day;
    final startOffset = (firstOfMonth.weekday - 1) % 7;

    const months = ['January','February','March','April','May','June',
                    'July','August','September','October','November','December'];
    const letters = ['M','T','W','T','F','S','S'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.panel),
        border: Border.all(color: c.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text('${months[month.month - 1]} ${month.year}',
                style: AppText.bodyStrong.copyWith(color: c.textPrimary)),
              const Spacer(),
              GestureDetector(
                onTap: () => ref.read(calendarProvider.notifier).previousMonth(),
                child: Icon(LucideIcons.chevronLeft, size: 16, color: c.textMuted)),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => ref.read(calendarProvider.notifier).nextMonth(),
                child: Icon(LucideIcons.chevronRight, size: 16, color: c.textMuted)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: letters.map((l) => Expanded(
              child: Center(child: Text(l,
                style: AppText.caption.copyWith(color: c.textMuted))))).toList(),
          ),
          const SizedBox(height: 8),
          ..._buildRows(daysInMonth, startOffset, month, now, c, ref),
        ],
      ),
    );
  }

  List<Widget> _buildRows(int daysInMonth, int startOffset,
      DateTime month, DateTime now, PlanPalColors c, WidgetRef ref) {
    final rows = <Widget>[];
    final totalCells = startOffset + daysInMonth;
    final numRows = (totalCells / 7).ceil();

    for (int row = 0; row < numRows; row++) {
      rows.add(Row(
        children: List.generate(7, (col) {
          final idx = row * 7 + col;
          final day = idx - startOffset + 1;
          if (day < 1 || day > daysInMonth) {
            return const Expanded(child: SizedBox(height: 28));
          }
          final date = DateTime(month.year, month.month, day);
          final isToday = date.year == now.year &&
              date.month == now.month && date.day == now.day;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                ref.read(calendarProvider.notifier).selectDay(date);
              },
              child: Container(
                height: 28,
                decoration: BoxDecoration(
                  color: isToday ? c.primary : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text('$day',
                    style: AppText.caption.copyWith(
                      color: isToday ? Colors.white : c.textPrimary,
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                    )),
                ),
              ),
            ),
          );
        }),
      ));
    }
    return rows;
  }
}

// ── Upcoming ──────────────────────────────────────────────────────────────────
class _UpcomingCard extends ConsumerWidget {
  final String workspaceId;
  const _UpcomingCard({required this.workspaceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final calState = ref.watch(calendarProvider);
    final upcoming = calState.events
        .where((e) => e.startsAt.isAfter(DateTime.now()))
        .take(3)
        .toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.panel),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Upcoming',
            style: AppText.sectionTitle.copyWith(color: c.textPrimary)),
          const SizedBox(height: 12),
          if (upcoming.isEmpty)
            Text('Nothing coming up.',
              style: AppText.body.copyWith(color: c.textMuted))
          else
            ...upcoming.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 4, height: 36,
                    decoration: BoxDecoration(
                      color: e.pillFg,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.title,
                          style: AppText.bodyStrong.copyWith(
                              color: c.textPrimary),
                          overflow: TextOverflow.ellipsis),
                        Text(e.formatTime(),
                          style: AppText.caption.copyWith(color: c.textMuted)),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }
}

class LoadingSkeleton extends StatelessWidget {
  final double height;
  const LoadingSkeleton({super.key, required this.height});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: context.colors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.control),
      ),
    );
  }
}

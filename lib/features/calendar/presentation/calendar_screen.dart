// app/lib/features/calendar/presentation/calendar_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/widgets/planpal_button.dart';
import '../models/event_model.dart';
import '../providers/calendar_providers.dart';
import 'schedule_event_screen.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = context.isDesktopLayout;
    return isDesktop ? const _DesktopCalendar() : const _MobileCalendar();
  }
}

// ── DESKTOP ───────────────────────────────────────────────────────────────────
class _DesktopCalendar extends ConsumerWidget {
  const _DesktopCalendar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final state = ref.watch(calendarProvider);
    final l10n = AppLocalizations.of(context);
    final material = MaterialLocalizations.of(context);
    final periodTitle = switch (state.view) {
      'day' => material.formatMediumDate(state.selectedDay),
      'week' => _weekTitle(material, state.selectedDay),
      _ => material.formatMonthYear(state.focusedMonth),
    };

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
                Text(
                  periodTitle,
                  style: AppText.pageTitle.copyWith(color: c.textPrimary),
                ),
                const SizedBox(width: 16),
                // Prev button
                _NavButton(
                  icon: LucideIcons.chevronLeft,
                  onTap: () =>
                      ref.read(calendarProvider.notifier).previousMonth(),
                ),
                const SizedBox(width: 8),
                // Next button
                _NavButton(
                  icon: LucideIcons.chevronRight,
                  onTap: () => ref.read(calendarProvider.notifier).nextMonth(),
                ),
                const Spacer(),
                // Week/Month/Day segmented
                _ViewSegmented(
                  value: state.view,
                  options: [
                    l10n.calendarWeek,
                    l10n.calendarMonth,
                    l10n.calendarDay,
                  ],
                  values: const ['week', 'month', 'day'],
                  onChanged: (v) =>
                      ref.read(calendarProvider.notifier).setView(v),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (state.loading) const LinearProgressIndicator(),
            if (state.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.errorGeneric,
                        style: AppText.body.copyWith(color: c.danger),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          ref.read(calendarProvider.notifier).loadMonth(),
                      child: Text(l10n.btnRetry),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: state.view == 'day'
                  ? _DaySchedule(
                      selectedDay: state.selectedDay,
                      events: state.selectedDayEvents,
                      dueTasks: state.selectedDayDueTasks,
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: state.view == 'week'
                              ? _WeekGrid(
                                  selectedDay: state.selectedDay,
                                  events: state.events,
                                  dueTasks: state.dueTasks,
                                  onDayTap: (day) => ref
                                      .read(calendarProvider.notifier)
                                      .selectDay(day),
                                )
                              : _MonthGrid(
                                  focusedMonth: state.focusedMonth,
                                  selectedDay: state.selectedDay,
                                  events: state.events,
                                  dueTasks: state.dueTasks,
                                  onDayTap: (day) => ref
                                      .read(calendarProvider.notifier)
                                      .selectDay(day),
                                ),
                        ),
                        const SizedBox(width: 24),
                        SizedBox(
                          width: LayoutMetrics.rightPanelWidth,
                          child: _RightPanel(
                            selectedDay: state.selectedDay,
                            events: state.selectedDayEvents,
                            dueTasks: state.selectedDayDueTasks,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: c.surface,
          shape: BoxShape.circle,
          border: Border.all(color: c.border),
        ),
        child: Icon(icon, size: 16, color: c.textPrimary),
      ),
    );
  }
}

class _ViewSegmented extends StatelessWidget {
  final String value;
  final List<String> options;
  final List<String>? values;
  final ValueChanged<String> onChanged;
  const _ViewSegmented({
    required this.value,
    required this.options,
    this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: c.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.control),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.indexed.map((entry) {
          final index = entry.$1;
          final label = entry.$2;
          final optionValue = values?[index] ?? label.toLowerCase();
          final selected = value == optionValue;
          return GestureDetector(
            onTap: () => onChanged(optionValue),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: selected ? c.surface : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.control - 3),
                boxShadow: selected ? AppShadows.card(Brightness.light) : null,
              ),
              child: Text(
                label,
                style: AppText.bodyMedium.copyWith(
                  color: selected ? c.textPrimary : c.textMuted,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime selectedDay;
  final List<EventModel> events;
  final List<DueTaskModel> dueTasks;
  final ValueChanged<DateTime> onDayTap;

  const _MonthGrid({
    required this.focusedMonth,
    required this.selectedDay,
    required this.events,
    required this.dueTasks,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final now = DateTime.now();
    final weekdays = MaterialLocalizations.of(context).narrowWeekdays;
    final orderedWeekdays = [...weekdays.skip(1), weekdays.first];

    // Build calendar grid starting Monday
    final firstOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);
    // weekday: Mon=1 ... Sun=7
    final startOffset = (firstOfMonth.weekday - 1) % 7;
    final daysInMonth = DateTime(
      focusedMonth.year,
      focusedMonth.month + 1,
      0,
    ).day;
    final totalCells = startOffset + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.panel),
        border: Border.all(color: c.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Weekday headers
          Row(
            children: orderedWeekdays
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: AppText.caption.copyWith(color: c.textMuted),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          // Grid rows
          ...List.generate(rows, (row) {
            return Expanded(
              child: Row(
                children: List.generate(7, (col) {
                  final cellIndex = row * 7 + col;
                  final dayNum = cellIndex - startOffset + 1;
                  DateTime? cellDate;
                  bool isCurrentMonth = true;
                  if (dayNum < 1) {
                    final prevMonth = DateTime(
                      focusedMonth.year,
                      focusedMonth.month,
                      0,
                    );
                    cellDate = DateTime(
                      prevMonth.year,
                      prevMonth.month,
                      prevMonth.day + dayNum + 1,
                    );
                    isCurrentMonth = false;
                  } else if (dayNum > daysInMonth) {
                    cellDate = DateTime(
                      focusedMonth.year,
                      focusedMonth.month + 1,
                      dayNum - daysInMonth,
                    );
                    isCurrentMonth = false;
                  } else {
                    cellDate = DateTime(
                      focusedMonth.year,
                      focusedMonth.month,
                      dayNum,
                    );
                  }

                  final isToday =
                      cellDate.year == now.year &&
                      cellDate.month == now.month &&
                      cellDate.day == now.day;
                  final isSelected =
                      cellDate.year == selectedDay.year &&
                      cellDate.month == selectedDay.month &&
                      cellDate.day == selectedDay.day;
                  final dayEvents = events.where((e) {
                    final d = DateTime(
                      cellDate!.year,
                      cellDate.month,
                      cellDate.day,
                    );
                    final s = DateTime(
                      e.startsAt.year,
                      e.startsAt.month,
                      e.startsAt.day,
                    );
                    return s == d;
                  }).toList();
                  final hasDueTasks = dueTasks.any(
                    (task) =>
                        task.dueAt.year == cellDate!.year &&
                        task.dueAt.month == cellDate.month &&
                        task.dueAt.day == cellDate.day,
                  );

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: GestureDetector(
                        onTap: () => onDayTap(cellDate!),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? c.primarySoft
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                              AppRadius.control,
                            ),
                            border: isSelected
                                ? Border.all(color: c.primary)
                                : Border.all(
                                    color: c.border.withValues(alpha: 0.5),
                                  ),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${cellDate.day}',
                                style: AppText.caption.copyWith(
                                  color: isToday
                                      ? c.primary
                                      : isCurrentMonth
                                      ? c.textPrimary
                                      : c.textMuted,
                                  fontWeight: isToday
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 2),
                              ...dayEvents
                                  .take(2)
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.only(bottom: 2),
                                      child: _EventPill(event: e),
                                    ),
                                  ),
                              if (dayEvents.length > 2)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: c.surfaceAlt,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(
                                      context,
                                    ).calendarMoreEvents(dayEvents.length - 2),
                                    style: AppText.chip.copyWith(
                                      color: c.textMuted,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              if (hasDueTasks)
                                Container(
                                  width: 6,
                                  height: 6,
                                  margin: const EdgeInsets.only(top: 2),
                                  decoration: BoxDecoration(
                                    color: c.warning,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _EventPill extends StatelessWidget {
  final EventModel event;
  const _EventPill({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: event.pillBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          event.title,
          style: AppText.chip.copyWith(color: event.pillFg, fontSize: 11),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }
}

class _RightPanel extends ConsumerWidget {
  final DateTime selectedDay;
  final List<EventModel> events;
  final List<DueTaskModel> dueTasks;
  const _RightPanel({
    required this.selectedDay,
    required this.events,
    required this.dueTasks,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final date = MaterialLocalizations.of(context).formatShortDate(selectedDay);

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
          Text(
            l10n.calendarEventsFor(date),
            style: AppText.cardTitle.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (events.isEmpty)
                    Text(
                      l10n.emptyStateNoEventsDay,
                      style: AppText.body.copyWith(color: c.textMuted),
                    ),
                  ...events.map(
                    (event) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 44,
                            decoration: BoxDecoration(
                              color: event.pillFg,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title,
                                  style: AppText.bodyStrong.copyWith(
                                    color: c.textPrimary,
                                  ),
                                ),
                                Text(
                                  event.attendeeNames.isEmpty
                                      ? event.formatTime(context)
                                      : '${event.formatTime(context)} · ${_attendeeLabel(event, l10n)}',
                                  style: AppText.caption.copyWith(
                                    color: c.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (dueTasks.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.calendarDueTasks,
                      style: AppText.bodyStrong.copyWith(color: c.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    ...dueTasks.map((task) => _DueTaskRow(task: task)),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          PlanPalButton(
            label: l10n.scheduleEventTitle,
            width: double.infinity,
            onPressed: () => showScheduleEventSheet(context, ref),
          ),
        ],
      ),
    );
  }
}

class _WeekGrid extends StatelessWidget {
  final DateTime selectedDay;
  final List<EventModel> events;
  final List<DueTaskModel> dueTasks;
  final ValueChanged<DateTime> onDayTap;

  const _WeekGrid({
    required this.selectedDay,
    required this.events,
    required this.dueTasks,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final material = MaterialLocalizations.of(context);
    final weekStart = DateTime(
      selectedDay.year,
      selectedDay.month,
      selectedDay.day - selectedDay.weekday + 1,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(7, (index) {
        final day = weekStart.add(Duration(days: index));
        final dayEvents = events.where(
          (event) => _sameDay(event.startsAt, day),
        );
        final dayTasks = dueTasks.where((task) => _sameDay(task.dueAt, day));
        return Expanded(
          child: GestureDetector(
            onTap: () => onDayTap(day),
            child: Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _sameDay(day, selectedDay) ? c.primarySoft : c.surface,
                borderRadius: BorderRadius.circular(AppRadius.control),
                border: Border.all(
                  color: _sameDay(day, selectedDay) ? c.primary : c.border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    material.formatShortDate(day),
                    style: AppText.caption.copyWith(color: c.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  ...dayEvents
                      .take(4)
                      .map(
                        (event) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: _EventPill(event: event),
                        ),
                      ),
                  if (dayTasks.isNotEmpty)
                    Icon(LucideIcons.checkSquare, size: 14, color: c.warning),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _DaySchedule extends StatelessWidget {
  final DateTime selectedDay;
  final List<EventModel> events;
  final List<DueTaskModel> dueTasks;

  const _DaySchedule({
    required this.selectedDay,
    required this.events,
    required this.dueTasks,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.panel),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.calendarEventsFor(
              MaterialLocalizations.of(context).formatMediumDate(selectedDay),
            ),
            style: AppText.cardTitle.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                if (events.isEmpty && dueTasks.isEmpty)
                  Text(
                    l10n.emptyStateNoEventsDay,
                    style: AppText.body.copyWith(color: c.textMuted),
                  ),
                ...events.map(
                  (event) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 5,
                      backgroundColor: event.pillFg,
                    ),
                    title: Text(event.title),
                    subtitle: Text(event.formatTime(context)),
                  ),
                ),
                if (dueTasks.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    l10n.calendarDueTasks,
                    style: AppText.bodyStrong.copyWith(color: c.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  ...dueTasks.map((task) => _DueTaskRow(task: task)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DueTaskRow extends StatelessWidget {
  final DueTaskModel task;
  const _DueTaskRow({required this.task});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(LucideIcons.checkSquare, size: 16, color: c.warning),
      title: Text(task.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      onTap: () => context.push('/tasks/${task.id}'),
    );
  }
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String _attendeeLabel(EventModel event, AppLocalizations l10n) {
  if (event.attendeeNames.isEmpty) return l10n.calendarTeam;
  if (event.attendeeNames.length <= 2) return event.attendeeNames.join(', ');
  return '${event.attendeeNames.take(2).join(', ')} +${event.attendeeNames.length - 2}';
}

String _weekTitle(MaterialLocalizations localizations, DateTime selectedDay) {
  final start = DateTime(
    selectedDay.year,
    selectedDay.month,
    selectedDay.day - selectedDay.weekday + 1,
  );
  final end = start.add(const Duration(days: 6));
  return '${localizations.formatShortDate(start)} – ${localizations.formatShortDate(end)}';
}

// ── MOBILE ────────────────────────────────────────────────────────────────────
class _MobileCalendar extends ConsumerWidget {
  const _MobileCalendar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final state = ref.watch(calendarProvider);
    final now = DateTime.now();
    final l10n = AppLocalizations.of(context);
    final material = MaterialLocalizations.of(context);
    final monthName = material.formatMonthYear(state.focusedMonth);

    return Scaffold(
      backgroundColor: c.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () => showScheduleEventSheet(context, ref),
        backgroundColor: c.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Text(
                    monthName,
                    style: AppText.pageTitleMobile.copyWith(
                      color: c.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () =>
                        ref.read(calendarProvider.notifier).goToToday(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: c.primarySoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        l10n.calendarToday,
                        style: AppText.bodyMedium.copyWith(color: c.primary),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (state.loading) const LinearProgressIndicator(),
              if (state.error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.errorGeneric,
                          style: AppText.body.copyWith(color: c.danger),
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            ref.read(calendarProvider.notifier).loadMonth(),
                        child: Text(l10n.btnRetry),
                      ),
                    ],
                  ),
                ),
              // Month/Day segmented
              _ViewSegmented(
                value: state.view,
                options: [l10n.calendarMonth, l10n.calendarDay],
                values: const ['month', 'day'],
                onChanged: (view) =>
                    ref.read(calendarProvider.notifier).setView(view),
              ),
              const SizedBox(height: 16),
              if (state.view == 'month')
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(AppRadius.panel),
                    border: Border.all(color: c.border),
                  ),
                  child: Column(
                    children: [
                      // Weekday letters
                      Row(
                        children: MaterialLocalizations.of(context)
                            .narrowWeekdays
                            .skip(1)
                            .followedBy([
                              MaterialLocalizations.of(
                                context,
                              ).narrowWeekdays.first,
                            ])
                            .map(
                              (l) => Expanded(
                                child: Center(
                                  child: Text(
                                    l,
                                    style: AppText.caption.copyWith(
                                      color: c.textMuted,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 8),
                      _MobileMonthGrid(
                        focusedMonth: state.focusedMonth,
                        selectedDay: state.selectedDay,
                        events: state.events,
                        dueTasks: state.dueTasks,
                        onDayTap: (d) =>
                            ref.read(calendarProvider.notifier).selectDay(d),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              // Today's Schedule heading
              Text(
                state.selectedDay.year == now.year &&
                        state.selectedDay.month == now.month &&
                        state.selectedDay.day == now.day
                    ? l10n.calendarTodaySchedule
                    : l10n.calendarScheduleFor(
                        material.formatShortDate(state.selectedDay),
                      ),
                style: AppText.sectionTitle.copyWith(color: c.textPrimary),
              ),
              const SizedBox(height: 12),
              // Events for selected day
              if (state.selectedDayEvents.isEmpty &&
                  state.selectedDayDueTasks.isEmpty)
                Text(
                  l10n.emptyStateNoEventsDay,
                  style: AppText.body.copyWith(color: c.textMuted),
                )
              else
                ...state.selectedDayEvents.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _MobileEventCard(event: e),
                  ),
                ),
              if (state.selectedDayDueTasks.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  l10n.calendarDueTasks,
                  style: AppText.bodyStrong.copyWith(color: c.textPrimary),
                ),
                ...state.selectedDayDueTasks.map(
                  (task) => _DueTaskRow(task: task),
                ),
              ],
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileMonthGrid extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime selectedDay;
  final List<EventModel> events;
  final List<DueTaskModel> dueTasks;
  final ValueChanged<DateTime> onDayTap;
  const _MobileMonthGrid({
    required this.focusedMonth,
    required this.selectedDay,
    required this.events,
    required this.dueTasks,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final now = DateTime.now();
    final firstOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final startOffset = (firstOfMonth.weekday - 1) % 7;
    final daysInMonth = DateTime(
      focusedMonth.year,
      focusedMonth.month + 1,
      0,
    ).day;
    final rows = ((startOffset + daysInMonth) / 7).ceil();

    return Column(
      children: List.generate(rows, (row) {
        return Row(
          children: List.generate(7, (col) {
            final cellIndex = row * 7 + col;
            final dayNum = cellIndex - startOffset + 1;
            if (dayNum < 1 || dayNum > daysInMonth) {
              return const Expanded(child: SizedBox(height: 40));
            }
            final cellDate = DateTime(
              focusedMonth.year,
              focusedMonth.month,
              dayNum,
            );
            final isToday =
                cellDate.year == now.year &&
                cellDate.month == now.month &&
                cellDate.day == now.day;
            final isSelected =
                cellDate.year == selectedDay.year &&
                cellDate.month == selectedDay.month &&
                cellDate.day == selectedDay.day;
            final hasEvents = events.any((e) {
              final s = DateTime(
                e.startsAt.year,
                e.startsAt.month,
                e.startsAt.day,
              );
              return s == cellDate;
            });
            final hasDueTasks = dueTasks.any(
              (task) =>
                  task.dueAt.year == cellDate.year &&
                  task.dueAt.month == cellDate.month &&
                  task.dueAt.day == cellDate.day,
            );

            return Expanded(
              child: GestureDetector(
                onTap: () => onDayTap(cellDate),
                child: SizedBox(
                  height: 40,
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isToday ? c.primary : Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              '$dayNum',
                              style: AppText.body.copyWith(
                                color: isToday
                                    ? Colors.white
                                    : hasEvents || hasDueTasks || isSelected
                                    ? c.primary
                                    : c.textPrimary,
                                fontWeight:
                                    (isToday || hasEvents || hasDueTasks)
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        if (hasDueTasks)
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: c.warning,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}

class _MobileEventCard extends StatelessWidget {
  final EventModel event;
  const _MobileEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    // Choose icon based on color
    final icon = _iconForColor(event.color);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          // Icon tile
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: event.pillBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: event.pillFg),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppText.bodyStrong.copyWith(color: c.textPrimary),
                ),
                Text(
                  event.description.isNotEmpty
                      ? '${event.formatTime(context)} · ${event.description}'
                      : event.formatTime(context),
                  style: AppText.caption.copyWith(color: c.textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForColor(String color) {
    switch (color.toUpperCase()) {
      case '#0EA5E9':
        return LucideIcons.video;
      case '#16A34A':
        return LucideIcons.coffee;
      case '#4F46E5':
        return LucideIcons.users;
      case '#F59E0B':
        return LucideIcons.star;
      case '#EF4444':
        return LucideIcons.alertCircle;
      default:
        return LucideIcons.calendar;
    }
  }
}

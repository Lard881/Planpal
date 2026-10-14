// app/lib/features/calendar/presentation/calendar_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/widgets/planpal_button.dart';
import '../models/event_model.dart';
import '../providers/calendar_providers.dart';
import 'schedule_event_screen.dart';

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _weekdayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
const _months = [
  'January','February','March','April','May','June',
  'July','August','September','October','November','December'
];

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = context.isDesktopLayout;
    return isDesktop
        ? const _DesktopCalendar()
        : const _MobileCalendar();
  }
}

// ── DESKTOP ───────────────────────────────────────────────────────────────────
class _DesktopCalendar extends ConsumerWidget {
  const _DesktopCalendar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final state = ref.watch(calendarProvider);

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
                  '${_months[state.focusedMonth.month - 1]} ${state.focusedMonth.year}',
                  style: AppText.pageTitle.copyWith(color: c.textPrimary),
                ),
                const SizedBox(width: 16),
                // Prev button
                _NavButton(
                  icon: LucideIcons.chevronLeft,
                  onTap: () => ref.read(calendarProvider.notifier).previousMonth(),
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
                  options: const ['Week', 'Month', 'Day'],
                  onChanged: (v) => ref.read(calendarProvider.notifier)
                      .setView(v.toLowerCase()),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Month grid
                  Expanded(
                    child: _MonthGrid(
                      focusedMonth: state.focusedMonth,
                      selectedDay: state.selectedDay,
                      events: state.events,
                      onDayTap: (d) => ref.read(calendarProvider.notifier).selectDay(d),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Right panel
                  SizedBox(
                    width: LayoutMetrics.rightPanelWidth,
                    child: _RightPanel(
                      selectedDay: state.selectedDay,
                      events: state.selectedDayEvents,
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
        width: 36, height: 36,
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
  final ValueChanged<String> onChanged;
  const _ViewSegmented({
    required this.value, required this.options, required this.onChanged});

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
        children: options.map((o) {
          final selected = value == o.toLowerCase();
          return GestureDetector(
            onTap: () => onChanged(o),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: selected ? c.surface : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.control - 3),
                boxShadow: selected ? AppShadows.card(Brightness.light) : null,
              ),
              child: Text(o,
                style: AppText.bodyMedium.copyWith(
                  color: selected ? c.textPrimary : c.textMuted)),
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
  final ValueChanged<DateTime> onDayTap;

  const _MonthGrid({
    required this.focusedMonth, required this.selectedDay,
    required this.events, required this.onDayTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final now = DateTime.now();

    // Build calendar grid starting Monday
    final firstOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);
    // weekday: Mon=1 ... Sun=7
    final startOffset = (firstOfMonth.weekday - 1) % 7;
    final daysInMonth = DateTime(focusedMonth.year, focusedMonth.month + 1, 0).day;
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
            children: _weekdays.map((d) => Expanded(
              child: Center(
                child: Text(d,
                  style: AppText.caption.copyWith(color: c.textMuted)),
              ),
            )).toList(),
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
                    final prevMonth = DateTime(focusedMonth.year, focusedMonth.month, 0);
                    cellDate = DateTime(prevMonth.year, prevMonth.month,
                        prevMonth.day + dayNum + 1);
                    isCurrentMonth = false;
                  } else if (dayNum > daysInMonth) {
                    cellDate = DateTime(focusedMonth.year, focusedMonth.month + 1,
                        dayNum - daysInMonth);
                    isCurrentMonth = false;
                  } else {
                    cellDate = DateTime(focusedMonth.year, focusedMonth.month, dayNum);
                  }

                  final isToday = cellDate.year == now.year &&
                      cellDate.month == now.month && cellDate.day == now.day;
                  final isSelected = cellDate.year == selectedDay.year &&
                      cellDate.month == selectedDay.month &&
                      cellDate.day == selectedDay.day;
                  final dayEvents = events.where((e) {
                    final d = DateTime(cellDate!.year, cellDate.month, cellDate.day);
                    final s = DateTime(e.startsAt.year, e.startsAt.month, e.startsAt.day);
                    return s == d;
                  }).toList();

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: GestureDetector(
                        onTap: () => onDayTap(cellDate!),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? c.primarySoft : Colors.transparent,
                            borderRadius: BorderRadius.circular(AppRadius.control),
                            border: isSelected
                                ? Border.all(color: c.primary)
                                : Border.all(color: c.border.withValues(alpha: 0.5)),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${cellDate.day}',
                                style: AppText.caption.copyWith(
                                  color: isToday
                                      ? c.primary
                                      : isCurrentMonth ? c.textPrimary : c.textMuted,
                                  fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                                )),
                              const SizedBox(height: 2),
                              ...dayEvents.take(2).map((e) => Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: _EventPill(event: e),
                              )),
                              if (dayEvents.length > 2)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: c.surfaceAlt,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text('+${dayEvents.length - 2} more',
                                    style: AppText.chip.copyWith(
                                        color: c.textMuted, fontSize: 10)),
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
          style: AppText.chip.copyWith(
            color: event.pillFg, fontSize: 11),
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
  const _RightPanel({required this.selectedDay, required this.events});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];

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
            'Events: ${months[selectedDay.month - 1]} ${selectedDay.day}',
            style: AppText.cardTitle.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: 16),
          if (events.isEmpty)
            Text('No events this day.',
              style: AppText.body.copyWith(color: c.textMuted))
          else
            ...events.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  // 4px colored left bar
                  Container(
                    width: 4, height: 44,
                    decoration: BoxDecoration(
                      color: e.pillFg,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.title,
                          style: AppText.bodyStrong.copyWith(
                            color: c.textPrimary)),
                        Text(
                          e.attendeeNames.isEmpty
                              ? e.formatTime()
                              : '${e.formatTime()} · ${e.attendeeLabel}',
                          style: AppText.caption.copyWith(color: c.textMuted)),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          const Spacer(),
          PlanPalButton(
            label: '+ Schedule Event',
            width: double.infinity,
            onPressed: () => showScheduleEventSheet(context, ref),
          ),
        ],
      ),
    );
  }
}

// ── MOBILE ────────────────────────────────────────────────────────────────────
class _MobileCalendar extends ConsumerWidget {
  const _MobileCalendar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final state = ref.watch(calendarProvider);
    final now = DateTime.now();
    final monthName = _months[state.focusedMonth.month - 1];

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
                  Text(monthName,
                    style: AppText.pageTitleMobile.copyWith(color: c.textPrimary)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => ref.read(calendarProvider.notifier).goToToday(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: c.primarySoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Today',
                        style: AppText.bodyMedium.copyWith(color: c.primary)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Month/Day segmented
              _ViewSegmented(
                value: state.view == 'day' ? 'Day' : 'Month',
                options: const ['Month', 'Day'],
                onChanged: (v) => ref.read(calendarProvider.notifier)
                    .setView(v.toLowerCase()),
              ),
              const SizedBox(height: 16),
              // Compact month grid
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
                      children: _weekdayLetters.map((l) => Expanded(
                        child: Center(
                          child: Text(l,
                            style: AppText.caption.copyWith(color: c.textMuted)),
                        ),
                      )).toList(),
                    ),
                    const SizedBox(height: 8),
                    _MobileMonthGrid(
                      focusedMonth: state.focusedMonth,
                      selectedDay: state.selectedDay,
                      events: state.events,
                      onDayTap: (d) => ref.read(calendarProvider.notifier).selectDay(d),
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
                    ? "Today's Schedule"
                    : 'Schedule · ${_months[state.selectedDay.month - 1]} ${state.selectedDay.day}',
                style: AppText.sectionTitle.copyWith(color: c.textPrimary),
              ),
              const SizedBox(height: 12),
              // Events for selected day
              if (state.selectedDayEvents.isEmpty)
                Text('No events this day.',
                  style: AppText.body.copyWith(color: c.textMuted))
              else
                ...state.selectedDayEvents.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _MobileEventCard(event: e),
                )),
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
  final ValueChanged<DateTime> onDayTap;
  const _MobileMonthGrid({
    required this.focusedMonth, required this.selectedDay,
    required this.events, required this.onDayTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final now = DateTime.now();
    final firstOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final startOffset = (firstOfMonth.weekday - 1) % 7;
    final daysInMonth = DateTime(focusedMonth.year, focusedMonth.month + 1, 0).day;
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
            final cellDate = DateTime(focusedMonth.year, focusedMonth.month, dayNum);
            final isToday = cellDate.year == now.year &&
                cellDate.month == now.month && cellDate.day == now.day;
            final isSelected = cellDate.year == selectedDay.year &&
                cellDate.month == selectedDay.month &&
                cellDate.day == selectedDay.day;
            final hasEvents = events.any((e) {
              final s = DateTime(e.startsAt.year, e.startsAt.month, e.startsAt.day);
              return s == cellDate;
            });

            return Expanded(
              child: GestureDetector(
                onTap: () => onDayTap(cellDate),
                child: SizedBox(
                  height: 40,
                  child: Center(
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isToday ? c.primary : Colors.transparent,
                      ),
                      child: Center(
                        child: Text('$dayNum',
                          style: AppText.body.copyWith(
                            color: isToday
                                ? Colors.white
                                : hasEvents
                                    ? c.primary
                                    : isSelected ? c.primary : c.textPrimary,
                            fontWeight: (isToday || hasEvents)
                                ? FontWeight.w700 : FontWeight.w400,
                          )),
                      ),
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
            width: 40, height: 40,
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
                Text(event.title,
                  style: AppText.bodyStrong.copyWith(color: c.textPrimary)),
                Text(
                  event.description.isNotEmpty
                      ? '${event.formatTime()} · ${event.description}'
                      : event.formatTime(),
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
      case '#0EA5E9': return LucideIcons.video;
      case '#16A34A': return LucideIcons.coffee;
      case '#4F46E5': return LucideIcons.users;
      case '#F59E0B': return LucideIcons.star;
      case '#EF4444': return LucideIcons.alertCircle;
      default: return LucideIcons.calendar;
    }
  }
}

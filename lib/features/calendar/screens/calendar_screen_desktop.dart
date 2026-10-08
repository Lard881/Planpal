import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/db/app_database.dart';
import '../providers/calendar_providers.dart';
import 'schedule_event_dialog.dart';
import 'package:intl/intl.dart';

/// S8.6: Calendar Screen - Desktop
/// Month, week, and day views with event chips and right panel
class CalendarScreenDesktop extends ConsumerStatefulWidget {
  const CalendarScreenDesktop({super.key});

  @override
  ConsumerState<CalendarScreenDesktop> createState() => _CalendarScreenDesktopState();
}

enum CalendarView { month, week, day }

class _CalendarScreenDesktopState extends ConsumerState<CalendarScreenDesktop> {
  CalendarView _view = CalendarView.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final workspaceId = ref.watch(currentWorkspaceIdProvider);

    if (workspaceId == null) {
      return const Scaffold(body: Center(child: Text('No workspace')));
    }

    // Get events for focused month
    final from = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final to = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);

    final eventsAsync = ref.watch(eventsInRangeProvider(
      workspaceId: workspaceId,
      from: from,
      to: to,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          // View switcher
          SegmentedButton<CalendarView>(
            segments: const [
              ButtonSegment(value: CalendarView.month, label: Text('Month')),
              ButtonSegment(value: CalendarView.week, label: Text('Week')),
              ButtonSegment(value: CalendarView.day, label: Text('Day')),
            ],
            selected: {_view},
            onSelectionChanged: (Set<CalendarView> newSelection) {
              setState(() => _view = newSelection.first);
            },
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () => _scheduleEvent(context, workspaceId),
            icon: const Icon(Icons.add),
            label: const Text('Schedule Event'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          // Calendar view
          Expanded(
            flex: 2,
            child: eventsAsync.when(
              data: (events) => _buildCalendarView(events, theme),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),

          // Right panel - selected day details
          if (_selectedDay != null)
            Container(
              width: 300,
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: theme.dividerColor)),
              ),
              child: _buildRightPanel(theme),
            ),
        ],
      ),
    );
  }

  Widget _buildCalendarView(List<Event> events, ThemeData theme) {
    switch (_view) {
      case CalendarView.month:
        return _buildMonthView(events, theme);
      case CalendarView.week:
        return _buildWeekView(events, theme);
      case CalendarView.day:
        return _buildDayView(events, theme);
    }
  }

  Widget _buildMonthView(List<Event> events, ThemeData theme) {
    return TableCalendar(
      firstDay: DateTime(2020),
      lastDay: DateTime(2030),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      calendarFormat: CalendarFormat.month,
      eventLoader: (day) => _getEventsForDay(day, events),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onPageChanged: (focusedDay) {
        setState(() => _focusedDay = focusedDay);
      },
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: theme.colorScheme.primary,
          shape: BoxShape.circle,
        ),
        markerDecoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildWeekView(List<Event> events, ThemeData theme) {
    return TableCalendar(
      firstDay: DateTime(2020),
      lastDay: DateTime(2030),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      calendarFormat: CalendarFormat.week,
      eventLoader: (day) => _getEventsForDay(day, events),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
    );
  }

  Widget _buildDayView(List<Event> events, ThemeData theme) {
    final dayEvents = _getEventsForDay(_selectedDay ?? _focusedDay, events);

    return Column(
      children: [
        // Day header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    _focusedDay = _focusedDay.subtract(const Duration(days: 1));
                    _selectedDay = _focusedDay;
                  });
                },
              ),
              Expanded(
                child: Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(_selectedDay ?? _focusedDay),
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    _focusedDay = _focusedDay.add(const Duration(days: 1));
                    _selectedDay = _focusedDay;
                  });
                },
              ),
            ],
          ),
        ),

        // Events list
        Expanded(
          child: dayEvents.isEmpty
              ? const Center(child: Text('No events'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: dayEvents.length,
                  itemBuilder: (context, index) {
                    final event = dayEvents[index];
                    return _buildEventCard(event, theme);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildRightPanel(ThemeData theme) {
    final dayEvents = _getEventsForDay(
      _selectedDay!,
      ref.watch(eventsInRangeProvider(
        workspaceId: ref.watch(currentWorkspaceIdProvider)!,
        from: DateTime(_selectedDay!.year, _selectedDay!.month, 1),
        to: DateTime(_selectedDay!.year, _selectedDay!.month + 1, 0),
      )).value ?? [],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            DateFormat('MMMM d, yyyy').format(_selectedDay!),
            style: theme.textTheme.titleLarge,
          ),
        ),
        const Divider(),
        Expanded(
          child: dayEvents.isEmpty
              ? const Center(child: Text('No events'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: dayEvents.length,
                  itemBuilder: (context, index) {
                    final event = dayEvents[index];
                    return _buildEventCard(event, theme);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEventCard(Event event, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 4,
          height: 40,
          color: event.color != null ? _parseColor(event.color!) : Colors.blue,
        ),
        title: Text(event.title),
        subtitle: Text(
          '${DateFormat('h:mm a').format(event.startsAt)} - ${DateFormat('h:mm a').format(event.endsAt)}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // TODO: Show event menu
          },
        ),
      ),
    );
  }

  List<Event> _getEventsForDay(DateTime day, List<Event> allEvents) {
    return allEvents.where((event) {
      return isSameDay(event.startsAt, day);
    }).toList();
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
    } catch (e) {
      return Colors.blue;
    }
  }

  void _scheduleEvent(BuildContext context, String workspaceId) {
    showDialog(
      context: context,
      builder: (context) => ScheduleEventDialog(
        workspaceId: workspaceId,
        initialDate: _selectedDay ?? _focusedDay,
      ),
    );
  }
}

// Placeholder providers
final currentWorkspaceIdProvider = Provider<String?>((ref) => null);
final eventsInRangeProvider = StreamProvider.autoDispose.family<
    List<Event>,
    ({String workspaceId, DateTime from, DateTime to})>((ref, params) {
  return Stream.value([]);
});

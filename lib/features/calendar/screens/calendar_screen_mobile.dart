import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/db/app_database.dart';
import '../providers/calendar_providers.dart';
import 'schedule_event_dialog.dart';
import 'package:intl/intl.dart';

/// S8.7: Calendar Screen - Mobile
/// Month and day views, compact grid, Today's Schedule
class CalendarScreenMobile extends ConsumerStatefulWidget {
  const CalendarScreenMobile({super.key});

  @override
  ConsumerState<CalendarScreenMobile> createState() => _CalendarScreenMobileState();
}

class _CalendarScreenMobileState extends ConsumerState<CalendarScreenMobile> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _showMonthView = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final workspaceId = ref.watch(currentWorkspaceIdProvider);

    if (workspaceId == null) {
      return const Scaffold(body: Center(child: Text('No workspace')));
    }

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
          IconButton(
            icon: Icon(_showMonthView ? Icons.view_day : Icons.view_module),
            onPressed: () {
              setState(() => _showMonthView = !_showMonthView);
            },
          ),
        ],
      ),
      body: eventsAsync.when(
        data: (events) => Column(
          children: [
            // Compact calendar
            if (_showMonthView)
              TableCalendar(
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
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
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
              ),

            const Divider(),

            // Today's Schedule or Selected Day
            Expanded(
              child: _buildSchedule(events, theme),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _scheduleEvent(context, workspaceId),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSchedule(List<Event> events, ThemeData theme) {
    final displayDay = _selectedDay ?? DateTime.now();
    final dayEvents = _getEventsForDay(displayDay, events);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            isSameDay(displayDay, DateTime.now())
                ? 'Today\'s Schedule'
                : DateFormat('EEEE, MMMM d').format(displayDay),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Events list (no overlap layout)
        Expanded(
          child: dayEvents.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_available, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No events scheduled'),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: dayEvents.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
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
    final eventColor = event.color != null ? _parseColor(event.color!) : Colors.blue;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: eventColor, width: 2),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Open event detail
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Time indicator
              Container(
                width: 4,
                height: 50,
                decoration: BoxDecoration(
                  color: eventColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),

              // Event info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${DateFormat('h:mm a').format(event.startsAt)} - ${DateFormat('h:mm a').format(event.endsAt)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    if (event.description != null && event.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        event.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Event> _getEventsForDay(DateTime day, List<Event> allEvents) {
    return allEvents.where((event) {
      return isSameDay(event.startsAt, day);
    }).toList()
      ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
    } catch (e) {
      return Colors.blue;
    }
  }

  void _scheduleEvent(BuildContext context, String workspaceId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ScheduleEventDialog(
          workspaceId: workspaceId,
          initialDate: _selectedDay ?? _focusedDay,
        ),
      ),
    );
  }
}

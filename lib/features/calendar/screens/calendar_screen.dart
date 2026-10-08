import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/app_providers.dart';

/// Calendar Screen - Mobile Design
/// Shows month view with today's schedule
/// NO MOCK DATA - all events from database
class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isMonthView = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final workspaceId = ref.watch(currentWorkspaceIdProvider);
    final taskRepository = ref.watch(taskRepositoryProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header with View Toggle
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Calendar',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      _buildViewToggle('Month', true),
                      const SizedBox(width: 8),
                      _buildViewToggle('Day', false),
                    ],
                  ),
                ],
              ),
            ),

            // Month/Year Display
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getMonthYearText(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _focusedDay = DateTime.now();
                        _selectedDay = DateTime.now();
                      });
                    },
                    child: const Text('Today'),
                  ),
                ],
              ),
            ),

            // Calendar Widget
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerVisible: false,
                daysOfWeekHeight: 40,
                rowHeight: 48,
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  todayTextStyle: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  weekendStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
              ),
            ),

            const SizedBox(height: 24),

            // Today's Schedule Section
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      offset: const Offset(0, -2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "Today's Schedule",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Tasks for selected day
                    Expanded(
                      child: workspaceId == null
                          ? const Center(child: Text('No workspace selected'))
                          : StreamBuilder(
                              stream: taskRepository.watchAllTasks(workspaceId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }

                                final allTasks = snapshot.data ?? [];
                                
                                // Filter tasks for selected day
                                final todaysTasks = allTasks.where((task) {
                                  if (task.dueDate == null) return false;
                                  return isSameDay(task.dueDate, _selectedDay ?? DateTime.now());
                                }).toList();

                                // Sort by time
                                todaysTasks.sort((a, b) {
                                  if (a.dueDate == null || b.dueDate == null) return 0;
                                  return a.dueDate!.compareTo(b.dueDate!);
                                });

                                if (todaysTasks.isEmpty) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.event_available,
                                          size: 64,
                                          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No tasks scheduled',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return ListView.separated(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                  itemCount: todaysTasks.length,
                                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final task = todaysTasks[index];
                                    return _buildScheduleItem(context, task);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewToggle(String label, bool isMonth) {
    final isSelected = _isMonthView == isMonth;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _isMonthView = isMonth;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  String _getMonthYearText() {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[_focusedDay.month - 1]} ${_focusedDay.year}';
  }

  Widget _buildScheduleItem(BuildContext context, dynamic task) {
    final theme = Theme.of(context);
    
    // Determine color based on priority
    Color leftBorderColor;
    switch (task.priority) {
      case 'high':
      case 'urgent':
        leftBorderColor = const Color(0xFF3B82F6); // Blue
        break;
      case 'medium':
        leftBorderColor = const Color(0xFFF59E0B); // Orange
        break;
      case 'low':
      default:
        leftBorderColor = const Color(0xFF10B981); // Green
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: leftBorderColor,
            width: 4,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.dueDate != null
                        ? _formatTime(task.dueDate!)
                        : 'No time set',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
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

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}

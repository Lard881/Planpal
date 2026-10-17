// app/lib/features/calendar/providers/calendar_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/app_failure.dart';
import '../data/calendar_repository.dart';
import '../models/event_model.dart';
import '../../workspaces/providers/workspace_providers.dart';

class CalendarState {
  final DateTime focusedMonth;
  final DateTime selectedDay;
  final String view; // month|week|day
  final List<EventModel> events;
  final List<DueTaskModel> dueTasks;
  final bool loading;
  final String? error;

  const CalendarState({
    required this.focusedMonth,
    required this.selectedDay,
    this.view = 'month',
    this.events = const [],
    this.dueTasks = const [],
    this.loading = false,
    this.error,
  });

  CalendarState copyWith({
    DateTime? focusedMonth,
    DateTime? selectedDay,
    String? view,
    List<EventModel>? events,
    List<DueTaskModel>? dueTasks,
    bool? loading,
    String? error,
    bool clearError = false,
  }) => CalendarState(
    focusedMonth: focusedMonth ?? this.focusedMonth,
    selectedDay: selectedDay ?? this.selectedDay,
    view: view ?? this.view,
    events: events ?? this.events,
    dueTasks: dueTasks ?? this.dueTasks,
    loading: loading ?? this.loading,
    error: clearError ? null : (error ?? this.error),
  );

  List<EventModel> eventsForDay(DateTime day) => events.where((e) {
    final d = DateTime(day.year, day.month, day.day);
    final s = DateTime(e.startsAt.year, e.startsAt.month, e.startsAt.day);
    return s == d;
  }).toList();

  List<EventModel> get selectedDayEvents => eventsForDay(selectedDay);

  List<DueTaskModel> dueTasksForDay(DateTime day) => dueTasks.where((task) {
    final due = task.dueAt;
    return due.year == day.year && due.month == day.month && due.day == day.day;
  }).toList();

  List<DueTaskModel> get selectedDayDueTasks => dueTasksForDay(selectedDay);
}

class CalendarNotifier extends StateNotifier<CalendarState> {
  final CalendarRepository _repo;
  final String workspaceId;
  int _loadRequest = 0;

  CalendarNotifier(this._repo, this.workspaceId)
    : super(
        CalendarState(
          focusedMonth: DateTime.now(),
          selectedDay: DateTime.now(),
        ),
      ) {
    loadMonth();
  }

  Future<void> loadMonth() async {
    if (workspaceId.isEmpty) return; // Guard
    final request = ++_loadRequest;
    state = state.copyWith(loading: true, clearError: true);
    final selectedDay = state.selectedDay;
    final DateTime from;
    final DateTime to;
    if (state.view == 'day') {
      from = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
      to = from
          .add(const Duration(days: 1))
          .subtract(const Duration(microseconds: 1));
    } else if (state.view == 'week') {
      final weekStart = DateTime(
        selectedDay.year,
        selectedDay.month,
        selectedDay.day - selectedDay.weekday + 1,
      );
      from = weekStart;
      to = weekStart
          .add(const Duration(days: 7))
          .subtract(const Duration(microseconds: 1));
    } else {
      from = DateTime(state.focusedMonth.year, state.focusedMonth.month, 1);
      to = DateTime(
        state.focusedMonth.year,
        state.focusedMonth.month + 1,
        0,
        23,
        59,
        59,
        999,
      );
    }
    final (events, dueTasks, err) = await _repo.getEvents(
      workspaceId,
      from,
      to,
    );
    if (request != _loadRequest) return;
    final shouldHideConnectivityError =
        err != null &&
        const [
          '__PLANPAL_API_ERROR__:NETWORK',
          '__PLANPAL_API_ERROR__:TIMEOUT',
          '__PLANPAL_API_ERROR__:SERVER_UNREACHABLE',
        ].any(err.message.startsWith) &&
        state.events.isNotEmpty;
    state = state.copyWith(
      events: events,
      dueTasks: dueTasks,
      loading: false,
      error: shouldHideConnectivityError ? null : err?.message,
    );
  }

  void previousMonth() {
    _movePeriod(-1);
  }

  void nextMonth() {
    _movePeriod(1);
  }

  void _movePeriod(int amount) {
    final selectedDay = state.selectedDay;
    final nextDate = switch (state.view) {
      'day' => selectedDay.add(Duration(days: amount)),
      'week' => selectedDay.add(Duration(days: amount * 7)),
      _ => DateTime(
        state.focusedMonth.year,
        state.focusedMonth.month + amount,
        1,
      ),
    };
    state = state.copyWith(
      focusedMonth: DateTime(nextDate.year, nextDate.month),
      selectedDay: state.view == 'month' ? state.selectedDay : nextDate,
    );
    loadMonth();
  }

  void selectDay(DateTime day) {
    state = state.copyWith(
      selectedDay: day,
      focusedMonth: DateTime(day.year, day.month),
    );
    loadMonth();
  }

  void setView(String view) {
    if (state.view == view) return;
    state = state.copyWith(view: view);
    loadMonth();
  }

  void goToToday() {
    final now = DateTime.now();
    final changedMonth =
        state.focusedMonth.month != now.month ||
        state.focusedMonth.year != now.year;
    final changedDay =
        state.selectedDay.year != now.year ||
        state.selectedDay.month != now.month ||
        state.selectedDay.day != now.day;
    state = state.copyWith(focusedMonth: now, selectedDay: now);
    if (changedMonth || (changedDay && state.view != 'month')) {
      loadMonth();
    }
  }

  Future<AppFailure?> createEvent({
    required String title,
    String description = '',
    required DateTime startsAt,
    required DateTime endsAt,
    bool allDay = false,
    String color = '#4F46E5',
    List<String> attendeeIds = const [],
    int reminderMinutesBefore = 15,
  }) async {
    final (event, err) = await _repo.createEvent(
      workspaceId,
      title: title,
      description: description,
      startsAt: startsAt,
      endsAt: endsAt,
      allDay: allDay,
      color: color,
      attendeeIds: attendeeIds,
      reminderMinutesBefore: reminderMinutesBefore,
    );
    if (event != null) {
      state = state.copyWith(events: [...state.events, event]);
    }
    return err;
  }

  Future<AppFailure?> deleteEvent(String eventId) async {
    final failure = await _repo.deleteEvent(workspaceId, eventId);
    if (failure == null ||
        failure is NetworkFailure ||
        failure is ServerUnreachableFailure ||
        failure is TimeoutFailure) {
      state = state.copyWith(
        events: state.events.where((event) => event.id != eventId).toList(),
      );
    }
    return failure;
  }
}

final calendarProvider =
    StateNotifierProvider.autoDispose<CalendarNotifier, CalendarState>((ref) {
      final wsId = ref.watch(currentWorkspaceIdProvider) ?? '';
      return CalendarNotifier(ref.watch(calendarRepositoryProvider), wsId);
    });

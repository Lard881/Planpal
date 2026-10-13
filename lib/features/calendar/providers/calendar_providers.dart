// app/lib/features/calendar/providers/calendar_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/calendar_repository.dart';
import '../models/event_model.dart';
import '../../workspaces/providers/workspace_providers.dart';

class CalendarState {
  final DateTime focusedMonth;
  final DateTime selectedDay;
  final String view; // month|week|day
  final List<EventModel> events;
  final bool loading;
  final String? error;

  const CalendarState({
    required this.focusedMonth,
    required this.selectedDay,
    this.view = 'month',
    this.events = const [],
    this.loading = false,
    this.error,
  });

  CalendarState copyWith({
    DateTime? focusedMonth, DateTime? selectedDay, String? view,
    List<EventModel>? events, bool? loading, String? error,
    bool clearError = false,
  }) => CalendarState(
    focusedMonth: focusedMonth ?? this.focusedMonth,
    selectedDay: selectedDay ?? this.selectedDay,
    view: view ?? this.view,
    events: events ?? this.events,
    loading: loading ?? this.loading,
    error: clearError ? null : (error ?? this.error),
  );

  List<EventModel> eventsForDay(DateTime day) => events.where((e) {
    final d = DateTime(day.year, day.month, day.day);
    final s = DateTime(e.startsAt.year, e.startsAt.month, e.startsAt.day);
    return s == d;
  }).toList();

  List<EventModel> get selectedDayEvents => eventsForDay(selectedDay);
}

class CalendarNotifier extends StateNotifier<CalendarState> {
  final CalendarRepository _repo;
  final String workspaceId;

  CalendarNotifier(this._repo, this.workspaceId)
      : super(CalendarState(
          focusedMonth: DateTime.now(),
          selectedDay: DateTime.now(),
        )) {
    loadMonth();
  }

  Future<void> loadMonth() async {
    if (workspaceId.isEmpty) return; // Guard
    state = state.copyWith(loading: true, clearError: true);
    final from = DateTime(state.focusedMonth.year, state.focusedMonth.month, 1);
    final to = DateTime(state.focusedMonth.year, state.focusedMonth.month + 1, 0, 23, 59);
    final (events, err) = await _repo.getEvents(workspaceId, from, to);
    state = state.copyWith(
      events: events, loading: false,
      error: err?.message,
    );
  }

  void previousMonth() {
    final m = state.focusedMonth;
    state = state.copyWith(
      focusedMonth: DateTime(m.year, m.month - 1));
    loadMonth();
  }

  void nextMonth() {
    final m = state.focusedMonth;
    state = state.copyWith(
      focusedMonth: DateTime(m.year, m.month + 1));
    loadMonth();
  }

  void selectDay(DateTime day) {
    state = state.copyWith(selectedDay: day);
  }

  void setView(String view) => state = state.copyWith(view: view);

  void goToToday() {
    final now = DateTime.now();
    if (state.focusedMonth.month != now.month ||
        state.focusedMonth.year != now.year) {
      state = state.copyWith(
        focusedMonth: now, selectedDay: now);
      loadMonth();
    } else {
      state = state.copyWith(selectedDay: now);
    }
  }

  Future<void> createEvent({
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
      title: title, description: description,
      startsAt: startsAt, endsAt: endsAt,
      allDay: allDay, color: color,
      attendeeIds: attendeeIds,
      reminderMinutesBefore: reminderMinutesBefore,
    );
    if (event != null) {
      state = state.copyWith(events: [...state.events, event]);
    }
  }

  Future<void> deleteEvent(String eventId) async {
    await _repo.deleteEvent(workspaceId, eventId);
    state = state.copyWith(
      events: state.events.where((e) => e.id != eventId).toList());
  }
}

final calendarProvider =
    StateNotifierProvider.autoDispose<CalendarNotifier, CalendarState>((ref) {
  final wsId = ref.watch(currentWorkspaceIdProvider) ?? '';
  return CalendarNotifier(ref.watch(calendarRepositoryProvider), wsId);
});

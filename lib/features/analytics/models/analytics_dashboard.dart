import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_dashboard.freezed.dart';
part 'analytics_dashboard.g.dart';

/// Analytics dashboard data
@freezed
class AnalyticsDashboard with _$AnalyticsDashboard {
  const factory AnalyticsDashboard({
    required AnalyticsPeriod period,
    required TaskMetrics taskMetrics,
    @Default([]) List<EventCount> eventCounts,
    @Default([]) List<DailyActivity> dailyActivity,
    String? workspaceId,
  }) = _AnalyticsDashboard;

  factory AnalyticsDashboard.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsDashboardFromJson(json);
}

/// Analytics period
@freezed
class AnalyticsPeriod with _$AnalyticsPeriod {
  const factory AnalyticsPeriod({
    required DateTime startDate,
    required DateTime endDate,
  }) = _AnalyticsPeriod;

  factory AnalyticsPeriod.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsPeriodFromJson(json);
}

/// Task completion metrics
@freezed
class TaskMetrics with _$TaskMetrics {
  const factory TaskMetrics({
    @Default(0) int totalCreated,
    @Default(0) int totalCompleted,
    @Default(0.0) double completionRate,
    @Default(0.0) double avgCompletionTimeHours,
  }) = _TaskMetrics;

  factory TaskMetrics.fromJson(Map<String, dynamic> json) =>
      _$TaskMetricsFromJson(json);
}

/// Event count by type
@freezed
class EventCount with _$EventCount {
  const factory EventCount({
    required String eventType,
    required int eventCount,
  }) = _EventCount;

  factory EventCount.fromJson(Map<String, dynamic> json) =>
      _$EventCountFromJson(json);
}

/// Daily activity count
@freezed
class DailyActivity with _$DailyActivity {
  const factory DailyActivity({
    required DateTime activityDate,
    required int eventCount,
  }) = _DailyActivity;

  factory DailyActivity.fromJson(Map<String, dynamic> json) =>
      _$DailyActivityFromJson(json);
}

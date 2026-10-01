import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_insights.freezed.dart';
part 'analytics_insights.g.dart';

/// Analytics insights with productivity trends
@freezed
class AnalyticsInsights with _$AnalyticsInsights {
  const factory AnalyticsInsights({
    required AnalyticsPeriod period,
    @Default([]) List<ProductivityTrend> productivityTrends,
    @Default([]) List<StatusDistribution> statusDistribution,
    @Default([]) List<PriorityDistribution> priorityDistribution,
    @Default([]) List<ActiveHour> activeHours,
    @Default([]) List<ActiveDay> activeDays,
    OverdueTasks? overdueTasks,
    AvgTasksPerDay? avgTasksPerDay,
    CompletionStreak? completionStreak,
    @Default([]) List<Insight> insights,
    String? workspaceId,
  }) = _AnalyticsInsights;

  factory AnalyticsInsights.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsInsightsFromJson(json);
}

/// Period model (reused from dashboard)
@freezed
class AnalyticsPeriod with _$AnalyticsPeriod {
  const factory AnalyticsPeriod({
    required DateTime startDate,
    required DateTime endDate,
  }) = _AnalyticsPeriod;

  factory AnalyticsPeriod.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsPeriodFromJson(json);
}

/// Productivity trend (weekly)
@freezed
class ProductivityTrend with _$ProductivityTrend {
  const factory ProductivityTrend({
    required DateTime weekStart,
    required int tasksCreated,
    required int tasksCompleted,
    required double completionRate,
    required int totalEvents,
  }) = _ProductivityTrend;

  factory ProductivityTrend.fromJson(Map<String, dynamic> json) =>
      _$ProductivityTrendFromJson(json);
}

/// Task status distribution
@freezed
class StatusDistribution with _$StatusDistribution {
  const factory StatusDistribution({
    required String status,
    required int taskCount,
    required double percentage,
  }) = _StatusDistribution;

  factory StatusDistribution.fromJson(Map<String, dynamic> json) =>
      _$StatusDistributionFromJson(json);
}

/// Task priority distribution
@freezed
class PriorityDistribution with _$PriorityDistribution {
  const factory PriorityDistribution({
    required String priority,
    required int taskCount,
    required double percentage,
  }) = _PriorityDistribution;

  factory PriorityDistribution.fromJson(Map<String, dynamic> json) =>
      _$PriorityDistributionFromJson(json);
}

/// Active hour
@freezed
class ActiveHour with _$ActiveHour {
  const factory ActiveHour({
    required int hourOfDay,
    required int eventCount,
    required double percentage,
  }) = _ActiveHour;

  factory ActiveHour.fromJson(Map<String, dynamic> json) =>
      _$ActiveHourFromJson(json);
}

/// Active day of week
@freezed
class ActiveDay with _$ActiveDay {
  const factory ActiveDay({
    required int dayOfWeek,
    required String dayName,
    required int eventCount,
    required double percentage,
  }) = _ActiveDay;

  factory ActiveDay.fromJson(Map<String, dynamic> json) =>
      _$ActiveDayFromJson(json);
}

/// Overdue tasks count
@freezed
class OverdueTasks with _$OverdueTasks {
  const factory OverdueTasks({
    required int overdueCount,
    required int overdueHighPriority,
    required int totalActiveTasks,
  }) = _OverdueTasks;

  factory OverdueTasks.fromJson(Map<String, dynamic> json) =>
      _$OverdueTasksFromJson(json);
}

/// Average tasks per day
@freezed
class AvgTasksPerDay with _$AvgTasksPerDay {
  const factory AvgTasksPerDay({
    required double avgCreatedPerDay,
    required double avgCompletedPerDay,
    required int totalDays,
  }) = _AvgTasksPerDay;

  factory AvgTasksPerDay.fromJson(Map<String, dynamic> json) =>
      _$AvgTasksPerDayFromJson(json);
}

/// Completion streak
@freezed
class CompletionStreak with _$CompletionStreak {
  const factory CompletionStreak({
    required int currentStreak,
    required int longestStreak,
    DateTime? lastCompletionDate,
  }) = _CompletionStreak;

  factory CompletionStreak.fromJson(Map<String, dynamic> json) =>
      _$CompletionStreakFromJson(json);
}

/// Individual insight
@freezed
class Insight with _$Insight {
  const factory Insight({
    required String type,
    required String title,
    required String value,
    String? detail,
    String? severity,
  }) = _Insight;

  factory Insight.fromJson(Map<String, dynamic> json) =>
      _$InsightFromJson(json);
}

/// Workspace team activity
@freezed
class TeamActivity with _$TeamActivity {
  const factory TeamActivity({
    required String userId,
    required String fullName,
    required int totalEvents,
    required int tasksCreated,
    required int tasksCompleted,
    required int commentsAdded,
    required DateTime lastActive,
  }) = _TeamActivity;

  factory TeamActivity.fromJson(Map<String, dynamic> json) =>
      _$TeamActivityFromJson(json);
}

/// Workspace analytics
@freezed
class WorkspaceAnalytics with _$WorkspaceAnalytics {
  const factory WorkspaceAnalytics({
    required String workspaceId,
    required AnalyticsPeriod period,
    required int totalEvents,
    required int totalMembers,
    @Default([]) List<TeamActivity> topContributors,
  }) = _WorkspaceAnalytics;

  factory WorkspaceAnalytics.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceAnalyticsFromJson(json);
}

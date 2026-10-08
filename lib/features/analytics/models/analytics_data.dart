import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_data.freezed.dart';
part 'analytics_data.g.dart';

@freezed
class AnalyticsData with _$AnalyticsData {
  const factory AnalyticsData({
    required AnalyticsSummary summary,
    required List<WeeklyData> weekly,
    required List<CategoryData> categories,
    required List<DailyData> daily,
    required int streak,
  }) = _AnalyticsData;

  factory AnalyticsData.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsDataFromJson(json);
}

@freezed
class AnalyticsSummary with _$AnalyticsSummary {
  const factory AnalyticsSummary({
    @JsonKey(name: 'total_completed') required int totalCompleted,
    @JsonKey(name: 'total_created') required int totalCreated,
    @JsonKey(name: 'completion_rate') required double completionRate,
    @JsonKey(name: 'on_time_rate') required double onTimeRate,
    @JsonKey(name: 'avg_completion_time') required double avgCompletionTime,
  }) = _AnalyticsSummary;

  factory AnalyticsSummary.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsSummaryFromJson(json);
}

@freezed
class WeeklyData with _$WeeklyData {
  const factory WeeklyData({
    @JsonKey(name: 'day_of_week') required String dayOfWeek,
    required int completed,
    required int created,
  }) = _WeeklyData;

  factory WeeklyData.fromJson(Map<String, dynamic> json) =>
      _$WeeklyDataFromJson(json);
}

@freezed
class CategoryData with _$CategoryData {
  const factory CategoryData({
    required String category,
    required int completed,
    required int total,
    required double percentage,
  }) = _CategoryData;

  factory CategoryData.fromJson(Map<String, dynamic> json) =>
      _$CategoryDataFromJson(json);
}

@freezed
class DailyData with _$DailyData {
  const factory DailyData({
    required String date,
    required int completed,
    required int created,
    @JsonKey(name: 'completion_rate') required double? completionRate,
  }) = _DailyData;

  factory DailyData.fromJson(Map<String, dynamic> json) =>
      _$DailyDataFromJson(json);
}

@freezed
class OverviewData with _$OverviewData {
  const factory OverviewData({
    required OverviewCounts counts,
    @JsonKey(name: 'productivityPercent') required double productivityPercent,
    @JsonKey(name: 'dailySeries') required List<DailyData> dailySeries,
  }) = _OverviewData;

  factory OverviewData.fromJson(Map<String, dynamic> json) =>
      _$OverviewDataFromJson(json);
}

@freezed
class OverviewCounts with _$OverviewCounts {
  const factory OverviewCounts({
    required int completed,
    required int inProgress,
    required int overdue,
  }) = _OverviewCounts;

  factory OverviewCounts.fromJson(Map<String, dynamic> json) =>
      _$OverviewCountsFromJson(json);
}

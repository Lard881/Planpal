// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnalyticsDataImpl _$$AnalyticsDataImplFromJson(Map<String, dynamic> json) =>
    _$AnalyticsDataImpl(
      summary:
          AnalyticsSummary.fromJson(json['summary'] as Map<String, dynamic>),
      weekly: (json['weekly'] as List<dynamic>)
          .map((e) => WeeklyData.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => CategoryData.fromJson(e as Map<String, dynamic>))
          .toList(),
      daily: (json['daily'] as List<dynamic>)
          .map((e) => DailyData.fromJson(e as Map<String, dynamic>))
          .toList(),
      streak: (json['streak'] as num).toInt(),
    );

Map<String, dynamic> _$$AnalyticsDataImplToJson(_$AnalyticsDataImpl instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'weekly': instance.weekly,
      'categories': instance.categories,
      'daily': instance.daily,
      'streak': instance.streak,
    };

_$AnalyticsSummaryImpl _$$AnalyticsSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$AnalyticsSummaryImpl(
      totalCompleted: (json['total_completed'] as num).toInt(),
      totalCreated: (json['total_created'] as num).toInt(),
      completionRate: (json['completion_rate'] as num).toDouble(),
      onTimeRate: (json['on_time_rate'] as num).toDouble(),
      avgCompletionTime: (json['avg_completion_time'] as num).toDouble(),
    );

Map<String, dynamic> _$$AnalyticsSummaryImplToJson(
        _$AnalyticsSummaryImpl instance) =>
    <String, dynamic>{
      'total_completed': instance.totalCompleted,
      'total_created': instance.totalCreated,
      'completion_rate': instance.completionRate,
      'on_time_rate': instance.onTimeRate,
      'avg_completion_time': instance.avgCompletionTime,
    };

_$WeeklyDataImpl _$$WeeklyDataImplFromJson(Map<String, dynamic> json) =>
    _$WeeklyDataImpl(
      dayOfWeek: json['day_of_week'] as String,
      completed: (json['completed'] as num).toInt(),
      created: (json['created'] as num).toInt(),
    );

Map<String, dynamic> _$$WeeklyDataImplToJson(_$WeeklyDataImpl instance) =>
    <String, dynamic>{
      'day_of_week': instance.dayOfWeek,
      'completed': instance.completed,
      'created': instance.created,
    };

_$CategoryDataImpl _$$CategoryDataImplFromJson(Map<String, dynamic> json) =>
    _$CategoryDataImpl(
      category: json['category'] as String,
      completed: (json['completed'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$$CategoryDataImplToJson(_$CategoryDataImpl instance) =>
    <String, dynamic>{
      'category': instance.category,
      'completed': instance.completed,
      'total': instance.total,
      'percentage': instance.percentage,
    };

_$DailyDataImpl _$$DailyDataImplFromJson(Map<String, dynamic> json) =>
    _$DailyDataImpl(
      date: json['date'] as String,
      completed: (json['completed'] as num).toInt(),
      created: (json['created'] as num).toInt(),
      completionRate: (json['completion_rate'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$DailyDataImplToJson(_$DailyDataImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'completed': instance.completed,
      'created': instance.created,
      'completion_rate': instance.completionRate,
    };

_$OverviewDataImpl _$$OverviewDataImplFromJson(Map<String, dynamic> json) =>
    _$OverviewDataImpl(
      counts: OverviewCounts.fromJson(json['counts'] as Map<String, dynamic>),
      productivityPercent: (json['productivityPercent'] as num).toDouble(),
      dailySeries: (json['dailySeries'] as List<dynamic>)
          .map((e) => DailyData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$OverviewDataImplToJson(_$OverviewDataImpl instance) =>
    <String, dynamic>{
      'counts': instance.counts,
      'productivityPercent': instance.productivityPercent,
      'dailySeries': instance.dailySeries,
    };

_$OverviewCountsImpl _$$OverviewCountsImplFromJson(Map<String, dynamic> json) =>
    _$OverviewCountsImpl(
      completed: (json['completed'] as num).toInt(),
      inProgress: (json['inProgress'] as num).toInt(),
      overdue: (json['overdue'] as num).toInt(),
    );

Map<String, dynamic> _$$OverviewCountsImplToJson(
        _$OverviewCountsImpl instance) =>
    <String, dynamic>{
      'completed': instance.completed,
      'inProgress': instance.inProgress,
      'overdue': instance.overdue,
    };

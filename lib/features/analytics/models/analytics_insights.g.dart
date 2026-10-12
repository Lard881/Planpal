// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_insights.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnalyticsInsightsImpl _$$AnalyticsInsightsImplFromJson(
        Map<String, dynamic> json) =>
    _$AnalyticsInsightsImpl(
      period: AnalyticsPeriod.fromJson(json['period'] as Map<String, dynamic>),
      productivityTrends: (json['productivityTrends'] as List<dynamic>?)
              ?.map(
                  (e) => ProductivityTrend.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      statusDistribution: (json['statusDistribution'] as List<dynamic>?)
              ?.map(
                  (e) => StatusDistribution.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      priorityDistribution: (json['priorityDistribution'] as List<dynamic>?)
              ?.map((e) =>
                  PriorityDistribution.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      activeHours: (json['activeHours'] as List<dynamic>?)
              ?.map((e) => ActiveHour.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      activeDays: (json['activeDays'] as List<dynamic>?)
              ?.map((e) => ActiveDay.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      overdueTasks: json['overdueTasks'] == null
          ? null
          : OverdueTasks.fromJson(json['overdueTasks'] as Map<String, dynamic>),
      avgTasksPerDay: json['avgTasksPerDay'] == null
          ? null
          : AvgTasksPerDay.fromJson(
              json['avgTasksPerDay'] as Map<String, dynamic>),
      completionStreak: json['completionStreak'] == null
          ? null
          : CompletionStreak.fromJson(
              json['completionStreak'] as Map<String, dynamic>),
      insights: (json['insights'] as List<dynamic>?)
              ?.map((e) => Insight.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      workspaceId: json['workspaceId'] as String?,
    );

Map<String, dynamic> _$$AnalyticsInsightsImplToJson(
        _$AnalyticsInsightsImpl instance) =>
    <String, dynamic>{
      'period': instance.period,
      'productivityTrends': instance.productivityTrends,
      'statusDistribution': instance.statusDistribution,
      'priorityDistribution': instance.priorityDistribution,
      'activeHours': instance.activeHours,
      'activeDays': instance.activeDays,
      'overdueTasks': instance.overdueTasks,
      'avgTasksPerDay': instance.avgTasksPerDay,
      'completionStreak': instance.completionStreak,
      'insights': instance.insights,
      'workspaceId': instance.workspaceId,
    };

_$AnalyticsPeriodImpl _$$AnalyticsPeriodImplFromJson(
        Map<String, dynamic> json) =>
    _$AnalyticsPeriodImpl(
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$$AnalyticsPeriodImplToJson(
        _$AnalyticsPeriodImpl instance) =>
    <String, dynamic>{
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
    };

_$ProductivityTrendImpl _$$ProductivityTrendImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductivityTrendImpl(
      weekStart: DateTime.parse(json['weekStart'] as String),
      tasksCreated: (json['tasksCreated'] as num).toInt(),
      tasksCompleted: (json['tasksCompleted'] as num).toInt(),
      completionRate: (json['completionRate'] as num).toDouble(),
      totalEvents: (json['totalEvents'] as num).toInt(),
    );

Map<String, dynamic> _$$ProductivityTrendImplToJson(
        _$ProductivityTrendImpl instance) =>
    <String, dynamic>{
      'weekStart': instance.weekStart.toIso8601String(),
      'tasksCreated': instance.tasksCreated,
      'tasksCompleted': instance.tasksCompleted,
      'completionRate': instance.completionRate,
      'totalEvents': instance.totalEvents,
    };

_$StatusDistributionImpl _$$StatusDistributionImplFromJson(
        Map<String, dynamic> json) =>
    _$StatusDistributionImpl(
      status: json['status'] as String,
      taskCount: (json['taskCount'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$$StatusDistributionImplToJson(
        _$StatusDistributionImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'taskCount': instance.taskCount,
      'percentage': instance.percentage,
    };

_$PriorityDistributionImpl _$$PriorityDistributionImplFromJson(
        Map<String, dynamic> json) =>
    _$PriorityDistributionImpl(
      priority: json['priority'] as String,
      taskCount: (json['taskCount'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$$PriorityDistributionImplToJson(
        _$PriorityDistributionImpl instance) =>
    <String, dynamic>{
      'priority': instance.priority,
      'taskCount': instance.taskCount,
      'percentage': instance.percentage,
    };

_$ActiveHourImpl _$$ActiveHourImplFromJson(Map<String, dynamic> json) =>
    _$ActiveHourImpl(
      hourOfDay: (json['hourOfDay'] as num).toInt(),
      eventCount: (json['eventCount'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$$ActiveHourImplToJson(_$ActiveHourImpl instance) =>
    <String, dynamic>{
      'hourOfDay': instance.hourOfDay,
      'eventCount': instance.eventCount,
      'percentage': instance.percentage,
    };

_$ActiveDayImpl _$$ActiveDayImplFromJson(Map<String, dynamic> json) =>
    _$ActiveDayImpl(
      dayOfWeek: (json['dayOfWeek'] as num).toInt(),
      dayName: json['dayName'] as String,
      eventCount: (json['eventCount'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$$ActiveDayImplToJson(_$ActiveDayImpl instance) =>
    <String, dynamic>{
      'dayOfWeek': instance.dayOfWeek,
      'dayName': instance.dayName,
      'eventCount': instance.eventCount,
      'percentage': instance.percentage,
    };

_$OverdueTasksImpl _$$OverdueTasksImplFromJson(Map<String, dynamic> json) =>
    _$OverdueTasksImpl(
      overdueCount: (json['overdueCount'] as num).toInt(),
      overdueHighPriority: (json['overdueHighPriority'] as num).toInt(),
      totalActiveTasks: (json['totalActiveTasks'] as num).toInt(),
    );

Map<String, dynamic> _$$OverdueTasksImplToJson(_$OverdueTasksImpl instance) =>
    <String, dynamic>{
      'overdueCount': instance.overdueCount,
      'overdueHighPriority': instance.overdueHighPriority,
      'totalActiveTasks': instance.totalActiveTasks,
    };

_$AvgTasksPerDayImpl _$$AvgTasksPerDayImplFromJson(Map<String, dynamic> json) =>
    _$AvgTasksPerDayImpl(
      avgCreatedPerDay: (json['avgCreatedPerDay'] as num).toDouble(),
      avgCompletedPerDay: (json['avgCompletedPerDay'] as num).toDouble(),
      totalDays: (json['totalDays'] as num).toInt(),
    );

Map<String, dynamic> _$$AvgTasksPerDayImplToJson(
        _$AvgTasksPerDayImpl instance) =>
    <String, dynamic>{
      'avgCreatedPerDay': instance.avgCreatedPerDay,
      'avgCompletedPerDay': instance.avgCompletedPerDay,
      'totalDays': instance.totalDays,
    };

_$CompletionStreakImpl _$$CompletionStreakImplFromJson(
        Map<String, dynamic> json) =>
    _$CompletionStreakImpl(
      currentStreak: (json['currentStreak'] as num).toInt(),
      longestStreak: (json['longestStreak'] as num).toInt(),
      lastCompletionDate: json['lastCompletionDate'] == null
          ? null
          : DateTime.parse(json['lastCompletionDate'] as String),
    );

Map<String, dynamic> _$$CompletionStreakImplToJson(
        _$CompletionStreakImpl instance) =>
    <String, dynamic>{
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'lastCompletionDate': instance.lastCompletionDate?.toIso8601String(),
    };

_$InsightImpl _$$InsightImplFromJson(Map<String, dynamic> json) =>
    _$InsightImpl(
      type: json['type'] as String,
      title: json['title'] as String,
      value: json['value'] as String,
      detail: json['detail'] as String?,
      severity: json['severity'] as String?,
    );

Map<String, dynamic> _$$InsightImplToJson(_$InsightImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'title': instance.title,
      'value': instance.value,
      'detail': instance.detail,
      'severity': instance.severity,
    };

_$TeamActivityImpl _$$TeamActivityImplFromJson(Map<String, dynamic> json) =>
    _$TeamActivityImpl(
      userId: json['userId'] as String,
      fullName: json['fullName'] as String,
      totalEvents: (json['totalEvents'] as num).toInt(),
      tasksCreated: (json['tasksCreated'] as num).toInt(),
      tasksCompleted: (json['tasksCompleted'] as num).toInt(),
      commentsAdded: (json['commentsAdded'] as num).toInt(),
      lastActive: DateTime.parse(json['lastActive'] as String),
    );

Map<String, dynamic> _$$TeamActivityImplToJson(_$TeamActivityImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'fullName': instance.fullName,
      'totalEvents': instance.totalEvents,
      'tasksCreated': instance.tasksCreated,
      'tasksCompleted': instance.tasksCompleted,
      'commentsAdded': instance.commentsAdded,
      'lastActive': instance.lastActive.toIso8601String(),
    };

_$WorkspaceAnalyticsImpl _$$WorkspaceAnalyticsImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkspaceAnalyticsImpl(
      workspaceId: json['workspaceId'] as String,
      period: AnalyticsPeriod.fromJson(json['period'] as Map<String, dynamic>),
      totalEvents: (json['totalEvents'] as num).toInt(),
      totalMembers: (json['totalMembers'] as num).toInt(),
      topContributors: (json['topContributors'] as List<dynamic>?)
              ?.map((e) => TeamActivity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$WorkspaceAnalyticsImplToJson(
        _$WorkspaceAnalyticsImpl instance) =>
    <String, dynamic>{
      'workspaceId': instance.workspaceId,
      'period': instance.period,
      'totalEvents': instance.totalEvents,
      'totalMembers': instance.totalMembers,
      'topContributors': instance.topContributors,
    };

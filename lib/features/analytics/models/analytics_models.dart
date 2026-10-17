// app/lib/features/analytics/models/analytics_models.dart
class AnalyticsSummary {
  final int tasksCompleted;
  final double avgCompletionDays;
  final double onTimeRate; // 0-100 percentage (F24)
  final int streak;
  final double? changeVsPrevious; // null = hide sub-line

  const AnalyticsSummary({
    this.tasksCompleted = 0,
    this.avgCompletionDays = 0,
    this.onTimeRate = 0,
    this.streak = 0,
    this.changeVsPrevious,
  });

  factory AnalyticsSummary.fromJson(Map<String, dynamic> j) => AnalyticsSummary(
    tasksCompleted: j['completed'] as int? ?? 0,
    avgCompletionDays: (j['avg_completion_days'] as num?)?.toDouble() ?? 0,
    onTimeRate: (j['on_time_rate'] as num?)?.toDouble() ?? 0,
    streak: j['streak'] as int? ?? 0,
    changeVsPrevious: j['changeVsPrevious'] != null
        ? (j['changeVsPrevious'] as num).toDouble()
        : null,
  );

  Map<String, dynamic> toJson() => {
    'completed': tasksCompleted,
    'avg_completion_days': avgCompletionDays,
    'on_time_rate': onTimeRate,
    'streak': streak,
    'changeVsPrevious': changeVsPrevious,
  };
}

class WeeklyData {
  final int weekday; // 1=Mon .. 7=Sun
  final int completed;

  const WeeklyData({required this.weekday, required this.completed});

  String get label {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[(weekday - 1).clamp(0, 6)];
  }

  factory WeeklyData.fromJson(Map<String, dynamic> j) => WeeklyData(
    weekday: j['weekday'] as int? ?? j['dow'] as int? ?? 1,
    completed: j['completed'] as int? ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'weekday': weekday,
    'completed': completed,
  };
}

class CategoryData {
  final String label;
  final String color;
  final int total;

  const CategoryData({
    required this.label, required this.color, required this.total});

  factory CategoryData.fromJson(Map<String, dynamic> j) => CategoryData(
    label: j['label'] as String? ?? 'Other',
    color: j['color'] as String? ?? '#6B7185',
    total: j['total'] as int? ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'label': label,
    'color': color,
    'total': total,
  };
}

class AnalyticsData {
  final AnalyticsSummary summary;
  final List<WeeklyData> weekly;
  final List<CategoryData> categories;

  const AnalyticsData({
    required this.summary,
    this.weekly = const [],
    this.categories = const [],
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> j) => AnalyticsData(
    summary: AnalyticsSummary.fromJson(
      {
        ...(j['summary'] as Map<String, dynamic>? ?? {}),
        'streak': j['streak'] as int? ?? 0,
      }),
    weekly: (j['weekly'] as List? ?? [])
        .map((w) => WeeklyData.fromJson(w as Map<String, dynamic>))
        .toList(),
    categories: (j['categories'] as List? ?? [])
        .map((c) => CategoryData.fromJson(c as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'summary': summary.toJson(),
    'weekly': weekly.map((item) => item.toJson()).toList(),
    'categories': categories.map((item) => item.toJson()).toList(),
  };
}

// app/lib/features/home/models/home_models.dart
class HomeOverview {
  final int completed;
  final int inProgress;
  final int overdue;
  final double productivityPercent;
  final List<DailyPoint> dailySeries;

  const HomeOverview({
    this.completed = 0,
    this.inProgress = 0,
    this.overdue = 0,
    this.productivityPercent = 0,
    this.dailySeries = const [],
  });

  factory HomeOverview.fromJson(Map<String, dynamic> j) {
    final counts = j['counts'] as Map<String, dynamic>? ?? j;
    return HomeOverview(
      completed: counts['completed'] as int? ?? 0,
      inProgress: counts['in_progress'] as int? ?? counts['inProgress'] as int? ?? 0,
      overdue: counts['overdue'] as int? ?? 0,
      productivityPercent: (j['productivityPercent'] as num?)?.toDouble() ?? 0,
      dailySeries: (j['dailySeries'] as List? ?? [])
          .map((d) => DailyPoint.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DailyPoint {
  final DateTime date;
  final int value;
  const DailyPoint({required this.date, required this.value});

  factory DailyPoint.fromJson(Map<String, dynamic> j) => DailyPoint(
    date: DateTime.parse(j['date'] as String),
    value: j['value'] as int? ?? 0,
  );
}

import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/features/home/models/home_models.dart';

void main() {
  test('parses the overview and daily-series response shape', () {
    final overview = HomeOverview.fromJson({
      'counts': {'completed': 4, 'inProgress': 2, 'overdue': 1},
      'productivityPercent': 75.0,
      'dailySeries': [
        {'day': '2026-07-14', 'completed': 3},
      ],
    });

    expect(overview.completed, 4);
    expect(overview.inProgress, 2);
    expect(overview.overdue, 1);
    expect(overview.productivityPercent, 75.0);
    expect(overview.dailySeries.single.date, DateTime(2026, 7, 14));
    expect(overview.dailySeries.single.value, 3);
  });
}

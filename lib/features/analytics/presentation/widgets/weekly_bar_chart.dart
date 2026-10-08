import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../models/analytics_data.dart';

class WeeklyBarChart extends StatelessWidget {
  final List<WeeklyData> weeklyData;

  const WeeklyBarChart({
    super.key,
    required this.weeklyData,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
          width: 1,
        ),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _getMaxY(),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final day = weeklyData[groupIndex].dayOfWeek;
                final value = rod.toY.round();
                final label = rodIndex == 0 ? 'Completed' : 'Created';
                return BarTooltipItem(
                  '$day\n$label: $value',
                  TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 &&
                      value.toInt() < weeklyData.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _getDayAbbreviation(
                            weeklyData[value.toInt()].dayOfWeek),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: (isDark ? AppColors.borderDark : AppColors.border)
                    .withValues(alpha: 0.3),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          barGroups: _buildBarGroups(),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return weeklyData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data.completed.toDouble(),
            color: AppColors.success,
            width: 12,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
          BarChartRodData(
            toY: data.created.toDouble(),
            color: AppColors.primary,
            width: 12,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }).toList();
  }

  double _getMaxY() {
    double max = 0;
    for (final data in weeklyData) {
      if (data.completed > max) max = data.completed.toDouble();
      if (data.created > max) max = data.created.toDouble();
    }
    return (max * 1.2).ceilToDouble(); // Add 20% padding
  }

  String _getDayAbbreviation(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return 'Mon';
      case 'tuesday':
        return 'Tue';
      case 'wednesday':
        return 'Wed';
      case 'thursday':
        return 'Thu';
      case 'friday':
        return 'Fri';
      case 'saturday':
        return 'Sat';
      case 'sunday':
        return 'Sun';
      default:
        return day.substring(0, 3);
    }
  }
}

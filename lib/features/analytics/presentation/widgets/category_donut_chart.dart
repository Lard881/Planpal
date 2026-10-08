import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../models/analytics_data.dart';

class CategoryDonutChart extends StatelessWidget {
  final List<CategoryData> categories;

  const CategoryDonutChart({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 350,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Pie chart
          Expanded(
            flex: 2,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 60,
                sections: _buildSections(context),
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          // Legend
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: categories.map((category) {
                final color = _getCategoryColor(categories.indexOf(category));
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.category,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${category.completed}/${category.total}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textMuted,
                                    fontSize: 10,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(BuildContext context) {
    return categories.asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value;
      final color = _getCategoryColor(index);

      return PieChartSectionData(
        value: category.percentage,
        title: '${category.percentage.toStringAsFixed(0)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: color,
      );
    }).toList();
  }

  Color _getCategoryColor(int index) {
    final colors = [
      AppColors.primary,
      AppColors.success,
      AppColors.warning,
      AppColors.violet,
      AppColors.info,
      AppColors.danger,
    ];
    return colors[index % colors.length];
  }
}

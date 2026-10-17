// app/lib/features/analytics/presentation/analytics_screen.dart
import 'dart:typed_data';

import 'package:fl_chart/fl_chart.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/network/failure_localizer.dart';
import '../data/analytics_repository.dart';
import '../models/analytics_models.dart';
import '../providers/analytics_providers.dart';
import '../../../core/platform/platform_info.dart';
import '../../workspaces/providers/workspace_providers.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = context.isDesktopLayout;
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(analyticsProvider);
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.background,
      body: Padding(
        padding: EdgeInsets.all(isDesktop ? 32 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Text(
                  l10n.analyticsTitle,
                  style:
                      (isDesktop ? AppText.pageTitle : AppText.pageTitleMobile)
                          .copyWith(color: c.textPrimary),
                ),
                const Spacer(),
                // Range selector
                _RangeDropdown(
                  value: state.range,
                  onChanged: (r) =>
                      ref.read(analyticsProvider.notifier).setRange(r),
                ),
                const SizedBox(width: 8),
                _ExportButton(),
              ],
            ),
            const SizedBox(height: 20),
            if (state.lastUpdated != null)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  l10n.analyticsLastUpdated(
                    '${MaterialLocalizations.of(context).formatMediumDate(state.lastUpdated!)} '
                    '${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(state.lastUpdated!))}',
                  ),
                  style: AppText.caption.copyWith(color: c.textMuted),
                ),
              ),
            // Content
            if (state.loading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (state.error != null)
              Expanded(child: ErrorState(message: state.error!))
            else if (state.data == null)
              Expanded(
                child: EmptyState(
                  icon: LucideIcons.barChart2,
                  title: l10n.emptyStateNoAnalytics,
                  subtitle: l10n.emptyStateNoAnalyticsDesc,
                ),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  child: _AnalyticsBody(
                    data: state.data!,
                    isDesktop: isDesktop,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RangeDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const _RangeDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final labels = {
      '7d': l10n.analyticsLastSevenDays,
      '30d': l10n.analyticsLastThirtyDays,
      '90d': l10n.analyticsLastNinetyDays,
    };
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.control),
        border: Border.all(color: c.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: Icon(LucideIcons.chevronDown, size: 14, color: c.textMuted),
          style: AppText.bodyMedium.copyWith(color: c.textPrimary),
          items: labels.entries
              .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
          selectedItemBuilder: (_) => labels.entries
              .map(
                (e) => Text(
                  e.value,
                  style: AppText.bodyMedium.copyWith(color: c.textPrimary),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _ExportButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(analyticsProvider);
    final wsId = ref.watch(currentWorkspaceIdProvider) ?? '';
    return SizedBox(
      height: 40,
      child: OutlinedButton.icon(
        onPressed: () async {
          final (csv, failure) = await ref
              .read(analyticsRepositoryProvider)
              .getCsv(wsId, state.range);
          if (!context.mounted) return;
          if (failure != null || csv == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  failure?.localizedMessage(context) ?? l10n.errorGeneric,
                ),
              ),
            );
            return;
          }
          final bytes = Uint8List.fromList(csv);
          final fileName = 'analytics-${state.range}.csv';
          if (PlatformInfo.isWindows) {
            await FilePicker.platform.saveFile(
              dialogTitle: l10n.analyticsExportCSV,
              fileName: fileName,
              type: FileType.custom,
              allowedExtensions: const ['csv'],
              bytes: bytes,
            );
          } else {
            await SharePlus.instance.share(
              ShareParams(
                title: l10n.analyticsExportCSV,
                files: [
                  XFile.fromData(bytes, name: fileName, mimeType: 'text/csv'),
                ],
                fileNameOverrides: [fileName],
              ),
            );
          }
        },
        icon: Icon(LucideIcons.download, size: 16, color: c.textPrimary),
        label: Text(
          l10n.analyticsExportCSV,
          style: AppText.bodyMedium.copyWith(color: c.textPrimary),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: c.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.control),
          ),
        ),
      ),
    );
  }
}

class _AnalyticsBody extends StatelessWidget {
  final AnalyticsData data;
  final bool isDesktop;
  const _AnalyticsBody({required this.data, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);

    // Stat cards
    final statCards = [
      _StatCard(
        icon: LucideIcons.checkCircle,
        iconBg: c.successSoft,
        iconFg: c.success,
        value: '${data.summary.tasksCompleted}',
        label: isDesktop ? l10n.analyticsTasksCompleted : l10n.homeCompleted,
        subLine: data.summary.changeVsPrevious != null
            ? _changeLabel(data.summary.changeVsPrevious!, c)
            : null,
      ),
      _StatCard(
        icon: LucideIcons.timer,
        iconBg: c.primarySoft,
        iconFg: c.primary,
        value: '${data.summary.avgCompletionDays.toStringAsFixed(1)} days',
        label: l10n.analyticsAvgTime,
      ),
      _StatCard(
        icon: LucideIcons.zap,
        iconBg: c.violetSoft,
        iconFg: c.violet,
        value: '${data.summary.onTimeRate.toStringAsFixed(0)}%',
        label: l10n.analyticsVelocity,
      ),
      _StatCard(
        icon: LucideIcons.flame,
        iconBg: c.warningSoft,
        iconFg: c.warningText,
        value: '${data.summary.streak} days',
        label: l10n.analyticsStreak,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stat cards row (desktop 4 across, mobile 2x2)
        isDesktop
            ? Row(
                children: statCards
                    .map(
                      (c) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: c,
                        ),
                      ),
                    )
                    .toList(),
              )
            : Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: statCards[0]),
                      const SizedBox(width: 12),
                      Expanded(child: statCards[1]),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: statCards[2]),
                      const SizedBox(width: 12),
                      Expanded(child: statCards[3]),
                    ],
                  ),
                ],
              ),
        const SizedBox(height: 24),
        // Charts
        isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: _WeeklyChart(weekly: data.weekly)),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 4,
                    child: _CategoryDonut(categories: data.categories),
                  ),
                ],
              )
            : Column(
                children: [
                  _WeeklyChart(weekly: data.weekly),
                  const SizedBox(height: 16),
                  _CategoryDonut(categories: data.categories),
                ],
              ),
      ],
    );
  }

  Widget _changeLabel(double change, PlanPalColors c) {
    final isPositive = change >= 0;
    final label =
        '${isPositive ? '+' : ''}${change.toStringAsFixed(1)}% this period';
    return Text(
      label,
      style: AppText.caption.copyWith(color: isPositive ? c.success : c.danger),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconFg;
  final String value;
  final String label;
  final Widget? subLine;

  const _StatCard({
    required this.icon,
    required this.iconBg,
    required this.iconFg,
    required this.value,
    required this.label,
    this.subLine,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(AppRadius.control),
            ),
            child: Icon(icon, size: 18, color: iconFg),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppText.statNumberLarge.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppText.body.copyWith(color: c.textMuted)),
          if (subLine != null) ...[const SizedBox(height: 2), subLine!],
        ],
      ),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  final List<WeeklyData> weekly;
  const _WeeklyChart({required this.weekly});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final isDesktop = context.isDesktopLayout;

    // Ensure all 7 days present
    final data = List.generate(7, (i) {
      final day = weekly.firstWhere(
        (w) => w.weekday == i + 1,
        orElse: () => WeeklyData(weekday: i + 1, completed: 0),
      );
      return day;
    });

    final maxVal = data
        .map((d) => d.completed)
        .fold(0, (a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.panel),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.analyticsWeeklyOutput,
            style: AppText.sectionTitle.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxVal > 0 ? maxVal * 1.2 : 10,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) {
                        final idx = val.toInt();
                        if (idx < 0 || idx >= 7) return const SizedBox();
                        // Mobile: only Mon and Sun
                        if (!isDesktop && idx != 0 && idx != 6) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            data[idx].label,
                            style: AppText.caption.copyWith(color: c.textMuted),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(7, (i) {
                  final isMax = data[i].completed == maxVal && maxVal > 0;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: data[i].completed.toDouble(),
                        color: isMax
                            ? c.primary
                            : c.primary.withValues(alpha: 0.2),
                        width: 24,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryDonut extends StatelessWidget {
  final List<CategoryData> categories;
  const _CategoryDonut({required this.categories});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);

    // Top 3 + Other
    final sorted = [...categories]..sort((a, b) => b.total.compareTo(a.total));
    final top3 = sorted.take(3).toList();
    final otherTotal = sorted.skip(3).fold(0, (s, e) => s + e.total);
    if (otherTotal > 0) {
      final l10n = AppLocalizations.of(context);
      top3.add(
        CategoryData(label: l10n.all, color: '#6B7185', total: otherTotal),
      );
    }
    final total = top3.fold(0, (s, e) => s + e.total);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.panel),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.analyticsCategoryMix,
            style: AppText.sectionTitle.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: 20),
          if (top3.isEmpty)
            Center(
              child: Text(
                l10n.emptyStateNoAnalytics,
                style: AppText.body.copyWith(color: c.textMuted),
              ),
            )
          else ...[
            // Donut chart
            SizedBox(
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 55,
                      sections: top3.map((cat) {
                        Color color;
                        try {
                          color = Color(
                            int.parse(
                              'FF${cat.color.replaceAll('#', '')}',
                              radix: 16,
                            ),
                          );
                        } catch (_) {
                          color = c.primary;
                        }
                        return PieChartSectionData(
                          value: cat.total.toDouble(),
                          color: color,
                          showTitle: false,
                          radius: 40,
                        );
                      }).toList(),
                    ),
                  ),
                  // Center text
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$total',
                        style: AppText.statNumber.copyWith(
                          color: c.textPrimary,
                        ),
                      ),
                      Text(
                        l10n.navTasks.toLowerCase(),
                        style: AppText.caption.copyWith(color: c.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Legend
            ...top3.map((cat) {
              Color color;
              try {
                color = Color(
                  int.parse('FF${cat.color.replaceAll('#', '')}', radix: 16),
                );
              } catch (_) {
                color = c.primary;
              }
              final pct = total > 0 ? (100 * cat.total / total).round() : 0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        cat.label,
                        style: AppText.body.copyWith(color: c.textPrimary),
                      ),
                    ),
                    Text(
                      '$pct%',
                      style: AppText.bodyMedium.copyWith(color: c.textMuted),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

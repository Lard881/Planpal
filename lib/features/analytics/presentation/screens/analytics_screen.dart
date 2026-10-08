import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../workspaces/providers/workspace_providers.dart';
import '../analytics_providers.dart';
import '../widgets/stat_card.dart';
import '../widgets/weekly_bar_chart.dart';
import '../widgets/category_donut_chart.dart';
import '../widgets/range_selector.dart';
import '../../utils/csv_export_helper.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(analyticsDataProvider);
    final permissions = ref.watch(currentWorkspacePermissionsProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          // Export CSV button (admin/member only)
          permissions.when(
            data: (perms) {
              if (perms?.isGuest ?? true) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.file_download),
                onPressed: () => _exportCsv(context, ref),
                tooltip: 'Export CSV',
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: permissions.when(
        data: (perms) {
          // Guest permission check
          if (perms?.isGuest ?? false) {
            return _buildGuestMessage(context);
          }

          return analyticsAsync.when(
            data: (analytics) => _buildAnalyticsContent(
              context,
              ref,
              analytics,
              isDesktop,
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => _buildErrorState(context, error),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(context, error),
      ),
    );
  }

  Widget _buildAnalyticsContent(
    BuildContext context,
    WidgetRef ref,
    dynamic analytics,
    bool isDesktop,
  ) {
    // Empty state check
    if (analytics.summary.totalCreated == 0) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(analyticsDataProvider);
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Range selector
            RangeSelector(
              currentRange: ref.watch(analyticsRangeProvider),
              onRangeChanged: (range) {
                ref.read(analyticsRangeProvider.notifier).state = range;
              },
            ),
            const SizedBox(height: 8),

            // Last updated indicator
            _buildLastUpdated(ref),
            const SizedBox(height: 24),

            // Stat cards
            _buildStatCards(analytics, isDesktop),
            const SizedBox(height: 32),

            // Weekly bar chart
            Text(
              'Weekly Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            WeeklyBarChart(weeklyData: analytics.weekly),
            const SizedBox(height: 32),

            // Category donut chart
            if (analytics.categories.isNotEmpty) ...[
              Text(
                'Tasks by Category',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              CategoryDonutChart(categories: analytics.categories),
              const SizedBox(height: 32),
            ],

            // Streak info
            if (analytics.streak > 0) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      size: 48,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${analytics.streak} Day Streak! 🔥',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Keep up the great work completing tasks daily!',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatCards(dynamic analytics, bool isDesktop) {
    final summary = analytics.summary;

    if (isDesktop) {
      return Row(
        children: [
          Expanded(
            child: StatCard(
              title: 'Completed',
              value: summary.totalCompleted.toString(),
              icon: Icons.check_circle,
              color: AppColors.success,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: StatCard(
              title: 'Created',
              value: summary.totalCreated.toString(),
              icon: Icons.add_circle,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: StatCard(
              title: 'Completion Rate',
              value: '${(summary.completionRate * 100).toStringAsFixed(0)}%',
              icon: Icons.trending_up,
              color: AppColors.info,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: StatCard(
              title: 'On-Time Rate',
              value: '${(summary.onTimeRate * 100).toStringAsFixed(0)}%',
              icon: Icons.schedule,
              color: AppColors.violet,
            ),
          ),
        ],
      );
    }

    // Mobile: 2x2 grid
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Completed',
                value: summary.totalCompleted.toString(),
                icon: Icons.check_circle,
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatCard(
                title: 'Created',
                value: summary.totalCreated.toString(),
                icon: Icons.add_circle,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Completion Rate',
                value: '${(summary.completionRate * 100).toStringAsFixed(0)}%',
                icon: Icons.trending_up,
                color: AppColors.info,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatCard(
                title: 'On-Time Rate',
                value: '${(summary.onTimeRate * 100).toStringAsFixed(0)}%',
                icon: Icons.schedule,
                color: AppColors.violet,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGuestMessage(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline,
              size: 64,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              'Analytics Not Available',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Guest users cannot access workspace analytics. Please contact an admin to upgrade your role.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 64,
              color: AppColors.textMuted.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Data Yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start creating and completing tasks to see your analytics here.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to Load Analytics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    try {
      // Show loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exporting CSV...')),
      );

      // Get workspace and range
      final workspaceId = ref.read(currentWorkspaceIdProvider);
      final range = ref.read(analyticsRangeProvider);

      if (workspaceId == null) {
        throw Exception('No workspace selected');
      }

      // Get CSV data from repository
      final repository = ref.read(analyticsRepositoryProvider);
      final csvContent = await repository.exportCsv(
        workspaceId: workspaceId,
        range: range,
      );

      // Generate filename with timestamp
      final now = DateTime.now();
      final timestamp =
          '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
      final fileName = 'analytics-$range-$timestamp.csv';

      // Export using helper
      await CsvExportHelper.exportCsv(
        csvContent: csvContent,
        fileName: fileName,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              Platform.isWindows
                  ? 'CSV saved to Downloads'
                  : 'CSV shared successfully',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Widget _buildLastUpdated(WidgetRef ref) {
    final lastUpdated = ref.watch(analyticsLastUpdatedProvider);
    
    if (lastUpdated == null) return const SizedBox.shrink();

    final now = DateTime.now();
    final difference = now.difference(lastUpdated);
    
    String timeAgo;
    if (difference.inMinutes < 1) {
      timeAgo = 'Just now';
    } else if (difference.inMinutes < 60) {
      timeAgo = '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      timeAgo = '${difference.inHours}h ago';
    } else {
      timeAgo = '${difference.inDays}d ago';
    }

    return Row(
      children: [
        Icon(
          Icons.update,
          size: 14,
          color: AppColors.textMuted,
        ),
        const SizedBox(width: 4),
        Text(
          'Last updated: $timeAgo',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
                fontStyle: FontStyle.italic,
              ),
        ),
      ],
    );
  }
}

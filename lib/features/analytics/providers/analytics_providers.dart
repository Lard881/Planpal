import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../repositories/analytics_repository.dart';
import '../services/analytics_tracking_service.dart';
import '../models/analytics_dashboard.dart';
import '../models/analytics_insights.dart';

/// Analytics repository provider
final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AnalyticsRepository(apiClient: apiClient);
});

/// Analytics tracking service provider
final analyticsTrackingServiceProvider = Provider<AnalyticsTrackingService>((ref) {
  final repository = ref.watch(analyticsRepositoryProvider);
  final service = AnalyticsTrackingService(repository: repository);
  
  // Initialize on creation
  service.initialize();
  
  // Dispose on cleanup
  ref.onDispose(() => service.dispose());
  
  return service;
});

/// Date range for analytics
class AnalyticsDateRange {
  final DateTime startDate;
  final DateTime endDate;

  AnalyticsDateRange({
    required this.startDate,
    required this.endDate,
  });

  /// Last 7 days
  factory AnalyticsDateRange.last7Days() {
    final end = DateTime.now();
    final start = end.subtract(const Duration(days: 7));
    return AnalyticsDateRange(startDate: start, endDate: end);
  }

  /// Last 30 days
  factory AnalyticsDateRange.last30Days() {
    final end = DateTime.now();
    final start = end.subtract(const Duration(days: 30));
    return AnalyticsDateRange(startDate: start, endDate: end);
  }

  /// Last 90 days
  factory AnalyticsDateRange.last90Days() {
    final end = DateTime.now();
    final start = end.subtract(const Duration(days: 90));
    return AnalyticsDateRange(startDate: start, endDate: end);
  }

  /// This month
  factory AnalyticsDateRange.thisMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime.now();
    return AnalyticsDateRange(startDate: start, endDate: end);
  }

  /// Last month
  factory AnalyticsDateRange.lastMonth() {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1, 1);
    final start = DateTime(lastMonth.year, lastMonth.month, 1);
    final end = DateTime(now.year, now.month, 0); // Last day of last month
    return AnalyticsDateRange(startDate: start, endDate: end);
  }
}

/// Current analytics date range provider
final analyticsDateRangeProvider = StateProvider<AnalyticsDateRange>((ref) {
  return AnalyticsDateRange.last30Days();
});

/// Analytics dashboard provider
final analyticsDashboardProvider = FutureProvider.autoDispose<AnalyticsDashboard>((ref) async {
  final repository = ref.watch(analyticsRepositoryProvider);
  final dateRange = ref.watch(analyticsDateRangeProvider);
  final workspaceId = ref.watch(currentWorkspaceIdProvider);

  return await repository.getDashboard(
    workspaceId: workspaceId,
    startDate: dateRange.startDate,
    endDate: dateRange.endDate,
  );
});

/// Analytics insights provider
final analyticsInsightsProvider = FutureProvider.autoDispose<AnalyticsInsights>((ref) async {
  final repository = ref.watch(analyticsRepositoryProvider);
  final dateRange = ref.watch(analyticsDateRangeProvider);
  final workspaceId = ref.watch(currentWorkspaceIdProvider);

  return await repository.getInsights(
    workspaceId: workspaceId,
    startDate: dateRange.startDate,
    endDate: dateRange.endDate,
  );
});

/// Workspace analytics provider (admin only)
final workspaceAnalyticsProvider = FutureProvider.autoDispose.family<
    WorkspaceAnalytics,
    String
>((ref, workspaceId) async {
  final repository = ref.watch(analyticsRepositoryProvider);
  final dateRange = ref.watch(analyticsDateRangeProvider);

  return await repository.getWorkspaceAnalytics(
    workspaceId: workspaceId,
    startDate: dateRange.startDate,
    endDate: dateRange.endDate,
  );
});

/// Dashboard loading state provider
final dashboardLoadingProvider = Provider<bool>((ref) {
  final asyncValue = ref.watch(analyticsDashboardProvider);
  return asyncValue.isLoading;
});

/// Dashboard error provider
final dashboardErrorProvider = Provider<String?>((ref) {
  final asyncValue = ref.watch(analyticsDashboardProvider);
  return asyncValue.hasError ? asyncValue.error.toString() : null;
});

/// Insights loading state provider
final insightsLoadingProvider = Provider<bool>((ref) {
  final asyncValue = ref.watch(analyticsInsightsProvider);
  return asyncValue.isLoading;
});

/// Insights error provider
final insightsErrorProvider = Provider<String?>((ref) {
  final asyncValue = ref.watch(analyticsInsightsProvider);
  return asyncValue.hasError ? asyncValue.error.toString() : null;
});

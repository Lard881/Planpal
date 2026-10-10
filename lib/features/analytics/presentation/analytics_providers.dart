import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../sync/providers/sync_providers.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../features/auth/presentation/auth_providers.dart';
import '../../../features/workspaces/providers/workspace_providers.dart';
import '../data/analytics_repository.dart';
import '../models/analytics_data.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final accessToken = ref.watch(accessTokenProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return AnalyticsRepository(
    dio: dio,
    accessToken: accessToken,
    prefs: prefs,
  );
});

/// Current analytics range
final analyticsRangeProvider = StateProvider<String>((ref) => '7d');

/// Analytics data provider
final analyticsDataProvider =
    FutureProvider.autoDispose<AnalyticsData>((ref) async {
  final repository = ref.watch(analyticsRepositoryProvider);
  final workspaceId = ref.watch(currentWorkspaceIdProvider);
  final range = ref.watch(analyticsRangeProvider);

  if (workspaceId == null) {
    throw Exception('No workspace selected');
  }

  return repository.getAnalytics(
    workspaceId: workspaceId,
    range: range,
  );
});

/// Overview data provider (for home dashboard)
final overviewDataProvider =
    FutureProvider.autoDispose<OverviewData>((ref) async {
  final repository = ref.watch(analyticsRepositoryProvider);
  final workspaceId = ref.watch(currentWorkspaceIdProvider);

  if (workspaceId == null) {
    throw Exception('No workspace selected');
  }

  return repository.getOverview(
    workspaceId: workspaceId,
    range: 'week',
  );
});

/// Last updated timestamp provider
final analyticsLastUpdatedProvider = Provider<DateTime?>((ref) {
  final repository = ref.watch(analyticsRepositoryProvider);
  final workspaceId = ref.watch(currentWorkspaceIdProvider);
  final range = ref.watch(analyticsRangeProvider);

  if (workspaceId == null) return null;

  return repository.getLastUpdated(workspaceId, range);
});

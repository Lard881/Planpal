import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/home_repository.dart';
import '../models/dashboard_overview.dart';
import '../../../core/providers/app_providers.dart';
import '../../workspaces/providers/workspace_providers.dart';

/// Home repository provider
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return HomeRepository(dio);
});

/// Dashboard range provider (week, 7d, 30d)
final dashboardRangeProvider = StateProvider<String>((ref) => 'week');

/// Dashboard overview provider
/// Fetches overview data from /workspaces/:id/overview
final dashboardOverviewProvider = FutureProvider.autoDispose<DashboardOverview?>((ref) async {
  final workspaceId = ref.watch(currentWorkspaceIdProvider);
  if (workspaceId == null) return null;

  final range = ref.watch(dashboardRangeProvider);
  final repository = ref.watch(homeRepositoryProvider);

  try {
    return await repository.getOverview(workspaceId, range: range);
  } catch (e) {
    // Return null on error - will show fallback UI
    return null;
  }
});

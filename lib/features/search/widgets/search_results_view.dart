import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_providers.dart';
import 'workspace_scope_toggle.dart';
import 'search_mode_indicator.dart';
import 'search_filter_chips.dart';
import 'search_result_list.dart';
import 'search_skeleton_loader.dart';

/// Search results view widget
class SearchResultsView extends ConsumerWidget {
  final String query;

  const SearchResultsView({
    super.key,
    required this.query,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncResults = ref.watch(searchResultsProvider);

    return asyncResults.when(
      data: (results) {
        if (results == null) {
          return _buildMinimumCharactersMessage(context);
        }

        if (results.totalCount == 0) {
          return _buildEmptyState(context, results);
        }

        return _buildResults(context, results);
      },
      loading: () => _buildLoadingState(context),
      error: (error, stack) => _buildErrorState(context, ref, error),
    );
  }

  /// Minimum characters message
  Widget _buildMinimumCharactersMessage(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Start typing to search',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter at least 2 characters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// Empty state with no results
  Widget _buildEmptyState(BuildContext context, SearchResults results) {
    return Column(
      children: [
        const WorkspaceScopeToggle(),
        const SearchModeIndicator(),
        SearchFilterChips(results: results),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No results found',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try different keywords or filters',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  _buildSearchTips(context),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Search tips for empty state
  Widget _buildSearchTips(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search Tips:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            _buildTip(context, 'Try simpler or more general terms'),
            _buildTip(context, 'Check your spelling'),
            _buildTip(context, 'Use the filters above to narrow results'),
            _buildTip(context, 'Switch to "All Workspaces" if needed'),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  /// Loading state with skeleton
  Widget _buildLoadingState(BuildContext context) {
    return Column(
      children: [
        const WorkspaceScopeToggle(),
        const SearchModeIndicator(),
        SearchFilterChips(results: null),
        const Divider(height: 1),
        Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Searching...',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        const Expanded(
          child: SearchSkeletonLoader(),
        ),
      ],
    );
  }

  /// Results with data
  Widget _buildResults(BuildContext context, SearchResults results) {
    return Column(
      children: [
        // Workspace scope toggle
        const WorkspaceScopeToggle(),

        // Offline mode indicator
        const SearchModeIndicator(),

        // Filter chips
        SearchFilterChips(results: results),
        const Divider(height: 1),

        // Results count
        Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.centerLeft,
          child: Text(
            _getResultsCountText(results),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),

        // Results list
        Expanded(
          child: SearchResultList(results: results),
        ),
      ],
    );
  }

  /// Error state with retry
  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Column(
      children: [
        const WorkspaceScopeToggle(),
        const SearchModeIndicator(),
        SearchFilterChips(results: null),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Search failed',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getErrorMessage(error),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => _retrySearch(ref),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => _showErrorDetails(context, error),
                    child: const Text('Show details'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Get user-friendly error message
  String _getErrorMessage(Object error) {
    final errorString = error.toString();
    
    if (errorString.contains('connection') || errorString.contains('network')) {
      return 'Could not connect to server. Check your internet connection.';
    } else if (errorString.contains('timeout')) {
      return 'Request timed out. Please try again.';
    } else if (errorString.contains('Invalid search query')) {
      return 'Invalid search query. Please try different keywords.';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }

  /// Retry search by invalidating provider
  void _retrySearch(WidgetRef ref) {
    ref.invalidate(searchResultsProvider);
  }

  /// Show error details in dialog
  void _showErrorDetails(BuildContext context, Object error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error Details'),
        content: SingleChildScrollView(
          child: Text(
            error.toString(),
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _getResultsCountText(SearchResults results) {
    final filter = results.type;

    if (filter == 'all') {
      return '${results.totalCount} result${results.totalCount == 1 ? '' : 's'}';
    } else if (filter == 'tasks') {
      return '${results.tasks.count} task${results.tasks.count == 1 ? '' : 's'}';
    } else if (filter == 'documents') {
      return '${results.documents.count} document${results.documents.count == 1 ? '' : 's'}';
    } else if (filter == 'people') {
      return '${results.people.count} ${results.people.count == 1 ? 'person' : 'people'}';
    }

    return '${results.totalCount} results';
  }
}

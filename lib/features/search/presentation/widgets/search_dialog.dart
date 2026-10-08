import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../search_providers.dart';
import 'search_results_list.dart';
import 'search_type_chips.dart';

/// Desktop search dialog - opened with Ctrl+K
class SearchDialog extends ConsumerStatefulWidget {
  const SearchDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const SearchDialog(),
    );
  }

  @override
  ConsumerState<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends ConsumerState<SearchDialog> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResponse = ref.watch(searchResultsProvider);
    final currentType = ref.watch(searchTypeProvider);
    final isOffline = ref.watch(isOfflineSearchProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 700,
        height: 600,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Search field
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.border,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: 'Search tasks, documents, people... (Ctrl+K)',
                        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMuted,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                      onChanged: (value) {
                        ref.read(searchQueryProvider.notifier).state = value;
                      },
                      onSubmitted: (_) {
                        // Close on Enter if there's a result
                        final results = ref.read(searchResultsProvider);
                        results.whenData((data) {
                          if (data.results.isNotEmpty) {
                            Navigator.pop(context);
                          }
                        });
                      },
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(searchQueryProvider.notifier).state = '';
                      },
                    ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Text('ESC'),
                    label: const Text('Close'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),

            // Offline indicator
            if (isOffline)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.border,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.cloud_off,
                      size: 16,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Offline - Searching local cache only',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.warning,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),

            // Workspace scope switch
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.border,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _WorkspaceScopeSwitch(),
                  ),
                ],
              ),
            ),

            // Type filter chips
            searchResponse.when(
              data: (response) => SearchTypeChips(
                counts: response.counts,
                currentType: currentType,
                onTypeSelected: (type) {
                  ref.read(searchTypeProvider.notifier).state = type;
                },
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            // Results
            Expanded(
              child: searchResponse.when(
                data: (response) {
                  if (_searchController.text.trim().length < 2) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search,
                            size: 64,
                            color: AppColors.textMuted.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Type at least 2 characters to search',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (response.results.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: AppColors.textMuted.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No results found',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try different keywords',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return SearchResultsList(
                    results: response.results,
                    onResultTap: () {
                      // Close dialog after navigating
                      Navigator.pop(context);
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
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
                        'Search failed',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkspaceScopeSwitch extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWorkspaceId = ref.watch(searchWorkspaceProvider);
    // TODO: Get current workspace name from workspaces provider
    final isAllWorkspaces = currentWorkspaceId == null;

    return Row(
      children: [
        Text(
          'Search in:',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                value: false,
                label: Text('This workspace'),
              ),
              ButtonSegment(
                value: true,
                label: Text('All workspaces'),
              ),
            ],
            selected: {isAllWorkspaces},
            onSelectionChanged: (Set<bool> selection) {
              if (selection.first) {
                // All workspaces
                ref.read(searchWorkspaceProvider.notifier).state = null;
              } else {
                // Current workspace
                // TODO: Get current workspace ID from workspace provider
                // For now, we'll implement this when we integrate with workspace context
                ref.read(searchWorkspaceProvider.notifier).state = null;
              }
            },
          ),
        ),
      ],
    );
  }
}

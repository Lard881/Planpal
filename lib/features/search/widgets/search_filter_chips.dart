import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_providers.dart';
import '../models/search_result.dart';

/// Search filter chips widget
class SearchFilterChips extends ConsumerWidget {
  final SearchResults? results;

  const SearchFilterChips({
    super.key,
    this.results,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(searchFilterProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildFilterChip(
            context,
            ref,
            label: 'All',
            count: results?.totalCount ?? 0,
            type: 'all',
            isSelected: currentFilter.type == 'all',
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context,
            ref,
            label: 'Tasks',
            count: results?.tasks.count ?? 0,
            type: 'tasks',
            isSelected: currentFilter.type == 'tasks',
            icon: Icons.task_alt,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context,
            ref,
            label: 'Documents',
            count: results?.documents.count ?? 0,
            type: 'documents',
            isSelected: currentFilter.type == 'documents',
            icon: Icons.description_outlined,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context,
            ref,
            label: 'People',
            count: results?.people.count ?? 0,
            type: 'people',
            isSelected: currentFilter.type == 'people',
            icon: Icons.person_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required int count,
    required String type,
    required bool isSelected,
    IconData? icon,
  }) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16),
            const SizedBox(width: 4),
          ],
          Text(label),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.2)
                  : Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        final currentFilter = ref.read(searchFilterProvider);
        ref.read(searchFilterProvider.notifier).state = currentFilter.copyWith(
          type: type,
          offset: 0, // Reset pagination when filter changes
        );
      },
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
    );
  }
}

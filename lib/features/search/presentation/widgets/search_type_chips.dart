import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/search_repository.dart';
import '../../models/search_response.dart';

class SearchTypeChips extends StatelessWidget {
  final SearchCounts counts;
  final SearchType currentType;
  final Function(SearchType) onTypeSelected;

  const SearchTypeChips({
    super.key,
    required this.counts,
    required this.currentType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildChip(
              label: 'All',
              count: counts.all,
              type: SearchType.all,
              icon: Icons.search,
              context: context,
            ),
            const SizedBox(width: 8),
            _buildChip(
              label: 'Tasks',
              count: counts.task,
              type: SearchType.task,
              icon: Icons.check_circle_outline,
              context: context,
            ),
            const SizedBox(width: 8),
            _buildChip(
              label: 'Documents',
              count: counts.document,
              type: SearchType.document,
              icon: Icons.description_outlined,
              context: context,
            ),
            const SizedBox(width: 8),
            _buildChip(
              label: 'People',
              count: counts.person,
              type: SearchType.person,
              icon: Icons.person_outline,
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required int count,
    required SearchType type,
    required IconData icon,
    required BuildContext context,
  }) {
    final isSelected = currentType == type;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? AppColors.onPrimary : AppColors.textMuted,
          ),
          const SizedBox(width: 6),
          Text(
            '$label ($count)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isSelected ? AppColors.onPrimary : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onTypeSelected(type),
      backgroundColor: AppColors.background,
      selectedColor: AppColors.primary,
      checkmarkColor: AppColors.onPrimary,
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.border,
        width: 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}

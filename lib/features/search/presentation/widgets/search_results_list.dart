import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../models/search_result.dart';

class SearchResultsList extends ConsumerWidget {
  final List<SearchResult> results;
  final VoidCallback? onResultTap;

  const SearchResultsList({
    super.key,
    required this.results,
    this.onResultTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Group results by entity type
    final tasks = results.where((r) => r.entityType == 'task').toList();
    final documents = results.where((r) => r.entityType == 'document').toList();
    final people = results.where((r) => r.entityType == 'person').toList();

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        if (tasks.isNotEmpty) ...[
          _buildSectionHeader('Tasks', tasks.length, context),
          ...tasks.map((result) => _SearchResultTile(
                result: result,
                onResultTap: onResultTap,
              )),
        ],
        if (documents.isNotEmpty) ...[
          _buildSectionHeader('Documents', documents.length, context),
          ...documents.map((result) => _SearchResultTile(
                result: result,
                onResultTap: onResultTap,
              )),
        ],
        if (people.isNotEmpty) ...[
          _buildSectionHeader('People', people.length, context),
          ...people.map((result) => _SearchResultTile(
                result: result,
                onResultTap: onResultTap,
              )),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, int count, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        '$title ($count)',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textMuted,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SearchResultTile extends ConsumerWidget {
  final SearchResult result;
  final VoidCallback? onResultTap;

  const _SearchResultTile({
    required this.result,
    this.onResultTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: _buildLeading(),
      title: Text(
        result.title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (result.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              result.subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 4),
          Row(
            children: [
              // Workspace badge
              if (result.workspaceName != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    result.workspaceName!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              // Match percentage
              if (result.matchRank != null) ...[
                Icon(
                  Icons.star,
                  size: 12,
                  color: AppColors.warning,
                ),
                const SizedBox(width: 4),
                Text(
                  '${result.matchPercentage}% match',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppColors.textMuted,
      ),
      onTap: () => _handleTap(context, ref),
    );
  }

  Widget _buildLeading() {
    if (result.entityType == 'person' && result.avatarUrl != null) {
      return CircleAvatar(
        radius: 20,
        backgroundImage: CachedNetworkImageProvider(result.avatarUrl!),
      );
    }

    IconData icon;
    Color color;

    switch (result.entityType) {
      case 'task':
        icon = Icons.check_circle_outline;
        color = AppColors.success;
        break;
      case 'document':
        icon = Icons.description_outlined;
        color = AppColors.info;
        break;
      case 'person':
        icon = Icons.person_outline;
        color = AppColors.primary;
        break;
      default:
        icon = Icons.help_outline;
        color = AppColors.textMuted;
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: color.withValues(alpha: 0.1),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }

  void _handleTap(BuildContext context, WidgetRef ref) {
    // Call the callback first
    onResultTap?.call();

    // Navigate to the entity detail screen
    // TODO: Implement navigation based on entity type (S12.5)
    switch (result.entityType) {
      case 'task':
        // Navigate to task detail
        // Navigator.push(context, MaterialPageRoute(
        //   builder: (_) => TaskDetailScreen(taskId: result.entityId),
        // ));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Open task: ${result.title}')),
        );
        break;
      case 'document':
        // Navigate to document detail
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Open document: ${result.title}')),
        );
        break;
      case 'person':
        // Navigate to person profile
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Open profile: ${result.title}')),
        );
        break;
    }
  }
}

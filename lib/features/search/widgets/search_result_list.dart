import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/search_result.dart';

/// Search result list widget with grouped results and navigation
class SearchResultList extends StatelessWidget {
  final SearchResults results;

  const SearchResultList({
    super.key,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    final currentFilter = results.type;
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Tasks section
        if (currentFilter == 'all' || currentFilter == 'tasks')
          ..._buildTasksSection(context, theme),

        // Spacing between sections
        if (currentFilter == 'all' && results.documents.count > 0 && results.tasks.count > 0)
          const SizedBox(height: 16),

        // Documents section
        if (currentFilter == 'all' || currentFilter == 'documents')
          ..._buildDocumentsSection(context, theme),

        // Spacing between sections
        if (currentFilter == 'all' && results.people.count > 0 && 
            (results.tasks.count > 0 || results.documents.count > 0))
          const SizedBox(height: 16),

        // People section
        if (currentFilter == 'all' || currentFilter == 'people')
          ..._buildPeopleSection(context, theme),
      ],
    );
  }

  /// Build tasks section with header
  List<Widget> _buildTasksSection(BuildContext context, ThemeData theme) {
    if (results.tasks.count == 0) return [];

    final widgets = <Widget>[];

    // Section header (only in 'all' view)
    if (results.type == 'all') {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Icon(Icons.task_alt, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Tasks',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${results.tasks.count}',
                  style: theme.textTheme.labelSmall,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Task items
    for (final item in results.tasks.items) {
      final task = item as Map<String, dynamic>;
      widgets.add(_buildTaskCard(context, theme, task));
    }

    return widgets;
  }

  /// Build documents section with header
  List<Widget> _buildDocumentsSection(BuildContext context, ThemeData theme) {
    if (results.documents.count == 0) return [];

    final widgets = <Widget>[];

    // Section header (only in 'all' view)
    if (results.type == 'all') {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Icon(Icons.description_outlined, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Documents',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${results.documents.count}',
                  style: theme.textTheme.labelSmall,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Document items
    for (final item in results.documents.items) {
      final doc = item as Map<String, dynamic>;
      widgets.add(_buildDocumentCard(context, theme, doc));
    }

    return widgets;
  }

  /// Build people section with header
  List<Widget> _buildPeopleSection(BuildContext context, ThemeData theme) {
    if (results.people.count == 0) return [];

    final widgets = <Widget>[];

    // Section header (only in 'all' view)
    if (results.type == 'all') {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Icon(Icons.people_outline, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'People',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${results.people.count}',
                  style: theme.textTheme.labelSmall,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // People items
    for (final item in results.people.items) {
      final person = item as Map<String, dynamic>;
      widgets.add(_buildPersonCard(context, theme, person));
    }

    return widgets;
  }

  /// Build task card
  Widget _buildTaskCard(BuildContext context, ThemeData theme, Map<String, dynamic> task) {
    final matchScore = task['matchScore'] as int? ?? 0;
    final status = task['status'] as String? ?? 'todo';
    final priority = task['priority'] as String?;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _navigateToTask(context, task['id'] as String),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Status icon
                  Icon(
                    _getTaskStatusIcon(status),
                    size: 20,
                    color: _getTaskStatusColor(status, theme),
                  ),
                  const SizedBox(width: 8),
                  // Title
                  Expanded(
                    child: Text(
                      task['title'] ?? '',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // Match score badge
                  _buildMatchBadge(theme, matchScore),
                ],
              ),
              if (task['description'] != null) ...[
                const SizedBox(height: 8),
                Text(
                  task['description'],
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              // Metadata row
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (priority != null)
                    _buildChip(theme, _getPriorityLabel(priority), _getPriorityColor(priority, theme)),
                  if (task['workspaceName'] != null)
                    _buildChip(theme, task['workspaceName'], theme.colorScheme.secondaryContainer),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build document card
  Widget _buildDocumentCard(BuildContext context, ThemeData theme, Map<String, dynamic> doc) {
    final matchScore = doc['matchScore'] as int? ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _navigateToDocument(context, doc['id'] as String),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.description_outlined, size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      doc['title'] ?? '',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _buildMatchBadge(theme, matchScore),
                ],
              ),
              if (doc['content'] != null) ...[
                const SizedBox(height: 8),
                Text(
                  doc['content'],
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              if (doc['workspaceName'] != null)
                _buildChip(theme, doc['workspaceName'], theme.colorScheme.secondaryContainer),
            ],
          ),
        ),
      ),
    );
  }

  /// Build person card
  Widget _buildPersonCard(BuildContext context, ThemeData theme, Map<String, dynamic> person) {
    final matchScore = person['matchScore'] as int? ?? 0;
    final workspaces = person['workspaces'] as List<dynamic>? ?? [];

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _navigateToPerson(context, person['id'] as String),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundImage: person['avatarUrl'] != null
                    ? NetworkImage(person['avatarUrl'])
                    : null,
                child: person['avatarUrl'] == null
                    ? const Icon(Icons.person)
                    : null,
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      person['fullName'] ?? '',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      person['email'] ?? '',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (workspaces.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: workspaces.take(3).map((ws) {
                          final workspace = ws as Map<String, dynamic>;
                          return _buildChip(
                            theme,
                            workspace['name'] ?? '',
                            theme.colorScheme.secondaryContainer,
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              // Match score
              _buildMatchBadge(theme, matchScore),
            ],
          ),
        ),
      ),
    );
  }

  /// Build match score badge
  Widget _buildMatchBadge(ThemeData theme, int score) {
    Color badgeColor;
    if (score >= 80) {
      badgeColor = theme.colorScheme.primaryContainer;
    } else if (score >= 50) {
      badgeColor = theme.colorScheme.secondaryContainer;
    } else {
      badgeColor = theme.colorScheme.surfaceVariant;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$score%',
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Build metadata chip
  Widget _buildChip(ThemeData theme, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall,
      ),
    );
  }

  /// Navigate to task detail
  void _navigateToTask(BuildContext context, String taskId) {
    context.push('/tasks/$taskId');
  }

  /// Navigate to document detail (placeholder - will be implemented in documents stage)
  void _navigateToDocument(BuildContext context, String documentId) {
    // TODO: Implement when documents stage is complete
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document viewer coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Navigate to person profile (placeholder - will be implemented in team/profile stage)
  void _navigateToPerson(BuildContext context, String userId) {
    // TODO: Implement when profile/team stage is complete
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User profile coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Helper methods for task styling
  IconData _getTaskStatusIcon(String status) {
    switch (status) {
      case 'completed':
        return Icons.check_circle;
      case 'in_progress':
        return Icons.pending;
      case 'blocked':
        return Icons.block;
      default:
        return Icons.circle_outlined;
    }
  }

  Color _getTaskStatusColor(String status, ThemeData theme) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.blue;
      case 'blocked':
        return Colors.red;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  String _getPriorityLabel(String priority) {
    switch (priority) {
      case 'high':
        return 'High Priority';
      case 'medium':
        return 'Medium';
      case 'low':
        return 'Low';
      default:
        return priority;
    }
  }

  Color _getPriorityColor(String priority, ThemeData theme) {
    switch (priority) {
      case 'high':
        return Colors.red.shade100;
      case 'medium':
        return Colors.orange.shade100;
      case 'low':
        return Colors.green.shade100;
      default:
        return theme.colorScheme.surfaceVariant;
    }
  }
}

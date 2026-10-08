import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/sync/sync_engine.dart' as sync;
import '../../core/providers/app_providers.dart';

/// Dialog for manually resolving sync conflicts
class SyncConflictDialog extends ConsumerWidget {
  final sync.SyncConflict conflict;

  const SyncConflictDialog({
    super.key,
    required this.conflict,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber,
                    color: Colors.orange,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sync Conflict',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'This ${conflict.entityType} was modified on both local and server',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.7),
                              ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Conflict info
                    _buildInfoCard(context),
                    const SizedBox(height: 20),

                    // Local version
                    _buildVersionCard(
                      context,
                      'Your Local Version',
                      conflict.localData,
                      conflict.localUpdatedAt,
                      Icons.phone_android,
                      Colors.blue,
                    ),
                    const SizedBox(height: 16),

                    // Server version
                    _buildVersionCard(
                      context,
                      'Server Version',
                      conflict.remoteData,
                      conflict.remoteUpdatedAt,
                      Icons.cloud,
                      Colors.green,
                    ),
                  ],
                ),
              ),
            ),

            // Actions
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Which version would you like to keep?',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _resolveConflict(context, ref, useLocal: true),
                          icon: const Icon(Icons.phone_android),
                          label: const Text('Keep Local'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Colors.blue),
                            foregroundColor: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _resolveConflict(context, ref, useLocal: false),
                          icon: const Icon(Icons.cloud),
                          label: const Text('Keep Server'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Both versions were modified at different times. Review the changes below and choose which one to keep.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionCard(
    BuildContext context,
    String title,
    Map<String, dynamic> data,
    DateTime updatedAt,
    IconData icon,
    Color color,
  ) {
    // Extract relevant fields based on entity type
    final displayData = _getDisplayData(data);

    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Last modified: ${_formatDateTime(updatedAt)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.6),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Card content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: displayData.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildDataRow(context, entry.key, entry.value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value.isEmpty ? '(empty)' : value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Map<String, String> _getDisplayData(Map<String, dynamic> data) {
    final result = <String, String>{};

    // Common fields for all entity types
    if (data.containsKey('title')) {
      result['Title'] = data['title']?.toString() ?? '';
    }
    if (data.containsKey('name')) {
      result['Name'] = data['name']?.toString() ?? '';
    }
    if (data.containsKey('description')) {
      result['Description'] = data['description']?.toString() ?? '';
    }

    // Task-specific fields
    if (data.containsKey('priority')) {
      result['Priority'] = data['priority']?.toString() ?? '';
    }
    if (data.containsKey('status')) {
      result['Status'] = data['status']?.toString() ?? '';
    }
    if (data.containsKey('due_date')) {
      final dueDate = data['due_date'];
      result['Due Date'] = dueDate != null ? _formatDate(dueDate.toString()) : 'Not set';
    }

    // Project-specific fields
    if (data.containsKey('color')) {
      result['Color'] = data['color']?.toString() ?? '';
    }
    if (data.containsKey('icon')) {
      result['Icon'] = data['icon']?.toString() ?? '';
    }

    return result;
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return isoDate;
    }
  }

  Future<void> _resolveConflict(
    BuildContext context,
    WidgetRef ref,
    {required bool useLocal}
  ) async {
    final syncEngine = ref.read(syncEngineProvider);

    try {
      await syncEngine.resolveConflict(conflict, useLocal);
      
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              useLocal 
                  ? 'Kept local version and synced to server' 
                  : 'Applied server version to local',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resolve conflict: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// Show conflict resolution dialog
void showConflictDialog(BuildContext context, sync.SyncConflict conflict) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => SyncConflictDialog(conflict: conflict),
  );
}

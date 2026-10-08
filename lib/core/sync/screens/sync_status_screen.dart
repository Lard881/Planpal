import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_colors.dart';

/// Sync Status Screen
/// Shows sync state, pending operations, failed items with retry/discard options
class SyncStatusScreen extends ConsumerWidget {
  const SyncStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Get sync status from provider
    final syncState = 'idle'; // 'syncing', 'idle', 'error'
    final lastSyncTime = 'Just now';
    final pendingItems = _getDummyPendingItems();
    final failedItems = _getDummyFailedItems();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Status'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // TODO: Trigger manual sync
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sync started...')),
              );
            },
            tooltip: 'Sync now',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sync State Card
            _buildSyncStateCard(context, syncState, lastSyncTime),
            const SizedBox(height: 24),

            // Pending Items
            if (pendingItems.isNotEmpty) ...[
              _buildSectionHeader(
                context,
                'Waiting to Sync',
                '${pendingItems.length} items',
                Icons.schedule,
                AppColors.warning,
              ),
              const SizedBox(height: 12),
              ...pendingItems.map((item) => _buildPendingItem(context, item)),
              const SizedBox(height: 24),
            ],

            // Failed Items
            if (failedItems.isNotEmpty) ...[
              _buildSectionHeader(
                context,
                'Failed',
                '${failedItems.length} items',
                Icons.error,
                AppColors.danger,
              ),
              const SizedBox(height: 12),
              ...failedItems.map((item) => _buildFailedItem(context, item)),
            ],

            // Empty State
            if (pendingItems.isEmpty && failedItems.isEmpty) ...[
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.cloud_done,
                      size: 80,
                      color: AppColors.success,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'All synced!',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'All changes have been synced to the server',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSyncStateCard(BuildContext context, String state, String lastSync) {
    IconData icon;
    Color color;
    String statusText;

    switch (state) {
      case 'syncing':
        icon = Icons.sync;
        color = AppColors.primary;
        statusText = 'Syncing...';
        break;
      case 'error':
        icon = Icons.sync_problem;
        color = AppColors.danger;
        statusText = 'Sync failed';
        break;
      default:
        icon = Icons.cloud_done;
        color = AppColors.success;
        statusText = 'Up to date';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statusText,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Last synced: $lastSync',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPendingItem(BuildContext context, Map<String, String> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.warning.withOpacity(0.1),
          child: Icon(_getEntityIcon(item['type']!), 
            size: 20, 
            color: AppColors.warning,
          ),
        ),
        title: Text(item['title']!),
        subtitle: Text('${item['type']!} • ${item['operation']!}'),
        trailing: const Icon(Icons.schedule, color: AppColors.warning),
      ),
    );
  }

  Widget _buildFailedItem(BuildContext context, Map<String, String> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.danger.withOpacity(0.1),
          child: Icon(_getEntityIcon(item['type']!), 
            size: 20, 
            color: AppColors.danger,
          ),
        ),
        title: Text(item['title']!),
        subtitle: Text('${item['type']!} • ${item['operation']!}'),
        trailing: const Icon(Icons.error, color: AppColors.danger),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Error message
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, 
                        size: 16, 
                        color: AppColors.danger,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item['error']!,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.danger,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                
                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        // TODO: Discard failed item
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Item discarded')),
                        );
                      },
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('Discard'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Retry failed item
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Retrying...')),
                        );
                      },
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getEntityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'task':
        return Icons.task_alt;
      case 'comment':
        return Icons.comment;
      case 'event':
        return Icons.event;
      case 'document':
        return Icons.description;
      default:
        return Icons.sync;
    }
  }

  List<Map<String, String>> _getDummyPendingItems() {
    return [
      {
        'type': 'Task',
        'title': 'Complete project proposal',
        'operation': 'Create',
      },
      {
        'type': 'Comment',
        'title': 'Great work on this!',
        'operation': 'Create',
      },
    ];
  }

  List<Map<String, String>> _getDummyFailedItems() {
    return [
      {
        'type': 'Task',
        'title': 'Review design mockups',
        'operation': 'Update',
        'error': 'Network error - please check your connection',
      },
    ];
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../connectivity/connectivity_providers.dart';
import '../sync/sync_manager.dart';
import '../offline_queue/offline_queue_providers.dart';
import '../database/app_database.dart';

/// Bottom sheet showing detailed sync information
class SyncDetailsBottomSheet extends ConsumerWidget {
  const SyncDetailsBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return const SyncDetailsBottomSheet();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.sync, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  'Sync Details',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          
          const Divider(),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ConnectivitySection(),
                  const SizedBox(height: 24),
                  _SyncStateSection(),
                  const SizedBox(height: 24),
                  _QueueSection(),
                  const SizedBox(height: 24),
                  _PendingOperationsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Connectivity section
class _ConnectivitySection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final stateAsync = ref.watch(connectivityStateStreamProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Connectivity',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        stateAsync.when(
          data: (state) {
            final isOnline = state.status.isOnline;
            final networkType = state.networkType;
            final timeSince = DateTime.now().difference(state.lastChanged);

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _DetailRow(
                      icon: isOnline ? Icons.wifi : Icons.wifi_off,
                      label: 'Status',
                      value: isOnline ? 'Online' : 'Offline',
                      valueColor: isOnline ? Colors.green : Colors.red,
                    ),
                    if (isOnline) ...[
                      const SizedBox(height: 12),
                      _DetailRow(
                        icon: Icons.network_check,
                        label: 'Network Type',
                        value: networkType.name.toUpperCase(),
                      ),
                    ],
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.access_time,
                      label: 'Last Changed',
                      value: _formatDuration(timeSince),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (_, __) => const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Error loading connectivity status'),
            ),
          ),
        ),
      ],
    );
  }
}

/// Sync state section
class _SyncStateSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final syncStateAsync = ref.watch(syncStateStreamProvider);
    final timeSinceLastSyncAsync = ref.watch(timeSinceLastSyncProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sync Status',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        syncStateAsync.when(
          data: (syncState) {
            String statusText;
            IconData statusIcon;
            Color statusColor;

            if (syncState.isLoading) {
              statusText = 'Syncing...';
              statusIcon = Icons.sync;
              statusColor = theme.colorScheme.primary;
            } else if (syncState.isSuccess) {
              statusText = 'Success';
              statusIcon = Icons.check_circle;
              statusColor = Colors.green;
            } else if (syncState.hasConflicts) {
              statusText = 'Conflicts';
              statusIcon = Icons.warning_amber;
              statusColor = Colors.amber;
            } else if (syncState.isError) {
              statusText = 'Error';
              statusIcon = Icons.error;
              statusColor = Colors.red;
            } else {
              statusText = 'Idle';
              statusIcon = Icons.cloud_queue;
              statusColor = Colors.grey;
            }

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _DetailRow(
                      icon: statusIcon,
                      label: 'Current State',
                      value: statusText,
                      valueColor: statusColor,
                    ),
                    if (timeSinceLastSyncAsync.value != null) ...[
                      const SizedBox(height: 12),
                      _DetailRow(
                        icon: Icons.schedule,
                        label: 'Last Sync',
                        value: _formatDuration(timeSinceLastSyncAsync.value!),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
          loading: () => const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (_, __) => const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Error loading sync status'),
            ),
          ),
        ),
      ],
    );
  }
}

/// Queue section
class _QueueSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final queueStatsAsync = ref.watch(queueStatsStreamProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Queue Statistics',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        queueStatsAsync.when(
          data: (stats) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _DetailRow(
                      icon: Icons.pending_actions,
                      label: 'Pending Operations',
                      value: '${stats.pendingOperations}',
                      valueColor: stats.pendingOperations > 0 ? Colors.orange : Colors.green,
                    ),
                    if (stats.failedOperations > 0) ...[
                      const SizedBox(height: 12),
                      _DetailRow(
                        icon: Icons.error_outline,
                        label: 'Failed Operations',
                        value: '${stats.failedOperations}',
                        valueColor: Colors.red,
                      ),
                    ],
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.list_alt,
                      label: 'Total in Queue',
                      value: '${stats.totalOperations}',
                    ),
                    if (stats.oldestOperation != null) ...[
                      const SizedBox(height: 12),
                      _DetailRow(
                        icon: Icons.history,
                        label: 'Oldest Operation',
                        value: _formatDateTime(stats.oldestOperation!),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
          loading: () => const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (_, __) => const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Error loading queue stats'),
            ),
          ),
        ),
      ],
    );
  }
}

/// Pending operations list section
class _PendingOperationsSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final operationsAsync = ref.watch(allPendingOperationsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pending Operations',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        operationsAsync.when(
          data: (operations) {
            if (operations.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 12),
                      Text('No pending operations'),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: operations.take(10).map((op) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(_getOperationIcon(op.operation)),
                    title: Text(
                      '${op.operation.toUpperCase()} ${op.entityType}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Created: ${_formatDateTime(op.createdAt)}',
                      style: theme.textTheme.bodySmall,
                    ),
                    trailing: op.retryCount > 0
                        ? Chip(
                            label: Text('Retry ${op.retryCount}'),
                            backgroundColor: Colors.orange.shade100,
                          )
                        : null,
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (_, __) => const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Error loading operations'),
            ),
          ),
        ),
      ],
    );
  }

  IconData _getOperationIcon(String operation) {
    switch (operation) {
      case 'insert':
        return Icons.add_circle_outline;
      case 'update':
        return Icons.edit_outlined;
      case 'delete':
        return Icons.delete_outline;
      default:
        return Icons.help_outline;
    }
  }
}

/// Detail row widget
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20, color: theme.textTheme.bodySmall?.color),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

/// Format duration helper
String _formatDuration(Duration duration) {
  if (duration.inSeconds < 60) {
    return '${duration.inSeconds}s ago';
  } else if (duration.inMinutes < 60) {
    return '${duration.inMinutes}m ago';
  } else if (duration.inHours < 24) {
    return '${duration.inHours}h ago';
  } else {
    return '${duration.inDays}d ago';
  }
}

/// Format datetime helper
String _formatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inMinutes < 1) {
    return 'Just now';
  } else if (difference.inHours < 1) {
    return '${difference.inMinutes}m ago';
  } else if (difference.inDays < 1) {
    return DateFormat('HH:mm').format(dateTime);
  } else if (difference.inDays < 7) {
    return '${difference.inDays}d ago';
  } else {
    return DateFormat('MMM d').format(dateTime);
  }
}

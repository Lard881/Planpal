import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../connectivity/connectivity_providers.dart';
import '../../features/sync/providers/sync_providers.dart';
import '../offline_queue/offline_queue_providers.dart';

/// Sync status indicator widget
/// Shows sync state with icon and optional text
class SyncStatusIndicator extends ConsumerWidget {
  final bool showText;
  final bool showPendingCount;
  final double iconSize;

  const SyncStatusIndicator({
    this.showText = true,
    this.showPendingCount = true,
    this.iconSize = 20,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStateAsync = ref.watch(syncStateProvider);
    final isOnline = ref.watch(isOnlineProvider);
    final queueStatsAsync = ref.watch(queueStatsStreamProvider);

    return syncStateAsync.when(
      data: (syncState) {
        final pendingCount = queueStatsAsync.value?.pendingOperations ?? 0;
        return _buildIndicator(
          context,
          syncState,
          isOnline,
          pendingCount,
        );
      },
      loading: () => _buildLoadingIndicator(),
      error: (_, __) => _buildErrorIndicator(),
    );
  }

  Widget _buildIndicator(
    BuildContext context,
    SyncState syncState,
    bool isOnline,
    int pendingCount,
  ) {
    final theme = Theme.of(context);
    IconData icon;
    Color color;
    String text;

    if (syncState.isSyncing) {
      icon = Icons.sync;
      color = theme.colorScheme.primary;
      text = 'Syncing...';
    } else if (!isOnline) {
      icon = Icons.cloud_off;
      color = Colors.orange;
      text = pendingCount > 0 ? '$pendingCount pending' : 'Offline';
    } else if (syncState.failedCount > 0) {
      icon = Icons.error_outline;
      color = Colors.red;
      text = 'Sync failed';
    } else if (pendingCount == 0) {
      icon = Icons.cloud_done;
      color = Colors.green;
      text = 'Synced';
    } else {
      icon = Icons.cloud_queue;
      color = Colors.orange;
      text = '$pendingCount pending';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (syncState.isSyncing)
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          )
        else
          Icon(icon, size: iconSize, color: color),
        if (showText) ...[
          const SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(color: color),
          ),
        ],
        if (showPendingCount && pendingCount > 0 && !showText) ...[
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$pendingCount',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }

  Widget _buildErrorIndicator() {
    return Icon(Icons.error_outline, size: iconSize, color: Colors.red);
  }
}

/// Connectivity status badge
/// Shows network connection status
class ConnectivityBadge extends ConsumerWidget {
  final bool compact;

  const ConnectivityBadge({
    this.compact = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final stateAsync = ref.watch(connectivityStateStreamProvider);

    return stateAsync.when(
      data: (state) {
        final isOnline = state.status.isOnline;
        final networkType = state.networkType;

        IconData icon;
        Color color;
        String label;

        if (isOnline) {
          switch (networkType) {
            case NetworkType.wifi:
              icon = Icons.wifi;
              color = Colors.green;
              label = 'WiFi';
              break;
            case NetworkType.mobile:
              icon = Icons.signal_cellular_alt;
              color = Colors.green;
              label = 'Mobile';
              break;
            case NetworkType.ethernet:
              icon = Icons.settings_ethernet;
              color = Colors.green;
              label = 'Ethernet';
              break;
            default:
              icon = Icons.cloud;
              color = Colors.green;
              label = 'Online';
          }
        } else {
          icon = Icons.cloud_off;
          color = Colors.red;
          label = 'Offline';
        }

        if (compact) {
          return Icon(icon, size: 16, color: color);
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

/// Offline banner
/// Shows at top of screen when offline
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOffline = ref.watch(isOfflineProvider);
    final queueStatsAsync = ref.watch(queueStatsStreamProvider);

    if (!isOffline) {
      return const SizedBox.shrink();
    }

    final pendingCount = queueStatsAsync.value?.pendingOperations ?? 0;

    return MaterialBanner(
      backgroundColor: Colors.orange.shade700,
      leading: const Icon(Icons.cloud_off, color: Colors.white),
      content: Text(
        pendingCount > 0
            ? 'You\'re offline. $pendingCount changes will sync when connection is restored.'
            : 'You\'re offline. Changes will sync when connection is restored.',
        style: const TextStyle(color: Colors.white),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Dismiss banner (could store preference)
          },
          child: const Text('OK', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

/// Pending operations badge
/// Shows count of pending operations
class PendingOperationsBadge extends ConsumerWidget {
  final bool showZero;

  const PendingOperationsBadge({
    this.showZero = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final queueStatsAsync = ref.watch(queueStatsStreamProvider);

    return queueStatsAsync.when(
      data: (stats) {
        final count = stats.pendingOperations;
        if (count == 0 && !showZero) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: count > 0 ? Colors.orange : Colors.green,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                count > 0 ? Icons.schedule : Icons.check_circle,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                count > 0 ? '$count pending' : 'All synced',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

/// Sync button with status
/// Button that triggers manual sync and shows current status
class SyncButton extends ConsumerWidget {
  final VoidCallback? onSyncComplete;

  const SyncButton({
    this.onSyncComplete,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStateAsync = ref.watch(syncStateProvider);
    final isOnline = ref.watch(isOnlineProvider);

    return syncStateAsync.when(
      data: (syncState) {
        final isSyncing = syncState.isSyncing;
        final canSync = isOnline && !isSyncing;

        return ElevatedButton.icon(
          onPressed: canSync
              ? () async {
                  try {
                    await ref.read(syncCoordinatorProvider).triggerSync();
                    
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sync completed'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      onSyncComplete?.call();
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Sync failed: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              : null,
          icon: isSyncing
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(isOnline ? Icons.sync : Icons.sync_disabled),
          label: Text(
            isSyncing
                ? 'Syncing...'
                : isOnline
                    ? 'Sync Now'
                    : 'Offline',
          ),
        );
      },
      loading: () => const ElevatedButton(
        onPressed: null,
        child: Text('Loading...'),
      ),
      error: (_, __) => const ElevatedButton(
        onPressed: null,
        child: Text('Error'),
      ),
    );
  }
}

/// Sync status card
/// Detailed card showing sync and queue status
class SyncStatusCard extends ConsumerWidget {
  const SyncStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final syncStateAsync = ref.watch(syncStateProvider);
    final queueStatsAsync = ref.watch(queueStatsStreamProvider);
    final isOnline = ref.watch(isOnlineProvider);
    final networkType = ref.watch(networkTypeProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isOnline ? Icons.cloud_done : Icons.cloud_off,
                  color: isOnline ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  'Sync Status',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                ConnectivityBadge(),
              ],
            ),
            const Divider(),
            
            // Sync state
            syncStateAsync.when(
              data: (syncState) {
                String stateText;
                Color stateColor;

                if (syncState.isSyncing) {
                  stateText = 'Syncing in progress...';
                  stateColor = theme.colorScheme.primary;
                } else if (syncState.pendingCount == 0 && syncState.failedCount == 0) {
                  stateText = 'All changes synced';
                  stateColor = Colors.green;
                } else if (syncState.failedCount > 0) {
                  stateText = 'Sync failed';
                  stateColor = Colors.red;
                } else {
                  stateText = 'Idle';
                  stateColor = Colors.grey;
                }

                return _StatusRow(
                  label: 'Status',
                  value: stateText,
                  color: stateColor,
                );
              },
              loading: () => const _StatusRow(label: 'Status', value: 'Loading...'),
              error: (_, __) => const _StatusRow(label: 'Status', value: 'Error'),
            ),
            
            const SizedBox(height: 8),
            
            // Network type
            _StatusRow(
              label: 'Connection',
              value: isOnline ? networkType.name.toUpperCase() : 'OFFLINE',
            ),
            
            const SizedBox(height: 8),
            
            // Queue stats
            queueStatsAsync.when(
              data: (stats) {
                return Column(
                  children: [
                    _StatusRow(
                      label: 'Pending Operations',
                      value: '${stats.pendingOperations}',
                      color: stats.pendingOperations > 0 ? Colors.orange : Colors.green,
                    ),
                    if (stats.failedOperations > 0) ...[
                      const SizedBox(height: 8),
                      _StatusRow(
                        label: 'Failed Operations',
                        value: '${stats.failedOperations}',
                        color: Colors.red,
                      ),
                    ],
                  ],
                );
              },
              loading: () => const _StatusRow(label: 'Queue', value: 'Loading...'),
              error: (_, __) => const _StatusRow(label: 'Queue', value: 'Error'),
            ),
            
            const SizedBox(height: 16),
            
            // Sync button
            Center(
              child: SyncButton(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Status row helper widget
class _StatusRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _StatusRow({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// Sync progress overlay
/// Shows sync progress during sync operation
class SyncProgressOverlay extends ConsumerWidget {
  const SyncProgressOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStateAsync = ref.watch(syncStateProvider);

    return syncStateAsync.when(
      data: (syncState) {
        if (!syncState.isSyncing) {
          return const SizedBox.shrink();
        }

        return Container(
          color: Colors.black54,
          child: Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Syncing...',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text('Please wait'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

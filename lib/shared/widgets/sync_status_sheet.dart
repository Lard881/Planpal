import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_providers.dart';
import '../../core/sync/sync_engine.dart' as sync;

/// Bottom sheet showing detailed sync status and queue information
class SyncStatusSheet extends ConsumerWidget {
  const SyncStatusSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStateAsync = ref.watch(syncStateProvider);
    final syncEngine = ref.watch(syncEngineProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.sync,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                'Sync Status',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
          const SizedBox(height: 24),

          // Current sync state
          syncStateAsync.when(
            data: (state) => _buildSyncStateCard(context, state),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _buildErrorCard(context, error.toString()),
          ),
          const SizedBox(height: 16),

          // Queue statistics
          _buildQueueStats(context, syncEngine),
          const SizedBox(height: 16),

          // Failed operations
          _buildFailedOperations(context, syncEngine),
          const SizedBox(height: 16),

          // Actions
          _buildActions(context, ref, syncEngine),
        ],
      ),
    );
  }

  Widget _buildSyncStateCard(BuildContext context, sync.SyncState state) {
    final (icon, color, title, subtitle) = _getStateDetails(state, context);

    return Card(
      color: color.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
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
    );
  }

  Widget _buildQueueStats(BuildContext context, sync.SyncEngine syncEngine) {
    final stats = syncEngine.getWorkspaceStats();
    final total = stats['total'] as int;
    final failed = stats['failed'] as int;
    final ready = stats['ready'] as int;
    final workspaceId = stats['currentWorkspaceId'] as String?;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sync Queue',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildStatRow(context, 'Pending Operations', '$total', Icons.schedule),
            _buildStatRow(context, 'Ready to Sync', '$ready', Icons.cloud_upload),
            _buildStatRow(context, 'Failed Operations', '$failed', Icons.error_outline,
                color: failed > 0 ? Colors.red : null),
            if (workspaceId != null)
              _buildStatRow(context, 'Workspace', workspaceId.substring(0, 8),
                  Icons.workspaces_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFailedOperations(BuildContext context, sync.SyncEngine syncEngine) {
    final failedOps = syncEngine.getFailedOperations();

    if (failedOps.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  'Failed Operations',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${failedOps.length} operation(s) failed after multiple retries',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(
    BuildContext context,
    WidgetRef ref,
    sync.SyncEngine syncEngine,
  ) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              syncEngine.retryFailedOperations();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Retrying failed operations...')),
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry Failed'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              try {
                await syncEngine.sync();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sync completed')),
                  );
                  Navigator.of(context).pop();
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
            },
            icon: const Icon(Icons.sync),
            label: const Text('Sync Now'),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorCard(BuildContext context, String error) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.onErrorContainer,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sync Error',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    error,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
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

  (IconData, Color, String, String) _getStateDetails(
    sync.SyncState state,
    BuildContext context,
  ) {
    switch (state) {
      case sync.SyncState.idle:
        return (
          Icons.cloud_done,
          Colors.green,
          'All Synced',
          'Your data is up to date',
        );
      case sync.SyncState.syncing:
        return (
          Icons.sync,
          Theme.of(context).colorScheme.primary,
          'Syncing...',
          'Synchronizing your data with the server',
        );
      case sync.SyncState.error:
        return (
          Icons.cloud_off,
          Theme.of(context).colorScheme.error,
          'Sync Error',
          'Failed to sync data. Check your connection',
        );
      case sync.SyncState.conflict:
        return (
          Icons.warning_amber,
          Colors.orange,
          'Sync Conflict',
          'Some changes conflict with server data',
        );
    }
  }
}

/// Show sync status bottom sheet
void showSyncStatusSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => const SyncStatusSheet(),
  );
}

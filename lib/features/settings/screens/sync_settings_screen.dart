import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/sync/sync_engine.dart' as sync;
// import '../../../core/sync/background_sync_service.dart'; // Temporarily disabled
import '../../../shared/widgets/sync_status_sheet.dart';
import 'sync_logs_screen.dart';

/// Screen for configuring sync settings and preferences
class SyncSettingsScreen extends ConsumerStatefulWidget {
  const SyncSettingsScreen({super.key});

  @override
  ConsumerState<SyncSettingsScreen> createState() => _SyncSettingsScreenState();
}

class _SyncSettingsScreenState extends ConsumerState<SyncSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final syncEngine = ref.watch(syncEngineProvider);
    final syncStateAsync = ref.watch(syncStateProvider);
    final backgroundSyncEnabled = ref.watch(backgroundSyncEnabledProvider);
    final realtimeEnabled = ref.watch(realtimeEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Current sync status card
          syncStateAsync.when(
            data: (state) => _buildStatusCard(context, state, syncEngine),
            loading: () => const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (error, _) => Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error: $error'),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Sync Options
          Text(
            'Sync Options',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),

          // Background sync toggle
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.cloud_sync),
              title: const Text('Background Sync'),
              subtitle: const Text('Sync data when app is in background'),
              value: backgroundSyncEnabled,
              onChanged: (value) {
                ref.read(backgroundSyncEnabledProvider.notifier).state = value;
                if (value) {
                  // BackgroundSyncService.schedulePeriodicSync(); // Temporarily disabled
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Background sync temporarily unavailable')),
                  );
                } else {
                  // BackgroundSyncService.cancelSync(); // Temporarily disabled
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Background sync disabled')),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 8),

          // Real-time updates toggle
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.bolt),
              title: const Text('Real-time Updates'),
              subtitle: const Text('Instant sync when data changes on server'),
              value: realtimeEnabled,
              onChanged: (value) {
                ref.read(realtimeEnabledProvider.notifier).state = value;
                if (value) {
                  // Realtime handler will auto-subscribe to current workspace
                  final handler = ref.read(realtimeSyncHandlerProvider);
                  final workspaceId = ref.read(currentWorkspaceIdProvider);
                  if (workspaceId != null) {
                    handler.subscribeToWorkspace(workspaceId);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Real-time updates enabled')),
                  );
                } else {
                  ref.read(realtimeSyncHandlerProvider).unsubscribeAll();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Real-time updates disabled')),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 8),

          // Conflict resolution strategy
          Card(
            child: ListTile(
              leading: const Icon(Icons.compare_arrows),
              title: const Text('Conflict Resolution'),
              subtitle: const Text('Last write wins'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showConflictStrategyDialog(context, syncEngine),
            ),
          ),
          const SizedBox(height: 24),

          // Actions
          Text(
            'Actions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),

          // Sync now button
          Card(
            child: ListTile(
              leading: const Icon(Icons.sync),
              title: const Text('Sync Now'),
              subtitle: const Text('Manually trigger sync'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _syncNow(context, syncEngine),
            ),
          ),
          const SizedBox(height: 8),

          // View sync queue
          Card(
            child: ListTile(
              leading: const Icon(Icons.queue),
              title: const Text('View Sync Queue'),
              subtitle: Text('${syncEngine.queue.length} pending operations'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showSyncStatusSheet(context),
            ),
          ),
          const SizedBox(height: 8),

          // View sync logs
          Card(
            child: ListTile(
              leading: const Icon(Icons.article),
              title: const Text('View Sync Logs'),
              subtitle: const Text('View detailed sync operation history'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SyncLogsScreen(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Clear sync queue
          Card(
            child: ListTile(
              leading: Icon(
                Icons.clear_all,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                'Clear Sync Queue',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              subtitle: const Text('Remove all pending operations'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _clearQueue(context, syncEngine),
            ),
          ),
          const SizedBox(height: 24),

          // Info section
          Text(
            'About Sync',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How Sync Works',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• PlanPal syncs your data automatically every 30 seconds\n'
                    '• Real-time updates push changes instantly from server\n'
                    '• Changes are queued when offline and synced when online\n'
                    '• Background sync keeps your data up to date\n'
                    '• Failed operations are retried with exponential backoff',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    BuildContext context,
    sync.SyncState state,
    sync.SyncEngine syncEngine,
  ) {
    final stats = syncEngine.getWorkspaceStats();
    final pendingCount = stats['total'] as int;
    final failedCount = stats['failed'] as int;

    return Card(
      color: _getStateColor(state).withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              _getStateIcon(state),
              size: 48,
              color: _getStateColor(state),
            ),
            const SizedBox(height: 12),
            Text(
              _getStateTitle(state),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              _getStateSubtitle(state),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatChip(context, 'Pending', '$pendingCount', Icons.schedule),
                _buildStatChip(context, 'Failed', '$failedCount', Icons.error_outline,
                    color: failedCount > 0 ? Colors.red : null),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text('$label: $value'),
      labelStyle: TextStyle(
        fontSize: 12,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  IconData _getStateIcon(sync.SyncState state) {
    switch (state) {
      case sync.SyncState.idle:
        return Icons.cloud_done;
      case sync.SyncState.syncing:
        return Icons.sync;
      case sync.SyncState.error:
        return Icons.cloud_off;
      case sync.SyncState.conflict:
        return Icons.warning_amber;
    }
  }

  Color _getStateColor(sync.SyncState state) {
    switch (state) {
      case sync.SyncState.idle:
        return Colors.green;
      case sync.SyncState.syncing:
        return Colors.blue;
      case sync.SyncState.error:
        return Colors.red;
      case sync.SyncState.conflict:
        return Colors.orange;
    }
  }

  String _getStateTitle(sync.SyncState state) {
    switch (state) {
      case sync.SyncState.idle:
        return 'All Synced';
      case sync.SyncState.syncing:
        return 'Syncing...';
      case sync.SyncState.error:
        return 'Sync Error';
      case sync.SyncState.conflict:
        return 'Sync Conflict';
    }
  }

  String _getStateSubtitle(sync.SyncState state) {
    switch (state) {
      case sync.SyncState.idle:
        return 'Your data is up to date';
      case sync.SyncState.syncing:
        return 'Synchronizing with server';
      case sync.SyncState.error:
        return 'Failed to sync. Check connection';
      case sync.SyncState.conflict:
        return 'Manual resolution required';
    }
  }

  Future<void> _syncNow(BuildContext context, sync.SyncEngine syncEngine) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await syncEngine.sync();
      if (!context.mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sync completed successfully')),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sync failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _clearQueue(BuildContext context, sync.SyncEngine syncEngine) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Sync Queue?'),
        content: const Text(
          'This will remove all pending sync operations. '
          'Unsynced changes may be lost. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      syncEngine.clearWorkspaceQueue();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sync queue cleared')),
      );
    }
  }

  Future<void> _showConflictStrategyDialog(
    BuildContext context,
    sync.SyncEngine syncEngine,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Conflict Resolution'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Last Write Wins'),
              subtitle: const Text('Newest change takes precedence'),
              trailing: const Icon(Icons.check),
            ),
            ListTile(
              title: const Text('Server Wins'),
              subtitle: const Text('Server data always wins'),
            ),
            ListTile(
              title: const Text('Client Wins'),
              subtitle: const Text('Local changes always win'),
            ),
            ListTile(
              title: const Text('Manual'),
              subtitle: const Text('Ask me to resolve conflicts'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

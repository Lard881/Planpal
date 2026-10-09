import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/sync/sync_messages.dart';
import '../../../core/widgets/planpal_button.dart';
import '../../../shared/widgets/empty_state.dart';
import '../providers/sync_providers.dart';

/// Screen showing sync status and failed items
/// 
/// Features:
/// - Current sync state
/// - Last successful sync time
/// - Pending items count
/// - Failed items with details
/// - Retry and Discard actions
class SyncStatusScreen extends ConsumerWidget {
  const SyncStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncStateProvider);
    final failedItems = ref.watch(failedSyncItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.syncStatus),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(syncCoordinatorProvider).triggerSync();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Sync status card
            _SyncStatusCard(
              isSyncing: syncState.isSyncing,
              lastSyncTime: syncState.lastSyncTime,
              pendingCount: syncState.pendingCount,
              failedCount: syncState.failedCount,
            ),

            const SizedBox(height: 24),

            // Failed items section
            if (failedItems.isNotEmpty) ...[
              Text(
                context.l10n.failedItems,
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: 12),

              ...failedItems.map((item) => _FailedItemCard(
                    item: item,
                    onRetry: () async {
                      await ref
                          .read(outboxServiceProvider)
                          .retryFailedItems();
                    },
                    onDiscard: () async {
                      final confirmed = await _showDiscardConfirmation(context);
                      if (confirmed == true) {
                        await ref
                            .read(outboxServiceProvider)
                            .discardItem(item.id);
                      }
                    },
                  )),

              const SizedBox(height: 16),

              // Bulk actions
              Row(
                children: [
                  Expanded(
                    child: PlanPalButton(
                      text: 'Retry All',
                      onPressed: () async {
                        await ref
                            .read(outboxServiceProvider)
                            .retryFailedItems();
                      },
                      label: context.l10n.retryAll,
                      variant: AppButtonVariant.outlined,
                      icon: Icons.refresh,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PlanPalButton(
                      text: 'Discard All',
                      type: ButtonType.danger,
                      onPressed: () async {
                        final confirmed =
                            await _showDiscardAllConfirmation(context);
                        if (confirmed == true) {
                          await ref
                              .read(outboxServiceProvider)
                              .discardAllFailedItems();
                        }
                      },
                      label: context.l10n.discardAll,
                      variant: AppButtonVariant.outlined,
                      color: AppColors.error,
                      icon: Icons.delete_sweep,
                    ),
                  ),
                ],
              ),
            ] else if (syncState.pendingCount == 0) ...[
              const EmptyState(
                icon: Icons.cloud_done,
                message: 'All synced!',
                description: 'Your changes are up to date',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<bool?> _showDiscardConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.discardChange),
        content: Text(SyncMessages.discardWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.l10n.discard),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showDiscardAllConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.discardAllChanges),
        content: Text(context.l10n.discardAllWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.l10n.discardAll),
          ),
        ],
      ),
    );
  }
}

/// Sync status summary card
class _SyncStatusCard extends StatelessWidget {
  final bool isSyncing;
  final DateTime? lastSyncTime;
  final int pendingCount;
  final int failedCount;

  const _SyncStatusCard({
    required this.isSyncing,
    required this.lastSyncTime,
    required this.pendingCount,
    required this.failedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSyncing
                      ? Icons.sync
                      : failedCount > 0
                          ? Icons.sync_problem
                          : Icons.cloud_done,
                  color: isSyncing
                      ? AppColors.primary
                      : failedCount > 0
                          ? AppColors.error
                          : AppColors.success,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getStatusText(context),
                        style: AppTextStyles.h3,
                      ),
                      if (lastSyncTime != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${context.l10n.lastSync}: ${_formatTime(lastSyncTime!)}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (pendingCount > 0 || failedCount > 0) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              if (pendingCount > 0)
                _StatusRow(
                  icon: Icons.schedule,
                  label: context.l10n.pendingChanges,
                  count: pendingCount,
                  color: AppColors.warning,
                ),
              if (failedCount > 0) ...[
                if (pendingCount > 0) const SizedBox(height: 12),
                _StatusRow(
                  icon: Icons.error,
                  label: context.l10n.failedChanges,
                  count: failedCount,
                  color: AppColors.error,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  String _getStatusText(BuildContext context) {
    if (isSyncing) return SyncMessages.syncInProgress;
    if (failedCount > 0) return SyncMessages.syncFailed;
    if (pendingCount > 0) return SyncMessages.itemsWaitingToSync;
    return SyncMessages.syncComplete;
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return DateFormat.MMMd().add_jm().format(time);
  }
}

/// Status row showing count and icon
class _StatusRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _StatusRow({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(color: color),
        ),
        const Spacer(),
        Text(
          count.toString(),
          style: AppTextStyles.h4.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// Card showing a failed sync item
class _FailedItemCard extends StatelessWidget {
  final OutboxData item;
  final VoidCallback onRetry;
  final VoidCallback onDiscard;

  const _FailedItemCard({
    required this.item,
    required this.onRetry,
    required this.onDiscard,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getEntityIcon(),
                  size: 20,
                  color: AppColors.error,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getTitle(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              SyncMessages.getErrorMessage(
                item.entityType,
                item.operation,
                item.lastError,
              ),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                TextButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: Text(context.l10n.retry),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: onDiscard,
                  icon: const Icon(Icons.delete, size: 18),
                  label: Text(context.l10n.discard),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getEntityIcon() {
    switch (item.entityType) {
      case 'label':
        return Icons.label;
      case 'task':
        return Icons.task_alt;
      case 'event':
        return Icons.event;
      case 'document':
        return Icons.description;
      default:
        return Icons.sync_problem;
    }
  }

  String _getTitle() {
    return '${item.operation.toUpperCase()} ${item.entityType}';
  }
}

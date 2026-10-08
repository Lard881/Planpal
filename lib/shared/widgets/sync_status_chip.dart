import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Chip that shows sync status
/// 
/// Displays:
/// - "Waiting to sync (n)" when items are pending
/// - Tap to open sync status screen
/// - Hidden when nothing to sync
class SyncStatusChip extends ConsumerWidget {
  final int pendingCount;
  final int failedCount;
  final bool isSyncing;

  const SyncStatusChip({
    super.key,
    required this.pendingCount,
    required this.failedCount,
    required this.isSyncing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Don't show if nothing to sync
    if (pendingCount == 0 && failedCount == 0 && !isSyncing) {
      return const SizedBox.shrink();
    }

    final hasError = failedCount > 0;
    final color = hasError ? AppColors.error : AppColors.warning;
    final totalCount = pendingCount + failedCount;

    return GestureDetector(
      onTap: () => context.push('/sync-status'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSyncing)
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              )
            else
              Icon(
                hasError ? Icons.sync_problem : Icons.sync,
                size: 14,
                color: color,
              ),
            const SizedBox(width: 6),
            Text(
              isSyncing
                  ? 'Syncing...'
                  : hasError
                      ? 'Sync failed ($totalCount)'
                      : 'Waiting to sync ($totalCount)',
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact sync status indicator (for smaller spaces)
class SyncStatusIndicator extends StatelessWidget {
  final bool isSyncing;
  final bool hasError;
  final double size;

  const SyncStatusIndicator({
    super.key,
    required this.isSyncing,
    required this.hasError,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    if (isSyncing) {
      return SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    if (hasError) {
      return Icon(
        Icons.sync_problem,
        size: size,
        color: AppColors.error,
      );
    }

    return Icon(
      Icons.sync_disabled,
      size: size,
      color: AppColors.textSecondary,
    );
  }
}

/// Sync status badge (shows count)
class SyncStatusBadge extends StatelessWidget {
  final int count;
  final Color? color;

  const SyncStatusBadge({
    super.key,
    required this.count,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color ?? AppColors.error,
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(
        minWidth: 18,
        minHeight: 18,
      ),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        style: AppTextStyles.caption.copyWith(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

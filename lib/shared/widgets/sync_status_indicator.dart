import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_providers.dart';
import '../../core/sync/sync_engine.dart' as sync;

/// Compact sync status indicator showing sync state with icon
class SyncStatusIndicator extends ConsumerWidget {
  final bool showLabel;
  final VoidCallback? onTap;

  const SyncStatusIndicator({
    super.key,
    this.showLabel = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStateAsync = ref.watch(syncStateProvider);

    return syncStateAsync.when(
      data: (state) {
        final (icon, color, label) = _getSyncStateInfo(state, context);
        
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
                if (showLabel) ...[
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (_, __) => Icon(
        Icons.sync_problem,
        size: 16,
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }

  (IconData, Color, String) _getSyncStateInfo(
    sync.SyncState state,
    BuildContext context,
  ) {
    switch (state) {
      case sync.SyncState.idle:
        return (
          Icons.cloud_done,
          Colors.green,
          'Synced',
        );
      case sync.SyncState.syncing:
        return (
          Icons.sync,
          Theme.of(context).colorScheme.primary,
          'Syncing...',
        );
      case sync.SyncState.error:
        return (
          Icons.cloud_off,
          Theme.of(context).colorScheme.error,
          'Sync Error',
        );
      case sync.SyncState.conflict:
        return (
          Icons.warning_amber,
          Colors.orange,
          'Conflict',
        );
    }
  }
}

/// Animated sync status indicator with rotation animation
class AnimatedSyncIndicator extends ConsumerStatefulWidget {
  const AnimatedSyncIndicator({super.key});

  @override
  ConsumerState<AnimatedSyncIndicator> createState() =>
      _AnimatedSyncIndicatorState();
}

class _AnimatedSyncIndicatorState extends ConsumerState<AnimatedSyncIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final syncStateAsync = ref.watch(syncStateProvider);

    return syncStateAsync.when(
      data: (state) {
        if (state == sync.SyncState.syncing) {
          _controller.repeat();
        } else {
          _controller.stop();
        }

        return RotationTransition(
          turns: _controller,
          child: Icon(
            Icons.sync,
            size: 20,
            color: state == sync.SyncState.syncing
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
          ),
        );
      },
      loading: () => const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (_, __) => Icon(
        Icons.sync_problem,
        size: 20,
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }
}

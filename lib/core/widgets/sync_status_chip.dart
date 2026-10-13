// app/lib/core/widgets/sync_status_chip.dart
// 24px pill — shown next to page title, never floating.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../sync/sync_engine.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class SyncStatusChip extends ConsumerWidget {
  const SyncStatusChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sync = ref.watch(syncEngineProvider);
    final c = context.colors;

    if (sync.status == SyncStatus.idle && sync.pendingCount == 0) {
      return const SizedBox.shrink();
    }

    final Color bg;
    final Color fg;
    final IconData icon;
    final String label;

    if (sync.status == SyncStatus.failed || sync.failedCount > 0) {
      bg = c.dangerSoft;
      fg = c.danger;
      icon = LucideIcons.alertCircle;
      label = 'Sync failed';
    } else {
      bg = c.warningSoft;
      fg = c.warningText;
      icon = LucideIcons.clock;
      label = 'Waiting to sync ${sync.pendingCount}';
    }

    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(label, style: AppText.chip.copyWith(color: fg)),
        ],
      ),
    );
  }
}

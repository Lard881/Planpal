// app/lib/features/settings/presentation/sync_status_screen.dart
// Derived screen — no image. Built from tokens and shared components.
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:drift/drift.dart' show Value;
import '../../../core/db/app_database.dart';
import '../../../core/sync/sync_engine.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/connectivity/connectivity_service.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/planpal_button.dart';

class SyncStatusScreen extends ConsumerWidget {
  const SyncStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final sync = ref.watch(syncEngineProvider);
    final connectivity = ref.watch(connectivityServiceProvider);
    final db = ref.watch(appDatabaseProvider);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.background,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(AppRadius.control),
              border: Border.all(color: c.border),
            ),
            child: Icon(LucideIcons.arrowLeft, size: 18, color: c.textPrimary),
          ),
        ),
        title: Text('Sync status',
          style: AppText.cardTitle.copyWith(color: c.textPrimary)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Connection card
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Connection',
                  style: AppText.bodyStrong.copyWith(color: c.textPrimary)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 10, height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: connectivity == ConnectivityState.online
                            ? c.success : c.danger,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      connectivity == ConnectivityState.online
                          ? 'Online'
                          : connectivity == ConnectivityState.offline
                              ? 'Offline'
                              : connectivity == ConnectivityState.wakingUp
                                  ? 'Server waking up...'
                                  : 'Server unreachable',
                      style: AppText.body.copyWith(color: c.textPrimary),
                    ),
                  ],
                ),
                if (sync.lastSyncAt != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Last synced: ${_formatTime(sync.lastSyncAt!)}',
                    style: AppText.caption.copyWith(color: c.textMuted),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Pending changes
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Pending changes',
                      style: AppText.bodyStrong.copyWith(color: c.textPrimary)),
                    if (sync.pendingCount > 0)
                      Text('${sync.pendingCount}',
                        style: AppText.bodyMedium.copyWith(color: c.primary)),
                  ],
                ),
                const SizedBox(height: 8),
                if (sync.pendingCount == 0)
                  Text('No pending changes.',
                    style: AppText.body.copyWith(color: c.textMuted))
                else
                  StreamBuilder<List<OutboxEntry>>(
                    stream: db.select(db.outboxEntries).watch().map(
                      (all) => all.where((e) => e.retryCount < 5).toList()),
                    builder: (_, snap) {
                      final items = snap.data ?? [];
                      return Column(
                        children: items.map((e) => _OutboxRow(entry: e)).toList(),
                      );
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Failed changes
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Failed changes',
                      style: AppText.bodyStrong.copyWith(color: c.textPrimary)),
                    if (sync.failedCount > 0)
                      Text('${sync.failedCount}',
                        style: AppText.bodyMedium.copyWith(color: c.danger)),
                  ],
                ),
                const SizedBox(height: 8),
                if (sync.failedCount == 0)
                  Text('No failed changes.',
                    style: AppText.body.copyWith(color: c.textMuted))
                else ...[
                  StreamBuilder<List<OutboxEntry>>(
                    stream: db.select(db.outboxEntries).watch().map(
                      (all) => all.where((e) => e.retryCount >= 5).toList()),
                    builder: (_, snap) {
                      final items = snap.data ?? [];
                      return Column(
                        children: items.map((e) =>
                          _FailedOutboxRow(entry: e)).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  PlanPalButton(
                    label: 'Retry all',
                    variant: PlanPalButtonVariant.outline,
                    width: double.infinity,
                    onPressed: () =>
                        ref.read(syncEngineProvider.notifier).retryFailed(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _OutboxRow extends StatelessWidget {
  final OutboxEntry entry;
  const _OutboxRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Map<String, dynamic> payload = {};
    try { payload = jsonDecode(entry.payload) as Map<String, dynamic>; } catch (_) {}
    final title = payload['title'] as String? ?? entry.entityType;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(LucideIcons.clock, size: 14, color: c.warningText),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${entry.operation.capitalize()}: $title',
              style: AppText.body.copyWith(color: c.textPrimary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _FailedOutboxRow extends ConsumerWidget {
  final OutboxEntry entry;
  const _FailedOutboxRow({required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    Map<String, dynamic> payload = {};
    try { payload = jsonDecode(entry.payload) as Map<String, dynamic>; } catch (_) {}
    final title = payload['title'] as String? ?? entry.entityType;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(LucideIcons.alertCircle, size: 14, color: c.danger),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.operation.capitalize()}: $title',
                  style: AppText.body.copyWith(color: c.textPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Could not be saved. You may no longer have access.',
                  style: AppText.caption.copyWith(color: c.textMuted),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Discard change?'),
                  content: const Text('This change will be permanently removed.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel')),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: FilledButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Discard')),
                  ],
                ),
              );
              if (confirm == true) {
                ref.read(syncEngineProvider.notifier).discardFailed(entry.id);
              }
            },
            child: Text('Discard',
              style: AppText.caption.copyWith(color: c.danger)),
          ),
        ],
      ),
    );
  }
}

extension on String {
  String capitalize() => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}

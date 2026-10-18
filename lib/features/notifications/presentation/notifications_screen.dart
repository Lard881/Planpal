// app/lib/features/notifications/presentation/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/network/failure_localizer.dart';
import '../models/notification_model.dart';
import '../providers/notifications_providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = context.isDesktopLayout;
    return isDesktop
        ? const _DesktopNotifications()
        : const _MobileNotifications();
  }
}

// ── DESKTOP ───────────────────────────────────────────────────────────────────
class _DesktopNotifications extends ConsumerWidget {
  const _DesktopNotifications();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(notificationsProvider);
    final notifier = ref.read(notificationsProvider.notifier);
    ref.listen(notificationsProvider, (previous, next) {
      if (next.error != null &&
          next.error != previous?.error &&
          next.notifications.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizeFailureText(l10n, next.error!))),
        );
      }
    });

    return Scaffold(
      backgroundColor: c.background,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n.notificationsTitle,
                  style: AppText.pageTitle.copyWith(color: c.textPrimary),
                ),
                const Spacer(),
                TextButton(
                  onPressed: notifier.markAllRead,
                  child: Text(
                    l10n.btnMarkAllRead,
                    style: AppText.bodyMedium.copyWith(color: c.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _FilterChips(
              filter: state.filter,
              onChanged: (f) => notifier.load(filter: f),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: state.loading && state.notifications.isEmpty
                  ? const ContentLoadingSkeleton(
                      kind: LoadingSkeletonKind.rows,
                      padding: EdgeInsets.zero,
                    )
                  : state.error != null && state.notifications.isEmpty
                  ? ErrorState(message: state.error!, onRetry: notifier.load)
                  : state.notifications.isEmpty
                  ? EmptyState(
                      icon: LucideIcons.bell,
                      title: l10n.emptyStateNoNotifications,
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: c.surface,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        border: Border.all(color: c.border),
                      ),
                      child: ListView.separated(
                        itemCount: state.notifications.length,
                        separatorBuilder: (_, __) =>
                            Divider(height: 1, color: c.border),
                        itemBuilder: (ctx, i) => _NotificationRow(
                          notification: state.notifications[i],
                          desktop: true,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── MOBILE ────────────────────────────────────────────────────────────────────
class _MobileNotifications extends ConsumerWidget {
  const _MobileNotifications();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(notificationsProvider);
    final notifier = ref.read(notificationsProvider.notifier);
    ref.listen(notificationsProvider, (previous, next) {
      if (next.error != null &&
          next.error != previous?.error &&
          next.notifications.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizeFailureText(l10n, next.error!))),
        );
      }
    });

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => notifier.load(),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Text(
                        l10n.notificationsTitle,
                        style: AppText.pageTitleMobile.copyWith(
                          color: c.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: notifier.markAllRead,
                        child: Text(
                          l10n.btnMarkAllRead,
                          style: AppText.caption.copyWith(color: c.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _FilterChips(
                    filter: state.filter,
                    onChanged: (f) => notifier.load(filter: f),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              if (state.loading && state.notifications.isEmpty)
                const SliverFillRemaining(
                  child: ContentLoadingSkeleton(
                    kind: LoadingSkeletonKind.rows,
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 24),
                  ),
                )
              else if (state.error != null && state.notifications.isEmpty)
                SliverFillRemaining(
                  child: ErrorState(
                    message: state.error!,
                    onRetry: notifier.load,
                  ),
                )
              else if (state.notifications.isEmpty)
                SliverFillRemaining(
                  child: EmptyState(
                    icon: LucideIcons.bell,
                    title: l10n.emptyStateNoNotifications,
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _NotificationRow(
                          notification: state.notifications[i],
                          desktop: false,
                        ),
                      ),
                      childCount: state.notifications.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Filter chips ──────────────────────────────────────────────────────────────
class _FilterChips extends StatelessWidget {
  final String filter;
  final ValueChanged<String> onChanged;
  const _FilterChips({required this.filter, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final options = [
      ('all', l10n.notificationsAll),
      ('unread', l10n.notificationsUnread),
      ('tasks', l10n.notificationsTasks),
      ('mentions', l10n.notificationsMentions),
    ];
    return Row(
      children: options.map(((String val, String label) opt) {
        final selected = filter == opt.$1;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => onChanged(opt.$1),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? c.primary : c.surfaceAlt,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                opt.$2,
                style: AppText.bodyMedium.copyWith(
                  color: selected ? Colors.white : c.textMuted,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Notification row ──────────────────────────────────────────────────────────
class _NotificationRow extends ConsumerWidget {
  final NotificationModel notification;
  final bool desktop;
  const _NotificationRow({required this.notification, required this.desktop});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final n = notification;
    final notifier = ref.read(notificationsProvider.notifier);

    Widget row = Container(
      color: n.isUnread
          ? c.primarySoft.withValues(alpha: 0.3)
          : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon tile
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: n.iconBg(c),
              borderRadius: BorderRadius.circular(AppRadius.control),
            ),
            child: Icon(n.icon, size: 18, color: n.iconFg(c)),
          ),
          const SizedBox(width: 12),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  n.localizedTitle(l10n),
                  style: AppText.bodyMedium.copyWith(
                    color: c.textPrimary,
                    fontWeight: n.isUnread ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                if (n.body.isNotEmpty)
                  Text(
                    n.body,
                    style: AppText.caption.copyWith(color: c.textMuted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                Text(
                  n.relativeTime(l10n),
                  style: AppText.caption.copyWith(color: c.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Unread dot + menu
          Column(
            children: [
              if (n.isUnread)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: c.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => _showMenu(context, ref, notifier),
                child: Icon(
                  LucideIcons.moreHorizontal,
                  size: 16,
                  color: c.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (!desktop) {
      row = Container(
        decoration: BoxDecoration(
          color: n.isUnread ? c.primarySoft.withValues(alpha: 0.15) : c.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: c.border),
        ),
        child: row,
      );
    }

    return GestureDetector(
      onTap: () => _navigate(context, ref, notifier),
      child: row,
    );
  }

  void _navigate(
    BuildContext context,
    WidgetRef ref,
    NotificationsNotifier notifier,
  ) {
    notifier.markRead(notification.id);
    final type = notification.entityType;
    final id = notification.entityId;
    if (type == 'task' && id != null) {
      context.push('/tasks/$id');
    } else if (type == 'channel' && id != null) {
      context.push('/chat/$id');
    } else if (type == 'document' && id != null) {
      context.push('/documents/$id');
    } else if (type == 'event') {
      context.push('/calendar');
    }
  }

  void _showMenu(
    BuildContext context,
    WidgetRef ref,
    NotificationsNotifier notifier,
  ) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                notification.isUnread
                    ? LucideIcons.checkCheck
                    : LucideIcons.circle,
              ),
              title: Text(
                notification.isUnread
                    ? l10n.notificationsMarkRead
                    : l10n.notificationsMarkUnread,
              ),
              onTap: () {
                Navigator.pop(context);
                if (notification.isUnread) {
                  notifier.markRead(notification.id);
                } else {
                  notifier.markUnread(notification.id);
                }
              },
            ),
            ListTile(
              leading: Icon(LucideIcons.trash2, color: c.danger),
              title: Text(l10n.btnDelete, style: TextStyle(color: c.danger)),
              onTap: () {
                Navigator.pop(context);
                notifier.delete(notification.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

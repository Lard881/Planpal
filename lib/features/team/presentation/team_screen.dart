// app/lib/features/team/presentation/team_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/widgets/chips.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/planpal_button.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/providers/presence_provider.dart';
import '../../workspaces/providers/workspace_providers.dart';
import '../../workspaces/data/workspace_repository.dart';
import '../../workspaces/models/workspace_model.dart';

class TeamScreen extends ConsumerStatefulWidget {
  final String? workspaceId;
  final bool showInvites;
  const TeamScreen({super.key, this.workspaceId, this.showInvites = false});

  @override
  ConsumerState<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends ConsumerState<TeamScreen> {
  String _filter = 'all'; // all|admin|member|guest

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final isDesktop = context.isDesktopLayout;
    final wsId = widget.workspaceId ?? ref.watch(currentWorkspaceIdProvider) ?? '';
    final workspace = ref.watch(currentWorkspaceProvider);
    final perms = ref.watch(currentRolePermissionsProvider);

    // Personal workspace — hide team
    if (workspace?.isPersonal == true) {
      return Scaffold(
        backgroundColor: c.background,
        body: EmptyState(
          icon: LucideIcons.users,
          title: l10n.emptyStateTeamOnly,
          subtitle: l10n.emptyStateTeamOnlyDesc,
        ),
      );
    }

    final membersAsync = ref.watch(
        FutureProvider.family<List<MemberModel>, String>((ref, id) async {
      final (list, _) = await ref.read(workspaceRepositoryProvider).getMembers(id);
      return list;
    })(wsId));

    // Role label map
    final roleLabels = <String, String>{
      'all': l10n.all,
      'admin': l10n.roleAdmin,
      'member': l10n.roleMember,
      'guest': l10n.roleGuest,
    };

    return Scaffold(
      backgroundColor: c.background,
      body: Padding(
        padding: EdgeInsets.all(isDesktop ? 32 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(l10n.teamDirectoryTitle,
                  style: (isDesktop ? AppText.pageTitle : AppText.pageTitleMobile)
                      .copyWith(color: c.textPrimary)),
                const Spacer(),
                if (perms.isAdmin)
                  PlanPalButton(
                    label: l10n.btnInviteWithCode,
                    toolbar: true,
                    icon: LucideIcons.key,
                    onPressed: () =>
                        context.push('/workspace/$wsId/invites'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['all', 'admin', 'member', 'guest'].map((f) {
                  final selected = _filter == f;
                  final label = roleLabels[f] ?? f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _filter = f),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected ? c.primary : c.surfaceAlt,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(label,
                          style: AppText.bodyMedium.copyWith(
                            color: selected ? Colors.white : c.textMuted)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: membersAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => ErrorState(message: e.toString()),
                data: (members) {
                  final filtered = _filter == 'all'
                      ? members
                      : members.where((m) => m.role == _filter).toList();

                  if (filtered.isEmpty) {
                    return EmptyState(
                      icon: LucideIcons.users,
                      title: l10n.emptyStateNoMembers);
                  }

                  return isDesktop
                      ? _DesktopGrid(members: filtered, wsId: wsId)
                      : _MobileList(members: filtered, wsId: wsId);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopGrid extends ConsumerWidget {
  final List<MemberModel> members;
  final String wsId;
  const _DesktopGrid({required this.members, required this.wsId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final presenceMap = ref.watch(presenceProvider(wsId));

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, crossAxisSpacing: 16,
        mainAxisSpacing: 16, childAspectRatio: 1.1,
      ),
      itemCount: members.length,
      itemBuilder: (_, i) {
        final m = members[i];
        final presence = presenceMap[m.userId] ?? PresenceStatus.offline;
        final presenceLabel = switch (presence) {
          PresenceStatus.online => l10n.teamPresenceOnline,
          PresenceStatus.away => l10n.teamPresenceAway,
          PresenceStatus.offline => l10n.teamPresenceOffline,
        };
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: c.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Avatar(
                userId: m.userId,
                name: m.fullName,
                avatarUrl: m.avatarUrl,
                size: 56,
                presence: presence,
              ),
              const SizedBox(height: 12),
              Text(
                m.fullName.isNotEmpty ? m.fullName : m.email,
                style: AppText.bodyStrong.copyWith(color: c.textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              RoleBadge(role: m.role),
              const SizedBox(height: 4),
              Text(presenceLabel,
                style: AppText.caption.copyWith(color: c.presenceOffline)),
            ],
          ),
        );
      },
    );
  }
}

class _MobileList extends ConsumerWidget {
  final List<MemberModel> members;
  final String wsId;
  const _MobileList({required this.members, required this.wsId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final presenceMap = ref.watch(presenceProvider(wsId));
    return ListView.separated(
      itemCount: members.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final m = members[i];
        final presence = presenceMap[m.userId] ?? PresenceStatus.offline;
        final presenceLabel = switch (presence) {
          PresenceStatus.online => l10n.teamPresenceOnline,
          PresenceStatus.away => l10n.teamPresenceAway,
          PresenceStatus.offline => l10n.teamPresenceOffline,
        };
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: c.border),
          ),
          child: Row(
            children: [
              Avatar(
                userId: m.userId,
                name: m.fullName,
                avatarUrl: m.avatarUrl,
                size: 44,
                presence: presence,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m.fullName.isNotEmpty ? m.fullName : m.email,
                      style: AppText.bodyStrong.copyWith(color: c.textPrimary),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                    Text(presenceLabel,
                      style: AppText.caption.copyWith(color: c.presenceOffline)),
                  ],
                ),
              ),
              RoleBadge(role: m.role),
            ],
          ),
        );
      },
    );
  }
}

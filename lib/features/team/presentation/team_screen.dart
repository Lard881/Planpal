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
    final isDesktop = context.isDesktopLayout;
    final wsId = widget.workspaceId ?? ref.watch(currentWorkspaceIdProvider) ?? '';
    final workspace = ref.watch(currentWorkspaceProvider);
    final perms = ref.watch(currentRolePermissionsProvider);

    // Personal workspace — hide team
    if (workspace?.isPersonal == true) {
      return Scaffold(
        backgroundColor: c.background,
        body: const EmptyState(
          icon: LucideIcons.users,
          title: 'Team is for team workspaces',
          subtitle: 'Create or join a team workspace to see members.',
        ),
      );
    }

    final membersAsync = ref.watch(
        FutureProvider.family<List<MemberModel>, String>((ref, id) async {
      final (list, _) = await ref.read(workspaceRepositoryProvider).getMembers(id);
      return list;
    })(wsId));

    return Scaffold(
      backgroundColor: c.background,
      body: Padding(
        padding: EdgeInsets.all(isDesktop ? 32 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Team Directory',
                  style: (isDesktop ? AppText.pageTitle : AppText.pageTitleMobile)
                      .copyWith(color: c.textPrimary)),
                const Spacer(),
                if (perms.isAdmin)
                  PlanPalButton(
                    label: 'Invite with code',
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
                  final label = f[0].toUpperCase() + f.substring(1);
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
                    return const EmptyState(
                      icon: LucideIcons.users,
                      title: 'No members found');
                  }

                  return isDesktop
                      ? _DesktopGrid(members: filtered)
                      : _MobileList(members: filtered);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopGrid extends StatelessWidget {
  final List<MemberModel> members;
  const _DesktopGrid({required this.members});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, crossAxisSpacing: 16,
        mainAxisSpacing: 16, childAspectRatio: 1.1,
      ),
      itemCount: members.length,
      itemBuilder: (_, i) {
        final m = members[i];
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
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Avatar(
                    userId: m.userId,
                    name: m.fullName,
                    avatarUrl: m.avatarUrl,
                    size: 56,
                    presence: PresenceStatus.offline,
                  ),
                ],
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
              Text('Offline',
                style: AppText.caption.copyWith(color: c.presenceOffline)),
            ],
          ),
        );
      },
    );
  }
}

class _MobileList extends StatelessWidget {
  final List<MemberModel> members;
  const _MobileList({required this.members});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ListView.separated(
      itemCount: members.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final m = members[i];
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
                presence: PresenceStatus.offline,
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
                    Text('Offline',
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

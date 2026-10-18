// app/lib/features/team/presentation/team_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/widgets/chips.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/planpal_button.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/network/failure_localizer.dart';
import '../../../core/providers/presence_provider.dart';
import '../../workspaces/providers/workspace_providers.dart';
import '../../workspaces/data/workspace_repository.dart';
import '../../workspaces/models/workspace_model.dart';
import '../../chat/data/chat_repository.dart';
import '../../chat/providers/chat_providers.dart';
import '../../tasks/data/task_repository.dart';
import '../../documents/data/documents_repository.dart';

final teamMembersProvider = FutureProvider.autoDispose
    .family<List<MemberModel>, String>((ref, workspaceId) async {
      final (members, failure) = await ref
          .read(workspaceRepositoryProvider)
          .getMembers(workspaceId);
      if (failure != null) throw failure;
      return members;
    });

class TeamActivity {
  final String type;
  final String title;
  final String id;
  final DateTime updatedAt;

  const TeamActivity({
    required this.type,
    required this.title,
    required this.id,
    required this.updatedAt,
  });
}

final teamLatestActivityProvider = FutureProvider.autoDispose
    .family<List<TeamActivity>, String>((ref, workspaceId) async {
      final (tasks, _, taskFailure, _) = await ref
          .read(taskRepositoryProvider)
          .getTasks(workspaceId, sort: 'updated_at');
      if (taskFailure != null) throw taskFailure;
      final (documents, documentFailure) = await ref
          .read(documentsRepositoryProvider)
          .getDocuments(workspaceId, recent: true);
      if (documentFailure != null) throw documentFailure;
      final (members, memberFailure) = await ref
          .read(workspaceRepositoryProvider)
          .getMembers(workspaceId);
      if (memberFailure != null) throw memberFailure;

      final updates = <TeamActivity>[
        ...tasks.map(
          (task) => TeamActivity(
            type: 'task',
            title: task.title,
            id: task.id,
            updatedAt: task.updatedAt,
          ),
        ),
        ...documents.map(
          (document) => TeamActivity(
            type: document.kind == 'file' ? 'file' : 'document',
            title: document.title,
            id: document.id,
            updatedAt: document.updatedAt,
          ),
        ),
        ...members
            .where((member) => member.joinedAt != null)
            .map(
              (member) => TeamActivity(
                type: 'member',
                title: member.fullName.isNotEmpty
                    ? member.fullName
                    : member.email,
                id: member.userId,
                updatedAt: member.joinedAt!,
              ),
            ),
      ]..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return updates.take(8).toList();
    });

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
    final wsId =
        widget.workspaceId ?? ref.watch(currentWorkspaceIdProvider) ?? '';
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

    final membersAsync = ref.watch(teamMembersProvider(wsId));

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
                Text(
                  l10n.teamDirectoryTitle,
                  style:
                      (isDesktop ? AppText.pageTitle : AppText.pageTitleMobile)
                          .copyWith(color: c.textPrimary),
                ),
                const Spacer(),
                if (perms.isAdmin)
                  PlanPalButton(
                    label: l10n.btnInviteWithCode,
                    toolbar: true,
                    icon: LucideIcons.key,
                    onPressed: () => context.push('/workspace/$wsId/invites'),
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
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? c.primary : c.surfaceAlt,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          label,
                          style: AppText.bodyMedium.copyWith(
                            color: selected ? Colors.white : c.textMuted,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: membersAsync.when(
                loading: () => const ContentLoadingSkeleton(
                  kind: LoadingSkeletonKind.cards,
                  padding: EdgeInsets.zero,
                ),
                error: (e, _) => ErrorState(
                  message: e.toString(),
                  retryLabel: l10n.btnRetry,
                  onRetry: () => ref.invalidate(teamMembersProvider(wsId)),
                ),
                data: (members) {
                  final filtered = _filter == 'all'
                      ? members
                      : members.where((m) => m.role == _filter).toList();

                  if (filtered.isEmpty) {
                    return EmptyState(
                      icon: LucideIcons.users,
                      title: l10n.emptyStateNoMembers,
                    );
                  }

                  return isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: _DesktopGrid(
                                members: filtered,
                                wsId: wsId,
                                onMemberTap: (member) => _showMemberProfile(
                                  context,
                                  ref,
                                  wsId,
                                  member,
                                  canManage: perms.isAdmin,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            SizedBox(
                              width: 280,
                              child: _LatestActivity(workspaceId: wsId),
                            ),
                          ],
                        )
                      : _MobileList(
                          members: filtered,
                          wsId: wsId,
                          onMemberTap: (member) => _showMemberProfile(
                            context,
                            ref,
                            wsId,
                            member,
                            canManage: perms.isAdmin,
                          ),
                        );
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
  final ValueChanged<MemberModel> onMemberTap;
  const _DesktopGrid({
    required this.members,
    required this.wsId,
    required this.onMemberTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final presenceMap = ref.watch(presenceProvider(wsId));

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
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
        return InkWell(
          borderRadius: BorderRadius.circular(AppRadius.card),
          onTap: () => onMemberTap(m),
          child: Container(
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
                Text(
                  presenceLabel,
                  style: AppText.caption.copyWith(color: c.presenceOffline),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MobileList extends ConsumerWidget {
  final List<MemberModel> members;
  final String wsId;
  final ValueChanged<MemberModel> onMemberTap;
  const _MobileList({
    required this.members,
    required this.wsId,
    required this.onMemberTap,
  });

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
        return InkWell(
          borderRadius: BorderRadius.circular(AppRadius.card),
          onTap: () => onMemberTap(m),
          child: Container(
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
                        style: AppText.bodyStrong.copyWith(
                          color: c.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        presenceLabel,
                        style: AppText.caption.copyWith(
                          color: c.presenceOffline,
                        ),
                      ),
                    ],
                  ),
                ),
                RoleBadge(role: m.role),
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<void> _showMemberProfile(
  BuildContext context,
  WidgetRef ref,
  String workspaceId,
  MemberModel member, {
  required bool canManage,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  builder: (_) => _MemberProfileSheet(
    workspaceId: workspaceId,
    member: member,
    canManage: canManage,
  ),
);

class _MemberProfileSheet extends ConsumerStatefulWidget {
  final String workspaceId;
  final MemberModel member;
  final bool canManage;
  const _MemberProfileSheet({
    required this.workspaceId,
    required this.member,
    required this.canManage,
  });

  @override
  ConsumerState<_MemberProfileSheet> createState() =>
      _MemberProfileSheetState();
}

class _MemberProfileSheetState extends ConsumerState<_MemberProfileSheet> {
  bool _busy = false;

  bool get _isSelf =>
      widget.member.userId == Supabase.instance.client.auth.currentUser?.id;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final displayName = widget.member.fullName.isEmpty
        ? widget.member.email
        : widget.member.fullName;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.teamMemberProfile,
              style: AppText.caption.copyWith(color: colors.textMuted),
            ),
            const SizedBox(height: 8),
            Avatar(
              userId: widget.member.userId,
              name: displayName,
              avatarUrl: widget.member.avatarUrl,
              size: 72,
            ),
            const SizedBox(height: 12),
            Text(
              displayName,
              style: AppText.sectionTitle.copyWith(color: colors.textPrimary),
            ),
            Text(
              widget.member.email,
              style: AppText.body.copyWith(color: colors.textMuted),
            ),
            const SizedBox(height: 8),
            RoleBadge(role: widget.member.role),
            const SizedBox(height: 16),
            if (!_isSelf)
              PlanPalButton(
                label: l10n.teamMessageMember,
                icon: LucideIcons.messageCircle,
                onPressed: _busy ? null : _messageMember,
              ),
            if (widget.canManage && !_isSelf) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: widget.member.role,
                decoration: InputDecoration(labelText: l10n.teamChangeRole),
                items: [
                  DropdownMenuItem(value: 'admin', child: Text(l10n.roleAdmin)),
                  DropdownMenuItem(
                    value: 'member',
                    child: Text(l10n.roleMember),
                  ),
                  DropdownMenuItem(value: 'guest', child: Text(l10n.roleGuest)),
                ],
                onChanged: _busy ? null : _updateRole,
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _busy ? null : _removeMember,
                icon: const Icon(LucideIcons.userMinus),
                label: Text(l10n.teamRemoveMember),
                style: TextButton.styleFrom(foregroundColor: colors.danger),
              ),
            ],
            if (_busy) const LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Future<void> _messageMember() async {
    setState(() => _busy = true);
    final (channel, failure) = await ref
        .read(chatRepositoryProvider)
        .createDm(widget.workspaceId, widget.member.userId);
    if (!mounted) return;
    setState(() => _busy = false);
    if (failure != null || channel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            failure?.localizedMessage(context) ??
                AppLocalizations.of(context).errorGeneric,
          ),
        ),
      );
      return;
    }
    ref.invalidate(channelsProvider(widget.workspaceId));
    Navigator.pop(context);
    context.go('/chat/${channel.id}');
  }

  Future<void> _updateRole(String? role) async {
    if (role == null || role == widget.member.role) return;
    setState(() => _busy = true);
    final failure = await ref
        .read(workspaceRepositoryProvider)
        .updateMemberRole(widget.workspaceId, widget.member.userId, role);
    if (!mounted) return;
    setState(() => _busy = false);
    if (failure != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failure.localizedMessage(context))),
      );
      return;
    }
    ref.invalidate(teamMembersProvider(widget.workspaceId));
    Navigator.pop(context);
  }

  Future<void> _removeMember() async {
    final l10n = AppLocalizations.of(context);
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.teamRemoveMember),
        content: Text(l10n.teamConfirmRemoveMember),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.btnCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.teamRemoveMember),
          ),
        ],
      ),
    );
    if (shouldRemove != true || !mounted) return;
    setState(() => _busy = true);
    final failure = await ref
        .read(workspaceRepositoryProvider)
        .removeMember(widget.workspaceId, widget.member.userId);
    if (!mounted) return;
    setState(() => _busy = false);
    if (failure != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failure.localizedMessage(context))),
      );
      return;
    }
    ref.invalidate(teamMembersProvider(widget.workspaceId));
    Navigator.pop(context);
  }
}

class _LatestActivity extends ConsumerWidget {
  final String workspaceId;
  const _LatestActivity({required this.workspaceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final updatesAsync = ref.watch(teamLatestActivityProvider(workspaceId));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.teamLatestUpdates,
            style: AppText.sectionTitle.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: updatesAsync.when(
              loading: () => const ContentLoadingSkeleton(
                kind: LoadingSkeletonKind.rows,
                itemCount: 4,
                padding: EdgeInsets.zero,
              ),
              error: (error, _) => ErrorState(
                message: error.toString(),
                retryLabel: l10n.btnRetry,
                onRetry: () =>
                    ref.invalidate(teamLatestActivityProvider(workspaceId)),
              ),
              data: (updates) => updates.isEmpty
                  ? Center(
                      child: Text(
                        l10n.teamNoActivity,
                        style: AppText.body.copyWith(color: colors.textMuted),
                      ),
                    )
                  : ListView.separated(
                      itemCount: updates.length,
                      separatorBuilder: (_, __) => const Divider(height: 16),
                      itemBuilder: (context, index) {
                        final update = updates[index];
                        final updatedAt =
                            '${MaterialLocalizations.of(context).formatMediumDate(update.updatedAt)} · '
                            '${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(update.updatedAt))}';
                        final activityLabel = switch (update.type) {
                          'task' => l10n.teamUpdateTask,
                          'file' => l10n.teamUpdateFile,
                          'member' => l10n.teamUpdateMemberJoined,
                          _ => l10n.teamUpdateDocument,
                        };
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(
                            update.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text('$activityLabel · $updatedAt'),
                          onTap: () {
                            if (update.type == 'task') {
                              context.push('/tasks/${update.id}');
                            } else if (update.type == 'file' ||
                                update.type == 'document') {
                              context.push('/documents/${update.id}');
                            }
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/planpal_button.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../../../shared/widgets/empty_state.dart';
import '../models/workspace_member.dart';
import '../providers/workspace_providers.dart';

/// Screen for managing workspace members
/// 
/// Features:
/// - List all workspace members
/// - Show member roles (admin/member)
/// - Change member roles (admin only)
/// - Remove members (admin only)
/// - Leave workspace option
/// - Permission guards based on current user role
class WorkspaceMembersScreen extends ConsumerStatefulWidget {
  final String workspaceId;

  const WorkspaceMembersScreen({
    super.key,
    required this.workspaceId,
  });

  @override
  ConsumerState<WorkspaceMembersScreen> createState() => _WorkspaceMembersScreenState();
}

class _WorkspaceMembersScreenState extends ConsumerState<WorkspaceMembersScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch members on load
    Future.microtask(() {
      ref.read(workspaceMembersProvider(widget.workspaceId).notifier).fetchMembers();
    });
  }

  Future<void> _changeMemberRole({
    required WorkspaceMember member,
    required String newRole,
  }) async {
    try {
      await ref.read(workspaceRepositoryProvider).changeMemberRole(
            workspaceId: widget.workspaceId,
            memberId: member.id,
            role: newRole,
          );

      // Refresh members list
      ref.invalidate(workspaceMembersProvider(widget.workspaceId));

      if (!mounted) return;
      AppSnackbar.showSuccess(
        context,
        context.l10n.memberRoleChanged,
      );
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(
        context,
        context.l10n.memberRoleChangeError,
      );
    }
  }

  Future<void> _removeMember(WorkspaceMember member) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.memberRemoveConfirmTitle),
        content: Text(
          context.l10n.memberRemoveConfirmMessage(member.name ?? member.email),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.l10n.remove),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(workspaceRepositoryProvider).removeMember(
            workspaceId: widget.workspaceId,
            memberId: member.id,
          );

      // Refresh members list
      ref.invalidate(workspaceMembersProvider(widget.workspaceId));

      if (!mounted) return;
      AppSnackbar.showSuccess(
        context,
        context.l10n.memberRemoved,
      );
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(
        context,
        context.l10n.memberRemoveError,
      );
    }
  }

  Future<void> _leaveWorkspace() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.workspaceLeaveConfirmTitle),
        content: Text(context.l10n.workspaceLeaveConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.l10n.leave),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(workspaceRepositoryProvider).leaveWorkspace(widget.workspaceId);

      // Refresh workspace list and current workspace
      ref.invalidate(workspaceListProvider);
      ref.invalidate(currentWorkspaceProvider);

      if (!mounted) return;
      
      AppSnackbar.showSuccess(
        context,
        context.l10n.workspaceLeft,
      );
      
      // Navigate back to home
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;
      
      // Check if it's the "last admin" error
      if (e.toString().toLowerCase().contains('last admin')) {
        AppSnackbar.showError(
          context,
          context.l10n.errorLastAdmin,
        );
      } else {
        AppSnackbar.showError(
          context,
          context.l10n.workspaceLeaveError,
        );
      }
    }
  }

  void _showRoleChangeMenu(BuildContext context, WorkspaceMember member) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: Text(context.l10n.roleAdmin),
              subtitle: Text(context.l10n.roleAdminDescription),
              trailing: member.role == 'admin' ? const Icon(Icons.check) : null,
              onTap: () {
                Navigator.pop(context);
                if (member.role != 'admin') {
                  _changeMemberRole(member: member, newRole: 'admin');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(context.l10n.roleMember),
              subtitle: Text(context.l10n.roleMemberDescription),
              trailing: member.role == 'member' ? const Icon(Icons.check) : null,
              onTap: () {
                Navigator.pop(context);
                if (member.role != 'member') {
                  _changeMemberRole(member: member, newRole: 'member');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(workspaceMembersProvider(widget.workspaceId));
    final currentUserAsync = ref.watch(currentUserProvider);
    final workspaceAsync = ref.watch(currentWorkspaceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.workspaceMembers),
        centerTitle: true,
      ),
      body: membersAsync.when(
        data: (members) {
          if (members.isEmpty) {
            return EmptyState(
              icon: Icons.people_outline,
              message: context.l10n.noMembersYet,
            );
          }

          // Determine if current user is admin
          final currentUserId = currentUserAsync.value?.id;
          final currentMember = members.firstWhere(
            (m) => m.userId == currentUserId,
            orElse: () => members.first,
          );
          final isAdmin = currentMember.role == 'admin';
          final isPersonalWorkspace = workspaceAsync.value?.type == 'personal';

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: members.length + (isPersonalWorkspace ? 0 : 1), // +1 for leave button
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              // Leave workspace button at the end
              if (!isPersonalWorkspace && index == members.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: AppButton(
                    onPressed: _leaveWorkspace,
                    label: context.l10n.workspaceLeave,
                    variant: AppButtonVariant.outlined,
                    icon: Icons.exit_to_app,
                    color: AppColors.error,
                  ),
                );
              }

              final member = members[index];
              final isCurrentUser = member.userId == currentUserId;

              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      (member.name ?? member.email).substring(0, 1).toUpperCase(),
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    member.name ?? member.email,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (member.name != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          member.email,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            member.role == 'admin'
                                ? Icons.admin_panel_settings
                                : Icons.person,
                            size: 14,
                            color: member.role == 'admin'
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            member.role == 'admin'
                                ? context.l10n.roleAdmin
                                : context.l10n.roleMember,
                            style: AppTextStyles.caption.copyWith(
                              color: member.role == 'admin'
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              fontWeight: member.role == 'admin'
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          if (isCurrentUser) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                context.l10n.you,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  trailing: !isPersonalWorkspace && isAdmin && !isCurrentUser
                      ? PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'role',
                              child: Row(
                                children: [
                                  const Icon(Icons.swap_horiz),
                                  const SizedBox(width: 12),
                                  Text(context.l10n.changeRole),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'remove',
                              child: Row(
                                children: [
                                  const Icon(Icons.person_remove, color: AppColors.error),
                                  const SizedBox(width: 12),
                                  Text(
                                    context.l10n.removeMember,
                                    style: const TextStyle(color: AppColors.error),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'role') {
                              _showRoleChangeMenu(context, member);
                            } else if (value == 'remove') {
                              _removeMember(member);
                            }
                          },
                        )
                      : null,
                ),
              );
            },
          );
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                context.l10n.errorLoadingMembers,
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 16),
              AppButton(
                onPressed: () {
                  ref.invalidate(workspaceMembersProvider(widget.workspaceId));
                },
                label: context.l10n.retry,
                variant: AppButtonVariant.outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

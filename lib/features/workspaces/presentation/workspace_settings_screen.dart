// app/lib/features/workspaces/presentation/workspace_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/planpal_button.dart';
import '../../../core/widgets/empty_state.dart';
import '../data/workspace_repository.dart';
import '../models/workspace_model.dart';
import '../providers/workspace_providers.dart';

class WorkspaceSettingsScreen extends ConsumerStatefulWidget {
  final String workspaceId;
  final bool showInvites;
  const WorkspaceSettingsScreen({
    super.key,
    required this.workspaceId,
    this.showInvites = false,
  });

  @override
  ConsumerState<WorkspaceSettingsScreen> createState() =>
      _WorkspaceSettingsScreenState();
}

class _WorkspaceSettingsScreenState
    extends ConsumerState<WorkspaceSettingsScreen> {
  late bool _showInvites;

  @override
  void initState() {
    super.initState();
    _showInvites = widget.showInvites;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final workspace = ref.watch(currentWorkspaceProvider);
    final wsName = workspace?.name ?? 'Workspace';

    return Scaffold(
      backgroundColor: c.background,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Workspace Settings',
                        style: AppText.pageTitle.copyWith(color: c.textPrimary)),
                      const SizedBox(height: 4),
                      Text('$wsName · Manage people and access',
                        style: AppText.body.copyWith(color: c.textMuted)),
                    ],
                  ),
                ),
                PlanPalButton(
                  label: '+ New code',
                  toolbar: true,
                  onPressed: () => _showCreateCodeDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Tab pills
            Row(
              children: [
                _TabPill(
                  label: 'Members',
                  selected: !_showInvites,
                  onTap: () => setState(() => _showInvites = false),
                ),
                const SizedBox(width: 8),
                _TabPill(
                  label: 'Invite codes',
                  selected: _showInvites,
                  onTap: () => setState(() => _showInvites = true),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _showInvites
                  ? _InviteCodesTab(workspaceId: widget.workspaceId)
                  : _MembersTab(workspaceId: widget.workspaceId),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateCodeDialog(BuildContext context) {
    final c = context.colors;
    String role = 'member';
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.panel)),
          title: Text('New invite code',
            style: AppText.cardTitle.copyWith(color: c.textPrimary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Role', style: AppText.label.copyWith(color: c.textPrimary)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: role,
                decoration: InputDecoration(
                  filled: true, fillColor: c.surfaceAlt,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.control),
                    borderSide: BorderSide.none),
                ),
                items: ['admin', 'member', 'guest'].map((r) =>
                  DropdownMenuItem(value: r, child: Text(r.capitalize()))).toList(),
                onChanged: (v) => setDlgState(() => role = v ?? 'member'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel',
                style: AppText.bodyMedium.copyWith(color: c.textMuted))),
            FilledButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                final (code, err) = await ref.read(workspaceRepositoryProvider)
                    .createInviteCode(widget.workspaceId, role);
                if (err != null && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(err.message)));
                }
                if (mounted) ref.invalidate(_inviteCodesProvider(widget.workspaceId));
              },
              child: const Text('Create code')),
          ],
        ),
      ),
    );
  }
}

// ── Members Tab ───────────────────────────────────────────────────────────────
class _MembersTab extends ConsumerWidget {
  final String workspaceId;
  const _MembersTab({required this.workspaceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final membersAsync = ref.watch(_membersProvider(workspaceId));

    return membersAsync.when(
      data: (members) => Container(
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: c.border),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: members.length,
          separatorBuilder: (_, __) => Divider(height: 1, color: c.border),
          itemBuilder: (ctx, i) => _MemberRow(
            member: members[i],
            workspaceId: workspaceId,
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorState(message: e.toString()),
    );
  }
}

class _MemberRow extends ConsumerWidget {
  final MemberModel member;
  final String workspaceId;
  const _MemberRow({required this.member, required this.workspaceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Avatar(
            userId: member.userId,
            name: member.fullName,
            avatarUrl: member.avatarUrl,
            size: 36,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(member.fullName.isNotEmpty ? member.fullName : member.email,
              style: AppText.bodyMedium.copyWith(color: c.textPrimary)),
          ),
          // Role dropdown
          _RoleDropdown(
            current: member.role,
            onChanged: (newRole) async {
              final err = await ref.read(workspaceRepositoryProvider)
                  .updateMemberRole(workspaceId, member.userId, newRole);
              if (err != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(err.message)));
              } else {
                ref.invalidate(_membersProvider(workspaceId));
              }
            },
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () async {
              final confirm = await _confirmRemove(context, member.fullName);
              if (!confirm) return;
              final err = await ref.read(workspaceRepositoryProvider)
                  .removeMember(workspaceId, member.userId);
              if (err != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(err.message)));
              } else {
                ref.invalidate(_membersProvider(workspaceId));
              }
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: c.danger,
              side: BorderSide(color: c.danger),
              minimumSize: const Size(0, 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.control)),
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmRemove(BuildContext context, String name) async {
    return await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove member?'),
        content: Text('Remove $name from this workspace?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: context.colors.danger),
            child: const Text('Remove')),
        ],
      ),
    ) ?? false;
  }
}

class _RoleDropdown extends StatelessWidget {
  final String current;
  final ValueChanged<String> onChanged;
  const _RoleDropdown({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: c.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.control),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: current,
          icon: Icon(LucideIcons.chevronDown, size: 14, color: c.textMuted),
          style: AppText.bodyMedium.copyWith(color: c.textPrimary),
          items: ['admin', 'member', 'guest'].map((r) =>
            DropdownMenuItem(value: r, child: Text(r.capitalize()))).toList(),
          onChanged: (v) { if (v != null) onChanged(v); },
        ),
      ),
    );
  }
}

// ── Invite Codes Tab ──────────────────────────────────────────────────────────
class _InviteCodesTab extends ConsumerWidget {
  final String workspaceId;
  const _InviteCodesTab({required this.workspaceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final codesAsync = ref.watch(_inviteCodesProvider(workspaceId));

    return codesAsync.when(
      data: (codes) => codes.isEmpty
          ? const EmptyState(
              icon: Icons.key_off_outlined,
              title: 'No invite codes',
              subtitle: 'Create one to invite teammates.')
          : Container(
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: c.border),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: codes.length,
                separatorBuilder: (_, __) => Divider(height: 1, color: c.border),
                itemBuilder: (_, i) => _InviteCodeRow(
                  code: codes[i],
                  workspaceId: workspaceId,
                ),
              ),
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorState(message: e.toString()),
    );
  }
}

class _InviteCodeRow extends ConsumerWidget {
  final InviteCodeModel code;
  final String workspaceId;
  const _InviteCodeRow({required this.code, required this.workspaceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;

    String statusLabel;
    Color statusBg;
    Color statusFg;
    if (code.isRevoked) {
      statusLabel = 'Revoked'; statusBg = c.surfaceAlt; statusFg = c.textMuted;
    } else if (code.isExpired) {
      statusLabel = 'Expired'; statusBg = c.surfaceAlt; statusFg = c.textMuted;
    } else {
      statusLabel = 'Active'; statusBg = c.successSoft; statusFg = c.success;
    }

    String expiryText;
    if (code.expiresAt == null) {
      expiryText = 'Never expires';
    } else if (code.isExpired) {
      expiryText = 'Expired ${_formatDate(code.expiresAt!)}';
    } else {
      expiryText = 'Expires ${_formatDate(code.expiresAt!)}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Code pill — monospace bold letter-spaced
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: c.surfaceAlt,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(code.code,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 14, fontWeight: FontWeight.w700,
                letterSpacing: 2, color: c.textPrimary),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${code.role.capitalize()} · ${code.useCount} uses',
                  style: AppText.bodyMedium.copyWith(color: c.textPrimary)),
                Text(expiryText,
                  style: AppText.caption.copyWith(color: c.textMuted)),
              ],
            ),
          ),
          // Status chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(statusLabel,
              style: AppText.chip.copyWith(color: statusFg)),
          ),
          const SizedBox(width: 8),
          // Copy button
          OutlinedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code.code));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Code copied')));
            },
            icon: Icon(LucideIcons.copy, size: 14),
            label: const Text('Copy'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.control)),
            ),
          ),
          // Revoke button (hide for already revoked)
          if (!code.isRevoked) ...[
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () async {
                final err = await ref.read(workspaceRepositoryProvider)
                    .revokeInviteCode(workspaceId, code.id);
                if (err != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(err.message)));
                } else {
                  ref.invalidate(_inviteCodesProvider(workspaceId));
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: c.danger,
                side: BorderSide(color: c.danger),
                minimumSize: const Size(0, 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.control)),
              ),
              child: const Text('Revoke'),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day}/${dt.month}/${dt.year}';
}

// ── Tab Pill ──────────────────────────────────────────────────────────────────
class _TabPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabPill({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? c.primary : c.surfaceAlt,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
          style: AppText.bodyMedium.copyWith(
            color: selected ? Colors.white : c.textMuted)),
      ),
    );
  }
}

// ── Providers ─────────────────────────────────────────────────────────────────
final _membersProvider =
    FutureProvider.family<List<MemberModel>, String>((ref, workspaceId) async {
  final (list, err) = await ref.read(workspaceRepositoryProvider).getMembers(workspaceId);
  if (err != null) throw err;
  return list;
});

final _inviteCodesProvider =
    FutureProvider.family<List<InviteCodeModel>, String>((ref, workspaceId) async {
  final (list, err) = await ref.read(workspaceRepositoryProvider).getInviteCodes(workspaceId);
  if (err != null) throw err;
  return list;
});

extension on String {
  String capitalize() => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/empty_state.dart';
import '../models/invite_code.dart';
import '../providers/workspace_providers.dart';

/// Screen for managing workspace invite codes
/// 
/// Features:
/// - Display all invite codes with status
/// - Create new invite codes (admin only)
/// - Revoke invite codes (admin only)
/// - Copy codes to clipboard
/// - Show usage stats and expiry info
class InviteCodesScreen extends ConsumerStatefulWidget {
  final String workspaceId;

  const InviteCodesScreen({
    super.key,
    required this.workspaceId,
  });

  @override
  ConsumerState<InviteCodesScreen> createState() => _InviteCodesScreenState();
}

class _InviteCodesScreenState extends ConsumerState<InviteCodesScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch invite codes on load
    Future.microtask(() {
      ref.invalidate(inviteCodesProvider(widget.workspaceId));
    });
  }

  Future<void> _createInviteCode() async {
    // Show dialog to configure new invite code
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const _CreateInviteCodeDialog(),
    );

    if (result == null) return;

    try {
      await ref.read(workspaceRepositoryProvider).createInviteCode(
            workspaceId: widget.workspaceId,
            maxUses: result['maxUses'] as int?,
            expiresInDays: result['expiresInDays'] as int?,
          );

      // Refresh invite codes
      ref.invalidate(inviteCodesProvider(widget.workspaceId));

      if (!mounted) return;
      AppSnackbar.showSuccess(
        context,
        context.l10n.inviteCodeCreated,
      );
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(
        context,
        context.l10n.inviteCodeCreateError,
      );
    }
  }

  Future<void> _revokeInviteCode(InviteCode code) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.inviteCodeRevokeConfirmTitle),
        content: Text(context.l10n.inviteCodeRevokeConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.l10n.revoke),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(workspaceRepositoryProvider).revokeInviteCode(
            workspaceId: widget.workspaceId,
            codeId: code.id,
          );

      // Refresh invite codes
      ref.invalidate(inviteCodesProvider(widget.workspaceId));

      if (!mounted) return;
      AppSnackbar.showSuccess(
        context,
        context.l10n.inviteCodeRevoked,
      );
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(
        context,
        context.l10n.inviteCodeRevokeError,
      );
    }
  }

  void _copyToClipboard(String code) {
    Clipboard.setData(ClipboardData(text: code));
    AppSnackbar.showSuccess(
      context,
      context.l10n.inviteCodeCopied,
    );
  }

  @override
  Widget build(BuildContext context) {
    final inviteCodesAsync = ref.watch(inviteCodesProvider(widget.workspaceId));
    final isAdminAsync = ref.watch(isCurrentWorkspaceAdminProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.inviteCodes),
        centerTitle: true,
      ),
      body: inviteCodesAsync.when(
        data: (codes) {
          final isAdmin = isAdminAsync.value ?? false;

          if (codes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EmptyState(
                    icon: Icons.key_off,
                    message: context.l10n.noInviteCodesYet,
                  ),
                  if (isAdmin) ...[
                    const SizedBox(height: 24),
                    AppButton(
                      onPressed: _createInviteCode,
                      label: context.l10n.createInviteCode,
                      icon: Icons.add,
                    ),
                  ],
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: codes.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final code = codes[index];
                    final isExpired = code.expiresAt != null &&
                        code.expiresAt!.isBefore(DateTime.now());
                    final isMaxedOut = code.maxUses != null &&
                        code.usesCount >= code.maxUses!;
                    final isActive = !code.isRevoked && !isExpired && !isMaxedOut;

                    return _InviteCodeCard(
                      code: code,
                      isActive: isActive,
                      isAdmin: isAdmin,
                      onCopy: () => _copyToClipboard(code.code),
                      onRevoke: isAdmin && isActive ? () => _revokeInviteCode(code) : null,
                    );
                  },
                ),
              ),
              if (isAdmin) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: AppButton(
                      onPressed: _createInviteCode,
                      label: context.l10n.createInviteCode,
                      icon: Icons.add,
                      width: double.infinity,
                    ),
                  ),
                ),
              ],
            ],
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
                context.l10n.errorLoadingInviteCodes,
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 16),
              AppButton(
                onPressed: () {
                  ref.invalidate(inviteCodesProvider(widget.workspaceId));
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

/// Card widget for displaying an invite code
class _InviteCodeCard extends StatelessWidget {
  final InviteCode code;
  final bool isActive;
  final bool isAdmin;
  final VoidCallback onCopy;
  final VoidCallback? onRevoke;

  const _InviteCodeCard({
    required this.code,
    required this.isActive,
    required this.isAdmin,
    required this.onCopy,
    this.onRevoke,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Code and status row
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primary.withOpacity(0.1)
                              : AppColors.textSecondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          code.code,
                          style: AppTextStyles.h3.copyWith(
                            color: isActive ? AppColors.primary : AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 20),
                        onPressed: onCopy,
                        tooltip: context.l10n.copyCode,
                      ),
                    ],
                  ),
                ),
                _StatusChip(
                  label: _getStatusLabel(context),
                  color: _getStatusColor(),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Stats row
            Row(
              children: [
                _StatItem(
                  icon: Icons.people,
                  label: context.l10n.uses,
                  value: code.maxUses != null
                      ? '${code.usesCount}/${code.maxUses}'
                      : '${code.usesCount}',
                ),
                const SizedBox(width: 16),
                if (code.expiresAt != null)
                  _StatItem(
                    icon: Icons.calendar_today,
                    label: context.l10n.expires,
                    value: dateFormat.format(code.expiresAt!),
                  ),
              ],
            ),

            // Actions (admin only)
            if (isAdmin && onRevoke != null) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: onRevoke,
                icon: const Icon(Icons.block, size: 18),
                label: Text(context.l10n.revokeCode),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getStatusLabel(BuildContext context) {
    if (code.isRevoked) return context.l10n.statusRevoked;
    if (code.expiresAt != null && code.expiresAt!.isBefore(DateTime.now())) {
      return context.l10n.statusExpired;
    }
    if (code.maxUses != null && code.usesCount >= code.maxUses!) {
      return context.l10n.statusMaxedOut;
    }
    return context.l10n.statusActive;
  }

  Color _getStatusColor() {
    if (isActive) return AppColors.success;
    return AppColors.error;
  }
}

/// Status chip widget
class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Stat item widget
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Dialog for creating a new invite code
class _CreateInviteCodeDialog extends StatefulWidget {
  const _CreateInviteCodeDialog();

  @override
  State<_CreateInviteCodeDialog> createState() => _CreateInviteCodeDialogState();
}

class _CreateInviteCodeDialogState extends State<_CreateInviteCodeDialog> {
  int? _maxUses;
  int? _expiresInDays;
  
  final List<int?> _maxUsesOptions = [null, 1, 5, 10, 25, 50, 100];
  final List<int?> _expiryOptions = [null, 1, 7, 30, 90];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.createInviteCode),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.inviteCodeMaxUses,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _maxUsesOptions.map((uses) {
              final isSelected = _maxUses == uses;
              return ChoiceChip(
                label: Text(uses == null ? context.l10n.unlimited : '$uses'),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => _maxUses = uses);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.inviteCodeExpiry,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _expiryOptions.map((days) {
              final isSelected = _expiresInDays == days;
              return ChoiceChip(
                label: Text(
                  days == null
                      ? context.l10n.never
                      : context.l10n.daysCount(days),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => _expiresInDays = days);
                },
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop({
              'maxUses': _maxUses,
              'expiresInDays': _expiresInDays,
            });
          },
          child: Text(context.l10n.create),
        ),
      ],
    );
  }
}

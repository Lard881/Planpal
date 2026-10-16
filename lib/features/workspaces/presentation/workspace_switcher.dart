// app/lib/features/workspaces/presentation/workspace_switcher.dart
// Desktop popover + mobile bottom sheet
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/network/app_failure.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/chips.dart';
import '../../../core/widgets/planpal_button.dart';
import '../../../core/widgets/empty_state.dart';
import '../models/workspace_model.dart';
import '../providers/workspace_providers.dart';

// Called from the desktop sidebar switcher card
void showWorkspaceSwitcherPopover(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (_) => _WorkspaceSwitcherPopover(ref: ref),
  );
}

// Called from the mobile home header
void showWorkspaceSwitcherSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _WorkspaceSwitcherSheet(),
  );
}

// ── Desktop Popover ───────────────────────────────────────────────────────────
class _WorkspaceSwitcherPopover extends ConsumerWidget {
  final WidgetRef ref;
  const _WorkspaceSwitcherPopover({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final workspacesAsync = ref.watch(workspacesProvider);
    final currentId = ref.watch(currentWorkspaceIdProvider);

    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 256, top: 12),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 320,
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(AppRadius.tile),
              border: Border.all(color: c.border),
              boxShadow: AppShadows.floating(Brightness.light),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Switch workspace',
                      style: AppText.caption.copyWith(color: c.textMuted)),
                  ),
                ),
                workspacesAsync.when(
                  data: (list) => Column(
                    children: list.map((w) =>
                      _WorkspaceRow(
                        workspace: w,
                        isCurrentRow: w.id == currentId,
                        onTap: () {
                          ref.read(currentWorkspaceIdProvider.notifier).set(w.id);
                          Navigator.of(context).pop();
                        },
                      ),
                    ).toList(),
                  ),
                  loading: () => const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, _) => ErrorState(
                    message: error is AppFailure
                        ? error.message
                        : AppLocalizations.of(context).errorGeneric,
                    requestId: error is AppFailure ? error.requestId : null,
                    retryLabel: AppLocalizations.of(context).btnRetry,
                    onRetry: () => ref.invalidate(workspacesProvider),
                  ),
                ),
                Divider(height: 1, color: c.border),
                _ActionRow(
                  icon: LucideIcons.plus,
                  label: 'Create workspace',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/workspace/create');
                  },
                ),
                _ActionRow(
                  icon: LucideIcons.key,
                  label: 'Join with code',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/workspace/join');
                  },
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Mobile Bottom Sheet ───────────────────────────────────────────────────────
class _WorkspaceSwitcherSheet extends ConsumerWidget {
  const _WorkspaceSwitcherSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final workspacesAsync = ref.watch(workspacesProvider);
    final currentId = ref.watch(currentWorkspaceIdProvider);

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.panel)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: c.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text('Switch workspace',
              style: AppText.sectionTitle.copyWith(color: c.textPrimary)),
            const SizedBox(height: 16),
            workspacesAsync.when(
              data: (list) => Column(
                children: list.map((w) =>
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _WorkspaceRowCard(
                      workspace: w,
                      isCurrent: w.id == currentId,
                      onTap: () {
                        ref.read(currentWorkspaceIdProvider.notifier).set(w.id);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ).toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => ErrorState(
                message: error is AppFailure
                    ? error.message
                    : AppLocalizations.of(context).errorGeneric,
                requestId: error is AppFailure ? error.requestId : null,
                retryLabel: AppLocalizations.of(context).btnRetry,
                onRetry: () => ref.invalidate(workspacesProvider),
              ),
            ),
            const SizedBox(height: 8),
            PlanPalButton(
              label: '+ Create workspace',
              width: double.infinity,
              onPressed: () {
                Navigator.of(context).pop();
                context.push('/workspace/create');
              },
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 44,
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.push('/workspace/join');
                },
                icon: Icon(LucideIcons.key, size: 16, color: c.textPrimary),
                label: Text('Join with code',
                  style: AppText.bodyMedium.copyWith(color: c.textPrimary)),
                style: OutlinedButton.styleFrom(
                  backgroundColor: c.surfaceAlt,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.control)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared Row Widgets ────────────────────────────────────────────────────────
class _WorkspaceRow extends StatelessWidget {
  final WorkspaceModel workspace;
  final bool isCurrentRow;
  final VoidCallback onTap;
  const _WorkspaceRow({required this.workspace, required this.isCurrentRow, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: isCurrentRow ? c.primarySoft : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.control),
        ),
        child: Row(
          children: [
            _WorkspaceAvatar(workspace: workspace),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(workspace.name,
                    style: AppText.bodyStrong.copyWith(color: c.textPrimary),
                    overflow: TextOverflow.ellipsis),
                  Text(_subtitle(workspace),
                    style: AppText.caption.copyWith(color: c.textMuted)),
                ],
              ),
            ),
            if (workspace.role != null)
              RoleBadge(role: workspace.role!),
          ],
        ),
      ),
    );
  }
}

class _WorkspaceRowCard extends StatelessWidget {
  final WorkspaceModel workspace;
  final bool isCurrent;
  final VoidCallback onTap;
  const _WorkspaceRowCard({required this.workspace, required this.isCurrent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppRadius.tile),
          border: Border.all(color: isCurrent ? c.primary : c.border),
        ),
        child: Row(
          children: [
            _WorkspaceAvatar(workspace: workspace),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(workspace.name,
                    style: AppText.bodyStrong.copyWith(color: c.textPrimary)),
                  Text(_subtitle(workspace),
                    style: AppText.caption.copyWith(color: c.textMuted)),
                ],
              ),
            ),
            if (workspace.role != null)
              RoleBadge(role: workspace.role!),
          ],
        ),
      ),
    );
  }
}

class _WorkspaceAvatar extends StatelessWidget {
  final WorkspaceModel workspace;
  const _WorkspaceAvatar({required this.workspace});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final colors = [c.primary, c.violet, c.sky, c.success];
    final color = colors[workspace.name.hashCode.abs() % colors.length];
    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(workspace.initial,
          style: const TextStyle(color: Colors.white,
              fontSize: 16, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionRow({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 18, color: c.primary),
            const SizedBox(width: 10),
            Text(label, style: AppText.bodyMedium.copyWith(color: c.textPrimary)),
          ],
        ),
      ),
    );
  }
}

String _subtitle(WorkspaceModel w) {
  if (w.isPersonal) return 'Personal';
  if (w.memberCount != null) return 'Team · ${w.memberCount} members';
  return 'Team';
}

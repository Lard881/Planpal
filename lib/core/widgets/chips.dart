// app/lib/core/widgets/chips.dart
// PriorityChip, StatusChip, RoleBadge, FileTypeBadge — colors from token tables.
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../l10n/app_localizations.dart';

class _Chip extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;

  const _Chip({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: AppText.chip.copyWith(color: fg)),
    );
  }
}

class PriorityChip extends StatelessWidget {
  final String priority; // 'high' | 'medium' | 'low'
  const PriorityChip({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final (label, color) = switch (priority.toLowerCase()) {
      'high' => (l10n.priorityHigh, c.danger),
      'medium' => (l10n.priorityMedium, c.warningText),
      'low' => (l10n.priorityLow, c.success),
      _ => (priority, c.textMuted),
    };
    return Text(label, style: AppText.bodyMedium.copyWith(color: color));
  }
}

class StatusChip extends StatelessWidget {
  final String status; // 'todo' | 'in_progress' | 'completed' | 'overdue'
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    final (label, color) = switch (status.toLowerCase()) {
      'todo' => (l10n.statusTodo, c.textMuted),
      'in_progress' => (l10n.statusInProgress, c.primary),
      'completed' => (l10n.statusCompleted, c.success),
      'overdue' => (l10n.statusOverdue, c.danger),
      _ => (status, c.textMuted),
    };
    return Text(label, style: AppText.bodyMedium.copyWith(color: color));
  }
}

class RoleBadge extends StatelessWidget {
  final String role; // 'admin' | 'member' | 'guest'
  const RoleBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    return switch (role.toLowerCase()) {
      'admin' => _Chip(label: l10n.roleAdmin, bg: c.primarySoft, fg: c.primary),
      'member' => _Chip(label: l10n.roleMember, bg: c.violetSoft, fg: c.violet),
      'guest' => _Chip(
        label: l10n.roleGuest,
        bg: c.surfaceAlt,
        fg: c.textMuted,
      ),
      _ => _Chip(label: role, bg: c.surfaceAlt, fg: c.textMuted),
    };
  }
}

class FileTypeBadge extends StatelessWidget {
  final String extension; // 'pdf' | 'doc' | 'xls' | etc
  const FileTypeBadge({super.key, required this.extension});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final ext = extension.toLowerCase().replaceAll('.', '');
    Color bg;
    String label;
    if (ext == 'pdf') {
      bg = c.danger;
      label = 'PDF';
    } else if (ext == 'doc' || ext == 'docx') {
      bg = c.sky;
      label = 'DOC';
    } else if (ext == 'xls' || ext == 'xlsx') {
      bg = c.success;
      label = 'XLS';
    } else {
      bg = c.textMuted;
      label = ext.toUpperCase();
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppText.chip.copyWith(color: Colors.white, fontSize: 10),
      ),
    );
  }
}

class LabelChip extends StatelessWidget {
  final String name;
  final Color color;
  const LabelChip({super.key, required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          name,
          style: AppText.chip.copyWith(color: context.colors.textPrimary),
        ),
      ],
    );
  }
}

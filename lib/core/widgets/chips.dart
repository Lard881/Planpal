// app/lib/core/widgets/chips.dart
// PriorityChip, StatusChip, RoleBadge, FileTypeBadge — colors from token tables.
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

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
    return switch (priority.toLowerCase()) {
      'high' => _Chip(
          label: 'High', bg: c.dangerSoft, fg: c.danger),
      'medium' => _Chip(
          label: 'Medium', bg: c.warningSoft, fg: c.warningText),
      'low' => _Chip(
          label: 'Low', bg: c.successSoft, fg: c.success),
      _ => _Chip(label: priority, bg: c.surfaceAlt, fg: c.textMuted),
    };
  }
}

class StatusChip extends StatelessWidget {
  final String status; // 'todo' | 'in_progress' | 'completed' | 'overdue'
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return switch (status.toLowerCase()) {
      'todo' => _Chip(label: 'Todo', bg: c.surfaceAlt, fg: c.textMuted),
      'in_progress' => _Chip(
          label: 'In Progress', bg: c.primarySoft, fg: c.primary),
      'completed' => _Chip(
          label: 'Completed', bg: c.successSoft, fg: c.success),
      'overdue' => _Chip(
          label: 'Overdue', bg: c.dangerSoft, fg: c.danger),
      _ => _Chip(label: status, bg: c.surfaceAlt, fg: c.textMuted),
    };
  }
}

class RoleBadge extends StatelessWidget {
  final String role; // 'admin' | 'member' | 'guest'
  const RoleBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return switch (role.toLowerCase()) {
      'admin' => _Chip(label: 'Admin', bg: c.primarySoft, fg: c.primary),
      'member' => _Chip(label: 'Member', bg: c.violetSoft, fg: c.violet),
      'guest' => _Chip(label: 'Guest', bg: c.surfaceAlt, fg: c.textMuted),
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
      bg = const Color(0xFFEF4444); label = 'PDF';
    } else if (ext == 'doc' || ext == 'docx') {
      bg = const Color(0xFF0EA5E9); label = 'DOC';
    } else if (ext == 'xls' || ext == 'xlsx') {
      bg = const Color(0xFF16A34A); label = 'XLS';
    } else {
      bg = const Color(0xFF6B7185); label = ext.toUpperCase();
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label,
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
          width: 8, height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(name,
          style: AppText.chip.copyWith(
            color: context.colors.textPrimary),
        ),
      ],
    );
  }
}

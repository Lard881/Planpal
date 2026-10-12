import 'package:flutter/material.dart';
import '../models/label.dart';

/// Label chip widget
class LabelChip extends StatelessWidget {
  final Label label;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const LabelChip({
    super.key,
    required this.label,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label.name),
      backgroundColor: label.colorValue.withValues(alpha: 0.1),
      labelStyle: TextStyle(color: label.colorValue),
      deleteIcon: onDelete != null ? const Icon(Icons.close, size: 16) : null,
      onDeleted: onDelete,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}

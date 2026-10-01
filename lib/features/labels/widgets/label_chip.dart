import 'package:flutter/material.dart';
import '../models/label.dart';

/// A chip widget that displays a label with its color
class LabelChip extends StatelessWidget {
  final Label label;
  final VoidCallback? onDeleted;
  final VoidCallback? onTap;
  final bool selected;
  final EdgeInsetsGeometry? padding;
  final double? size;

  const LabelChip({
    Key? key,
    required this.label,
    this.onDeleted,
    this.onTap,
    this.selected = false,
    this.padding,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chipSize = size ?? 32.0;
    
    if (onTap != null || selected) {
      return FilterChip(
        label: Text(
          label.name,
          style: TextStyle(
            color: label.textColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        selected: selected,
        onSelected: onTap != null ? (_) => onTap!() : null,
        backgroundColor: label.colorValue,
        selectedColor: label.colorValue,
        checkmarkColor: label.textColor,
        deleteIcon: onDeleted != null
            ? Icon(
                Icons.close,
                size: 16,
                color: label.textColor,
              )
            : null,
        onDeleted: onDeleted,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      );
    }

    return Chip(
      label: Text(
        label.name,
        style: TextStyle(
          color: label.textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: label.colorValue,
      deleteIcon: onDeleted != null
          ? Icon(
              Icons.close,
              size: 16,
              color: label.textColor,
            )
          : null,
      onDeleted: onDeleted,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}

/// A compact label badge (smaller than chip)
class LabelBadge extends StatelessWidget {
  final Label label;
  final VoidCallback? onTap;
  final double size;

  const LabelBadge({
    Key? key,
    required this.label,
    this.onTap,
    this.size = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        height: size,
        padding: EdgeInsets.symmetric(horizontal: size * 0.5, vertical: size * 0.15),
        decoration: BoxDecoration(
          color: label.colorValue,
          borderRadius: BorderRadius.circular(size / 2),
        ),
        child: Center(
          child: Text(
            label.name,
            style: TextStyle(
              color: label.textColor,
              fontSize: size * 0.5,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

/// A dot indicator showing label color
class LabelDot extends StatelessWidget {
  final Label label;
  final double size;
  final VoidCallback? onTap;

  const LabelDot({
    Key? key,
    required this.label,
    this.size = 12.0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: Tooltip(
        message: label.name,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: label.colorValue,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

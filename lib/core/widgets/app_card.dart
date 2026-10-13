// app/lib/core/widgets/app_card.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../theme/app_theme.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double radius;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.radius = AppRadius.card,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: c.surface,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: c.border),
          ),
          child: child,
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppText.sectionTitle.copyWith(color: c.textPrimary)),
        if (actionLabel != null && onAction != null)
          TextButton(
            onPressed: onAction,
            child: Text(actionLabel!,
              style: AppText.bodyMedium.copyWith(color: c.primary),
            ),
          ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final String? subLabel;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    this.subLabel,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppText.statNumber.copyWith(color: c.textPrimary)),
          const SizedBox(height: 4),
          Text(label, style: AppText.body.copyWith(color: c.textMuted)),
          if (subLabel != null)
            Text(subLabel!,
              style: AppText.caption.copyWith(color: c.textMuted)),
        ],
      ),
    );
  }
}

/// Quick action tile (Home screen: New Task, Calendar, Analytics, Documents)
class QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconBg;
  final Color iconFg;
  final VoidCallback? onTap;

  const QuickActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.iconBg,
    required this.iconFg,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: iconFg),
            ),
            const SizedBox(height: 12),
            Text(label,
              style: AppText.bodyStrong.copyWith(color: c.textPrimary)),
          ],
        ),
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  final double value; // 0.0 to 1.0
  const ProgressBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: 6,
        backgroundColor: c.surfaceAlt,
        valueColor: AlwaysStoppedAnimation(c.primary),
      ),
    );
  }
}

class CheckCircle extends StatelessWidget {
  final bool checked;
  final VoidCallback? onTap;
  const CheckCircle({super.key, required this.checked, this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22, height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: checked ? c.primary : Colors.transparent,
          border: checked
              ? null
              : Border.all(color: c.presenceOffline, width: 1.5),
        ),
        child: checked
            ? const Icon(Icons.check, size: 14, color: Colors.white)
            : null,
      ),
    );
  }
}

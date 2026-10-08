import 'package:flutter/material.dart';

/// Section header with title and optional "View All" action
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;
  final String? viewAllText;

  const SectionHeader({
    super.key,
    required this.title,
    this.onViewAll,
    this.viewAllText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: Text(viewAllText ?? 'View All →'),
          ),
      ],
    );
  }
}

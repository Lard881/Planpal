import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Activity timeline widget (stub for now)
class ActivityTimeline extends StatelessWidget {
  final String taskId;

  const ActivityTimeline({
    super.key,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implement activity timeline with real data
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timeline, size: 48, color: AppColors.grey300),
            SizedBox(height: 16),
            Text(
              'Activity timeline',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.grey500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Coming soon',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.grey400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

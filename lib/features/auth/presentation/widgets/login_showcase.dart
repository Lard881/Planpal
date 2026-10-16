// Desktop login right panel — static decorative widget (fix F18)
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text.dart';
import '../../../../core/theme/app_theme.dart';

class LoginShowcase extends StatelessWidget {
  const LoginShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEEEFFF), Color(0xFFEDE9FE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Decorative card
            Container(
              width: 384,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.panel),
                boxShadow: AppShadows.floating(Brightness.light),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [c.primary, c.violet],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'MA',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Maya's Tuesday",
                            style: AppText.bodyStrong.copyWith(
                              color: c.textPrimary,
                            ),
                          ),
                          Text(
                            '4 of 6 done — nice pace',
                            style: AppText.caption.copyWith(color: c.textMuted),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _TaskRow(
                    'Design review deck',
                    'High',
                    const Color(0xFFEF4444),
                  ),
                  _TaskRow(
                    'Ship onboarding flow',
                    'In Progress',
                    const Color(0xFF4F46E5),
                  ),
                  _TaskRow('Water the plants', 'Low', const Color(0xFF16A34A)),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Calm days, done tasks.',
              style: AppText.sectionTitle.copyWith(
                color: c.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 320,
              child: Text(
                'PlanPal keeps tasks, calendar and chat in one friendly place.',
                style: AppText.body.copyWith(color: c.textMuted),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  final String title;
  final String badge;
  final Color badgeColor;
  const _TaskRow(this.title, this.badge, this.badgeColor);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: badgeColor, width: 1.5),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppText.body.copyWith(color: c.textPrimary),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(badge, style: AppText.chip.copyWith(color: badgeColor)),
          ),
        ],
      ),
    );
  }
}

// Shared PlanPal logo mark used on all auth screens
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: c.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Text('P',
              style: TextStyle(color: Colors.white, fontSize: 20,
                  fontWeight: FontWeight.w700, fontFamily: 'Inter'),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text('PlanPal', style: AppText.brand.copyWith(color: c.textPrimary)),
      ],
    );
  }
}

// SEED FILE for app/lib/core/theme/app_text.dart
// Headings use Inter, body text uses Noto Sans (measured from the design).
// Bundle both fonts as assets (weights 400, 500, 600, 700) and declare them in pubspec.yaml
// under the family names 'Inter' and 'NotoSans'.
// Colors are NOT set here; the theme applies textPrimary, and muted text uses context.colors.textMuted.
import 'package:flutter/material.dart';

const List<String> _fallback = [
  'Noto Sans SC',
  'Noto Sans KR',
  'Microsoft YaHei',
  'Malgun Gothic',
  'PingFang SC',
  'sans-serif',
];

class AppText {
  AppText._();

  static const pageTitle = TextStyle(
    fontFamily: 'Inter', fontSize: 28, fontWeight: FontWeight.w700,
    height: 1.2, letterSpacing: -0.3, fontFamilyFallback: _fallback,
  );
  static const pageTitleMobile = TextStyle(
    fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w700,
    height: 1.2, letterSpacing: -0.2, fontFamilyFallback: _fallback,
  );
  static const authTitle = TextStyle(
    fontFamily: 'Inter', fontSize: 32, fontWeight: FontWeight.w700,
    height: 1.2, letterSpacing: -0.4, fontFamilyFallback: _fallback,
  );
  static const sectionTitle = TextStyle(
    fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w600,
    height: 1.3, fontFamilyFallback: _fallback,
  );
  static const cardTitle = TextStyle(
    fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600,
    height: 1.3, fontFamilyFallback: _fallback,
  );
  static const statNumber = TextStyle(
    fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w700,
    height: 1.2, fontFamilyFallback: _fallback,
  );
  static const statNumberLarge = TextStyle(
    fontFamily: 'Inter', fontSize: 28, fontWeight: FontWeight.w700,
    height: 1.2, fontFamilyFallback: _fallback,
  );
  static const brand = TextStyle(
    fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w700,
    height: 1.2, fontFamilyFallback: _fallback,
  );

  static const body = TextStyle(
    fontFamily: 'NotoSans', fontSize: 14, fontWeight: FontWeight.w400,
    height: 1.5, fontFamilyFallback: _fallback,
  );
  static const bodyMedium = TextStyle(
    fontFamily: 'NotoSans', fontSize: 14, fontWeight: FontWeight.w500,
    height: 1.5, fontFamilyFallback: _fallback,
  );
  static const bodyStrong = TextStyle(
    fontFamily: 'NotoSans', fontSize: 14, fontWeight: FontWeight.w600,
    height: 1.5, fontFamilyFallback: _fallback,
  );
  static const label = TextStyle(
    fontFamily: 'NotoSans', fontSize: 14, fontWeight: FontWeight.w500,
    height: 1.4, fontFamilyFallback: _fallback,
  );
  static const caption = TextStyle(
    fontFamily: 'NotoSans', fontSize: 12, fontWeight: FontWeight.w400,
    height: 1.4, fontFamilyFallback: _fallback,
  );
  static const chip = TextStyle(
    fontFamily: 'NotoSans', fontSize: 12, fontWeight: FontWeight.w500,
    height: 1.2, fontFamilyFallback: _fallback,
  );
}

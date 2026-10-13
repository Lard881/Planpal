// app/lib/core/theme/app_text.dart
// Headings use Inter, body text uses Noto Sans (measured from the design).
// Fonts are loaded via google_fonts package.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  static TextStyle get pageTitle => GoogleFonts.inter(
        fontSize: 28, fontWeight: FontWeight.w700,
        height: 1.2, letterSpacing: -0.3,
      );
  static TextStyle get pageTitleMobile => GoogleFonts.inter(
        fontSize: 24, fontWeight: FontWeight.w700,
        height: 1.2, letterSpacing: -0.2,
      );
  static TextStyle get authTitle => GoogleFonts.inter(
        fontSize: 32, fontWeight: FontWeight.w700,
        height: 1.2, letterSpacing: -0.4,
      );
  static TextStyle get sectionTitle => GoogleFonts.inter(
        fontSize: 20, fontWeight: FontWeight.w600, height: 1.3,
      );
  static TextStyle get cardTitle => GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w600, height: 1.3,
      );
  static TextStyle get statNumber => GoogleFonts.inter(
        fontSize: 24, fontWeight: FontWeight.w700, height: 1.2,
      );
  static TextStyle get statNumberLarge => GoogleFonts.inter(
        fontSize: 28, fontWeight: FontWeight.w700, height: 1.2,
      );
  static TextStyle get brand => GoogleFonts.inter(
        fontSize: 20, fontWeight: FontWeight.w700, height: 1.2,
      );

  static TextStyle get body => GoogleFonts.notoSans(
        fontSize: 14, fontWeight: FontWeight.w400, height: 1.5,
      );
  static TextStyle get bodyMedium => GoogleFonts.notoSans(
        fontSize: 14, fontWeight: FontWeight.w500, height: 1.5,
      );
  static TextStyle get bodyStrong => GoogleFonts.notoSans(
        fontSize: 14, fontWeight: FontWeight.w600, height: 1.5,
      );
  static TextStyle get label => GoogleFonts.notoSans(
        fontSize: 14, fontWeight: FontWeight.w500, height: 1.4,
      );
  static TextStyle get caption => GoogleFonts.notoSans(
        fontSize: 12, fontWeight: FontWeight.w400, height: 1.4,
      );
  static TextStyle get chip => GoogleFonts.notoSans(
        fontSize: 12, fontWeight: FontWeight.w500, height: 1.2,
      );
}

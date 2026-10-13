// SEED FILE for app/lib/core/theme/app_colors.dart
// Values are sampled from the approved design (see 01-DESIGN-TOKENS.md).
// Not compiled by the author: fix any analyzer errors for the installed Flutter version.
import 'package:flutter/material.dart';

@immutable
class PlanPalColors extends ThemeExtension<PlanPalColors> {
  const PlanPalColors({
    required this.primary,
    required this.link,
    required this.primarySoft,
    required this.violet,
    required this.violetSoft,
    required this.sky,
    required this.skySoft,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningText,
    required this.warningSoft,
    required this.danger,
    required this.dangerSoft,
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.textPrimary,
    required this.textMuted,
    required this.presenceOffline,
    required this.scrim,
  });

  final Color primary;
  final Color link; // text links and active icons (lighter in dark mode)
  final Color primarySoft;
  final Color violet;
  final Color violetSoft;
  final Color sky;
  final Color skySoft;
  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningText;
  final Color warningSoft;
  final Color danger;
  final Color dangerSoft;
  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color border;
  final Color textPrimary;
  final Color textMuted;
  final Color presenceOffline;
  final Color scrim;

  static const Color onPrimary = Color(0xFFFFFFFF);

  static const light = PlanPalColors(
    primary: Color(0xFF4F46E5),
    link: Color(0xFF4F46E5),
    primarySoft: Color(0xFFEEF0FF),
    violet: Color(0xFF8B5CF6),
    violetSoft: Color(0xFFEDE9FE),
    sky: Color(0xFF0EA5E9),
    skySoft: Color(0xFFE0F2FE),
    success: Color(0xFF16A34A),
    successSoft: Color(0xFFDCFCE7),
    warning: Color(0xFFF59E0B),
    warningText: Color(0xFFD97706),
    warningSoft: Color(0xFFFEF3C7),
    danger: Color(0xFFEF4444),
    dangerSoft: Color(0xFFFEE2E2),
    background: Color(0xFFF7F7FB),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFEEF0F6),
    border: Color(0xFFE4E7EF),
    textPrimary: Color(0xFF12141F),
    textMuted: Color(0xFF6B7185),
    presenceOffline: Color(0xFFC4C7D1),
    scrim: Color(0x59000000),
  );

  // Dark values are derived (no image exists). Same hues, same structure.
  static const dark = PlanPalColors(
    primary: Color(0xFF6366F1),
    link: Color(0xFFA5B4FC),
    primarySoft: Color(0xFF232754),
    violet: Color(0xFFA78BFA),
    violetSoft: Color(0xFF2A2250),
    sky: Color(0xFF38BDF8),
    skySoft: Color(0xFF12303F),
    success: Color(0xFF4ADE80),
    successSoft: Color(0xFF12301F),
    warning: Color(0xFFFBBF24),
    warningText: Color(0xFFFBBF24),
    warningSoft: Color(0xFF3A2E10),
    danger: Color(0xFFF87171),
    dangerSoft: Color(0xFF3F1D22),
    background: Color(0xFF0C0E16),
    surface: Color(0xFF151826),
    surfaceAlt: Color(0xFF1E2233),
    border: Color(0xFF262B40),
    textPrimary: Color(0xFFF2F3F8),
    textMuted: Color(0xFF9AA0B8),
    presenceOffline: Color(0xFF4B5168),
    scrim: Color(0x80000000),
  );

  @override
  PlanPalColors copyWith({
    Color? primary,
    Color? link,
    Color? primarySoft,
    Color? violet,
    Color? violetSoft,
    Color? sky,
    Color? skySoft,
    Color? success,
    Color? successSoft,
    Color? warning,
    Color? warningText,
    Color? warningSoft,
    Color? danger,
    Color? dangerSoft,
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? border,
    Color? textPrimary,
    Color? textMuted,
    Color? presenceOffline,
    Color? scrim,
  }) {
    return PlanPalColors(
      primary: primary ?? this.primary,
      link: link ?? this.link,
      primarySoft: primarySoft ?? this.primarySoft,
      violet: violet ?? this.violet,
      violetSoft: violetSoft ?? this.violetSoft,
      sky: sky ?? this.sky,
      skySoft: skySoft ?? this.skySoft,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      warning: warning ?? this.warning,
      warningText: warningText ?? this.warningText,
      warningSoft: warningSoft ?? this.warningSoft,
      danger: danger ?? this.danger,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      presenceOffline: presenceOffline ?? this.presenceOffline,
      scrim: scrim ?? this.scrim,
    );
  }

  @override
  PlanPalColors lerp(ThemeExtension<PlanPalColors>? other, double t) {
    if (other is! PlanPalColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return PlanPalColors(
      primary: l(primary, other.primary),
      link: l(link, other.link),
      primarySoft: l(primarySoft, other.primarySoft),
      violet: l(violet, other.violet),
      violetSoft: l(violetSoft, other.violetSoft),
      sky: l(sky, other.sky),
      skySoft: l(skySoft, other.skySoft),
      success: l(success, other.success),
      successSoft: l(successSoft, other.successSoft),
      warning: l(warning, other.warning),
      warningText: l(warningText, other.warningText),
      warningSoft: l(warningSoft, other.warningSoft),
      danger: l(danger, other.danger),
      dangerSoft: l(dangerSoft, other.dangerSoft),
      background: l(background, other.background),
      surface: l(surface, other.surface),
      surfaceAlt: l(surfaceAlt, other.surfaceAlt),
      border: l(border, other.border),
      textPrimary: l(textPrimary, other.textPrimary),
      textMuted: l(textMuted, other.textMuted),
      presenceOffline: l(presenceOffline, other.presenceOffline),
      scrim: l(scrim, other.scrim),
    );
  }
}

extension PlanPalColorsContext on BuildContext {
  PlanPalColors get colors => Theme.of(this).extension<PlanPalColors>()!;
}

/// Avatar background colors, chosen deterministically from the user id.
const List<Color> kAvatarColors = [
  Color(0xFF4F46E5),
  Color(0xFF8B5CF6),
  Color(0xFF0EA5E9),
  Color(0xFF16A34A),
  Color(0xFFD97706),
  Color(0xFFEF4444),
  Color(0xFF6B7185),
];

Color avatarColorFor(String userId) {
  var hash = 0;
  for (final unit in userId.codeUnits) {
    hash = (hash * 31 + unit) & 0x7fffffff;
  }
  return kAvatarColors[hash % kAvatarColors.length];
}

/// The six event/label colors offered in "Schedule Event".
const List<Color> kEventColors = [
  Color(0xFF4F46E5),
  Color(0xFF8B5CF6),
  Color(0xFF0EA5E9),
  Color(0xFF16A34A),
  Color(0xFFF59E0B),
  Color(0xFFEF4444),
];

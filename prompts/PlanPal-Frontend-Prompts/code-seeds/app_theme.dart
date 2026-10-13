// SEED FILE for app/lib/core/theme/app_theme.dart
// Not compiled by the author. In Flutter versions before 3.27 the classes
// CardThemeData / DialogThemeData are named CardTheme / DialogTheme: use whatever the installed SDK expects.
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text.dart';

class AppRadius {
  AppRadius._();
  static const double card = 20;
  static const double panel = 24;
  static const double tile = 16;
  static const double control = 12;
}

class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

class AppShadows {
  AppShadows._();
  /// Light cards get a very soft shadow; dark cards use only the border.
  static List<BoxShadow> card(Brightness brightness) => brightness == Brightness.light
      ? const [BoxShadow(color: Color(0x0A101828), blurRadius: 2, offset: Offset(0, 1))]
      : const [];
  static List<BoxShadow> floating(Brightness brightness) => brightness == Brightness.light
      ? const [BoxShadow(color: Color(0x1F4F46E5), blurRadius: 16, offset: Offset(0, 6))]
      : const [BoxShadow(color: Color(0x66000000), blurRadius: 16, offset: Offset(0, 6))];
}

ThemeData buildPlanPalTheme(Brightness brightness) {
  final c = brightness == Brightness.light ? PlanPalColors.light : PlanPalColors.dark;
  final shape12 = RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.control));

  final scheme = ColorScheme(
    brightness: brightness,
    primary: c.primary,
    onPrimary: PlanPalColors.onPrimary,
    secondary: c.violet,
    onSecondary: Colors.white,
    error: c.danger,
    onError: Colors.white,
    surface: c.surface,
    onSurface: c.textPrimary,
    outline: c.border,
  );

  final textTheme = const TextTheme(
    displayLarge: AppText.authTitle,
    headlineLarge: AppText.pageTitle,
    headlineMedium: AppText.sectionTitle,
    titleLarge: AppText.sectionTitle,
    titleMedium: AppText.cardTitle,
    bodyLarge: AppText.body,
    bodyMedium: AppText.body,
    bodySmall: AppText.caption,
    labelLarge: AppText.bodyStrong,
    labelMedium: AppText.label,
    labelSmall: AppText.chip,
  ).apply(bodyColor: c.textPrimary, displayColor: c.textPrimary);

  OutlineInputBorder inputBorder([Color? color, double width = 0]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.control),
        borderSide: color == null ? BorderSide.none : BorderSide(color: color, width: width),
      );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: c.background,
    canvasColor: c.surface,
    fontFamily: 'NotoSans',
    textTheme: textTheme,
    dividerTheme: DividerThemeData(color: c.border, thickness: 1, space: 1),
    cardTheme: CardThemeData(
      color: c.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: BorderSide(color: c.border),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.surfaceAlt,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      hintStyle: AppText.body.copyWith(color: c.textMuted),
      errorStyle: AppText.caption.copyWith(color: c.danger),
      border: inputBorder(),
      enabledBorder: inputBorder(),
      focusedBorder: inputBorder(c.primary, 1.5),
      errorBorder: inputBorder(c.danger, 1.5),
      focusedErrorBorder: inputBorder(c.danger, 1.5),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: c.primary,
        foregroundColor: PlanPalColors.onPrimary,
        minimumSize: const Size(0, 44),
        elevation: 0,
        shape: shape12,
        textStyle: AppText.bodyStrong,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: c.textPrimary,
        backgroundColor: c.surface,
        minimumSize: const Size(0, 44),
        side: BorderSide(color: c.border),
        shape: shape12,
        textStyle: AppText.bodyMedium,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: c.link,
        textStyle: AppText.bodyMedium,
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: c.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.panel)),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: c.surface,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      modalBarrierColor: c.scrim,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.panel)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: c.textPrimary,
      contentTextStyle: AppText.body.copyWith(color: c.background),
      shape: shape12,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? c.primary : c.surfaceAlt,
      ),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),
    extensions: <ThemeExtension<dynamic>>[c],
  );
}

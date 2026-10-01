import 'package:flutter/material.dart';

/// Responsive breakpoints
class Breakpoints {
  Breakpoints._();

  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;

  /// Get current layout type
  static LayoutType getLayout(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobile) return LayoutType.mobile;
    if (width < tablet) return LayoutType.tablet;
    return LayoutType.desktop;
  }

  /// Check if mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobile;
  }

  /// Check if tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < tablet;
  }

  /// Check if desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tablet;
  }
}

enum LayoutType {
  mobile, // < 600px: bottom tabs + FAB
  tablet, // 600-899px: navigation rail
  desktop, // >= 900px: sidebar
}

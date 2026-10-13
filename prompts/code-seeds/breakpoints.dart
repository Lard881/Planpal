// SEED FILE for app/lib/core/layout/breakpoints.dart
// The layout is chosen from the window WIDTH, never from the platform.
import 'package:flutter/widgets.dart';

enum LayoutSize { mobile, tablet, desktop }

class Breakpoints {
  Breakpoints._();
  static const double tablet = 600;
  static const double desktop = 900;

  static LayoutSize of(double width) {
    if (width >= desktop) return LayoutSize.desktop;
    if (width >= tablet) return LayoutSize.tablet;
    return LayoutSize.mobile;
  }
}

/// Measured from the design (logical pixels).
class LayoutMetrics {
  LayoutMetrics._();
  static const double sidebarWidth = 240;
  static const double railWidth = 72;       // tablet (derived)
  static const double rightPanelWidth = 288;
  static const double pagePaddingDesktop = 32;
  static const double pagePaddingMobile = 16;
  static const double detailMaxWidth = 960;
  static const double topBarHeight = 40;
  static const double minWindowWidth = 900; // Windows minimum window size is 900 x 600
  static const double minWindowHeight = 600;
}

extension LayoutContext on BuildContext {
  LayoutSize get layoutSize => Breakpoints.of(MediaQuery.sizeOf(this).width);
  bool get isMobileLayout => layoutSize == LayoutSize.mobile;
  bool get isDesktopLayout => layoutSize == LayoutSize.desktop;
}

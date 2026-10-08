import 'dart:io';
import 'package:flutter/foundation.dart';

/// Platform information helper (S16.9)
/// Centralizes all platform checks to avoid blocking macOS support
/// All Windows-specific code should go through this file
class PlatformInfo {
  // Platform checks
  static bool get isWeb => kIsWeb;
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isWindows => !kIsWeb && Platform.isWindows;
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;
  static bool get isLinux => !kIsWeb && Platform.isLinux;
  
  // Group checks
  static bool get isMobile => isAndroid || isIOS;
  static bool get isDesktop => isWindows || isMacOS || isLinux;
  
  // Feature availability
  static bool get supportsWindowManager => isWindows || isMacOS || isLinux;
  static bool get supportsPushNotifications => isAndroid || isIOS;
  static bool get supportsFileSystemPicker => isAndroid || isDesktop;
  static bool get supportsShareSheet => isAndroid || isIOS;
  
  // OS-specific features (properly gated)
  static bool get supportsWindowsIntegration => isWindows;
  static bool get supportsMacOSIntegration => isMacOS;
  
  // Window features
  static bool get supportsWindowResize => isDesktop;
  static bool get supportsWindowPosition => isDesktop;
  static bool get supportsWindowMinimize => isDesktop;
  
  // Get platform name
  static String get platformName {
    if (isWeb) return 'Web';
    if (isAndroid) return 'Android';
    if (isIOS) return 'iOS';
    if (isWindows) return 'Windows';
    if (isMacOS) return 'macOS';
    if (isLinux) return 'Linux';
    return 'Unknown';
  }
  
  // Get platform version
  static String get platformVersion {
    if (kIsWeb) return 'N/A';
    return Platform.operatingSystemVersion;
  }
}

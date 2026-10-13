// app/lib/core/platform/platform_info.dart
// All platform checks in one place so iOS/macOS can be added later.
import 'dart:io';

class PlatformInfo {
  PlatformInfo._();
  static bool get isAndroid => Platform.isAndroid;
  static bool get isWindows => Platform.isWindows;
  static bool get isMacOS => Platform.isMacOS;
  static bool get isIOS => Platform.isIOS;
  static bool get isLinux => Platform.isLinux;
  static bool get isDesktop => isWindows || isMacOS || isLinux;
  static bool get isMobile => isAndroid || isIOS;
}

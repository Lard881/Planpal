// app/lib/core/services/fcm_service.dart
// FCM push notifications — Android only.
// Firebase packages removed from pubspec to allow Windows builds.
// Re-add firebase_core + firebase_messaging to pubspec when targeting Android push.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FcmService {
  /// No-op on all platforms until Firebase packages are re-added.
  static Future<void> initialize(WidgetRef ref) async {
    debugPrint('FCM: Firebase packages not included in this build.');
  }

  /// No-op — nothing to unregister without Firebase.
  static Future<void> unregister(WidgetRef ref) async {}

  static GlobalKey<NavigatorState> get navigatorKey =>
      GlobalKey<NavigatorState>();
}

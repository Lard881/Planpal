import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/logger.dart';
import '../../features/notifications/data/firebase_messaging_provider.dart';
import '../../features/notifications/data/windows_notification_provider.dart';

/// Widget that initializes platform-specific notifications on first build
/// - Android/iOS: Firebase Cloud Messaging
/// - Windows: Local notifications via Supabase Realtime
class NotificationInitializer extends ConsumerStatefulWidget {
  final Widget child;

  const NotificationInitializer({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<NotificationInitializer> createState() => _NotificationInitializerState();
}

class _NotificationInitializerState extends ConsumerState<NotificationInitializer> {
  @override
  void initState() {
    super.initState();
    // Initialize notifications after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeNotifications();
    });
  }

  Future<void> _initializeNotifications() async {
    if (Platform.isAndroid || Platform.isIOS) {
      // Initialize FCM for mobile platforms
      await _initializeFCM();
    } else if (Platform.isWindows) {
      // Initialize Windows local notifications
      await _initializeWindowsNotifications();
    }
  }

  Future<void> _initializeFCM() async {
    try {
      // This will trigger initialization via the provider
      await ref.read(initializeFirebaseMessagingProvider.future);
      logger.info('✓ Firebase Messaging initialized');
    } catch (e, stackTrace) {
      logger.error('Failed to initialize Firebase Messaging', 
        error: e, stackTrace: stackTrace);
      // Continue anyway - push notifications won't work but app still functional
    }
  }

  Future<void> _initializeWindowsNotifications() async {
    try {
      await ref.read(initializeWindowsNotificationsProvider.future);
      logger.info('✓ Windows local notifications initialized');
    } catch (e, stackTrace) {
      logger.error('Failed to initialize Windows notifications',
        error: e, stackTrace: stackTrace);
      // Continue anyway - notifications won't work but app still functional
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

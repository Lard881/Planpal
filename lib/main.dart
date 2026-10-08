import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:firebase_core/firebase_core.dart';
import 'dart:io' show Platform;
import 'package:window_manager/window_manager.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'core/utils/logger.dart';
import 'core/services/supabase_service.dart';
import 'core/providers/theme_provider.dart';
import 'features/auth/data/google_sign_in_service.dart';
import 'core/config/env.dart';

// import 'core/sync/background_sync_service.dart'; // Temporarily disabled - workmanager compatibility
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  logger.i('🚀 Starting PlanPal...');

  // Initialize window manager for desktop platforms (Windows, macOS, Linux)
  // S16.3: Remember size and position
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized();

    // Load saved window preferences
    final savedWidth = prefs.getDouble('window_width') ?? 1200.0;
    final savedHeight = prefs.getDouble('window_height') ?? 800.0;
    final savedX = prefs.getDouble('window_x');
    final savedY = prefs.getDouble('window_y');

    final windowOptions = WindowOptions(
      size: Size(savedWidth, savedHeight),
      minimumSize: const Size(900, 600),
      center: savedX == null || savedY == null,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      // Restore position if saved
      if (savedX != null && savedY != null) {
        await windowManager.setPosition(Offset(savedX, savedY));
      }
      
      await windowManager.show();
      await windowManager.focus();
      logger.i('✓ Window manager initialized (${savedWidth.toInt()}x${savedHeight.toInt()})');
    });

    // Listen for window changes to save preferences
    windowManager.addListener(_WindowPreferencesSaver(prefs));
  }

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  logger.i('✓ SharedPreferences initialized');

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    logger.i('✓ Firebase initialized');
  } catch (e) {
    logger.e('Failed to initialize Firebase', error: e);
    // Continue anyway - push notifications won't work but app still functional
  }

  // Initialize timezone data for notifications
  try {
    tz.initializeTimeZones();
    logger.i('✓ Timezone data initialized');
  } catch (e) {
    logger.e('Failed to initialize timezone data', error: e);
  }

  // Initialize Supabase
  try {
    await SupabaseService.initialize();
  } catch (e) {
    logger.e('Failed to initialize Supabase', error: e);
    // Continue anyway - app can work in offline mode
  }

  // Initialize Google Sign-In for Android
  if (Platform.isAndroid) {
    try {
      GoogleSignInService().initializeForAndroid(
        serverClientId: Env.googleWebClientId.isNotEmpty 
            ? Env.googleWebClientId 
            : null,
        scopes: ['email', 'profile'],
      );
      logger.i('✓ Google Sign-In initialized for Android');
    } catch (e) {
      logger.e('Failed to initialize Google Sign-In', error: e);
      // Continue anyway - email/password auth will still work
    }
  }

  // Initialize background sync
  // Temporarily disabled - workmanager compatibility issues
  /*
  try {
    await BackgroundSyncService.initialize();
    // Schedule periodic sync every 15 minutes (Android minimum)
    await BackgroundSyncService.schedulePeriodicSync(
      frequencyMinutes: 15,
      requiresNetwork: true,
      requiresCharging: false,
    );
    logger.i('✓ Background sync initialized');
  } catch (e) {
    logger.e('Failed to initialize background sync', error: e);
    // Continue anyway - foreground sync will still work
  }
  */

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const PlanPalApp(),
    ),
  );
}


/// Window preferences saver (S16.3)
/// Saves window size and position when changed
class _WindowPreferencesSaver with WindowListener {
  final SharedPreferences prefs;

  _WindowPreferencesSaver(this.prefs);

  @override
  void onWindowResized() async {
    final size = await windowManager.getSize();
    await prefs.setDouble('window_width', size.width);
    await prefs.setDouble('window_height', size.height);
  }

  @override
  void onWindowMoved() async {
    final position = await windowManager.getPosition();
    await prefs.setDouble('window_x', position.dx);
    await prefs.setDouble('window_y', position.dy);
  }
}

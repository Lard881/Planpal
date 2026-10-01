import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'core/utils/logger.dart';
import 'core/services/supabase_service.dart';
import 'core/sync/background_sync_service.dart';
import 'features/reminders/services/background_reminder_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  logger.info('🚀 Starting PlanPal...');

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    logger.info('✓ Firebase initialized');
  } catch (e) {
    logger.error('Failed to initialize Firebase', error: e);
    // Continue anyway - push notifications won't work but app still functional
  }

  // Initialize timezone data for notifications
  try {
    tz.initializeTimeZones();
    logger.info('✓ Timezone data initialized');
  } catch (e) {
    logger.error('Failed to initialize timezone data', error: e);
  }

  // Initialize Supabase
  try {
    await SupabaseService.initialize();
  } catch (e) {
    logger.error('Failed to initialize Supabase', error: e);
    // Continue anyway - app can work in offline mode
  }

  // Initialize background sync
  try {
    await BackgroundSyncService.initialize();
    // Schedule periodic sync every 15 minutes (Android minimum)
    await BackgroundSyncService.schedulePeriodicSync(
      frequencyMinutes: 15,
      requiresNetwork: true,
      requiresCharging: false,
    );
    logger.info('✓ Background sync initialized');
  } catch (e) {
    logger.error('Failed to initialize background sync', error: e);
    // Continue anyway - foreground sync will still work
  }

  // Initialize background reminders
  try {
    await BackgroundReminderService.initialize();
    await BackgroundReminderService.registerPeriodicCheck();
    logger.info('✓ Background reminders initialized');
  } catch (e) {
    logger.error('Failed to initialize background reminders', error: e);
    // Continue anyway - reminders will still work in foreground
  }

  runApp(
    const ProviderScope(
      child: PlanPalApp(),
    ),
  );
}


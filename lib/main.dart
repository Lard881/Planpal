// app/lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:window_manager/window_manager.dart';
import 'core/config/env.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/platform/platform_info.dart';
import 'core/sync/sync_engine.dart';
import 'core/connectivity/connectivity_service.dart';
import 'core/widgets/empty_state.dart';
import 'core/services/fcm_service.dart';
import 'core/providers/user_profile_provider.dart';
import 'core/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (needed for FCM on Android)
  if (PlatformInfo.isAndroid) {
    await Firebase.initializeApp();
  }

  // Allow Google Fonts runtime fetch
  GoogleFonts.config.allowRuntimeFetching = true;

  // Init Supabase (only if env vars are provided).
  if (Env.isConfigured) {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
    );
  } else {
    await Supabase.initialize(
      url: 'https://placeholder.supabase.co',
      anonKey: 'placeholder',
    );
  }

  // Windows: set minimum window size and remember position
  if (PlatformInfo.isWindows) {
    await windowManager.ensureInitialized();
    const options = WindowOptions(
      minimumSize: Size(900, 600),
      size: Size(1280, 800),
      center: true,
      title: 'PlanPal',
    );
    await windowManager.waitUntilReadyToShow(options, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const ProviderScope(child: PlanPalApp()));
}

class PlanPalApp extends ConsumerWidget {
  const PlanPalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final router = ref.watch(routerProvider);

    // Trigger sync when connectivity comes back online
    ref.listen(connectivityServiceProvider, (prev, next) {
      if (prev != ConnectivityState.online &&
          next == ConnectivityState.online) {
        ref.read(syncEngineProvider.notifier).sync();
      }
    });

    // On session restore (cold start with existing session) — load profile
    ref.listen(authStateProvider, (prev, next) {
      if (prev?.valueOrNull == null && next.valueOrNull != null) {
        // User just became logged in (either fresh login or session restore)
        loadMeAndApply(ref);
      }
    });

    // Initialize FCM on Android after the first frame
    if (PlatformInfo.isAndroid) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await FcmService.initialize(ref);
      });
    }

    return MaterialApp.router(
      title: 'PlanPal',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: buildPlanPalTheme(Brightness.light),
      darkTheme: buildPlanPalTheme(Brightness.dark),
      routerConfig: router,
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

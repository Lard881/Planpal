// app/lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase, User;
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
import 'core/providers/user_profile_provider.dart';
import 'core/providers/auth_provider.dart';
import 'core/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // A4: Disable runtime font fetching — fonts are bundled as assets.
  GoogleFonts.config.allowRuntimeFetching = false;

  // Init Supabase. If not configured, SplashScreen will route to /not-configured.
  if (Env.isConfigured) {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
    );
  } else {
    // Still call initialize with placeholder so the SDK doesn't crash;
    // the splash screen checks Env.isConfigured and redirects accordingly.
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
    ref.listen<AsyncValue<User?>>(authStateProvider, (prev, next) {
      if (prev?.valueOrNull == null && next.valueOrNull != null) {
        // User just became logged in (either fresh login or session restore)
        loadMeAndApply(ref);
      }
    });

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

// app/lib/main.dart
import 'dart:async';

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
import 'core/db/app_database.dart';
import 'core/network/api_client.dart';
import 'core/services/fcm_service.dart';
import 'features/workspaces/providers/workspace_providers.dart';
import 'core/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final _rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // A4: Disable runtime font fetching — fonts are bundled as assets.
  GoogleFonts.config.allowRuntimeFetching = false;

  // Init Supabase. If not configured, SplashScreen will route to /not-configured.
  if (Env.isConfigured) {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      publishableKey: Env.supabaseAnonKey,
    );
  } else {
    // Still call initialize with placeholder so the SDK doesn't crash;
    // the splash screen checks Env.isConfigured and redirects accordingly.
    await Supabase.initialize(
      url: 'https://placeholder.supabase.co',
      publishableKey: 'placeholder',
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

    ref.listen<bool>(sessionExpiredProvider, (_, expired) {
      if (!expired) return;
      ref.read(sessionExpiredProvider.notifier).state = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final messengerContext = _rootScaffoldMessengerKey.currentContext;
        if (messengerContext == null) return;
        final l10n = AppLocalizations.of(messengerContext);
        _rootScaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text(l10n.errorSessionExpired)),
        );
      });
    });

    // Trigger sync when connectivity comes back online
    ref.listen(connectivityServiceProvider, (prev, next) {
      if (prev != ConnectivityState.online &&
          next == ConnectivityState.online &&
          ref.read(currentUserProvider) != null) {
        ref
            .read(syncEngineProvider.notifier)
            .sync(workspaceId: ref.read(currentWorkspaceIdProvider));
      }
    });

    ref.listen<String?>(currentWorkspaceIdProvider, (previous, next) {
      if (next != null &&
          next != previous &&
          ref.read(currentUserProvider) != null) {
        ref.read(syncEngineProvider.notifier).sync(workspaceId: next);
      }
    });

    // On session restore (cold start with existing session) — load profile
    ref.listen<AsyncValue<User?>>(authStateProvider, (prev, next) {
      if (prev?.valueOrNull == null && next.valueOrNull != null) {
        // User just became logged in (either fresh login or session restore)
        unawaited(FcmService.initialize(ref));
        loadMeAndApply(ref);
      }
      if (prev?.valueOrNull != null && next.valueOrNull == null) {
        unawaited(_clearSignedOutUserData(ref));
      }
    });

    return MaterialApp.router(
      title: 'PlanPal',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _rootScaffoldMessengerKey,
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

  Future<void> _clearSignedOutUserData(WidgetRef ref) async {
    try {
      await ref.read(appDatabaseProvider).clearUserData();
      await ref.read(currentWorkspaceIdProvider.notifier).clear();
      await ref.read(syncEngineProvider.notifier).clearSyncCursors();
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'signed-out local data cleanup',
        ),
      );
    }
  }
}

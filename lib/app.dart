import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/app_providers.dart';
import 'core/navigation/global_navigator_key.dart';
import 'core/initialization/fcm_initializer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlanPalApp extends ConsumerWidget {
  const PlanPalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return NotificationInitializer(
      child: MaterialApp.router(
        // Global navigator key for push notification navigation
        key: globalNavigatorKey,
        
        title: 'PlanPal',
        debugShowCheckedModeBanner: false,
        
        // Routing
        routerConfig: router,
        
        // Theme
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system, // TODO: Make this configurable via provider
        
        // Localization
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('es'), // Spanish
          Locale('fr'), // French
          Locale('zh'), // Chinese (Simplified)
          Locale('ko'), // Korean
        ],
      ),
    );
  }
}

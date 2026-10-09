import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/app_providers.dart';
import 'core/providers/theme_provider.dart';
import 'core/navigation/global_navigator_key.dart';
import 'core/initialization/fcm_initializer.dart';
import 'features/search/presentation/widgets/search_shortcut_listener.dart';
import 'core/l10n/app_localizations.dart';

class PlanPalApp extends ConsumerWidget {
  const PlanPalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return NotificationInitializer(
      child: SearchShortcutListener(
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
          themeMode: themeMode,
          
          // Localization
          localizationsDelegates: const [
            // AppLocalizations.delegate, // Temporarily disabled
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
      ),
    );
  }
}
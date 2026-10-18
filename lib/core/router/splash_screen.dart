// app/lib/core/router/splash_screen.dart
// A1.5: Restores session, loads GET /me, applies theme/language, then navigates.
// A1.4: Checks if onboarding has been shown; if not, routes there first.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import '../config/env.dart';
import '../providers/auth_provider.dart';
import '../providers/user_profile_provider.dart';

const _kOnboardingKey = 'planpal_onboarding_shown';
const _storage = FlutterSecureStorage();

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // A1.9: if not configured, send to error screen immediately
    if (!Env.isConfigured) {
      if (mounted) context.go('/not-configured');
      return;
    }

    // Wait for auth to settle (Supabase restores session from secure storage)
    await Future.doWhile(() async {
      final state = ref.read(authStateProvider);
      if (state.isLoading) {
        await Future.delayed(const Duration(milliseconds: 50));
        return true;
      }
      return false;
    });

    if (!mounted) return;

    final isLoggedIn = ref.read(authStateProvider).valueOrNull != null;
    if (isLoggedIn) {
      // Load profile, apply theme & language
      await loadMeAndApply(ref);
      if (!mounted) return;

      // A1.4: Show onboarding once after the very first verified login
      final shown = await _storage.read(key: _kOnboardingKey);
      if (shown == null) {
        // Mark shown immediately so a crash during onboarding doesn't loop
        await _storage.write(key: _kOnboardingKey, value: 'true');
        if (mounted) context.go('/onboarding');
      } else {
        if (mounted) context.go('/home');
      }
    } else {
      if (mounted) context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2196F3),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/planpal-logo.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 32),
            Container(
              width: 112,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.24),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.38,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.82),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

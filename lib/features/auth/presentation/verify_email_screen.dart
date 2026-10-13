// app/lib/features/auth/presentation/verify_email_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/widgets/planpal_button.dart';
import '../../../core/providers/user_profile_provider.dart';
import 'auth_notifier.dart';
import 'widgets/auth_logo.dart';
import 'widgets/otp_field.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  final String? email;
  const VerifyEmailScreen({super.key, this.email});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  String _otp = '';
  int _resendCooldown = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    setState(() => _resendCooldown = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _resendCooldown--);
      if (_resendCooldown <= 0) t.cancel();
    });
  }

  Future<void> _verify() async {
    if (_otp.length < 6) return;
    final email = widget.email ?? '';
    final ok = await ref.read(authNotifierProvider.notifier).verifyOtp(email, _otp);
    if (ok && mounted) {
      await loadMeAndApply(ref);
      context.go('/onboarding/workspace');
    }
  }

  Future<void> _resend() async {
    if (_resendCooldown > 0) return;
    await ref.read(authNotifierProvider.notifier).resendOtp(widget.email ?? '');
    _startCooldown();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);
    final c = context.colors;
    final isDesktop = context.isDesktopLayout;
    final email = widget.email ?? '';

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isDesktop) ...[
          const SizedBox(height: 48),
          const Center(child: AuthLogo()),
          const SizedBox(height: 32),
        ],
        Text('Check your inbox',
          style: (isDesktop ? AppText.authTitle : AppText.pageTitleMobile)
              .copyWith(color: c.textPrimary),
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          isDesktop
              ? 'We sent a 6-digit code to $email'
              : 'Code sent to $email',
          style: AppText.body.copyWith(color: c.textMuted),
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
        ),
        const SizedBox(height: 32),
        if (state.error != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: c.dangerSoft,
              borderRadius: BorderRadius.circular(AppRadius.control),
            ),
            child: Text(state.error!.message,
              style: AppText.body.copyWith(color: c.danger)),
          ),
          const SizedBox(height: 16),
        ],
        OtpField(
          length: 6,
          onCompleted: (v) => setState(() => _otp = v),
          onChanged: (v) => setState(() => _otp = v),
        ),
        const SizedBox(height: 24),
        PlanPalButton(
          label: 'Verify',
          onPressed: _otp.length == 6 ? _verify : null,
          loading: state.loading,
          width: double.infinity,
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: _resendCooldown > 0 ? null : _resend,
            child: Text(
              _resendCooldown > 0
                  ? "Didn't get it? Resend in ${_resendCooldown}s"
                  : "Didn't get it? Resend code",
              style: AppText.bodyMedium.copyWith(
                color: _resendCooldown > 0 ? c.textMuted : c.primary),
            ),
          ),
        ),
      ],
    );

    if (isDesktop) {
      return Scaffold(
        backgroundColor: c.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AuthLogo(),
              const SizedBox(height: 32),
              Container(
                width: 440,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(AppRadius.panel),
                  border: Border.all(color: c.border),
                  boxShadow: AppShadows.card(Brightness.light),
                ),
                child: content,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: content,
        ),
      ),
    );
  }
}

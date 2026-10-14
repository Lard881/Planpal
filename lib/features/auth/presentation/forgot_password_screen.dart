// app/lib/features/auth/presentation/forgot_password_screen.dart
// 3-step: Step1=email, Step2=OTP, Step3=new password
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/widgets/planpal_button.dart';
import '../../../core/widgets/planpal_text_field.dart';
import '../../../core/l10n/app_localizations.dart';
import 'auth_notifier.dart';
import 'widgets/auth_logo.dart';
import 'widgets/otp_field.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  final int initialStep;
  const ForgotPasswordScreen({super.key, this.initialStep = 1});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends ConsumerState<ForgotPasswordScreen> {
  late int _step;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  String _otp = '';
  String? _emailError, _passError, _confirmError;
  int _resendCooldown = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _step = widget.initialStep;
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
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

  Future<void> _step1Submit() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _emailError = _emailCtrl.text.trim().isEmpty
          ? l10n.validationEmailRequired
          : (!_emailCtrl.text.contains('@') ? l10n.validationEmailInvalid : null);
    });
    if (_emailError != null) return;
    final ok = await ref.read(authNotifierProvider.notifier)
        .sendPasswordReset(_emailCtrl.text.trim());
    if (ok && mounted) setState(() => _step = 2);
  }

  Future<void> _step2Submit() async {
    if (_otp.length < 6) return;
    final ok = await ref.read(authNotifierProvider.notifier)
        .verifyPasswordResetOtp(_emailCtrl.text.trim(), _otp);
    if (ok && mounted) setState(() => _step = 3);
  }

  Future<void> _step3Submit() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _passError = _passCtrl.text.length < 8 ? l10n.validationPasswordTooShort : null;
      _confirmError = _passCtrl.text != _confirmCtrl.text ? l10n.validationPasswordsNoMatch : null;
    });
    if (_passError != null || _confirmError != null) return;
    final ok = await ref.read(authNotifierProvider.notifier)
        .setNewPassword(_passCtrl.text);
    if (ok && mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);
    final c = context.colors;
    final isDesktop = context.isDesktopLayout;

    Widget body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isDesktop) ...[
          const SizedBox(height: 48),
          const Center(child: AuthLogo()),
          const SizedBox(height: 24),
        ],
        _buildStepIndicator(c, isDesktop),
        const SizedBox(height: 28),
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
        if (_step == 1) _buildStep1(state, c),
        if (_step == 2) _buildStep2(state, c),
        if (_step == 3) _buildStep3(state, c),
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
                child: body,
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
          child: body,
        ),
      ),
    );
  }

  Widget _buildStepIndicator(PlanPalColors c, bool isDesktop) {
    final l10n = AppLocalizations.of(context);
    if (isDesktop) {
      return Row(
        children: List.generate(3, (i) {
          final active = _step == i + 1;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: active ? c.primarySoft : c.surfaceAlt,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(l10n.forgotPasswordStep(i + 1),
                style: AppText.chip.copyWith(
                  color: active ? c.primary : c.textMuted)),
            ),
          );
        }),
      );
    }
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: c.primarySoft,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(l10n.forgotPasswordStep(_step),
          style: AppText.chip.copyWith(color: c.primary)),
      ),
    );
  }

  Widget _buildStep1(AuthState state, PlanPalColors c) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.forgotPasswordTitle,
          style: AppText.sectionTitle.copyWith(color: c.textPrimary)),
        const SizedBox(height: 8),
        Text(l10n.forgotPasswordSubtitle,
          style: AppText.body.copyWith(color: c.textMuted)),
        const SizedBox(height: 24),
        PlanPalTextField(
          label: l10n.fieldEmail,
          hint: l10n.fieldEmailHint,
          controller: _emailCtrl,
          errorText: _emailError,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onEditingComplete: _step1Submit,
          onChanged: (_) => setState(() => _emailError = null),
        ),
        const SizedBox(height: 20),
        PlanPalButton(
          label: l10n.forgotPasswordSendCode,
          onPressed: _step1Submit,
          loading: state.loading,
          width: double.infinity,
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: () => context.go('/login'),
            child: Text(l10n.forgotPasswordBackToLogin,
              style: AppText.bodyMedium.copyWith(color: c.primary)),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2(AuthState state, PlanPalColors c) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.forgotPasswordEnterCode,
          style: AppText.sectionTitle.copyWith(color: c.textPrimary)),
        const SizedBox(height: 8),
        Text(l10n.forgotPasswordCodeSent,
          style: AppText.body.copyWith(color: c.textMuted)),
        const SizedBox(height: 24),
        OtpField(
          length: 6,
          onCompleted: (v) => setState(() => _otp = v),
          onChanged: (v) => setState(() => _otp = v),
        ),
        const SizedBox(height: 24),
        PlanPalButton(
          label: l10n.forgotPasswordContinue,
          onPressed: _otp.length == 6 ? _step2Submit : null,
          loading: state.loading,
          width: double.infinity,
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: _resendCooldown > 0 ? null : () async {
              await ref.read(authNotifierProvider.notifier)
                  .sendPasswordReset(_emailCtrl.text.trim());
              _startCooldown();
            },
            child: Text(
              _resendCooldown > 0
                  ? l10n.verifyEmailResendCooldown(_resendCooldown)
                  : l10n.verifyEmailResend,
              style: AppText.bodyMedium.copyWith(
                color: _resendCooldown > 0 ? c.textMuted : c.primary)),
          ),
        ),
      ],
    );
  }

  Widget _buildStep3(AuthState state, PlanPalColors c) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.forgotPasswordSetNew,
          style: AppText.sectionTitle.copyWith(color: c.textPrimary)),
        const SizedBox(height: 24),
        PlanPalTextField(
          label: l10n.fieldNewPassword,
          hint: l10n.fieldPasswordHint,
          controller: _passCtrl,
          errorText: _passError,
          isPassword: true,
          textInputAction: TextInputAction.next,
          onChanged: (_) => setState(() => _passError = null),
        ),
        const SizedBox(height: 16),
        PlanPalTextField(
          label: l10n.fieldConfirmNewPassword,
          hint: l10n.fieldPasswordHint,
          controller: _confirmCtrl,
          errorText: _confirmError,
          isPassword: true,
          textInputAction: TextInputAction.done,
          onEditingComplete: _step3Submit,
          onChanged: (_) => setState(() => _confirmError = null),
        ),
        const SizedBox(height: 20),
        PlanPalButton(
          label: l10n.forgotPasswordSaveNew,
          onPressed: _step3Submit,
          loading: state.loading,
          width: double.infinity,
        ),
      ],
    );
  }
}

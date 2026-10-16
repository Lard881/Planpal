// app/lib/features/auth/presentation/signup_screen.dart
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
import 'widgets/auth_divider.dart';
import 'widgets/google_button.dart';
import '../../../core/services/google_sign_in_service.dart';
import 'auth_failure_message.dart';
import '../../../core/providers/user_profile_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});
  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _termsAccepted = false;
  String? _nameError, _emailError, _passError, _confirmError, _termsError;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  bool _validate() {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _nameError = _nameCtrl.text.trim().isEmpty
          ? l10n.validationNameRequired
          : null;
      _emailError = _emailCtrl.text.trim().isEmpty
          ? l10n.validationEmailRequired
          : (!_emailCtrl.text.contains('@')
                ? l10n.validationEmailInvalid
                : null);
      _passError = _passCtrl.text.length < 8
          ? l10n.validationPasswordTooShort
          : null;
      _confirmError = _passCtrl.text != _confirmCtrl.text
          ? l10n.validationPasswordsNoMatch
          : null;
      _termsError = !_termsAccepted ? l10n.validationTermsRequired : null;
    });
    return _nameError == null &&
        _emailError == null &&
        _passError == null &&
        _confirmError == null &&
        _termsError == null;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    final ok = await ref
        .read(authNotifierProvider.notifier)
        .signUp(_emailCtrl.text.trim(), _passCtrl.text, _nameCtrl.text.trim());
    if (ok && mounted) {
      context.go('/verify-email', extra: _emailCtrl.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isDesktop = context.isDesktopLayout;
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.background,
      body: isDesktop
          ? _buildDesktop(context, authState, c)
          : _buildMobile(context, authState, c),
    );
  }

  Widget _buildMobile(BuildContext context, AuthState state, PlanPalColors c) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),
                    const Center(child: AuthLogo()),
                    const SizedBox(height: 32),
                    Text(
                      l10n.signupTitle,
                      style: AppText.pageTitleMobile.copyWith(
                        color: c.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    _buildForm(state, c),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: _buildLoginLink(context, c),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context, AuthState state, PlanPalColors c) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: Center(
            child: SizedBox(
              width: 448,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthLogo(),
                    const SizedBox(height: 40),
                    Text(
                      l10n.signupTitle,
                      style: AppText.authTitle.copyWith(color: c.textPrimary),
                    ),
                    const SizedBox(height: 32),
                    _buildForm(state, c),
                    const SizedBox(height: 24),
                    _buildLoginLink(context, c),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [c.primary, c.violet],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.signupTeamworkTitle,
                      style: AppText.authTitle.copyWith(
                        color: Colors.white,
                        fontSize: 36,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.signupTeamworkDesc,
                      style: AppText.body.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        _WhitePill('✓ ${l10n.navTasks}'),
                        _WhitePill('✓ ${l10n.navCalendar}'),
                        _WhitePill('✓ ${l10n.navChat}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(AuthState state, PlanPalColors c) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.error != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: c.dangerSoft,
              borderRadius: BorderRadius.circular(AppRadius.control),
            ),
            child: Text(
              authFailureMessage(l10n, state.error!),
              style: AppText.body.copyWith(color: c.danger),
            ),
          ),
          const SizedBox(height: 16),
        ],
        PlanPalTextField(
          label: l10n.fieldFullName,
          hint: l10n.fieldFullNameHint,
          controller: _nameCtrl,
          errorText: _nameError,
          textInputAction: TextInputAction.next,
          onChanged: (_) => setState(() => _nameError = null),
        ),
        const SizedBox(height: 16),
        PlanPalTextField(
          label: l10n.fieldEmail,
          hint: l10n.fieldEmailHint,
          controller: _emailCtrl,
          errorText: _emailError,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: (_) => setState(() => _emailError = null),
        ),
        const SizedBox(height: 16),
        PlanPalTextField(
          label: l10n.fieldPassword,
          hint: l10n.fieldPasswordHint,
          controller: _passCtrl,
          errorText: _passError,
          isPassword: true,
          textInputAction: TextInputAction.next,
          onChanged: (_) => setState(() => _passError = null),
        ),
        const SizedBox(height: 16),
        PlanPalTextField(
          label: l10n.fieldConfirmPassword,
          hint: l10n.fieldPasswordHint,
          controller: _confirmCtrl,
          errorText: _confirmError,
          isPassword: true,
          textInputAction: TextInputAction.done,
          onEditingComplete: _submit,
          onChanged: (_) => setState(() => _confirmError = null),
        ),
        const SizedBox(height: 16),
        _buildTermsRow(c),
        if (_termsError != null) ...[
          const SizedBox(height: 4),
          Text(_termsError!, style: AppText.caption.copyWith(color: c.danger)),
        ],
        const SizedBox(height: 20),
        PlanPalButton(
          label: l10n.signUp,
          onPressed: _submit,
          loading: state.loading,
          width: double.infinity,
        ),
        const SizedBox(height: 16),
        const AuthDivider(),
        const SizedBox(height: 16),
        GoogleButton(
          onPressed: () async {
            final (ok, err) = await GoogleSignInService.signIn(
              browserCompleteMessage: l10n.authGoogleBrowserComplete,
              browserFailureMessage: l10n.authGoogleBrowserFailure,
            );
            if (!mounted) return;
            if (err != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(
                SnackBar(content: Text(authFailureMessage(l10n, err))),
              );
            } else if (ok) {
              await loadMeAndApply(ref);
              if (!mounted) return;
              context.go('/home');
            }
          },
        ),
      ],
    );
  }

  void _showLegalDialog(BuildContext context, String title) {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(l10n.settingsComingSoon(title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.btnConfirm),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsRow(PlanPalColors c) {
    final l10n = AppLocalizations.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: _termsAccepted,
          onChanged: (v) => setState(() {
            _termsAccepted = v ?? false;
            _termsError = null;
          }),
          activeColor: c.primary,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        const SizedBox(width: 4),
        Text(
          '${l10n.signupTermsPrefix} ',
          style: AppText.body.copyWith(color: c.textMuted),
        ),
        GestureDetector(
          onTap: () => _showLegalDialog(context, l10n.signupTerms),
          child: Text(
            l10n.signupTerms,
            style: AppText.bodyMedium.copyWith(color: c.primary),
          ),
        ),
        Text(
          ' ${l10n.signupTermsAnd} ',
          style: AppText.body.copyWith(color: c.textMuted),
        ),
        GestureDetector(
          onTap: () => _showLegalDialog(context, l10n.signupPrivacy),
          child: Text(
            l10n.signupPrivacy,
            style: AppText.bodyMedium.copyWith(color: c.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginLink(BuildContext context, PlanPalColors c) {
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${l10n.signupHaveAccount} ',
          style: AppText.body.copyWith(color: c.textMuted),
        ),
        GestureDetector(
          onTap: () => context.go('/login'),
          child: Text(
            l10n.logIn,
            style: AppText.bodyMedium.copyWith(color: c.primary),
          ),
        ),
      ],
    );
  }
}

class _WhitePill extends StatelessWidget {
  final String label;
  const _WhitePill(this.label);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

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
import 'auth_notifier.dart';
import 'widgets/auth_logo.dart';
import 'widgets/auth_divider.dart';
import 'widgets/google_button.dart';
import '../../../core/services/google_sign_in_service.dart';
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
    setState(() {
      _nameError = _nameCtrl.text.trim().isEmpty ? 'Full name is required.' : null;
      _emailError = _emailCtrl.text.trim().isEmpty
          ? 'Email is required.'
          : (!_emailCtrl.text.contains('@') ? 'Enter a valid email.' : null);
      _passError = _passCtrl.text.length < 8
          ? 'Password must be at least 8 characters.' : null;
      _confirmError = _passCtrl.text != _confirmCtrl.text
          ? 'Passwords do not match.' : null;
      _termsError = !_termsAccepted ? 'Please agree to the Terms and Privacy Policy.' : null;
    });
    return _nameError == null && _emailError == null &&
        _passError == null && _confirmError == null && _termsError == null;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    final ok = await ref.read(authNotifierProvider.notifier).signUp(
      _emailCtrl.text.trim(),
      _passCtrl.text,
      _nameCtrl.text.trim(),
    );
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
                    Text('Create your account',
                      style: AppText.pageTitleMobile.copyWith(color: c.textPrimary),
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
    return Row(
      children: [
        // Left: form
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
                    Text('Create your account',
                      style: AppText.authTitle.copyWith(color: c.textPrimary)),
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
        // Right: purple gradient panel
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5A4AE8), Color(0xFF7554EF)],
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
                    Text('Teamwork,\nminus the chaos.',
                      style: AppText.authTitle.copyWith(
                          color: Colors.white, fontSize: 36),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tasks, calendar, chat, docs and insights\n— designed to feel calm.',
                      style: AppText.body.copyWith(
                          color: Colors.white.withOpacity(0.8)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 12, runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        _WhitePill('✓ Tasks'),
                        _WhitePill('✓ Calendar'),
                        _WhitePill('✓ Chat'),
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
            child: Text(state.error!.message,
              style: AppText.body.copyWith(color: c.danger)),
          ),
          const SizedBox(height: 16),
        ],
        PlanPalTextField(
          label: 'Full name',
          hint: 'Maya Chen',
          controller: _nameCtrl,
          errorText: _nameError,
          textInputAction: TextInputAction.next,
          onChanged: (_) => setState(() => _nameError = null),
        ),
        const SizedBox(height: 16),
        PlanPalTextField(
          label: 'Email',
          hint: 'maya.chen@planpal.io',
          controller: _emailCtrl,
          errorText: _emailError,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: (_) => setState(() => _emailError = null),
        ),
        const SizedBox(height: 16),
        PlanPalTextField(
          label: 'Password',
          hint: '••••••••••',
          controller: _passCtrl,
          errorText: _passError,
          isPassword: true,
          textInputAction: TextInputAction.next,
          onChanged: (_) => setState(() => _passError = null),
        ),
        const SizedBox(height: 16),
        PlanPalTextField(
          label: 'Confirm password',
          hint: '••••••••••',
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
          Text(_termsError!,
            style: AppText.caption.copyWith(color: c.danger)),
        ],
        const SizedBox(height: 20),
        PlanPalButton(
          label: 'Create Account',
          onPressed: _submit,
          loading: state.loading,
          width: double.infinity,
        ),
        const SizedBox(height: 16),
        const AuthDivider(),
        const SizedBox(height: 16),
        GoogleButton(onPressed: () async {
                  final (ok, err) = await GoogleSignInService.signIn();
                  if (!mounted) return;
                  if (err != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(err.message)));
                  } else if (ok) {
                    await loadMeAndApply(ref);
                    context.go('/home');
                  }
                }),
      ],
    );
  }

  // A1.11: placeholder pages for legal docs (coming soon)
  void _showLegalDialog(BuildContext context, String title) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: const Text('These documents are coming soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsRow(PlanPalColors c) {
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
        Text('I agree to the ', style: AppText.body.copyWith(color: c.textMuted)),
        GestureDetector(
          onTap: () => _showLegalDialog(context, 'Terms of Service'),
          child: Text('Terms',
            style: AppText.bodyMedium.copyWith(color: c.primary)),
        ),
        Text(' and ', style: AppText.body.copyWith(color: c.textMuted)),
        GestureDetector(
          onTap: () => _showLegalDialog(context, 'Privacy Policy'),
          child: Text('Privacy Policy',
            style: AppText.bodyMedium.copyWith(color: c.primary)),
        ),
      ],
    );
  }

  Widget _buildLoginLink(BuildContext context, PlanPalColors c) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Have an account? ',
          style: AppText.body.copyWith(color: c.textMuted)),
        GestureDetector(
          onTap: () => context.go('/login'),
          child: Text('Log in',
            style: AppText.bodyMedium.copyWith(color: c.primary)),
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
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Text(label,
        style: const TextStyle(color: Colors.white,
            fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }
}

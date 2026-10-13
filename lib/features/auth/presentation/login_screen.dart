// app/lib/features/auth/presentation/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
import 'widgets/login_showcase.dart';
import '../../../core/services/google_sign_in_service.dart';
import '../../../core/providers/user_profile_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String? _emailError;
  String? _passError;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  bool _validate() {
    setState(() {
      _emailError = _emailCtrl.text.trim().isEmpty
          ? 'Email is required.'
          : (!_emailCtrl.text.contains('@') ? 'Enter a valid email.' : null);
      _passError = _passCtrl.text.isEmpty ? 'Password is required.' : null;
    });
    return _emailError == null && _passError == null;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    final ok = await ref.read(authNotifierProvider.notifier)
        .signIn(_emailCtrl.text.trim(), _passCtrl.text);
    if (ok && mounted) {
      await loadMeAndApply(ref);
      context.go('/home');
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
                    Text('Welcome back',
                      style: AppText.pageTitleMobile.copyWith(color: c.textPrimary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text('Log in to keep the day on track.',
                      style: AppText.body.copyWith(color: c.textMuted),
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
              child: _buildSignupLink(context, c),
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
                    Text('Welcome back',
                      style: AppText.authTitle.copyWith(color: c.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    Text('Log in to pick up where you left off.',
                      style: AppText.body.copyWith(color: c.textMuted),
                    ),
                    const SizedBox(height: 32),
                    _buildForm(state, c),
                    const SizedBox(height: 24),
                    _buildSignupLink(context, c),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Right: showcase
        const Expanded(child: LoginShowcase()),
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
          textInputAction: TextInputAction.done,
          onEditingComplete: _submit,
          onChanged: (_) => setState(() => _passError = null),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => context.push('/forgot-password'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text('Forgot password?',
              style: AppText.bodyMedium.copyWith(color: c.primary)),
          ),
        ),
        const SizedBox(height: 16),
        PlanPalButton(
          label: 'Log In',
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

  Widget _buildSignupLink(BuildContext context, PlanPalColors c) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('New here? ', style: AppText.body.copyWith(color: c.textMuted)),
        GestureDetector(
          onTap: () => context.go('/signup'),
          child: Text('Create account',
            style: AppText.bodyMedium.copyWith(color: c.primary)),
        ),
      ],
    );
  }
}

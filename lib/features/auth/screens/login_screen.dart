import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:planpal/core/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/failure_messages.dart';
import '../../../shared/widgets/planpal_button.dart';
import '../../../shared/widgets/planpal_text_field.dart';
import '../presentation/auth_providers.dart';
import '../data/post_login_service.dart';

/// Login screen with email/password authentication
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final breakpoint = Breakpoints.getBreakpoint(context);
    final isMobile = breakpoint == BreakpointType.mobile;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 24 : 48),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo and title
                    _buildHeader(context),
                    const SizedBox(height: 48),

                    // Error message
                    if (_errorMessage != null) ...[
                      _buildErrorBanner(),
                      const SizedBox(height: 24),
                    ],

                    // Email field
                    PlanPalTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      enabled: !_isLoading,
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    PlanPalTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Enter your password',
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      enabled: !_isLoading,
                      validator: _validatePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      onSubmitted: (_) => _handleLogin(),
                    ),
                    const SizedBox(height: 12),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _isLoading ? null : _goToForgotPassword,
                        child: const Text('Forgot password?'),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Login button
                    PlanPalButton(
                      text: 'Sign In',
                      onPressed: _isLoading ? null : _handleLogin,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: AppColors.grey300)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: TextStyle(color: AppColors.grey500),
                          ),
                        ),
                        Expanded(child: Divider(color: AppColors.grey300)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Google sign in
                    OutlinedButton.icon(
                      onPressed: _isLoading ? null : _handleGoogleSignIn,
                      icon: Image.asset(
                        'assets/images/google_logo.png',
                        width: 20,
                        height: 20,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.g_mobiledata, size: 24);
                        },
                      ),
                      label: const Text('Continue with Google'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Sign up link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(color: AppColors.grey600),
                        ),
                        TextButton(
                          onPressed: _isLoading ? null : _goToSignUp,
                          child: const Text('Sign Up'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        // Logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.task_alt,
            size: 48,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 24),
        
        // Title
        Text(
          'Welcome back',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.grey900,
          ),
        ),
        const SizedBox(height: 8),
        
        // Subtitle
        Text(
          'Sign in to continue to PlanPal',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppColors.grey600,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(color: AppColors.error),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () => setState(() => _errorMessage = null),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    // Clear previous error
    setState(() => _errorMessage = null);

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authNotifier = ref.read(authStateNotifierProvider.notifier);
      final success = await authNotifier.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        // Execute post-login flow (GET /me, apply theme/language, set workspace)
        try {
          final apiClient = ref.read(apiClientProvider);
          final prefs = await SharedPreferences.getInstance();
          
          final postLoginService = PostLoginService(
            apiClient: apiClient,
            prefs: prefs,
          );
          
          final result = await postLoginService.executePostLoginFlow();
          
          if (!mounted) return;
          
          // Check if onboarding is needed (first login)
          if (result == 'onboarding') {
            context.go('/onboarding/workspace');
          } else {
            // Navigate to app (workspace set by post-login service)
            context.go('/home');
          }
        } catch (e) {
          // Post-login failed but auth succeeded, still navigate
          // User can work with default settings
          if (mounted) {
            context.go('/home');
          }
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Login failed. Please check your credentials.';
        });
      }
    } catch (e) {
      if (!mounted) return;
      
      // Map error to localized message
      final l10n = AppLocalizations.of(context)!;
      String errorMessage;
      
      if (e is AppFailure) {
        errorMessage = FailureMessages.getMessage(context, e);
      } else {
        errorMessage = 'An unknown error occurred';
      }
      
      setState(() {
        _isLoading = false;
        _errorMessage = errorMessage;
      });
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authNotifier = ref.read(authStateNotifierProvider.notifier);
      final success = await authNotifier.signInWithGoogle();

      if (!success && mounted) {
        // User cancelled or the flow returned false
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _isLoading = false;
          _errorMessage = l10n.errorAuthCancelled;
        });
      }
      // If successful, navigation is handled by auth state change
    } catch (e) {
      if (!mounted) return;
      
      // Map error to localized message
      final l10n = AppLocalizations.of(context)!;
      String errorMessage;
      
      if (e is AppFailure) {
        errorMessage = FailureMessages.getMessage(context, e);
      } else {
        errorMessage = 'An unknown error occurred';
      }
      
      setState(() {
        _isLoading = false;
        _errorMessage = errorMessage;
      });
    }
  }

  void _goToSignUp() {
    context.go('/auth/register');
  }

  void _goToForgotPassword() {
    context.push('/auth/forgot-password');
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:planpal/core/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/utils/logger.dart';
import '../../../shared/widgets/planpal_button.dart';
import '../../../shared/widgets/planpal_text_field.dart';
import '../../../core/errors/app_failure.dart';
import '../data/supabase_auth_error_mapper.dart';

/// Step 3: Set new password
/// User arrives here after clicking reset link in email
class ResetPasswordNewScreen extends ConsumerStatefulWidget {
  const ResetPasswordNewScreen({super.key});

  @override
  ConsumerState<ResetPasswordNewScreen> createState() =>
      _ResetPasswordNewScreenState();
}

class _ResetPasswordNewScreenState extends ConsumerState<ResetPasswordNewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final breakpoint = Breakpoints.getBreakpoint(context);
    final isMobile = breakpoint == BreakpointType.mobile;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Don't allow back navigation
      ),
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
                    // Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.lock_open,
                        size: 48,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Title
                    Text(
                      l10n.authEnterNewPassword,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Text(
                      l10n.authEnterNewPasswordDesc,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.grey600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // Error message
                    if (_errorMessage != null) ...[
                      _buildErrorBanner(),
                      const SizedBox(height: 24),
                    ],

                    // New password field
                    PlanPalTextField(
                      controller: _passwordController,
                      label: l10n.authNewPassword,
                      hint: l10n.authEnterYourPassword,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      enabled: !_isLoading,
                      validator: (value) => _validatePassword(value, l10n),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Confirm password field
                    PlanPalTextField(
                      controller: _confirmPasswordController,
                      label: l10n.confirmPassword,
                      hint: l10n.authConfirmYourPassword,
                      obscureText: _obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      enabled: !_isLoading,
                      validator: (value) => _validateConfirmPassword(value, l10n),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(
                              () => _obscureConfirmPassword = !_obscureConfirmPassword);
                        },
                      ),
                      onSubmitted: (_) => _handleResetPassword(),
                    ),
                    const SizedBox(height: 32),

                    // Reset Password button
                    PlanPalButton(
                      text: l10n.authResetPassword,
                      onPressed: _isLoading ? null : _handleResetPassword,
                      isLoading: _isLoading,
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

  String? _validatePassword(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.validationPasswordRequired;
    }
    if (value.length < 8) {
      return l10n.validationPasswordMinLength(8);
    }
    return null;
  }

  String? _validateConfirmPassword(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.validationPasswordRequired;
    }
    if (value != _passwordController.text) {
      return l10n.validationPasswordMatch;
    }
    return null;
  }

  Future<void> _handleResetPassword() async {
    final l10n = AppLocalizations.of(context)!;
    
    // Clear previous error
    setState(() => _errorMessage = null);

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      logger.i('🔐 Updating password...');
      
      // Update password using Supabase Auth
      final response = await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          password: _passwordController.text,
        ),
      );

      if (response.user != null) {
        logger.i('✅ Password updated successfully');
        
        if (!mounted) return;

        // Show success dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            icon: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 40,
                color: AppColors.success,
              ),
            ),
            title: Text(l10n.authPasswordResetSuccess),
            content: Text(
              'Your password has been reset successfully. You can now sign in with your new password.',
            ),
            actions: [
              PlanPalButton(
                text: 'Go to ${l10n.login}',
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/auth/login');
                },
              ),
            ],
          ),
        );
      } else {
        logger.w('⚠️ Password update returned no user');
        setState(() {
          _isLoading = false;
          _errorMessage = l10n.errorUnknown;
        });
      }
    } on AuthException catch (e) {
      logger.e('❌ Password update failed', error: e);
      final failure = SupabaseAuthErrorMapper.mapAuthException(e);
      
      setState(() {
        _isLoading = false;
        _errorMessage = _getErrorMessage(failure, l10n);
      });
    } catch (e) {
      logger.e('❌ Password update error', error: e);
      setState(() {
        _isLoading = false;
        _errorMessage = l10n.errorUnknown;
      });
    }
  }

  String _getErrorMessage(AppFailure failure, AppLocalizations l10n) {
    return failure.when(
      weakPassword: () => l10n.errorWeakPassword,
      authRequired: () => l10n.errorAuthRequired,
      networkError: () => l10n.errorNoInternet,
      timeout: () => l10n.errorTimeout,
      serverError: (message) => l10n.errorServerError,
      notFound: (resource) => l10n.errorNotFound,
      invalidCredentials: () => l10n.errorInvalidCredentials,
      emailNotConfirmed: () => l10n.errorEmailNotConfirmed,
      emailAlreadyInUse: () => l10n.errorEmailAlreadyInUse,
      invalidCode: () => l10n.errorInvalidCode,
      codeExpired: () => l10n.errorCodeExpired,
      rateLimited: () => 'Too many attempts',
      forbidden: () => l10n.errorForbidden,
      validationError: (message) => message ?? l10n.errorValidationFailed,
      authCancelled: () => l10n.errorAuthCancelled,
      alreadyMember: () => l10n.errorAlreadyMember,
      noNetwork: () => l10n.errorNoNetwork,
      noInternet: () => l10n.errorNoInternet,
      serverUnreachable: () => l10n.errorServerUnreachable,
      authExpired: () => l10n.errorAuthExpired,
      userAlreadyExists: () => l10n.errorUserAlreadyExists,
      notAMember: () => l10n.errorNotAMember,
      lastAdmin: () => l10n.errorLastAdmin,
      codeRevoked: () => l10n.errorCodeRevoked,
      codeUsedUp: () => l10n.errorCodeUsedUp,
      fileTooLarge: () => l10n.errorFileTooLarge,
      fileTypeNotAllowed: () => l10n.errorFileTypeNotAllowed,
      taskNotFound: () => l10n.errorTaskNotFound,
      workspaceNotFound: () => l10n.errorWorkspaceNotFound,
      validationFailed: (fields) => l10n.errorValidationFailed,
      conflict: (message) => message ?? 'Conflict',
      folderNotEmpty: () => 'Folder not empty',
      payloadTooLarge: () => 'Payload too large',
      internalError: () => l10n.errorServerError,
      upstreamError: () => l10n.errorServerError,
      serviceUnavailable: () => l10n.errorServerError,
      syncFailed: (message) => l10n.errorSyncConflict,
      localDatabaseError: () => 'Database error',
      unknown: (message) => message ?? l10n.errorUnknown,
    );
  }
}

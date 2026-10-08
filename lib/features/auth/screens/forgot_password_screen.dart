import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/utils/logger.dart';
import '../../../shared/widgets/planpal_button.dart';
import '../../../shared/widgets/planpal_text_field.dart';
import '../../../core/errors/app_failure.dart';
import '../data/supabase_auth_error_mapper.dart';

/// Step 1: Request password reset code
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
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
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.lock_reset,
                        size: 48,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Title
                    Text(
                      l10n.authResetPassword,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Text(
                      l10n.authResetPasswordDesc,
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

                    // Email field
                    PlanPalTextField(
                      controller: _emailController,
                      label: l10n.email,
                      hint: l10n.authEnterYourEmail,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      enabled: !_isLoading,
                      validator: (value) => _validateEmail(value, l10n),
                      onSubmitted: (_) => _handleRequestCode(),
                    ),
                    const SizedBox(height: 32),

                    // Send Code button
                    PlanPalButton(
                      text: l10n.authSendResetCode,
                      onPressed: _isLoading ? null : _handleRequestCode,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 16),

                    // Back to login
                    TextButton(
                      onPressed: _isLoading ? null : () => context.pop(),
                      child: Text('${l10n.login}'),
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

  String? _validateEmail(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.validationEmailRequired;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return l10n.validationEmailInvalid;
    }
    return null;
  }

  Future<void> _handleRequestCode() async {
    final l10n = AppLocalizations.of(context)!;
    
    // Clear previous error
    setState(() => _errorMessage = null);

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      logger.i('🔐 Requesting password reset for: ${_emailController.text.trim()}');
      
      // Request password reset using Supabase Auth
      await Supabase.instance.client.auth.resetPasswordForEmail(
        _emailController.text.trim(),
      );

      logger.i('✅ Password reset code sent');
      
      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.authCodeSent),
          backgroundColor: AppColors.success,
        ),
      );

      // Navigate to verification step
      context.push('/auth/reset-password/verify?email=${Uri.encodeComponent(_emailController.text.trim())}');
    } on AuthException catch (e) {
      logger.e('❌ Password reset request failed', error: e);
      final failure = SupabaseAuthErrorMapper.mapAuthException(e);
      
      setState(() {
        _isLoading = false;
        _errorMessage = _getErrorMessage(failure, l10n);
      });
    } catch (e) {
      logger.e('❌ Password reset error', error: e);
      setState(() {
        _isLoading = false;
        _errorMessage = l10n.errorUnknown;
      });
    }
  }

  String _getErrorMessage(AppFailure failure, AppLocalizations l10n) {
    return failure.when(
      notFound: (resource) => 'No account found with this email',
      networkError: () => l10n.errorNoInternet,
      timeout: () => l10n.errorTimeout,
      rateLimited: () => 'Too many attempts. Please try again later',
      serverError: (message) => l10n.errorServerError,
      invalidCredentials: () => l10n.errorInvalidCredentials,
      emailNotConfirmed: () => l10n.errorEmailNotConfirmed,
      emailAlreadyInUse: () => l10n.errorEmailAlreadyInUse,
      invalidCode: () => l10n.errorInvalidCode,
      codeExpired: () => l10n.errorCodeExpired,
      weakPassword: () => l10n.errorWeakPassword,
      authRequired: () => l10n.errorAuthRequired,
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

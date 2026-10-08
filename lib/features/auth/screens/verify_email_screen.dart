import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:async';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/utils/logger.dart';
import '../../../shared/widgets/planpal_button.dart';
import '../../../core/errors/app_failure.dart';
import '../data/supabase_auth_error_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Email verification screen with 6-digit OTP code input
class VerifyEmailScreen extends ConsumerStatefulWidget {
  final String email;

  const VerifyEmailScreen({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  
  bool _isVerifying = false;
  bool _isResending = false;
  String? _errorMessage;
  int _resendCooldown = 0;
  Timer? _cooldownTimer;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _cooldownTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/auth/login'),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
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
                      Icons.email_outlined,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  Text(
                    l10n.authVerifyEmail,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    l10n.authVerifyEmailDesc(widget.email),
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

                  // 6-digit code input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 50,
                        margin: EdgeInsets.only(
                          right: index < 5 ? 12 : 0,
                        ),
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          enabled: !_isVerifying,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onChanged: (value) => _onCodeChanged(value, index),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),

                  // Verify button
                  PlanPalButton(
                    text: l10n.authVerifyButton,
                    onPressed: _isVerifying ? null : _handleVerify,
                    isLoading: _isVerifying,
                  ),
                  const SizedBox(height: 24),

                  // Resend code
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${l10n.authResendCode}? ",
                        style: TextStyle(color: AppColors.grey600),
                      ),
                      if (_resendCooldown > 0)
                        Text(
                          l10n.authResendCodeIn(_resendCooldown),
                          style: TextStyle(color: AppColors.grey500),
                        )
                      else
                        TextButton(
                          onPressed: _isResending ? null : _handleResend,
                          child: _isResending
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(l10n.authResendCode),
                        ),
                    ],
                  ),
                ],
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

  void _onCodeChanged(String value, int index) {
    if (value.isNotEmpty) {
      // Move to next field
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last field filled, verify automatically
        _handleVerify();
      }
    } else if (value.isEmpty && index > 0) {
      // Move to previous field on backspace
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _handleVerify() async {
    final l10n = AppLocalizations.of(context)!;
    
    // Clear previous error
    setState(() => _errorMessage = null);

    // Get the full code
    final code = _controllers.map((c) => c.text).join();

    // Validate code
    if (code.length != 6) {
      setState(() => _errorMessage = l10n.validationEmailRequired);
      return;
    }

    setState(() => _isVerifying = true);

    try {
      logger.i('🔐 Verifying email with OTP code...');
      
      // Verify OTP using Supabase Auth
      final response = await Supabase.instance.client.auth.verifyOTP(
        email: widget.email,
        token: code,
        type: OtpType.signup,
      );

      if (response.user != null) {
        logger.i('✅ Email verified successfully');
        
        if (!mounted) return;
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.authVerificationSuccess),
            backgroundColor: AppColors.success,
          ),
        );

        // Navigate to splash which will handle the rest
        context.go('/');
      } else {
        logger.w('⚠️ Verification returned no user');
        setState(() {
          _isVerifying = false;
          _errorMessage = l10n.errorUnknown;
        });
      }
    } on AuthException catch (e) {
      logger.e('❌ Verification failed', error: e);
      final failure = SupabaseAuthErrorMapper.mapAuthException(e);
      
      setState(() {
        _isVerifying = false;
        _errorMessage = _getErrorMessage(failure, l10n);
      });
      
      // Clear the code fields on error
      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    } catch (e) {
      logger.e('❌ Verification error', error: e);
      setState(() {
        _isVerifying = false;
        _errorMessage = l10n.errorUnknown;
      });
      
      // Clear the code fields on error
      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  Future<void> _handleResend() async {
    final l10n = AppLocalizations.of(context)!;
    
    setState(() {
      _isResending = true;
      _errorMessage = null;
    });

    try {
      logger.i('📧 Resending verification code...');
      
      // Resend OTP using Supabase Auth
      await Supabase.instance.client.auth.resend(
        type: OtpType.signup,
        email: widget.email,
      );

      logger.i('✅ Verification code resent');
      
      setState(() => _isResending = false);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.authCodeSent),
            backgroundColor: AppColors.success,
          ),
        );
      }

      // Start cooldown timer (60 seconds)
      _startCooldown();
    } on AuthException catch (e) {
      logger.e('❌ Resend failed', error: e);
      final failure = SupabaseAuthErrorMapper.mapAuthException(e);
      
      setState(() {
        _isResending = false;
        _errorMessage = _getErrorMessage(failure, l10n);
      });
    } catch (e) {
      logger.e('❌ Resend error', error: e);
      setState(() {
        _isResending = false;
        _errorMessage = l10n.errorUnknown;
      });
    }
  }

  void _startCooldown() {
    setState(() => _resendCooldown = 60);
    
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCooldown > 0) {
        setState(() => _resendCooldown--);
      } else {
        timer.cancel();
      }
    });
  }

  String _getErrorMessage(AppFailure failure, AppLocalizations l10n) {
    return failure.when(
      invalidCode: () => l10n.errorInvalidCode,
      codeExpired: () => l10n.errorCodeExpired,
      networkError: () => l10n.errorNoInternet,
      timeout: () => l10n.errorTimeout,
      rateLimited: () => 'Too many attempts. Please try again later',
      serverError: (message) => l10n.errorServerError,
      notFound: (resource) => l10n.errorNotFound,
      invalidCredentials: () => l10n.errorInvalidCredentials,
      emailNotConfirmed: () => l10n.errorEmailNotConfirmed,
      emailAlreadyInUse: () => l10n.errorEmailAlreadyInUse,
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

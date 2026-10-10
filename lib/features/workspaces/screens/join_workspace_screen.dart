import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/planpal_button.dart';
import '../../../core/widgets/planpal_text_field.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../providers/workspace_providers.dart';

/// Screen for joining a workspace using an invite code
/// 
/// Features:
/// - 6-character uppercase code input
/// - Real-time validation
/// - Calls POST /workspaces/join
/// - Success navigation to workspace
/// - Error handling for invalid/expired codes
class JoinWorkspaceScreen extends ConsumerStatefulWidget {
  const JoinWorkspaceScreen({super.key});

  @override
  ConsumerState<JoinWorkspaceScreen> createState() => _JoinWorkspaceScreenState();
}

class _JoinWorkspaceScreenState extends ConsumerState<JoinWorkspaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  String? _validateCode(String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.fieldRequired;
    }
    
    // Code must be exactly 6 characters
    if (value.length != 6) {
      return context.l10n.workspaceCodeLength;
    }
    
    // Code must be alphanumeric
    if (!RegExp(r'^[A-Z0-9]+$').hasMatch(value)) {
      return context.l10n.workspaceCodeFormat;
    }
    
    return null;
  }

  Future<void> _joinWorkspace() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final code = _codeController.text.trim().toUpperCase();
      
      // Call the join workspace method
      await ref.read(workspaceRepositoryProvider).joinWorkspace(code);
      
      // Refresh current workspace after joining
      ref.invalidate(currentWorkspaceProvider);
      ref.invalidate(workspaceListProvider);
      
      if (!mounted) return;
      
      // Show success message
      AppSnackbar.showSuccess(
        context,
        context.l10n.workspaceJoinSuccess,
      );
      
      // Navigate back to workspaces list or home
      context.go('/home');
      
    } catch (e) {
      if (!mounted) return;
      
      // Show error message
      String errorMessage = context.l10n.workspaceJoinError;
      
      // Customize error messages based on error type
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('invalid') || errorString.contains('not found')) {
        errorMessage = context.l10n.workspaceCodeInvalid;
      } else if (errorString.contains('expired')) {
        errorMessage = context.l10n.workspaceCodeExpired;
      } else if (errorString.contains('already') || errorString.contains('member')) {
        errorMessage = context.l10n.workspaceAlreadyMember;
      }
      
      AppSnackbar.showError(context, errorMessage);
      
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.workspaceJoinTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 24.0 : 32.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Icon
                    Icon(
                      Icons.group_add_rounded,
                      size: 80,
                      color: theme.colorScheme.primary,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Title
                    Text(
                      context.l10n.workspaceJoinTitle,
                      style: AppTextStyles.h2.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Description
                    Text(
                      context.l10n.workspaceJoinDescription,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Invite code field
                    TextFormField(
                      controller: _codeController,
                      validator: _validateCode,
                      enabled: !_isLoading,
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 6,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                        UpperCaseTextFormatter(),
                      ],
                      textAlign: TextAlign.center,
                      style: AppTextStyles.h3.copyWith(
                        letterSpacing: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        labelText: context.l10n.workspaceInviteCode,
                        hintText: 'ABC123',
                        prefixIcon: const Icon(Icons.key_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onFieldSubmitted: (_) => _joinWorkspace(),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Helper text
                    Text(
                      context.l10n.workspaceCodeHelper,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Join button
                    PlanPalButton(
                      text: context.l10n.workspaceJoinButton,
                      fullWidth: true,
                      onPressed: _isLoading ? null : _joinWorkspace,
                      isLoading: _isLoading,
                      icon: Icons.login_rounded,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Cancel button
                    PlanPalButton(
                      text: context.l10n.cancel,
                      type: ButtonType.secondary,
                      fullWidth: true,
                      onPressed: _isLoading ? null : () => context.pop(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Divider with "or"
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            context.l10n.or,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Create workspace option
                    TextButton.icon(
                      onPressed: _isLoading ? null : () {
                        context.go('/workspaces/create');
                      },
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      label: Text(context.l10n.workspaceCreateNew),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
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
}

/// Text input formatter that converts input to uppercase
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

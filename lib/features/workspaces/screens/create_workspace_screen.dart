import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:planpal/core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/failure_messages.dart';
import '../../../shared/widgets/planpal_button.dart';
import '../../../shared/widgets/planpal_text_field.dart';
import '../providers/workspace_providers.dart';

/// Create workspace screen
/// Allows user to create a new team workspace
class CreateWorkspaceScreen extends ConsumerStatefulWidget {
  const CreateWorkspaceScreen({super.key});

  @override
  ConsumerState<CreateWorkspaceScreen> createState() => _CreateWorkspaceScreenState();
}

class _CreateWorkspaceScreenState extends ConsumerState<CreateWorkspaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final breakpoint = Breakpoints.getBreakpoint(context);
    final isMobile = breakpoint == BreakpointType.mobile;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Workspace'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 24 : 48),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Icon
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.group_add,
                          size: 48,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      'Create a Team Workspace',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      'Team workspaces allow you to collaborate with others. You\'ll be the admin and can invite members.',
                      style: TextStyle(
                        color: AppColors.grey600,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Error message
                    if (_errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.error.withOpacity(0.3),
                          ),
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Workspace name field
                    PlanPalTextField(
                      controller: _nameController,
                      label: 'Workspace Name',
                      hint: 'e.g., Marketing Team, Design Squad',
                      textInputAction: TextInputAction.done,
                      enabled: !_isLoading,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Workspace name is required';
                        }
                        if (value.trim().length < 2) {
                          return 'Workspace name must be at least 2 characters';
                        }
                        if (value.trim().length > 50) {
                          return 'Workspace name must be less than 50 characters';
                        }
                        return null;
                      },
                      onSubmitted: (_) => _handleCreate(),
                    ),
                    const SizedBox(height: 32),

                    // Create button
                    PlanPalButton(
                      text: 'Create Workspace',
                      onPressed: _isLoading ? null : _handleCreate,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 16),

                    // Cancel button
                    TextButton(
                      onPressed: _isLoading ? null : () => context.pop(),
                      child: const Text('Cancel'),
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

  Future<void> _handleCreate() async {
    setState(() => _errorMessage = null);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(workspaceRepositoryProvider);
      final workspace = await repository.createWorkspace(
        name: _nameController.text.trim(),
      );

      if (!mounted) return;

      // Switch to the new workspace
      await ref.read(currentWorkspaceIdProvider.notifier).setWorkspace(workspace.id);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Workspace "${workspace.name}" created successfully!'),
          backgroundColor: AppColors.success,
        ),
      );

      // Navigate back
      context.pop();
    } on AppFailure catch (e) {
      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _isLoading = false;
        _errorMessage = FailureMessages.getMessage(context, e);
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to create workspace. Please try again.';
      });
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/planpal_button.dart';
import '../../../core/widgets/planpal_text_field.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../providers/workspace_providers.dart';

/// Workspace settings screen
/// 
/// Features:
/// - Edit workspace name and description
/// - View workspace type (read-only)
/// - View creation date
/// - Delete workspace option (admin only, team workspaces)
/// - Permission guards for all actions
class WorkspaceSettingsScreen extends ConsumerStatefulWidget {
  final String workspaceId;

  const WorkspaceSettingsScreen({
    super.key,
    required this.workspaceId,
  });

  @override
  ConsumerState<WorkspaceSettingsScreen> createState() =>
      _WorkspaceSettingsScreenState();
}

class _WorkspaceSettingsScreenState
    extends ConsumerState<WorkspaceSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.validationNameRequired;
    }
    if (value.trim().length < 3) {
      return context.l10n.workspaceNameTooShort;
    }
    if (value.trim().length > 50) {
      return context.l10n.workspaceNameTooLong;
    }
    return null;
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();

      await ref.read(workspaceRepositoryProvider).updateWorkspace(
            widget.workspaceId,
            name: name,
            description: description.isEmpty ? null : description,
          );

      // Refresh workspace data
      ref.invalidate(workspaceProvider(widget.workspaceId));
      ref.invalidate(workspaceListProvider);

      if (!mounted) return;

      AppSnackbar.showSuccess(
        context,
        context.l10n.workspaceUpdated,
      );

      setState(() => _hasChanges = false);
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(
        context,
        context.l10n.workspaceUpdateError,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteWorkspace() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.workspaceDeleteConfirmTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.workspaceDeleteConfirmMessage),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: AppColors.error),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      context.l10n.workspaceDeleteWarning,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(workspaceRepositoryProvider).deleteWorkspace(
            widget.workspaceId,
          );

      // Refresh workspace list and current workspace
      ref.invalidate(workspaceListProvider);
      ref.invalidate(currentWorkspaceProvider);

      if (!mounted) return;

      AppSnackbar.showSuccess(
        context,
        context.l10n.workspaceDeleted,
      );

      // Navigate back to home
      context.go('/home');
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(
        context,
        context.l10n.workspaceDeleteError,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final workspaceAsync = ref.watch(workspaceProvider(widget.workspaceId));
    final permissionsAsync = ref.watch(currentWorkspacePermissionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.workspaceSettings),
        centerTitle: true,
        actions: [
          if (_hasChanges && !_isLoading)
            TextButton(
              onPressed: _saveChanges,
              child: Text(context.l10n.save),
            ),
        ],
      ),
      body: workspaceAsync.when(
        data: (workspace) {
          if (workspace == null) {
            return Center(
              child: Text(context.l10n.workspaceNotFound),
            );
          }

          // Initialize controllers with workspace data
          if (_nameController.text.isEmpty) {
            _nameController.text = workspace.name;
            _nameController.addListener(_onFieldChanged);
            _descriptionController.addListener(_onFieldChanged);
          }

          final permissions = permissionsAsync.value;
          final canEdit = permissions?.canEditWorkspaceSettings ?? false;
          final canDelete = permissions?.canDeleteWorkspace ?? false;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Workspace name
                  PlanPalTextField(
                    label: context.l10n.workspaceName,
                    controller: _nameController,
                    enabled: canEdit && !_isLoading,
                    prefixIcon: const Icon(Icons.workspaces),
                  ),

                  const SizedBox(height: 16),

                  // Workspace description
                  PlanPalTextField(
                    label: context.l10n.workspaceDescription,
                    controller: _descriptionController,
                    hint: context.l10n.workspaceDescriptionHint,
                    enabled: canEdit && !_isLoading,
                    maxLines: 3,
                    prefixIcon: const Icon(Icons.description),
                  ),

                  const SizedBox(height: 24),

                  // Workspace type (read-only)
                  _InfoCard(
                    icon: Icons.category,
                    label: context.l10n.workspaceType,
                    value: workspace.type == 'personal'
                        ? context.l10n.workspaceTypePersonal
                        : context.l10n.workspaceTypeTeam,
                  ),

                  const SizedBox(height: 12),

                  // Creation date
                  _InfoCard(
                    icon: Icons.calendar_today,
                    label: context.l10n.createdAt,
                    value: _formatDate(workspace.createdAt),
                  ),

                  if (!canEdit) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info, color: AppColors.warning),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              context.l10n.adminOnlySettings,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.warning,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (canDelete) ...[
                    const SizedBox(height: 32),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Danger zone
                    Text(
                      context.l10n.dangerZone,
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.error,
                      ),
                    ),

                    const SizedBox(height: 16),

                    PlanPalButton(
                      text: context.l10n.deleteWorkspace,
                      type: ButtonType.danger,
                      icon: Icons.delete_forever,
                      onPressed: _isLoading ? null : _deleteWorkspace,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                context.l10n.errorLoadingWorkspace,
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 16),
              PlanPalButton(
                text: 'Retry',
                type: ButtonType.secondary,
                onPressed: () {
                  ref.invalidate(workspaceProvider(widget.workspaceId));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Info card widget for read-only workspace information
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

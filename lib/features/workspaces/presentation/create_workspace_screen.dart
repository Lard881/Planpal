// app/lib/features/workspaces/presentation/create_workspace_screen.dart
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
import '../data/workspace_repository.dart';
import '../providers/workspace_providers.dart';

class CreateWorkspaceScreen extends ConsumerStatefulWidget {
  const CreateWorkspaceScreen({super.key});
  @override
  ConsumerState<CreateWorkspaceScreen> createState() => _CreateWorkspaceScreenState();
}

class _CreateWorkspaceScreenState extends ConsumerState<CreateWorkspaceScreen> {
  final _nameCtrl = TextEditingController();
  String? _nameError;
  bool _loading = false;
  String? _error;

  @override
  void dispose() { _nameCtrl.dispose(); super.dispose(); }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = 'Workspace name is required.');
      return;
    }
    setState(() { _loading = true; _error = null; });
    final (workspace, failure) = await ref.read(workspaceRepositoryProvider).createWorkspace(name);
    if (!mounted) return;
    setState(() => _loading = false);
    if (failure != null) {
      setState(() => _error = failure.message);
      return;
    }
    if (workspace != null) {
      await ref.read(currentWorkspaceIdProvider.notifier).set(workspace.id);
      ref.invalidate(workspacesProvider);
      if (mounted) context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isDesktop = context.isDesktopLayout;

    Widget form = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_error != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: c.dangerSoft,
              borderRadius: BorderRadius.circular(AppRadius.control),
            ),
            child: Text(_error!, style: AppText.body.copyWith(color: c.danger)),
          ),
          const SizedBox(height: 16),
        ],
        PlanPalTextField(
          label: 'Workspace name',
          hint: 'My Team',
          controller: _nameCtrl,
          errorText: _nameError,
          textInputAction: TextInputAction.done,
          onEditingComplete: _submit,
          onChanged: (_) => setState(() => _nameError = null),
        ),
        const SizedBox(height: 20),
        PlanPalButton(
          label: 'Create',
          onPressed: _submit,
          loading: _loading,
          width: double.infinity,
        ),
        if (isDesktop) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: c.surfaceAlt,
              borderRadius: BorderRadius.circular(AppRadius.control),
            ),
            child: Row(
              children: [
                Icon(LucideIcons.info, size: 16, color: c.textMuted),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tip: you can invite teammates right after creating it.',
                    style: AppText.caption.copyWith(color: c.textMuted),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );

    if (isDesktop) {
      return Scaffold(
        backgroundColor: c.background,
        body: Center(
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(AppRadius.panel),
              border: Border.all(color: c.border),
              boxShadow: AppShadows.card(Brightness.light),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Create workspace',
                  style: AppText.pageTitle.copyWith(color: c.textPrimary)),
                const SizedBox(height: 8),
                Text('Give your new space a friendly name.',
                  style: AppText.body.copyWith(color: c.textMuted)),
                const SizedBox(height: 24),
                form,
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button — 36x36 white square, radius 12, arrow-left
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(AppRadius.control),
                    border: Border.all(color: c.border),
                  ),
                  child: Icon(LucideIcons.arrowLeft, size: 18, color: c.textPrimary),
                ),
              ),
              const SizedBox(height: 24),
              Text('Create workspace',
                style: AppText.pageTitle.copyWith(color: c.textPrimary)),
              const SizedBox(height: 24),
              form,
            ],
          ),
        ),
      ),
    );
  }
}

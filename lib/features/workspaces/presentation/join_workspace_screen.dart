// app/lib/features/workspaces/presentation/join_workspace_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/widgets/planpal_button.dart';
import '../data/workspace_repository.dart';
import '../providers/workspace_providers.dart';

// Allowed characters per F13 — no I, O, 0, 1
const _allowedChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

class JoinWorkspaceScreen extends ConsumerStatefulWidget {
  const JoinWorkspaceScreen({super.key});
  @override
  ConsumerState<JoinWorkspaceScreen> createState() => _JoinWorkspaceScreenState();
}

class _JoinWorkspaceScreenState extends ConsumerState<JoinWorkspaceScreen> {
  final _controllers = List.generate(8, (_) => TextEditingController());
  final _focusNodes = List.generate(8, (_) => FocusNode());
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _onChanged(int index, String value) {
    // Auto-uppercase and filter to allowed chars
    final filtered = value.toUpperCase().split('')
        .where((c) => _allowedChars.contains(c)).join();

    if (filtered.length > 1) {
      // Paste handling
      for (int i = 0; i < 8 && i < filtered.length; i++) {
        _controllers[i].text = filtered[i];
      }
      final next = filtered.length.clamp(0, 7);
      _focusNodes[next].requestFocus();
    } else if (filtered.length == 1) {
      _controllers[index].text = filtered;
      if (index < 7) _focusNodes[index + 1].requestFocus();
    }
    setState(() {});
  }

  void _onKeyDown(int index, RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
      setState(() {});
    }
  }

  Future<void> _submit() async {
    if (_code.length < 8) return;
    setState(() { _loading = true; _error = null; });
    final (workspace, failure) = await ref.read(workspaceRepositoryProvider).joinWithCode(_code);
    if (!mounted) return;
    setState(() => _loading = false);
    if (failure != null) {
      setState(() => _error = _mapJoinError(failure.message));
      return;
    }
    if (workspace != null) {
      await ref.read(currentWorkspaceIdProvider.notifier).set(workspace.id);
      ref.invalidate(workspacesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Joined ${workspace.name}!')),
        );
        context.go('/home');
      }
    }
  }

  String _mapJoinError(String msg) {
    final lower = msg.toLowerCase();
    if (lower.contains('invalid_code') || lower.contains('not found')) {
      return 'This code is not valid. Check it and try again.';
    }
    if (lower.contains('code_expired') || lower.contains('expired')) {
      return 'This invite code has expired.';
    }
    if (lower.contains('code_revoked') || lower.contains('revoked')) {
      return 'This invite code has been revoked.';
    }
    if (lower.contains('code_used_up') || lower.contains('max uses')) {
      return 'This invite code has reached its maximum uses.';
    }
    if (lower.contains('already_member') || lower.contains('already a member')) {
      return 'You are already a member of this workspace.';
    }
    if (lower.contains('rate_limited') || lower.contains('rate limit')) {
      return 'Too many attempts. Please wait before trying again.';
    }
    return msg;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isDesktop = context.isDesktopLayout;
    final codeComplete = _code.length == 8;

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Join with code',
          style: (isDesktop ? AppText.pageTitle : AppText.pageTitle)
              .copyWith(color: c.textPrimary),
          textAlign: isDesktop ? TextAlign.left : TextAlign.left,
        ),
        const SizedBox(height: 8),
        Text(
          isDesktop
              ? 'Ask your teammate for the 8-character invite code.'
              : 'Enter the 8-character code from your teammate.',
          style: AppText.body.copyWith(color: c.textMuted),
        ),
        const SizedBox(height: 24),
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
        // 8-box code input
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(8, (i) {
            final filled = _controllers[i].text.isNotEmpty;
            return SizedBox(
              width: 36, height: 48,
              child: RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (e) => _onKeyDown(i, e),
                child: TextField(
                  controller: _controllers[i],
                  focusNode: _focusNodes[i],
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(8),
                    FilteringTextInputFormatter.allow(RegExp('[A-Za-z2-9]')),
                  ],
                  onChanged: (v) => _onChanged(i, v),
                  style: AppText.bodyStrong.copyWith(
                    color: c.textPrimary, fontSize: 18),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: filled ? c.primarySoft : c.surfaceAlt,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.control),
                      borderSide: BorderSide(
                        color: filled ? c.primary : Colors.transparent,
                        width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.control),
                      borderSide: BorderSide(
                        color: filled ? c.primary : Colors.transparent,
                        width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.control),
                      borderSide: BorderSide(color: c.primary, width: 1.5)),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),
        PlanPalButton(
          label: 'Join',
          onPressed: codeComplete ? _submit : null,
          loading: _loading,
          width: double.infinity,
        ),
      ],
    );

    if (isDesktop) {
      return Scaffold(
        backgroundColor: c.background,
        body: Center(
          child: Container(
            width: 440,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(AppRadius.panel),
              border: Border.all(color: c.border),
              boxShadow: AppShadows.card(Brightness.light),
            ),
            child: content,
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
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(AppRadius.control),
                    border: Border.all(color: c.border),
                  ),
                  child: Icon(LucideIcons.arrowLeft,
                    size: 18, color: c.textPrimary),
                ),
              ),
              const SizedBox(height: 24),
              content,
            ],
          ),
        ),
      ),
    );
  }
}

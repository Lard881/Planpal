// app/lib/core/widgets/empty_state.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'planpal_button.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: c.textMuted),
            const SizedBox(height: 16),
            Text(title,
              style: AppText.cardTitle.copyWith(color: c.textPrimary),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(subtitle!,
                style: AppText.body.copyWith(color: c.textMuted),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              PlanPalButton(label: actionLabel!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  final String message;
  final String? code;
  final String? requestId;
  final VoidCallback? onRetry;

  const ErrorState({
    super.key,
    required this.message,
    this.code,
    this.requestId,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: c.danger),
            const SizedBox(height: 16),
            Text(message,
              style: AppText.cardTitle.copyWith(color: c.textPrimary),
              textAlign: TextAlign.center,
            ),
            if (code != null || requestId != null) ...[
              const SizedBox(height: 8),
              Text(
                [if (code != null) 'Code: $code',
                 if (requestId != null) 'ID: $requestId'].join(' · '),
                style: AppText.caption.copyWith(color: c.textMuted),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              PlanPalButton(
                label: 'Try again',
                onPressed: onRetry,
                variant: PlanPalButtonVariant.outline,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class LoadingSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const LoadingSkeleton({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: c.surfaceAlt,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class ConnectivityBanner extends StatelessWidget {
  final ConnectivityState state;
  const ConnectivityBanner({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Color bg;
    Color fg;
    String msg;
    if (state == ConnectivityState.offline) {
      bg = c.warningSoft;
      fg = c.warningText;
      msg = "You're offline. Your changes are saved on this device and will sync when you're back online.";
    } else if (state == ConnectivityState.serverUnreachable) {
      bg = c.dangerSoft; fg = c.danger;
      msg = "Can't reach the server. Check your connection.";
    } else if (state == ConnectivityState.wakingUp) {
      bg = c.primarySoft; fg = c.primary;
      msg = 'Waking up the server, this can take up to a minute.';
    } else if (state == ConnectivityState.backOnline) {
      bg = c.successSoft; fg = c.success;
      msg = 'Back online. Syncing...';
    } else {
      bg = c.surface; fg = c.textPrimary; msg = '';
    }

    if (state == ConnectivityState.online) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: bg,
      child: Text(msg,
        style: AppText.caption.copyWith(color: fg),
        textAlign: TextAlign.center,
      ),
    );
  }
}

enum ConnectivityState { online, offline, serverUnreachable, wakingUp, backOnline }

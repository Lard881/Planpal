// app/lib/core/widgets/empty_state.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../network/failure_localizer.dart';
import 'planpal_button.dart';

enum LoadingSkeletonKind {
  rows,
  table,
  cards,
  detail,
  dashboard,
  conversation,
  calendar,
}

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
            Text(
              title,
              style: AppText.cardTitle.copyWith(color: c.textPrimary),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
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
  final String? retryLabel;
  final VoidCallback? onRetry;

  const ErrorState({
    super.key,
    required this.message,
    this.code,
    this.requestId,
    this.retryLabel,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: c.danger),
            const SizedBox(height: 16),
            Text(
              localizeFailureText(l10n, message),
              style: AppText.cardTitle.copyWith(color: c.textPrimary),
              textAlign: TextAlign.center,
            ),
            if (code != null || requestId != null) ...[
              const SizedBox(height: 8),
              Text(
                [
                  if (code != null) 'Code: $code',
                  if (requestId != null) 'ID: $requestId',
                ].join(' · '),
                style: AppText.caption.copyWith(color: c.textMuted),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              PlanPalButton(
                label: retryLabel ?? l10n.btnRetry,
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

class ContentLoadingSkeleton extends StatelessWidget {
  final LoadingSkeletonKind kind;
  final int itemCount;
  final EdgeInsetsGeometry padding;

  const ContentLoadingSkeleton({
    super.key,
    required this.kind,
    this.itemCount = 6,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding,
      child: switch (kind) {
        LoadingSkeletonKind.rows => _rows(context),
        LoadingSkeletonKind.table => _table(context),
        LoadingSkeletonKind.cards => _cards(context),
        LoadingSkeletonKind.detail => _detail(context),
        LoadingSkeletonKind.dashboard => _dashboard(context),
        LoadingSkeletonKind.conversation => _conversation(context),
        LoadingSkeletonKind.calendar => _calendar(context),
      },
    );
  }

  Widget _rows(BuildContext context) => Column(
    children: [
      for (var index = 0; index < itemCount; index++) ...[
        if (index > 0) const SizedBox(height: 12),
        _SkeletonSurface(
          child: Row(
            children: [
              const _SkeletonBlock(width: 40, height: 40, radius: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonBlock(width: index.isEven ? 190 : 140, height: 14),
                    const SizedBox(height: 8),
                    _SkeletonBlock(width: index.isEven ? 128 : 170, height: 12),
                  ],
                ),
              ),
              const _SkeletonBlock(width: 64, height: 22, radius: 12),
            ],
          ),
        ),
      ],
    ],
  );

  Widget _table(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: c.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              children: [
                const SizedBox(width: 36),
                for (final flex in const [5, 2, 2, 1, 2])
                  Expanded(
                    flex: flex,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: _SkeletonBlock(height: 12),
                    ),
                  ),
              ],
            ),
          ),
          Divider(height: 1, color: c.border),
          for (var index = 0; index < itemCount; index++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const _SkeletonBlock(width: 22, height: 22, radius: 11),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 5,
                    child: _SkeletonBlock(
                      height: 16,
                      width: index.isEven ? 230 : 170,
                    ),
                  ),
                  const Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        _SkeletonBlock(width: 30, height: 30, radius: 15),
                        SizedBox(width: 8),
                        Expanded(child: _SkeletonBlock(height: 14)),
                      ],
                    ),
                  ),
                  const Expanded(flex: 2, child: _SkeletonBlock(height: 14)),
                  const Expanded(
                    flex: 1,
                    child: _SkeletonBlock(width: 52, height: 22, radius: 12),
                  ),
                  const Expanded(
                    flex: 2,
                    child: _SkeletonBlock(width: 78, height: 22, radius: 12),
                  ),
                ],
              ),
            ),
            if (index < itemCount - 1) Divider(height: 1, color: c.border),
          ],
        ],
      ),
    );
  }

  Widget _cards(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth >= 900
          ? 3
          : constraints.maxWidth >= 600
          ? 2
          : 1;
      final cardWidth = (constraints.maxWidth - ((columns - 1) * 12)) / columns;
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (var index = 0; index < itemCount; index++)
            SizedBox(
              width: cardWidth,
              child: _SkeletonSurface(
                height: 112,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const _SkeletonBlock(width: 40, height: 40, radius: 10),
                    _SkeletonBlock(width: index.isEven ? 150 : 110, height: 14),
                    const _SkeletonBlock(width: 80, height: 11),
                  ],
                ),
              ),
            ),
        ],
      );
    },
  );

  Widget _detail(BuildContext context) => Column(
    children: [
      _SkeletonSurface(
        height: 174,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Row(
              children: [
                _SkeletonBlock(width: 60, height: 24, radius: 12),
                SizedBox(width: 8),
                _SkeletonBlock(width: 86, height: 24, radius: 12),
              ],
            ),
            _SkeletonBlock(width: 340, height: 30),
            _SkeletonBlock(width: 188, height: 14),
          ],
        ),
      ),
      const SizedBox(height: 16),
      LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 700) {
            return Column(
              children: [
                for (var index = 0; index < 4; index++) ...[
                  if (index > 0) const SizedBox(height: 12),
                  const _DetailSectionSkeleton(),
                ],
              ],
            );
          }
          return const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _DetailSectionSkeleton(),
                    SizedBox(height: 12),
                    _DetailSectionSkeleton(height: 250),
                    SizedBox(height: 12),
                    _DetailSectionSkeleton(height: 170),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _DetailSectionSkeleton(height: 190),
                    SizedBox(height: 12),
                    _DetailSectionSkeleton(height: 250),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    ],
  );

  Widget _dashboard(BuildContext context) => Column(
    children: [
      LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 700 ? 4 : 2;
          final width = (constraints.maxWidth - (12 * (columns - 1))) / columns;
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (var index = 0; index < 4; index++)
                SizedBox(
                  width: width,
                  child: const _SkeletonSurface(
                    height: 106,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _SkeletonBlock(width: 80, height: 12),
                        _SkeletonBlock(width: 54, height: 25),
                        _SkeletonBlock(width: 120, height: 10),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      const SizedBox(height: 16),
      const _SkeletonSurface(
        height: 260,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SkeletonBlock(width: 150, height: 16),
            SizedBox(height: 24),
            Expanded(child: _SkeletonBlock(height: double.infinity)),
          ],
        ),
      ),
      const SizedBox(height: 16),
      _rows(context),
    ],
  );

  Widget _conversation(BuildContext context) => Column(
    children: [
      for (var index = 0; index < itemCount; index++)
        Align(
          alignment: index.isEven
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _SkeletonSurface(
              width: 280,
              height: index % 3 == 0 ? 68 : 48,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SkeletonBlock(width: 82, height: 11),
                  _SkeletonBlock(width: 210, height: 13),
                ],
              ),
            ),
          ),
        ),
    ],
  );

  Widget _calendar(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 3,
        child: _SkeletonSurface(
          height: 430,
          child: Column(
            children: [
              const Row(
                children: [
                  _SkeletonBlock(width: 150, height: 18),
                  Spacer(),
                  _SkeletonBlock(width: 96, height: 28),
                ],
              ),
              const SizedBox(height: 22),
              for (var week = 0; week < 6; week++) ...[
                Expanded(
                  child: Row(
                    children: [
                      for (var day = 0; day < 7; day++)
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: _SkeletonBlock(height: 38, radius: 8),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      const SizedBox(width: 16),
      const Expanded(
        flex: 2,
        child: Column(
          children: [
            _DetailSectionSkeleton(height: 210),
            SizedBox(height: 12),
            _DetailSectionSkeleton(height: 180),
          ],
        ),
      ),
    ],
  );
}

class _DetailSectionSkeleton extends StatelessWidget {
  final double height;
  const _DetailSectionSkeleton({this.height = 140});

  @override
  Widget build(BuildContext context) => _SkeletonSurface(
    height: height,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        _SkeletonBlock(width: 118, height: 16),
        _SkeletonBlock(height: 12),
        _SkeletonBlock(width: 190, height: 12),
      ],
    ),
  );
}

class _SkeletonSurface extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;

  const _SkeletonSurface({required this.child, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: c.border),
      ),
      child: child,
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _SkeletonBlock({
    this.width = double.infinity,
    required this.height,
    this.radius = 6,
  });

  @override
  Widget build(BuildContext context) =>
      LoadingSkeleton(width: width, height: height, radius: radius);
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
    final l10n = AppLocalizations.of(context);
    if (state == ConnectivityState.offline) {
      bg = c.warningSoft;
      fg = c.warningText;
      msg = l10n.bannerOffline;
    } else if (state == ConnectivityState.serverUnreachable) {
      bg = c.dangerSoft;
      fg = c.danger;
      msg = l10n.bannerServerUnreachable;
    } else if (state == ConnectivityState.wakingUp) {
      bg = c.primarySoft;
      fg = c.primary;
      msg = l10n.bannerWakingUp;
    } else if (state == ConnectivityState.backOnline) {
      bg = c.successSoft;
      fg = c.success;
      msg = l10n.bannerBackOnline;
    } else {
      bg = c.surface;
      fg = c.textPrimary;
      msg = '';
    }

    if (state == ConnectivityState.online) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: bg,
      child: Text(
        msg,
        style: AppText.caption.copyWith(color: fg),
        textAlign: TextAlign.center,
      ),
    );
  }
}

enum ConnectivityState {
  online,
  offline,
  serverUnreachable,
  wakingUp,
  backOnline,
}

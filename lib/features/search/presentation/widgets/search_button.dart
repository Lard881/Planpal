import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import '../../../../core/theme/app_colors.dart';
import '../screens/search_screen_mobile.dart';
import 'search_dialog.dart';

/// Search button for app bars
/// - Mobile: navigates to full-screen search page
/// - Desktop: opens search dialog
class SearchButton extends StatelessWidget {
  final bool isDesktop;

  const SearchButton({
    super.key,
    this.isDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return _DesktopSearchButton();
    }

    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SearchScreenMobile()),
        );
      },
      tooltip: 'Search',
    );
  }
}

/// Desktop search button with hint text and keyboard shortcut
class _DesktopSearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMac = defaultTargetPlatform == TargetPlatform.macOS;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: () => SearchDialog.show(context),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 250,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.border,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                size: 18,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Search...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: AppColors.border,
                    width: 1,
                  ),
                ),
                child: Text(
                  isMac ? '⌘K' : 'Ctrl+K',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

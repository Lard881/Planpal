import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../providers/search_providers.dart';

/// Workspace scope toggle widget
/// Allows switching between searching current workspace only or all workspaces
class WorkspaceScopeToggle extends ConsumerWidget {
  const WorkspaceScopeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(searchFilterProvider);
    final isAllWorkspaces = filter.workspaceId == null;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ScopeOption(
              label: 'This Workspace',
              icon: Icons.folder,
              isSelected: !isAllWorkspaces,
              onTap: () => _setCurrentWorkspace(ref),
            ),
          ),
          Expanded(
            child: _ScopeOption(
              label: 'All Workspaces',
              icon: Icons.folder_open,
              isSelected: isAllWorkspaces,
              onTap: () => _setAllWorkspaces(ref),
            ),
          ),
        ],
      ),
    );
  }

  void _setCurrentWorkspace(WidgetRef ref) {
    final currentWorkspaceId = ref.read(currentWorkspaceIdProvider);
    if (currentWorkspaceId != null) {
      final currentFilter = ref.read(searchFilterProvider);
      ref.read(searchFilterProvider.notifier).state = currentFilter.copyWith(
        workspaceId: currentWorkspaceId,
      );
    }
  }

  void _setAllWorkspaces(WidgetRef ref) {
    final currentFilter = ref.read(searchFilterProvider);
    ref.read(searchFilterProvider.notifier).state = currentFilter.copyWith(
      workspaceId: null,
    );
  }
}

/// Individual scope option button
class _ScopeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ScopeOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

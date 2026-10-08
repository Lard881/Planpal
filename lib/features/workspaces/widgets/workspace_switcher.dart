import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/layout/breakpoints.dart';
import '../providers/workspace_providers.dart';
import '../../../core/db/app_database.dart';

/// Workspace switcher
/// Shows current workspace with dropdown to switch
/// Desktop: Top of sidebar
/// Mobile: Home header
class WorkspaceSwitcher extends ConsumerWidget {
  const WorkspaceSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakpoint = Breakpoints.getBreakpoint(context);
    final isMobile = breakpoint == BreakpointType.mobile;
    
    final currentWorkspaceAsync = ref.watch(currentWorkspaceProvider);
    final workspacesAsync = ref.watch(workspacesStreamProvider);
    final personalWorkspaceId = ref.watch(personalWorkspaceIdProvider);

    return currentWorkspaceAsync.when(
      data: (currentWorkspace) {
        if (currentWorkspace == null) {
          return const SizedBox.shrink();
        }

        return workspacesAsync.when(
          data: (workspaces) {
            return _buildSwitcher(
              context,
              ref,
              currentWorkspace,
              workspaces,
              personalWorkspaceId,
              isMobile,
            );
          },
          loading: () => _buildLoading(isMobile),
          error: (_, __) => _buildError(isMobile),
        );
      },
      loading: () => _buildLoading(isMobile),
      error: (_, __) => _buildError(isMobile),
    );
  }

  Widget _buildSwitcher(
    BuildContext context,
    WidgetRef ref,
    Workspace currentWorkspace,
    List<Workspace> workspaces,
    String? personalWorkspaceId,
    bool isMobile,
  ) {
    return PopupMenuButton<String>(
      offset: Offset(0, isMobile ? 56 : 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: _buildButton(currentWorkspace, isMobile),
      itemBuilder: (context) {
        return [
          // Workspaces section
          ...workspaces.map((workspace) {
            final isPersonal = workspace.id == personalWorkspaceId;
            final isCurrent = workspace.id == currentWorkspace.id;
            
            return PopupMenuItem<String>(
              value: workspace.id,
              child: Row(
                children: [
                  // Icon
                  Icon(
                    isPersonal ? Icons.person : Icons.group,
                    size: 20,
                    color: isCurrent ? AppColors.primary : AppColors.grey600,
                  ),
                  const SizedBox(width: 12),
                  
                  // Name
                  Expanded(
                    child: Text(
                      workspace.name,
                      style: TextStyle(
                        color: isCurrent ? AppColors.primary : AppColors.grey900,
                        fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                  
                  // Check mark for current
                  if (isCurrent) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.check,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ],
                ],
              ),
            );
          }),
          
          // Divider
          const PopupMenuDivider(),
          
          // Create workspace
          PopupMenuItem<String>(
            value: 'create',
            child: Row(
              children: [
                Icon(Icons.add, size: 20, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  'Create Workspace',
                  style: TextStyle(color: AppColors.primary),
                ),
              ],
            ),
          ),
          
          // Join workspace
          PopupMenuItem<String>(
            value: 'join',
            child: Row(
              children: [
                Icon(Icons.group_add, size: 20, color: AppColors.success),
                const SizedBox(width: 12),
                Text(
                  'Join with Code',
                  style: TextStyle(color: AppColors.success),
                ),
              ],
            ),
          ),
        ];
      },
      onSelected: (value) {
        if (value == 'create') {
          context.push('/workspace/create');
        } else if (value == 'join') {
          context.push('/workspace/join');
        } else {
          // Switch workspace
          ref.read(currentWorkspaceIdProvider.notifier).setWorkspace(value);
        }
      },
    );
  }

  Widget _buildButton(Workspace workspace, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 8 : 12,
      ),
      decoration: BoxDecoration(
        color: isMobile ? Colors.transparent : AppColors.grey800.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isMobile ? AppColors.grey300 : AppColors.grey700,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Workspace name
          Flexible(
            child: Text(
              workspace.name,
              style: TextStyle(
                color: isMobile ? AppColors.grey900 : AppColors.white,
                fontSize: isMobile ? 16 : 14,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          
          // Dropdown icon
          Icon(
            Icons.keyboard_arrow_down,
            size: 20,
            color: isMobile ? AppColors.grey600 : AppColors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildLoading(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 8 : 12,
      ),
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(
            isMobile ? AppColors.primary : AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildError(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 8 : 12,
      ),
      child: Icon(
        Icons.error_outline,
        size: 20,
        color: isMobile ? AppColors.error : AppColors.white,
      ),
    );
  }
}

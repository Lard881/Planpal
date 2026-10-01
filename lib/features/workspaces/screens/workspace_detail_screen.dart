import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workspace.dart';
import '../models/invite_code.dart';
import '../providers/workspace_providers.dart';
import '../../../core/providers/app_providers.dart';

/// Screen showing workspace details, members, and invite codes
class WorkspaceDetailScreen extends ConsumerStatefulWidget {
  final Workspace workspace;

  const WorkspaceDetailScreen({
    super.key,
    required this.workspace,
  });

  @override
  ConsumerState<WorkspaceDetailScreen> createState() =>
      _WorkspaceDetailScreenState();
}

class _WorkspaceDetailScreenState
    extends ConsumerState<WorkspaceDetailScreen> {
  int _selectedTab = 0;
  bool _isPersonal = false;

  @override
  void initState() {
    super.initState();
    _isPersonal = widget.workspace.type == 'personal';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workspace.name),
        actions: [
          if (!_isPersonal)
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'rename',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Rename'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'leave',
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8),
                      Text('Leave Workspace'),
                    ],
                  ),
                ),
                if (widget.workspace.role == 'owner')
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete Workspace', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
              ],
              onSelected: (value) => _handleMenuAction(value as String),
            ),
        ],
      ),
      body: _isPersonal
          ? _buildPersonalWorkspaceMessage()
          : Column(
              children: [
                // Tab bar
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildTab('Members', 0),
                      _buildTab('Invites', 1),
                    ],
                  ),
                ),
                // Tab content
                Expanded(
                  child: _selectedTab == 0
                      ? _buildMembersTab()
                      : _buildInvitesTab(),
                ),
              ],
            ),
    );
  }

  Widget _buildPersonalWorkspaceMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Personal Workspace',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              'This is your personal workspace. Tasks and projects here are private and only visible to you.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.workspaces_outlined,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Want to collaborate?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Create a team workspace to share tasks and projects with others',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMembersTab() {
    final membersAsync =
        ref.watch(workspaceMembersProvider(widget.workspace.id));
    final currentUserId = ref.watch(currentUserIdProvider);

    return membersAsync.when(
      data: (members) {
        if (members.isEmpty) {
          return const Center(child: Text('No members'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: members.length,
          itemBuilder: (context, index) {
            final member = members[index];
            final isCurrentUser = member.userId == currentUserId;
            final canRemove = widget.workspace.role == 'owner' &&
                !isCurrentUser &&
                member.role != 'owner';

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(
                    member.userEmail[0].toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(child: Text(member.userEmail)),
                    if (isCurrentUser)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'You',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                  ],
                ),
                subtitle: Text(_getRoleLabel(member.role)),
                trailing: canRemove
                    ? IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        color: Colors.red,
                        onPressed: () => _removeMember(member.userId),
                      )
                    : null,
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Failed to load members: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  ref.invalidate(workspaceMembersProvider(widget.workspace.id)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvitesTab() {
    final invitesAsync =
        ref.watch(workspaceInviteCodesProvider(widget.workspace.id));
    final canManageInvites = widget.workspace.role == 'owner' ||
        widget.workspace.role == 'admin';

    return invitesAsync.when(
      data: (invites) {
        return Column(
          children: [
            if (canManageInvites)
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: _createInviteCode,
                  icon: const Icon(Icons.add),
                  label: const Text('Create Invite Code'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ),
            Expanded(
              child: invites.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.link_off,
                            size: 64,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No active invite codes',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (canManageInvites) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Create one to invite team members',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.6),
                                  ),
                            ),
                          ],
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: invites.length,
                      itemBuilder: (context, index) {
                        final invite = invites[index];
                        final isExpired = invite.expiresAt != null &&
                            invite.expiresAt!.isBefore(DateTime.now());
                        final isMaxed = invite.maxUses != null &&
                            invite.usedCount >= invite.maxUses!;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Icon(
                              isExpired || isMaxed
                                  ? Icons.link_off
                                  : Icons.link,
                              color: isExpired || isMaxed
                                  ? Colors.grey
                                  : Theme.of(context).colorScheme.primary,
                            ),
                            title: Row(
                              children: [
                                Text(
                                  invite.code,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.copy, size: 18),
                                  onPressed: () => _copyCode(invite.code),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                            subtitle: Text(_getInviteStatus(invite)),
                            trailing: canManageInvites
                                ? IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    color: Colors.red,
                                    onPressed: () => _revokeInviteCode(invite.id),
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Failed to load invites: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref
                  .invalidate(workspaceInviteCodesProvider(widget.workspace.id)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  String _getRoleLabel(String role) {
    switch (role) {
      case 'owner':
        return 'Owner';
      case 'admin':
        return 'Admin';
      case 'member':
        return 'Member';
      default:
        return role;
    }
  }

  String _getInviteStatus(InviteCode invite) {
    if (invite.expiresAt != null &&
        invite.expiresAt!.isBefore(DateTime.now())) {
      return 'Expired';
    }
    if (invite.maxUses != null && invite.usedCount >= invite.maxUses!) {
      return 'Max uses reached (${invite.usedCount}/${invite.maxUses})';
    }
    
    final parts = <String>[];
    parts.add('Used ${invite.usedCount} times');
    if (invite.maxUses != null) {
      parts.add('max ${invite.maxUses}');
    }
    if (invite.expiresAt != null) {
      final daysLeft = invite.expiresAt!.difference(DateTime.now()).inDays;
      parts.add('expires in $daysLeft days');
    }
    
    return parts.join(' • ');
  }

  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invite code copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _createInviteCode() async {
    // Show dialog to configure invite code
    await showDialog(
      context: context,
      builder: (context) => _CreateInviteDialog(
        workspaceId: widget.workspace.id,
        onCreated: () {
          ref.invalidate(workspaceInviteCodesProvider(widget.workspace.id));
        },
      ),
    );
  }

  Future<void> _removeMember(String userId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Member'),
        content: const Text(
          'Are you sure you want to remove this member from the workspace?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final removeMember = ref.read(removeMemberProvider);
      await removeMember(widget.workspace.id, userId);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Member removed')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove member: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _revokeInviteCode(String codeId) async {
    try {
      final revokeCode = ref.read(revokeInviteCodeProvider);
      await revokeCode(widget.workspace.id, codeId);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invite code revoked')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to revoke code: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleMenuAction(String action) async {
    switch (action) {
      case 'rename':
        await _renameWorkspace();
        break;
      case 'leave':
        await _leaveWorkspace();
        break;
      case 'delete':
        await _deleteWorkspace();
        break;
    }
  }

  Future<void> _renameWorkspace() async {
    final controller = TextEditingController(text: widget.workspace.name);
    
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Workspace'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Workspace Name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Rename'),
          ),
        ],
      ),
    );

    if (newName == null || newName.isEmpty || newName == widget.workspace.name) {
      return;
    }

    try {
      final updateWorkspace = ref.read(updateWorkspaceProvider);
      await updateWorkspace(widget.workspace.id, newName);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workspace renamed')),
        );
        Navigator.of(context).pop(); // Close detail screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to rename: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _leaveWorkspace() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Workspace'),
        content: Text(
          'Are you sure you want to leave "${widget.workspace.name}"? You will lose access to all shared tasks and projects.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Leave'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final leaveWorkspace = ref.read(leaveWorkspaceProvider);
      await leaveWorkspace(widget.workspace.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Left workspace')),
        );
        Navigator.of(context).pop(); // Close detail screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to leave: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteWorkspace() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Workspace'),
        content: Text(
          'Are you sure you want to delete "${widget.workspace.name}"? This action cannot be undone. All tasks and projects will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final deleteWorkspace = ref.read(deleteWorkspaceProvider);
      await deleteWorkspace(widget.workspace.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workspace deleted')),
        );
        Navigator.of(context).pop(); // Close detail screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

// Dialog for creating invite codes
class _CreateInviteDialog extends ConsumerStatefulWidget {
  final String workspaceId;
  final VoidCallback onCreated;

  const _CreateInviteDialog({
    required this.workspaceId,
    required this.onCreated,
  });

  @override
  ConsumerState<_CreateInviteDialog> createState() =>
      _CreateInviteDialogState();
}

class _CreateInviteDialogState extends ConsumerState<_CreateInviteDialog> {
  bool _hasMaxUses = false;
  bool _hasExpiry = false;
  int _maxUses = 10;
  int _expiryDays = 7;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Invite Code'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Limit uses'),
              value: _hasMaxUses,
              onChanged: (value) => setState(() => _hasMaxUses = value),
            ),
            if (_hasMaxUses)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text('Max uses:'),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: _maxUses > 1
                          ? () => setState(() => _maxUses--)
                          : null,
                    ),
                    Text('$_maxUses'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() => _maxUses++),
                    ),
                  ],
                ),
              ),
            SwitchListTile(
              title: const Text('Set expiration'),
              value: _hasExpiry,
              onChanged: (value) => setState(() => _hasExpiry = value),
            ),
            if (_hasExpiry)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text('Expires in:'),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: _expiryDays > 1
                          ? () => setState(() => _expiryDays--)
                          : null,
                    ),
                    Text('$_expiryDays days'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() => _expiryDays++),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _isLoading ? null : _createCode,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
        ),
      ],
    );
  }

  Future<void> _createCode() async {
    setState(() => _isLoading = true);

    try {
      final createCode = ref.read(createInviteCodeProvider);
      final expiresAt = _hasExpiry
          ? DateTime.now().add(Duration(days: _expiryDays))
          : null;
      
      await createCode(
        widget.workspaceId,
        _hasMaxUses ? _maxUses : null,
        expiresAt,
      );

      widget.onCreated();
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invite code created')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create code: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

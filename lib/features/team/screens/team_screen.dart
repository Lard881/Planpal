import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../workspaces/providers/workspace_providers.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../../core/l10n/app_localizations.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Team Directory Screen (S15.1-S15.5)
/// Shows workspace members in grid layout with role filters,
/// presence indicators, and latest activity panel
class TeamScreen extends ConsumerStatefulWidget {
  const TeamScreen({super.key});

  @override
  ConsumerState<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends ConsumerState<TeamScreen> {
  String _selectedRoleFilter = 'all'; // all, admin, member, guest

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    
    final workspaceId = ref.watch(currentWorkspaceIdProvider);
    final currentUser = ref.watch(currentUserProfileProvider).value;

    if (workspaceId == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.team)),
        body: Center(child: Text(l10n.noWorkspaceSelected)),
      );
    }

    final membersAsync = ref.watch(workspaceMembersProvider(workspaceId));
    final workspaceAsync = ref.watch(currentWorkspaceProvider);

    return Scaffold(
      backgroundColor: isDesktop ? const Color(0xFFF5F5F7) : null,
      appBar: AppBar(
        title: Text(l10n.team),
        actions: [
          // S15.5: Invite with code button
          if (workspaceAsync.value?.kind != 'personal')
            TextButton.icon(
              onPressed: () => _showInviteDialog(context, workspaceId),
              icon: const Icon(Icons.person_add),
              label: const Text('Invite'),
            ),
        ],
      ),
      body: membersAsync.when(
        data: (members) {
          // Filter by role
          final filteredMembers = _selectedRoleFilter == 'all'
              ? members
              : members.where((m) => m.role == _selectedRoleFilter).toList();

          return isDesktop
              ? _buildDesktopLayout(filteredMembers, currentUser?.id)
              : _buildMobileLayout(filteredMembers, currentUser?.id);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading team: $error'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(List<dynamic> members, String? currentUserId) {
    return Row(
      children: [
        // Main content - Team grid
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with role filter chips
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Team Members (${members.length})',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildRoleFilterChips(),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Member grid (S15.1)
                _buildMemberGrid(members, currentUserId),
              ],
            ),
          ),
        ),
        
        // Right sidebar - Latest Updates (S15.3)
        Container(
          width: 350,
          color: Colors.white,
          child: _buildLatestUpdatesPanel(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(List<dynamic> members, String? currentUserId) {
    return Column(
      children: [
        // Role filter chips
        Container(
          padding: const EdgeInsets.all(16),
          child: _buildRoleFilterChips(),
        ),
        
        // Member list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: members.length,
            itemBuilder: (context, index) =>
                _buildMemberCard(members[index], currentUserId, false),
          ),
        ),
      ],
    );
  }

  // S15.1: Role filter chips
  Widget _buildRoleFilterChips() {
    return Wrap(
      spacing: 8,
      children: [
        _buildFilterChip('All', 'all'),
        _buildFilterChip('Admin', 'admin'),
        _buildFilterChip('Member', 'member'),
        _buildFilterChip('Guest', 'guest'),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedRoleFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedRoleFilter = selected ? value : 'all';
        });
      },
      backgroundColor: Colors.white,
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  // S15.1: Member grid
  Widget _buildMemberGrid(List<dynamic> members, String? currentUserId) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: members.length,
      itemBuilder: (context, index) =>
          _buildMemberCard(members[index], currentUserId, true),
    );
  }

  // S15.1 & S15.2: Member card with presence indicator
  Widget _buildMemberCard(dynamic member, String? currentUserId, bool isGrid) {
    final isCurrentUser = member.userId == currentUserId;
    final userName = member.profile?.fullName ?? 'Unknown';
    final userEmail = member.profile?.email ?? '';
    final avatarUrl = member.profile?.avatarUrl;
    
    // S15.2: Presence indicator
    // TODO: Connect to Realtime presence when implemented
    final isOnline = false; // Placeholder until presence is wired

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _showMemberProfileSheet(member), // S15.4
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar with presence dot
              Stack(
                children: [
                  CircleAvatar(
                    radius: isGrid ? 40 : 24,
                    backgroundColor: AppColors.primary,
                    backgroundImage:
                        avatarUrl != null ? NetworkImage(avatarUrl) : null,
                    child: avatarUrl == null
                        ? Text(
                            userName[0].toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isGrid ? 32 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  // S15.2: Presence dot
                  if (isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: isGrid ? 16 : 12,
                        height: isGrid ? 16 : 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Name
              Text(
                userName,
                style: TextStyle(
                  fontSize: isGrid ? 16 : 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              if (isGrid) ...[
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              
              const SizedBox(height: 8),
              
              // Role badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getRoleColor(member.role).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  member.role.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _getRoleColor(member.role),
                  ),
                ),
              ),
              
              if (isCurrentUser) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'YOU',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return const Color(0xFFEF4444);
      case 'member':
        return const Color(0xFF3B82F6);
      case 'guest':
        return const Color(0xFF6B7280);
      default:
        return Colors.grey;
    }
  }

  // S15.3: Latest Updates panel
  Widget _buildLatestUpdatesPanel() {
    // TODO: Connect to real activity/audit log data
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Latest Updates',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          
          // Empty state until real data is connected
          const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No recent activity',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
                text: TextSpan(
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                  children: [
                    TextSpan(
                      text: activity['user'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: ' ${activity['action']} '),
                    TextSpan(
                      text: activity['target'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                timeago.format(activity['time'] as DateTime),
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // S15.4: Member profile sheet
  void _showMemberProfileSheet(dynamic member) {
    final currentUser = ref.read(currentUserProfileProvider).value;
    final isCurrentUser = member.userId == currentUser?.id;
    final canManage = !isCurrentUser; // Admins can manage other members

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: controller,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Profile header
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primary,
                      backgroundImage: member.profile?.avatarUrl != null
                          ? NetworkImage(member.profile!.avatarUrl!)
                          : null,
                      child: member.profile?.avatarUrl == null
                          ? Text(
                              (member.profile?.fullName ?? 'U')[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      member.profile?.fullName ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      member.profile?.email ?? '',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getRoleColor(member.role).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        member.role.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getRoleColor(member.role),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Actions
              if (!isCurrentUser) ...[
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigate to DM
                    Navigator.pushNamed(context, '/chat/dm/${member.userId}');
                  },
                  icon: const Icon(Icons.message),
                  label: const Text('Send Message'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              
              if (canManage) ...[
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showChangeRoleDialog(member);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Change Role'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _confirmRemoveMember(member);
                  },
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  label:
                      const Text('Remove from Team', style: TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // S15.5: Invite dialog
  void _showInviteDialog(BuildContext context, String workspaceId) {
    Navigator.pushNamed(context, '/workspace/$workspaceId/invite');
  }

  void _showChangeRoleDialog(dynamic member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Admin'),
              leading: Radio(value: 'admin', groupValue: member.role, onChanged: (_) {}),
            ),
            ListTile(
              title: const Text('Member'),
              leading: Radio(value: 'member', groupValue: member.role, onChanged: (_) {}),
            ),
            ListTile(
              title: const Text('Guest'),
              leading: Radio(value: 'guest', groupValue: member.role, onChanged: (_) {}),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement role change
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmRemoveMember(dynamic member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text(
          'Are you sure you want to remove ${member.profile?.fullName ?? 'this member'} from the team?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement member removal
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

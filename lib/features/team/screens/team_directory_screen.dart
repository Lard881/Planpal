import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../workspaces/repositories/workspace_repository.dart';

class TeamDirectoryScreen extends ConsumerStatefulWidget {
  const TeamDirectoryScreen({super.key});

  @override
  ConsumerState<TeamDirectoryScreen> createState() => _TeamDirectoryScreenState();
}

class _TeamDirectoryScreenState extends ConsumerState<TeamDirectoryScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(teamMembersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Directory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Navigator.pushNamed(context, '/workspaces/invite');
            },
            tooltip: 'Invite member',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search team members...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Members list
          Expanded(
            child: membersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(teamMembersProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (members) {
                if (members.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No team members',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Invite people to join your workspace',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[500],
                                  ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/workspaces/invite');
                          },
                          icon: const Icon(Icons.person_add),
                          label: const Text('Invite Team Members'),
                        ),
                      ],
                    ),
                  );
                }

                // Filter members
                final filteredMembers = members.where((member) {
                  if (_searchQuery.isEmpty) return true;
                  final query = _searchQuery.toLowerCase();
                  return member.name.toLowerCase().contains(query) ||
                      (member.email?.toLowerCase().contains(query) ?? false) ||
                      member.role.toLowerCase().contains(query);
                }).toList();

                if (filteredMembers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 64),
                        const SizedBox(height: 16),
                        Text(
                          'No members found',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  );
                }

                // Group by role
                final groupedMembers = <String, List<TeamMember>>{};
                for (final member in filteredMembers) {
                  groupedMembers.putIfAbsent(member.role, () => []);
                  groupedMembers[member.role]!.add(member);
                }

                return ListView.builder(
                  itemCount: groupedMembers.length,
                  itemBuilder: (context, index) {
                    final role = groupedMembers.keys.elementAt(index);
                    final roleMembers = groupedMembers[role]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Text(
                            '${role.toUpperCase()} (${roleMembers.length})',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        ...roleMembers.map((member) {
                          return _MemberListItem(member: member);
                        }),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberListItem extends StatelessWidget {
  final TeamMember member;

  const _MemberListItem({required this.member});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getAvatarColor(member.name),
        child: Text(
          _getInitials(member.name),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Row(
        children: [
          Text(member.name),
          if (member.isOnline) ...[
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (member.email != null) Text(member.email!),
          const SizedBox(height: 2),
          Text(
            member.isOnline ? 'Active now' : _formatLastSeen(member.lastSeen),
            style: TextStyle(
              color: member.isOnline ? Colors.green : Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
      isThreeLine: true,
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'profile',
            child: Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 12),
                Text('View Profile'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'message',
            child: Row(
              children: [
                Icon(Icons.chat),
                SizedBox(width: 12),
                Text('Send Message'),
              ],
            ),
          ),
          if (member.role != 'owner')
            const PopupMenuItem(
              value: 'remove',
              child: Row(
                children: [
                  Icon(Icons.remove_circle, color: Colors.red),
                  SizedBox(width: 12),
                  Text('Remove', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
        ],
        onSelected: (value) {
          if (value == 'profile') {
            Navigator.pushNamed(
              context,
              '/team/profile',
              arguments: member.userId,
            );
          } else if (value == 'message') {
            Navigator.pushNamed(
              context,
              '/chat/conversation',
              arguments: {
                'userId': member.userId,
                'userName': member.name,
              },
            );
          } else if (value == 'remove') {
            _showRemoveMemberDialog(context, member);
          }
        },
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/team/profile',
          arguments: member.userId,
        );
      },
    );
  }

  void _showRemoveMemberDialog(BuildContext context, TeamMember member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text('Are you sure you want to remove ${member.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${member.name} removed')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  Color _getAvatarColor(String name) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
      Colors.amber,
    ];
    return colors[name.hashCode % colors.length];
  }

  String _formatLastSeen(DateTime? lastSeen) {
    if (lastSeen == null) return 'Offline';
    
    final diff = DateTime.now().difference(lastSeen);
    if (diff.inMinutes < 5) return 'Active recently';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${lastSeen.day}/${lastSeen.month}/${lastSeen.year}';
  }
}

// Provider
final teamMembersProvider = StreamProvider<List<TeamMember>>((ref) {
  final repository = ref.watch(workspaceRepositoryProvider);
  return repository.watchTeamMembers();
});

// Placeholder model
class TeamMember {
  final int userId;
  final String name;
  final String? email;
  final String role;
  final bool isOnline;
  final DateTime? lastSeen;

  TeamMember({
    required this.userId,
    required this.name,
    this.email,
    required this.role,
    required this.isOnline,
    this.lastSeen,
  });
}

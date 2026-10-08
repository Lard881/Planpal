import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:planpal/core/theme/app_theme.dart';
import 'package:planpal/features/chat/presentation/chat_providers.dart';
import 'package:planpal/features/workspaces/presentation/workspace_providers.dart';

/// Screen to select a user to start a direct message
class NewDirectMessageScreen extends ConsumerStatefulWidget {
  final String workspaceId;

  const NewDirectMessageScreen({
    super.key,
    required this.workspaceId,
  });

  @override
  ConsumerState<NewDirectMessageScreen> createState() => _NewDirectMessageScreenState();
}

class _NewDirectMessageScreenState extends ConsumerState<NewDirectMessageScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(workspaceMembersProvider(widget.workspaceId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Direct Message'),
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search members...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value.toLowerCase());
              },
            ),
          ),

          // Members list
          Expanded(
            child: membersAsync.when(
              data: (members) {
                // Filter members by search query
                final filtered = _searchQuery.isEmpty
                    ? members
                    : members.where((m) {
                        return m.userEmail.toLowerCase().contains(_searchQuery) ||
                            (m.userFullName?.toLowerCase().contains(_searchQuery) ?? false);
                      }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_search, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No members in this workspace'
                              : 'No members found',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final member = filtered[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                        backgroundImage: member.userAvatarUrl != null
                            ? NetworkImage(member.userAvatarUrl!)
                            : null,
                        child: member.userAvatarUrl == null
                            ? Text(
                                _getInitials(member.userFullName ?? member.userEmail),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              )
                            : null,
                      ),
                      title: Text(member.userFullName ?? member.userEmail),
                      subtitle: member.userFullName != null
                          ? Text(member.userEmail)
                          : null,
                      trailing: member.role == 'admin'
                          ? Chip(
                              label: const Text(
                                'Admin',
                                style: TextStyle(fontSize: 11),
                              ),
                              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                              padding: EdgeInsets.zero,
                            )
                          : null,
                      onTap: () => _startDM(member.userId),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text('Error loading members'),
                    TextButton(
                      onPressed: () => ref.invalidate(workspaceMembersProvider(widget.workspaceId)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _startDM(String userId) async {
    try {
      final repo = ref.read(chatRepositoryProvider);
      final channelId = await repo.getOrCreateDM(
        workspaceId: widget.workspaceId,
        userId: userId,
      );

      if (mounted) {
        // Pop this screen and navigate to the conversation
        context.pop();
        context.push('/workspaces/${widget.workspaceId}/chat/$channelId');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to start conversation: $e')),
        );
      }
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }
}

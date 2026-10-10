import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:planpal/core/theme/app_theme.dart';
import 'package:planpal/features/chat/presentation/chat_providers.dart';
import 'package:planpal/features/workspaces/providers/workspace_providers.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Mobile chat screen - shows list of channels and DMs
class ChatScreenMobile extends ConsumerWidget {
  const ChatScreenMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspaceAsync = ref.watch(currentWorkspaceProvider);

    return workspaceAsync.when(
      data: (workspace) {
        if (workspace == null) {
          return const Scaffold(
            body: Center(child: Text('No workspace selected')),
          );
        }

        // Don't allow chat in personal workspaces
        if (workspace.type == 'personal') {
          return Scaffold(
            appBar: AppBar(title: const Text('Chat')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Chat is not available in personal workspaces',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Switch to a team workspace to use chat',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final channelsAsync = ref.watch(channelsProvider(workspace.id));

        return Scaffold(
          appBar: AppBar(
            title: const Text('Chat'),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_add),
                onPressed: () => context.push('/workspaces/${workspace.id}/chat/new-dm'),
                tooltip: 'New Direct Message',
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showCreateChannelDialog(context, ref, workspace.id),
                tooltip: 'New Channel',
              ),
            ],
          ),
          body: channelsAsync.when(
            data: (channels) {
              if (channels.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.forum_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No channels yet',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create a channel to start chatting',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: channels.length,
                itemBuilder: (context, index) {
                  final channel = channels[index];
                  return _ChannelTile(channel: channel, workspaceId: workspace.id);
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
                  Text('Error: $error'),
                  TextButton(
                    onPressed: () => ref.invalidate(channelsProvider(workspace.id)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }

  void _showCreateChannelDialog(BuildContext context, WidgetRef ref, String workspaceId) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    bool isPrivate = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Create Channel'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Channel Name',
                  hintText: 'e.g. general, announcements',
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Private Channel'),
                subtitle: const Text('Only invited members can see this channel'),
                value: isPrivate,
                onChanged: (value) => setState(() => isPrivate = value ?? false),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) return;

                try {
                  final repo = ref.read(chatRepositoryProvider);
                  final channelId = await repo.createChannel(
                    workspaceId: workspaceId,
                    name: name,
                    description: descriptionController.text.trim(),
                    isPrivate: isPrivate,
                  );

                  if (context.mounted) {
                    Navigator.pop(context);
                    context.push('/workspaces/$workspaceId/chat/$channelId');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to create channel: $e')),
                    );
                  }
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChannelTile extends ConsumerWidget {
  final dynamic channel; // Channel from Drift
  final String workspaceId;

  const _ChannelTile({
    required this.channel,
    required this.workspaceId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCountAsync = ref.watch(unreadCountProvider(channel.id));

    return unreadCountAsync.when(
      data: (unreadCount) => _buildTile(context, unreadCount),
      loading: () => _buildTile(context, 0),
      error: (_, __) => _buildTile(context, 0),
    );
  }

  Widget _buildTile(BuildContext context, int unreadCount) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            child: Icon(
              channel.kind == 'dm' ? Icons.person : Icons.tag,
              color: AppTheme.primaryColor,
            ),
          ),
          // Online indicator for DMs
          if (channel.kind == 'dm')
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        channel.name ?? 'Direct Message',
        style: TextStyle(
          fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: channel.description.isNotEmpty ? Text(channel.description) : null,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            timeago.format(channel.updatedAt),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          if (unreadCount > 0) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                unreadCount > 99 ? '99+' : '$unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: () {
        context.push('/workspaces/$workspaceId/chat/${channel.id}');
      },
    );
  }
}

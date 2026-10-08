import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planpal/core/theme/app_theme.dart';
import 'package:planpal/features/chat/presentation/chat_providers.dart';
import 'package:planpal/features/chat/widgets/message_composer.dart';
import 'package:planpal/features/chat/widgets/message_bubble.dart';
import 'package:planpal/features/workspaces/presentation/workspace_providers.dart';
import 'package:planpal/core/services/supabase_service.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Desktop chat screen with split view (channels on left, conversation on right)
class ChatScreenDesktop extends ConsumerStatefulWidget {
  const ChatScreenDesktop({super.key});

  @override
  ConsumerState<ChatScreenDesktop> createState() => _ChatScreenDesktopState();
}

class _ChatScreenDesktopState extends ConsumerState<ChatScreenDesktop> {
  String? _selectedChannelId;
  final ScrollController _messagesScrollController = ScrollController();

  @override
  void dispose() {
    _messagesScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 96, color: Colors.grey[400]),
                    const SizedBox(height: 24),
                    Text(
                      'Chat is not available in personal workspaces',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Switch to a team workspace to use chat features',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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

        return Row(
          children: [
            // Left: Channels list
            SizedBox(
              width: 300,
              child: _ChannelsList(
                workspaceId: workspace.id,
                selectedChannelId: _selectedChannelId,
                onChannelSelected: (channelId) {
                  setState(() => _selectedChannelId = channelId);
                  // Mark as read when selected
                  ref.read(sendMessageProvider).markAsRead(channelId);
                },
              ),
            ),

            const VerticalDivider(width: 1),

            // Right: Conversation view
            Expanded(
              child: _selectedChannelId == null
                  ? _EmptyConversationView()
                  : _ConversationView(
                      channelId: _selectedChannelId!,
                      workspaceId: workspace.id,
                      scrollController: _messagesScrollController,
                    ),
            ),
          ],
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
}

class _ChannelsList extends ConsumerWidget {
  final String workspaceId;
  final String? selectedChannelId;
  final Function(String) onChannelSelected;

  const _ChannelsList({
    required this.workspaceId,
    required this.selectedChannelId,
    required this.onChannelSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelsAsync = ref.watch(channelsProvider(workspaceId));

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              const Text(
                'Channels',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.person_add),
                onPressed: () => _showDMPicker(context, ref),
                tooltip: 'New Direct Message',
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showCreateChannelDialog(context, ref),
                tooltip: 'Create Channel',
              ),
            ],
          ),
        ),

        // Channels list
        Expanded(
          child: channelsAsync.when(
            data: (channels) {
              if (channels.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.forum_outlined, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No channels yet',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create a channel to start chatting',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: channels.length,
                itemBuilder: (context, index) {
                  final channel = channels[index];
                  final isSelected = channel.id == selectedChannelId;

                  return _ChannelTile(
                    channel: channel,
                    isSelected: isSelected,
                    onTap: () => onChannelSelected(channel.id),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(height: 8),
                    Text(
                      'Error loading channels',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextButton(
                      onPressed: () => ref.invalidate(channelsProvider(workspaceId)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDMPicker(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.read(workspaceMembersProvider(workspaceId));
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Direct Message'),
        content: SizedBox(
          width: 400,
          height: 500,
          child: membersAsync.when(
            data: (members) {
              return ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: member.userAvatarUrl != null
                          ? NetworkImage(member.userAvatarUrl!)
                          : null,
                      child: member.userAvatarUrl == null
                          ? Text(member.userEmail.substring(0, 1).toUpperCase())
                          : null,
                    ),
                    title: Text(member.userFullName ?? member.userEmail),
                    subtitle: member.userFullName != null
                        ? Text(member.userEmail)
                        : null,
                    onTap: () async {
                      Navigator.pop(context);
                      try {
                        final repo = ref.read(chatRepositoryProvider);
                        await repo.getOrCreateDM(
                          workspaceId: workspaceId,
                          userId: member.userId,
                        );
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to start DM: $e')),
                          );
                        }
                      }
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showCreateChannelDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    bool isPrivate = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Create Channel'),
          content: SizedBox(
            width: 400,
            child: Column(
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
                  await repo.createChannel(
                    workspaceId: workspaceId,
                    name: name,
                    description: descriptionController.text.trim(),
                    isPrivate: isPrivate,
                  );

                  if (context.mounted) {
                    Navigator.pop(context);
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
  final dynamic channel;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChannelTile({
    required this.channel,
    required this.isSelected,
    required this.onTap,
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
      selected: isSelected,
      leading: Stack(
        children: [
          Icon(
            channel.kind == 'dm' ? Icons.person : Icons.tag,
            color: isSelected ? AppTheme.primaryColor : null,
          ),
          // Online indicator for DMs
          if (channel.kind == 'dm')
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        channel.name ?? 'Direct Message',
        style: TextStyle(
          fontWeight: unreadCount > 0 || isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: channel.description.isNotEmpty 
          ? Text(
              channel.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: unreadCount > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                unreadCount > 99 ? '99+' : '$unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}

class _EmptyConversationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_outlined, size: 96, color: Colors.grey[300]),
          const SizedBox(height: 24),
          Text(
            'Select a channel to start chatting',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }
}

class _ConversationView extends ConsumerStatefulWidget {
  final String channelId;
  final String workspaceId;
  final ScrollController scrollController;

  const _ConversationView({
    required this.channelId,
    required this.workspaceId,
    required this.scrollController,
  });

  @override
  ConsumerState<_ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends ConsumerState<_ConversationView> {
  bool _isAtBottom = true;

  @override
  void initState() {
    super.initState();
    
    // Mark as read when opening
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sendMessageProvider).markAsRead(widget.channelId);
    });

    // Listen to scroll position
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!widget.scrollController.hasClients) return;

    final isAtBottom = widget.scrollController.position.pixels >= 
        widget.scrollController.position.maxScrollExtent - 100;

    if (isAtBottom != _isAtBottom) {
      setState(() => _isAtBottom = isAtBottom);
      
      // Mark as read when at bottom
      if (isAtBottom) {
        ref.read(sendMessageProvider).markAsRead(widget.channelId);
      }
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(messagesProvider(widget.channelId));
    final currentUserId = ref.watch(supabaseServiceProvider).currentUserId;

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              const Text(
                'Conversation', // TODO: Show channel name
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () {
                  // TODO: Show channel info
                },
                tooltip: 'Channel Info',
              ),
            ],
          ),
        ),

        // Messages
        Expanded(
          child: messagesAsync.when(
            data: (messages) {
              if (messages.isEmpty) {
                return const Center(
                  child: Text('No messages yet. Start the conversation!'),
                );
              }

              // Messages are in descending order, reverse for display
              final displayMessages = messages.reversed.toList();

              return ListView.builder(
                controller: widget.scrollController,
                padding: const EdgeInsets.all(24),
                itemCount: displayMessages.length,
                itemBuilder: (context, index) {
                  final message = displayMessages[index];
                  final isMe = message.senderId == currentUserId;
                  
                  final showSender = index == 0 || 
                      displayMessages[index - 1].senderId != message.senderId;

                  return MessageBubble(
                    message: message,
                    isMe: isMe,
                    showSender: showSender,
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
                  const Text('Error loading messages'),
                  TextButton(
                    onPressed: () => ref.invalidate(messagesProvider(widget.channelId)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Composer
        MessageComposer(
          channelId: widget.channelId,
          workspaceId: widget.workspaceId,
          onMessageSent: () {
            Future.delayed(const Duration(milliseconds: 100), () {
              if (widget.scrollController.hasClients) {
                widget.scrollController.animateTo(
                  widget.scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            });
          },
        ),
      ],
    );
  }
}

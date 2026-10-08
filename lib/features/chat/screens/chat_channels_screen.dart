import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/db/app_database.dart';
import '../../../core/providers/app_providers.dart';
import '../repositories/chat_repository.dart';
import '../providers/chat_providers.dart';

class ChatChannelsScreen extends ConsumerStatefulWidget {
  const ChatChannelsScreen({super.key});

  @override
  ConsumerState<ChatChannelsScreen> createState() => _ChatChannelsScreenState();
}

class _ChatChannelsScreenState extends ConsumerState<ChatChannelsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Channels', icon: Icon(Icons.tag)),
            Tab(text: 'Direct Messages', icon: Icon(Icons.person)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ChannelsTab(),
          _DirectMessagesTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewChatOptions(context),
        icon: const Icon(Icons.add),
        label: const Text('New'),
      ),
    );
  }

  void _showNewChatOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.tag),
              title: const Text('Create Channel'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/chat/new-channel');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('New Direct Message'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/chat/new-dm');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ChannelsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current workspace ID
    final workspaceId = ref.watch(currentWorkspaceIdProvider);
    
    if (workspaceId == null) {
      return const Center(
        child: Text('No workspace selected'),
      );
    }
    
    final channelsAsync = ref.watch(chatChannelsProvider(workspaceId));

    return channelsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading channels: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(chatChannelsProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (channels) {
        if (channels.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.forum_outlined, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No channels yet',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your first channel to start chatting',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[500],
                      ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/chat/new-channel');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Create Channel'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: channels.length,
          itemBuilder: (context, index) {
            final channel = channels[index];
            return _ChannelListItem(channel: channel);
          },
        );
      },
    );
  }
}

class _DirectMessagesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dmsAsync = ref.watch(directMessagesProvider);

    return dmsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading messages: $error'),
          ],
        ),
      ),
      data: (conversations) {
        if (conversations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No direct messages',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start a conversation with your teammates',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[500],
                      ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/chat/new-dm');
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text('New Message'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: conversations.length,
          itemBuilder: (context, index) {
            final conversation = conversations[index];
            return _DirectMessageListItem(conversation: conversation);
          },
        );
      },
    );
  }
}

class _ChannelListItem extends StatelessWidget {
  final ChatChannel channel;

  const _ChannelListItem({required this.channel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Text(
          '#',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        '#${channel.name}',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        channel.description ?? 'No description',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: channel.unreadCount > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${channel.unreadCount}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      onTap: () {
        Navigator.pushNamed(
          context,
          '/chat/conversation',
          arguments: {'channelId': channel.id, 'channelName': channel.name},
        );
      },
    );
  }
}

class _DirectMessageListItem extends StatelessWidget {
  final DirectMessageConversation conversation;

  const _DirectMessageListItem({required this.conversation});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getAvatarColor(conversation.otherUserName),
        child: Text(
          _getInitials(conversation.otherUserName),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        conversation.otherUserName,
        style: TextStyle(
          fontWeight: conversation.unreadCount > 0
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        conversation.lastMessage ?? 'No messages',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: conversation.unreadCount > 0
              ? FontWeight.w500
              : FontWeight.normal,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(conversation.lastMessageTime),
            style: TextStyle(
              fontSize: 12,
              color: conversation.unreadCount > 0
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[600],
            ),
          ),
          if (conversation.unreadCount > 0) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${conversation.unreadCount}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/chat/conversation',
          arguments: {
            'userId': conversation.otherUserId,
            'userName': conversation.otherUserName,
          },
        );
      },
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
    final index = name.hashCode % colors.length;
    return colors[index];
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inDays == 0) {
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } else if (diff.inDays < 7) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[time.weekday - 1];
    } else {
      return '${time.day}/${time.month}';
    }
  }
}

// Providers for chat data
final chatChannelsProvider = StreamProvider.family<List<dynamic>, String>((ref, workspaceId) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.watchChannels(workspaceId);
});

// Stub for direct messages - not implemented yet
final directMessagesProvider = StreamProvider<List<DirectMessageConversation>>((ref) {
  // TODO: Implement direct messages
  return Stream.value([]);
});

// Placeholder models
class ChatChannel {
  final int id;
  final String name;
  final String? description;
  final int unreadCount;

  ChatChannel({
    required this.id,
    required this.name,
    this.description,
    this.unreadCount = 0,
  });
}

class DirectMessageConversation {
  final int otherUserId;
  final String otherUserName;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;

  DirectMessageConversation({
    required this.otherUserId,
    required this.otherUserName,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
  });
}

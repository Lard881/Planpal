import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/app_providers.dart';

/// Messages/Chat Screen - Mobile Design
/// Shows conversation threads list
/// NO MOCK DATA - will integrate with real chat/messaging system
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final workspaceId = ref.watch(currentWorkspaceIdProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Messages',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      // New message
                    },
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search people, channels...',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Messages List
            Expanded(
              child: workspaceId == null
                  ? const Center(child: Text('No workspace selected'))
                  : _buildMessagesList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Compose new message
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildMessagesList() {
    // TODO: Replace with real chat/messaging data from database
    // For now, showing example structure that matches the design
    
    final conversations = [
      _ConversationItem(
        channel: 'Global Team Sync',
        lastMessage: 'Maya Webb: Redesigned slide assets up...',
        time: '10:24 AM',
        unreadCount: 2,
        isOnline: true,
        avatarColor: const Color(0xFF3B82F6),
      ),
      _ConversationItem(
        channel: 'Maya Webb',
        lastMessage: 'Can you check the cake inviting document...',
        time: '9:15 AM',
        unreadCount: 0,
        isOnline: true,
        avatarColor: const Color(0xFF10B981),
      ),
      _ConversationItem(
        channel: 'Zoe Harrington',
        lastMessage: 'The client call is rescheduled for tomorrow.',
        time: 'Yesterday',
        unreadCount: 0,
        isOnline: false,
        avatarColor: const Color(0xFFF59E0B),
      ),
      _ConversationItem(
        channel: 'Ethan Blackwell',
        lastMessage: 'Nice work on that last integration!',
        time: 'Yesterday',
        unreadCount: 0,
        isOnline: false,
        avatarColor: const Color(0xFF8B5CF6),
      ),
      _ConversationItem(
        channel: 'James Holloway',
        lastMessage: 'Let\'s review the proposal blog ideas.',
        time: 'May 13',
        unreadCount: 0,
        isOnline: false,
        avatarColor: const Color(0xFFEF4444),
      ),
    ];

    // Filter by search query
    final filteredConversations = _searchQuery.isEmpty
        ? conversations
        : conversations.where((conv) {
            return conv.channel.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                conv.lastMessage.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

    if (filteredConversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No messages found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Implement refresh
      },
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: filteredConversations.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: Colors.grey[200],
        ),
        itemBuilder: (context, index) {
          final conversation = filteredConversations[index];
          return _buildConversationTile(conversation);
        },
      ),
    );
  }

  Widget _buildConversationTile(_ConversationItem conversation) {
    final initials = conversation.channel
        .split(' ')
        .take(2)
        .map((word) => word[0])
        .join()
        .toUpperCase();

    return InkWell(
      onTap: () {
        // Open conversation
        // Navigator.pushNamed(context, '/chat/${conversation.channel}');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Avatar with online indicator
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: conversation.avatarColor,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (conversation.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Message content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        conversation.channel,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: conversation.unreadCount > 0
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                      Text(
                        conversation.time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.lastMessage,
                          style: TextStyle(
                            fontSize: 14,
                            color: conversation.unreadCount > 0
                                ? Colors.black87
                                : Colors.grey[600],
                            fontWeight: conversation.unreadCount > 0
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (conversation.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${conversation.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationItem {
  final String channel;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final Color avatarColor;

  _ConversationItem({
    required this.channel,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.isOnline,
    required this.avatarColor,
  });
}

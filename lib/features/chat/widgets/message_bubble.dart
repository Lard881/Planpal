import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:planpal/core/db/app_database.dart';
import 'package:planpal/core/theme/app_theme.dart';
import 'package:planpal/features/chat/presentation/chat_providers.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Message bubble widget for chat messages
class MessageBubble extends ConsumerWidget {
  final Message message;
  final bool isMe;
  final bool showSender;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.showSender = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onLongPress: () => _showMessageActions(context, ref),
      child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe && showSender)
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              child: Text(
                _getInitials(message.senderId),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          if (!isMe && !showSender) const SizedBox(width: 40),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe && showSender)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 4),
                    child: Text(
                      message.senderId, // TODO: Show sender name from profile
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? AppTheme.primaryColor : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.body.isNotEmpty)
                        Text(
                          message.body,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                      if (message.fileId != null) ...[
                        if (message.body.isNotEmpty) const SizedBox(height: 8),
                        _FileAttachment(fileId: message.fileId!),
                      ],
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            timeago.format(message.createdAt),
                            style: TextStyle(
                              color: isMe ? Colors.white70 : Colors.grey[600],
                              fontSize: 11,
                            ),
                          ),
                          if (message.editedAt != null) ...[
                            const SizedBox(width: 4),
                            Text(
                              '(edited)',
                              style: TextStyle(
                                color: isMe ? Colors.white70 : Colors.grey[600],
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                          if (message.syncStatus == 'pending') ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.schedule,
                              size: 12,
                              color: isMe ? Colors.white70 : Colors.grey[600],
                            ),
                          ],
                          if (message.syncStatus == 'failed') ...[
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _retryMessage(context, ref),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.refresh,
                                    size: 14,
                                    color: Colors.red[700],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Retry',
                                    style: TextStyle(
                                      color: Colors.red[700],
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
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
          const SizedBox(width: 8),
          if (isMe && showSender) const SizedBox(width: 32),
        ],
      ),
    );
  }

  String _getInitials(String userId) {
    // Extract first letter, or use # for unknown
    if (userId.isEmpty) return '#';
    return userId.substring(0, 1).toUpperCase();
  }

  Future<void> _retryMessage(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(sendMessageProvider).retry(message.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message sent')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to retry: $e')),
        );
      }
    }
  }

  void _showMessageActions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy'),
              onTap: () {
                Navigator.pop(context);
                Clipboard.setData(ClipboardData(text: message.body));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message copied')),
                );
              },
            ),
            if (isMe) ...[
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditDialog(context, ref);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context, ref);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: message.body);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Message'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Message',
          ),
          maxLines: 3,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final newBody = controller.text.trim();
              if (newBody.isEmpty || newBody == message.body) {
                Navigator.pop(context);
                return;
              }

              try {
                await ref.read(sendMessageProvider).edit(message.id, newBody);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Message edited')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to edit message: $e')),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await ref.read(sendMessageProvider).delete(message.id);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Message deleted')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete message: $e')),
                  );
                }
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _FileAttachment extends StatelessWidget {
  final String fileId;

  const _FileAttachment({required this.fileId});

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch actual file metadata from Files table
    // For now, show placeholder
    final isImage = false; // Check mime type when file data available
    
    if (isImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: 'https://placeholder.url/$fileId', // TODO: Get real URL
          width: 200,
          height: 200,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: 200,
            height: 200,
            color: Colors.grey[300],
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            width: 200,
            height: 200,
            color: Colors.grey[300],
            child: const Icon(Icons.error),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.attach_file, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'File attachment', // TODO: Show actual filename
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              Text(
                fileId.substring(0, 8), // Show short ID
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

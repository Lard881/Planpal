import 'package:flutter/material.dart';
import 'avatar.dart';

/// Chat bubble component for messages
class ChatBubble extends StatelessWidget {
  final String message;
  final String senderName;
  final String? senderAvatar;
  final DateTime timestamp;
  final bool isOwnMessage;
  final bool showAvatar;
  final VoidCallback? onLongPress;

  const ChatBubble({
    super.key,
    required this.message,
    required this.senderName,
    this.senderAvatar,
    required this.timestamp,
    this.isOwnMessage = false,
    this.showAvatar = true,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment:
            isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isOwnMessage && showAvatar) ...[
            Avatar(
              imageUrl: senderAvatar,
              name: senderName,
              size: 32,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: onLongPress,
              child: Column(
                crossAxisAlignment: isOwnMessage
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (!isOwnMessage && showAvatar)
                    Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 4),
                      child: Text(
                        senderName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isOwnMessage
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isOwnMessage ? 16 : 4),
                        bottomRight: Radius.circular(isOwnMessage ? 4 : 16),
                      ),
                    ),
                    child: Text(
                      message,
                      style: TextStyle(
                        fontSize: 14,
                        color: isOwnMessage
                            ? Colors.white
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 12, right: 12),
                    child: Text(
                      _formatTime(timestamp),
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isOwnMessage && showAvatar) ...[
            const SizedBox(width: 8),
            Avatar(
              imageUrl: senderAvatar,
              name: senderName,
              size: 32,
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${time.month}/${time.day} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}

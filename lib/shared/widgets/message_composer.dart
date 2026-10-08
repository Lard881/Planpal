import 'package:flutter/material.dart';

/// Message composer component for chat
class MessageComposer extends StatefulWidget {
  final ValueChanged<String> onSend;
  final VoidCallback? onAttach;
  final String? hintText;
  final bool isLoading;

  const MessageComposer({
    super.key,
    required this.onSend,
    this.onAttach,
    this.hintText,
    this.isLoading = false,
  });

  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Attach button
            if (widget.onAttach != null)
              IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: widget.isLoading ? null : widget.onAttach,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            if (widget.onAttach != null) const SizedBox(width: 12),

            // Text field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: !widget.isLoading,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: widget.hintText ?? 'Type a message...',
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) => _send(),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Send button
            Container(
              decoration: BoxDecoration(
                color: _hasText && !widget.isLoading
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: widget.isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        Icons.send,
                        color: _hasText
                            ? Colors.white
                            : theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                onPressed:
                    _hasText && !widget.isLoading ? _send : null,
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

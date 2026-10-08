import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planpal/core/theme/app_theme.dart';
import 'package:planpal/features/chat/presentation/chat_providers.dart';
import 'package:planpal/features/documents/services/file_upload_service.dart';
import 'package:planpal/features/workspaces/providers/workspace_providers.dart';

/// Message composer widget with retry logic and file/image support
class MessageComposer extends ConsumerStatefulWidget {
  final String channelId;
  final String workspaceId;
  final VoidCallback? onMessageSent;

  const MessageComposer({
    super.key,
    required this.channelId,
    required this.workspaceId,
    this.onMessageSent,
  });

  @override
  ConsumerState<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends ConsumerState<MessageComposer> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _imagePicker = ImagePicker();
  
  bool _isSending = false;
  File? _selectedFile;
  String? _selectedFileName;
  double _uploadProgress = 0.0;
  
  // Mention support
  bool _showMentionPicker = false;
  String _mentionQuery = '';
  
  // Typing indicator
  Timer? _typingTimer;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final text = _controller.text;
    final cursorPos = _controller.selection.baseOffset;
    
    // Send typing indicator
    if (text.isNotEmpty && !_isTyping) {
      _isTyping = true;
      ref.read(chatRepositoryProvider).sendTypingIndicator(widget.channelId);
    }
    
    // Clear typing after 3 seconds of no typing
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 3), () {
      if (_isTyping) {
        _isTyping = false;
        ref.read(chatRepositoryProvider).clearTypingIndicator(widget.channelId);
      }
    });
    
    // Check if we should show mention picker
    if (cursorPos > 0 && text.length >= cursorPos) {
      final beforeCursor = text.substring(0, cursorPos);
      final atIndex = beforeCursor.lastIndexOf('@');
      
      if (atIndex >= 0) {
        final afterAt = beforeCursor.substring(atIndex + 1);
        
        // Show picker if @ is at word boundary and no space after
        if ((atIndex == 0 || text[atIndex - 1] == ' ') && !afterAt.contains(' ')) {
          setState(() {
            _showMentionPicker = true;
            _mentionQuery = afterAt.toLowerCase();
          });
          return;
        }
      }
    }
    
    if (_showMentionPicker) {
      setState(() => _showMentionPicker = false);
    }
  }

  void _insertMention(String userId, String userName) {
    final text = _controller.text;
    final cursorPos = _controller.selection.baseOffset;
    final beforeCursor = text.substring(0, cursorPos);
    final atIndex = beforeCursor.lastIndexOf('@');
    
    if (atIndex >= 0) {
      final before = text.substring(0, atIndex);
      final after = text.substring(cursorPos);
      final mention = '@[$userName](user:$userId)';
      
      _controller.text = before + mention + ' ' + after;
      _controller.selection = TextSelection.collapsed(
        offset: before.length + mention.length + 1,
      );
    }
    
    setState(() => _showMentionPicker = false);
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    if (_isTyping) {
      ref.read(chatRepositoryProvider).clearTypingIndicator(widget.channelId);
    }
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: false,
        withReadStream: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        setState(() {
          _selectedFile = File(file.path!);
          _selectedFileName = file.name;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick file: $e')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedFile = File(pickedFile.path);
          _selectedFileName = pickedFile.path.split('/').last;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  void _removeFile() {
    setState(() {
      _selectedFile = null;
      _selectedFileName = null;
      _uploadProgress = 0.0;
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if ((text.isEmpty && _selectedFile == null) || _isSending) return;

    setState(() => _isSending = true);

    String? fileId;

    try {
      // Upload file if attached
      if (_selectedFile != null) {
        final uploadService = ref.read(fileUploadServiceProvider);
        fileId = await uploadService.uploadFile(
          workspaceId: widget.workspaceId,
          file: _selectedFile!,
          fileName: _selectedFileName!,
          onProgress: (progress) {
            if (mounted) {
              setState(() => _uploadProgress = progress);
            }
          },
        );
      }

      // Send message
      final controller = ref.read(sendMessageProvider);
      await controller.send(
        channelId: widget.channelId,
        body: text.isNotEmpty ? text : null,
        fileId: fileId,
      );

      _controller.clear();
      _removeFile();
      widget.onMessageSent?.call();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message: $e'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _sendMessage,
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
          _uploadProgress = 0.0;
        });
      }
    }
  }

  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Photo from gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_file),
              title: const Text('File'),
              onTap: () {
                Navigator.pop(context);
                _pickFile();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(workspaceMembersProvider(widget.workspaceId));

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: 12 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Mention picker
          if (_showMentionPicker)
            membersAsync.when(
              data: (members) {
                final filtered = _mentionQuery.isEmpty
                    ? members
                    : members.where((m) {
                        return m.userEmail.toLowerCase().contains(_mentionQuery) ||
                            (m.userFullName?.toLowerCase().contains(_mentionQuery) ?? false);
                      }).toList();

                if (filtered.isEmpty) return const SizedBox.shrink();

                return Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filtered.length > 5 ? 5 : filtered.length,
                    itemBuilder: (context, index) {
                      final member = filtered[index];
                      return ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundImage: member.userAvatarUrl != null
                              ? NetworkImage(member.userAvatarUrl!)
                              : null,
                          child: member.userAvatarUrl == null
                              ? Text(
                                  member.userEmail.substring(0, 1).toUpperCase(),
                                  style: const TextStyle(fontSize: 12),
                                )
                              : null,
                        ),
                        title: Text(
                          member.userFullName ?? member.userEmail,
                          style: const TextStyle(fontSize: 14),
                        ),
                        onTap: () => _insertMention(
                          member.userId,
                          member.userFullName ?? member.userEmail,
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          // File preview
          if (_selectedFile != null) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Image preview or file icon
                  _isImage(_selectedFileName!)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _selectedFile!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.insert_drive_file, size: 32),
                        ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedFileName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        if (_isSending && _uploadProgress > 0) ...[
                          const SizedBox(height: 4),
                          LinearProgressIndicator(value: _uploadProgress),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _isSending ? null : _removeFile,
                  ),
                ],
              ),
            ),
          ],

          // Input row
          Row(
            children: [
              // Attach button
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: _isSending ? null : _showAttachmentMenu,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 8),

              // Text input
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: !_isSending,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),

              // Send button
              _isSending
                  ? const SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                      color: AppTheme.primaryColor,
                      iconSize: 28,
                    ),
            ],
          ),
        ],
      ),
    );
  }

  bool _isImage(String filename) {
    final ext = filename.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(ext);
  }
}

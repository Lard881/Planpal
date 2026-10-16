import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/features/chat/models/chat_models.dart';

void main() {
  test('parses joined sender and file metadata for an attachment message', () {
    final message = MessageModel.fromJson({
      'id': 'message-1',
      'channel_id': 'channel-1',
      'sender_id': 'user-1',
      'body': '',
      'created_at': '2026-07-14T09:00:00.000Z',
      'sender': {
        'full_name': 'Alex Example',
        'avatar_url': 'https://example.test/avatar.png',
      },
      'file': {'id': 'file-1', 'name': 'diagram.png', 'mime_type': 'image/png'},
    });

    expect(message.senderName, 'Alex Example');
    expect(message.senderAvatarUrl, 'https://example.test/avatar.png');
    expect(message.fileId, 'file-1');
    expect(message.fileName, 'diagram.png');
    expect(message.hasFile, isTrue);
    expect(message.isImage, isTrue);
  });

  test('uses the other user profile for a direct message channel', () {
    final channel = ChannelModel.fromJson({
      'id': 'dm-1',
      'workspace_id': 'workspace-1',
      'kind': 'dm',
      'otherUser': {'id': 'user-2', 'full_name': 'Sam Example'},
    });

    expect(channel.isDm, isTrue);
    expect(channel.memberIds, ['user-2']);
    expect(channel.memberNames, ['Sam Example']);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/features/workspaces/models/workspace_model.dart';

void main() {
  group('MemberModel.fromJson', () {
    test('parses the workspace members API response', () {
      final member = MemberModel.fromJson({
        'userId': 'user-123',
        'role': 'admin',
        'fullName': 'Alex Example',
        'email': 'alex@example.com',
        'avatarUrl': 'https://example.com/avatar.png',
      });

      expect(member.userId, 'user-123');
      expect(member.role, 'admin');
      expect(member.fullName, 'Alex Example');
      expect(member.email, 'alex@example.com');
      expect(member.avatarUrl, 'https://example.com/avatar.png');
    });

    test('continues to parse nested profile responses', () {
      final member = MemberModel.fromJson({
        'user_id': 'user-456',
        'role': 'member',
        'profile': {
          'full_name': 'Sam Example',
          'email': 'sam@example.com',
          'avatar_url': 'https://example.com/sam.png',
        },
      });

      expect(member.userId, 'user-456');
      expect(member.role, 'member');
      expect(member.fullName, 'Sam Example');
      expect(member.email, 'sam@example.com');
      expect(member.avatarUrl, 'https://example.com/sam.png');
    });
  });
}

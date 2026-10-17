import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/features/notifications/providers/notification_preferences.dart';

void main() {
  group('NotificationPreferences', () {
    test('keeps push category filters independent of in-app alerts', () {
      const preferences = NotificationPreferences(
        inApp: false,
        comments: false,
      );

      expect(preferences.allowsType('chat_message'), isTrue);
      expect(preferences.allowsType('task_comment'), isFalse);
      expect(preferences.allowsInAppType('chat_message'), isFalse);
    });
  });
}

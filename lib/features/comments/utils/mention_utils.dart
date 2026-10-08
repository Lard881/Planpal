/// Utility functions for handling @mentions in comments
library;

/// Extracts all @username mentions from text
List<String> extractMentions(String text) {
  final mentionRegex = RegExp(r'@(\w+)');
  final matches = mentionRegex.allMatches(text);
  
  return matches
      .map((match) => match.group(1)!) // Extract username without @
      .toSet() // Remove duplicates
      .toList();
}

/// Checks if text contains any mentions
bool hasMentions(String text) {
  final mentionRegex = RegExp(r'@(\w+)');
  return mentionRegex.hasMatch(text);
}

/// Replaces mentions with user IDs for backend processing
/// Example: "@john worked on this" -> "[@user:123] worked on this"
String replaceMentionsWithIds(String text, Map<String, String> usernameToIdMap) {
  final mentionRegex = RegExp(r'@(\w+)');
  
  return text.replaceAllMapped(mentionRegex, (match) {
    final username = match.group(1)!;
    final userId = usernameToIdMap[username];
    
    if (userId != null) {
      return '@$username'; // Keep the mention format for display
    }
    return match.group(0)!; // Keep as-is if no user ID found
  });
}

/// Gets unique user IDs from a list of usernames
Future<List<String>> getUserIdsFromMentions(
  List<String> mentions,
  Future<Map<String, String>> Function() fetchUsernameMap,
) async {
  if (mentions.isEmpty) return [];
  
  try {
    final usernameMap = await fetchUsernameMap();
    return mentions
        .map((username) => usernameMap[username])
        .whereType<String>()
        .toList();
  } catch (e) {
    return [];
  }
}

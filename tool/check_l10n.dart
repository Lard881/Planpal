// tool/check_l10n.dart
// A2: Fails if any .dart file under lib/features or lib/core/widgets
// contains a user-visible string that is not routed through AppLocalizations.
// Run: dart tool/check_l10n.dart
// Returns exit code 1 if violations are found.

import 'dart:io';

// Patterns that indicate a user-visible hardcoded string
final _patterns = [
  // Text('...') with an uppercase first letter
  RegExp(r"Text\('([A-Z][^']{2,})'\)"),
  // label: '...' or hint: '...' or title: '...' or subtitle: '...'
  RegExp(
    r"(?:label|hint|title|subtitle|hintText|labelText):\s*'([A-Z][^']{2,})'",
  ),
];

// Files/patterns to always ignore
final _ignoreFiles = [
  'app_localizations',
  '.g.dart',
  '.freezed.dart',
  'test/',
  'tool/',
];

// Strings that are acceptable to keep hardcoded
final _allowedStrings = {
  'PlanPal', // app name
  'GET', // HTTP methods
  'POST',
  'PATCH',
  'DELETE',
  '••••••••••', // password placeholder
};

void main() {
  final dirs = [Directory('lib/features'), Directory('lib/core/widgets')];

  final violations = <String>[];

  for (final dir in dirs) {
    if (!dir.existsSync()) {
      continue;
    }
    for (final file in dir.listSync(recursive: true)) {
      if (file is! File || !file.path.endsWith('.dart')) {
        continue;
      }
      if (_ignoreFiles.any((p) => file.path.contains(p))) {
        continue;
      }

      final content = file.readAsStringSync();
      final lines = content.split('\n');

      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        // Skip lines that already use l10n
        if (line.contains('l10n.') || line.contains('AppLocalizations')) {
          continue;
        }
        // Skip comments
        if (line.trimLeft().startsWith('//')) {
          continue;
        }

        for (final pattern in _patterns) {
          final matches = pattern.allMatches(line);
          for (final match in matches) {
            final str = match.group(1) ?? '';
            if (_allowedStrings.contains(str)) {
              continue;
            }
            if (str.length < 3) {
              continue;
            }
            violations.add('${file.path}:${i + 1}: "$str"');
          }
        }
      }
    }
  }

  if (violations.isEmpty) {
    stdout.writeln('✓ No hardcoded UI strings found.');
    exit(0);
  } else {
    stdout.writeln('✗ Found ${violations.length} hardcoded UI strings:\n');
    for (final v in violations) {
      stdout.writeln('  $v');
    }
    stdout.writeln('\nReplace each with the matching AppLocalizations key.');
    exit(1);
  }
}

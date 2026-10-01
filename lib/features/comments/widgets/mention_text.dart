import 'package:flutter/material.dart';

/// Widget that displays text with highlighted @mentions
class MentionText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  const MentionText({
    super.key,
    required this.text,
    this.style,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final spans = _parseText(context);

    return RichText(
      text: TextSpan(
        style: style ?? Theme.of(context).textTheme.bodyMedium,
        children: spans,
      ),
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
    );
  }

  List<TextSpan> _parseText(BuildContext context) {
    final List<TextSpan> spans = [];
    final mentionRegex = RegExp(r'@(\w+)');
    
    int lastMatchEnd = 0;
    
    for (final match in mentionRegex.allMatches(text)) {
      // Add text before mention
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
        ));
      }
      
      // Add mention with highlighting
      spans.add(TextSpan(
        text: match.group(0),
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
        ),
      ));
      
      lastMatchEnd = match.end;
    }
    
    // Add remaining text
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
      ));
    }
    
    return spans.isEmpty ? [TextSpan(text: text)] : spans;
  }
}

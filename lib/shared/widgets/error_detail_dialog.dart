import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Dialog that displays technical error details including error code and request ID.
/// Shows a "Copy" button to copy all details to clipboard.
/// Used when user taps "Details" link on error messages.
class ErrorDetailDialog extends StatelessWidget {
  final String? errorCode;
  final String? requestId;
  final String? message;
  final String? timestamp;

  const ErrorDetailDialog({
    super.key,
    this.errorCode,
    this.requestId,
    this.message,
    this.timestamp,
  });

  /// Show the error detail dialog.
  static Future<void> show(
    BuildContext context, {
    String? errorCode,
    String? requestId,
    String? message,
    String? timestamp,
  }) {
    return showDialog(
      context: context,
      builder: (context) => ErrorDetailDialog(
        errorCode: errorCode,
        requestId: requestId,
        message: message,
        timestamp: timestamp ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final details = _buildDetailsText();

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: theme.colorScheme.error,
          ),
          const SizedBox(width: 12),
          Text(l10n.error),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message != null) ...[
              Text(
                message!,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
            ],
            Text(
              'Technical Details',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: SelectableText(
                details,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton.icon(
          onPressed: () => _copyToClipboard(context, details),
          icon: const Icon(Icons.copy, size: 18),
          label: const Text('Copy'),
        ),
      ],
    );
  }

  String _buildDetailsText() {
    final buffer = StringBuffer();

    if (errorCode != null) {
      buffer.writeln('Error Code: $errorCode');
    }
    if (requestId != null) {
      buffer.writeln('Request ID: $requestId');
    }
    if (timestamp != null) {
      buffer.writeln('Timestamp: $timestamp');
    }

    return buffer.toString().trim();
  }

  Future<void> _copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error details copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pop();
  }
}

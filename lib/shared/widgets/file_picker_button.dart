import 'package:flutter/material.dart';

/// File picker button component
/// NOTE: file_picker package temporarily disabled for SDK 36 compatibility
/// This is a placeholder UI until file_picker is re-enabled
class FilePickerButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;
  final String? disabledReason;

  const FilePickerButton({
    super.key,
    this.label = 'Attach File',
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.disabledReason,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Tooltip(
      message: isDisabled && disabledReason != null
          ? disabledReason!
          : 'Attach a file',
      child: OutlinedButton.icon(
        onPressed: isDisabled || isLoading ? null : onPressed,
        icon: isLoading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.attach_file, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}

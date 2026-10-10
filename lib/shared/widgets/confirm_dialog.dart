import 'package:flutter/material.dart';
import 'planpal_button.dart';

/// Confirmation dialog
/// Shows a dialog asking for user confirmation
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final bool isDangerous;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.isDangerous = false,
  });

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDangerous = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDangerous: isDangerous,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        PlanPalButton(
          text: cancelText,
          isOutlined: true,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        PlanPalButton(
          text: confirmText,
          backgroundColor: isDangerous ? AppColors.danger : AppColors.primary,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}

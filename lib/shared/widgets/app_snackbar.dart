import 'package:flutter/material.dart';

/// App snackbar with different types
enum SnackbarType { success, info, error }

class AppSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    Color getBackgroundColor() {
      switch (type) {
        case SnackbarType.success:
          return const Color(0xFF10B981);
        case SnackbarType.error:
          return const Color(0xFFEF4444);
        case SnackbarType.info:
        default:
          return const Color(0xFF3B82F6);
      }
    }

    IconData getIcon() {
      switch (type) {
        case SnackbarType.success:
          return Icons.check_circle;
        case SnackbarType.error:
          return Icons.error;
        case SnackbarType.info:
        default:
          return Icons.info;
      }
    }

    final backgroundColor = getBackgroundColor();
    final icon = getIcon();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction,
              )
            : null,
      ),
    );
  }

  static void success(BuildContext context, String message) {
    show(context, message: message, type: SnackbarType.success);
  }

  static void error(BuildContext context, String message) {
    show(context, message: message, type: SnackbarType.error);
  }

  static void info(BuildContext context, String message) {
    show(context, message: message, type: SnackbarType.info);
  }
}

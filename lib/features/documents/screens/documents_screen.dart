import 'package:flutter/material.dart';
import 'documents_screen_desktop.dart';
import 'documents_screen_mobile.dart';

/// Responsive wrapper for Documents screen
class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          return const DocumentsScreenDesktop();
        } else {
          return const DocumentsScreenMobile();
        }
      },
    );
  }
}

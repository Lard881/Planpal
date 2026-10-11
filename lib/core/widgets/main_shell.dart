import 'package:flutter/material.dart';
import '../../features/main/screens/main_navigation_screen.dart';

/// Main shell widget wrapping content with adaptive navigation
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MainNavigationScreen(child: child);
  }
}

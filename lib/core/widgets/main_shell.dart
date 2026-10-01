import 'package:flutter/material.dart';

/// Main shell widget with bottom navigation
/// TODO: Implement full bottom navigation in later stage
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Placeholder - just shows the child without bottom nav for now
    // This will be fully implemented when the main navigation is built
    return child;
  }
}

import 'package:flutter/material.dart';

/// Settings screen
/// TODO: Implement full settings functionality in later stage
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const Center(
        child: Text('Settings screen - Coming soon'),
      ),
    );
  }
}

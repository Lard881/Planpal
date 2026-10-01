import 'package:flutter/material.dart';

/// Profile screen
/// TODO: Implement full profile functionality in later stage
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text('Profile screen - Coming soon'),
      ),
    );
  }
}

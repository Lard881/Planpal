import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkspaceScreen extends ConsumerWidget {
  const WorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workspace'),
      ),
      body: const Center(
        child: Text('Workspace Screen - To be implemented'),
      ),
    );
  }
}

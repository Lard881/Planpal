import 'package:flutter/material.dart';
class TasksScreen extends StatelessWidget {
  final String? taskId;
  final bool showNewTask;
  const TasksScreen({super.key, this.taskId, this.showNewTask = false});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Tasks — Stage 7')));
}

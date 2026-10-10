import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/env.dart';
import 'core/db/app_database.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/tasks/repositories/task_repository.dart';
import 'features/tasks/presentation/task_providers.dart';

/// Minimal test app to verify Task CRUD integration
void main() {
  runApp(
    const ProviderScope(
      child: TestApp(),
    ),
  );
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlanPal Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TestHomeScreen(),
    );
  }
}

class TestHomeScreen extends ConsumerStatefulWidget {
  const TestHomeScreen({super.key});

  @override
  ConsumerState<TestHomeScreen> createState() => _TestHomeScreenState();
}

class _TestHomeScreenState extends ConsumerState<TestHomeScreen> {
  String _status = 'Ready to test Task CRUD';
  bool _loading = false;

  Future<void> _testTaskCRUD() async {
    setState(() {
      _loading = true;
      _status = 'Testing...';
    });

    try {
      final taskRepo = ref.read(taskRepositoryProvider);
      
      // Test 1: Create a task
      _updateStatus('Creating test task...');
      final task = await taskRepo.createTask(
        workspaceId: 'test-workspace',
        title: 'Test Task ${DateTime.now().millisecondsSinceEpoch}',
        description: 'This is a test task created from Flutter',
        status: 'todo',
        priority: 'high',
      );
      
      _updateStatus('✅ Task created: ${task.id}');
      await Future.delayed(const Duration(seconds: 1));
      
      // Test 2: Fetch tasks
      _updateStatus('Fetching tasks...');
      final tasks = await taskRepo.fetchAndSyncTasks('test-workspace');
      _updateStatus('✅ Found ${tasks.length} task(s)');
      await Future.delayed(const Duration(seconds: 1));
      
      // Test 3: Update task
      _updateStatus('Updating task...');
      await taskRepo.updateTask(
        task.id,
        TasksCompanion.insert(
          id: task.id,
          workspaceId: task.workspaceId,
          title: '${task.title} (UPDATED)',
          status: 'in_progress',
          priority: task.priority,
          createdBy: task.createdBy,
          createdAt: task.createdAt,
          updatedAt: DateTime.now(),
        ),
      );
      _updateStatus('✅ Task updated');
      await Future.delayed(const Duration(seconds: 1));
      
      // Test 4: Delete task
      _updateStatus('Deleting task...');
      await taskRepo.deleteTask(task.id);
      _updateStatus('✅ Task deleted');
      await Future.delayed(const Duration(seconds: 1));
      
      _updateStatus('🎉 All tests passed!\n\nBackend: ${Env.apiBaseUrl}');
      
    } catch (e, stack) {
      _updateStatus('❌ Error: $e\n\nStack: ${stack.toString().substring(0, 200)}...');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _updateStatus(String status) {
    setState(() => _status = status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PlanPal Task CRUD Test'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Task CRUD Integration Test',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Backend: ${Env.apiBaseUrl}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _loading ? null : _testTaskCRUD,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Run Test', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _status,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

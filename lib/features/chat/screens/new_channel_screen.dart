import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/db/app_database.dart';
import '../repositories/chat_repository.dart';
import '../../workspaces/providers/workspace_providers.dart';

class NewChannelScreen extends ConsumerStatefulWidget {
  const NewChannelScreen({super.key});

  @override
  ConsumerState<NewChannelScreen> createState() => _NewChannelScreenState();
}

class _NewChannelScreenState extends ConsumerState<NewChannelScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  bool _isPrivate = false;
  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Channel'),
        actions: [
          if (_isCreating)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _createChannel,
              child: const Text('CREATE'),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Info card
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Channels are where your team communicates. They\'re best organized around a topic.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Channel name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Channel Name',
                hintText: 'e.g. project-planning',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.tag),
                helperText: 'Use lowercase, no spaces',
                prefixText: '#',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Channel name is required';
                }
                if (value.contains(' ')) {
                  return 'Channel name cannot contain spaces';
                }
                if (value != value.toLowerCase()) {
                  return 'Channel name must be lowercase';
                }
                if (!RegExp(r'^[a-z0-9-_]+$').hasMatch(value)) {
                  return 'Only letters, numbers, hyphens and underscores allowed';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                // Auto-format: lowercase and replace spaces with hyphens
                final formatted = value.toLowerCase().replaceAll(' ', '-');
                if (formatted != value) {
                  _nameController.value = TextEditingValue(
                    text: formatted,
                    selection: TextSelection.collapsed(offset: formatted.length),
                  );
                }
              },
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'What is this channel about?',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 24),

            // Privacy settings
            Text(
              'Privacy',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            Card(
              child: Column(
                children: [
                  RadioListTile<bool>(
                    value: false,
                    groupValue: _isPrivate,
                    onChanged: (value) {
                      setState(() {
                        _isPrivate = value!;
                      });
                    },
                    title: const Text('Public'),
                    subtitle: const Text(
                      'Anyone in the workspace can join and see messages',
                    ),
                    secondary: const Icon(Icons.public),
                  ),
                  const Divider(height: 1),
                  RadioListTile<bool>(
                    value: true,
                    groupValue: _isPrivate,
                    onChanged: (value) {
                      setState(() {
                        _isPrivate = value!;
                      });
                    },
                    title: const Text('Private'),
                    subtitle: const Text(
                      'Only invited members can join and see messages',
                    ),
                    secondary: const Icon(Icons.lock),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Create button
            FilledButton.icon(
              onPressed: _isCreating ? null : _createChannel,
              icon: const Icon(Icons.add),
              label: const Text('Create Channel'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createChannel() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      final currentWorkspace = ref.read(currentWorkspaceProvider);
      if (currentWorkspace == null) {
        throw Exception('No workspace selected');
      }

      // Create channel logic here
      await Future.delayed(const Duration(seconds: 1)); // Simulate network

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Channel #${_nameController.text} created'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create channel: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/planpal_button.dart';
import '../../../shared/widgets/planpal_text_field.dart';

/// Dialog for creating a new project
class CreateProjectDialog extends ConsumerStatefulWidget {
  const CreateProjectDialog({super.key});

  @override
  ConsumerState<CreateProjectDialog> createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends ConsumerState<CreateProjectDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedColor = '#3B82F6'; // Default blue
  String _selectedIcon = 'folder';
  bool _isCreating = false;

  final List<String> _colors = [
    '#3B82F6', // Blue
    '#10B981', // Green
    '#F59E0B', // Orange
    '#EF4444', // Red
    '#8B5CF6', // Purple
    '#EC4899', // Pink
    '#14B8A6', // Teal
    '#F97316', // Deep orange
  ];

  final List<Map<String, dynamic>> _icons = [
    {'name': 'folder', 'icon': Icons.folder},
    {'name': 'work', 'icon': Icons.work},
    {'name': 'home', 'icon': Icons.home},
    {'name': 'school', 'icon': Icons.school},
    {'name': 'shopping', 'icon': Icons.shopping_cart},
    {'name': 'health', 'icon': Icons.favorite},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Project'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project name
              PlanPalTextField(
                controller: _nameController,
                labelText: 'Project Name',
                hintText: 'Enter project name',
              ),
              const SizedBox(height: 16),

              // Description
              PlanPalTextField(
                controller: _descriptionController,
                labelText: 'Description (optional)',
                hintText: 'Add a description...',
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Color picker
              Text(
                'Color',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _colors.map((color) {
                  final isSelected = color == _selectedColor;
                  return InkWell(
                    onTap: () => setState(() => _selectedColor = color),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(int.parse(color.replaceFirst('#', '0xFF'))),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? AppColors.grey900 : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white, size: 20)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Icon picker
              Text(
                'Icon',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _icons.map((iconData) {
                  final isSelected = iconData['name'] == _selectedIcon;
                  final color = Color(int.parse(_selectedColor.replaceFirst('#', '0xFF')));
                  return InkWell(
                    onTap: () => setState(() => _selectedIcon = iconData['name']),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isSelected ? color.withOpacity(0.1) : AppColors.grey100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? color : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        iconData['icon'],
                        color: isSelected ? color : AppColors.grey600,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isCreating ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        PlanPalButton(
          onPressed: _isCreating ? null : _createProject,
          isLoading: _isCreating,
          child: const Text('Create'),
        ),
      ],
    );
  }

  Future<void> _createProject() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a project name')),
      );
      return;
    }

    final workspaceId = ref.read(currentWorkspaceIdProvider);
    if (workspaceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No workspace selected')),
      );
      return;
    }

    setState(() => _isCreating = true);

    try {
      final projectRepository = ref.read(projectRepositoryProvider);
      await projectRepository.createProject(
        workspaceId: workspaceId,
        name: name,
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        color: _selectedColor,
        icon: _selectedIcon,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project created successfully')),
        );
      }
    } catch (e) {
      setState(() => _isCreating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create project: $e')),
        );
      }
    }
  }
}

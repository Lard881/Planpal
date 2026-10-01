import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/label.dart';
import '../repositories/label_repository.dart';
import '../../../core/providers/app_providers.dart';
import 'label_chip.dart';
import 'color_picker.dart';

/// A widget for selecting and managing labels for a task
class LabelPicker extends ConsumerStatefulWidget {
  final String workspaceId;
  final List<String> selectedLabelIds;
  final ValueChanged<List<String>> onSelectionChanged;

  const LabelPicker({
    Key? key,
    required this.workspaceId,
    required this.selectedLabelIds,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  ConsumerState<LabelPicker> createState() => _LabelPickerState();
}

class _LabelPickerState extends ConsumerState<LabelPicker> {
  late List<String> _selectedIds;
  bool _isCreatingLabel = false;

  @override
  void initState() {
    super.initState();
    _selectedIds = List.from(widget.selectedLabelIds);
  }

  @override
  Widget build(BuildContext context) {
    final labelRepository = ref.watch(labelRepositoryProvider);

    return StreamBuilder<List<Label>>(
      stream: labelRepository.watchLocalLabels(widget.workspaceId),
      builder: (context, snapshot) {
        final labels = snapshot.data ?? [];

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Labels',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                TextButton.icon(
                  onPressed: () => _showCreateLabelDialog(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('New Label'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Label list
            if (labels.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.label_outline,
                        size: 48,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No labels yet',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => _showCreateLabelDialog(context),
                        child: const Text('Create your first label'),
                      ),
                    ],
                  ),
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: labels.map((label) {
                  final isSelected = _selectedIds.contains(label.id);
                  return LabelChip(
                    label: label,
                    selected: isSelected,
                    onTap: () => _toggleLabel(label.id),
                  );
                }).toList(),
              ),

            const SizedBox(height: 16),

            // Selected labels summary
            if (_selectedIds.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 8),
              Text(
                '${_selectedIds.length} label${_selectedIds.length == 1 ? '' : 's'} selected',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ],
          ],
        );
      },
    );
  }

  void _toggleLabel(String labelId) {
    setState(() {
      if (_selectedIds.contains(labelId)) {
        _selectedIds.remove(labelId);
      } else {
        _selectedIds.add(labelId);
      }
    });
    widget.onSelectionChanged(_selectedIds);
  }

  Future<void> _showCreateLabelDialog(BuildContext context) async {
    final result = await showDialog<Label>(
      context: context,
      builder: (context) => CreateLabelDialog(
        workspaceId: widget.workspaceId,
      ),
    );

    if (result != null) {
      // Automatically select the newly created label
      setState(() {
        _selectedIds.add(result.id);
      });
      widget.onSelectionChanged(_selectedIds);
    }
  }
}

/// Dialog for creating a new label
class CreateLabelDialog extends ConsumerStatefulWidget {
  final String workspaceId;
  final Label? existingLabel;

  const CreateLabelDialog({
    Key? key,
    required this.workspaceId,
    this.existingLabel,
  }) : super(key: key);

  @override
  ConsumerState<CreateLabelDialog> createState() => _CreateLabelDialogState();
}

class _CreateLabelDialogState extends ConsumerState<CreateLabelDialog> {
  late final TextEditingController _nameController;
  late Color _selectedColor;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existingLabel?.name);
    _selectedColor = widget.existingLabel?.colorValue ?? LabelColors.colors.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingLabel != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Label' : 'Create Label'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name field
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Label name',
                hintText: 'e.g., Bug, Feature, Priority',
                border: const OutlineInputBorder(),
                errorText: _errorMessage,
              ),
              textCapitalization: TextCapitalization.words,
              onChanged: (_) {
                if (_errorMessage != null) {
                  setState(() => _errorMessage = null);
                }
              },
            ),
            const SizedBox(height: 24),

            // Color picker
            ColorPicker(
              selectedColor: _selectedColor,
              onColorSelected: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
            ),

            // Preview
            const SizedBox(height: 24),
            Text(
              'Preview',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(
                _nameController.text.isEmpty ? 'Label name' : _nameController.text,
                style: TextStyle(
                  color: _getTextColor(_selectedColor),
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: _selectedColor,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        if (isEditing)
          TextButton(
            onPressed: _isLoading ? null : _deleteLabel,
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        FilledButton(
          onPressed: _isLoading ? null : _saveLabel,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEditing ? 'Save' : 'Create'),
        ),
      ],
    );
  }

  Future<void> _saveLabel() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _errorMessage = 'Label name is required');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final labelRepository = ref.read(labelRepositoryProvider);
      final colorHex = LabelColors.colorToHex(_selectedColor);

      final Label label;
      if (widget.existingLabel != null) {
        label = await labelRepository.updateLabel(
          labelId: widget.existingLabel!.id,
          name: name,
          color: colorHex,
        );
      } else {
        label = await labelRepository.createLabel(
          workspaceId: widget.workspaceId,
          name: name,
          color: colorHex,
        );
      }

      // Save to local database
      await labelRepository.saveLabelLocally(label);

      if (mounted) {
        Navigator.of(context).pop(label);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _deleteLabel() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Label'),
        content: Text(
          'Are you sure you want to delete "${widget.existingLabel!.name}"? '
          'This will remove it from all tasks.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      final labelRepository = ref.read(labelRepositoryProvider);
      await labelRepository.deleteLabel(widget.existingLabel!.id);
      await labelRepository.deleteLabelLocally(widget.existingLabel!.id);

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Color _getTextColor(Color backgroundColor) {
    final luminance =
        (0.299 * backgroundColor.r + 0.587 * backgroundColor.g + 0.114 * backgroundColor.b);
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
}

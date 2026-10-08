import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/theme_provider.dart';

class AppearanceSettingsScreen extends ConsumerStatefulWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  ConsumerState<AppearanceSettingsScreen> createState() =>
      _AppearanceSettingsScreenState();
}

class _AppearanceSettingsScreenState
    extends ConsumerState<AppearanceSettingsScreen> {
  String _accentColor = 'blue';
  double _textScale = 1.0;
  bool _compactMode = false;
  bool _showAvatars = true;
  bool _animationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appearance'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme section
          Text(
            'Theme',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  value: ThemeMode.system,
                  groupValue: themeMode,
                  onChanged: (value) {
                    ref.read(themeModeProvider.notifier).setThemeMode(value!);
                  },
                  title: const Text('System'),
                  subtitle: const Text('Follow system theme'),
                  secondary: const Icon(Icons.brightness_auto),
                ),
                const Divider(height: 1),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.light,
                  groupValue: themeMode,
                  onChanged: (value) {
                    ref.read(themeModeProvider.notifier).setThemeMode(value!);
                  },
                  title: const Text('Light'),
                  subtitle: const Text('Light theme'),
                  secondary: const Icon(Icons.light_mode),
                ),
                const Divider(height: 1),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.dark,
                  groupValue: themeMode,
                  onChanged: (value) {
                    ref.read(themeModeProvider.notifier).setThemeMode(value!);
                  },
                  title: const Text('Dark'),
                  subtitle: const Text('Dark theme'),
                  secondary: const Icon(Icons.dark_mode),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Accent color
          Text(
            'Accent Color',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _ColorOption(
                    color: Colors.blue,
                    label: 'Blue',
                    isSelected: _accentColor == 'blue',
                    onTap: () => setState(() => _accentColor = 'blue'),
                  ),
                  _ColorOption(
                    color: Colors.green,
                    label: 'Green',
                    isSelected: _accentColor == 'green',
                    onTap: () => setState(() => _accentColor = 'green'),
                  ),
                  _ColorOption(
                    color: Colors.orange,
                    label: 'Orange',
                    isSelected: _accentColor == 'orange',
                    onTap: () => setState(() => _accentColor = 'orange'),
                  ),
                  _ColorOption(
                    color: Colors.purple,
                    label: 'Purple',
                    isSelected: _accentColor == 'purple',
                    onTap: () => setState(() => _accentColor = 'purple'),
                  ),
                  _ColorOption(
                    color: Colors.pink,
                    label: 'Pink',
                    isSelected: _accentColor == 'pink',
                    onTap: () => setState(() => _accentColor = 'pink'),
                  ),
                  _ColorOption(
                    color: Colors.teal,
                    label: 'Teal',
                    isSelected: _accentColor == 'teal',
                    onTap: () => setState(() => _accentColor = 'teal'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Text size
          Text(
            'Text Size',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sample Text',
                    style: TextStyle(fontSize: 16 * _textScale),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.text_fields, size: 16),
                      Expanded(
                        child: Slider(
                          value: _textScale,
                          min: 0.8,
                          max: 1.4,
                          divisions: 6,
                          label: '${(_textScale * 100).round()}%',
                          onChanged: (value) {
                            setState(() {
                              _textScale = value;
                            });
                          },
                        ),
                      ),
                      const Icon(Icons.text_fields, size: 24),
                    ],
                  ),
                  Center(
                    child: Text(
                      '${(_textScale * 100).round()}%',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Display options
          Text(
            'Display Options',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: _compactMode,
                  onChanged: (value) {
                    setState(() {
                      _compactMode = value;
                    });
                  },
                  title: const Text('Compact Mode'),
                  subtitle: const Text('Reduce spacing and padding'),
                  secondary: const Icon(Icons.view_compact),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: _showAvatars,
                  onChanged: (value) {
                    setState(() {
                      _showAvatars = value;
                    });
                  },
                  title: const Text('Show Avatars'),
                  subtitle: const Text('Display user avatars'),
                  secondary: const Icon(Icons.account_circle),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: _animationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _animationsEnabled = value;
                    });
                  },
                  title: const Text('Animations'),
                  subtitle: const Text('Enable UI animations'),
                  secondary: const Icon(Icons.animation),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Save button
          FilledButton(
            onPressed: _saveSettings,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Appearance settings saved')),
    );
  }
}

class _ColorOption extends StatelessWidget {
  final Color color;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorOption({
    required this.color,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(color: Colors.black, width: 3)
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 32)
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
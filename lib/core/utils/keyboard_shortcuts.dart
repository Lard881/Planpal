import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Keyboard shortcuts for desktop (S16.1)
/// Common shortcuts that work across the app
class KeyboardShortcuts {
  // Global shortcuts
  static const newTask = SingleActivator(LogicalKeyboardKey.keyN, control: true);
  static const search = SingleActivator(LogicalKeyboardKey.keyK, control: true);
  static const settings = SingleActivator(LogicalKeyboardKey.comma, control: true);
  static const save = SingleActivator(LogicalKeyboardKey.keyS, control: true);
  static const close = SingleActivator(LogicalKeyboardKey.keyW, control: true);
  static const quit = SingleActivator(LogicalKeyboardKey.keyQ, control: true);
  static const refresh = SingleActivator(LogicalKeyboardKey.f5);
  
  // Navigation
  static const goHome = SingleActivator(LogicalKeyboardKey.keyH, control: true);
  static const goTasks = SingleActivator(LogicalKeyboardKey.keyT, control: true);
  static const goCalendar = SingleActivator(LogicalKeyboardKey.keyE, control: true);
  static const goDocuments = SingleActivator(LogicalKeyboardKey.keyD, control: true);
  static const goChat = SingleActivator(LogicalKeyboardKey.keyM, control: true);
  static const goTeam = SingleActivator(LogicalKeyboardKey.keyP, control: true);
  
  // Editing
  static const undo = SingleActivator(LogicalKeyboardKey.keyZ, control: true);
  static const redo = SingleActivator(LogicalKeyboardKey.keyY, control: true);
  static const copy = SingleActivator(LogicalKeyboardKey.keyC, control: true);
  static const paste = SingleActivator(LogicalKeyboardKey.keyV, control: true);
  static const selectAll = SingleActivator(LogicalKeyboardKey.keyA, control: true);
  
  // Workspace
  static const nextWorkspace = SingleActivator(LogicalKeyboardKey.tab, control: true);
  static const prevWorkspace = SingleActivator(LogicalKeyboardKey.tab, control: true, shift: true);

  /// Get keyboard shortcut label for display
  static String getShortcutLabel(SingleActivator activator) {
    final modifiers = <String>[];
    if (activator.control) modifiers.add('Ctrl');
    if (activator.shift) modifiers.add('Shift');
    if (activator.alt) modifiers.add('Alt');
    if (activator.meta) modifiers.add('Win');
    
    final key = _getKeyLabel(activator.trigger);
    modifiers.add(key);
    
    return modifiers.join(' + ');
  }

  static String _getKeyLabel(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.keyN) return 'N';
    if (key == LogicalKeyboardKey.keyK) return 'K';
    if (key == LogicalKeyboardKey.keyS) return 'S';
    if (key == LogicalKeyboardKey.keyT) return 'T';
    if (key == LogicalKeyboardKey.keyE) return 'E';
    if (key == LogicalKeyboardKey.keyD) return 'D';
    if (key == LogicalKeyboardKey.keyM) return 'M';
    if (key == LogicalKeyboardKey.keyP) return 'P';
    if (key == LogicalKeyboardKey.keyH) return 'H';
    if (key == LogicalKeyboardKey.keyW) return 'W';
    if (key == LogicalKeyboardKey.keyQ) return 'Q';
    if (key == LogicalKeyboardKey.keyZ) return 'Z';
    if (key == LogicalKeyboardKey.keyY) return 'Y';
    if (key == LogicalKeyboardKey.keyC) return 'C';
    if (key == LogicalKeyboardKey.keyV) return 'V';
    if (key == LogicalKeyboardKey.keyA) return 'A';
    if (key == LogicalKeyboardKey.comma) return ',';
    if (key == LogicalKeyboardKey.tab) return 'Tab';
    if (key == LogicalKeyboardKey.f5) return 'F5';
    return key.keyLabel;
  }
}

/// Keyboard shortcuts wrapper widget
/// Wraps the app with global keyboard shortcuts
class KeyboardShortcutsWrapper extends StatelessWidget {
  final Widget child;

  const KeyboardShortcutsWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        KeyboardShortcuts.newTask: () => _handleNewTask(context),
        KeyboardShortcuts.search: () => _handleSearch(context),
        KeyboardShortcuts.settings: () => _handleSettings(context),
        KeyboardShortcuts.goHome: () => _navigateTo(context, '/'),
        KeyboardShortcuts.goTasks: () => _navigateTo(context, '/tasks'),
        KeyboardShortcuts.goCalendar: () => _navigateTo(context, '/calendar'),
        KeyboardShortcuts.goDocuments: () => _navigateTo(context, '/documents'),
        KeyboardShortcuts.goChat: () => _navigateTo(context, '/chat'),
        KeyboardShortcuts.goTeam: () => _navigateTo(context, '/team'),
      },
      child: Focus(
        autofocus: true,
        child: child,
      ),
    );
  }

  void _handleNewTask(BuildContext context) {
    Navigator.pushNamed(context, '/tasks/new');
  }

  void _handleSearch(BuildContext context) {
    Navigator.pushNamed(context, '/search');
  }

  void _handleSettings(BuildContext context) {
    Navigator.pushNamed(context, '/settings');
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }
}

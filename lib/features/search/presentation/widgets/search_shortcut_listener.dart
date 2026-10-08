import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'search_dialog.dart';

/// Global keyboard shortcut listener for search (Ctrl+K or Cmd+K)
class SearchShortcutListener extends StatelessWidget {
  final Widget child;

  const SearchShortcutListener({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyK, control: true): () {
          _openSearch(context);
        },
        const SingleActivator(LogicalKeyboardKey.keyK, meta: true): () {
          _openSearch(context);
        },
      },
      child: Focus(
        autofocus: true,
        child: child,
      ),
    );
  }

  void _openSearch(BuildContext context) {
    SearchDialog.show(context);
  }
}

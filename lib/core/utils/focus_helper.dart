import 'package:flutter/material.dart';

/// Focus Helper - Provides consistent focus indicators and tab order management
/// for Windows desktop accessibility (S16.5)

/// Custom FocusedBorder widget that adds visible focus indicators
class FocusedBorder extends StatefulWidget {
  final Widget child;
  final Color? focusColor;
  final double borderWidth;
  final BorderRadius? borderRadius;

  const FocusedBorder({
    super.key,
    required this.child,
    this.focusColor,
    this.borderWidth = 2.0,
    this.borderRadius,
  });

  @override
  State<FocusedBorder> createState() => _FocusedBorderState();
}

class _FocusedBorderState extends State<FocusedBorder> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final focusColor = widget.focusColor ?? Theme.of(context).colorScheme.primary;
    
    return Focus(
      focusNode: _focusNode,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          border: _isFocused
              ? Border.all(
                  color: focusColor,
                  width: widget.borderWidth,
                )
              : null,
        ),
        child: widget.child,
      ),
    );
  }
}

/// OrderedFocusTraversal - Wrapper for managing tab order in forms and complex UIs
class OrderedFocusTraversal extends StatelessWidget {
  final List<OrderedFocusChild> children;
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const OrderedFocusTraversal({
    super.key,
    required this.children,
    this.direction = Axis.vertical,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: direction == Axis.vertical
          ? Column(
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              children: children.map((child) => 
                FocusTraversalOrder(
                  order: NumericFocusOrder(child.order),
                  child: child.child,
                ),
              ).toList(),
            )
          : Row(
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              children: children.map((child) => 
                FocusTraversalOrder(
                  order: NumericFocusOrder(child.order),
                  child: child.child,
                ),
              ).toList(),
            ),
    );
  }
}

/// Ordered focus child with explicit tab order
class OrderedFocusChild {
  final double order;
  final Widget child;

  const OrderedFocusChild({
    required this.order,
    required this.child,
  });
}

/// FocusableCard - Card with focus indicator for list items
class FocusableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final EdgeInsetsGeometry? padding;
  final Color? focusColor;

  const FocusableCard({
    super.key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.padding,
    this.focusColor,
  });

  @override
  State<FocusableCard> createState() => _FocusableCardState();
}

class _FocusableCardState extends State<FocusableCard> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final focusColor = widget.focusColor ?? Theme.of(context).colorScheme.primary;
    final theme = Theme.of(context);

    return Focus(
      focusNode: _focusNode,
      onKey: (node, event) {
        if (event.logicalKey.keyLabel == 'Enter' && widget.onTap != null) {
          widget.onTap!();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: () {
            _focusNode.requestFocus();
            widget.onTap?.call();
          },
          onDoubleTap: widget.onDoubleTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isFocused
                    ? focusColor
                    : theme.colorScheme.outline.withValues(alpha: 0.2),
                width: _isFocused ? 2.0 : 1.0,
              ),
              color: _isHovered
                  ? theme.colorScheme.surfaceContainerHighest
                  : theme.colorScheme.surface,
              boxShadow: _isFocused || _isHovered
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            padding: widget.padding ?? const EdgeInsets.all(16),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// Focus scope wrapper for forms
class FormFocusScope extends StatelessWidget {
  final Widget child;
  final bool autoFocus;

  const FormFocusScope({
    super.key,
    required this.child,
    this.autoFocus = true,
  });

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      autofocus: autoFocus,
      child: child,
    );
  }
}

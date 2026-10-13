// app/lib/core/widgets/planpal_text_field.dart
// Filled field: surfaceAlt bg, 44px, label above, error text, password toggle.
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../theme/app_theme.dart';

class PlanPalTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final bool obscureText;
  final bool isPassword;
  final IconData? leadingIcon;
  final Widget? trailing;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final bool enabled;
  final int maxLines;
  final FocusNode? focusNode;

  const PlanPalTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.obscureText = false,
    this.isPassword = false,
    this.leadingIcon,
    this.trailing,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onEditingComplete,
    this.enabled = true,
    this.maxLines = 1,
    this.focusNode,
  });

  @override
  State<PlanPalTextField> createState() => _PlanPalTextFieldState();
}

class _PlanPalTextFieldState extends State<PlanPalTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText || widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!,
            style: AppText.label.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: 6),
        ],
        SizedBox(
          height: widget.maxLines > 1 ? null : 44,
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            obscureText: _obscure,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            onChanged: widget.onChanged,
            onEditingComplete: widget.onEditingComplete,
            enabled: widget.enabled,
            maxLines: widget.maxLines,
            style: AppText.body.copyWith(color: c.textPrimary),
            decoration: InputDecoration(
              hintText: widget.hint,
              errorText: widget.errorText,
              prefixIcon: widget.leadingIcon != null
                  ? Icon(widget.leadingIcon, size: 18, color: c.textMuted)
                  : null,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscure ? LucideIcons.eyeOff : LucideIcons.eye,
                        size: 18, color: c.textMuted,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    )
                  : widget.trailing != null
                      ? widget.trailing
                      : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}

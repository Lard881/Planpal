import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'label.freezed.dart';
part 'label.g.dart';

@freezed
class Label with _$Label {
  const factory Label({
    required String id,
    required String name,
    required String color,
    required String workspaceId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Label;

  factory Label.fromJson(Map<String, dynamic> json) => _$LabelFromJson(json);
}

extension LabelExtension on Label {
  /// Convert hex color string to Flutter Color
  Color get colorValue {
    try {
      // Remove # if present
      String hexColor = color.replaceAll('#', '');
      
      // Add opacity if not present
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }
      
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      // Fallback to grey if invalid color
      return Colors.grey;
    }
  }

  /// Check if color is dark (for text color selection)
  bool get isDarkColor {
    final color = colorValue;
    final r = (color.r * 255.0).round().clamp(0, 255);
    final g = (color.g * 255.0).round().clamp(0, 255);
    final b = (color.b * 255.0).round().clamp(0, 255);
    final luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255;
    return luminance < 0.5;
  }

  /// Get appropriate text color for this label
  Color get textColor => isDarkColor ? Colors.white : Colors.black87;
}

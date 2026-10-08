import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'label.freezed.dart';
part 'label.g.dart';

/// Label model (matches backend API schema)
@freezed
class Label with _$Label {
  const Label._();

  const factory Label({
    required String id,
    @JsonKey(name: 'workspace_id') required String workspaceId,
    required String name,
    required String color,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
  }) = _Label;

  factory Label.fromJson(Map<String, dynamic> json) => _$LabelFromJson(json);

  /// Get color as Color object
  Color get colorValue {
    // Remove # if present and parse hex color
    final hexColor = color.replaceAll('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }
}

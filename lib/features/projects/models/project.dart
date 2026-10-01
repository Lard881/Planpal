import 'package:freezed_annotation/freezed_annotation.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@freezed
class Project with _$Project {
  const factory Project({
    required String id,
    required String workspaceId,
    required String name,
    String? description,
    String? color,
    String? icon,
    @Default(false) bool isArchived,
    int? position,
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    // Related data
    @JsonKey(includeFromJson: true, includeToJson: false) int? taskCount,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);
}

/// Extension for project helpers
extension ProjectExtension on Project {
  bool get hasIcon => icon != null && icon!.isNotEmpty;
  bool get hasColor => color != null && color!.isNotEmpty;
}

import 'dart:convert';
import 'package:drift/drift.dart';
import 'app_database.dart';

// TODO: Import model files once they're created in their respective feature modules
// import '../../features/tasks/data/models/task_model.dart';
// import '../../features/projects/data/models/project_model.dart';
// import '../../features/labels/data/models/label_model.dart';

/// Mappers to convert between Supabase models and local database models
/// 
/// Note: TaskModel, ProjectModel, and LabelModel conversions are commented out
/// until those models are created in their respective feature modules.
/// For now, use JSON conversion methods for sync operations.
class EntityMappers {
  // ============================================================================
  // Task Mappers
  // ============================================================================

  // TODO: Uncomment these methods once TaskModel is created
  /*
  /// Convert TaskModel (from Supabase) to LocalTask (for local database)
  static LocalTask taskModelToLocal(TaskModel task) {
    return LocalTask(
      id: task.id,
      workspaceId: task.workspaceId,
      projectId: task.projectId,
      title: task.title,
      description: task.description,
      status: task.status,
      priority: task.priority,
      dueDate: task.dueDate,
      assigneeId: task.assigneeId,
      position: task.position,
      labelIds: task.labelIds != null ? jsonEncode(task.labelIds) : null,
      createdBy: task.createdBy,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt ?? task.createdAt,
      deletedAt: task.deletedAt,
      isSynced: true,
    );
  }

  /// Convert LocalTask to TaskModel
  static TaskModel localTaskToModel(LocalTask task) {
    return TaskModel(
      id: task.id,
      workspaceId: task.workspaceId,
      projectId: task.projectId,
      title: task.title,
      description: task.description,
      status: task.status,
      priority: task.priority,
      dueDate: task.dueDate,
      assigneeId: task.assigneeId,
      position: task.position,
      labelIds: task.labelIds != null 
          ? List<String>.from(jsonDecode(task.labelIds!))
          : null,
      createdBy: task.createdBy,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
      deletedAt: task.deletedAt,
      project: null, // Will be populated separately if needed
      assignee: null, // Will be populated separately if needed
    );
  }
  */

  /// Convert JSON map to LocalTask
  static LocalTask jsonToLocalTask(Map<String, dynamic> json) {
    return LocalTask(
      id: json['id'] as String,
      workspaceId: json['workspace_id'] as String,
      projectId: json['project_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'todo',
      priority: json['priority'] as String?,
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date'] as String) : null,
      assigneeId: json['assignee_id'] as String?,
      position: json['position'] as int? ?? 0,
      labelIds: json['label_ids'] != null ? jsonEncode(json['label_ids']) : null,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.parse(json['created_at'] as String),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
      isSynced: true,
    );
  }

  /// Convert LocalTask to JSON map
  static Map<String, dynamic> localTaskToJson(LocalTask task) {
    return {
      'id': task.id,
      'workspace_id': task.workspaceId,
      'project_id': task.projectId,
      'title': task.title,
      'description': task.description,
      'status': task.status,
      'priority': task.priority,
      'due_date': task.dueDate?.toIso8601String(),
      'assignee_id': task.assigneeId,
      'position': task.position,
      'label_ids': task.labelIds != null ? jsonDecode(task.labelIds!) : null,
      'created_by': task.createdBy,
      'created_at': task.createdAt.toIso8601String(),
      'updated_at': task.updatedAt.toIso8601String(),
      'deleted_at': task.deletedAt?.toIso8601String(),
    };
  }

  // ============================================================================
  // Project Mappers
  // ============================================================================

  // TODO: Uncomment these methods once ProjectModel is created
  /*
  /// Convert ProjectModel to LocalProject
  static LocalProject projectModelToLocal(ProjectModel project) {
    return LocalProject(
      id: project.id,
      workspaceId: project.workspaceId,
      name: project.name,
      description: project.description,
      color: project.color,
      isFavorite: project.isFavorite ?? false,
      createdBy: project.createdBy,
      createdAt: project.createdAt,
      updatedAt: project.updatedAt ?? project.createdAt,
      deletedAt: project.deletedAt,
      isSynced: true,
    );
  }

  /// Convert LocalProject to ProjectModel
  static ProjectModel localProjectToModel(LocalProject project) {
    return ProjectModel(
      id: project.id,
      workspaceId: project.workspaceId,
      name: project.name,
      description: project.description,
      color: project.color,
      isFavorite: project.isFavorite,
      createdBy: project.createdBy,
      createdAt: project.createdAt,
      updatedAt: project.updatedAt,
      deletedAt: project.deletedAt,
    );
  }
  */

  /// Convert JSON map to LocalProject
  static LocalProject jsonToLocalProject(Map<String, dynamic> json) {
    return LocalProject(
      id: json['id'] as String,
      workspaceId: json['workspace_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      color: json['color'] as String?,
      isFavorite: json['is_favorite'] as bool? ?? false,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.parse(json['created_at'] as String),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
      isSynced: true,
    );
  }

  /// Convert LocalProject to JSON map
  static Map<String, dynamic> localProjectToJson(LocalProject project) {
    return {
      'id': project.id,
      'workspace_id': project.workspaceId,
      'name': project.name,
      'description': project.description,
      'color': project.color,
      'is_favorite': project.isFavorite,
      'created_by': project.createdBy,
      'created_at': project.createdAt.toIso8601String(),
      'updated_at': project.updatedAt.toIso8601String(),
      'deleted_at': project.deletedAt?.toIso8601String(),
    };
  }

  // ============================================================================
  // Label Mappers
  // ============================================================================

  // TODO: Uncomment these methods once LabelModel is created
  /*
  /// Convert LabelModel to LocalLabel
  static LocalLabel labelModelToLocal(LabelModel label) {
    return LocalLabel(
      id: label.id,
      workspaceId: label.workspaceId,
      name: label.name,
      color: label.color,
      createdBy: label.createdBy,
      createdAt: label.createdAt,
      updatedAt: label.updatedAt ?? label.createdAt,
      deletedAt: label.deletedAt,
      isSynced: true,
    );
  }

  /// Convert LocalLabel to LabelModel
  static LabelModel localLabelToModel(LocalLabel label) {
    return LabelModel(
      id: label.id,
      workspaceId: label.workspaceId,
      name: label.name,
      color: label.color,
      createdBy: label.createdBy,
      createdAt: label.createdAt,
      updatedAt: label.updatedAt,
      deletedAt: label.deletedAt,
    );
  }
  */

  /// Convert JSON map to LocalLabel
  static LocalLabel jsonToLocalLabel(Map<String, dynamic> json) {
    return LocalLabel(
      id: json['id'] as String,
      workspaceId: json['workspace_id'] as String,
      name: json['name'] as String,
      color: json['color'] as String,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.parse(json['created_at'] as String),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
      isSynced: true,
    );
  }

  /// Convert LocalLabel to JSON map
  static Map<String, dynamic> localLabelToJson(LocalLabel label) {
    return {
      'id': label.id,
      'workspace_id': label.workspaceId,
      'name': label.name,
      'color': label.color,
      'created_by': label.createdBy,
      'created_at': label.createdAt.toIso8601String(),
      'updated_at': label.updatedAt.toIso8601String(),
      'deleted_at': label.deletedAt?.toIso8601String(),
    };
  }

  // ============================================================================
  // Generic Entity Mapper
  // ============================================================================

  /// Convert sync change data to appropriate local entity
  static dynamic jsonToLocalEntity(String entityType, Map<String, dynamic> json) {
    switch (entityType) {
      case 'task':
        return jsonToLocalTask(json);
      case 'project':
        return jsonToLocalProject(json);
      case 'label':
        return jsonToLocalLabel(json);
      default:
        throw ArgumentError('Unknown entity type: $entityType');
    }
  }

  /// Convert local entity to JSON map
  static Map<String, dynamic> localEntityToJson(String entityType, dynamic entity) {
    switch (entityType) {
      case 'task':
        return localTaskToJson(entity as LocalTask);
      case 'project':
        return localProjectToJson(entity as LocalProject);
      case 'label':
        return localLabelToJson(entity as LocalLabel);
      default:
        throw ArgumentError('Unknown entity type: $entityType');
    }
  }

  // ============================================================================
  // Batch Conversion Helpers
  // ============================================================================

  // TODO: Uncomment these methods once model classes are created
  /*
  /// Convert list of TaskModels to LocalTasks
  static List<LocalTask> taskModelsToLocal(List<TaskModel> tasks) {
    return tasks.map(taskModelToLocal).toList();
  }

  /// Convert list of LocalTasks to TaskModels
  static List<TaskModel> localTasksToModels(List<LocalTask> tasks) {
    return tasks.map(localTaskToModel).toList();
  }

  /// Convert list of ProjectModels to LocalProjects
  static List<LocalProject> projectModelsToLocal(List<ProjectModel> projects) {
    return projects.map(projectModelToLocal).toList();
  }

  /// Convert list of LocalProjects to ProjectModels
  static List<ProjectModel> localProjectsToModels(List<LocalProject> projects) {
    return projects.map(localProjectToModel).toList();
  }

  /// Convert list of LabelModels to LocalLabels
  static List<LocalLabel> labelModelsToLocal(List<LabelModel> labels) {
    return labels.map(labelModelToLocal).toList();
  }

  /// Convert list of LocalLabels to LabelModels
  static List<LabelModel> localLabelsToModels(List<LocalLabel> labels) {
    return labels.map(localLabelToModel).toList();
  }
  */
}

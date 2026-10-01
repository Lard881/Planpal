import 'package:drift/drift.dart';
import '../../../core/db/app_database.dart';
import '../../../core/network/api_client.dart';
import '../models/project.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class ProjectRepository {
  final AppDatabase _db;
  final ApiClient _api;

  ProjectRepository({
    required AppDatabase database,
    required ApiClient apiClient,
  })  : _db = database,
        _api = apiClient;

  // ========================================================================
  // Local database operations
  // ========================================================================

  /// Watch all projects for a workspace
  Stream<List<ProjectData>> watchProjects(String workspaceId, {bool includeArchived = false}) {
    final query = _db.select(_db.projects)
      ..where((p) => p.workspaceId.equals(workspaceId))
      ..where((p) => p.deletedAt.isNull());

    if (!includeArchived) {
      query.where((p) => p.isArchived.equals(false));
    }

    query.orderBy([(p) => OrderingTerm.asc(p.position)]);

    return query.watch();
  }

  /// Get a single project
  Future<ProjectData?> getProject(String id) {
    return (_db.select(_db.projects)
          ..where((p) => p.id.equals(id))
          ..where((p) => p.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Watch a single project
  Stream<ProjectData?> watchProject(String id) {
    return (_db.select(_db.projects)
          ..where((p) => p.id.equals(id))
          ..where((p) => p.deletedAt.isNull()))
        .watchSingleOrNull();
  }

  // ========================================================================
  // Create, Update, Delete
  // ========================================================================

  /// Create a new project
  Future<ProjectData> createProject({
    required String workspaceId,
    required String name,
    String? description,
    String? color,
    String? icon,
  }) async {
    final projectId = _uuid.v4();
    final now = DateTime.now();

    final project = ProjectsCompanion.insert(
      id: Value(projectId),
      workspaceId: workspaceId,
      name: name,
      description: Value(description),
      color: Value(color),
      icon: Value(icon),
      createdBy: 'current-user-id', // TODO: Get from auth
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    await _db.into(_db.projects).insert(project);

    // Queue for sync
    await _queueOutbox(
      entity: 'project',
      entityId: projectId,
      action: 'create',
      payload: {
        'id': projectId,
        'workspace_id': workspaceId,
        'name': name,
        'description': description,
        'color': color,
        'icon': icon,
      },
    );

    return (await getProject(projectId))!;
  }

  /// Update a project
  Future<void> updateProject(String projectId, ProjectsCompanion updates) async {
    await (_db.update(_db.projects)..where((p) => p.id.equals(projectId)))
        .write(updates.copyWith(updatedAt: Value(DateTime.now())));

    // Queue for sync
    await _queueOutbox(
      entity: 'project',
      entityId: projectId,
      action: 'update',
      payload: updates.toJson(),
    );
  }

  /// Delete a project
  Future<void> deleteProject(String projectId) async {
    await (_db.update(_db.projects)..where((p) => p.id.equals(projectId))).write(
      ProjectsCompanion(
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );

    // Queue for sync
    await _queueOutbox(
      entity: 'project',
      entityId: projectId,
      action: 'delete',
      payload: {},
    );
  }

  /// Archive/unarchive a project
  Future<void> archiveProject(String projectId, bool isArchived) async {
    await (_db.update(_db.projects)..where((p) => p.id.equals(projectId))).write(
      ProjectsCompanion(
        isArchived: Value(isArchived),
        updatedAt: Value(DateTime.now()),
      ),
    );

    // Queue for sync
    await _queueOutbox(
      entity: 'project',
      entityId: projectId,
      action: 'update',
      payload: {'is_archived': isArchived},
    );
  }

  // ========================================================================
  // API operations
  // ========================================================================

  /// Fetch projects from API
  Future<List<Project>> fetchProjects({
    required String workspaceId,
    bool? isArchived,
    int page = 1,
    int limit = 50,
  }) async {
    final queryParams = <String, String>{
      'workspace_id': workspaceId,
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (isArchived != null) {
      queryParams['is_archived'] = isArchived.toString();
    }

    final response = await _api.get('/projects', queryParams: queryParams);
    final projects = (response.data['projects'] as List)
        .map((json) => Project.fromJson(json as Map<String, dynamic>))
        .toList();

    return projects;
  }

  // ========================================================================
  // Helpers
  // ========================================================================

  Future<void> _queueOutbox({
    required String entity,
    required String entityId,
    required String action,
    required Map<String, dynamic> payload,
  }) async {
    await _db.outboxDao.insert(OutboxCompanion.insert(
      entity: entity,
      entityId: entityId,
      action: action,
      payload: payload.toString(),
      createdAt: Value(DateTime.now()),
    ));
  }
}

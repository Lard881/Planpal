import 'package:drift/drift.dart';
import '../../../core/db/app_database.dart';
import '../models/search_result.dart';

/// Offline search service using local Drift database
/// Provides search functionality when network is unavailable
class OfflineSearchService {
  final AppDatabase database;

  OfflineSearchService({required this.database});

  /// Search tasks, documents, and people in local database
  Future<SearchResults> search({
    required String query,
    String type = 'all',
    String? workspaceId,
    int limit = 20,
    int offset = 0,
  }) async {
    final lowerQuery = query.toLowerCase();

    // Search tasks
    final taskResults = (type == 'all' || type == 'tasks')
        ? await _searchTasks(lowerQuery, workspaceId, limit)
        : <Map<String, dynamic>>[];

    // Search documents (not implemented yet - will be added in documents stage)
    final documentResults = <Map<String, dynamic>>[];

    // Search people
    final peopleResults = (type == 'all' || type == 'people')
        ? await _searchPeople(lowerQuery, workspaceId, limit)
        : <Map<String, dynamic>>[];

    final totalCount = taskResults.length + documentResults.length + peopleResults.length;

    return SearchResults(
      query: query,
      type: type,
      workspaceId: workspaceId,
      totalCount: totalCount,
      tasks: SearchResultsGroup(
        items: taskResults,
        count: taskResults.length,
      ),
      documents: SearchResultsGroup(
        items: documentResults,
        count: documentResults.length,
      ),
      people: SearchResultsGroup(
        items: peopleResults,
        count: peopleResults.length,
      ),
    );
  }

  /// Search tasks in local database
  Future<List<Map<String, dynamic>>> _searchTasks(
    String query,
    String? workspaceId,
    int limit,
  ) async {
    final tasksTable = database.tasks;
    final workspacesTable = database.workspaces;

    // Build query
    final taskQuery = database.select(tasksTable).join([
      leftOuterJoin(
        workspacesTable,
        workspacesTable.id.equalsExp(tasksTable.workspaceId),
      ),
    ]);

    // Apply filters
    taskQuery.where(
      tasksTable.deletedAt.isNull() &
      (tasksTable.title.lower().like('%$query%') |
       tasksTable.description.lower().like('%$query%')),
    );

    if (workspaceId != null) {
      taskQuery.where(tasksTable.workspaceId.equals(workspaceId));
    }

    // Limit results
    taskQuery.limit(limit);

    // Execute query
    final results = await taskQuery.get();

    // Convert to search result format
    return results.map((row) {
      final task = row.readTable(tasksTable);
      final workspace = row.readTableOrNull(workspacesTable);

      // Calculate match score
      final matchScore = _calculateMatchScore(
        query,
        task.title,
        task.description,
      );

      return {
        'id': task.id,
        'title': task.title,
        'description': task.description,
        'status': task.status,
        'priority': task.priority,
        'dueDate': task.dueAt?.toIso8601String(),
        'workspaceId': task.workspaceId,
        'workspaceName': workspace?.name,
        'projectId': null, // Not stored in local DB yet
        'assignedTo': task.assigneeId,
        'createdAt': task.createdAt.toIso8601String(),
        'matchScore': matchScore,
      };
    }).toList();
  }

  /// Search people in local database
  Future<List<Map<String, dynamic>>> _searchPeople(
    String query,
    String? workspaceId,
    int limit,
  ) async {
    final profilesTable = database.profiles;
    final membersTable = database.workspaceMembers;
    final workspacesTable = database.workspaces;

    // Build query - join profiles with workspace members
    final peopleQuery = database.select(profilesTable).join([
      innerJoin(
        membersTable,
        membersTable.userId.equalsExp(profilesTable.id),
      ),
      leftOuterJoin(
        workspacesTable,
        workspacesTable.id.equalsExp(membersTable.workspaceId),
      ),
    ]);

    // Apply filters
    peopleQuery.where(
      profilesTable.deletedAt.isNull() &
      (profilesTable.fullName.lower().like('%$query%') |
       profilesTable.email.lower().like('%$query%')),
    );

    if (workspaceId != null) {
      peopleQuery.where(membersTable.workspaceId.equals(workspaceId));
    }

    // Execute query
    final results = await peopleQuery.get();

    // Deduplicate by user ID and collect all workspaces
    final peopleMap = <String, Map<String, dynamic>>{};

    for (final row in results) {
      final profile = row.readTable(profilesTable);
      final member = row.readTable(membersTable);
      final workspace = row.readTableOrNull(workspacesTable);

      if (!peopleMap.containsKey(profile.id)) {
        // Calculate match score
        final matchScore = _calculateMatchScore(
          query,
          profile.fullName,
          profile.email,
        );

        peopleMap[profile.id] = {
          'id': profile.id,
          'fullName': profile.fullName,
          'email': profile.email,
          'avatarUrl': profile.avatarUrl,
          'workspaces': <Map<String, dynamic>>[],
          'matchScore': matchScore,
        };
      }

      // Add workspace info
      if (workspace != null) {
        final workspaces = peopleMap[profile.id]!['workspaces'] as List<Map<String, dynamic>>;
        workspaces.add({
          'id': workspace.id,
          'name': workspace.name,
          'role': member.role,
        });
      }
    }

    // Convert to list and apply limit
    return peopleMap.values.take(limit).toList();
  }

  /// Calculate match score for search results
  /// Similar to backend algorithm but simplified for local search
  int _calculateMatchScore(String query, String title, String? description) {
    final lowerQuery = query.toLowerCase();
    final lowerTitle = title.toLowerCase();
    final lowerDesc = (description ?? '').toLowerCase();

    // Exact match in title = 100
    if (lowerTitle == lowerQuery) return 100;

    // Title starts with query = 80
    if (lowerTitle.startsWith(lowerQuery)) return 80;

    // Title contains query = 50
    if (lowerTitle.contains(lowerQuery)) return 50;

    // Title word starts with query = 30
    if (lowerTitle.split(' ').any((word) => word.startsWith(lowerQuery))) {
      return 30;
    }

    // Description contains query = 20
    if (lowerDesc.contains(lowerQuery)) return 20;

    // Fallback
    return 10;
  }

  /// Check if offline search is available
  /// (Always true since we're using local DB)
  bool get isAvailable => true;

  /// Get count of searchable items in local database
  Future<Map<String, int>> getSearchableCounts({String? workspaceId}) async {
    final tasksCount = await _countTasks(workspaceId);
    final peopleCount = await _countPeople(workspaceId);

    return {
      'tasks': tasksCount,
      'documents': 0, // Not implemented yet
      'people': peopleCount,
      'total': tasksCount + peopleCount,
    };
  }

  Future<int> _countTasks(String? workspaceId) async {
    final query = database.selectOnly(database.tasks)
      ..addColumns([database.tasks.id.count()])
      ..where(database.tasks.deletedAt.isNull());

    if (workspaceId != null) {
      query.where(database.tasks.workspaceId.equals(workspaceId));
    }

    final result = await query.getSingle();
    return result.read(database.tasks.id.count()) ?? 0;
  }

  Future<int> _countPeople(String? workspaceId) async {
    final membersTable = database.workspaceMembers;
    final profilesTable = database.profiles;

    final query = database.selectOnly(membersTable).join([
      innerJoin(
        profilesTable,
        profilesTable.id.equalsExp(membersTable.userId),
      ),
    ])
      ..addColumns([membersTable.userId.count(distinct: true)])
      ..where(profilesTable.deletedAt.isNull());

    if (workspaceId != null) {
      query.where(membersTable.workspaceId.equals(workspaceId));
    }

    final result = await query.getSingle();
    return result.read(membersTable.userId.count(distinct: true)) ?? 0;
  }
}

import 'package:drift/drift.dart';
import '../../../core/db/app_database.dart';
import '../../../core/network/api_client.dart';
import '../models/label.dart' as model;

class LabelRepository {
  final AppDatabase _db;
  final ApiClient _api;

  LabelRepository(this._db, this._api);

  // ==================== Remote API Methods ====================

  /// Fetch all labels for a workspace from the API
  Future<List<model.Label>> fetchLabels(String workspaceId) async {
    final response = await _api.get('/labels', queryParameters: {
      'workspace_id': workspaceId,
    });

    final List<dynamic> data = response.data['data'] as List<dynamic>;
    return data.map((json) => model.Label.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Create a new label
  Future<model.Label> createLabel({
    required String workspaceId,
    required String name,
    required String color,
  }) async {
    final response = await _api.post('/labels', data: {
      'workspace_id': workspaceId,
      'name': name,
      'color': color,
    });

    return model.Label.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// Update an existing label
  Future<model.Label> updateLabel({
    required String labelId,
    String? name,
    String? color,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (color != null) body['color'] = color;

    final response = await _api.patch('/labels/$labelId', data: body);

    return model.Label.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// Delete a label
  Future<void> deleteLabel(String labelId) async {
    await _api.delete('/labels/$labelId');
  }

  /// Get labels for a specific task
  Future<List<model.Label>> fetchTaskLabels(String taskId) async {
    final response = await _api.get('/tasks/$taskId/labels');

    final List<dynamic> data = response.data['data'] as List<dynamic>;
    return data.map((json) => model.Label.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Add a label to a task
  Future<model.Label> addLabelToTask({
    required String taskId,
    required String labelId,
  }) async {
    final response = await _api.post('/tasks/$taskId/labels', data: {
      'labelId': labelId,
    });

    return model.Label.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// Remove a label from a task
  Future<void> removeLabelFromTask({
    required String taskId,
    required String labelId,
  }) async {
    await _api.delete('/tasks/$taskId/labels/$labelId');
  }

  /// Replace all labels for a task
  Future<List<model.Label>> updateTaskLabels({
    required String taskId,
    required List<String> labelIds,
  }) async {
    final response = await _api.put('/tasks/$taskId/labels', data: {
      'labelIds': labelIds,
    });

    final List<dynamic> data = response.data['data'] as List<dynamic>;
    return data.map((json) => model.Label.fromJson(json as Map<String, dynamic>)).toList();
  }

  // ==================== Local Database Methods ====================

  /// Get all labels for a workspace from local database
  Stream<List<model.Label>> watchLocalLabels(String workspaceId) {
    final query = _db.select(_db.labels)
      ..where((tbl) => tbl.workspaceId.equals(workspaceId))
      ..orderBy([
        (tbl) => OrderingTerm.asc(tbl.name),
      ]);

    return query.watch().map((rows) => rows.map((row) => _labelFromDb(row)).toList());
  }

  /// Get labels for a task from local database
  Stream<List<model.Label>> watchLocalTaskLabels(String taskId) {
    final query = _db.select(_db.labels).join([
      innerJoin(
        _db.taskLabels,
        _db.taskLabels.labelId.equalsExp(_db.labels.id),
      ),
    ])
      ..where(_db.taskLabels.taskId.equals(taskId))
      ..orderBy([
        OrderingTerm.asc(_db.labels.name),
      ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final label = row.readTable(_db.labels);
        return _labelFromDb(label);
      }).toList();
    });
  }

  /// Get a single label by ID from local database
  Future<model.Label?> getLocalLabel(String labelId) async {
    final query = _db.select(_db.labels)
      ..where((tbl) => tbl.id.equals(labelId));

    final row = await query.getSingleOrNull();
    return row != null ? _labelFromDb(row) : null;
  }

  /// Save labels to local database (upsert)
  Future<void> saveLabelsLocally(List<model.Label> labels) async {
    await _db.batch((batch) {
      for (final label in labels) {
        batch.insert(
          _db.labels,
          _labelToDb(label),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// Save a single label to local database
  Future<void> saveLabelLocally(model.Label label) async {
    await _db.into(_db.labels).insertOnConflictUpdate(_labelToDb(label));
  }

  /// Delete a label from local database
  Future<void> deleteLabelLocally(String labelId) async {
    await (_db.delete(_db.labels)..where((tbl) => tbl.id.equals(labelId))).go();
    
    // Also delete task-label associations
    await (_db.delete(_db.taskLabels)..where((tbl) => tbl.labelId.equals(labelId))).go();
  }

  /// Save task-label associations locally
  Future<void> saveTaskLabelsLocally(String taskId, List<String> labelIds) async {
    // Delete existing associations for this task
    await (_db.delete(_db.taskLabels)..where((tbl) => tbl.taskId.equals(taskId))).go();

    // Insert new associations
    if (labelIds.isNotEmpty) {
      await _db.batch((batch) {
        for (final labelId in labelIds) {
          batch.insert(
            _db.taskLabels,
            TaskLabelsCompanion.insert(
              taskId: taskId,
              labelId: labelId,
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      });
    }
  }

  /// Add a label to a task locally
  Future<void> addTaskLabelLocally(String taskId, String labelId) async {
    await _db.into(_db.taskLabels).insert(
      TaskLabelsCompanion.insert(
        taskId: taskId,
        labelId: labelId,
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// Remove a label from a task locally
  Future<void> removeTaskLabelLocally(String taskId, String labelId) async {
    await (_db.delete(_db.taskLabels)
          ..where((tbl) => tbl.taskId.equals(taskId) & tbl.labelId.equals(labelId)))
        .go();
  }

  // ==================== Helper Methods ====================

  /// Convert database row to model
  model.Label _labelFromDb(Label dbLabel) {
    return model.Label(
      id: dbLabel.id,
      name: dbLabel.name,
      color: dbLabel.color,
      workspaceId: dbLabel.workspaceId,
      createdAt: dbLabel.createdAt,
      updatedAt: dbLabel.updatedAt,
    );
  }

  /// Convert model to database companion
  LabelsCompanion _labelToDb(model.Label label) {
    return LabelsCompanion.insert(
      id: label.id,
      name: label.name,
      color: label.color,
      workspaceId: label.workspaceId,
      createdAt: label.createdAt,
      updatedAt: label.updatedAt,
    );
  }

  // ==================== Sync Support Methods ====================

  /// Get all labels modified since a timestamp
  Future<List<model.Label>> getLabelsModifiedSince(
    String workspaceId,
    DateTime since,
  ) async {
    final query = _db.select(_db.labels)
      ..where((tbl) =>
          tbl.workspaceId.equals(workspaceId) &
          tbl.updatedAt.isBiggerThanValue(since))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.updatedAt)]);

    final rows = await query.get();
    return rows.map((row) => _labelFromDb(row)).toList();
  }

  /// Get last sync timestamp for labels
  Future<DateTime?> getLastLabelsSyncTime(String workspaceId) async {
    final query = _db.select(_db.labels)
      ..where((tbl) => tbl.workspaceId.equals(workspaceId))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)])
      ..limit(1);

    final row = await query.getSingleOrNull();
    return row?.updatedAt;
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/features/tasks/data/task_repository.dart';

void main() {
  test('parses successful and failed IDs from the backend response', () {
    final result = BulkTaskActionResult.fromJson({
      'succeeded': ['task-1', 'task-2'],
      'failed': [
        {'id': 'task-3', 'code': 'OPERATION_FAILED'},
      ],
    });

    expect(result.succeededIds, ['task-1', 'task-2']);
    expect(result.failedIds, ['task-3']);
    expect(result.failure, isNull);
  });
}

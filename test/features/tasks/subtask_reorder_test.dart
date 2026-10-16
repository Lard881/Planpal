import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/features/tasks/models/task_model.dart';

void main() {
  test('reorders subtasks and rewrites their positions', () {
    final subtasks = [_subtask('a', 0), _subtask('b', 1), _subtask('c', 2)];

    final reordered = reorderSubtaskList(subtasks, 0, 2);

    expect(reordered.map((subtask) => subtask.id), ['b', 'c', 'a']);
    expect(reordered.map((subtask) => subtask.position), [0, 1, 2]);
    expect(subtasks.map((subtask) => subtask.id), ['a', 'b', 'c']);
  });

  test('keeps order when drag starts and ends at the same index', () {
    final subtasks = [_subtask('a', 0), _subtask('b', 1)];

    final reordered = reorderSubtaskList(subtasks, 1, 1);

    expect(reordered.map((subtask) => subtask.id), ['a', 'b']);
    expect(reordered.map((subtask) => subtask.position), [0, 1]);
  });
}

SubtaskModel _subtask(String id, int position) => SubtaskModel(
  id: id,
  taskId: 'task-1',
  title: 'Subtask $id',
  position: position,
);

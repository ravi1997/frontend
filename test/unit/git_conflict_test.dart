import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/forms/services/git_controller.dart';

void main() {
  group('GitConflict parsing tests', () {
    test('parses conflict descriptor correctly with base value', () {
      final json = {
        'path': '/sections/0/questions/1/label',
        'mine': 'Name (Mine)',
        'theirs': 'Name (Theirs)',
        'base': 'Name (Base)',
        'mine_op': 'replace',
        'theirs_op': 'replace'
      };

      final conflict = GitConflict.fromJson(json);

      expect(conflict.path, '/sections/0/questions/1/label');
      expect(conflict.mine, 'Name (Mine)');
      expect(conflict.theirs, 'Name (Theirs)');
      expect(conflict.base, 'Name (Base)');
      expect(conflict.mineOp, 'replace');
      expect(conflict.theirsOp, 'replace');
    });

    test('parses conflict descriptor correctly with null fields', () {
      final json = {
        'path': '/sections/0/name',
        'mine': null,
        'theirs': 'New Section Name',
        'base': 'Old Section Name',
        'mine_op': 'remove',
        'theirs_op': 'replace'
      };

      final conflict = GitConflict.fromJson(json);

      expect(conflict.path, '/sections/0/name');
      expect(conflict.mine, isNull);
      expect(conflict.theirs, 'New Section Name');
      expect(conflict.base, 'Old Section Name');
      expect(conflict.mineOp, 'remove');
      expect(conflict.theirsOp, 'replace');
    });
  });
}

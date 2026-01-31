import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/form_builder/domain/entities/builder_form.dart';
import 'package:frontend/features/form_builder/domain/entities/form_version_history.dart';

void main() {
  group('BuilderForm Versioning', () {
    test('should have initial version 1.0.0', () {
      final form = BuilderForm(id: '1', title: 'Test Form', sections: []);

      expect(form.version, '1.0.0');
      expect(form.versionHistory, isEmpty);
    });

    test('should support version history entries', () {
      final history = FormVersionHistory(
        version: '1.0.1',
        createdAt: DateTime.now(),
        changeLog: 'Minor fix',
      );

      final form = BuilderForm(
        id: '1',
        title: 'Test Form',
        sections: [],
        versionHistory: [history],
      );

      expect(form.versionHistory.length, 1);
      expect(form.versionHistory.first.version, '1.0.1');
    });
  });
}

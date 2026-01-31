import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/form_builder/domain/entities/builder_form.dart';
import 'package:frontend/features/form_builder/domain/services/workflow_executor.dart';

void main() {
  group('WorkflowExecutor', () {
    test('should skip execution if no workflows defined', () async {
      final executor = WorkflowExecutorImpl();
      final form = BuilderForm(
        id: '1',
        title: 'Test Form',
        sections: [],
        workflows: {},
      );

      await executor.execute(form, {'test': 'data'});
      // Should complete without error
    });

    test('should process email workflow if enabled', () async {
      final executor = WorkflowExecutorImpl();
      final form = BuilderForm(
        id: '1',
        title: 'Test Form',
        sections: [],
        workflows: {
          'email_notification': {
            'enabled': true,
            'recipient': 'test@example.com',
          },
        },
      );

      await executor.execute(form, {'test': 'data'});
      // Verification is via debug logs currently, but we ensure it runs
    });
  });
}

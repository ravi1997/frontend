import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/form_builder/utility/form_logic_engine.dart';
import 'package:frontend/core/form_models.dart';

void main() {
  group('FormLogicEngine', () {
    test('Calculated expression A + B works', () {
      final questionA = Question(id: 'qA', fieldType: 'number', label: 'A');
      final questionB = Question(id: 'qB', fieldType: 'number', label: 'B');
      final questionC = Question(
        id: 'qC',
        fieldType: 'number',
        label: 'C',
        metadata: {
          'conditional_logic': {
            'rules': [
              {
                'action': 'calculate',
                'expression': '{qA} + {qB}',
                'conditionGroup': {
                  'matchType': 'and',
                  'rules': [
                    {'triggerId': 'qA', 'operator': 'is_not_empty', 'value': ''}
                  ]
                }
              }
            ]
          }
        },
      );

      final form = Form(
        id: '1',
        title: 'Form',
        slug: 'form',
        organizationId: 'org1',
        createdBy: 'user1',
        activeVersion: '1.0.0',
        sections: [
          FormSection(
            id: 's1',
            title: 'S1',
            questions: [questionA, questionB, questionC],
          ),
        ],
        versions: [
          FormVersion(
            id: 'v1',
            version: '1.0.0',
            sections: [
              FormSection(
                id: 's1',
                title: 'S1',
                questions: [questionA, questionB, questionC],
              ),
            ],
          ),
        ],
      );

      final result = FormLogicEngine.evaluate(form, {'qA': 5, 'qB': 10});
      expect(result.valueOverrides['qC'], 15);
    });

    test('Cycle detection avoids infinite loop', () {
      // Simulate A depends on B, B depends on A
      final qA = Question(
        id: 'qA',
        fieldType: 'number',
        label: 'A',
        metadata: {
          'conditional_logic': {
            'rules': [
              {
                'action': 'calculate',
                'expression': '{qB} + 1',
                'conditionGroup': {
                  'rules': [
                    {'triggerId': 'qB', 'operator': 'is_not_empty', 'value': ''}
                  ]
                }
              }
            ]
          }
        },
      );
      final qB = Question(
        id: 'qB',
        fieldType: 'number',
        label: 'B',
        metadata: {
          'conditional_logic': {
            'rules': [
              {
                'action': 'calculate',
                'expression': '{qA} + 1',
                'conditionGroup': {
                  'rules': [
                    {'triggerId': 'qA', 'operator': 'is_not_empty', 'value': ''}
                  ]
                }
              }
            ]
          }
        },
      );

      final form = Form(
        id: '1',
        title: 'Form',
        slug: 'form',
        organizationId: 'org1',
        createdBy: 'user1',
        activeVersion: '1.0.0',
        sections: [
          FormSection(
            id: 's1',
            title: 'S1',
            questions: [qA, qB],
          ),
        ],
        versions: [
          FormVersion(
            id: 'v1',
            version: '1.0.0',
            sections: [
              FormSection(
                id: 's1',
                title: 'S1',
                questions: [qA, qB],
              ),
            ],
          ),
        ],
      );

      // Should not throw, should evaluate to some fallback or partial state
      final result = FormLogicEngine.evaluate(form, {'qA': 1, 'qB': 1});
      expect(result.valueOverrides, isNotNull);
    });
  });
}

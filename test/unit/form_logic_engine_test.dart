import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/form_builder/presentation/utils/form_logic_engine.dart';
import 'package:frontend/features/form_builder/domain/entities/builder_form.dart';
import 'package:frontend/features/form_builder/domain/entities/form_section.dart';
import 'package:frontend/features/form_builder/domain/entities/form_question.dart';
import 'package:frontend/features/form_builder/domain/entities/question_type.dart';

void main() {
  group('FormLogicEngine', () {
    test('Calculated expression A + B works', () {
      final questionA = FormQuestion(id: 'qA', type: QuestionType.number, label: 'A');
      final questionB = FormQuestion(id: 'qB', type: QuestionType.number, label: 'B');
      final questionC = FormQuestion(
        id: 'qC',
        type: QuestionType.number,
        label: 'C',
        conditionalLogic: {
          'rules': [
            {
              'action': 'calculate',
              'expression': '{qA} + {qB}',
              'conditionGroup': {
                'matchType': 'and',
                'rules': [{'triggerId': 'qA', 'operator': 'is_not_empty', 'value': ''}]
              }
            }
          ]
        },
      );

      final form = BuilderForm(
        id: '1',
        title: 'Form',
        sections: [
          FormSection(id: 's1', title: 'S1', questions: [questionA, questionB, questionC]),
        ],
      );

      final result = FormLogicEngine.evaluate(form, {'qA': 5, 'qB': 10});
      expect(result.valueOverrides['qC'], 15);
    });

    test('Cycle detection avoids infinite loop', () {
      // Simulate A depends on B, B depends on A
      final qA = FormQuestion(
        id: 'qA', type: QuestionType.number, label: 'A',
        conditionalLogic: {
          'rules': [{'action': 'calculate', 'expression': '{qB} + 1', 'conditionGroup': {'rules': [{'triggerId': 'qB', 'operator': 'is_not_empty', 'value': ''}]}}]
        }
      );
      final qB = FormQuestion(
        id: 'qB', type: QuestionType.number, label: 'B',
        conditionalLogic: {
          'rules': [{'action': 'calculate', 'expression': '{qA} + 1', 'conditionGroup': {'rules': [{'triggerId': 'qA', 'operator': 'is_not_empty', 'value': ''}]}}]
        }
      );

      final form = BuilderForm(id: '1', title: 'Form', sections: [FormSection(id: 's1', title: 'S1', questions: [qA, qB])]);
      
      // Should not throw, should evaluate to some fallback or partial state
      final result = FormLogicEngine.evaluate(form, {'qA': 1, 'qB': 1});
      expect(result.valueOverrides, isNotNull);
    });
  });
}

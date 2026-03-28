import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/form_builder/domain/entities/builder_form.dart';
import 'package:frontend/features/form_builder/domain/entities/form_section.dart';
import 'package:frontend/features/form_builder/domain/entities/form_question.dart';
import 'package:frontend/features/form_builder/domain/entities/question_type.dart';
import 'package:frontend/features/form_builder/presentation/utils/form_logic_engine.dart';

void main() {
  group('FormLogicEngine', () {
    test('should evaluate simple addition expression', () {
      final form = BuilderForm(
        id: '1',
        title: 'Test',
        sections: [
          FormSection(
            id: 's1',
            title: 'S1',
            questions: [
              FormQuestion(id: 'a', type: QuestionType.number, label: 'A'),
              FormQuestion(id: 'b', type: QuestionType.number, label: 'B'),
              FormQuestion(
                id: 'c',
                type: QuestionType.number,
                label: 'C',
                conditionalLogic: {
                  'rules': [
                    {
                      'action': 'calculate',
                      'expression': '{a} + {b}',
                      'conditionGroup': {
                        'matchType': 'and',
                        'rules': [
                          {'triggerId': 'a', 'operator': 'is_not_empty'},
                        ],
                      },
                    }
                  ],
                },
              ),
            ],
          ),
        ],
      );

      final formData = {'a': 10, 'b': 20};
      final result = FormLogicEngine.evaluate(form, formData);

      expect(result.valueOverrides['c'], equals(30.0));
    });

    test('should handle multi-step dependency chain', () {
      final form = BuilderForm(
        id: '1',
        title: 'Test',
        sections: [
          FormSection(
            id: 's1',
            title: 'S1',
            questions: [
              FormQuestion(id: 'a', type: QuestionType.number, label: 'A'),
              FormQuestion(
                id: 'b',
                type: QuestionType.number,
                label: 'B',
                conditionalLogic: {
                  'rules': [
                    {
                      'action': 'calculate',
                      'expression': '{a} * 2',
                      'conditionGroup': {
                        'matchType': 'and',
                        'rules': [],
                      },
                    }
                  ],
                },
              ),
              FormQuestion(
                id: 'c',
                type: QuestionType.number,
                label: 'C',
                conditionalLogic: {
                  'rules': [
                    {
                      'action': 'calculate',
                      'expression': '{b} + 5',
                      'conditionGroup': {
                        'matchType': 'and',
                        'rules': [],
                      },
                    }
                  ],
                },
              ),
            ],
          ),
        ],
      );

      final formData = {'a': 10};
      final result = FormLogicEngine.evaluate(form, formData);

      // a=10 -> b=20 -> c=25
      expect(result.valueOverrides['b'], equals(20.0));
      expect(result.valueOverrides['c'], equals(25.0));
    });

    test('should handle conditional required state', () {
      final form = BuilderForm(
        id: '1',
        title: 'Test',
        sections: [
          FormSection(
            id: 's1',
            title: 'S1',
            questions: [
              FormQuestion(id: 'trigger', type: QuestionType.shortText, label: 'Trigger'),
              FormQuestion(
                id: 'target',
                type: QuestionType.shortText,
                label: 'Target',
                isRequired: false,
                conditionalLogic: {
                  'rules': [
                    {
                      'action': 'require',
                      'conditionGroup': {
                        'matchType': 'and',
                        'rules': [
                          {'triggerId': 'trigger', 'operator': 'equals', 'value': 'yes'},
                        ],
                      },
                    }
                  ],
                },
              ),
            ],
          ),
        ],
      );

      final res1 = FormLogicEngine.evaluate(form, {'trigger': 'no'});
      expect(res1.requiredStatus['target'], isFalse);

      final res2 = FormLogicEngine.evaluate(form, {'trigger': 'yes'});
      expect(res2.requiredStatus['target'], isTrue);
    });
  });
}

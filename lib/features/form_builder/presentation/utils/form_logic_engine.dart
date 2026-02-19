import '../../domain/entities/builder_form.dart';
import '../../domain/entities/form_question_option.dart';

class LogicEvaluationResult {
  final Map<String, bool> visibility;
  final Map<String, dynamic> valueOverrides;
  final Map<String, List<FormQuestionOption>> optionOverrides;
  final List<Map<String, dynamic>> pendingWebhooks;

  LogicEvaluationResult({
    required this.visibility,
    required this.valueOverrides,
    required this.optionOverrides,
    required this.pendingWebhooks,
  });
}

class FormLogicEngine {
  static LogicEvaluationResult evaluate(
    BuilderForm form,
    Map<String, dynamic> formData,
  ) {
    final visibilityMap = <String, bool>{};
    final valueOverrides = <String, dynamic>{};
    final optionOverrides = <String, List<FormQuestionOption>>{};
    final pendingWebhooks = <List<Map<String, dynamic>>>[];

    // Evaluate Section Visibility
    for (final section in form.sections) {
      final sectionLogic = _evaluateV3Logic(
        section.conditionalLogic,
        formData,
        section.isHidden,
      );
      visibilityMap[section.id] = sectionLogic.isVisible;

      // Section-level webhooks or value sets could be added here if needed

      // Evaluate Question Logic within Section
      for (final question in section.questions) {
        if (!visibilityMap[section.id]!) {
          visibilityMap[question.id] = false;
          continue;
        }

        final qLogic = _evaluateV3Logic(
          question.conditionalLogic,
          formData,
          question.isHidden,
        );
        visibilityMap[question.id] = qLogic.isVisible;

        if (qLogic.isVisible) {
          if (qLogic.valueToSet != null) {
            valueOverrides[question.id] = qLogic.valueToSet;
          }
          if (qLogic.optionsToSet != null) {
            optionOverrides[question.id] = qLogic.optionsToSet!;
          }
          if (qLogic.webhooksToTrigger != null) {
            pendingWebhooks.add(qLogic.webhooksToTrigger!);
          }
        }
      }
    }

    return LogicEvaluationResult(
      visibility: visibilityMap,
      valueOverrides: valueOverrides,
      optionOverrides: optionOverrides,
      pendingWebhooks: pendingWebhooks.expand((x) => x).toList(),
    );
  }

  static _V3EvaluationResult _evaluateV3Logic(
    Map<String, dynamic>? logic,
    Map<String, dynamic> formData,
    bool defaultIsHidden,
  ) {
    if (logic == null || logic.isEmpty) {
      return _V3EvaluationResult(isVisible: !defaultIsHidden);
    }

    // Handle V3 structure (list of rules)
    final rules = (logic['rules'] as List? ?? []).cast<Map<String, dynamic>>();
    if (rules.isEmpty) return _V3EvaluationResult(isVisible: !defaultIsHidden);

    bool isVisible = !defaultIsHidden;
    dynamic valueToSet;
    List<FormQuestionOption>? optionsToSet;
    List<Map<String, dynamic>>? webhooksToTrigger;

    for (final rule in rules) {
      final action = rule['action'] ?? 'show';
      final conditionGroup = rule['conditionGroup'] as Map<String, dynamic>?;
      if (conditionGroup == null) continue;

      final matchType = conditionGroup['matchType'] ?? 'and';
      final conditionRules = conditionGroup['rules'] as List? ?? [];

      bool matched;
      if (matchType == 'and') {
        matched = conditionRules.every((r) => _evaluateCondition(r, formData));
      } else {
        matched = conditionRules.any((r) => _evaluateCondition(r, formData));
      }

      if (matched) {
        switch (action) {
          case 'show':
            isVisible = true;
            break;
          case 'hide':
            isVisible = false;
            break;
          case 'set_value':
            valueToSet = rule['value'];
            break;
          case 'update_options':
            final dynOptions = rule['dynamicOptions'] as List? ?? [];
            optionsToSet = dynOptions
                .map(
                  (o) => FormQuestionOption(
                    id: o['value'] ?? 'opt',
                    label: o['label'] ?? '',
                    value: o['value'] ?? '',
                    order: 0,
                  ),
                )
                .toList();
            break;
          case 'webhook':
            webhooksToTrigger ??= [];
            webhooksToTrigger.add({
              'url': rule['webhookUrl'],
              'method': rule['webhookMethod'] ?? 'GET',
              'mappings': rule['webhookMappings'],
            });
            break;
        }
      }
    }

    return _V3EvaluationResult(
      isVisible: isVisible,
      valueToSet: valueToSet,
      optionsToSet: optionsToSet,
      webhooksToTrigger: webhooksToTrigger,
    );
  }

  static bool _evaluateCondition(
    Map<String, dynamic> rule,
    Map<String, dynamic> formData,
  ) {
    final triggerId = rule['triggerId'];
    if (triggerId == null) return false;

    final operator = rule['operator'] ?? 'equals';
    final expectedValue = rule['value'];
    final actualValue = formData[triggerId];

    final actualStr = actualValue?.toString() ?? '';
    final expectedStr = expectedValue?.toString() ?? '';

    switch (operator) {
      case 'equals':
        if (actualValue is List) {
          return actualValue.length == 1 &&
              actualValue.first.toString() == expectedStr;
        }
        return actualStr == expectedStr;
      case 'not_equals':
        return actualStr != expectedStr;
      case 'contains':
        if (actualValue is List) {
          return actualValue.map((e) => e.toString()).contains(expectedStr);
        }
        return actualStr.contains(expectedStr);
      case 'not_contains':
        if (actualValue is List) {
          return !actualValue.map((e) => e.toString()).contains(expectedStr);
        }
        return !actualStr.contains(expectedStr);
      case 'is_empty':
        if (actualValue is List) return actualValue.isEmpty;
        return actualStr.isEmpty;
      case 'is_not_empty':
        if (actualValue is List) return actualValue.isNotEmpty;
        return actualStr.isNotEmpty;
      case 'greater_than':
        return (double.tryParse(actualStr) ?? 0) >
            (double.tryParse(expectedStr) ?? 0);
      case 'less_than':
        return (double.tryParse(actualStr) ?? 0) <
            (double.tryParse(expectedStr) ?? 0);
      default:
        return false;
    }
  }

  // Support for legacy EvaluateVisibility call
  static Map<String, bool> evaluateVisibility(
    BuilderForm form,
    Map<String, dynamic> formData,
  ) {
    return evaluate(form, formData).visibility;
  }
}

class _V3EvaluationResult {
  final bool isVisible;
  final dynamic valueToSet;
  final List<FormQuestionOption>? optionsToSet;
  final List<Map<String, dynamic>>? webhooksToTrigger;

  _V3EvaluationResult({
    required this.isVisible,
    this.valueToSet,
    this.optionsToSet,
    this.webhooksToTrigger,
  });
}

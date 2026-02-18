import '../../domain/entities/builder_form.dart';

class FormLogicEngine {
  static Map<String, bool> evaluateVisibility(
    BuilderForm form,
    Map<String, dynamic> formData,
  ) {
    final visibilityMap = <String, bool>{};

    // Evaluate Section Visibility
    for (final section in form.sections) {
      final isVisible = _evaluateRule(
        section.conditionalLogic,
        formData,
        section.isHidden,
      );
      visibilityMap[section.id] = isVisible;

      // Evaluate Question Visibility within Section
      for (final question in section.questions) {
        if (!isVisible) {
          visibilityMap[question.id] = false;
          continue;
        }
        final isQuestionVisible = _evaluateRule(
          question.conditionalLogic,
          formData,
          question.isHidden,
        );
        visibilityMap[question.id] = isQuestionVisible;
      }
    }

    return visibilityMap;
  }

  static bool _evaluateRule(
    Map<String, dynamic>? logic,
    Map<String, dynamic> formData,
    bool defaultIsHidden,
  ) {
    if (logic == null || logic.isEmpty) return !defaultIsHidden;

    final action = logic['action'] ?? 'show';
    final conditionGroup = logic['conditionGroup'] as Map<String, dynamic>?;
    if (conditionGroup == null) return !defaultIsHidden;

    final matchType = conditionGroup['matchType'] ?? 'and';
    final rules = conditionGroup['rules'] as List? ?? [];

    if (rules.isEmpty) return !defaultIsHidden;

    bool result;
    if (matchType == 'and') {
      result = rules.every((r) => _evaluateCondition(r, formData));
    } else {
      result = rules.any((r) => _evaluateCondition(r, formData));
    }

    if (action == 'show') return result;
    if (action == 'hide') return !result;

    return !defaultIsHidden;
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

    // Convert values to strings for standard comparison unless they are lists
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
      case 'starts_with':
        return actualStr.startsWith(expectedStr);
      case 'ends_with':
        return actualStr.endsWith(expectedStr);
      case 'greater_than':
        return (double.tryParse(actualStr) ?? 0) >
            (double.tryParse(expectedStr) ?? 0);
      case 'less_than':
        return (double.tryParse(actualStr) ?? 0) <
            (double.tryParse(expectedStr) ?? 0);
      case 'greater_than_equals':
        return (double.tryParse(actualStr) ?? 0) >=
            (double.tryParse(expectedStr) ?? 0);
      case 'less_than_equals':
        return (double.tryParse(actualStr) ?? 0) <=
            (double.tryParse(expectedStr) ?? 0);
      default:
        return false;
    }
  }
}

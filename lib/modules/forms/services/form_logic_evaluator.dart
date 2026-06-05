import 'package:frontend/shared/models/form_models.dart';

class FormLogicEvaluator {
  /// Evaluates visibility for a question based on its logic rules and current form data.
  /// Returns `true` if the question should be visible, `false` otherwise.
  static bool shouldShowQuestion(
    FormQuestion question,
    Map<String, dynamic> formData,
  ) {
    if (question.conditionalLogic == null ||
        question.conditionalLogic!.isEmpty) {
      return !question.isHidden;
    }

    final logic = _parseLogic(question.conditionalLogic!);
    if (logic == null) return !question.isHidden;

    // Evaluate rules
    for (final rule in logic.rules) {
      if (rule.action == 'hide' &&
          _evaluateConditionGroup(rule.conditions, formData)) {
        return false;
      }
      if (rule.action == 'show') {
        // If "show" rule matches, we show it.
        // But what if there are multiple rules?
        // Usually "show" implies hidden by default unless condition met.
        // Or "hide" implies shown unless condition met.
        // Let's assume standard behavior:
        // If there are ANY "show" rules, the field is HIDDEN unless one of them matches.
        // If there are ONLY "hide" rules, the field is SHOWN unless one of them matches.
      }
    }

    // Complex precedence logic:
    // 1. Gather all applicable rules
    final applicableRules = logic.rules
        .where((r) => _evaluateConditionGroup(r.conditions, formData))
        .toList();

    // If no rules match, return default state
    if (applicableRules.isEmpty) {
      // If there are explicit SHOW rules defined, but none match -> Hide
      if (logic.rules.any((r) => r.action == 'show')) return false;
      return !question.isHidden;
    }

    // If any matched rule says HIDE, we Hide (Hide takes precedence usually, or last match)
    // Let's assume specificity or order. Here: Hide overrides Show.
    if (applicableRules.any((r) => r.action == 'hide')) return false;

    return true;
  }

  /// Checks if a question triggers a validation error based on current data.
  /// Returns error message string if invalid, null otherwise.
  static String? validateQuestion(
    FormQuestion question,
    Map<String, dynamic> formData,
  ) {
    if (question.conditionalLogic == null) return null;
    final logic = _parseLogic(question.conditionalLogic!);
    if (logic == null) return null;

    for (final rule in logic.rules) {
      if (rule.action == 'validate') {
        if (_evaluateConditionGroup(rule.conditions, formData)) {
          return rule.errorMessage ?? 'Invalid condition met.';
        }
      }
    }
    return null;
  }

  /// Checks if a specific option should be disabled.
  static bool isOptionDisabled(
    FormQuestion question,
    String optionValue,
    Map<String, dynamic> formData,
  ) {
    if (question.conditionalLogic == null) return false;
    final logic = _parseLogic(question.conditionalLogic!);
    if (logic == null) return false;

    for (final rule in logic.rules) {
      if (rule.action == 'disable_option' && rule.targetOption == optionValue) {
        if (_evaluateConditionGroup(rule.conditions, formData)) {
          return true;
        }
      }
    }
    return false;
  }

  /// Checks if question is required dynamically
  static bool isQuestionRequired(
    FormQuestion question,
    Map<String, dynamic> formData,
  ) {
    if (question.conditionalLogic == null) return question.isRequired;
    final logic = _parseLogic(question.conditionalLogic!);
    if (logic == null) return question.isRequired;

    bool isReq = question.isRequired;
    for (final rule in logic.rules) {
      if (_evaluateConditionGroup(rule.conditions, formData)) {
        if (rule.action == 'require') isReq = true;
        if (rule.action == 'optional') isReq = false;
      }
    }
    return isReq;
  }

  // --- Helpers ---

  static _LogicDefinition? _parseLogic(Map<String, dynamic> json) {
    // Handle V2
    if (json['version'] == 2 && json['rules'] is List) {
      final rules = (json['rules'] as List)
          .map((r) => _LogicRule.fromJson(r))
          .toList();
      return _LogicDefinition(rules: rules);
    }
    // Handle V1 (Legacy compatibility)
    if (json['triggerId'] != null || json['matchType'] != null) {
      // Convert on fly or ignore. Let's try to convert simple V1
      // ... simple conversion logic or return null
      return null;
    }
    return null;
  }

  static bool _evaluateConditionGroup(
    _ConditionGroup group,
    Map<String, dynamic> formData,
  ) {
    if (group.conditions.isEmpty) {
      return true; // Empty group matches? Or not? Usually true if no constraints.
    }
    if (group.matchType == 'and') {
      return group.conditions.every((c) => _evaluateCondition(c, formData));
    } else {
      // OR
      return group.conditions.any((c) => _evaluateCondition(c, formData));
    }
  }

  static bool _evaluateCondition(
    _Condition condition,
    Map<String, dynamic> formData,
  ) {
    final triggerValue = formData[condition.triggerId];
    // If triggerValue is null (not answered), most checks fail except is_empty

    final op = condition.operator;
    final targetVal = condition.value;

    if (op == 'is_empty') {
      return triggerValue == null || triggerValue.toString().isEmpty;
    }
    if (op == 'is_not_empty') {
      return triggerValue != null && triggerValue.toString().isNotEmpty;
    }

    if (triggerValue == null) return false;

    final tStr = triggerValue.toString();
    final vStr = targetVal.toString();

    switch (op) {
      case 'equals':
        return tStr == vStr;
      case 'not_equals':
        return tStr != vStr;
      case 'contains':
        return tStr.contains(vStr);
      case 'not_contains':
        return !tStr.contains(vStr);
      case 'starts_with':
        return tStr.startsWith(vStr);
      case 'ends_with':
        return tStr.endsWith(vStr);
      case 'greater_than':
        return (num.tryParse(tStr) ?? 0) > (num.tryParse(vStr) ?? 0);
      case 'less_than':
        return (num.tryParse(tStr) ?? 0) < (num.tryParse(vStr) ?? 0);
      case 'greater_than_equals':
        return (num.tryParse(tStr) ?? 0) >= (num.tryParse(vStr) ?? 0);
      case 'less_than_equals':
        return (num.tryParse(tStr) ?? 0) <= (num.tryParse(vStr) ?? 0);
      default:
        return false;
    }
  }
}

class _LogicDefinition {
  final List<_LogicRule> rules;
  _LogicDefinition({required this.rules});
}

class _LogicRule {
  final String action;
  final String? errorMessage;
  final String? targetOption;
  final _ConditionGroup conditions;

  _LogicRule({
    required this.action,
    this.errorMessage,
    this.targetOption,
    required this.conditions,
  });

  factory _LogicRule.fromJson(Map<String, dynamic> json) {
    return _LogicRule(
      action: json['action'] ?? 'show',
      errorMessage: json['errorMessage'],
      targetOption: json['targetOption'],
      conditions: _ConditionGroup.fromJson(json['conditionGroup'] ?? {}),
    );
  }
}

class _ConditionGroup {
  final String matchType;
  final List<_Condition> conditions;

  _ConditionGroup({required this.matchType, required this.conditions});

  factory _ConditionGroup.fromJson(Map<String, dynamic> json) {
    return _ConditionGroup(
      matchType: json['matchType'] ?? 'and',
      conditions: (json['rules'] as List? ?? [])
          .map((c) => _Condition.fromJson(c))
          .toList(),
    );
  }
}

class _Condition {
  final String triggerId;
  final String operator;
  final dynamic value;

  _Condition({required this.triggerId, required this.operator, this.value});

  factory _Condition.fromJson(Map<String, dynamic> json) {
    return _Condition(
      triggerId: json['triggerId'] ?? '',
      operator: json['operator'] ?? 'equals',
      value: json['value'],
    );
  }
}

import '../../domain/entities/builder_form.dart';
import '../../domain/entities/form_question_option.dart';
import 'package:expressions/expressions.dart';

class LogicEvaluationResult {
  final Map<String, bool> visibility;
  final Map<String, bool> requiredStatus;
  final Map<String, dynamic> valueOverrides;
  final Map<String, List<FormQuestionOption>> optionOverrides;
  final List<Map<String, dynamic>> pendingWebhooks;

  LogicEvaluationResult({
    required this.visibility,
    required this.requiredStatus,
    required this.valueOverrides,
    required this.optionOverrides,
    required this.pendingWebhooks,
  });
}

class FormLogicEngine {
  static const ExpressionEvaluator evaluator = ExpressionEvaluator();

  static LogicEvaluationResult evaluate(
    BuilderForm form,
    Map<String, dynamic> formData,
  ) {
    final visibilityMap = <String, bool>{};
    final requiredMap = <String, bool>{};
    final valueOverrides = <String, dynamic>{};
    final optionOverrides = <String, List<FormQuestionOption>>{};
    final pendingWebhooks = <List<Map<String, dynamic>>>[];

    // Build dependency graph
    final graph = <String, Set<String>>{};
    final questions = <String, dynamic>{};
    
    // 1. Evaluate Section Visibility
    for (final section in form.sections) {
      final sectionLogic = _evaluateV3Logic(
        section.conditionalLogic,
        formData,
        section.isHidden,
        false,
      );
      visibilityMap[section.id] = sectionLogic.isVisible;

      for (final question in section.questions) {
        questions[question.id] = question;
        requiredMap[question.id] = question.isRequired;

        if (!visibilityMap[section.id]!) {
          visibilityMap[question.id] = false;
          continue;
        }

        final qLogic = _evaluateV3Logic(
          question.conditionalLogic,
          formData,
          question.isHidden,
          question.isRequired,
        );
        
        visibilityMap[question.id] = qLogic.isVisible;
        requiredMap[question.id] = qLogic.isRequired;

        if (qLogic.isVisible) {
          if (qLogic.optionsToSet != null) {
            optionOverrides[question.id] = qLogic.optionsToSet!;
          }
          if (qLogic.webhooksToTrigger != null) {
            pendingWebhooks.add(qLogic.webhooksToTrigger!);
          }
        }

        // Detect dependencies for calculated values and visibility triggers
        final deps = _extractDependencies(question.conditionalLogic);
        graph[question.id] = deps;
      }
    }

    final sortedIds = _topologicalSort(graph);

    // 2. Evaluate values in topologically sorted order
    for (final id in sortedIds) {
      final question = questions[id];
      if (question == null) continue;

      // Ensure form data includes overrides from previous nodes in the chain
      final currentData = {...formData, ...valueOverrides};

      final qLogic = _evaluateV3Logic(
        question.conditionalLogic,
        currentData,
        question.isHidden,
        question.isRequired,
      );
      
      if (qLogic.isVisible && qLogic.valueToSet != null) {
        valueOverrides[id] = qLogic.valueToSet;
      }
    }

    return LogicEvaluationResult(
      visibility: visibilityMap,
      requiredStatus: requiredMap,
      valueOverrides: valueOverrides,
      optionOverrides: optionOverrides,
      pendingWebhooks: pendingWebhooks.expand((x) => x).toList(),
    );
  }

  static Set<String> _extractDependencies(Map<String, dynamic>? logic) {
    final deps = <String>{};
    if (logic == null || logic.isEmpty) return deps;

    final rules = (logic['rules'] as List? ?? []).cast<Map<String, dynamic>>();
    for (final rule in rules) {
      // Dependencies from conditions
      final conditionGroup = rule['conditionGroup'] as Map<String, dynamic>?;
      if (conditionGroup != null) {
        final conditionRules = conditionGroup['rules'] as List? ?? [];
        for (final r in conditionRules) {
          final triggerId = r['triggerId'];
          if (triggerId != null) deps.add(triggerId.toString());
        }
      }
      
      // Dependencies from calculation expressions
      if (rule['action'] == 'calculate' || rule['action'] == 'set_value') {
        final expr = rule['expression']?.toString() ?? '';
        if (expr.isNotEmpty) {
          final matches = RegExp(r'\{([a-zA-Z0-9_-]+)\}').allMatches(expr);
          for (final m in matches) {
            deps.add(m.group(1)!);
          }
        }
      }
    }
    return deps;
  }

  static List<String> _topologicalSort(Map<String, Set<String>> graph) {
    final inDegree = <String, int>{};
    for (final node in graph.keys) {
      inDegree[node] = 0;
    }
    for (final deps in graph.values) {
      for (final dep in deps) {
        if (inDegree.containsKey(dep)) {
          inDegree[dep] = inDegree[dep]! + 1;
        }
      }
    }

    final queue = <String>[];
    for (final entry in inDegree.entries) {
      if (entry.value == 0) {
        queue.add(entry.key);
      }
    }

    final result = <String>[];
    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);
      result.add(current);

      if (graph.containsKey(current)) {
        for (final dep in graph[current]!) {
          if (inDegree.containsKey(dep)) {
            inDegree[dep] = inDegree[dep]! - 1;
            if (inDegree[dep] == 0) {
              queue.add(dep);
            }
          }
        }
      }
    }

    // Cycle detection or remaining nodes
    for (final node in graph.keys) {
      if (!result.contains(node)) {
        result.add(node); // Append cycles to avoid losing fields
      }
    }

    return result.reversed.toList();
  }

  static _V3EvaluationResult _evaluateV3Logic(
    Map<String, dynamic>? logic,
    Map<String, dynamic> formData,
    bool defaultIsHidden,
    bool defaultIsRequired,
  ) {
    if (logic == null || logic.isEmpty) {
      return _V3EvaluationResult(
        isVisible: !defaultIsHidden, 
        isRequired: defaultIsRequired
      );
    }

    final rules = (logic['rules'] as List? ?? []).cast<Map<String, dynamic>>();
    if (rules.isEmpty) return _V3EvaluationResult(
      isVisible: !defaultIsHidden,
      isRequired: defaultIsRequired
    );

    bool isVisible = !defaultIsHidden;
    bool isRequired = defaultIsRequired;
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
          case 'require':
            isRequired = true;
            break;
          case 'optional':
            isRequired = false;
            break;
          case 'set_value':
            valueToSet = rule['value'];
            break;
          case 'calculate':
            final expr = rule['expression']?.toString() ?? '';
            valueToSet = _evaluateExpression(expr, formData);
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
      isRequired: isRequired,
      valueToSet: valueToSet,
      optionsToSet: optionsToSet,
      webhooksToTrigger: webhooksToTrigger,
    );
  }

  static dynamic _evaluateExpression(String expression, Map<String, dynamic> formData) {
    if (expression.isEmpty) return null;
    try {
      // Interpolate field references: {field_id} -> field_id
      // and prepare context
      final Map<String, dynamic> context = {};
      var processedExpr = expression;
      
      final matches = RegExp(r'\{([a-zA-Z0-9_-]+)\}').allMatches(expression);
      for (final m in matches) {
        final fullMatch = m.group(0)!;
        final fieldId = m.group(1)!;
        
        // Use normalized names for the evaluator
        final varName = fieldId.replaceAll('-', '_');
        processedExpr = processedExpr.replaceAll(fullMatch, varName);
        
        var val = formData[fieldId];
        if (val == null) val = 0; // Default to 0 for arithmetic
        if (val is String) val = double.tryParse(val) ?? val;
        
        context[varName] = val;
      }

      final parsedExpr = Expression.parse(processedExpr);
      return evaluator.eval(parsedExpr, context);
    } catch (e) {
      return null;
    }
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
  final bool isRequired;
  final dynamic valueToSet;
  final List<FormQuestionOption>? optionsToSet;
  final List<Map<String, dynamic>>? webhooksToTrigger;

  _V3EvaluationResult({
    required this.isVisible,
    required this.isRequired,
    this.valueToSet,
    this.optionsToSet,
    this.webhooksToTrigger,
  });
}

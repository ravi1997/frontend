import 'package:frontend/models/form_models.dart';
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
    // A node is an ID of either a question or a section
    final graph = <String, Set<String>>{};
    final nodeData = <String, dynamic>{};
    final isSection = <String, bool>{};
    
    // Initialize graph with all nodes
    for (final section in form.sections) {
      nodeData[section.id] = section;
      isSection[section.id] = true;
      graph[section.id] = _extractDependencies(section.conditionalLogic);
      
      for (final question in section.questions) {
        nodeData[question.id] = question;
        isSection[question.id] = false;
        graph[question.id] = _extractDependencies(question.conditionalLogic);
      }
    }

    final sortedIds = _topologicalSort(graph);

    // Evaluate in topologically sorted order
    for (final id in sortedIds) {
      final data = nodeData[id];
      if (data == null) {
        continue;
      }

      final currentData = {...formData, ...valueOverrides};

      if (isSection[id] == true) {
        final section = data as FormSection;
        final logic = _evaluateV3Logic(
          section.conditionalLogic,
          currentData,
          section.isHidden,
          false,
        );
        visibilityMap[id] = logic.isVisible;
      } else {
        final question = data as FormQuestion;
        
        // Find parent section visibility
        final parentSectionId = form.sections.firstWhere((s) => s.questions.any((q) => q.id == id)).id;
        final isParentVisible = visibilityMap[parentSectionId] ?? true;

        if (!isParentVisible) {
          visibilityMap[id] = false;
          requiredMap[id] = false;
          continue;
        }

        final qLogic = _evaluateV3Logic(
          question.conditionalLogic,
          currentData,
          question.isHidden,
          question.isRequired,
        );
        
        visibilityMap[id] = qLogic.isVisible;
        requiredMap[id] = qLogic.isRequired;

        if (qLogic.isVisible) {
          if (qLogic.optionsToSet != null) {
            optionOverrides[id] = qLogic.optionsToSet!;
          }
          if (qLogic.webhooksToTrigger != null) {
            pendingWebhooks.add(qLogic.webhooksToTrigger!);
          }
          if (qLogic.valueToSet != null) {
            valueOverrides[id] = qLogic.valueToSet;
          }
        }
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
    if (logic == null || logic.isEmpty) {
      return deps;
    }

    final rules = (logic['rules'] as List? ?? []).cast<Map<String, dynamic>>();
    for (final rule in rules) {
      // Dependencies from conditions
      final conditionGroup = rule['conditionGroup'] as Map<String, dynamic>?;
      if (conditionGroup != null) {
        final conditionRules = (conditionGroup['rules'] as List? ?? []).cast<Map<String, dynamic>>();
        for (final r in conditionRules) {
          final triggerId = r['triggerId'];
          if (triggerId != null) deps.add(triggerId.toString());
        }
      }
      
      // Dependencies from calculation expressions
      if (rule['action'] == 'calculate') {
        final expr = rule['expression']?.toString() ?? '';
        if (expr.isNotEmpty) {
          final matches = RegExp(r'\{([a-zA-Z0-9_-]+)\}').allMatches(expr);
          for (final m in matches) {
            deps.add(m.group(1)!);
          }
        }
      }

      // Dependencies from set_value if it uses interpolation (optional feature)
      if (rule['action'] == 'set_value' && rule['value'] is String) {
        final val = rule['value'] as String;
        final matches = RegExp(r'\{([a-zA-Z0-9_-]+)\}').allMatches(val);
        for (final m in matches) {
          deps.add(m.group(1)!);
        }
      }
    }
    return deps;
  }

  static List<String> _topologicalSort(Map<String, Set<String>> graph) {
    final result = <String>[];
    final visited = <String, bool>{}; // false = visiting, true = visited
    void visit(String node) {
      if (visited[node] == true) return;
      if (visited[node] == false) {
        return;
      }
      visited[node] = false; // Mark as visiting
      final deps = graph[node] ?? {};
      for (final dep in deps) {
        if (graph.containsKey(dep)) {
          visit(dep);
        }
      }

      visited[node] = true; // Mark as visited
      result.add(node);
    }

    for (final node in graph.keys) {
      if (!visited.containsKey(node)) {
        visit(node);
      }
    }

    // result now contains nodes such that dependencies come before dependents
    return result;
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
    if (rules.isEmpty) {
      return _V3EvaluationResult(
        isVisible: !defaultIsHidden,
        isRequired: defaultIsRequired,
      );
    }

    bool isVisible = !defaultIsHidden;
    bool isRequired = defaultIsRequired;
    dynamic valueToSet;
    List<FormQuestionOption>? optionsToSet;
    List<Map<String, dynamic>>? webhooksToTrigger;

    for (final rule in rules) {
      final action = rule['action'] ?? 'show';
      final conditionGroup = rule['conditionGroup'] as Map<String, dynamic>?;
      if (conditionGroup == null) {
        continue;
      }

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
    if (expression.isEmpty) {
      return null;
    }
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
        
        var val = formData[fieldId] ?? 0; // Default to 0 for arithmetic
        if (val is String) {
          val = double.tryParse(val) ?? val;
        }
        
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
    if (triggerId == null) {
      return false;
    }

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
        if (actualValue is List) {
          return actualValue.isEmpty;
        }
        return actualStr.isEmpty;
      case 'is_not_empty':
        if (actualValue is List) {
          return actualValue.isNotEmpty;
        }
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

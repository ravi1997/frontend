import 'condition_enums.dart';

/// Represents a single condition in a conditional logic rule.
///
/// A condition compares a field's value against a specified value using
/// an operator (equals, contains, greater than, etc.).
class Condition {
  /// Unique identifier for this condition.
  final String id;

  /// The field ID to check.
  final String fieldId;

  /// The field name (for display purposes).
  final String fieldName;

  /// Comparison operator.
  final ConditionOperator operator;

  /// Value to compare against.
  final dynamic value;

  /// For list-based operators, the list of values.
  final List<dynamic>? valueList;

  const Condition({
    required this.id,
    required this.fieldId,
    required this.fieldName,
    required this.operator,
    this.value,
    this.valueList,
  });

  /// Evaluates this condition against a set of field values.
  bool evaluate(Map<String, dynamic> fieldValues) {
    final fieldValue = fieldValues[fieldId];

    switch (operator) {
      case ConditionOperator.equals:
        return fieldValue == value;
      case ConditionOperator.notEquals:
        return fieldValue != value;
      case ConditionOperator.contains:
        return fieldValue?.toString().contains(value?.toString() ?? '') ??
            false;
      case ConditionOperator.notContains:
        final fieldStr = fieldValue?.toString() ?? '';
        final searchStr = value?.toString() ?? '';
        return !fieldStr.contains(searchStr);
      case ConditionOperator.greaterThan:
        return _compare(fieldValue, value) > 0;
      case ConditionOperator.lessThan:
        return _compare(fieldValue, value) < 0;
      case ConditionOperator.greaterThanOrEquals:
        return _compare(fieldValue, value) >= 0;
      case ConditionOperator.lessThanOrEquals:
        return _compare(fieldValue, value) <= 0;
      case ConditionOperator.isEmpty:
        return fieldValue == null ||
            fieldValue.toString().isEmpty ||
            (fieldValue is List && fieldValue.isEmpty);
      case ConditionOperator.isNotEmpty:
        return fieldValue != null &&
            fieldValue.toString().isNotEmpty &&
            !(fieldValue is List && fieldValue.isEmpty);
      case ConditionOperator.isNull:
        return fieldValue == null;
      case ConditionOperator.isNotNull:
        return fieldValue != null;
      case ConditionOperator.inList:
        return valueList?.contains(fieldValue) ?? false;
      case ConditionOperator.notInList:
        return !(valueList?.contains(fieldValue) ?? false);
    }
  }

  int _compare(dynamic a, dynamic b) {
    if (a == null || b == null) return 0;
    if (a is num && b is num) return a.compareTo(b);
    return a.toString().compareTo(b.toString());
  }

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fieldId': fieldId,
      'fieldName': fieldName,
      'operator': operator.name,
      'value': value,
      'valueList': valueList,
    };
  }

  /// Creates from JSON.
  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      id: json['id'] as String,
      fieldId: json['fieldId'] as String,
      fieldName: json['fieldName'] as String,
      operator: ConditionOperator.values.byName(json['operator'] as String),
      value: json['value'],
      valueList: (json['valueList'] as List<dynamic>?)?.map((e) => e).toList(),
    );
  }
}

/// Represents a complete conditional logic rule.
///
/// A rule consists of one or more conditions combined with logical operators
/// (AND/OR) and defines an action to perform on a target field/section.
class ConditionalRule {
  /// Unique identifier for this rule.
  final String id;

  /// Name of the rule (for display in rule builder).
  final String name;

  /// Description of what this rule does.
  final String? description;

  /// The conditions in this rule.
  final List<Condition> conditions;

  /// Logical operator to combine conditions.
  final LogicalOperator logicalOperator;

  /// The action to perform when conditions are met.
  final ConditionAction action;

  /// The target field/section/page ID to apply the action to.
  final String targetId;

  /// The target type (field, section, page).
  final ConditionTargetType targetType;

  /// Whether this rule is currently active.
  final bool isEnabled;

  /// Priority order (lower = higher priority).
  final int priority;

  /// Whether to negate the result (i.e., action when conditions are NOT met).
  final bool negate;

  const ConditionalRule({
    required this.id,
    required this.name,
    this.description,
    required this.conditions,
    this.logicalOperator = LogicalOperator.and,
    required this.action,
    required this.targetId,
    this.targetType = ConditionTargetType.field,
    this.isEnabled = true,
    this.priority = 0,
    this.negate = false,
  });

  /// Evaluates this rule against a set of field values.
  bool evaluate(Map<String, dynamic> fieldValues) {
    if (!isEnabled) return false;

    bool result;
    if (logicalOperator == LogicalOperator.and) {
      result = conditions.every((c) => c.evaluate(fieldValues));
    } else {
      result = conditions.any((c) => c.evaluate(fieldValues));
    }

    return negate ? !result : result;
  }

  /// Creates a copy with the given fields replaced.
  ConditionalRule copyWith({
    String? id,
    String? name,
    String? description,
    List<Condition>? conditions,
    LogicalOperator? logicalOperator,
    ConditionAction? action,
    String? targetId,
    ConditionTargetType? targetType,
    bool? isEnabled,
    int? priority,
    bool? negate,
  }) {
    return ConditionalRule(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      conditions: conditions ?? this.conditions,
      logicalOperator: logicalOperator ?? this.logicalOperator,
      action: action ?? this.action,
      targetId: targetId ?? this.targetId,
      targetType: targetType ?? this.targetType,
      isEnabled: isEnabled ?? this.isEnabled,
      priority: priority ?? this.priority,
      negate: negate ?? this.negate,
    );
  }

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'conditions': conditions.map((c) => c.toJson()).toList(),
      'logicalOperator': logicalOperator.name,
      'action': action.name,
      'targetId': targetId,
      'targetType': targetType.name,
      'isEnabled': isEnabled,
      'priority': priority,
      'negate': negate,
    };
  }

  /// Creates from JSON.
  factory ConditionalRule.fromJson(Map<String, dynamic> json) {
    return ConditionalRule(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      conditions: (json['conditions'] as List<dynamic>)
          .map((c) => Condition.fromJson(c as Map<String, dynamic>))
          .toList(),
      logicalOperator: LogicalOperator.values.byName(
        json['logicalOperator'] as String,
      ),
      action: ConditionAction.values.byName(json['action'] as String),
      targetId: json['targetId'] as String,
      targetType: ConditionTargetType.values.byName(
        json['targetType'] as String,
      ),
      isEnabled: json['isEnabled'] as bool? ?? true,
      priority: json['priority'] as int? ?? 0,
      negate: json['negate'] as bool? ?? false,
    );
  }
}

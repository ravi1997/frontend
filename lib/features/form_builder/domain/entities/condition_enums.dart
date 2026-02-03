/// Types of comparison operators for conditions.
enum ConditionOperator {
  equals,
  notEquals,
  contains,
  notContains,
  greaterThan,
  lessThan,
  greaterThanOrEquals,
  lessThanOrEquals,
  isEmpty,
  isNotEmpty,
  isNull,
  isNotNull,
  inList,
  notInList,
}

/// Types of actions to perform when a condition is met.
enum ConditionAction {
  show,
  hide,
  require,
  optional,
  disable,
  enable,
  setValue,
}

/// Logical operators for combining multiple conditions.
enum LogicalOperator { and, or }

/// Target type for applying conditions.
enum ConditionTargetType { field, section, page }

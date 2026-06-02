import 'workflow_enums.dart';

/// Represents a transition between workflow steps.
///
/// Transitions define how the workflow moves from one step to another,
/// including conditions for conditional branching.
class WorkflowTransition {
  /// Unique identifier for this transition
  final String id;

  /// Source step ID
  final String fromStepId;

  /// Target step ID
  final String toStepId;

  /// Type of transition
  final TransitionType type;

  /// Display label for the transition
  final String? label;

  /// Condition for conditional transitions (JSON logic expression)
  final String? condition;

  /// Priority for parallel branches (lower = higher priority)
  final int? priority;

  /// Whether this transition is the default fallback
  final bool isDefault;

  /// Auto-transition delay in seconds (0 = immediate)
  final int autoDelaySeconds;

  const WorkflowTransition({
    required this.id,
    required this.fromStepId,
    required this.toStepId,
    this.type = TransitionType.sequential,
    this.label,
    this.condition,
    this.priority,
    this.isDefault = false,
    this.autoDelaySeconds = 0,
  });

  /// Creates a copy of this transition with the given fields replaced.
  WorkflowTransition copyWith({
    String? id,
    String? fromStepId,
    String? toStepId,
    TransitionType? type,
    String? label,
    String? condition,
    int? priority,
    bool? isDefault,
    int? autoDelaySeconds,
  }) {
    return WorkflowTransition(
      id: id ?? this.id,
      fromStepId: fromStepId ?? this.fromStepId,
      toStepId: toStepId ?? this.toStepId,
      type: type ?? this.type,
      label: label ?? this.label,
      condition: condition ?? this.condition,
      priority: priority ?? this.priority,
      isDefault: isDefault ?? this.isDefault,
      autoDelaySeconds: autoDelaySeconds ?? this.autoDelaySeconds,
    );
  }

  /// Converts this transition to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromStepId': fromStepId,
      'toStepId': toStepId,
      'type': type.name,
      'label': label,
      'condition': condition,
      'priority': priority,
      'isDefault': isDefault,
      'autoDelaySeconds': autoDelaySeconds,
    };
  }

  /// Creates a transition from a JSON map.
  factory WorkflowTransition.fromJson(Map<String, dynamic> json) {
    return WorkflowTransition(
      id: json['id'] as String,
      fromStepId: json['fromStepId'] as String,
      toStepId: json['toStepId'] as String,
      type: TransitionType.values.byName(json['type'] as String),
      label: json['label'] as String?,
      condition: json['condition'] as String?,
      priority: json['priority'] as int?,
      isDefault: json['isDefault'] as bool? ?? false,
      autoDelaySeconds: json['autoDelaySeconds'] as int? ?? 0,
    );
  }
}

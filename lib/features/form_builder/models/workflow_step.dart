import 'workflow_enums.dart';

/// Represents a single step in a workflow.
///
/// A step can be of different types (start, approval, automation, end, condition)
/// and defines what actions occur at that point in the workflow.
class WorkflowStep {
  /// Unique identifier for this step
  final String id;

  /// Display name for the step
  final String name;

  /// Description of what this step does
  final String? description;

  /// Type of step
  final WorkflowStepType type;

  /// Order/position in the workflow sequence
  final int order;

  /// Configuration specific to this step type
  final Map<String, dynamic>? config;

  /// Assignee for approval steps (user ID or role)
  final String? assigneeId;

  /// Due date offset in days from step activation
  final int? dueInDays;

  /// Actions available at this step
  final List<String>? allowedActions;

  /// Whether this step requires manual intervention
  final bool requiresManualAction;

  /// Whether this step can be skipped
  final bool skippable;

  /// On-complete hooks (webhooks, notifications)
  final List<String>? onCompleteHooks;

  const WorkflowStep({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.order,
    this.config,
    this.assigneeId,
    this.dueInDays,
    this.allowedActions,
    this.requiresManualAction = false,
    this.skippable = false,
    this.onCompleteHooks,
  });

  /// Creates a copy of this step with the given fields replaced.
  WorkflowStep copyWith({
    String? id,
    String? name,
    String? description,
    WorkflowStepType? type,
    int? order,
    Map<String, dynamic>? config,
    String? assigneeId,
    int? dueInDays,
    List<String>? allowedActions,
    bool? requiresManualAction,
    bool? skippable,
    List<String>? onCompleteHooks,
  }) {
    return WorkflowStep(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      order: order ?? this.order,
      config: config ?? this.config,
      assigneeId: assigneeId ?? this.assigneeId,
      dueInDays: dueInDays ?? this.dueInDays,
      allowedActions: allowedActions ?? this.allowedActions,
      requiresManualAction: requiresManualAction ?? this.requiresManualAction,
      skippable: skippable ?? this.skippable,
      onCompleteHooks: onCompleteHooks ?? this.onCompleteHooks,
    );
  }

  /// Converts this step to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name,
      'order': order,
      'config': config,
      'assigneeId': assigneeId,
      'dueInDays': dueInDays,
      'allowedActions': allowedActions,
      'requiresManualAction': requiresManualAction,
      'skippable': skippable,
      'onCompleteHooks': onCompleteHooks,
    };
  }

  /// Creates a step from a JSON map.
  factory WorkflowStep.fromJson(Map<String, dynamic> json) {
    return WorkflowStep(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      type: WorkflowStepType.values.byName(json['type'] as String),
      order: json['order'] as int,
      config: json['config'] as Map<String, dynamic>?,
      assigneeId: json['assigneeId'] as String?,
      dueInDays: json['dueInDays'] as int?,
      allowedActions: (json['allowedActions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      requiresManualAction: json['requiresManualAction'] as bool? ?? false,
      skippable: json['skippable'] as bool? ?? false,
      onCompleteHooks: (json['onCompleteHooks'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }
}

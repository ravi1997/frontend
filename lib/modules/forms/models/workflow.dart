import 'package:uuid/uuid.dart';
import 'workflow_enums.dart';
import 'workflow_step.dart';
import 'workflow_transition.dart';

/// Represents a workflow definition.
///
/// A workflow consists of steps (nodes) and transitions (edges) that define
/// the flow of a form submission through various stages.
class Workflow {
  /// Unique identifier for this workflow
  final String id;

  /// Form ID this workflow belongs to
  final String formId;

  /// Display name for the workflow
  final String name;

  /// Description of the workflow's purpose
  final String? description;

  /// Current status
  final WorkflowStatus status;

  /// Version number for optimistic locking
  final int version;

  /// Steps in this workflow (ordered by execution)
  final List<WorkflowStep> steps;

  /// Transitions between steps
  final List<WorkflowTransition> transitions;

  /// Created timestamp
  final DateTime createdAt;

  /// Last updated timestamp
  final DateTime updatedAt;

  /// Created by user ID
  final String createdBy;

  /// Initial step ID (entry point)
  final String? initialStepId;

  /// Final step IDs (exit points)
  final List<String> finalStepIds;

  /// Workflow metadata
  final Map<String, dynamic>? metadata;

  const Workflow({
    required this.id,
    required this.formId,
    required this.name,
    this.description,
    this.status = WorkflowStatus.draft,
    this.version = 1,
    required this.steps,
    required this.transitions,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.initialStepId,
    this.finalStepIds = const [],
    this.metadata,
  });

  /// Creates a new workflow with a generated ID.
  factory Workflow.create({
    required String formId,
    required String name,
    String? description,
    required String createdBy,
  }) {
    final now = DateTime.now();
    return Workflow(
      id: const Uuid().v4(),
      formId: formId,
      name: name,
      description: description,
      status: WorkflowStatus.draft,
      version: 1,
      steps: [],
      transitions: [],
      createdAt: now,
      updatedAt: now,
      createdBy: createdBy,
      finalStepIds: [],
    );
  }

  /// Creates a copy of this workflow with the given fields replaced.
  Workflow copyWith({
    String? id,
    String? formId,
    String? name,
    String? description,
    WorkflowStatus? status,
    int? version,
    List<WorkflowStep>? steps,
    List<WorkflowTransition>? transitions,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? initialStepId,
    List<String>? finalStepIds,
    Map<String, dynamic>? metadata,
  }) {
    return Workflow(
      id: id ?? this.id,
      formId: formId ?? this.formId,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      version: version ?? this.version,
      steps: steps ?? this.steps,
      transitions: transitions ?? this.transitions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      initialStepId: initialStepId ?? this.initialStepId,
      finalStepIds: finalStepIds ?? this.finalStepIds,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Adds a step to this workflow.
  Workflow addStep(WorkflowStep step) {
    return copyWith(steps: [...steps, step], updatedAt: DateTime.now());
  }

  /// Adds a transition to this workflow.
  Workflow addTransition(WorkflowTransition transition) {
    return copyWith(
      transitions: [...transitions, transition],
      updatedAt: DateTime.now(),
    );
  }

  /// Removes a step and its connected transitions.
  Workflow removeStep(String stepId) {
    return copyWith(
      steps: steps.where((s) => s.id != stepId).toList(),
      transitions: transitions
          .where((t) => t.fromStepId != stepId && t.toStepId != stepId)
          .toList(),
      updatedAt: DateTime.now(),
    );
  }

  /// Gets a step by ID.
  WorkflowStep? getStep(String stepId) {
    return steps.cast<WorkflowStep?>().firstWhere(
      (s) => s?.id == stepId,
      orElse: () => null,
    );
  }

  /// Gets transitions from a specific step.
  List<WorkflowTransition> getTransitionsFrom(String stepId) {
    return transitions.where((t) => t.fromStepId == stepId).toList();
  }

  /// Gets the next step based on a transition.
  WorkflowStep? getNextStep(String currentStepId, {String? condition}) {
    final transitions = getTransitionsFrom(currentStepId);
    if (transitions.isEmpty) return null;

    // For conditional transitions, find matching condition
    if (condition != null) {
      final matching = transitions.firstWhere(
        (t) => t.type == TransitionType.conditional && t.condition == condition,
        orElse: () => transitions.firstWhere(
          (t) => t.isDefault,
          orElse: () => transitions.first,
        ),
      );
      return getStep(matching.toStepId);
    }

    // Return first sequential transition or default
    return getStep(transitions.first.toStepId);
  }

  /// Converts this workflow to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'formId': formId,
      'name': name,
      'description': description,
      'status': status.name,
      'version': version,
      'steps': steps.map((s) => s.toJson()).toList(),
      'transitions': transitions.map((t) => t.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdBy': createdBy,
      'initialStepId': initialStepId,
      'finalStepIds': finalStepIds,
      'metadata': metadata,
    };
  }

  /// Creates a workflow from a JSON map.
  factory Workflow.fromJson(Map<String, dynamic> json) {
    return Workflow(
      id: json['id'] as String,
      formId: json['formId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      status: WorkflowStatus.values.byName(json['status'] as String),
      version: json['version'] as int,
      steps: (json['steps'] as List<dynamic>)
          .map((s) => WorkflowStep.fromJson(s as Map<String, dynamic>))
          .toList(),
      transitions: (json['transitions'] as List<dynamic>)
          .map((t) => WorkflowTransition.fromJson(t as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String,
      initialStepId: json['initialStepId'] as String?,
      finalStepIds:
          (json['finalStepIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}

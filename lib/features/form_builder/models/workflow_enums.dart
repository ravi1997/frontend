/// Represents the type of a workflow step.
enum WorkflowStepType {
  /// Start point of the workflow
  start,

  /// Manual action step requiring user input
  approval,

  /// Automated system action
  automation,

  /// End point of the workflow
  end,

  /// Condition step for branching logic
  condition,
}

/// Represents the status of a workflow or step.
enum WorkflowStatus {
  /// Workflow is in draft mode
  draft,

  /// Workflow is active and running
  active,

  /// Workflow is paused
  paused,

  /// Workflow has been completed
  completed,

  /// Workflow has been cancelled
  cancelled,
}

/// Represents the type of transition between steps.
enum TransitionType {
  /// Sequential progression to next step
  sequential,

  /// Conditional branching based on rules
  conditional,

  /// Parallel execution of multiple paths
  parallel,

  /// Escalation to higher authority
  escalation,
}

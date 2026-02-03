import '../entities/workflow.dart';

/// Repository interface for workflow operations.
///
/// Handles CRUD operations for workflow definitions associated with forms.
abstract class WorkflowRepository {
  /// Gets all workflows for a form.
  Future<List<Workflow>> getWorkflows(String formId);

  /// Gets a workflow by ID.
  Future<Workflow> getWorkflow(String workflowId);

  /// Creates a new workflow.
  Future<Workflow> createWorkflow(Workflow workflow);

  /// Updates an existing workflow.
  Future<Workflow> updateWorkflow(Workflow workflow);

  /// Deletes a workflow.
  Future<void> deleteWorkflow(String workflowId);

  /// Activates a workflow (changes status to active).
  Future<Workflow> activateWorkflow(String workflowId);

  /// Pauses an active workflow.
  Future<Workflow> pauseWorkflow(String workflowId);

  /// Resets a workflow to draft status.
  Future<Workflow> resetWorkflow(String workflowId);
}

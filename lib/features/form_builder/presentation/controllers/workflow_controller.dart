import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:frontend/features/auth/auth_controller.dart';
import '../../domain/entities/workflow.dart';
import '../../domain/entities/workflow_enums.dart';
import '../../domain/entities/workflow_step.dart';
import '../../domain/entities/workflow_transition.dart';
import '../../domain/repositories/workflow_repository.dart';
import '../../../../core/network/api_client_wrapper.dart';
import '../../data/repositories/workflow_repository_impl.dart';
import '../../../../core/controllers/base_controller_mixin.dart';

part 'workflow_controller.g.dart';

/// Provider for WorkflowRepository
@riverpod
WorkflowRepository workflowRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WorkflowRepositoryImpl(apiClient);
}

/// Controller for managing workflow builder state.
@riverpod
class WorkflowController extends _$WorkflowController with BaseControllerMixin {
  @override
  List<Workflow> build() {
    return [];
  }

  /// Loads all workflows for a form.
  Future<void> loadWorkflows(String formId) async {
    await executeOperation(
      operation: () async {
        final repository = ref.read(workflowRepositoryProvider);
        final workflows = await repository.getWorkflows(formId);
        state = workflows;
      },
    );
  }

  /// Gets a specific workflow by ID.
  Future<Workflow> getWorkflow(String workflowId) async {
    final repository = ref.read(workflowRepositoryProvider);
    return repository.getWorkflow(workflowId);
  }

  /// Creates a new workflow.
  Future<Workflow> createWorkflow({
    required String formId,
    required String name,
    String? description,
  }) async {
    final user = ref.read(authControllerProvider);
    final repository = ref.read(workflowRepositoryProvider);

    final createdBy = user.value?.id ?? 'unknown';

    final workflow = Workflow.create(
      formId: formId,
      name: name,
      description: description,
      createdBy: createdBy,
    );

    final created = await executeCreate(
      createOperation: () => repository.createWorkflow(workflow),
      entityName: 'workflow',
    );

    if (created != null) {
      state = [...state, created];
      return created;
    }

    throw Exception('Failed to create workflow');
  }

  /// Updates an existing workflow.
  Future<void> updateWorkflow(Workflow workflow) async {
    await executeUpdate(
      item: workflow,
      updateOperation: (w) async {
        final repository = ref.read(workflowRepositoryProvider);
        final updated = await repository.updateWorkflow(w);
        state = state.map((w) => w.id == updated.id ? updated : w).toList();
        return updated;
      },
      entityName: 'workflow',
    );
  }

  /// Deletes a workflow.
  Future<void> deleteWorkflow(String workflowId) async {
    await executeDelete(
      id: workflowId,
      deleteOperation: (id) async {
        final repository = ref.read(workflowRepositoryProvider);
        await repository.deleteWorkflow(id);
      },
      refreshAfterDelete: () async {
        state = state.where((w) => w.id != workflowId).toList();
      },
      entityName: 'workflow',
    );
  }

  /// Activates a workflow.
  Future<void> activateWorkflow(String workflowId) async {
    await executeOperation(
      operation: () async {
        final repository = ref.read(workflowRepositoryProvider);
        final updated = await repository.activateWorkflow(workflowId);
        state = state.map((w) => w.id == updated.id ? updated : w).toList();
      },
    );
  }

  /// Pauses a workflow.
  Future<void> pauseWorkflow(String workflowId) async {
    await executeOperation(
      operation: () async {
        final repository = ref.read(workflowRepositoryProvider);
        final updated = await repository.pauseWorkflow(workflowId);
        state = state.map((w) => w.id == updated.id ? updated : w).toList();
      },
    );
  }

  /// Adds a step to a workflow.
  Future<void> addStep(
    String workflowId, {
    required String name,
    required WorkflowStepType type,
    String? description,
    String? assigneeId,
  }) async {
    final workflow = state.firstWhere((w) => w.id == workflowId);
    final newStep = WorkflowStep(
      id: const Uuid().v4(),
      name: name,
      type: type,
      order: workflow.steps.length,
      description: description,
      assigneeId: assigneeId,
      allowedActions: _getDefaultActionsForType(type),
    );

    final updated = workflow.addStep(newStep);
    await updateWorkflow(updated);
  }

  /// Removes a step from a workflow.
  Future<void> removeStep(String workflowId, String stepId) async {
    final workflow = state.firstWhere((w) => w.id == workflowId);
    final updated = workflow.removeStep(stepId);
    await updateWorkflow(updated);
  }

  /// Updates a step in a workflow.
  Future<void> updateStep(String workflowId, WorkflowStep updatedStep) async {
    final workflow = state.firstWhere((w) => w.id == workflowId);
    final updatedSteps = workflow.steps
        .map((s) => s.id == updatedStep.id ? updatedStep : s)
        .toList();
    final updatedWorkflow = workflow.copyWith(
      steps: updatedSteps,
      updatedAt: DateTime.now(),
    );
    await updateWorkflow(updatedWorkflow);
  }

  /// Adds a transition between steps.
  Future<void> addTransition(
    String workflowId, {
    required String fromStepId,
    required String toStepId,
    TransitionType type = TransitionType.sequential,
    String? label,
  }) async {
    final workflow = state.firstWhere((w) => w.id == workflowId);
    final newTransition = WorkflowTransition(
      id: const Uuid().v4(),
      fromStepId: fromStepId,
      toStepId: toStepId,
      type: type,
      label: label,
    );

    final updated = workflow.addTransition(newTransition);
    await updateWorkflow(updated);
  }

  /// Sets initial step for a workflow.
  Future<void> setInitialStep(String workflowId, String stepId) async {
    final workflow = state.firstWhere((w) => w.id == workflowId);
    final updated = workflow.copyWith(initialStepId: stepId);
    await updateWorkflow(updated);
  }

  /// Gets default allowed actions for a step type.
  List<String> _getDefaultActionsForType(WorkflowStepType type) {
    switch (type) {
      case WorkflowStepType.approval:
        return ['approve', 'reject', 'request_changes'];
      case WorkflowStepType.automation:
        return ['execute'];
      case WorkflowStepType.condition:
        return ['evaluate'];
      default:
        return ['complete'];
    }
  }
}

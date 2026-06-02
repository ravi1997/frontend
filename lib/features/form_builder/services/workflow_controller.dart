import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:frontend/features/auth/auth_controller.dart';
import 'package:frontend/features/form_builder/models/workflow.dart';
import 'package:frontend/features/form_builder/models/workflow_enums.dart';
import 'package:frontend/features/form_builder/models/workflow_step.dart';
import 'package:frontend/features/form_builder/models/workflow_transition.dart';
import 'package:frontend/features/form_builder/services/workflow_repository.dart';

class WorkflowController extends ChangeNotifier {
  WorkflowController(this.ref);

  final Ref ref;
  List<Workflow> _state = const [];
  List<Workflow> get state => _state;
  set state(List<Workflow> value) {
    _state = value;
    notifyListeners();
  }

  Future<void> loadWorkflows(String formId) async {
    final repository = ref.read(workflowRepositoryProvider);
    state = List<Workflow>.from(await repository.getWorkflows(formId));
  }

  Future<Workflow> getWorkflow(String workflowId) async {
    final repository = ref.read(workflowRepositoryProvider);
    return repository.getWorkflow(workflowId);
  }

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
    final created = await repository.createWorkflow(workflow);
    state = [...state, created];
    return created;
  }

  Future<void> updateWorkflow(Workflow workflow) async {
    final repository = ref.read(workflowRepositoryProvider);
    final updated = await repository.updateWorkflow(workflow);
    state = List<Workflow>.from(
      state.map((w) => w.id == updated.id ? updated : w).toList(),
    );
  }

  Future<void> deleteWorkflow(String workflowId) async {
    final repository = ref.read(workflowRepositoryProvider);
    await repository.deleteWorkflow(workflowId);
    state = List<Workflow>.from(state.where((w) => w.id != workflowId));
  }

  Future<void> activateWorkflow(String workflowId) async {
    final repository = ref.read(workflowRepositoryProvider);
    final updated = await repository.activateWorkflow(workflowId);
    state = List<Workflow>.from(
      state.map((w) => w.id == updated.id ? updated : w).toList(),
    );
  }

  Future<void> pauseWorkflow(String workflowId) async {
    final repository = ref.read(workflowRepositoryProvider);
    final updated = await repository.pauseWorkflow(workflowId);
    state = List<Workflow>.from(
      state.map((w) => w.id == updated.id ? updated : w).toList(),
    );
  }

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
    await updateWorkflow(workflow.addStep(newStep));
  }

  Future<void> removeStep(String workflowId, String stepId) async {
    final workflow = state.firstWhere((w) => w.id == workflowId);
    await updateWorkflow(workflow.removeStep(stepId));
  }

  Future<void> updateStep(String workflowId, WorkflowStep updatedStep) async {
    final workflow = state.firstWhere((w) => w.id == workflowId);
    final updatedSteps = workflow.steps
        .map((s) => s.id == updatedStep.id ? updatedStep : s)
        .toList();
    await updateWorkflow(
      workflow.copyWith(steps: updatedSteps, updatedAt: DateTime.now()),
    );
  }

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
    await updateWorkflow(workflow.addTransition(newTransition));
  }

  Future<void> setInitialStep(String workflowId, String stepId) async {
    final workflow = state.firstWhere((w) => w.id == workflowId);
    await updateWorkflow(workflow.copyWith(initialStepId: stepId));
  }

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

final workflowControllerProvider = Provider<WorkflowController>((ref) {
  final controller = WorkflowController(ref);
  ref.onDispose(controller.dispose);
  return controller;
});

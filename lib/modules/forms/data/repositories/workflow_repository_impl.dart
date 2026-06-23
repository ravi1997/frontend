import 'package:logger/logger.dart';
import 'package:frontend/core/networking/api_client.dart';
import 'package:frontend/modules/forms/models/workflow.dart';
import 'package:frontend/modules/forms/services/workflow_repository.dart';

/// Implementation of [WorkflowRepository] for workflow operations.
///
/// Handles CRUD operations for workflow definitions via the backend API.
class WorkflowRepositoryImpl implements WorkflowRepository {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  WorkflowRepositoryImpl(this._apiClient);

  @override
  Future<List<Workflow>> getWorkflows(String formId) async {
    try {
      final data = await _apiClient.getWorkflows(formId);

      final workflows = data.map((item) {
        return Workflow.fromJson(item as Map<String, dynamic>);
      }).toList();

      _logger.i('Loaded ${workflows.length} workflows for form: $formId');
      return workflows;
    } catch (e, stack) {
      _logger.e('Failed to load workflows', error: e, stackTrace: stack);
      throw _createException(
        'Failed to load workflows for form: $formId',
        e,
        stack,
      );
    }
  }

  @override
  Future<Workflow> getWorkflow(String workflowId) async {
    try {
      final response = await _apiClient.getWorkflow(workflowId);
      _logger.i('Loaded workflow: $workflowId');
      return Workflow.fromJson(response);
    } catch (e, stack) {
      _logger.e('Failed to load workflow', error: e, stackTrace: stack);
      throw _createException('Failed to load workflow: $workflowId', e, stack);
    }
  }

  @override
  Future<Workflow> createWorkflow(Workflow workflow) async {
    try {
      final response = await _apiClient.createWorkflow(workflow);
      _logger.i('Created workflow: ${workflow.name}');
      return Workflow.fromJson(response);
    } catch (e, stack) {
      _logger.e('Failed to create workflow', error: e, stackTrace: stack);
      throw _createException(
        'Failed to create workflow: ${workflow.name}',
        e,
        stack,
      );
    }
  }

  @override
  Future<Workflow> updateWorkflow(Workflow workflow) async {
    try {
      final response = await _apiClient.updateWorkflow(workflow);
      _logger.i('Updated workflow: ${workflow.name}');
      return Workflow.fromJson(response);
    } catch (e, stack) {
      _logger.e('Failed to update workflow', error: e, stackTrace: stack);
      throw _createException(
        'Failed to update workflow: ${workflow.name}',
        e,
        stack,
      );
    }
  }

  @override
  Future<void> deleteWorkflow(String workflowId) async {
    try {
      await _apiClient.deleteWorkflow(workflowId);
      _logger.i('Deleted workflow: $workflowId');
    } catch (e, stack) {
      _logger.e('Failed to delete workflow', error: e, stackTrace: stack);
      throw _createException(
        'Failed to delete workflow: $workflowId',
        e,
        stack,
      );
    }
  }

  @override
  Future<Workflow> activateWorkflow(String workflowId) async {
    try {
      final response = await _apiClient.activateWorkflow(workflowId);
      _logger.i('Activated workflow: $workflowId');
      return Workflow.fromJson(response);
    } catch (e, stack) {
      _logger.e('Failed to activate workflow', error: e, stackTrace: stack);
      throw _createException(
        'Failed to activate workflow: $workflowId',
        e,
        stack,
      );
    }
  }

  @override
  Future<Workflow> pauseWorkflow(String workflowId) async {
    try {
      final response = await _apiClient.pauseWorkflow(workflowId);
      _logger.i('Paused workflow: $workflowId');
      return Workflow.fromJson(response);
    } catch (e, stack) {
      _logger.e('Failed to pause workflow', error: e, stackTrace: stack);
      throw _createException('Failed to pause workflow: $workflowId', e, stack);
    }
  }

  @override
  Future<Workflow> resetWorkflow(String workflowId) async {
    try {
      final response = await _apiClient.resetWorkflow(workflowId);
      _logger.i('Reset workflow to draft: $workflowId');
      return Workflow.fromJson(response);
    } catch (e, stack) {
      _logger.e('Failed to reset workflow', error: e, stackTrace: stack);
      throw _createException('Failed to reset workflow: $workflowId', e, stack);
    }
  }

  Exception _createException(String message, Object error, StackTrace stack) {
    return Exception('$message: $error');
  }
}

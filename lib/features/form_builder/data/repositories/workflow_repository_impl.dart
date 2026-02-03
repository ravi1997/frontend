import 'package:logger/logger.dart';
import '../../domain/entities/workflow.dart';
import '../../domain/repositories/workflow_repository.dart';
import '../../../../core/network/api_client_wrapper.dart';

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
      final response = await _apiClient.get('/forms/$formId/workflows');
      final data = response.data as List<dynamic>;

      final workflows = data.map((item) {
        return Workflow.fromJson(item as Map<String, dynamic>);
      }).toList();

      _logger.i('Loaded ${workflows.length} workflows for form: $formId');
      return workflows;
    } catch (e, stack) {
      _logger.e('Failed to load workflows: $e');
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
      final response = await _apiClient.get('/workflows/$workflowId');

      _logger.i('Loaded workflow: $workflowId');
      return Workflow.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stack) {
      _logger.e('Failed to load workflow: $e');
      throw _createException('Failed to load workflow: $workflowId', e, stack);
    }
  }

  @override
  Future<Workflow> createWorkflow(Workflow workflow) async {
    try {
      final response = await _apiClient.post(
        '/forms/${workflow.formId}/workflows',
        data: workflow.toJson(),
      );

      _logger.i('Created workflow: ${workflow.name}');
      return Workflow.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stack) {
      _logger.e('Failed to create workflow: $e');
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
      final response = await _apiClient.put(
        '/workflows/${workflow.id}',
        data: workflow.toJson(),
      );

      _logger.i('Updated workflow: ${workflow.name}');
      return Workflow.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stack) {
      _logger.e('Failed to update workflow: $e');
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
      await _apiClient.delete('/workflows/$workflowId');
      _logger.i('Deleted workflow: $workflowId');
    } catch (e, stack) {
      _logger.e('Failed to delete workflow: $e');
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
      final response = await _apiClient.post('/workflows/$workflowId/activate');

      _logger.i('Activated workflow: $workflowId');
      return Workflow.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stack) {
      _logger.e('Failed to activate workflow: $e');
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
      final response = await _apiClient.post('/workflows/$workflowId/pause');

      _logger.i('Paused workflow: $workflowId');
      return Workflow.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stack) {
      _logger.e('Failed to pause workflow: $e');
      throw _createException('Failed to pause workflow: $workflowId', e, stack);
    }
  }

  @override
  Future<Workflow> resetWorkflow(String workflowId) async {
    try {
      final response = await _apiClient.post('/workflows/$workflowId/reset');

      _logger.i('Reset workflow to draft: $workflowId');
      return Workflow.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stack) {
      _logger.e('Failed to reset workflow: $e');
      throw _createException('Failed to reset workflow: $workflowId', e, stack);
    }
  }

  Exception _createException(String message, Object error, StackTrace stack) {
    return Exception('$message: $error');
  }
}

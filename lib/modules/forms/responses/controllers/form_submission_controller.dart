import 'package:frontend/core/errors/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../form_response.dart';
import '../sync_service.dart';
import '../../../../core/services/connectivity_service.dart';
import 'package:uuid/uuid.dart';
import '../response_repository_provider.dart';
import '../response_mapper.dart';

final formSubmissionControllerProvider =
    NotifierProvider<FormSubmissionController, AsyncValue<void>>(
      FormSubmissionController.new,
    );

class FormSubmissionController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<bool> submit({
    required String projectId,
    required String formId,
    required Map<String, dynamic> answers,
    required Map<String, bool> visibilityMap,
    Map<String, int>? repeatInstances,
  }) async {
    state = const AsyncValue.loading();

    // Prune hidden fields and transform to nested structure
    final prunedAnswers = ResponseMapper.toBackendPayload(
      answers,
      visibilityMap,
      repeatInstances: repeatInstances,
    );

    final response = FormResponse(
      id: const Uuid().v4(),
      formId: formId,
      organizationId: '',
      submittedBy: '',
      submittedAt: DateTime.now(),
      answers: prunedAnswers,
    );

    final isOnline = ref.read(connectivityServiceProvider).isConnected;

    if (!isOnline) {
      await ref
          .read(syncServiceProvider.notifier)
          .addPendingSubmission(response, projectId: projectId);
      state = const AsyncValue.data(null);
      return true; // Success in terms of being queued
    }

    try {
      final repository = ref.read(responseRepositoryProvider);
      await repository.submitProjectResponse(projectId, response);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      if (e is ApiException && (e.statusCode == 400 || e.statusCode == 403)) {
        state = AsyncValue.error(e, st);
        return false;
      }

      // Queue submission for later retry when the backend is unreachable.
      await ref
          .read(syncServiceProvider.notifier)
          .addPendingSubmission(response, projectId: projectId);
      state = const AsyncValue.data(null);
      return true; // Still "success" because it's queued
    }
  }

  Future<bool> submitFormResponse({
    required String formId,
    required Map<String, dynamic> responseData,
  }) async {
    state = const AsyncValue.loading();

    try {
      final repository = ref.read(responseRepositoryProvider);
      
      // Extract project ID from response data if available
      final projectId = responseData['project_id'] ?? '';
      
      // Create form response object
      final response = FormResponse(
        id: const Uuid().v4(),
        formId: formId,
        organizationId: responseData['organization_id'] ?? '',
        submittedBy: responseData['submitted_by'] ?? '',
        submittedAt: DateTime.now(),
        answers: responseData['answers'] ?? {},
      );

      // Submit the response
      await repository.submitProjectResponse(projectId, response);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      if (e is ApiException && (e.statusCode == 400 || e.statusCode == 403)) {
        state = AsyncValue.error(e, st);
        return false;
      }

      // Queue submission for later retry when the backend is unreachable
      final response = FormResponse(
        id: const Uuid().v4(),
        formId: formId,
        organizationId: responseData['organization_id'] ?? '',
        submittedBy: responseData['submitted_by'] ?? '',
        submittedAt: DateTime.now(),
        answers: responseData['answers'] ?? {},
      );

      final projectId = responseData['project_id'] ?? '';
      await ref
          .read(syncServiceProvider.notifier)
          .addPendingSubmission(response, projectId: projectId);
      state = const AsyncValue.data(null);
      return true; // Still "success" because it's queued
    }
  }
}

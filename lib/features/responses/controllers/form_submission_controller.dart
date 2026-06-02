import 'package:frontend/core/exceptions/app_exception.dart';
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

    final isOnline = await ref.read(connectivityServiceProvider).isConnected;

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

      // Fallback to offline storage on network failure
      await ref
          .read(syncServiceProvider.notifier)
          .addPendingSubmission(response, projectId: projectId);
      state = const AsyncValue.data(null);
      return true; // Still "success" because it's queued
    }
  }
}

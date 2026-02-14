import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/form_response.dart';
import '../../data/services/sync_service.dart';
import '../../../../core/services/connectivity_service.dart';
import 'package:uuid/uuid.dart';
import '../../data/repositories/response_repository_impl.dart';

part 'form_submission_controller.g.dart';

@riverpod
class FormSubmissionController extends _$FormSubmissionController {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<bool> submit(String formId, Map<String, dynamic> answers) async {
    state = const AsyncValue.loading();

    final response = FormResponse(
      id: const Uuid().v4(),
      formId: formId,
      submittedAt: DateTime.now(),
      answers: answers,
    );

    final isOnline =
        ref.read(connectivityServiceProvider) == ConnectivityStatus.online;

    if (!isOnline) {
      await ref
          .read(syncServiceProvider.notifier)
          .addPendingSubmission(response);
      state = const AsyncValue.data(null);
      return true; // Success in terms of being queued
    }

    try {
      final repository = ref.read(responseRepositoryProvider);
      await repository.submitResponse(response);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      // Fallback to offline storage on network failure
      await ref
          .read(syncServiceProvider.notifier)
          .addPendingSubmission(response);
      state = AsyncValue.error(e, st);
      return true; // Still "success" because it's queued
    }
  }
}

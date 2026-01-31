import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/features/responses/domain/entities/form_response.dart';
import 'package:frontend/features/responses/data/repositories/mock_response_repository.dart';

part 'responses_controller.g.dart';

@riverpod
Future<List<FormResponse>> formResponses(Ref ref, String formId) {
  final repository = ref.watch(responseRepositoryProvider);
  return repository.getResponsesForForm(formId);
}

@riverpod
Future<FormResponse> responseDetail(Ref ref, String responseId) {
  final repository = ref.watch(responseRepositoryProvider);
  return repository.getResponseDetail(responseId);
}

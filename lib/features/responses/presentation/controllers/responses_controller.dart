import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/features/responses/domain/entities/form_response.dart';
import 'package:frontend/features/responses/data/repositories/response_repository_impl.dart';
import 'package:frontend/features/responses/domain/entities/response_history.dart';

part 'responses_controller.g.dart';

@riverpod
Future<List<FormResponse>> formResponses(
  Ref ref,
  String projectId,
  String formId, {
  String? searchQuery,
}) {
  final repository = ref.watch(responseRepositoryProvider);
  if (searchQuery != null && searchQuery.isNotEmpty) {
    return repository.aiSearch(formId, searchQuery);
  }
  return repository.getProjectResponses(projectId, formId);
}

@riverpod
Future<FormResponse> responseDetail(
  Ref ref,
  String projectId,
  String formId,
  String responseId,
) {
  final repository = ref.watch(responseRepositoryProvider);
  return repository.getProjectResponseDetail(projectId, formId, responseId);
}

@riverpod
Future<List<ResponseHistory>> responseHistory(
  Ref ref,
  String projectId,
  String formId,
  String responseId,
) {
  final repository = ref.watch(responseRepositoryProvider);
  return repository.getProjectResponseHistory(projectId, formId, responseId);
}

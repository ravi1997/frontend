import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/features/form_builder/data/repositories/ai_repository_impl.dart';

part 'ai_controller.g.dart';

@riverpod
class AIController extends _$AIController {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<Map<String, dynamic>> analyzeResponse(
    String formId,
    String responseId,
  ) async {
    state = const AsyncLoading();
    try {
      final results = await ref
          .read(aiRepositoryProvider)
          .analyzeResponse(formId, responseId);
      state = const AsyncData(null);
      return results;
    } catch (e, s) {
      state = AsyncError(e, s);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> moderateResponse(
    String formId,
    String responseId,
  ) async {
    state = const AsyncLoading();
    try {
      final results = await ref
          .read(aiRepositoryProvider)
          .moderateResponse(formId, responseId);
      state = const AsyncData(null);
      return results;
    } catch (e, s) {
      state = AsyncError(e, s);
      rethrow;
    }
  }
}

@riverpod
Future<Map<String, dynamic>> sentimentTrends(Ref ref, String formId) {
  return ref.watch(aiRepositoryProvider).getFormSentimentTrends(formId);
}

@riverpod
Future<Map<String, dynamic>> anomalies(Ref ref, String formId) {
  return ref.watch(aiRepositoryProvider).detectAnomalies(formId);
}

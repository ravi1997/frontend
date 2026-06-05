import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/modules/forms/data/repositories/ai_repository_impl.dart';

final aiControllerProvider = AsyncNotifierProvider<AIController, void>(
  AIController.new,
);

// Backwards-compatible alias for the previous codegen name.
final aIControllerProvider = aiControllerProvider;

final sentimentTrendsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, formId) {
      return ref.watch(aiRepositoryProvider).getFormSentimentTrends(formId);
    });

final anomaliesProvider = FutureProvider.family<Map<String, dynamic>, String>((
  ref,
  formId,
) {
  return ref.watch(aiRepositoryProvider).detectAnomalies(formId);
});

class AIController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<Map<String, dynamic>> analyzeResponse(
    String formId,
    String responseId,
  ) async {
    state = const AsyncValue<void>.loading();
    try {
      final results = await ref
          .read(aiRepositoryProvider)
          .analyzeResponse(formId, responseId);
      if (ref.mounted) {
        state = const AsyncValue<void>.data(null);
      }
      return results;
    } catch (e, s) {
      if (ref.mounted) {
        state = AsyncValue<void>.error(e, s);
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> moderateResponse(
    String formId,
    String responseId,
  ) async {
    state = const AsyncValue<void>.loading();
    try {
      final results = await ref
          .read(aiRepositoryProvider)
          .moderateResponse(formId, responseId);
      if (ref.mounted) {
        state = const AsyncValue<void>.data(null);
      }
      return results;
    } catch (e, s) {
      if (ref.mounted) {
        state = AsyncValue<void>.error(e, s);
      }
      rethrow;
    }
  }
}

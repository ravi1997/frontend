import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/modules/auth/auth_controller.dart';
import 'package:frontend/modules/forms/data/repositories/translation_repository_impl.dart';
import 'package:frontend/modules/forms/models/translation_job.dart';
import 'package:frontend/modules/forms/models/translation_language.dart';
import 'package:frontend/modules/forms/services/form_builder_repository.dart';
import 'package:frontend/modules/forms/services/translation_repository.dart';
import 'package:frontend/core/networking/dio_provider.dart';

class TranslationController extends ChangeNotifier {
  TranslationController(this.ref);

  final Ref ref;
  List<TranslationJob> _state = const [];
  List<TranslationJob> get state => _state;
  set state(List<TranslationJob> value) {
    _state = value;
    notifyListeners();
  }

  Future<List<TranslationLanguage>> loadLanguages() async {
    final repository = ref.read(translationRepositoryProvider);
    final languages = await repository.getAvailableLanguages();
    return languages
        .whereType<TranslationLanguage>()
        .where((l) => l.isEnabled == true)
        .toList();
  }

  Future<void> loadTranslationJobs(String formId) async {
    final repository = ref.read(translationRepositoryProvider);
    state = await repository.getTranslationJobs(formId);
  }

  Future<TranslationJob> startTranslation({
    required String formId,
    required String sourceLanguage,
    required List<String> targetLanguages,
    required int totalFields,
  }) async {
    final user = ref.read(authControllerProvider);
    final repository = ref.read(translationRepositoryProvider);
    final createdBy = user.value?.id ?? 'unknown';
    final job = await repository.startTranslationJob(
      formId: formId,
      sourceLanguage: sourceLanguage,
      targetLanguages: targetLanguages,
      createdBy: createdBy,
      totalFields: totalFields,
    );
    state = [...state, job];
    return job;
  }

  Future<TranslationJob> getTranslationJob(String jobId) async {
    final repository = ref.read(translationRepositoryProvider);
    return repository.getTranslationJob(jobId);
  }

  Future<void> cancelTranslationJob(String jobId) async {
    final repository = ref.read(translationRepositoryProvider);
    final updated = await repository.cancelTranslationJob(jobId);
    state = state.map((j) => j.id == jobId ? updated : j).toList();
  }

  Future<void> deleteTranslationJob(String jobId) async {
    final repository = ref.read(translationRepositoryProvider);
    await repository.deleteTranslationJob(jobId);
    state = state.where((j) => j.id != jobId).toList();
  }

  Future<String> previewTranslation({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    final repository = ref.read(translationRepositoryProvider);
    return repository.translateText(
      text: text,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );
  }

  List<TranslationJob> getJobsByStatus(TranslationJobStatus status) {
    return state.where((j) => j.status == status).toList();
  }

  TranslationJob? getMostRecentJob() {
    if (state.isEmpty) return null;
    return state.reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b);
  }

  Future<Map<String, dynamic>?> getTranslatedContent(String jobId) async {
    final repository = ref.read(translationRepositoryProvider);
    return repository.getTranslatedContent(jobId);
  }

  Future<Map<String, dynamic>> getManualTranslations(
    String formId, {
    String? language,
  }) async {
  final repository = ref.read(formBuilderRepositoryProvider);
    return repository.getTranslations(formId, language: language);
  }

  Future<void> saveManualTranslations(
    String formId,
    String language,
    Map<String, dynamic> translations,
  ) async {
    final repository = ref.read(formBuilderRepositoryProvider);
    await repository.saveTranslations(formId, language, translations);
  }
}

final translationRepositoryProvider = Provider<TranslationRepository>((ref) {
  return TranslationRepositoryImpl(ref.watch(apiClientProvider));
});

final translationControllerProvider = Provider<TranslationController>((ref) {
  final controller = TranslationController(ref);
  ref.onDispose(controller.dispose);
  return controller;
});

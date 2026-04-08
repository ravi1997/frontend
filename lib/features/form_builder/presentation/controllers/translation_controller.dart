import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/translation_job.dart';
import '../../domain/entities/translation_language.dart';
import '../../domain/repositories/translation_repository.dart';
import '../../domain/repositories/form_builder_repository.dart';
import '../../../../core/network/api_client_wrapper.dart';
import '../../data/repositories/translation_repository_impl.dart';
import '../../../../core/controllers/base_controller_mixin.dart';

part 'translation_controller.g.dart';

/// Provider for TranslationRepository
@riverpod
TranslationRepository translationRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TranslationRepositoryImpl(apiClient);
}

/// Controller for managing bulk translation operations.
@riverpod
class TranslationController extends _$TranslationController
    with BaseControllerMixin {
  @override
  List<TranslationJob> build() {
    return [];
  }

  /// Loads available languages.
  Future<List<TranslationLanguage>> loadLanguages() async {
    await executeOperation(
      operation: () async {
        final repository = ref.read(translationRepositoryProvider);
        final languages = await repository.getAvailableLanguages();
        return languages.where((l) => l.isEnabled).toList();
      },
    );
    return [];
  }

  /// Loads translation jobs for a form.
  Future<void> loadTranslationJobs(String formId) async {
    await executeOperation(
      operation: () async {
        final repository = ref.read(translationRepositoryProvider);
        final jobs = await repository.getTranslationJobs(formId);
        state = jobs;
      },
    );
  }

  /// Starts a new translation job.
  Future<TranslationJob> startTranslation({
    required String formId,
    required String sourceLanguage,
    required List<String> targetLanguages,
    required int totalFields,
  }) async {
    final user = ref.read(authControllerProvider);
    final repository = ref.read(translationRepositoryProvider);

    final createdBy = user.value?.id ?? 'unknown';

    final job = await executeCreate(
      createOperation: () => repository.startTranslationJob(
        formId: formId,
        sourceLanguage: sourceLanguage,
        targetLanguages: targetLanguages,
        createdBy: createdBy,
        totalFields: totalFields,
      ),
      entityName: 'translation job',
    );

    if (job != null) {
      state = [...state, job];
      return job;
    }

    throw Exception('Failed to start translation job');
  }

  /// Gets a specific translation job.
  Future<TranslationJob> getTranslationJob(String jobId) async {
    final repository = ref.read(translationRepositoryProvider);
    return repository.getTranslationJob(jobId);
  }

  /// Cancels a translation job.
  Future<void> cancelTranslationJob(String jobId) async {
    await executeOperation(
      operation: () async {
        final repository = ref.read(translationRepositoryProvider);
        final updated = await repository.cancelTranslationJob(jobId);
        state = state.map((j) => j.id == jobId ? updated : j).toList();
      },
    );
  }

  /// Deletes a translation job.
  Future<void> deleteTranslationJob(String jobId) async {
    await executeDelete(
      id: jobId,
      deleteOperation: (id) async {
        final repository = ref.read(translationRepositoryProvider);
        await repository.deleteTranslationJob(id);
      },
      refreshAfterDelete: () async {
        state = state.where((j) => j.id != jobId).toList();
      },
      entityName: 'translation job',
    );
  }

  /// Previews a single translation.
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

  /// Gets jobs filtered by status.
  List<TranslationJob> getJobsByStatus(TranslationJobStatus status) {
    return state.where((j) => j.status == status).toList();
  }

  /// Gets most recent job.
  TranslationJob? getMostRecentJob() {
    if (state.isEmpty) return null;
    return state.reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b);
  }

  /// Gets translated content for a job.
  Future<Map<String, dynamic>?> getTranslatedContent(String jobId) async {
    final repository = ref.read(translationRepositoryProvider);
    return repository.getTranslatedContent(jobId);
  }

  /// Gets manual translations for a form.
  Future<Map<String, dynamic>> getManualTranslations(
    String formId, {
    String? language,
  }) async {
    final repository = ref.read(formBuilderRepositoryProvider);
    return repository.getTranslations(formId, language: language);
  }

  /// Saves manual translations for a form.
  Future<void> saveManualTranslations(
    String formId,
    String language,
    Map<String, dynamic> translations,
  ) async {
    await executeOperation(
      operation: () async {
        final repository = ref.read(formBuilderRepositoryProvider);
        await repository.saveTranslations(formId, language, translations);
      },
    );
  }
}

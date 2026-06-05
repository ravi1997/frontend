import 'package:frontend/modules/forms/models/translation_job.dart';
import 'package:frontend/modules/forms/models/translation_language.dart';

/// Repository interface for translation operations.
///
/// Handles bulk translation and translation job management.
abstract class TranslationRepository {
  /// Gets available languages for translation.
  Future<List<TranslationLanguage>> getAvailableLanguages();

  /// Starts a new bulk translation job.
  Future<TranslationJob> startTranslationJob({
    required String formId,
    required String sourceLanguage,
    required List<String> targetLanguages,
    required String createdBy,
    required int totalFields,
  });

  /// Gets a translation job by ID.
  Future<TranslationJob> getTranslationJob(String jobId);

  /// Gets all translation jobs for a form.
  Future<List<TranslationJob>> getTranslationJobs(String formId);

  /// Cancels a translation job.
  Future<TranslationJob> cancelTranslationJob(String jobId);

  /// Deletes a translation job.
  Future<void> deleteTranslationJob(String jobId);

  /// Translates a single field (for preview).
  Future<String> translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  });

  /// Gets the translated content for a completed job.
  Future<Map<String, dynamic>?> getTranslatedContent(String jobId);
}

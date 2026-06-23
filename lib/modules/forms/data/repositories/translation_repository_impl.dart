import 'package:logger/logger.dart';
import 'package:frontend/core/networking/api_client.dart';
import 'package:frontend/core/networking/api_requests.dart';
import 'package:frontend/modules/forms/models/translation_job.dart';
import 'package:frontend/modules/forms/models/translation_language.dart';
import 'package:frontend/modules/forms/services/translation_repository.dart';

/// Implementation of [TranslationRepository] for translation operations.
///
/// Handles bulk translation and translation job management via the backend API.
class TranslationRepositoryImpl implements TranslationRepository {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  TranslationRepositoryImpl(this._apiClient);

  @override
  Future<List<TranslationLanguage>> getAvailableLanguages() async {
    try {
      final data = await _apiClient.listTranslationLanguages();
      final languages = data.map((item) {
        return TranslationLanguage.fromJson(item as Map<String, dynamic>);
      }).toList();

      _logger.i('Loaded ${languages.length} available languages');
      return languages;
    } catch (e, stack) {
      _logger.e('Failed to load languages', error: e, stackTrace: stack);
      throw _createException('Failed to load available languages', e, stack);
    }
  }

  @override
  Future<TranslationJob> startTranslationJob({
    required String formId,
    required String sourceLanguage,
    required List<String> targetLanguages,
    required String createdBy,
    required int totalFields,
  }) async {
    try {
      final response = await _apiClient.startTranslationJob(
        TranslationJobRequest(
          formId: formId,
          sourceLanguage: sourceLanguage,
          targetLanguages: targetLanguages,
          createdBy: createdBy,
          totalFields: totalFields,
        ),
      );
      _logger.i('Started translation job for form: $formId');
      return TranslationJob.fromJson(response);
    } catch (e, stack) {
      _logger.e('Failed to start translation', error: e, stackTrace: stack);
      throw _createException('Failed to start translation job', e, stack);
    }
  }

  @override
  Future<TranslationJob> getTranslationJob(String jobId) async {
    try {
      final response = await _apiClient.getTranslationJob(jobId);
      _logger.i('Loaded translation job: $jobId');
      return TranslationJob.fromJson(response);
    } catch (e, stack) {
      _logger.e('Failed to load translation job', error: e, stackTrace: stack);
      throw _createException(
        'Failed to load translation job: $jobId',
        e,
        stack,
      );
    }
  }

  @override
  Future<List<TranslationJob>> getTranslationJobs(String formId) async {
    try {
      final data = await _apiClient.listTranslationJobs(formId);

      final jobs = data.map((item) {
        return TranslationJob.fromJson(item as Map<String, dynamic>);
      }).toList();

      _logger.i('Loaded ${jobs.length} translation jobs for form: $formId');
      return jobs;
    } catch (e, stack) {
      _logger.e('Failed to load translation jobs', error: e, stackTrace: stack);
      throw _createException('Failed to load translation jobs', e, stack);
    }
  }

  @override
  Future<TranslationJob> cancelTranslationJob(String jobId) async {
    try {
      final response = await _apiClient.cancelTranslationJob(jobId);
      _logger.i('Cancelled translation job: $jobId');
      return TranslationJob.fromJson(response);
    } catch (e, stack) {
      _logger.e(
        'Failed to cancel translation job',
        error: e,
        stackTrace: stack,
      );
      throw _createException(
        'Failed to cancel translation job: $jobId',
        e,
        stack,
      );
    }
  }

  @override
  Future<void> deleteTranslationJob(String jobId) async {
    try {
      await _apiClient.deleteTranslationJob(jobId);
      _logger.i('Deleted translation job: $jobId');
    } catch (e, stack) {
      _logger.e(
        'Failed to delete translation job',
        error: e,
        stackTrace: stack,
      );
      throw _createException(
        'Failed to delete translation job: $jobId',
        e,
        stack,
      );
    }
  }

  @override
  Future<String> translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    try {
      final response = await _apiClient.previewTranslation(
        TranslationPreviewRequest(
          text: text,
          sourceLanguage: sourceLanguage,
          targetLanguage: targetLanguage,
        ),
      );

      _logger.i('Translated text from $sourceLanguage to $targetLanguage');
      return response['translated_text'] as String;
    } catch (e, stack) {
      _logger.e('Failed to translate text', error: e, stackTrace: stack);
      throw _createException('Failed to translate text', e, stack);
    }
  }

  @override
  Future<Map<String, dynamic>?> getTranslatedContent(String jobId) async {
    try {
      final response = await _apiClient.getTranslatedContent(jobId);
      _logger.i('Fetched translated content for job: $jobId');
      return response;
    } catch (e, stack) {
      _logger.e(
        'Failed to fetch translated content',
        error: e,
        stackTrace: stack,
      );
      throw _createException(
        'Failed to fetch translated content: $jobId',
        e,
        stack,
      );
    }
  }

  Exception _createException(String message, Object error, StackTrace stack) {
    return Exception('$message: $error');
  }
}

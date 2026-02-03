import 'package:logger/logger.dart';
import '../../domain/entities/translation_job.dart';
import '../../domain/entities/translation_language.dart';
import '../../domain/repositories/translation_repository.dart';
import '../../../../core/network/api_client_wrapper.dart';

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
      final response = await _apiClient.get('/translations/languages');
      final data = response.data as List<dynamic>;

      final languages = data.map((item) {
        return TranslationLanguage.fromJson(item as Map<String, dynamic>);
      }).toList();

      _logger.i('Loaded ${languages.length} available languages');
      return languages;
    } catch (e, stack) {
      _logger.e('Failed to load languages: $e');
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
      final response = await _apiClient.post(
        '/forms/$formId/translations',
        data: {
          'sourceLanguage': sourceLanguage,
          'targetLanguages': targetLanguages,
          'createdBy': createdBy,
          'totalFields': totalFields,
        },
      );

      _logger.i('Started translation job for form: $formId');
      return TranslationJob.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stack) {
      _logger.e('Failed to start translation: $e');
      throw _createException('Failed to start translation job', e, stack);
    }
  }

  @override
  Future<TranslationJob> getTranslationJob(String jobId) async {
    try {
      final response = await _apiClient.get('/translations/jobs/$jobId');

      _logger.i('Loaded translation job: $jobId');
      return TranslationJob.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stack) {
      _logger.e('Failed to load translation job: $e');
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
      final response = await _apiClient.get('/forms/$formId/translations');
      final data = response.data as List<dynamic>;

      final jobs = data.map((item) {
        return TranslationJob.fromJson(item as Map<String, dynamic>);
      }).toList();

      _logger.i('Loaded ${jobs.length} translation jobs for form: $formId');
      return jobs;
    } catch (e, stack) {
      _logger.e('Failed to load translation jobs: $e');
      throw _createException('Failed to load translation jobs', e, stack);
    }
  }

  @override
  Future<TranslationJob> cancelTranslationJob(String jobId) async {
    try {
      final response = await _apiClient.post(
        '/translations/jobs/$jobId/cancel',
      );

      _logger.i('Cancelled translation job: $jobId');
      return TranslationJob.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stack) {
      _logger.e('Failed to cancel translation job: $e');
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
      await _apiClient.delete('/translations/jobs/$jobId');
      _logger.i('Deleted translation job: $jobId');
    } catch (e, stack) {
      _logger.e('Failed to delete translation job: $e');
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
      final response = await _apiClient.post(
        '/translations/translate',
        data: {
          'text': text,
          'sourceLanguage': sourceLanguage,
          'targetLanguage': targetLanguage,
        },
      );

      _logger.i('Translated text from $sourceLanguage to $targetLanguage');
      return response.data['translatedText'] as String;
    } catch (e, stack) {
      _logger.e('Failed to translate text: $e');
      throw _createException('Failed to translate text', e, stack);
    }
  }

  Exception _createException(String message, Object error, StackTrace stack) {
    return Exception('$message: $error');
  }
}

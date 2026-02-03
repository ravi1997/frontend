import 'translation_language.dart';

/// Status of a translation job.
enum TranslationJobStatus { pending, inProgress, completed, failed, cancelled }

/// Represents a bulk translation job.
class TranslationJob {
  /// Unique identifier for this job.
  final String id;

  /// Form ID being translated.
  final String formId;

  /// Source language code.
  final String sourceLanguage;

  /// Target language codes.
  final List<String> targetLanguages;

  /// Current status.
  final TranslationJobStatus status;

  /// Progress percentage (0-100).
  final int progress;

  /// Total number of fields to translate.
  final int totalFields;

  /// Number of fields completed.
  final int completedFields;

  /// Number of fields that failed.
  final int failedFields;

  /// Created timestamp.
  final DateTime createdAt;

  /// Started timestamp.
  final DateTime? startedAt;

  /// Completed timestamp.
  final DateTime? completedAt;

  /// Created by user ID.
  final String createdBy;

  /// Error message if failed.
  final String? errorMessage;

  /// Results for each target language.
  final Map<String, TranslationResult>? results;

  const TranslationJob({
    required this.id,
    required this.formId,
    required this.sourceLanguage,
    required this.targetLanguages,
    required this.status,
    required this.progress,
    required this.totalFields,
    required this.completedFields,
    required this.failedFields,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    required this.createdBy,
    this.errorMessage,
    this.results,
  });

  /// Creates a new translation job.
  factory TranslationJob.create({
    required String formId,
    required String sourceLanguage,
    required List<String> targetLanguages,
    required String createdBy,
    required int totalFields,
  }) {
    final now = DateTime.now();
    return TranslationJob(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      formId: formId,
      sourceLanguage: sourceLanguage,
      targetLanguages: targetLanguages,
      status: TranslationJobStatus.pending,
      progress: 0,
      totalFields: totalFields,
      completedFields: 0,
      failedFields: 0,
      createdAt: now,
      createdBy: createdBy,
    );
  }

  /// Creates a copy with updated values.
  TranslationJob copyWith({
    String? id,
    String? formId,
    String? sourceLanguage,
    List<String>? targetLanguages,
    TranslationJobStatus? status,
    int? progress,
    int? totalFields,
    int? completedFields,
    int? failedFields,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
    String? createdBy,
    String? errorMessage,
    Map<String, TranslationResult>? results,
  }) {
    return TranslationJob(
      id: id ?? this.id,
      formId: formId ?? this.formId,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguages: targetLanguages ?? this.targetLanguages,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      totalFields: totalFields ?? this.totalFields,
      completedFields: completedFields ?? this.completedFields,
      failedFields: failedFields ?? this.failedFields,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      createdBy: createdBy ?? this.createdBy,
      errorMessage: errorMessage ?? this.errorMessage,
      results: results ?? this.results,
    );
  }

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'formId': formId,
      'sourceLanguage': sourceLanguage,
      'targetLanguages': targetLanguages,
      'status': status.name,
      'progress': progress,
      'totalFields': totalFields,
      'completedFields': completedFields,
      'failedFields': failedFields,
      'createdAt': createdAt.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'createdBy': createdBy,
      'errorMessage': errorMessage,
      'results': results?.map((k, v) => MapEntry(k, v.toJson())),
    };
  }

  /// Creates from JSON.
  factory TranslationJob.fromJson(Map<String, dynamic> json) {
    return TranslationJob(
      id: json['id'] as String,
      formId: json['formId'] as String,
      sourceLanguage: json['sourceLanguage'] as String,
      targetLanguages: (json['targetLanguages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      status: TranslationJobStatus.values.byName(json['status'] as String),
      progress: json['progress'] as int,
      totalFields: json['totalFields'] as int,
      completedFields: json['completedFields'] as int,
      failedFields: json['failedFields'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      createdBy: json['createdBy'] as String,
      errorMessage: json['errorMessage'] as String?,
      results: json['results'] != null
          ? Map<String, TranslationResult>.from(
              (json['results'] as Map<String, dynamic>).map(
                (k, v) => MapEntry(k, TranslationResult.fromJson(v)),
              ),
            )
          : null,
    );
  }
}

/// Result of translating to a single language.
class TranslationResult {
  /// Language code.
  final String languageCode;

  /// Number of fields successfully translated.
  final int successCount;

  /// Number of fields that failed.
  final int failureCount;

  /// Whether the translation was successful.
  final bool success;

  /// Error message if failed.
  final String? errorMessage;

  const TranslationResult({
    required this.languageCode,
    required this.successCount,
    required this.failureCount,
    required this.success,
    this.errorMessage,
  });

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    return {
      'languageCode': languageCode,
      'successCount': successCount,
      'failureCount': failureCount,
      'success': success,
      'errorMessage': errorMessage,
    };
  }

  /// Creates from JSON.
  factory TranslationResult.fromJson(Map<String, dynamic> json) {
    return TranslationResult(
      languageCode: json['languageCode'] as String,
      successCount: json['successCount'] as int,
      failureCount: json['failureCount'] as int,
      success: json['success'] as bool,
      errorMessage: json['errorMessage'] as String?,
    );
  }
}

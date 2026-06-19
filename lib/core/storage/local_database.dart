import 'package:hive_flutter/hive_flutter.dart';

class CachedFormRecord {
  final String id;
  final String title;
  final String slug;
  final String rawJson;
  final DateTime cachedAt;

  const CachedFormRecord({
    required this.id,
    required this.title,
    required this.slug,
    required this.rawJson,
    required this.cachedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'slug': slug,
        'rawJson': rawJson,
        'cachedAt': cachedAt.toIso8601String(),
      };

  factory CachedFormRecord.fromJson(Map<String, dynamic> json) {
    return CachedFormRecord(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      rawJson: json['rawJson']?.toString() ?? '{}',
      cachedAt: DateTime.tryParse(json['cachedAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}

class CachedResponseRecord {
  final String id;
  final String formId;
  final String dataJson;
  final String status;
  final DateTime createdAt;

  const CachedResponseRecord({
    required this.id,
    required this.formId,
    required this.dataJson,
    required this.status,
    required this.createdAt,
  });
}

class PendingUploadRecord {
  final String id;
  final String formId;
  final String payloadJson;
  final DateTime queuedAt;
  final int retryCount;

  const PendingUploadRecord({
    required this.id,
    required this.formId,
    required this.payloadJson,
    required this.queuedAt,
    required this.retryCount,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'formId': formId,
        'payloadJson': payloadJson,
        'queuedAt': queuedAt.toIso8601String(),
        'retryCount': retryCount,
      };

  factory PendingUploadRecord.fromJson(Map<String, dynamic> json) {
    return PendingUploadRecord(
      id: json['id']?.toString() ?? '',
      formId: json['formId']?.toString() ?? '',
      payloadJson: json['payloadJson']?.toString() ?? '{}',
      queuedAt: DateTime.tryParse(json['queuedAt']?.toString() ?? '') ??
          DateTime.now(),
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class LocalDatabase {
  static const _formsBoxName = 'cached_forms_box';
  static const _responsesBoxName = 'cached_responses_box';
  static const _uploadsBoxName = 'pending_uploads_box';

  Future<Box> get _formsBox async => Hive.isBoxOpen(_formsBoxName)
      ? Hive.box(_formsBoxName)
      : await Hive.openBox(_formsBoxName);

  Future<Box> get _responsesBox async => Hive.isBoxOpen(_responsesBoxName)
      ? Hive.box(_responsesBoxName)
      : await Hive.openBox(_responsesBoxName);

  Future<Box> get _uploadsBox async => Hive.isBoxOpen(_uploadsBoxName)
      ? Hive.box(_uploadsBoxName)
      : await Hive.openBox(_uploadsBoxName);

  Future<void> upsertCachedForm(CachedFormRecord record) async {
    final box = await _formsBox;
    await box.put(record.id, record.toJson());
  }

  Future<CachedFormRecord?> getCachedForm(String id) async {
    final box = await _formsBox;
    final raw = box.get(id);
    if (raw is Map) {
      return CachedFormRecord.fromJson(Map<String, dynamic>.from(raw));
    }
    return null;
  }

  Future<void> deleteAllCachedForms() async {
    final box = await _formsBox;
    await box.clear();
  }

  Future<void> deleteAllCachedResponses() async {
    final box = await _responsesBox;
    await box.clear();
  }

  Future<void> deleteAllPendingUploads() async {
    final box = await _uploadsBox;
    await box.clear();
  }

  Future<void> upsertPendingUpload(PendingUploadRecord record) async {
    final box = await _uploadsBox;
    await box.put(record.id, record.toJson());
  }

  Future<List<PendingUploadRecord>> listPendingUploads() async {
    final box = await _uploadsBox;
    return box.values
        .whereType<Map>()
        .map((value) => PendingUploadRecord.fromJson(Map<String, dynamic>.from(value)))
        .toList();
  }

  Future<void> deletePendingUpload(String id) async {
    final box = await _uploadsBox;
    await box.delete(id);
  }

  Future<void> incrementPendingRetryCount(String id) async {
    final box = await _uploadsBox;
    final raw = box.get(id);
    if (raw is Map) {
      final record = PendingUploadRecord.fromJson(Map<String, dynamic>.from(raw));
      await box.put(
        id,
        record.copyWith(retryCount: record.retryCount + 1).toJson(),
      );
    }
  }

  Future<void> close() async {
    await Future.wait([
      if (Hive.isBoxOpen(_formsBoxName)) Hive.box(_formsBoxName).close(),
      if (Hive.isBoxOpen(_responsesBoxName)) Hive.box(_responsesBoxName).close(),
      if (Hive.isBoxOpen(_uploadsBoxName)) Hive.box(_uploadsBoxName).close(),
    ]);
  }
}

extension on PendingUploadRecord {
  PendingUploadRecord copyWith({
    String? id,
    String? formId,
    String? payloadJson,
    DateTime? queuedAt,
    int? retryCount,
  }) {
    return PendingUploadRecord(
      id: id ?? this.id,
      formId: formId ?? this.formId,
      payloadJson: payloadJson ?? this.payloadJson,
      queuedAt: queuedAt ?? this.queuedAt,
      retryCount: retryCount ?? this.retryCount,
    );
  }
}

import 'package:json_annotation/json_annotation.dart';

Object? _readId(Map json, String key) => json['_id'] ?? json['id'] ?? '';

@JsonSerializable(fieldRename: FieldRename.snake)
class ResponseHistory {
  @JsonKey(readValue: _readId)
  final String id;
  final String responseId;
  final String formId;
  final Map<String, dynamic> dataBefore;
  final Map<String, dynamic> dataAfter;
  final String changedBy;
  final DateTime changedAt;
  final String changeType;
  final String? version;

  const ResponseHistory({
    required this.id,
    required this.responseId,
    required this.formId,
    required this.dataBefore,
    required this.dataAfter,
    required this.changedBy,
    required this.changedAt,
    required this.changeType,
    this.version,
  });

  ResponseHistory copyWith({
    String? id,
    String? responseId,
    String? formId,
    Map<String, dynamic>? dataBefore,
    Map<String, dynamic>? dataAfter,
    String? changedBy,
    DateTime? changedAt,
    String? changeType,
    String? version,
  }) {
    return ResponseHistory(
      id: id ?? this.id,
      responseId: responseId ?? this.responseId,
      formId: formId ?? this.formId,
      dataBefore: dataBefore ?? this.dataBefore,
      dataAfter: dataAfter ?? this.dataAfter,
      changedBy: changedBy ?? this.changedBy,
      changedAt: changedAt ?? this.changedAt,
      changeType: changeType ?? this.changeType,
      version: version ?? this.version,
    );
  }

  factory ResponseHistory.fromJson(Map<String, dynamic> json) {
    return ResponseHistory(
      id: _readId(json, 'id') as String,
      responseId: json['response_id'] as String,
      formId: json['form_id'] as String,
      dataBefore: Map<String, dynamic>.from(json['data_before'] ?? {}),
      dataAfter: Map<String, dynamic>.from(json['data_after'] ?? {}),
      changedBy: json['changed_by'] as String,
      changedAt: DateTime.parse(json['changed_at']),
      changeType: json['change_type'] as String,
      version: json['version'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'response_id': responseId,
      'form_id': formId,
      'data_before': dataBefore,
      'data_after': dataAfter,
      'changed_by': changedBy,
      'changed_at': changedAt.toIso8601String(),
      'change_type': changeType,
      'version': version,
    };
  }
}
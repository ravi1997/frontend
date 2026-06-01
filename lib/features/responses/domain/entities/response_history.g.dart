// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ResponseHistory _$ResponseHistoryFromJson(Map<String, dynamic> json) =>
    _ResponseHistory(
      id: _readId(json, 'id') as String,
      responseId: json['response_id'] as String,
      formId: json['form_id'] as String,
      dataBefore: json['data_before'] as Map<String, dynamic>,
      dataAfter: json['data_after'] as Map<String, dynamic>,
      changedBy: json['changed_by'] as String,
      changedAt: DateTime.parse(json['changed_at'] as String),
      changeType: json['change_type'] as String,
      version: json['version'] as String?,
    );

Map<String, dynamic> _$ResponseHistoryToJson(_ResponseHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'response_id': instance.responseId,
      'form_id': instance.formId,
      'data_before': instance.dataBefore,
      'data_after': instance.dataAfter,
      'changed_by': instance.changedBy,
      'changed_at': instance.changedAt.toIso8601String(),
      'change_type': instance.changeType,
      'version': instance.version,
    };

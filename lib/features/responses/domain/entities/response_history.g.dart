// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ResponseHistory _$ResponseHistoryFromJson(Map<String, dynamic> json) =>
    _ResponseHistory(
      id: json['id'] as String,
      responseId: json['responseId'] as String,
      formId: json['formId'] as String,
      dataBefore: json['dataBefore'] as Map<String, dynamic>,
      dataAfter: json['dataAfter'] as Map<String, dynamic>,
      changedBy: json['changedBy'] as String,
      changedAt: DateTime.parse(json['changedAt'] as String),
      changeType: json['changeType'] as String,
    );

Map<String, dynamic> _$ResponseHistoryToJson(_ResponseHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'responseId': instance.responseId,
      'formId': instance.formId,
      'dataBefore': instance.dataBefore,
      'dataAfter': instance.dataAfter,
      'changedBy': instance.changedBy,
      'changedAt': instance.changedAt.toIso8601String(),
      'changeType': instance.changeType,
    };

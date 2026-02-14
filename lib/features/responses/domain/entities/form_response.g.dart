// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FormResponse _$FormResponseFromJson(Map<String, dynamic> json) =>
    _FormResponse(
      id: json['id'] as String,
      formId: json['formId'] as String,
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      answers: json['answers'] as Map<String, dynamic>,
      aiResults: json['aiResults'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$FormResponseToJson(_FormResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'formId': instance.formId,
      'submittedAt': instance.submittedAt.toIso8601String(),
      'answers': instance.answers,
      'aiResults': instance.aiResults,
    };

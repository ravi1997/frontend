// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FormResponse _$FormResponseFromJson(Map<String, dynamic> json) =>
    _FormResponse(
      id: json['_id'] as String,
      formId: json['form'] as String,
      organizationId: json['organization_id'] as String?,
      submittedBy: json['submitted_by'] as String?,
      submittedAt: DateUtils.parse(json['submitted_at']),
      answers: json['data'] as Map<String, dynamic>,
      ipAddress: json['ip_address'] as String?,
      userAgent: json['user_agent'] as String?,
      aiResults: json['ai_results'] as Map<String, dynamic>? ?? const {},
      status: json['status'] as String? ?? 'pending',
    );

Map<String, dynamic> _$FormResponseToJson(_FormResponse instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'form': instance.formId,
      'organization_id': instance.organizationId,
      'submitted_by': instance.submittedBy,
      'submitted_at': DateUtils.toIso8601(instance.submittedAt),
      'data': instance.answers,
      'ip_address': instance.ipAddress,
      'user_agent': instance.userAgent,
      'ai_results': instance.aiResults,
      'status': instance.status,
    };

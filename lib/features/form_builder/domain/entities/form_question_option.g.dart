// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_question_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FormQuestionOption _$FormQuestionOptionFromJson(Map<String, dynamic> json) =>
    _FormQuestionOption(
      id: IdReader.readIdCallback(json, 'id') as String,
      description: json['description'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
      isDisabled: json['is_disabled'] as bool? ?? false,
      label: json['option_label'] as String,
      value: json['option_value'] as String,
      order: (json['order'] as num?)?.toInt() ?? 0,
      followupVisibilityCondition:
          json['followup_visibility_condition'] as String?,
    );

Map<String, dynamic> _$FormQuestionOptionToJson(_FormQuestionOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'is_default': instance.isDefault,
      'is_disabled': instance.isDisabled,
      'option_label': instance.label,
      'option_value': instance.value,
      'order': instance.order,
      'followup_visibility_condition': instance.followupVisibilityCondition,
    };

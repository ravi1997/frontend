// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GlobalFilter _$GlobalFilterFromJson(Map<String, dynamic> json) =>
    _GlobalFilter(
      id: json['id'] as String,
      label: json['label'] as String,
      type: json['type'] as String,
      fieldId: json['fieldId'] as String?,
      value: json['value'],
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$GlobalFilterToJson(_GlobalFilter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'type': instance.type,
      'fieldId': instance.fieldId,
      'value': instance.value,
      'isActive': instance.isActive,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_component_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UIComponentSchema _$UIComponentSchemaFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UIComponentSchema',
      json,
      ($checkedConvert) {
        final val = UIComponentSchema(
          id: $checkedConvert('_id', (v) => v),
          createdAt: $checkedConvert('created_at', (v) => v),
          style: $checkedConvert('style', (v) => v),
          updatedAt: $checkedConvert('updated_at', (v) => v),
          visibleHeader: $checkedConvert(
            'visible_header',
            (v) => v as bool? ?? true,
          ),
          visibleName: $checkedConvert('visible_name', (v) => v),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': '_id',
        'createdAt': 'created_at',
        'updatedAt': 'updated_at',
        'visibleHeader': 'visible_header',
        'visibleName': 'visible_name',
      },
    );

Map<String, dynamic> _$UIComponentSchemaToJson(UIComponentSchema instance) =>
    <String, dynamic>{
      '_id': ?instance.id,
      'created_at': ?instance.createdAt,
      'style': ?instance.style,
      'updated_at': ?instance.updatedAt,
      'visible_header': ?instance.visibleHeader,
      'visible_name': ?instance.visibleName,
    };

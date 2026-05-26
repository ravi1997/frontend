// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseSchema _$BaseSchemaFromJson(Map<String, dynamic> json) => $checkedCreate(
  'BaseSchema',
  json,
  ($checkedConvert) {
    final val = BaseSchema(
      id: $checkedConvert('_id', (v) => v),
      createdAt: $checkedConvert('created_at', (v) => v),
      updatedAt: $checkedConvert('updated_at', (v) => v),
    );
    return val;
  },
  fieldKeyMap: const {
    'id': '_id',
    'createdAt': 'created_at',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$BaseSchemaToJson(BaseSchema instance) =>
    <String, dynamic>{
      '_id': ?instance.id,
      'created_at': ?instance.createdAt,
      'updated_at': ?instance.updatedAt,
    };

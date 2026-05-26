// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soft_delete_base_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SoftDeleteBaseSchema _$SoftDeleteBaseSchemaFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'SoftDeleteBaseSchema',
  json,
  ($checkedConvert) {
    final val = SoftDeleteBaseSchema(
      id: $checkedConvert('_id', (v) => v),
      createdAt: $checkedConvert('created_at', (v) => v),
      deletedAt: $checkedConvert('deleted_at', (v) => v),
      isDeleted: $checkedConvert('is_deleted', (v) => v as bool? ?? false),
      updatedAt: $checkedConvert('updated_at', (v) => v),
    );
    return val;
  },
  fieldKeyMap: const {
    'id': '_id',
    'createdAt': 'created_at',
    'deletedAt': 'deleted_at',
    'isDeleted': 'is_deleted',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$SoftDeleteBaseSchemaToJson(
  SoftDeleteBaseSchema instance,
) => <String, dynamic>{
  '_id': ?instance.id,
  'created_at': ?instance.createdAt,
  'deleted_at': ?instance.deletedAt,
  'is_deleted': ?instance.isDeleted,
  'updated_at': ?instance.updatedAt,
};

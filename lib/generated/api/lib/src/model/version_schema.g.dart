// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VersionSchema _$VersionSchemaFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'VersionSchema',
      json,
      ($checkedConvert) {
        final val = VersionSchema(
          id: $checkedConvert('_id', (v) => v),
          createdAt: $checkedConvert('created_at', (v) => v),
          form: $checkedConvert('form', (v) => v),
          major: $checkedConvert('major', (v) => (v as num?)?.toInt()),
          minor: $checkedConvert('minor', (v) => (v as num?)?.toInt()),
          patch_: $checkedConvert('patch', (v) => (v as num?)?.toInt()),
          project: $checkedConvert('project', (v) => v),
          updatedAt: $checkedConvert('updated_at', (v) => v),
          versionString: $checkedConvert('version_string', (v) => v),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': '_id',
        'createdAt': 'created_at',
        'patch_': 'patch',
        'updatedAt': 'updated_at',
        'versionString': 'version_string',
      },
    );

Map<String, dynamic> _$VersionSchemaToJson(VersionSchema instance) =>
    <String, dynamic>{
      '_id': ?instance.id,
      'created_at': ?instance.createdAt,
      'form': ?instance.form,
      'major': ?instance.major,
      'minor': ?instance.minor,
      'patch': ?instance.patch_,
      'project': ?instance.project,
      'updated_at': ?instance.updatedAt,
      'version_string': ?instance.versionString,
    };

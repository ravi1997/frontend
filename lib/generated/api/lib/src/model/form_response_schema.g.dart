// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_response_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormResponseSchema _$FormResponseSchemaFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'FormResponseSchema',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'data',
            'form',
            'form_version',
            'organization_id',
            'submitted_by',
          ],
        );
        final val = FormResponseSchema(
          id: $checkedConvert('_id', (v) => v),
          createdAt: $checkedConvert('created_at', (v) => v),
          data: $checkedConvert('data', (v) => v as Object),
          deletedAt: $checkedConvert('deleted_at', (v) => v),
          form: $checkedConvert('form', (v) => v as String),
          formVersion: $checkedConvert('form_version', (v) => v as String),
          ipAddress: $checkedConvert('ip_address', (v) => v),
          isDeleted: $checkedConvert('is_deleted', (v) => v as bool? ?? false),
          metaData: $checkedConvert('meta_data', (v) => v),
          organizationId: $checkedConvert(
            'organization_id',
            (v) => v as String,
          ),
          project: $checkedConvert('project', (v) => v),
          reviewStatus: $checkedConvert(
            'review_status',
            (v) =>
                $enumDecodeNullable(
                  _$FormResponseSchemaReviewStatusEnumEnumMap,
                  v,
                ) ??
                'pending',
          ),
          status: $checkedConvert(
            'status',
            (v) =>
                $enumDecodeNullable(_$FormResponseSchemaStatusEnumEnumMap, v) ??
                'submitted',
          ),
          submittedAt: $checkedConvert('submitted_at', (v) => v),
          submittedBy: $checkedConvert('submitted_by', (v) => v as String),
          tags: $checkedConvert(
            'tags',
            (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
          ),
          updatedAt: $checkedConvert('updated_at', (v) => v),
          userAgent: $checkedConvert('user_agent', (v) => v),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': '_id',
        'createdAt': 'created_at',
        'deletedAt': 'deleted_at',
        'formVersion': 'form_version',
        'ipAddress': 'ip_address',
        'isDeleted': 'is_deleted',
        'metaData': 'meta_data',
        'organizationId': 'organization_id',
        'reviewStatus': 'review_status',
        'submittedAt': 'submitted_at',
        'submittedBy': 'submitted_by',
        'updatedAt': 'updated_at',
        'userAgent': 'user_agent',
      },
    );

Map<String, dynamic> _$FormResponseSchemaToJson(FormResponseSchema instance) =>
    <String, dynamic>{
      '_id': ?instance.id,
      'created_at': ?instance.createdAt,
      'data': instance.data,
      'deleted_at': ?instance.deletedAt,
      'form': instance.form,
      'form_version': instance.formVersion,
      'ip_address': ?instance.ipAddress,
      'is_deleted': ?instance.isDeleted,
      'meta_data': ?instance.metaData,
      'organization_id': instance.organizationId,
      'project': ?instance.project,
      'review_status':
          ?_$FormResponseSchemaReviewStatusEnumEnumMap[instance.reviewStatus],
      'status': ?_$FormResponseSchemaStatusEnumEnumMap[instance.status],
      'submitted_at': ?instance.submittedAt,
      'submitted_by': instance.submittedBy,
      'tags': ?instance.tags,
      'updated_at': ?instance.updatedAt,
      'user_agent': ?instance.userAgent,
    };

const _$FormResponseSchemaReviewStatusEnumEnumMap = {
  FormResponseSchemaReviewStatusEnum.pending: 'pending',
  FormResponseSchemaReviewStatusEnum.approved: 'approved',
  FormResponseSchemaReviewStatusEnum.rejected: 'rejected',
};

const _$FormResponseSchemaStatusEnumEnumMap = {
  FormResponseSchemaStatusEnum.submitted: 'submitted',
  FormResponseSchemaStatusEnum.processed: 'processed',
  FormResponseSchemaStatusEnum.error: 'error',
  FormResponseSchemaStatusEnum.archived: 'archived',
};

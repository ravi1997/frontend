//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'form_response_schema.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class FormResponseSchema {
  /// Returns a new [FormResponseSchema] instance.
  FormResponseSchema({

     this.id,

     this.createdAt,

    required  this.data,

     this.deletedAt,

    required  this.form,

    required  this.formVersion,

     this.ipAddress,

     this.isDeleted = false,

     this.metaData,

    required  this.organizationId,

     this.project,

     this.reviewStatus = const FormResponseSchemaReviewStatusEnum._('pending'),

     this.status = const FormResponseSchemaStatusEnum._('submitted'),

     this.submittedAt,

    required  this.submittedBy,

     this.tags,

     this.updatedAt,

     this.userAgent,
  });

  @JsonKey(
    
    name: r'_id',
    required: false,
    includeIfNull: false,
  )


  final Object? id;



  @JsonKey(
    
    name: r'created_at',
    required: false,
    includeIfNull: false,
  )


  final Object? createdAt;



  @JsonKey(
    
    name: r'data',
    required: true,
    includeIfNull: false,
  )


  final Map<String, Object> data;



  @JsonKey(
    
    name: r'deleted_at',
    required: false,
    includeIfNull: false,
  )


  final Object? deletedAt;



  @JsonKey(
    
    name: r'form',
    required: true,
    includeIfNull: false,
  )


  final String form;



  @JsonKey(
    
    name: r'form_version',
    required: true,
    includeIfNull: false,
  )


  final String formVersion;



  @JsonKey(
    
    name: r'ip_address',
    required: false,
    includeIfNull: false,
  )


  final Object? ipAddress;



  @JsonKey(
    defaultValue: false,
    name: r'is_deleted',
    required: false,
    includeIfNull: false,
  )


  final bool? isDeleted;



  @JsonKey(
    
    name: r'meta_data',
    required: false,
    includeIfNull: false,
  )


  final Object? metaData;



  @JsonKey(
    
    name: r'organization_id',
    required: true,
    includeIfNull: false,
  )


  final String organizationId;



  @JsonKey(
    
    name: r'project',
    required: false,
    includeIfNull: false,
  )


  final Object? project;



  @JsonKey(
    defaultValue: 'pending',
    name: r'review_status',
    required: false,
    includeIfNull: false,
  )


  final FormResponseSchemaReviewStatusEnum? reviewStatus;



  @JsonKey(
    defaultValue: 'submitted',
    name: r'status',
    required: false,
    includeIfNull: false,
  )


  final FormResponseSchemaStatusEnum? status;



  @JsonKey(
    
    name: r'submitted_at',
    required: false,
    includeIfNull: false,
  )


  final Object? submittedAt;



  @JsonKey(
    
    name: r'submitted_by',
    required: true,
    includeIfNull: false,
  )


  final String submittedBy;



  @JsonKey(
    
    name: r'tags',
    required: false,
    includeIfNull: false,
  )


  final List<String>? tags;



  @JsonKey(
    
    name: r'updated_at',
    required: false,
    includeIfNull: false,
  )


  final Object? updatedAt;



  @JsonKey(
    
    name: r'user_agent',
    required: false,
    includeIfNull: false,
  )


  final Object? userAgent;





    @override
    bool operator ==(Object other) => identical(this, other) || other is FormResponseSchema &&
      other.id == id &&
      other.createdAt == createdAt &&
      other.data == data &&
      other.deletedAt == deletedAt &&
      other.form == form &&
      other.formVersion == formVersion &&
      other.ipAddress == ipAddress &&
      other.isDeleted == isDeleted &&
      other.metaData == metaData &&
      other.organizationId == organizationId &&
      other.project == project &&
      other.reviewStatus == reviewStatus &&
      other.status == status &&
      other.submittedAt == submittedAt &&
      other.submittedBy == submittedBy &&
      other.tags == tags &&
      other.updatedAt == updatedAt &&
      other.userAgent == userAgent;

    @override
    int get hashCode =>
        id.hashCode +
        createdAt.hashCode +
        data.hashCode +
        deletedAt.hashCode +
        form.hashCode +
        formVersion.hashCode +
        ipAddress.hashCode +
        isDeleted.hashCode +
        metaData.hashCode +
        organizationId.hashCode +
        project.hashCode +
        reviewStatus.hashCode +
        status.hashCode +
        submittedAt.hashCode +
        submittedBy.hashCode +
        tags.hashCode +
        updatedAt.hashCode +
        userAgent.hashCode;

  factory FormResponseSchema.fromJson(Map<String, dynamic> json) => _$FormResponseSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$FormResponseSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


enum FormResponseSchemaReviewStatusEnum {
@JsonValue(r'pending')
pending(r'pending'),
@JsonValue(r'approved')
approved(r'approved'),
@JsonValue(r'rejected')
rejected(r'rejected');

const FormResponseSchemaReviewStatusEnum(this.value);

final String value;

@override
String toString() => value;
}



enum FormResponseSchemaStatusEnum {
@JsonValue(r'submitted')
submitted(r'submitted'),
@JsonValue(r'processed')
processed(r'processed'),
@JsonValue(r'error')
error(r'error'),
@JsonValue(r'archived')
archived(r'archived');

const FormResponseSchemaStatusEnum(this.value);

final String value;

@override
String toString() => value;
}



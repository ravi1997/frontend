//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mahasangraha_api_v1_admin_orgs_post_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MahasangrahaApiV1AdminOrgsPostRequest {
  /// Returns a new [MahasangrahaApiV1AdminOrgsPostRequest] instance.
  MahasangrahaApiV1AdminOrgsPostRequest({

     this.contactEmail,

     this.description,

    required  this.displayName,

     this.metadata,

    required  this.name,

    required  this.organizationId,
  });

  @JsonKey(
    
    name: r'contact_email',
    required: false,
    includeIfNull: false,
  )


  final String? contactEmail;



  @JsonKey(
    
    name: r'description',
    required: false,
    includeIfNull: false,
  )


  final String? description;



  @JsonKey(
    
    name: r'display_name',
    required: true,
    includeIfNull: false,
  )


  final String displayName;



  @JsonKey(
    
    name: r'metadata',
    required: false,
    includeIfNull: false,
  )


  final Object? metadata;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'organization_id',
    required: true,
    includeIfNull: false,
  )


  final String organizationId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MahasangrahaApiV1AdminOrgsPostRequest &&
      other.contactEmail == contactEmail &&
      other.description == description &&
      other.displayName == displayName &&
      other.metadata == metadata &&
      other.name == name &&
      other.organizationId == organizationId;

    @override
    int get hashCode =>
        contactEmail.hashCode +
        description.hashCode +
        displayName.hashCode +
        metadata.hashCode +
        name.hashCode +
        organizationId.hashCode;

  factory MahasangrahaApiV1AdminOrgsPostRequest.fromJson(Map<String, dynamic> json) => _$MahasangrahaApiV1AdminOrgsPostRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MahasangrahaApiV1AdminOrgsPostRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'access_entry_schema.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AccessEntrySchema {
  /// Returns a new [AccessEntrySchema] instance.
  AccessEntrySchema({

     this.id,

     this.createdAt,

     this.granteeGroup,

    required  this.granteeType,

     this.granteeUser,

     this.permissions,

     this.updatedAt,
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
    
    name: r'grantee_group',
    required: false,
    includeIfNull: false,
  )


  final Object? granteeGroup;



  @JsonKey(
    
    name: r'grantee_type',
    required: true,
    includeIfNull: false,
  )


  final AccessEntrySchemaGranteeTypeEnum granteeType;



  @JsonKey(
    
    name: r'grantee_user',
    required: false,
    includeIfNull: false,
  )


  final Object? granteeUser;



  @JsonKey(
    
    name: r'permissions',
    required: false,
    includeIfNull: false,
  )


  final List<AccessEntrySchemaPermissionsEnum>? permissions;



  @JsonKey(
    
    name: r'updated_at',
    required: false,
    includeIfNull: false,
  )


  final Object? updatedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AccessEntrySchema &&
      other.id == id &&
      other.createdAt == createdAt &&
      other.granteeGroup == granteeGroup &&
      other.granteeType == granteeType &&
      other.granteeUser == granteeUser &&
      other.permissions == permissions &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        id.hashCode +
        createdAt.hashCode +
        granteeGroup.hashCode +
        granteeType.hashCode +
        granteeUser.hashCode +
        permissions.hashCode +
        updatedAt.hashCode;

  factory AccessEntrySchema.fromJson(Map<String, dynamic> json) => _$AccessEntrySchemaFromJson(json);

  Map<String, dynamic> toJson() => _$AccessEntrySchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


enum AccessEntrySchemaGranteeTypeEnum {
@JsonValue(r'user')
user(r'user'),
@JsonValue(r'group')
group(r'group');

const AccessEntrySchemaGranteeTypeEnum(this.value);

final String value;

@override
String toString() => value;
}



enum AccessEntrySchemaPermissionsEnum {
@JsonValue(r'view')
view(r'view'),
@JsonValue(r'edit')
edit(r'edit'),
@JsonValue(r'delete')
delete(r'delete'),
@JsonValue(r'publish')
publish(r'publish'),
@JsonValue(r'export_data')
exportData(r'export_data'),
@JsonValue(r'manage_access')
manageAccess(r'manage_access'),
@JsonValue(r'approve_submissions')
approveSubmissions(r'approve_submissions');

const AccessEntrySchemaPermissionsEnum(this.value);

final String value;

@override
String toString() => value;
}



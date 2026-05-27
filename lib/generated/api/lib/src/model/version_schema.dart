//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'version_schema.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class VersionSchema {
  /// Returns a new [VersionSchema] instance.
  VersionSchema({

     this.id,

     this.createdAt,

     this.form,

     this.major,

     this.minor,

     this.patch_,

     this.project,

     this.updatedAt,

     this.versionString,
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
    
    name: r'form',
    required: false,
    includeIfNull: false,
  )


  final Object? form;



          // minimum: 0
  @JsonKey(
    
    name: r'major',
    required: false,
    includeIfNull: false,
  )


  final int? major;



          // minimum: 0
  @JsonKey(
    
    name: r'minor',
    required: false,
    includeIfNull: false,
  )


  final int? minor;



          // minimum: 0
  @JsonKey(
    
    name: r'patch',
    required: false,
    includeIfNull: false,
  )


  final int? patch_;



  @JsonKey(
    
    name: r'project',
    required: false,
    includeIfNull: false,
  )


  final Object? project;



  @JsonKey(
    
    name: r'updated_at',
    required: false,
    includeIfNull: false,
  )


  final Object? updatedAt;



  @JsonKey(
    
    name: r'version_string',
    required: false,
    includeIfNull: false,
  )


  final Object? versionString;





    @override
    bool operator ==(Object other) => identical(this, other) || other is VersionSchema &&
      other.id == id &&
      other.createdAt == createdAt &&
      other.form == form &&
      other.major == major &&
      other.minor == minor &&
      other.patch_ == patch_ &&
      other.project == project &&
      other.updatedAt == updatedAt &&
      other.versionString == versionString;

    @override
    int get hashCode =>
        id.hashCode +
        createdAt.hashCode +
        form.hashCode +
        major.hashCode +
        minor.hashCode +
        patch_.hashCode +
        project.hashCode +
        updatedAt.hashCode +
        versionString.hashCode;

  factory VersionSchema.fromJson(Map<String, dynamic> json) => _$VersionSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$VersionSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


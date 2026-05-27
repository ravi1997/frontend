//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'form_version_schema.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class FormVersionSchema {
  /// Returns a new [FormVersionSchema] instance.
  FormVersionSchema({

     this.id,

     this.createdAt,

    required  this.form,

     this.sections,

     this.status = const FormVersionSchemaStatusEnum._('draft'),

     this.translations,

     this.updatedAt,

    required  this.version,
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
    required: true,
    includeIfNull: false,
  )


  final String form;



  @JsonKey(
    
    name: r'sections',
    required: false,
    includeIfNull: false,
  )


  final List<Object>? sections;



  @JsonKey(
    defaultValue: 'draft',
    name: r'status',
    required: false,
    includeIfNull: false,
  )


  final FormVersionSchemaStatusEnum? status;



  @JsonKey(
    
    name: r'translations',
    required: false,
    includeIfNull: false,
  )


  final Object? translations;



  @JsonKey(
    
    name: r'updated_at',
    required: false,
    includeIfNull: false,
  )


  final Object? updatedAt;



  @JsonKey(
    
    name: r'version',
    required: true,
    includeIfNull: false,
  )


  final String version;





    @override
    bool operator ==(Object other) => identical(this, other) || other is FormVersionSchema &&
      other.id == id &&
      other.createdAt == createdAt &&
      other.form == form &&
      other.sections == sections &&
      other.status == status &&
      other.translations == translations &&
      other.updatedAt == updatedAt &&
      other.version == version;

    @override
    int get hashCode =>
        id.hashCode +
        createdAt.hashCode +
        form.hashCode +
        sections.hashCode +
        status.hashCode +
        translations.hashCode +
        updatedAt.hashCode +
        version.hashCode;

  factory FormVersionSchema.fromJson(Map<String, dynamic> json) => _$FormVersionSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$FormVersionSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


enum FormVersionSchemaStatusEnum {
@JsonValue(r'draft')
draft(r'draft'),
@JsonValue(r'published')
published(r'published'),
@JsonValue(r'archived')
archived(r'archived');

const FormVersionSchemaStatusEnum(this.value);

final String value;

@override
String toString() => value;
}



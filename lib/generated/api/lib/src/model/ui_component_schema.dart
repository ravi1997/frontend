//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ui_component_schema.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UIComponentSchema {
  /// Returns a new [UIComponentSchema] instance.
  UIComponentSchema({

     this.id,

     this.createdAt,

     this.style,

     this.updatedAt,

     this.visibleHeader = true,

     this.visibleName,
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
    
    name: r'style',
    required: false,
    includeIfNull: false,
  )


  final Object? style;



  @JsonKey(
    
    name: r'updated_at',
    required: false,
    includeIfNull: false,
  )


  final Object? updatedAt;



  @JsonKey(
    defaultValue: true,
    name: r'visible_header',
    required: false,
    includeIfNull: false,
  )


  final bool? visibleHeader;



  @JsonKey(
    
    name: r'visible_name',
    required: false,
    includeIfNull: false,
  )


  final Object? visibleName;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UIComponentSchema &&
      other.id == id &&
      other.createdAt == createdAt &&
      other.style == style &&
      other.updatedAt == updatedAt &&
      other.visibleHeader == visibleHeader &&
      other.visibleName == visibleName;

    @override
    int get hashCode =>
        id.hashCode +
        createdAt.hashCode +
        style.hashCode +
        updatedAt.hashCode +
        visibleHeader.hashCode +
        visibleName.hashCode;

  factory UIComponentSchema.fromJson(Map<String, dynamic> json) => _$UIComponentSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$UIComponentSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


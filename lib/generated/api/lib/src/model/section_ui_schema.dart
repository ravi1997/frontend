//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'section_ui_schema.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SectionUISchema {
  /// Returns a new [SectionUISchema] instance.
  SectionUISchema({

     this.id,

     this.createdAt,

     this.layoutType = const SectionUISchemaLayoutTypeEnum._('flex'),

     this.style,

     this.updatedAt,

     this.visibleHeader = true,

     this.visibleName,
  });

  @JsonKey(
    
    name: r'_id',
    required: false,
    includeIfNull: false
  )


  final Object? id;



  @JsonKey(
    
    name: r'created_at',
    required: false,
    includeIfNull: false
  )


  final Object? createdAt;



  @JsonKey(
    defaultValue: 'flex',
    name: r'layout_type',
    required: false,
    includeIfNull: false
  )


  final SectionUISchemaLayoutTypeEnum? layoutType;



  @JsonKey(
    
    name: r'style',
    required: false,
    includeIfNull: false
  )


  final Object? style;



  @JsonKey(
    
    name: r'updated_at',
    required: false,
    includeIfNull: false
  )


  final Object? updatedAt;



  @JsonKey(
    defaultValue: true,
    name: r'visible_header',
    required: false,
    includeIfNull: false
  )


  final bool? visibleHeader;



  @JsonKey(
    
    name: r'visible_name',
    required: false,
    includeIfNull: false
  )


  final Object? visibleName;



  @override
  bool operator ==(Object other) => identical(this, other) || other is SectionUISchema &&
     other.id == id &&
     other.createdAt == createdAt &&
     other.layoutType == layoutType &&
     other.style == style &&
     other.updatedAt == updatedAt &&
     other.visibleHeader == visibleHeader &&
     other.visibleName == visibleName;

  @override
  int get hashCode =>
    id.hashCode +
    createdAt.hashCode +
    layoutType.hashCode +
    style.hashCode +
    updatedAt.hashCode +
    visibleHeader.hashCode +
    visibleName.hashCode;

  factory SectionUISchema.fromJson(Map<String, dynamic> json) => _$SectionUISchemaFromJson(json);

  Map<String, dynamic> toJson() => _$SectionUISchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


enum SectionUISchemaLayoutTypeEnum {
  @JsonValue(r'flex')
  flex,
  @JsonValue(r'grid-cols-2')
  gridCols2,
  @JsonValue(r'tabbed')
  tabbed,
  @JsonValue(r'custom')
  custom,
  @JsonValue(r'grid-cols-3')
  gridCols3,
  @JsonValue(r'full-width')
  fullWidth,
  @JsonValue(r'cards')
  cards,
  @JsonValue(r'card')
  card,
}



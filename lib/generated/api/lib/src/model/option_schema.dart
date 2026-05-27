//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'option_schema.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OptionSchema {
  /// Returns a new [OptionSchema] instance.
  OptionSchema({

     this.id,

     this.createdAt,

     this.description,

     this.isDefault = false,

     this.isDisabled = false,

     this.optionCode,

    required  this.optionLabel,

    required  this.optionValue,

     this.order,

     this.updatedAt,

     this.visibilityCondition,
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
    
    name: r'description',
    required: false,
    includeIfNull: false,
  )


  final Object? description;



  @JsonKey(
    defaultValue: false,
    name: r'is_default',
    required: false,
    includeIfNull: false,
  )


  final bool? isDefault;



  @JsonKey(
    defaultValue: false,
    name: r'is_disabled',
    required: false,
    includeIfNull: false,
  )


  final bool? isDisabled;



  @JsonKey(
    
    name: r'option_code',
    required: false,
    includeIfNull: false,
  )


  final Object? optionCode;



  @JsonKey(
    
    name: r'option_label',
    required: true,
    includeIfNull: false,
  )


  final String optionLabel;



  @JsonKey(
    
    name: r'option_value',
    required: true,
    includeIfNull: false,
  )


  final String optionValue;



  @JsonKey(
    
    name: r'order',
    required: false,
    includeIfNull: false,
  )


  final int? order;



  @JsonKey(
    
    name: r'updated_at',
    required: false,
    includeIfNull: false,
  )


  final Object? updatedAt;



  @JsonKey(
    
    name: r'visibility_condition',
    required: false,
    includeIfNull: false,
  )


  final Object? visibilityCondition;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OptionSchema &&
      other.id == id &&
      other.createdAt == createdAt &&
      other.description == description &&
      other.isDefault == isDefault &&
      other.isDisabled == isDisabled &&
      other.optionCode == optionCode &&
      other.optionLabel == optionLabel &&
      other.optionValue == optionValue &&
      other.order == order &&
      other.updatedAt == updatedAt &&
      other.visibilityCondition == visibilityCondition;

    @override
    int get hashCode =>
        id.hashCode +
        createdAt.hashCode +
        description.hashCode +
        isDefault.hashCode +
        isDisabled.hashCode +
        optionCode.hashCode +
        optionLabel.hashCode +
        optionValue.hashCode +
        order.hashCode +
        updatedAt.hashCode +
        visibilityCondition.hashCode;

  factory OptionSchema.fromJson(Map<String, dynamic> json) => _$OptionSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$OptionSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


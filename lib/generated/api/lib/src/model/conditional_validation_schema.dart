//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'conditional_validation_schema.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ConditionalValidationSchema {
  /// Returns a new [ConditionalValidationSchema] instance.
  ConditionalValidationSchema({

     this.id,

     this.conditions,

     this.createdAt,

    required  this.errorMessage,

     this.logicalOperator = 'AND',

     this.updatedAt,
  });

  @JsonKey(
    
    name: r'_id',
    required: false,
    includeIfNull: false,
  )


  final Object? id;



  @JsonKey(
    
    name: r'conditions',
    required: false,
    includeIfNull: false,
  )


  final List<Object>? conditions;



  @JsonKey(
    
    name: r'created_at',
    required: false,
    includeIfNull: false,
  )


  final Object? createdAt;



  @JsonKey(
    
    name: r'error_message',
    required: true,
    includeIfNull: false,
  )


  final String errorMessage;



  @JsonKey(
    defaultValue: 'AND',
    name: r'logical_operator',
    required: false,
    includeIfNull: false,
  )


  final String? logicalOperator;



  @JsonKey(
    
    name: r'updated_at',
    required: false,
    includeIfNull: false,
  )


  final Object? updatedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ConditionalValidationSchema &&
      other.id == id &&
      other.conditions == conditions &&
      other.createdAt == createdAt &&
      other.errorMessage == errorMessage &&
      other.logicalOperator == logicalOperator &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        id.hashCode +
        conditions.hashCode +
        createdAt.hashCode +
        errorMessage.hashCode +
        logicalOperator.hashCode +
        updatedAt.hashCode;

  factory ConditionalValidationSchema.fromJson(Map<String, dynamic> json) => _$ConditionalValidationSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$ConditionalValidationSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


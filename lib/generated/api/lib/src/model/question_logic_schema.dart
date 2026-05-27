//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'question_logic_schema.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class QuestionLogicSchema {
  /// Returns a new [QuestionLogicSchema] instance.
  QuestionLogicSchema({

     this.id,

     this.actionConfig,

     this.calculatedValue,

     this.conditionalLogic,

     this.createdAt,

     this.customScript,

     this.fieldApiCall,

     this.isDisabled = false,

     this.onChange,

     this.triggers,

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
    
    name: r'action_config',
    required: false,
    includeIfNull: false,
  )


  final Object? actionConfig;



  @JsonKey(
    
    name: r'calculated_value',
    required: false,
    includeIfNull: false,
  )


  final Object? calculatedValue;



  @JsonKey(
    
    name: r'conditional_logic',
    required: false,
    includeIfNull: false,
  )


  final Object? conditionalLogic;



  @JsonKey(
    
    name: r'created_at',
    required: false,
    includeIfNull: false,
  )


  final Object? createdAt;



  @JsonKey(
    
    name: r'custom_script',
    required: false,
    includeIfNull: false,
  )


  final Object? customScript;



  @JsonKey(
    
    name: r'field_api_call',
    required: false,
    includeIfNull: false,
  )


  final Object? fieldApiCall;



  @JsonKey(
    defaultValue: false,
    name: r'is_disabled',
    required: false,
    includeIfNull: false,
  )


  final bool? isDisabled;



  @JsonKey(
    
    name: r'on_change',
    required: false,
    includeIfNull: false,
  )


  final Object? onChange;



  @JsonKey(
    
    name: r'triggers',
    required: false,
    includeIfNull: false,
  )


  final List<Object>? triggers;



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
    bool operator ==(Object other) => identical(this, other) || other is QuestionLogicSchema &&
      other.id == id &&
      other.actionConfig == actionConfig &&
      other.calculatedValue == calculatedValue &&
      other.conditionalLogic == conditionalLogic &&
      other.createdAt == createdAt &&
      other.customScript == customScript &&
      other.fieldApiCall == fieldApiCall &&
      other.isDisabled == isDisabled &&
      other.onChange == onChange &&
      other.triggers == triggers &&
      other.updatedAt == updatedAt &&
      other.visibilityCondition == visibilityCondition;

    @override
    int get hashCode =>
        id.hashCode +
        actionConfig.hashCode +
        calculatedValue.hashCode +
        conditionalLogic.hashCode +
        createdAt.hashCode +
        customScript.hashCode +
        fieldApiCall.hashCode +
        isDisabled.hashCode +
        onChange.hashCode +
        triggers.hashCode +
        updatedAt.hashCode +
        visibilityCondition.hashCode;

  factory QuestionLogicSchema.fromJson(Map<String, dynamic> json) => _$QuestionLogicSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionLogicSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


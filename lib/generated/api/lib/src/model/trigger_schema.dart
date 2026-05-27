//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trigger_schema.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TriggerSchema {
  /// Returns a new [TriggerSchema] instance.
  TriggerSchema({

     this.id,

     this.actionConfig,

    required  this.actionType,

     this.condition,

     this.createdAt,

     this.customScript,

    required  this.eventType,

     this.isActive = true,

     this.metaData,

    required  this.name,

     this.order,

     this.updatedAt,
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
    
    name: r'action_type',
    required: true,
    includeIfNull: false,
  )


  final TriggerSchemaActionTypeEnum actionType;



  @JsonKey(
    
    name: r'condition',
    required: false,
    includeIfNull: false,
  )


  final Object? condition;



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
    
    name: r'event_type',
    required: true,
    includeIfNull: false,
  )


  final TriggerSchemaEventTypeEnum eventType;



  @JsonKey(
    defaultValue: true,
    name: r'is_active',
    required: false,
    includeIfNull: false,
  )


  final bool? isActive;



  @JsonKey(
    
    name: r'meta_data',
    required: false,
    includeIfNull: false,
  )


  final Object? metaData;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'order',
    required: false,
    includeIfNull: false,
  )


  final Object? order;



  @JsonKey(
    
    name: r'updated_at',
    required: false,
    includeIfNull: false,
  )


  final Object? updatedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TriggerSchema &&
      other.id == id &&
      other.actionConfig == actionConfig &&
      other.actionType == actionType &&
      other.condition == condition &&
      other.createdAt == createdAt &&
      other.customScript == customScript &&
      other.eventType == eventType &&
      other.isActive == isActive &&
      other.metaData == metaData &&
      other.name == name &&
      other.order == order &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        id.hashCode +
        actionConfig.hashCode +
        actionType.hashCode +
        condition.hashCode +
        createdAt.hashCode +
        customScript.hashCode +
        eventType.hashCode +
        isActive.hashCode +
        metaData.hashCode +
        name.hashCode +
        order.hashCode +
        updatedAt.hashCode;

  factory TriggerSchema.fromJson(Map<String, dynamic> json) => _$TriggerSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$TriggerSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


enum TriggerSchemaActionTypeEnum {
@JsonValue(r'webhook')
webhook(r'webhook'),
@JsonValue(r'email')
email(r'email'),
@JsonValue(r'sms')
sms(r'sms'),
@JsonValue(r'notification')
notification(r'notification'),
@JsonValue(r'update_field')
updateField(r'update_field'),
@JsonValue(r'execute_script')
executeScript(r'execute_script'),
@JsonValue(r'hide_show')
hideShow(r'hide_show'),
@JsonValue(r'enable_disable')
enableDisable(r'enable_disable'),
@JsonValue(r'validation_error')
validationError(r'validation_error'),
@JsonValue(r'calculation')
calculation(r'calculation'),
@JsonValue(r'api_call')
apiCall(r'api_call');

const TriggerSchemaActionTypeEnum(this.value);

final String value;

@override
String toString() => value;
}



enum TriggerSchemaEventTypeEnum {
@JsonValue(r'on_load')
onLoad(r'on_load'),
@JsonValue(r'on_submit')
onSubmit(r'on_submit'),
@JsonValue(r'on_change')
onChange(r'on_change'),
@JsonValue(r'on_status_change')
onStatusChange(r'on_status_change'),
@JsonValue(r'on_validate')
onValidate(r'on_validate'),
@JsonValue(r'on_approval_step')
onApprovalStep(r'on_approval_step'),
@JsonValue(r'on_creation')
onCreation(r'on_creation');

const TriggerSchemaEventTypeEnum(this.value);

final String value;

@override
String toString() => value;
}



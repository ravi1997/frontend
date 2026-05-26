//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'trigger_schema.g.dart';


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
    includeIfNull: false
  )


  final Object? id;



  @JsonKey(
    
    name: r'action_config',
    required: false,
    includeIfNull: false
  )


  final Object? actionConfig;



  @JsonKey(
    
    name: r'action_type',
    required: true,
    includeIfNull: false
  )


  final TriggerSchemaActionTypeEnum actionType;



  @JsonKey(
    
    name: r'condition',
    required: false,
    includeIfNull: false
  )


  final Object? condition;



  @JsonKey(
    
    name: r'created_at',
    required: false,
    includeIfNull: false
  )


  final Object? createdAt;



  @JsonKey(
    
    name: r'custom_script',
    required: false,
    includeIfNull: false
  )


  final Object? customScript;



  @JsonKey(
    
    name: r'event_type',
    required: true,
    includeIfNull: false
  )


  final TriggerSchemaEventTypeEnum eventType;



  @JsonKey(
    defaultValue: true,
    name: r'is_active',
    required: false,
    includeIfNull: false
  )


  final bool? isActive;



  @JsonKey(
    
    name: r'meta_data',
    required: false,
    includeIfNull: false
  )


  final Object? metaData;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false
  )


  final String name;



  @JsonKey(
    
    name: r'order',
    required: false,
    includeIfNull: false
  )


  final Object? order;



  @JsonKey(
    
    name: r'updated_at',
    required: false,
    includeIfNull: false
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
  webhook,
  @JsonValue(r'email')
  email,
  @JsonValue(r'sms')
  sms,
  @JsonValue(r'notification')
  notification,
  @JsonValue(r'update_field')
  updateField,
  @JsonValue(r'execute_script')
  executeScript,
  @JsonValue(r'hide_show')
  hideShow,
  @JsonValue(r'enable_disable')
  enableDisable,
  @JsonValue(r'validation_error')
  validationError,
  @JsonValue(r'calculation')
  calculation,
  @JsonValue(r'api_call')
  apiCall,
}



enum TriggerSchemaEventTypeEnum {
  @JsonValue(r'on_load')
  load,
  @JsonValue(r'on_submit')
  submit,
  @JsonValue(r'on_change')
  change,
  @JsonValue(r'on_status_change')
  statusChange,
  @JsonValue(r'on_validate')
  validate,
  @JsonValue(r'on_approval_step')
  approvalStep,
  @JsonValue(r'on_creation')
  creation,
}



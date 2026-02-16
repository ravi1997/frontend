// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form_question_option.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FormQuestionOption {

 String get id; String? get description;@JsonKey(name: 'is_default') bool get isDefault;@JsonKey(name: 'is_disabled') bool get isDisabled;@JsonKey(name: 'option_label') String get label;@JsonKey(name: 'option_value') String get value; int get order;@JsonKey(name: 'followup_visibility_condition') String? get followupVisibilityCondition;
/// Create a copy of FormQuestionOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormQuestionOptionCopyWith<FormQuestionOption> get copyWith => _$FormQuestionOptionCopyWithImpl<FormQuestionOption>(this as FormQuestionOption, _$identity);

  /// Serializes this FormQuestionOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormQuestionOption&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.isDisabled, isDisabled) || other.isDisabled == isDisabled)&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.order, order) || other.order == order)&&(identical(other.followupVisibilityCondition, followupVisibilityCondition) || other.followupVisibilityCondition == followupVisibilityCondition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,isDefault,isDisabled,label,value,order,followupVisibilityCondition);

@override
String toString() {
  return 'FormQuestionOption(id: $id, description: $description, isDefault: $isDefault, isDisabled: $isDisabled, label: $label, value: $value, order: $order, followupVisibilityCondition: $followupVisibilityCondition)';
}


}

/// @nodoc
abstract mixin class $FormQuestionOptionCopyWith<$Res>  {
  factory $FormQuestionOptionCopyWith(FormQuestionOption value, $Res Function(FormQuestionOption) _then) = _$FormQuestionOptionCopyWithImpl;
@useResult
$Res call({
 String id, String? description,@JsonKey(name: 'is_default') bool isDefault,@JsonKey(name: 'is_disabled') bool isDisabled,@JsonKey(name: 'option_label') String label,@JsonKey(name: 'option_value') String value, int order,@JsonKey(name: 'followup_visibility_condition') String? followupVisibilityCondition
});




}
/// @nodoc
class _$FormQuestionOptionCopyWithImpl<$Res>
    implements $FormQuestionOptionCopyWith<$Res> {
  _$FormQuestionOptionCopyWithImpl(this._self, this._then);

  final FormQuestionOption _self;
  final $Res Function(FormQuestionOption) _then;

/// Create a copy of FormQuestionOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? description = freezed,Object? isDefault = null,Object? isDisabled = null,Object? label = null,Object? value = null,Object? order = null,Object? followupVisibilityCondition = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,isDisabled: null == isDisabled ? _self.isDisabled : isDisabled // ignore: cast_nullable_to_non_nullable
as bool,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,followupVisibilityCondition: freezed == followupVisibilityCondition ? _self.followupVisibilityCondition : followupVisibilityCondition // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FormQuestionOption].
extension FormQuestionOptionPatterns on FormQuestionOption {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormQuestionOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormQuestionOption() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormQuestionOption value)  $default,){
final _that = this;
switch (_that) {
case _FormQuestionOption():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormQuestionOption value)?  $default,){
final _that = this;
switch (_that) {
case _FormQuestionOption() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? description, @JsonKey(name: 'is_default')  bool isDefault, @JsonKey(name: 'is_disabled')  bool isDisabled, @JsonKey(name: 'option_label')  String label, @JsonKey(name: 'option_value')  String value,  int order, @JsonKey(name: 'followup_visibility_condition')  String? followupVisibilityCondition)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormQuestionOption() when $default != null:
return $default(_that.id,_that.description,_that.isDefault,_that.isDisabled,_that.label,_that.value,_that.order,_that.followupVisibilityCondition);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? description, @JsonKey(name: 'is_default')  bool isDefault, @JsonKey(name: 'is_disabled')  bool isDisabled, @JsonKey(name: 'option_label')  String label, @JsonKey(name: 'option_value')  String value,  int order, @JsonKey(name: 'followup_visibility_condition')  String? followupVisibilityCondition)  $default,) {final _that = this;
switch (_that) {
case _FormQuestionOption():
return $default(_that.id,_that.description,_that.isDefault,_that.isDisabled,_that.label,_that.value,_that.order,_that.followupVisibilityCondition);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? description, @JsonKey(name: 'is_default')  bool isDefault, @JsonKey(name: 'is_disabled')  bool isDisabled, @JsonKey(name: 'option_label')  String label, @JsonKey(name: 'option_value')  String value,  int order, @JsonKey(name: 'followup_visibility_condition')  String? followupVisibilityCondition)?  $default,) {final _that = this;
switch (_that) {
case _FormQuestionOption() when $default != null:
return $default(_that.id,_that.description,_that.isDefault,_that.isDisabled,_that.label,_that.value,_that.order,_that.followupVisibilityCondition);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormQuestionOption implements FormQuestionOption {
  const _FormQuestionOption({required this.id, this.description, @JsonKey(name: 'is_default') this.isDefault = false, @JsonKey(name: 'is_disabled') this.isDisabled = false, @JsonKey(name: 'option_label') required this.label, @JsonKey(name: 'option_value') required this.value, this.order = 0, @JsonKey(name: 'followup_visibility_condition') this.followupVisibilityCondition});
  factory _FormQuestionOption.fromJson(Map<String, dynamic> json) => _$FormQuestionOptionFromJson(json);

@override final  String id;
@override final  String? description;
@override@JsonKey(name: 'is_default') final  bool isDefault;
@override@JsonKey(name: 'is_disabled') final  bool isDisabled;
@override@JsonKey(name: 'option_label') final  String label;
@override@JsonKey(name: 'option_value') final  String value;
@override@JsonKey() final  int order;
@override@JsonKey(name: 'followup_visibility_condition') final  String? followupVisibilityCondition;

/// Create a copy of FormQuestionOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormQuestionOptionCopyWith<_FormQuestionOption> get copyWith => __$FormQuestionOptionCopyWithImpl<_FormQuestionOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FormQuestionOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormQuestionOption&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.isDisabled, isDisabled) || other.isDisabled == isDisabled)&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.order, order) || other.order == order)&&(identical(other.followupVisibilityCondition, followupVisibilityCondition) || other.followupVisibilityCondition == followupVisibilityCondition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,isDefault,isDisabled,label,value,order,followupVisibilityCondition);

@override
String toString() {
  return 'FormQuestionOption(id: $id, description: $description, isDefault: $isDefault, isDisabled: $isDisabled, label: $label, value: $value, order: $order, followupVisibilityCondition: $followupVisibilityCondition)';
}


}

/// @nodoc
abstract mixin class _$FormQuestionOptionCopyWith<$Res> implements $FormQuestionOptionCopyWith<$Res> {
  factory _$FormQuestionOptionCopyWith(_FormQuestionOption value, $Res Function(_FormQuestionOption) _then) = __$FormQuestionOptionCopyWithImpl;
@override @useResult
$Res call({
 String id, String? description,@JsonKey(name: 'is_default') bool isDefault,@JsonKey(name: 'is_disabled') bool isDisabled,@JsonKey(name: 'option_label') String label,@JsonKey(name: 'option_value') String value, int order,@JsonKey(name: 'followup_visibility_condition') String? followupVisibilityCondition
});




}
/// @nodoc
class __$FormQuestionOptionCopyWithImpl<$Res>
    implements _$FormQuestionOptionCopyWith<$Res> {
  __$FormQuestionOptionCopyWithImpl(this._self, this._then);

  final _FormQuestionOption _self;
  final $Res Function(_FormQuestionOption) _then;

/// Create a copy of FormQuestionOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? description = freezed,Object? isDefault = null,Object? isDisabled = null,Object? label = null,Object? value = null,Object? order = null,Object? followupVisibilityCondition = freezed,}) {
  return _then(_FormQuestionOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,isDisabled: null == isDisabled ? _self.isDisabled : isDisabled // ignore: cast_nullable_to_non_nullable
as bool,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,followupVisibilityCondition: freezed == followupVisibilityCondition ? _self.followupVisibilityCondition : followupVisibilityCondition // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

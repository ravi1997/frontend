// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FormQuestion {

 String get id; String get label; QuestionType get type; String? get helperText; String? get placeholder; bool get isRequired; List<String>? get options; Map<String, dynamic>? get conditionalLogic;
/// Create a copy of FormQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormQuestionCopyWith<FormQuestion> get copyWith => _$FormQuestionCopyWithImpl<FormQuestion>(this as FormQuestion, _$identity);

  /// Serializes this FormQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.helperText, helperText) || other.helperText == helperText)&&(identical(other.placeholder, placeholder) || other.placeholder == placeholder)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&const DeepCollectionEquality().equals(other.options, options)&&const DeepCollectionEquality().equals(other.conditionalLogic, conditionalLogic));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,type,helperText,placeholder,isRequired,const DeepCollectionEquality().hash(options),const DeepCollectionEquality().hash(conditionalLogic));

@override
String toString() {
  return 'FormQuestion(id: $id, label: $label, type: $type, helperText: $helperText, placeholder: $placeholder, isRequired: $isRequired, options: $options, conditionalLogic: $conditionalLogic)';
}


}

/// @nodoc
abstract mixin class $FormQuestionCopyWith<$Res>  {
  factory $FormQuestionCopyWith(FormQuestion value, $Res Function(FormQuestion) _then) = _$FormQuestionCopyWithImpl;
@useResult
$Res call({
 String id, String label, QuestionType type, String? helperText, String? placeholder, bool isRequired, List<String>? options, Map<String, dynamic>? conditionalLogic
});




}
/// @nodoc
class _$FormQuestionCopyWithImpl<$Res>
    implements $FormQuestionCopyWith<$Res> {
  _$FormQuestionCopyWithImpl(this._self, this._then);

  final FormQuestion _self;
  final $Res Function(FormQuestion) _then;

/// Create a copy of FormQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? type = null,Object? helperText = freezed,Object? placeholder = freezed,Object? isRequired = null,Object? options = freezed,Object? conditionalLogic = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QuestionType,helperText: freezed == helperText ? _self.helperText : helperText // ignore: cast_nullable_to_non_nullable
as String?,placeholder: freezed == placeholder ? _self.placeholder : placeholder // ignore: cast_nullable_to_non_nullable
as String?,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,conditionalLogic: freezed == conditionalLogic ? _self.conditionalLogic : conditionalLogic // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [FormQuestion].
extension FormQuestionPatterns on FormQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormQuestion value)  $default,){
final _that = this;
switch (_that) {
case _FormQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _FormQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  QuestionType type,  String? helperText,  String? placeholder,  bool isRequired,  List<String>? options,  Map<String, dynamic>? conditionalLogic)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormQuestion() when $default != null:
return $default(_that.id,_that.label,_that.type,_that.helperText,_that.placeholder,_that.isRequired,_that.options,_that.conditionalLogic);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  QuestionType type,  String? helperText,  String? placeholder,  bool isRequired,  List<String>? options,  Map<String, dynamic>? conditionalLogic)  $default,) {final _that = this;
switch (_that) {
case _FormQuestion():
return $default(_that.id,_that.label,_that.type,_that.helperText,_that.placeholder,_that.isRequired,_that.options,_that.conditionalLogic);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  QuestionType type,  String? helperText,  String? placeholder,  bool isRequired,  List<String>? options,  Map<String, dynamic>? conditionalLogic)?  $default,) {final _that = this;
switch (_that) {
case _FormQuestion() when $default != null:
return $default(_that.id,_that.label,_that.type,_that.helperText,_that.placeholder,_that.isRequired,_that.options,_that.conditionalLogic);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormQuestion extends FormQuestion {
  const _FormQuestion({required this.id, required this.label, required this.type, this.helperText, this.placeholder, this.isRequired = false, final  List<String>? options, final  Map<String, dynamic>? conditionalLogic}): _options = options,_conditionalLogic = conditionalLogic,super._();
  factory _FormQuestion.fromJson(Map<String, dynamic> json) => _$FormQuestionFromJson(json);

@override final  String id;
@override final  String label;
@override final  QuestionType type;
@override final  String? helperText;
@override final  String? placeholder;
@override@JsonKey() final  bool isRequired;
 final  List<String>? _options;
@override List<String>? get options {
  final value = _options;
  if (value == null) return null;
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  Map<String, dynamic>? _conditionalLogic;
@override Map<String, dynamic>? get conditionalLogic {
  final value = _conditionalLogic;
  if (value == null) return null;
  if (_conditionalLogic is EqualUnmodifiableMapView) return _conditionalLogic;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of FormQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormQuestionCopyWith<_FormQuestion> get copyWith => __$FormQuestionCopyWithImpl<_FormQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FormQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.helperText, helperText) || other.helperText == helperText)&&(identical(other.placeholder, placeholder) || other.placeholder == placeholder)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&const DeepCollectionEquality().equals(other._options, _options)&&const DeepCollectionEquality().equals(other._conditionalLogic, _conditionalLogic));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,type,helperText,placeholder,isRequired,const DeepCollectionEquality().hash(_options),const DeepCollectionEquality().hash(_conditionalLogic));

@override
String toString() {
  return 'FormQuestion(id: $id, label: $label, type: $type, helperText: $helperText, placeholder: $placeholder, isRequired: $isRequired, options: $options, conditionalLogic: $conditionalLogic)';
}


}

/// @nodoc
abstract mixin class _$FormQuestionCopyWith<$Res> implements $FormQuestionCopyWith<$Res> {
  factory _$FormQuestionCopyWith(_FormQuestion value, $Res Function(_FormQuestion) _then) = __$FormQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, QuestionType type, String? helperText, String? placeholder, bool isRequired, List<String>? options, Map<String, dynamic>? conditionalLogic
});




}
/// @nodoc
class __$FormQuestionCopyWithImpl<$Res>
    implements _$FormQuestionCopyWith<$Res> {
  __$FormQuestionCopyWithImpl(this._self, this._then);

  final _FormQuestion _self;
  final $Res Function(_FormQuestion) _then;

/// Create a copy of FormQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? type = null,Object? helperText = freezed,Object? placeholder = freezed,Object? isRequired = null,Object? options = freezed,Object? conditionalLogic = freezed,}) {
  return _then(_FormQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QuestionType,helperText: freezed == helperText ? _self.helperText : helperText // ignore: cast_nullable_to_non_nullable
as String?,placeholder: freezed == placeholder ? _self.placeholder : placeholder // ignore: cast_nullable_to_non_nullable
as String?,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,options: freezed == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,conditionalLogic: freezed == conditionalLogic ? _self._conditionalLogic : conditionalLogic // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on

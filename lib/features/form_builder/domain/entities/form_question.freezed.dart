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

 String get id; String get label; QuestionType get type; String? get helperText; String? get placeholder; bool get isRequired; List<String>? get options; bool get isReadOnly; bool get isHidden; String? get validationRegex; int? get minLength; int? get maxLength; num? get minValue; num? get maxValue; String? get inputMask; String? get customErrorMessage; Map<String, dynamic>? get conditionalLogic; Map<String, dynamic>? get metadata; QuestionStyle get style;
/// Create a copy of FormQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormQuestionCopyWith<FormQuestion> get copyWith => _$FormQuestionCopyWithImpl<FormQuestion>(this as FormQuestion, _$identity);

  /// Serializes this FormQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.helperText, helperText) || other.helperText == helperText)&&(identical(other.placeholder, placeholder) || other.placeholder == placeholder)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.isReadOnly, isReadOnly) || other.isReadOnly == isReadOnly)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.validationRegex, validationRegex) || other.validationRegex == validationRegex)&&(identical(other.minLength, minLength) || other.minLength == minLength)&&(identical(other.maxLength, maxLength) || other.maxLength == maxLength)&&(identical(other.minValue, minValue) || other.minValue == minValue)&&(identical(other.maxValue, maxValue) || other.maxValue == maxValue)&&(identical(other.inputMask, inputMask) || other.inputMask == inputMask)&&(identical(other.customErrorMessage, customErrorMessage) || other.customErrorMessage == customErrorMessage)&&const DeepCollectionEquality().equals(other.conditionalLogic, conditionalLogic)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.style, style) || other.style == style));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,label,type,helperText,placeholder,isRequired,const DeepCollectionEquality().hash(options),isReadOnly,isHidden,validationRegex,minLength,maxLength,minValue,maxValue,inputMask,customErrorMessage,const DeepCollectionEquality().hash(conditionalLogic),const DeepCollectionEquality().hash(metadata),style]);

@override
String toString() {
  return 'FormQuestion(id: $id, label: $label, type: $type, helperText: $helperText, placeholder: $placeholder, isRequired: $isRequired, options: $options, isReadOnly: $isReadOnly, isHidden: $isHidden, validationRegex: $validationRegex, minLength: $minLength, maxLength: $maxLength, minValue: $minValue, maxValue: $maxValue, inputMask: $inputMask, customErrorMessage: $customErrorMessage, conditionalLogic: $conditionalLogic, metadata: $metadata, style: $style)';
}


}

/// @nodoc
abstract mixin class $FormQuestionCopyWith<$Res>  {
  factory $FormQuestionCopyWith(FormQuestion value, $Res Function(FormQuestion) _then) = _$FormQuestionCopyWithImpl;
@useResult
$Res call({
 String id, String label, QuestionType type, String? helperText, String? placeholder, bool isRequired, List<String>? options, bool isReadOnly, bool isHidden, String? validationRegex, int? minLength, int? maxLength, num? minValue, num? maxValue, String? inputMask, String? customErrorMessage, Map<String, dynamic>? conditionalLogic, Map<String, dynamic>? metadata, QuestionStyle style
});


$QuestionStyleCopyWith<$Res> get style;

}
/// @nodoc
class _$FormQuestionCopyWithImpl<$Res>
    implements $FormQuestionCopyWith<$Res> {
  _$FormQuestionCopyWithImpl(this._self, this._then);

  final FormQuestion _self;
  final $Res Function(FormQuestion) _then;

/// Create a copy of FormQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? type = null,Object? helperText = freezed,Object? placeholder = freezed,Object? isRequired = null,Object? options = freezed,Object? isReadOnly = null,Object? isHidden = null,Object? validationRegex = freezed,Object? minLength = freezed,Object? maxLength = freezed,Object? minValue = freezed,Object? maxValue = freezed,Object? inputMask = freezed,Object? customErrorMessage = freezed,Object? conditionalLogic = freezed,Object? metadata = freezed,Object? style = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QuestionType,helperText: freezed == helperText ? _self.helperText : helperText // ignore: cast_nullable_to_non_nullable
as String?,placeholder: freezed == placeholder ? _self.placeholder : placeholder // ignore: cast_nullable_to_non_nullable
as String?,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,isReadOnly: null == isReadOnly ? _self.isReadOnly : isReadOnly // ignore: cast_nullable_to_non_nullable
as bool,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,validationRegex: freezed == validationRegex ? _self.validationRegex : validationRegex // ignore: cast_nullable_to_non_nullable
as String?,minLength: freezed == minLength ? _self.minLength : minLength // ignore: cast_nullable_to_non_nullable
as int?,maxLength: freezed == maxLength ? _self.maxLength : maxLength // ignore: cast_nullable_to_non_nullable
as int?,minValue: freezed == minValue ? _self.minValue : minValue // ignore: cast_nullable_to_non_nullable
as num?,maxValue: freezed == maxValue ? _self.maxValue : maxValue // ignore: cast_nullable_to_non_nullable
as num?,inputMask: freezed == inputMask ? _self.inputMask : inputMask // ignore: cast_nullable_to_non_nullable
as String?,customErrorMessage: freezed == customErrorMessage ? _self.customErrorMessage : customErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,conditionalLogic: freezed == conditionalLogic ? _self.conditionalLogic : conditionalLogic // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as QuestionStyle,
  ));
}
/// Create a copy of FormQuestion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuestionStyleCopyWith<$Res> get style {
  
  return $QuestionStyleCopyWith<$Res>(_self.style, (value) {
    return _then(_self.copyWith(style: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  QuestionType type,  String? helperText,  String? placeholder,  bool isRequired,  List<String>? options,  bool isReadOnly,  bool isHidden,  String? validationRegex,  int? minLength,  int? maxLength,  num? minValue,  num? maxValue,  String? inputMask,  String? customErrorMessage,  Map<String, dynamic>? conditionalLogic,  Map<String, dynamic>? metadata,  QuestionStyle style)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormQuestion() when $default != null:
return $default(_that.id,_that.label,_that.type,_that.helperText,_that.placeholder,_that.isRequired,_that.options,_that.isReadOnly,_that.isHidden,_that.validationRegex,_that.minLength,_that.maxLength,_that.minValue,_that.maxValue,_that.inputMask,_that.customErrorMessage,_that.conditionalLogic,_that.metadata,_that.style);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  QuestionType type,  String? helperText,  String? placeholder,  bool isRequired,  List<String>? options,  bool isReadOnly,  bool isHidden,  String? validationRegex,  int? minLength,  int? maxLength,  num? minValue,  num? maxValue,  String? inputMask,  String? customErrorMessage,  Map<String, dynamic>? conditionalLogic,  Map<String, dynamic>? metadata,  QuestionStyle style)  $default,) {final _that = this;
switch (_that) {
case _FormQuestion():
return $default(_that.id,_that.label,_that.type,_that.helperText,_that.placeholder,_that.isRequired,_that.options,_that.isReadOnly,_that.isHidden,_that.validationRegex,_that.minLength,_that.maxLength,_that.minValue,_that.maxValue,_that.inputMask,_that.customErrorMessage,_that.conditionalLogic,_that.metadata,_that.style);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  QuestionType type,  String? helperText,  String? placeholder,  bool isRequired,  List<String>? options,  bool isReadOnly,  bool isHidden,  String? validationRegex,  int? minLength,  int? maxLength,  num? minValue,  num? maxValue,  String? inputMask,  String? customErrorMessage,  Map<String, dynamic>? conditionalLogic,  Map<String, dynamic>? metadata,  QuestionStyle style)?  $default,) {final _that = this;
switch (_that) {
case _FormQuestion() when $default != null:
return $default(_that.id,_that.label,_that.type,_that.helperText,_that.placeholder,_that.isRequired,_that.options,_that.isReadOnly,_that.isHidden,_that.validationRegex,_that.minLength,_that.maxLength,_that.minValue,_that.maxValue,_that.inputMask,_that.customErrorMessage,_that.conditionalLogic,_that.metadata,_that.style);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormQuestion extends FormQuestion {
  const _FormQuestion({required this.id, required this.label, required this.type, this.helperText, this.placeholder, this.isRequired = false, final  List<String>? options, this.isReadOnly = false, this.isHidden = false, this.validationRegex, this.minLength, this.maxLength, this.minValue, this.maxValue, this.inputMask, this.customErrorMessage, final  Map<String, dynamic>? conditionalLogic, final  Map<String, dynamic>? metadata, this.style = const QuestionStyle()}): _options = options,_conditionalLogic = conditionalLogic,_metadata = metadata,super._();
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

@override@JsonKey() final  bool isReadOnly;
@override@JsonKey() final  bool isHidden;
@override final  String? validationRegex;
@override final  int? minLength;
@override final  int? maxLength;
@override final  num? minValue;
@override final  num? maxValue;
@override final  String? inputMask;
@override final  String? customErrorMessage;
 final  Map<String, dynamic>? _conditionalLogic;
@override Map<String, dynamic>? get conditionalLogic {
  final value = _conditionalLogic;
  if (value == null) return null;
  if (_conditionalLogic is EqualUnmodifiableMapView) return _conditionalLogic;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _metadata;
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey() final  QuestionStyle style;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.helperText, helperText) || other.helperText == helperText)&&(identical(other.placeholder, placeholder) || other.placeholder == placeholder)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.isReadOnly, isReadOnly) || other.isReadOnly == isReadOnly)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.validationRegex, validationRegex) || other.validationRegex == validationRegex)&&(identical(other.minLength, minLength) || other.minLength == minLength)&&(identical(other.maxLength, maxLength) || other.maxLength == maxLength)&&(identical(other.minValue, minValue) || other.minValue == minValue)&&(identical(other.maxValue, maxValue) || other.maxValue == maxValue)&&(identical(other.inputMask, inputMask) || other.inputMask == inputMask)&&(identical(other.customErrorMessage, customErrorMessage) || other.customErrorMessage == customErrorMessage)&&const DeepCollectionEquality().equals(other._conditionalLogic, _conditionalLogic)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.style, style) || other.style == style));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,label,type,helperText,placeholder,isRequired,const DeepCollectionEquality().hash(_options),isReadOnly,isHidden,validationRegex,minLength,maxLength,minValue,maxValue,inputMask,customErrorMessage,const DeepCollectionEquality().hash(_conditionalLogic),const DeepCollectionEquality().hash(_metadata),style]);

@override
String toString() {
  return 'FormQuestion(id: $id, label: $label, type: $type, helperText: $helperText, placeholder: $placeholder, isRequired: $isRequired, options: $options, isReadOnly: $isReadOnly, isHidden: $isHidden, validationRegex: $validationRegex, minLength: $minLength, maxLength: $maxLength, minValue: $minValue, maxValue: $maxValue, inputMask: $inputMask, customErrorMessage: $customErrorMessage, conditionalLogic: $conditionalLogic, metadata: $metadata, style: $style)';
}


}

/// @nodoc
abstract mixin class _$FormQuestionCopyWith<$Res> implements $FormQuestionCopyWith<$Res> {
  factory _$FormQuestionCopyWith(_FormQuestion value, $Res Function(_FormQuestion) _then) = __$FormQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, QuestionType type, String? helperText, String? placeholder, bool isRequired, List<String>? options, bool isReadOnly, bool isHidden, String? validationRegex, int? minLength, int? maxLength, num? minValue, num? maxValue, String? inputMask, String? customErrorMessage, Map<String, dynamic>? conditionalLogic, Map<String, dynamic>? metadata, QuestionStyle style
});


@override $QuestionStyleCopyWith<$Res> get style;

}
/// @nodoc
class __$FormQuestionCopyWithImpl<$Res>
    implements _$FormQuestionCopyWith<$Res> {
  __$FormQuestionCopyWithImpl(this._self, this._then);

  final _FormQuestion _self;
  final $Res Function(_FormQuestion) _then;

/// Create a copy of FormQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? type = null,Object? helperText = freezed,Object? placeholder = freezed,Object? isRequired = null,Object? options = freezed,Object? isReadOnly = null,Object? isHidden = null,Object? validationRegex = freezed,Object? minLength = freezed,Object? maxLength = freezed,Object? minValue = freezed,Object? maxValue = freezed,Object? inputMask = freezed,Object? customErrorMessage = freezed,Object? conditionalLogic = freezed,Object? metadata = freezed,Object? style = null,}) {
  return _then(_FormQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QuestionType,helperText: freezed == helperText ? _self.helperText : helperText // ignore: cast_nullable_to_non_nullable
as String?,placeholder: freezed == placeholder ? _self.placeholder : placeholder // ignore: cast_nullable_to_non_nullable
as String?,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,options: freezed == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,isReadOnly: null == isReadOnly ? _self.isReadOnly : isReadOnly // ignore: cast_nullable_to_non_nullable
as bool,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,validationRegex: freezed == validationRegex ? _self.validationRegex : validationRegex // ignore: cast_nullable_to_non_nullable
as String?,minLength: freezed == minLength ? _self.minLength : minLength // ignore: cast_nullable_to_non_nullable
as int?,maxLength: freezed == maxLength ? _self.maxLength : maxLength // ignore: cast_nullable_to_non_nullable
as int?,minValue: freezed == minValue ? _self.minValue : minValue // ignore: cast_nullable_to_non_nullable
as num?,maxValue: freezed == maxValue ? _self.maxValue : maxValue // ignore: cast_nullable_to_non_nullable
as num?,inputMask: freezed == inputMask ? _self.inputMask : inputMask // ignore: cast_nullable_to_non_nullable
as String?,customErrorMessage: freezed == customErrorMessage ? _self.customErrorMessage : customErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,conditionalLogic: freezed == conditionalLogic ? _self._conditionalLogic : conditionalLogic // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as QuestionStyle,
  ));
}

/// Create a copy of FormQuestion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuestionStyleCopyWith<$Res> get style {
  
  return $QuestionStyleCopyWith<$Res>(_self.style, (value) {
    return _then(_self.copyWith(style: value));
  });
}
}

// dart format on

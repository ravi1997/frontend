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

@JsonKey(readValue: _readId) String get id; String? get variableName; Object? get label;@JsonKey(name: 'field_type') QuestionType get type; Object? get helperText; Object? get placeholder; Object? get defaultValue; bool get isRequired; List<FormQuestionOption>? get options; bool get isReadOnly; bool get isHidden; String? get validationRegex; int? get minLength; int? get maxLength; num? get minValue; num? get maxValue; String? get inputMask; String? get customErrorMessage;// Advanced Validation
 DateTime? get dateMin; DateTime? get dateMax; List<String>? get allowedFileTypes; int? get maxFileSize;// in MB
 int? get maxFiles; bool? get isUnique; bool? get requiresConfirmation;// Checkbox / Select Limits
 int? get minSelection; int? get maxSelection;// Word Count (Paragraph)
 int? get minWordCount; int? get maxWordCount;// Date Constraints
 bool? get disablePastDates; bool? get disableFutureDates; bool? get disableWeekends; Map<String, dynamic>? get conditionalLogic; Map<String, dynamic>? get actionConfig;@JsonKey(name: 'metadata') Map<String, dynamic>? get metadata; QuestionStyle get style;
/// Create a copy of FormQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormQuestionCopyWith<FormQuestion> get copyWith => _$FormQuestionCopyWithImpl<FormQuestion>(this as FormQuestion, _$identity);

  /// Serializes this FormQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.variableName, variableName) || other.variableName == variableName)&&const DeepCollectionEquality().equals(other.label, label)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.helperText, helperText)&&const DeepCollectionEquality().equals(other.placeholder, placeholder)&&const DeepCollectionEquality().equals(other.defaultValue, defaultValue)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.isReadOnly, isReadOnly) || other.isReadOnly == isReadOnly)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.validationRegex, validationRegex) || other.validationRegex == validationRegex)&&(identical(other.minLength, minLength) || other.minLength == minLength)&&(identical(other.maxLength, maxLength) || other.maxLength == maxLength)&&(identical(other.minValue, minValue) || other.minValue == minValue)&&(identical(other.maxValue, maxValue) || other.maxValue == maxValue)&&(identical(other.inputMask, inputMask) || other.inputMask == inputMask)&&(identical(other.customErrorMessage, customErrorMessage) || other.customErrorMessage == customErrorMessage)&&(identical(other.dateMin, dateMin) || other.dateMin == dateMin)&&(identical(other.dateMax, dateMax) || other.dateMax == dateMax)&&const DeepCollectionEquality().equals(other.allowedFileTypes, allowedFileTypes)&&(identical(other.maxFileSize, maxFileSize) || other.maxFileSize == maxFileSize)&&(identical(other.maxFiles, maxFiles) || other.maxFiles == maxFiles)&&(identical(other.isUnique, isUnique) || other.isUnique == isUnique)&&(identical(other.requiresConfirmation, requiresConfirmation) || other.requiresConfirmation == requiresConfirmation)&&(identical(other.minSelection, minSelection) || other.minSelection == minSelection)&&(identical(other.maxSelection, maxSelection) || other.maxSelection == maxSelection)&&(identical(other.minWordCount, minWordCount) || other.minWordCount == minWordCount)&&(identical(other.maxWordCount, maxWordCount) || other.maxWordCount == maxWordCount)&&(identical(other.disablePastDates, disablePastDates) || other.disablePastDates == disablePastDates)&&(identical(other.disableFutureDates, disableFutureDates) || other.disableFutureDates == disableFutureDates)&&(identical(other.disableWeekends, disableWeekends) || other.disableWeekends == disableWeekends)&&const DeepCollectionEquality().equals(other.conditionalLogic, conditionalLogic)&&const DeepCollectionEquality().equals(other.actionConfig, actionConfig)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.style, style) || other.style == style));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,variableName,const DeepCollectionEquality().hash(label),type,const DeepCollectionEquality().hash(helperText),const DeepCollectionEquality().hash(placeholder),const DeepCollectionEquality().hash(defaultValue),isRequired,const DeepCollectionEquality().hash(options),isReadOnly,isHidden,validationRegex,minLength,maxLength,minValue,maxValue,inputMask,customErrorMessage,dateMin,dateMax,const DeepCollectionEquality().hash(allowedFileTypes),maxFileSize,maxFiles,isUnique,requiresConfirmation,minSelection,maxSelection,minWordCount,maxWordCount,disablePastDates,disableFutureDates,disableWeekends,const DeepCollectionEquality().hash(conditionalLogic),const DeepCollectionEquality().hash(actionConfig),const DeepCollectionEquality().hash(metadata),style]);

@override
String toString() {
  return 'FormQuestion(id: $id, variableName: $variableName, label: $label, type: $type, helperText: $helperText, placeholder: $placeholder, defaultValue: $defaultValue, isRequired: $isRequired, options: $options, isReadOnly: $isReadOnly, isHidden: $isHidden, validationRegex: $validationRegex, minLength: $minLength, maxLength: $maxLength, minValue: $minValue, maxValue: $maxValue, inputMask: $inputMask, customErrorMessage: $customErrorMessage, dateMin: $dateMin, dateMax: $dateMax, allowedFileTypes: $allowedFileTypes, maxFileSize: $maxFileSize, maxFiles: $maxFiles, isUnique: $isUnique, requiresConfirmation: $requiresConfirmation, minSelection: $minSelection, maxSelection: $maxSelection, minWordCount: $minWordCount, maxWordCount: $maxWordCount, disablePastDates: $disablePastDates, disableFutureDates: $disableFutureDates, disableWeekends: $disableWeekends, conditionalLogic: $conditionalLogic, actionConfig: $actionConfig, metadata: $metadata, style: $style)';
}


}

/// @nodoc
abstract mixin class $FormQuestionCopyWith<$Res>  {
  factory $FormQuestionCopyWith(FormQuestion value, $Res Function(FormQuestion) _then) = _$FormQuestionCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: _readId) String id, String? variableName, Object? label,@JsonKey(name: 'field_type') QuestionType type, Object? helperText, Object? placeholder, Object? defaultValue, bool isRequired, List<FormQuestionOption>? options, bool isReadOnly, bool isHidden, String? validationRegex, int? minLength, int? maxLength, num? minValue, num? maxValue, String? inputMask, String? customErrorMessage, DateTime? dateMin, DateTime? dateMax, List<String>? allowedFileTypes, int? maxFileSize, int? maxFiles, bool? isUnique, bool? requiresConfirmation, int? minSelection, int? maxSelection, int? minWordCount, int? maxWordCount, bool? disablePastDates, bool? disableFutureDates, bool? disableWeekends, Map<String, dynamic>? conditionalLogic, Map<String, dynamic>? actionConfig,@JsonKey(name: 'metadata') Map<String, dynamic>? metadata, QuestionStyle style
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? variableName = freezed,Object? label = freezed,Object? type = null,Object? helperText = freezed,Object? placeholder = freezed,Object? defaultValue = freezed,Object? isRequired = null,Object? options = freezed,Object? isReadOnly = null,Object? isHidden = null,Object? validationRegex = freezed,Object? minLength = freezed,Object? maxLength = freezed,Object? minValue = freezed,Object? maxValue = freezed,Object? inputMask = freezed,Object? customErrorMessage = freezed,Object? dateMin = freezed,Object? dateMax = freezed,Object? allowedFileTypes = freezed,Object? maxFileSize = freezed,Object? maxFiles = freezed,Object? isUnique = freezed,Object? requiresConfirmation = freezed,Object? minSelection = freezed,Object? maxSelection = freezed,Object? minWordCount = freezed,Object? maxWordCount = freezed,Object? disablePastDates = freezed,Object? disableFutureDates = freezed,Object? disableWeekends = freezed,Object? conditionalLogic = freezed,Object? actionConfig = freezed,Object? metadata = freezed,Object? style = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,variableName: freezed == variableName ? _self.variableName : variableName // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label ,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QuestionType,helperText: freezed == helperText ? _self.helperText : helperText ,placeholder: freezed == placeholder ? _self.placeholder : placeholder ,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue ,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<FormQuestionOption>?,isReadOnly: null == isReadOnly ? _self.isReadOnly : isReadOnly // ignore: cast_nullable_to_non_nullable
as bool,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,validationRegex: freezed == validationRegex ? _self.validationRegex : validationRegex // ignore: cast_nullable_to_non_nullable
as String?,minLength: freezed == minLength ? _self.minLength : minLength // ignore: cast_nullable_to_non_nullable
as int?,maxLength: freezed == maxLength ? _self.maxLength : maxLength // ignore: cast_nullable_to_non_nullable
as int?,minValue: freezed == minValue ? _self.minValue : minValue // ignore: cast_nullable_to_non_nullable
as num?,maxValue: freezed == maxValue ? _self.maxValue : maxValue // ignore: cast_nullable_to_non_nullable
as num?,inputMask: freezed == inputMask ? _self.inputMask : inputMask // ignore: cast_nullable_to_non_nullable
as String?,customErrorMessage: freezed == customErrorMessage ? _self.customErrorMessage : customErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,dateMin: freezed == dateMin ? _self.dateMin : dateMin // ignore: cast_nullable_to_non_nullable
as DateTime?,dateMax: freezed == dateMax ? _self.dateMax : dateMax // ignore: cast_nullable_to_non_nullable
as DateTime?,allowedFileTypes: freezed == allowedFileTypes ? _self.allowedFileTypes : allowedFileTypes // ignore: cast_nullable_to_non_nullable
as List<String>?,maxFileSize: freezed == maxFileSize ? _self.maxFileSize : maxFileSize // ignore: cast_nullable_to_non_nullable
as int?,maxFiles: freezed == maxFiles ? _self.maxFiles : maxFiles // ignore: cast_nullable_to_non_nullable
as int?,isUnique: freezed == isUnique ? _self.isUnique : isUnique // ignore: cast_nullable_to_non_nullable
as bool?,requiresConfirmation: freezed == requiresConfirmation ? _self.requiresConfirmation : requiresConfirmation // ignore: cast_nullable_to_non_nullable
as bool?,minSelection: freezed == minSelection ? _self.minSelection : minSelection // ignore: cast_nullable_to_non_nullable
as int?,maxSelection: freezed == maxSelection ? _self.maxSelection : maxSelection // ignore: cast_nullable_to_non_nullable
as int?,minWordCount: freezed == minWordCount ? _self.minWordCount : minWordCount // ignore: cast_nullable_to_non_nullable
as int?,maxWordCount: freezed == maxWordCount ? _self.maxWordCount : maxWordCount // ignore: cast_nullable_to_non_nullable
as int?,disablePastDates: freezed == disablePastDates ? _self.disablePastDates : disablePastDates // ignore: cast_nullable_to_non_nullable
as bool?,disableFutureDates: freezed == disableFutureDates ? _self.disableFutureDates : disableFutureDates // ignore: cast_nullable_to_non_nullable
as bool?,disableWeekends: freezed == disableWeekends ? _self.disableWeekends : disableWeekends // ignore: cast_nullable_to_non_nullable
as bool?,conditionalLogic: freezed == conditionalLogic ? _self.conditionalLogic : conditionalLogic // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,actionConfig: freezed == actionConfig ? _self.actionConfig : actionConfig // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: _readId)  String id,  String? variableName,  Object? label, @JsonKey(name: 'field_type')  QuestionType type,  Object? helperText,  Object? placeholder,  Object? defaultValue,  bool isRequired,  List<FormQuestionOption>? options,  bool isReadOnly,  bool isHidden,  String? validationRegex,  int? minLength,  int? maxLength,  num? minValue,  num? maxValue,  String? inputMask,  String? customErrorMessage,  DateTime? dateMin,  DateTime? dateMax,  List<String>? allowedFileTypes,  int? maxFileSize,  int? maxFiles,  bool? isUnique,  bool? requiresConfirmation,  int? minSelection,  int? maxSelection,  int? minWordCount,  int? maxWordCount,  bool? disablePastDates,  bool? disableFutureDates,  bool? disableWeekends,  Map<String, dynamic>? conditionalLogic,  Map<String, dynamic>? actionConfig, @JsonKey(name: 'metadata')  Map<String, dynamic>? metadata,  QuestionStyle style)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormQuestion() when $default != null:
return $default(_that.id,_that.variableName,_that.label,_that.type,_that.helperText,_that.placeholder,_that.defaultValue,_that.isRequired,_that.options,_that.isReadOnly,_that.isHidden,_that.validationRegex,_that.minLength,_that.maxLength,_that.minValue,_that.maxValue,_that.inputMask,_that.customErrorMessage,_that.dateMin,_that.dateMax,_that.allowedFileTypes,_that.maxFileSize,_that.maxFiles,_that.isUnique,_that.requiresConfirmation,_that.minSelection,_that.maxSelection,_that.minWordCount,_that.maxWordCount,_that.disablePastDates,_that.disableFutureDates,_that.disableWeekends,_that.conditionalLogic,_that.actionConfig,_that.metadata,_that.style);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: _readId)  String id,  String? variableName,  Object? label, @JsonKey(name: 'field_type')  QuestionType type,  Object? helperText,  Object? placeholder,  Object? defaultValue,  bool isRequired,  List<FormQuestionOption>? options,  bool isReadOnly,  bool isHidden,  String? validationRegex,  int? minLength,  int? maxLength,  num? minValue,  num? maxValue,  String? inputMask,  String? customErrorMessage,  DateTime? dateMin,  DateTime? dateMax,  List<String>? allowedFileTypes,  int? maxFileSize,  int? maxFiles,  bool? isUnique,  bool? requiresConfirmation,  int? minSelection,  int? maxSelection,  int? minWordCount,  int? maxWordCount,  bool? disablePastDates,  bool? disableFutureDates,  bool? disableWeekends,  Map<String, dynamic>? conditionalLogic,  Map<String, dynamic>? actionConfig, @JsonKey(name: 'metadata')  Map<String, dynamic>? metadata,  QuestionStyle style)  $default,) {final _that = this;
switch (_that) {
case _FormQuestion():
return $default(_that.id,_that.variableName,_that.label,_that.type,_that.helperText,_that.placeholder,_that.defaultValue,_that.isRequired,_that.options,_that.isReadOnly,_that.isHidden,_that.validationRegex,_that.minLength,_that.maxLength,_that.minValue,_that.maxValue,_that.inputMask,_that.customErrorMessage,_that.dateMin,_that.dateMax,_that.allowedFileTypes,_that.maxFileSize,_that.maxFiles,_that.isUnique,_that.requiresConfirmation,_that.minSelection,_that.maxSelection,_that.minWordCount,_that.maxWordCount,_that.disablePastDates,_that.disableFutureDates,_that.disableWeekends,_that.conditionalLogic,_that.actionConfig,_that.metadata,_that.style);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: _readId)  String id,  String? variableName,  Object? label, @JsonKey(name: 'field_type')  QuestionType type,  Object? helperText,  Object? placeholder,  Object? defaultValue,  bool isRequired,  List<FormQuestionOption>? options,  bool isReadOnly,  bool isHidden,  String? validationRegex,  int? minLength,  int? maxLength,  num? minValue,  num? maxValue,  String? inputMask,  String? customErrorMessage,  DateTime? dateMin,  DateTime? dateMax,  List<String>? allowedFileTypes,  int? maxFileSize,  int? maxFiles,  bool? isUnique,  bool? requiresConfirmation,  int? minSelection,  int? maxSelection,  int? minWordCount,  int? maxWordCount,  bool? disablePastDates,  bool? disableFutureDates,  bool? disableWeekends,  Map<String, dynamic>? conditionalLogic,  Map<String, dynamic>? actionConfig, @JsonKey(name: 'metadata')  Map<String, dynamic>? metadata,  QuestionStyle style)?  $default,) {final _that = this;
switch (_that) {
case _FormQuestion() when $default != null:
return $default(_that.id,_that.variableName,_that.label,_that.type,_that.helperText,_that.placeholder,_that.defaultValue,_that.isRequired,_that.options,_that.isReadOnly,_that.isHidden,_that.validationRegex,_that.minLength,_that.maxLength,_that.minValue,_that.maxValue,_that.inputMask,_that.customErrorMessage,_that.dateMin,_that.dateMax,_that.allowedFileTypes,_that.maxFileSize,_that.maxFiles,_that.isUnique,_that.requiresConfirmation,_that.minSelection,_that.maxSelection,_that.minWordCount,_that.maxWordCount,_that.disablePastDates,_that.disableFutureDates,_that.disableWeekends,_that.conditionalLogic,_that.actionConfig,_that.metadata,_that.style);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormQuestion extends FormQuestion {
  const _FormQuestion({@JsonKey(readValue: _readId) required this.id, this.variableName, required this.label, @JsonKey(name: 'field_type') required this.type, this.helperText, this.placeholder, this.defaultValue, this.isRequired = false, final  List<FormQuestionOption>? options, this.isReadOnly = false, this.isHidden = false, this.validationRegex, this.minLength, this.maxLength, this.minValue, this.maxValue, this.inputMask, this.customErrorMessage, this.dateMin, this.dateMax, final  List<String>? allowedFileTypes, this.maxFileSize, this.maxFiles, this.isUnique, this.requiresConfirmation, this.minSelection, this.maxSelection, this.minWordCount, this.maxWordCount, this.disablePastDates, this.disableFutureDates, this.disableWeekends, final  Map<String, dynamic>? conditionalLogic, final  Map<String, dynamic>? actionConfig, @JsonKey(name: 'metadata') final  Map<String, dynamic>? metadata, this.style = const QuestionStyle()}): _options = options,_allowedFileTypes = allowedFileTypes,_conditionalLogic = conditionalLogic,_actionConfig = actionConfig,_metadata = metadata,super._();
  factory _FormQuestion.fromJson(Map<String, dynamic> json) => _$FormQuestionFromJson(json);

@override@JsonKey(readValue: _readId) final  String id;
@override final  String? variableName;
@override final  Object? label;
@override@JsonKey(name: 'field_type') final  QuestionType type;
@override final  Object? helperText;
@override final  Object? placeholder;
@override final  Object? defaultValue;
@override@JsonKey() final  bool isRequired;
 final  List<FormQuestionOption>? _options;
@override List<FormQuestionOption>? get options {
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
// Advanced Validation
@override final  DateTime? dateMin;
@override final  DateTime? dateMax;
 final  List<String>? _allowedFileTypes;
@override List<String>? get allowedFileTypes {
  final value = _allowedFileTypes;
  if (value == null) return null;
  if (_allowedFileTypes is EqualUnmodifiableListView) return _allowedFileTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? maxFileSize;
// in MB
@override final  int? maxFiles;
@override final  bool? isUnique;
@override final  bool? requiresConfirmation;
// Checkbox / Select Limits
@override final  int? minSelection;
@override final  int? maxSelection;
// Word Count (Paragraph)
@override final  int? minWordCount;
@override final  int? maxWordCount;
// Date Constraints
@override final  bool? disablePastDates;
@override final  bool? disableFutureDates;
@override final  bool? disableWeekends;
 final  Map<String, dynamic>? _conditionalLogic;
@override Map<String, dynamic>? get conditionalLogic {
  final value = _conditionalLogic;
  if (value == null) return null;
  if (_conditionalLogic is EqualUnmodifiableMapView) return _conditionalLogic;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _actionConfig;
@override Map<String, dynamic>? get actionConfig {
  final value = _actionConfig;
  if (value == null) return null;
  if (_actionConfig is EqualUnmodifiableMapView) return _actionConfig;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _metadata;
@override@JsonKey(name: 'metadata') Map<String, dynamic>? get metadata {
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.variableName, variableName) || other.variableName == variableName)&&const DeepCollectionEquality().equals(other.label, label)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.helperText, helperText)&&const DeepCollectionEquality().equals(other.placeholder, placeholder)&&const DeepCollectionEquality().equals(other.defaultValue, defaultValue)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.isReadOnly, isReadOnly) || other.isReadOnly == isReadOnly)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.validationRegex, validationRegex) || other.validationRegex == validationRegex)&&(identical(other.minLength, minLength) || other.minLength == minLength)&&(identical(other.maxLength, maxLength) || other.maxLength == maxLength)&&(identical(other.minValue, minValue) || other.minValue == minValue)&&(identical(other.maxValue, maxValue) || other.maxValue == maxValue)&&(identical(other.inputMask, inputMask) || other.inputMask == inputMask)&&(identical(other.customErrorMessage, customErrorMessage) || other.customErrorMessage == customErrorMessage)&&(identical(other.dateMin, dateMin) || other.dateMin == dateMin)&&(identical(other.dateMax, dateMax) || other.dateMax == dateMax)&&const DeepCollectionEquality().equals(other._allowedFileTypes, _allowedFileTypes)&&(identical(other.maxFileSize, maxFileSize) || other.maxFileSize == maxFileSize)&&(identical(other.maxFiles, maxFiles) || other.maxFiles == maxFiles)&&(identical(other.isUnique, isUnique) || other.isUnique == isUnique)&&(identical(other.requiresConfirmation, requiresConfirmation) || other.requiresConfirmation == requiresConfirmation)&&(identical(other.minSelection, minSelection) || other.minSelection == minSelection)&&(identical(other.maxSelection, maxSelection) || other.maxSelection == maxSelection)&&(identical(other.minWordCount, minWordCount) || other.minWordCount == minWordCount)&&(identical(other.maxWordCount, maxWordCount) || other.maxWordCount == maxWordCount)&&(identical(other.disablePastDates, disablePastDates) || other.disablePastDates == disablePastDates)&&(identical(other.disableFutureDates, disableFutureDates) || other.disableFutureDates == disableFutureDates)&&(identical(other.disableWeekends, disableWeekends) || other.disableWeekends == disableWeekends)&&const DeepCollectionEquality().equals(other._conditionalLogic, _conditionalLogic)&&const DeepCollectionEquality().equals(other._actionConfig, _actionConfig)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.style, style) || other.style == style));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,variableName,const DeepCollectionEquality().hash(label),type,const DeepCollectionEquality().hash(helperText),const DeepCollectionEquality().hash(placeholder),const DeepCollectionEquality().hash(defaultValue),isRequired,const DeepCollectionEquality().hash(_options),isReadOnly,isHidden,validationRegex,minLength,maxLength,minValue,maxValue,inputMask,customErrorMessage,dateMin,dateMax,const DeepCollectionEquality().hash(_allowedFileTypes),maxFileSize,maxFiles,isUnique,requiresConfirmation,minSelection,maxSelection,minWordCount,maxWordCount,disablePastDates,disableFutureDates,disableWeekends,const DeepCollectionEquality().hash(_conditionalLogic),const DeepCollectionEquality().hash(_actionConfig),const DeepCollectionEquality().hash(_metadata),style]);

@override
String toString() {
  return 'FormQuestion(id: $id, variableName: $variableName, label: $label, type: $type, helperText: $helperText, placeholder: $placeholder, defaultValue: $defaultValue, isRequired: $isRequired, options: $options, isReadOnly: $isReadOnly, isHidden: $isHidden, validationRegex: $validationRegex, minLength: $minLength, maxLength: $maxLength, minValue: $minValue, maxValue: $maxValue, inputMask: $inputMask, customErrorMessage: $customErrorMessage, dateMin: $dateMin, dateMax: $dateMax, allowedFileTypes: $allowedFileTypes, maxFileSize: $maxFileSize, maxFiles: $maxFiles, isUnique: $isUnique, requiresConfirmation: $requiresConfirmation, minSelection: $minSelection, maxSelection: $maxSelection, minWordCount: $minWordCount, maxWordCount: $maxWordCount, disablePastDates: $disablePastDates, disableFutureDates: $disableFutureDates, disableWeekends: $disableWeekends, conditionalLogic: $conditionalLogic, actionConfig: $actionConfig, metadata: $metadata, style: $style)';
}


}

/// @nodoc
abstract mixin class _$FormQuestionCopyWith<$Res> implements $FormQuestionCopyWith<$Res> {
  factory _$FormQuestionCopyWith(_FormQuestion value, $Res Function(_FormQuestion) _then) = __$FormQuestionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: _readId) String id, String? variableName, Object? label,@JsonKey(name: 'field_type') QuestionType type, Object? helperText, Object? placeholder, Object? defaultValue, bool isRequired, List<FormQuestionOption>? options, bool isReadOnly, bool isHidden, String? validationRegex, int? minLength, int? maxLength, num? minValue, num? maxValue, String? inputMask, String? customErrorMessage, DateTime? dateMin, DateTime? dateMax, List<String>? allowedFileTypes, int? maxFileSize, int? maxFiles, bool? isUnique, bool? requiresConfirmation, int? minSelection, int? maxSelection, int? minWordCount, int? maxWordCount, bool? disablePastDates, bool? disableFutureDates, bool? disableWeekends, Map<String, dynamic>? conditionalLogic, Map<String, dynamic>? actionConfig,@JsonKey(name: 'metadata') Map<String, dynamic>? metadata, QuestionStyle style
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? variableName = freezed,Object? label = freezed,Object? type = null,Object? helperText = freezed,Object? placeholder = freezed,Object? defaultValue = freezed,Object? isRequired = null,Object? options = freezed,Object? isReadOnly = null,Object? isHidden = null,Object? validationRegex = freezed,Object? minLength = freezed,Object? maxLength = freezed,Object? minValue = freezed,Object? maxValue = freezed,Object? inputMask = freezed,Object? customErrorMessage = freezed,Object? dateMin = freezed,Object? dateMax = freezed,Object? allowedFileTypes = freezed,Object? maxFileSize = freezed,Object? maxFiles = freezed,Object? isUnique = freezed,Object? requiresConfirmation = freezed,Object? minSelection = freezed,Object? maxSelection = freezed,Object? minWordCount = freezed,Object? maxWordCount = freezed,Object? disablePastDates = freezed,Object? disableFutureDates = freezed,Object? disableWeekends = freezed,Object? conditionalLogic = freezed,Object? actionConfig = freezed,Object? metadata = freezed,Object? style = null,}) {
  return _then(_FormQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,variableName: freezed == variableName ? _self.variableName : variableName // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label ,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QuestionType,helperText: freezed == helperText ? _self.helperText : helperText ,placeholder: freezed == placeholder ? _self.placeholder : placeholder ,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue ,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,options: freezed == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<FormQuestionOption>?,isReadOnly: null == isReadOnly ? _self.isReadOnly : isReadOnly // ignore: cast_nullable_to_non_nullable
as bool,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,validationRegex: freezed == validationRegex ? _self.validationRegex : validationRegex // ignore: cast_nullable_to_non_nullable
as String?,minLength: freezed == minLength ? _self.minLength : minLength // ignore: cast_nullable_to_non_nullable
as int?,maxLength: freezed == maxLength ? _self.maxLength : maxLength // ignore: cast_nullable_to_non_nullable
as int?,minValue: freezed == minValue ? _self.minValue : minValue // ignore: cast_nullable_to_non_nullable
as num?,maxValue: freezed == maxValue ? _self.maxValue : maxValue // ignore: cast_nullable_to_non_nullable
as num?,inputMask: freezed == inputMask ? _self.inputMask : inputMask // ignore: cast_nullable_to_non_nullable
as String?,customErrorMessage: freezed == customErrorMessage ? _self.customErrorMessage : customErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,dateMin: freezed == dateMin ? _self.dateMin : dateMin // ignore: cast_nullable_to_non_nullable
as DateTime?,dateMax: freezed == dateMax ? _self.dateMax : dateMax // ignore: cast_nullable_to_non_nullable
as DateTime?,allowedFileTypes: freezed == allowedFileTypes ? _self._allowedFileTypes : allowedFileTypes // ignore: cast_nullable_to_non_nullable
as List<String>?,maxFileSize: freezed == maxFileSize ? _self.maxFileSize : maxFileSize // ignore: cast_nullable_to_non_nullable
as int?,maxFiles: freezed == maxFiles ? _self.maxFiles : maxFiles // ignore: cast_nullable_to_non_nullable
as int?,isUnique: freezed == isUnique ? _self.isUnique : isUnique // ignore: cast_nullable_to_non_nullable
as bool?,requiresConfirmation: freezed == requiresConfirmation ? _self.requiresConfirmation : requiresConfirmation // ignore: cast_nullable_to_non_nullable
as bool?,minSelection: freezed == minSelection ? _self.minSelection : minSelection // ignore: cast_nullable_to_non_nullable
as int?,maxSelection: freezed == maxSelection ? _self.maxSelection : maxSelection // ignore: cast_nullable_to_non_nullable
as int?,minWordCount: freezed == minWordCount ? _self.minWordCount : minWordCount // ignore: cast_nullable_to_non_nullable
as int?,maxWordCount: freezed == maxWordCount ? _self.maxWordCount : maxWordCount // ignore: cast_nullable_to_non_nullable
as int?,disablePastDates: freezed == disablePastDates ? _self.disablePastDates : disablePastDates // ignore: cast_nullable_to_non_nullable
as bool?,disableFutureDates: freezed == disableFutureDates ? _self.disableFutureDates : disableFutureDates // ignore: cast_nullable_to_non_nullable
as bool?,disableWeekends: freezed == disableWeekends ? _self.disableWeekends : disableWeekends // ignore: cast_nullable_to_non_nullable
as bool?,conditionalLogic: freezed == conditionalLogic ? _self._conditionalLogic : conditionalLogic // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,actionConfig: freezed == actionConfig ? _self._actionConfig : actionConfig // ignore: cast_nullable_to_non_nullable
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

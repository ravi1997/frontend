// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Question {

 String get id;@JsonKey(name: 'variable_name') String? get variableName; String get label;@JsonKey(name: 'field_type') String get fieldType;@JsonKey(name: 'help_text') String? get helpText;@JsonKey(name: 'default_value') dynamic get defaultValue;@JsonKey(name: 'is_read_only') bool get isReadOnly;@JsonKey(name: 'is_hidden') bool get isHidden;@JsonKey(name: 'is_repeatable') bool get isRepeatable;@JsonKey(name: 'repeat_min') int? get repeatMin;@JsonKey(name: 'repeat_max') int? get repeatMax;@JsonKey(name: 'keep_last_value') bool get keepLastValue;// UI, Validation & Logic configurations
 Map<String, dynamic> get validation; Map<String, dynamic> get logic; Map<String, dynamic> get ui;// Choices / Nested structures
 List<Map<String, dynamic>> get options; List<String> get tags;@JsonKey(name: 'meta_data') Map<String, dynamic> get metadata;
/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionCopyWith<Question> get copyWith => _$QuestionCopyWithImpl<Question>(this as Question, _$identity);

  /// Serializes this Question to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Question&&(identical(other.id, id) || other.id == id)&&(identical(other.variableName, variableName) || other.variableName == variableName)&&(identical(other.label, label) || other.label == label)&&(identical(other.fieldType, fieldType) || other.fieldType == fieldType)&&(identical(other.helpText, helpText) || other.helpText == helpText)&&const DeepCollectionEquality().equals(other.defaultValue, defaultValue)&&(identical(other.isReadOnly, isReadOnly) || other.isReadOnly == isReadOnly)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.isRepeatable, isRepeatable) || other.isRepeatable == isRepeatable)&&(identical(other.repeatMin, repeatMin) || other.repeatMin == repeatMin)&&(identical(other.repeatMax, repeatMax) || other.repeatMax == repeatMax)&&(identical(other.keepLastValue, keepLastValue) || other.keepLastValue == keepLastValue)&&const DeepCollectionEquality().equals(other.validation, validation)&&const DeepCollectionEquality().equals(other.logic, logic)&&const DeepCollectionEquality().equals(other.ui, ui)&&const DeepCollectionEquality().equals(other.options, options)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,variableName,label,fieldType,helpText,const DeepCollectionEquality().hash(defaultValue),isReadOnly,isHidden,isRepeatable,repeatMin,repeatMax,keepLastValue,const DeepCollectionEquality().hash(validation),const DeepCollectionEquality().hash(logic),const DeepCollectionEquality().hash(ui),const DeepCollectionEquality().hash(options),const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'Question(id: $id, variableName: $variableName, label: $label, fieldType: $fieldType, helpText: $helpText, defaultValue: $defaultValue, isReadOnly: $isReadOnly, isHidden: $isHidden, isRepeatable: $isRepeatable, repeatMin: $repeatMin, repeatMax: $repeatMax, keepLastValue: $keepLastValue, validation: $validation, logic: $logic, ui: $ui, options: $options, tags: $tags, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $QuestionCopyWith<$Res>  {
  factory $QuestionCopyWith(Question value, $Res Function(Question) _then) = _$QuestionCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'variable_name') String? variableName, String label,@JsonKey(name: 'field_type') String fieldType,@JsonKey(name: 'help_text') String? helpText,@JsonKey(name: 'default_value') dynamic defaultValue,@JsonKey(name: 'is_read_only') bool isReadOnly,@JsonKey(name: 'is_hidden') bool isHidden,@JsonKey(name: 'is_repeatable') bool isRepeatable,@JsonKey(name: 'repeat_min') int? repeatMin,@JsonKey(name: 'repeat_max') int? repeatMax,@JsonKey(name: 'keep_last_value') bool keepLastValue, Map<String, dynamic> validation, Map<String, dynamic> logic, Map<String, dynamic> ui, List<Map<String, dynamic>> options, List<String> tags,@JsonKey(name: 'meta_data') Map<String, dynamic> metadata
});




}
/// @nodoc
class _$QuestionCopyWithImpl<$Res>
    implements $QuestionCopyWith<$Res> {
  _$QuestionCopyWithImpl(this._self, this._then);

  final Question _self;
  final $Res Function(Question) _then;

/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? variableName = freezed,Object? label = null,Object? fieldType = null,Object? helpText = freezed,Object? defaultValue = freezed,Object? isReadOnly = null,Object? isHidden = null,Object? isRepeatable = null,Object? repeatMin = freezed,Object? repeatMax = freezed,Object? keepLastValue = null,Object? validation = null,Object? logic = null,Object? ui = null,Object? options = null,Object? tags = null,Object? metadata = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,variableName: freezed == variableName ? _self.variableName : variableName // ignore: cast_nullable_to_non_nullable
as String?,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,fieldType: null == fieldType ? _self.fieldType : fieldType // ignore: cast_nullable_to_non_nullable
as String,helpText: freezed == helpText ? _self.helpText : helpText // ignore: cast_nullable_to_non_nullable
as String?,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as dynamic,isReadOnly: null == isReadOnly ? _self.isReadOnly : isReadOnly // ignore: cast_nullable_to_non_nullable
as bool,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,isRepeatable: null == isRepeatable ? _self.isRepeatable : isRepeatable // ignore: cast_nullable_to_non_nullable
as bool,repeatMin: freezed == repeatMin ? _self.repeatMin : repeatMin // ignore: cast_nullable_to_non_nullable
as int?,repeatMax: freezed == repeatMax ? _self.repeatMax : repeatMax // ignore: cast_nullable_to_non_nullable
as int?,keepLastValue: null == keepLastValue ? _self.keepLastValue : keepLastValue // ignore: cast_nullable_to_non_nullable
as bool,validation: null == validation ? _self.validation : validation // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,logic: null == logic ? _self.logic : logic // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,ui: null == ui ? _self.ui : ui // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [Question].
extension QuestionPatterns on Question {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Question value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Question() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Question value)  $default,){
final _that = this;
switch (_that) {
case _Question():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Question value)?  $default,){
final _that = this;
switch (_that) {
case _Question() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'variable_name')  String? variableName,  String label, @JsonKey(name: 'field_type')  String fieldType, @JsonKey(name: 'help_text')  String? helpText, @JsonKey(name: 'default_value')  dynamic defaultValue, @JsonKey(name: 'is_read_only')  bool isReadOnly, @JsonKey(name: 'is_hidden')  bool isHidden, @JsonKey(name: 'is_repeatable')  bool isRepeatable, @JsonKey(name: 'repeat_min')  int? repeatMin, @JsonKey(name: 'repeat_max')  int? repeatMax, @JsonKey(name: 'keep_last_value')  bool keepLastValue,  Map<String, dynamic> validation,  Map<String, dynamic> logic,  Map<String, dynamic> ui,  List<Map<String, dynamic>> options,  List<String> tags, @JsonKey(name: 'meta_data')  Map<String, dynamic> metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Question() when $default != null:
return $default(_that.id,_that.variableName,_that.label,_that.fieldType,_that.helpText,_that.defaultValue,_that.isReadOnly,_that.isHidden,_that.isRepeatable,_that.repeatMin,_that.repeatMax,_that.keepLastValue,_that.validation,_that.logic,_that.ui,_that.options,_that.tags,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'variable_name')  String? variableName,  String label, @JsonKey(name: 'field_type')  String fieldType, @JsonKey(name: 'help_text')  String? helpText, @JsonKey(name: 'default_value')  dynamic defaultValue, @JsonKey(name: 'is_read_only')  bool isReadOnly, @JsonKey(name: 'is_hidden')  bool isHidden, @JsonKey(name: 'is_repeatable')  bool isRepeatable, @JsonKey(name: 'repeat_min')  int? repeatMin, @JsonKey(name: 'repeat_max')  int? repeatMax, @JsonKey(name: 'keep_last_value')  bool keepLastValue,  Map<String, dynamic> validation,  Map<String, dynamic> logic,  Map<String, dynamic> ui,  List<Map<String, dynamic>> options,  List<String> tags, @JsonKey(name: 'meta_data')  Map<String, dynamic> metadata)  $default,) {final _that = this;
switch (_that) {
case _Question():
return $default(_that.id,_that.variableName,_that.label,_that.fieldType,_that.helpText,_that.defaultValue,_that.isReadOnly,_that.isHidden,_that.isRepeatable,_that.repeatMin,_that.repeatMax,_that.keepLastValue,_that.validation,_that.logic,_that.ui,_that.options,_that.tags,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'variable_name')  String? variableName,  String label, @JsonKey(name: 'field_type')  String fieldType, @JsonKey(name: 'help_text')  String? helpText, @JsonKey(name: 'default_value')  dynamic defaultValue, @JsonKey(name: 'is_read_only')  bool isReadOnly, @JsonKey(name: 'is_hidden')  bool isHidden, @JsonKey(name: 'is_repeatable')  bool isRepeatable, @JsonKey(name: 'repeat_min')  int? repeatMin, @JsonKey(name: 'repeat_max')  int? repeatMax, @JsonKey(name: 'keep_last_value')  bool keepLastValue,  Map<String, dynamic> validation,  Map<String, dynamic> logic,  Map<String, dynamic> ui,  List<Map<String, dynamic>> options,  List<String> tags, @JsonKey(name: 'meta_data')  Map<String, dynamic> metadata)?  $default,) {final _that = this;
switch (_that) {
case _Question() when $default != null:
return $default(_that.id,_that.variableName,_that.label,_that.fieldType,_that.helpText,_that.defaultValue,_that.isReadOnly,_that.isHidden,_that.isRepeatable,_that.repeatMin,_that.repeatMax,_that.keepLastValue,_that.validation,_that.logic,_that.ui,_that.options,_that.tags,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Question extends Question {
  const _Question({required this.id, @JsonKey(name: 'variable_name') this.variableName, required this.label, @JsonKey(name: 'field_type') required this.fieldType, @JsonKey(name: 'help_text') this.helpText, @JsonKey(name: 'default_value') this.defaultValue, @JsonKey(name: 'is_read_only') this.isReadOnly = false, @JsonKey(name: 'is_hidden') this.isHidden = false, @JsonKey(name: 'is_repeatable') this.isRepeatable = false, @JsonKey(name: 'repeat_min') this.repeatMin, @JsonKey(name: 'repeat_max') this.repeatMax, @JsonKey(name: 'keep_last_value') this.keepLastValue = false, final  Map<String, dynamic> validation = const <String, dynamic>{}, final  Map<String, dynamic> logic = const <String, dynamic>{}, final  Map<String, dynamic> ui = const <String, dynamic>{}, final  List<Map<String, dynamic>> options = const <Map<String, dynamic>>[], final  List<String> tags = const <String>[], @JsonKey(name: 'meta_data') final  Map<String, dynamic> metadata = const <String, dynamic>{}}): _validation = validation,_logic = logic,_ui = ui,_options = options,_tags = tags,_metadata = metadata,super._();
  factory _Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);

@override final  String id;
@override@JsonKey(name: 'variable_name') final  String? variableName;
@override final  String label;
@override@JsonKey(name: 'field_type') final  String fieldType;
@override@JsonKey(name: 'help_text') final  String? helpText;
@override@JsonKey(name: 'default_value') final  dynamic defaultValue;
@override@JsonKey(name: 'is_read_only') final  bool isReadOnly;
@override@JsonKey(name: 'is_hidden') final  bool isHidden;
@override@JsonKey(name: 'is_repeatable') final  bool isRepeatable;
@override@JsonKey(name: 'repeat_min') final  int? repeatMin;
@override@JsonKey(name: 'repeat_max') final  int? repeatMax;
@override@JsonKey(name: 'keep_last_value') final  bool keepLastValue;
// UI, Validation & Logic configurations
 final  Map<String, dynamic> _validation;
// UI, Validation & Logic configurations
@override@JsonKey() Map<String, dynamic> get validation {
  if (_validation is EqualUnmodifiableMapView) return _validation;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_validation);
}

 final  Map<String, dynamic> _logic;
@override@JsonKey() Map<String, dynamic> get logic {
  if (_logic is EqualUnmodifiableMapView) return _logic;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_logic);
}

 final  Map<String, dynamic> _ui;
@override@JsonKey() Map<String, dynamic> get ui {
  if (_ui is EqualUnmodifiableMapView) return _ui;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_ui);
}

// Choices / Nested structures
 final  List<Map<String, dynamic>> _options;
// Choices / Nested structures
@override@JsonKey() List<Map<String, dynamic>> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  Map<String, dynamic> _metadata;
@override@JsonKey(name: 'meta_data') Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}


/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionCopyWith<_Question> get copyWith => __$QuestionCopyWithImpl<_Question>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Question&&(identical(other.id, id) || other.id == id)&&(identical(other.variableName, variableName) || other.variableName == variableName)&&(identical(other.label, label) || other.label == label)&&(identical(other.fieldType, fieldType) || other.fieldType == fieldType)&&(identical(other.helpText, helpText) || other.helpText == helpText)&&const DeepCollectionEquality().equals(other.defaultValue, defaultValue)&&(identical(other.isReadOnly, isReadOnly) || other.isReadOnly == isReadOnly)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.isRepeatable, isRepeatable) || other.isRepeatable == isRepeatable)&&(identical(other.repeatMin, repeatMin) || other.repeatMin == repeatMin)&&(identical(other.repeatMax, repeatMax) || other.repeatMax == repeatMax)&&(identical(other.keepLastValue, keepLastValue) || other.keepLastValue == keepLastValue)&&const DeepCollectionEquality().equals(other._validation, _validation)&&const DeepCollectionEquality().equals(other._logic, _logic)&&const DeepCollectionEquality().equals(other._ui, _ui)&&const DeepCollectionEquality().equals(other._options, _options)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,variableName,label,fieldType,helpText,const DeepCollectionEquality().hash(defaultValue),isReadOnly,isHidden,isRepeatable,repeatMin,repeatMax,keepLastValue,const DeepCollectionEquality().hash(_validation),const DeepCollectionEquality().hash(_logic),const DeepCollectionEquality().hash(_ui),const DeepCollectionEquality().hash(_options),const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'Question(id: $id, variableName: $variableName, label: $label, fieldType: $fieldType, helpText: $helpText, defaultValue: $defaultValue, isReadOnly: $isReadOnly, isHidden: $isHidden, isRepeatable: $isRepeatable, repeatMin: $repeatMin, repeatMax: $repeatMax, keepLastValue: $keepLastValue, validation: $validation, logic: $logic, ui: $ui, options: $options, tags: $tags, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$QuestionCopyWith<$Res> implements $QuestionCopyWith<$Res> {
  factory _$QuestionCopyWith(_Question value, $Res Function(_Question) _then) = __$QuestionCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'variable_name') String? variableName, String label,@JsonKey(name: 'field_type') String fieldType,@JsonKey(name: 'help_text') String? helpText,@JsonKey(name: 'default_value') dynamic defaultValue,@JsonKey(name: 'is_read_only') bool isReadOnly,@JsonKey(name: 'is_hidden') bool isHidden,@JsonKey(name: 'is_repeatable') bool isRepeatable,@JsonKey(name: 'repeat_min') int? repeatMin,@JsonKey(name: 'repeat_max') int? repeatMax,@JsonKey(name: 'keep_last_value') bool keepLastValue, Map<String, dynamic> validation, Map<String, dynamic> logic, Map<String, dynamic> ui, List<Map<String, dynamic>> options, List<String> tags,@JsonKey(name: 'meta_data') Map<String, dynamic> metadata
});




}
/// @nodoc
class __$QuestionCopyWithImpl<$Res>
    implements _$QuestionCopyWith<$Res> {
  __$QuestionCopyWithImpl(this._self, this._then);

  final _Question _self;
  final $Res Function(_Question) _then;

/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? variableName = freezed,Object? label = null,Object? fieldType = null,Object? helpText = freezed,Object? defaultValue = freezed,Object? isReadOnly = null,Object? isHidden = null,Object? isRepeatable = null,Object? repeatMin = freezed,Object? repeatMax = freezed,Object? keepLastValue = null,Object? validation = null,Object? logic = null,Object? ui = null,Object? options = null,Object? tags = null,Object? metadata = null,}) {
  return _then(_Question(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,variableName: freezed == variableName ? _self.variableName : variableName // ignore: cast_nullable_to_non_nullable
as String?,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,fieldType: null == fieldType ? _self.fieldType : fieldType // ignore: cast_nullable_to_non_nullable
as String,helpText: freezed == helpText ? _self.helpText : helpText // ignore: cast_nullable_to_non_nullable
as String?,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as dynamic,isReadOnly: null == isReadOnly ? _self.isReadOnly : isReadOnly // ignore: cast_nullable_to_non_nullable
as bool,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,isRepeatable: null == isRepeatable ? _self.isRepeatable : isRepeatable // ignore: cast_nullable_to_non_nullable
as bool,repeatMin: freezed == repeatMin ? _self.repeatMin : repeatMin // ignore: cast_nullable_to_non_nullable
as int?,repeatMax: freezed == repeatMax ? _self.repeatMax : repeatMax // ignore: cast_nullable_to_non_nullable
as int?,keepLastValue: null == keepLastValue ? _self.keepLastValue : keepLastValue // ignore: cast_nullable_to_non_nullable
as bool,validation: null == validation ? _self._validation : validation // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,logic: null == logic ? _self._logic : logic // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,ui: null == ui ? _self._ui : ui // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}


/// @nodoc
mixin _$Section {

 String get id; String get title; String? get description;@JsonKey(name: 'help_text') String? get helpText; int get order; List<Question> get questions; List<Section> get sections;// Nested sub-sections
 String get layout;@JsonKey(name: 'grid_columns') int get gridColumns;@JsonKey(name: 'is_hidden') bool get isHidden;@JsonKey(name: 'is_repeatable') bool get isRepeatable;@JsonKey(name: 'repeat_min') int? get repeatMin;@JsonKey(name: 'repeat_max') int? get repeatMax; Map<String, dynamic> get logic; Map<String, dynamic> get ui; List<String> get tags;@JsonKey(name: 'meta_data') Map<String, dynamic> get metadata;
/// Create a copy of Section
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SectionCopyWith<Section> get copyWith => _$SectionCopyWithImpl<Section>(this as Section, _$identity);

  /// Serializes this Section to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Section&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.helpText, helpText) || other.helpText == helpText)&&(identical(other.order, order) || other.order == order)&&const DeepCollectionEquality().equals(other.questions, questions)&&const DeepCollectionEquality().equals(other.sections, sections)&&(identical(other.layout, layout) || other.layout == layout)&&(identical(other.gridColumns, gridColumns) || other.gridColumns == gridColumns)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.isRepeatable, isRepeatable) || other.isRepeatable == isRepeatable)&&(identical(other.repeatMin, repeatMin) || other.repeatMin == repeatMin)&&(identical(other.repeatMax, repeatMax) || other.repeatMax == repeatMax)&&const DeepCollectionEquality().equals(other.logic, logic)&&const DeepCollectionEquality().equals(other.ui, ui)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,helpText,order,const DeepCollectionEquality().hash(questions),const DeepCollectionEquality().hash(sections),layout,gridColumns,isHidden,isRepeatable,repeatMin,repeatMax,const DeepCollectionEquality().hash(logic),const DeepCollectionEquality().hash(ui),const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'Section(id: $id, title: $title, description: $description, helpText: $helpText, order: $order, questions: $questions, sections: $sections, layout: $layout, gridColumns: $gridColumns, isHidden: $isHidden, isRepeatable: $isRepeatable, repeatMin: $repeatMin, repeatMax: $repeatMax, logic: $logic, ui: $ui, tags: $tags, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $SectionCopyWith<$Res>  {
  factory $SectionCopyWith(Section value, $Res Function(Section) _then) = _$SectionCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? description,@JsonKey(name: 'help_text') String? helpText, int order, List<Question> questions, List<Section> sections, String layout,@JsonKey(name: 'grid_columns') int gridColumns,@JsonKey(name: 'is_hidden') bool isHidden,@JsonKey(name: 'is_repeatable') bool isRepeatable,@JsonKey(name: 'repeat_min') int? repeatMin,@JsonKey(name: 'repeat_max') int? repeatMax, Map<String, dynamic> logic, Map<String, dynamic> ui, List<String> tags,@JsonKey(name: 'meta_data') Map<String, dynamic> metadata
});




}
/// @nodoc
class _$SectionCopyWithImpl<$Res>
    implements $SectionCopyWith<$Res> {
  _$SectionCopyWithImpl(this._self, this._then);

  final Section _self;
  final $Res Function(Section) _then;

/// Create a copy of Section
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? helpText = freezed,Object? order = null,Object? questions = null,Object? sections = null,Object? layout = null,Object? gridColumns = null,Object? isHidden = null,Object? isRepeatable = null,Object? repeatMin = freezed,Object? repeatMax = freezed,Object? logic = null,Object? ui = null,Object? tags = null,Object? metadata = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,helpText: freezed == helpText ? _self.helpText : helpText // ignore: cast_nullable_to_non_nullable
as String?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<Question>,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<Section>,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as String,gridColumns: null == gridColumns ? _self.gridColumns : gridColumns // ignore: cast_nullable_to_non_nullable
as int,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,isRepeatable: null == isRepeatable ? _self.isRepeatable : isRepeatable // ignore: cast_nullable_to_non_nullable
as bool,repeatMin: freezed == repeatMin ? _self.repeatMin : repeatMin // ignore: cast_nullable_to_non_nullable
as int?,repeatMax: freezed == repeatMax ? _self.repeatMax : repeatMax // ignore: cast_nullable_to_non_nullable
as int?,logic: null == logic ? _self.logic : logic // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,ui: null == ui ? _self.ui : ui // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [Section].
extension SectionPatterns on Section {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Section value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Section() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Section value)  $default,){
final _that = this;
switch (_that) {
case _Section():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Section value)?  $default,){
final _that = this;
switch (_that) {
case _Section() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? description, @JsonKey(name: 'help_text')  String? helpText,  int order,  List<Question> questions,  List<Section> sections,  String layout, @JsonKey(name: 'grid_columns')  int gridColumns, @JsonKey(name: 'is_hidden')  bool isHidden, @JsonKey(name: 'is_repeatable')  bool isRepeatable, @JsonKey(name: 'repeat_min')  int? repeatMin, @JsonKey(name: 'repeat_max')  int? repeatMax,  Map<String, dynamic> logic,  Map<String, dynamic> ui,  List<String> tags, @JsonKey(name: 'meta_data')  Map<String, dynamic> metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Section() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.helpText,_that.order,_that.questions,_that.sections,_that.layout,_that.gridColumns,_that.isHidden,_that.isRepeatable,_that.repeatMin,_that.repeatMax,_that.logic,_that.ui,_that.tags,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? description, @JsonKey(name: 'help_text')  String? helpText,  int order,  List<Question> questions,  List<Section> sections,  String layout, @JsonKey(name: 'grid_columns')  int gridColumns, @JsonKey(name: 'is_hidden')  bool isHidden, @JsonKey(name: 'is_repeatable')  bool isRepeatable, @JsonKey(name: 'repeat_min')  int? repeatMin, @JsonKey(name: 'repeat_max')  int? repeatMax,  Map<String, dynamic> logic,  Map<String, dynamic> ui,  List<String> tags, @JsonKey(name: 'meta_data')  Map<String, dynamic> metadata)  $default,) {final _that = this;
switch (_that) {
case _Section():
return $default(_that.id,_that.title,_that.description,_that.helpText,_that.order,_that.questions,_that.sections,_that.layout,_that.gridColumns,_that.isHidden,_that.isRepeatable,_that.repeatMin,_that.repeatMax,_that.logic,_that.ui,_that.tags,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? description, @JsonKey(name: 'help_text')  String? helpText,  int order,  List<Question> questions,  List<Section> sections,  String layout, @JsonKey(name: 'grid_columns')  int gridColumns, @JsonKey(name: 'is_hidden')  bool isHidden, @JsonKey(name: 'is_repeatable')  bool isRepeatable, @JsonKey(name: 'repeat_min')  int? repeatMin, @JsonKey(name: 'repeat_max')  int? repeatMax,  Map<String, dynamic> logic,  Map<String, dynamic> ui,  List<String> tags, @JsonKey(name: 'meta_data')  Map<String, dynamic> metadata)?  $default,) {final _that = this;
switch (_that) {
case _Section() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.helpText,_that.order,_that.questions,_that.sections,_that.layout,_that.gridColumns,_that.isHidden,_that.isRepeatable,_that.repeatMin,_that.repeatMax,_that.logic,_that.ui,_that.tags,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Section extends Section {
  const _Section({required this.id, required this.title, this.description, @JsonKey(name: 'help_text') this.helpText, this.order = 0, final  List<Question> questions = const <Question>[], final  List<Section> sections = const <Section>[], this.layout = 'standard', @JsonKey(name: 'grid_columns') this.gridColumns = 2, @JsonKey(name: 'is_hidden') this.isHidden = false, @JsonKey(name: 'is_repeatable') this.isRepeatable = false, @JsonKey(name: 'repeat_min') this.repeatMin, @JsonKey(name: 'repeat_max') this.repeatMax, final  Map<String, dynamic> logic = const <String, dynamic>{}, final  Map<String, dynamic> ui = const <String, dynamic>{}, final  List<String> tags = const <String>[], @JsonKey(name: 'meta_data') final  Map<String, dynamic> metadata = const <String, dynamic>{}}): _questions = questions,_sections = sections,_logic = logic,_ui = ui,_tags = tags,_metadata = metadata,super._();
  factory _Section.fromJson(Map<String, dynamic> json) => _$SectionFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? description;
@override@JsonKey(name: 'help_text') final  String? helpText;
@override@JsonKey() final  int order;
 final  List<Question> _questions;
@override@JsonKey() List<Question> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}

 final  List<Section> _sections;
@override@JsonKey() List<Section> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}

// Nested sub-sections
@override@JsonKey() final  String layout;
@override@JsonKey(name: 'grid_columns') final  int gridColumns;
@override@JsonKey(name: 'is_hidden') final  bool isHidden;
@override@JsonKey(name: 'is_repeatable') final  bool isRepeatable;
@override@JsonKey(name: 'repeat_min') final  int? repeatMin;
@override@JsonKey(name: 'repeat_max') final  int? repeatMax;
 final  Map<String, dynamic> _logic;
@override@JsonKey() Map<String, dynamic> get logic {
  if (_logic is EqualUnmodifiableMapView) return _logic;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_logic);
}

 final  Map<String, dynamic> _ui;
@override@JsonKey() Map<String, dynamic> get ui {
  if (_ui is EqualUnmodifiableMapView) return _ui;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_ui);
}

 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  Map<String, dynamic> _metadata;
@override@JsonKey(name: 'meta_data') Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}


/// Create a copy of Section
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SectionCopyWith<_Section> get copyWith => __$SectionCopyWithImpl<_Section>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Section&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.helpText, helpText) || other.helpText == helpText)&&(identical(other.order, order) || other.order == order)&&const DeepCollectionEquality().equals(other._questions, _questions)&&const DeepCollectionEquality().equals(other._sections, _sections)&&(identical(other.layout, layout) || other.layout == layout)&&(identical(other.gridColumns, gridColumns) || other.gridColumns == gridColumns)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.isRepeatable, isRepeatable) || other.isRepeatable == isRepeatable)&&(identical(other.repeatMin, repeatMin) || other.repeatMin == repeatMin)&&(identical(other.repeatMax, repeatMax) || other.repeatMax == repeatMax)&&const DeepCollectionEquality().equals(other._logic, _logic)&&const DeepCollectionEquality().equals(other._ui, _ui)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,helpText,order,const DeepCollectionEquality().hash(_questions),const DeepCollectionEquality().hash(_sections),layout,gridColumns,isHidden,isRepeatable,repeatMin,repeatMax,const DeepCollectionEquality().hash(_logic),const DeepCollectionEquality().hash(_ui),const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'Section(id: $id, title: $title, description: $description, helpText: $helpText, order: $order, questions: $questions, sections: $sections, layout: $layout, gridColumns: $gridColumns, isHidden: $isHidden, isRepeatable: $isRepeatable, repeatMin: $repeatMin, repeatMax: $repeatMax, logic: $logic, ui: $ui, tags: $tags, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$SectionCopyWith<$Res> implements $SectionCopyWith<$Res> {
  factory _$SectionCopyWith(_Section value, $Res Function(_Section) _then) = __$SectionCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? description,@JsonKey(name: 'help_text') String? helpText, int order, List<Question> questions, List<Section> sections, String layout,@JsonKey(name: 'grid_columns') int gridColumns,@JsonKey(name: 'is_hidden') bool isHidden,@JsonKey(name: 'is_repeatable') bool isRepeatable,@JsonKey(name: 'repeat_min') int? repeatMin,@JsonKey(name: 'repeat_max') int? repeatMax, Map<String, dynamic> logic, Map<String, dynamic> ui, List<String> tags,@JsonKey(name: 'meta_data') Map<String, dynamic> metadata
});




}
/// @nodoc
class __$SectionCopyWithImpl<$Res>
    implements _$SectionCopyWith<$Res> {
  __$SectionCopyWithImpl(this._self, this._then);

  final _Section _self;
  final $Res Function(_Section) _then;

/// Create a copy of Section
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? helpText = freezed,Object? order = null,Object? questions = null,Object? sections = null,Object? layout = null,Object? gridColumns = null,Object? isHidden = null,Object? isRepeatable = null,Object? repeatMin = freezed,Object? repeatMax = freezed,Object? logic = null,Object? ui = null,Object? tags = null,Object? metadata = null,}) {
  return _then(_Section(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,helpText: freezed == helpText ? _self.helpText : helpText // ignore: cast_nullable_to_non_nullable
as String?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<Question>,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<Section>,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as String,gridColumns: null == gridColumns ? _self.gridColumns : gridColumns // ignore: cast_nullable_to_non_nullable
as int,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,isRepeatable: null == isRepeatable ? _self.isRepeatable : isRepeatable // ignore: cast_nullable_to_non_nullable
as bool,repeatMin: freezed == repeatMin ? _self.repeatMin : repeatMin // ignore: cast_nullable_to_non_nullable
as int?,repeatMax: freezed == repeatMax ? _self.repeatMax : repeatMax // ignore: cast_nullable_to_non_nullable
as int?,logic: null == logic ? _self._logic : logic // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,ui: null == ui ? _self._ui : ui // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}


/// @nodoc
mixin _$FormVersion {

 String get id; String get version; List<Section> get sections; String get status; Map<String, dynamic> get translations;@JsonKey(name: 'created_at') String? get createdAt;
/// Create a copy of FormVersion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormVersionCopyWith<FormVersion> get copyWith => _$FormVersionCopyWithImpl<FormVersion>(this as FormVersion, _$identity);

  /// Serializes this FormVersion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormVersion&&(identical(other.id, id) || other.id == id)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.sections, sections)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.translations, translations)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,version,const DeepCollectionEquality().hash(sections),status,const DeepCollectionEquality().hash(translations),createdAt);

@override
String toString() {
  return 'FormVersion(id: $id, version: $version, sections: $sections, status: $status, translations: $translations, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $FormVersionCopyWith<$Res>  {
  factory $FormVersionCopyWith(FormVersion value, $Res Function(FormVersion) _then) = _$FormVersionCopyWithImpl;
@useResult
$Res call({
 String id, String version, List<Section> sections, String status, Map<String, dynamic> translations,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class _$FormVersionCopyWithImpl<$Res>
    implements $FormVersionCopyWith<$Res> {
  _$FormVersionCopyWithImpl(this._self, this._then);

  final FormVersion _self;
  final $Res Function(FormVersion) _then;

/// Create a copy of FormVersion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? version = null,Object? sections = null,Object? status = null,Object? translations = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<Section>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,translations: null == translations ? _self.translations : translations // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FormVersion].
extension FormVersionPatterns on FormVersion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormVersion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormVersion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormVersion value)  $default,){
final _that = this;
switch (_that) {
case _FormVersion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormVersion value)?  $default,){
final _that = this;
switch (_that) {
case _FormVersion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String version,  List<Section> sections,  String status,  Map<String, dynamic> translations, @JsonKey(name: 'created_at')  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormVersion() when $default != null:
return $default(_that.id,_that.version,_that.sections,_that.status,_that.translations,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String version,  List<Section> sections,  String status,  Map<String, dynamic> translations, @JsonKey(name: 'created_at')  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _FormVersion():
return $default(_that.id,_that.version,_that.sections,_that.status,_that.translations,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String version,  List<Section> sections,  String status,  Map<String, dynamic> translations, @JsonKey(name: 'created_at')  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _FormVersion() when $default != null:
return $default(_that.id,_that.version,_that.sections,_that.status,_that.translations,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormVersion extends FormVersion {
  const _FormVersion({required this.id, required this.version, final  List<Section> sections = const <Section>[], this.status = 'draft', final  Map<String, dynamic> translations = const <String, dynamic>{}, @JsonKey(name: 'created_at') this.createdAt}): _sections = sections,_translations = translations,super._();
  factory _FormVersion.fromJson(Map<String, dynamic> json) => _$FormVersionFromJson(json);

@override final  String id;
@override final  String version;
 final  List<Section> _sections;
@override@JsonKey() List<Section> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}

@override@JsonKey() final  String status;
 final  Map<String, dynamic> _translations;
@override@JsonKey() Map<String, dynamic> get translations {
  if (_translations is EqualUnmodifiableMapView) return _translations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_translations);
}

@override@JsonKey(name: 'created_at') final  String? createdAt;

/// Create a copy of FormVersion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormVersionCopyWith<_FormVersion> get copyWith => __$FormVersionCopyWithImpl<_FormVersion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FormVersionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormVersion&&(identical(other.id, id) || other.id == id)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other._sections, _sections)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._translations, _translations)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,version,const DeepCollectionEquality().hash(_sections),status,const DeepCollectionEquality().hash(_translations),createdAt);

@override
String toString() {
  return 'FormVersion(id: $id, version: $version, sections: $sections, status: $status, translations: $translations, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$FormVersionCopyWith<$Res> implements $FormVersionCopyWith<$Res> {
  factory _$FormVersionCopyWith(_FormVersion value, $Res Function(_FormVersion) _then) = __$FormVersionCopyWithImpl;
@override @useResult
$Res call({
 String id, String version, List<Section> sections, String status, Map<String, dynamic> translations,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class __$FormVersionCopyWithImpl<$Res>
    implements _$FormVersionCopyWith<$Res> {
  __$FormVersionCopyWithImpl(this._self, this._then);

  final _FormVersion _self;
  final $Res Function(_FormVersion) _then;

/// Create a copy of FormVersion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? version = null,Object? sections = null,Object? status = null,Object? translations = null,Object? createdAt = freezed,}) {
  return _then(_FormVersion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<Section>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,translations: null == translations ? _self._translations : translations // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Form {

 String get id; String get title; String get slug;@JsonKey(name: 'organization_id') String get organizationId;@JsonKey(name: 'created_by') String get createdBy; String get status;@JsonKey(name: 'ui_type') String get uiType;@JsonKey(name: 'active_version') String? get activeVersion; List<FormVersion> get versions;// Configurations
 String? get description;@JsonKey(name: 'help_text') String? get helpText;@JsonKey(name: 'expires_at') String? get expiresAt;@JsonKey(name: 'publish_at') String? get publishAt;@JsonKey(name: 'is_template') bool get isTemplate;@JsonKey(name: 'is_public') bool get isPublic;@JsonKey(name: 'supported_languages') List<String> get supportedLanguages;@JsonKey(name: 'default_language') String get defaultLanguage; List<String> get tags;// Integrations & Policies
 Map<String, dynamic> get workflows;@JsonKey(name: 'access_policy') Map<String, dynamic> get accessPolicy; Map<String, dynamic> get style;
/// Create a copy of Form
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormCopyWith<Form> get copyWith => _$FormCopyWithImpl<Form>(this as Form, _$identity);

  /// Serializes this Form to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Form&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.status, status) || other.status == status)&&(identical(other.uiType, uiType) || other.uiType == uiType)&&(identical(other.activeVersion, activeVersion) || other.activeVersion == activeVersion)&&const DeepCollectionEquality().equals(other.versions, versions)&&(identical(other.description, description) || other.description == description)&&(identical(other.helpText, helpText) || other.helpText == helpText)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.publishAt, publishAt) || other.publishAt == publishAt)&&(identical(other.isTemplate, isTemplate) || other.isTemplate == isTemplate)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&const DeepCollectionEquality().equals(other.supportedLanguages, supportedLanguages)&&(identical(other.defaultLanguage, defaultLanguage) || other.defaultLanguage == defaultLanguage)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.workflows, workflows)&&const DeepCollectionEquality().equals(other.accessPolicy, accessPolicy)&&const DeepCollectionEquality().equals(other.style, style));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,slug,organizationId,createdBy,status,uiType,activeVersion,const DeepCollectionEquality().hash(versions),description,helpText,expiresAt,publishAt,isTemplate,isPublic,const DeepCollectionEquality().hash(supportedLanguages),defaultLanguage,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(workflows),const DeepCollectionEquality().hash(accessPolicy),const DeepCollectionEquality().hash(style)]);

@override
String toString() {
  return 'Form(id: $id, title: $title, slug: $slug, organizationId: $organizationId, createdBy: $createdBy, status: $status, uiType: $uiType, activeVersion: $activeVersion, versions: $versions, description: $description, helpText: $helpText, expiresAt: $expiresAt, publishAt: $publishAt, isTemplate: $isTemplate, isPublic: $isPublic, supportedLanguages: $supportedLanguages, defaultLanguage: $defaultLanguage, tags: $tags, workflows: $workflows, accessPolicy: $accessPolicy, style: $style)';
}


}

/// @nodoc
abstract mixin class $FormCopyWith<$Res>  {
  factory $FormCopyWith(Form value, $Res Function(Form) _then) = _$FormCopyWithImpl;
@useResult
$Res call({
 String id, String title, String slug,@JsonKey(name: 'organization_id') String organizationId,@JsonKey(name: 'created_by') String createdBy, String status,@JsonKey(name: 'ui_type') String uiType,@JsonKey(name: 'active_version') String? activeVersion, List<FormVersion> versions, String? description,@JsonKey(name: 'help_text') String? helpText,@JsonKey(name: 'expires_at') String? expiresAt,@JsonKey(name: 'publish_at') String? publishAt,@JsonKey(name: 'is_template') bool isTemplate,@JsonKey(name: 'is_public') bool isPublic,@JsonKey(name: 'supported_languages') List<String> supportedLanguages,@JsonKey(name: 'default_language') String defaultLanguage, List<String> tags, Map<String, dynamic> workflows,@JsonKey(name: 'access_policy') Map<String, dynamic> accessPolicy, Map<String, dynamic> style
});




}
/// @nodoc
class _$FormCopyWithImpl<$Res>
    implements $FormCopyWith<$Res> {
  _$FormCopyWithImpl(this._self, this._then);

  final Form _self;
  final $Res Function(Form) _then;

/// Create a copy of Form
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? slug = null,Object? organizationId = null,Object? createdBy = null,Object? status = null,Object? uiType = null,Object? activeVersion = freezed,Object? versions = null,Object? description = freezed,Object? helpText = freezed,Object? expiresAt = freezed,Object? publishAt = freezed,Object? isTemplate = null,Object? isPublic = null,Object? supportedLanguages = null,Object? defaultLanguage = null,Object? tags = null,Object? workflows = null,Object? accessPolicy = null,Object? style = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,uiType: null == uiType ? _self.uiType : uiType // ignore: cast_nullable_to_non_nullable
as String,activeVersion: freezed == activeVersion ? _self.activeVersion : activeVersion // ignore: cast_nullable_to_non_nullable
as String?,versions: null == versions ? _self.versions : versions // ignore: cast_nullable_to_non_nullable
as List<FormVersion>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,helpText: freezed == helpText ? _self.helpText : helpText // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String?,publishAt: freezed == publishAt ? _self.publishAt : publishAt // ignore: cast_nullable_to_non_nullable
as String?,isTemplate: null == isTemplate ? _self.isTemplate : isTemplate // ignore: cast_nullable_to_non_nullable
as bool,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,supportedLanguages: null == supportedLanguages ? _self.supportedLanguages : supportedLanguages // ignore: cast_nullable_to_non_nullable
as List<String>,defaultLanguage: null == defaultLanguage ? _self.defaultLanguage : defaultLanguage // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,workflows: null == workflows ? _self.workflows : workflows // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,accessPolicy: null == accessPolicy ? _self.accessPolicy : accessPolicy // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [Form].
extension FormPatterns on Form {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Form value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Form() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Form value)  $default,){
final _that = this;
switch (_that) {
case _Form():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Form value)?  $default,){
final _that = this;
switch (_that) {
case _Form() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String slug, @JsonKey(name: 'organization_id')  String organizationId, @JsonKey(name: 'created_by')  String createdBy,  String status, @JsonKey(name: 'ui_type')  String uiType, @JsonKey(name: 'active_version')  String? activeVersion,  List<FormVersion> versions,  String? description, @JsonKey(name: 'help_text')  String? helpText, @JsonKey(name: 'expires_at')  String? expiresAt, @JsonKey(name: 'publish_at')  String? publishAt, @JsonKey(name: 'is_template')  bool isTemplate, @JsonKey(name: 'is_public')  bool isPublic, @JsonKey(name: 'supported_languages')  List<String> supportedLanguages, @JsonKey(name: 'default_language')  String defaultLanguage,  List<String> tags,  Map<String, dynamic> workflows, @JsonKey(name: 'access_policy')  Map<String, dynamic> accessPolicy,  Map<String, dynamic> style)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Form() when $default != null:
return $default(_that.id,_that.title,_that.slug,_that.organizationId,_that.createdBy,_that.status,_that.uiType,_that.activeVersion,_that.versions,_that.description,_that.helpText,_that.expiresAt,_that.publishAt,_that.isTemplate,_that.isPublic,_that.supportedLanguages,_that.defaultLanguage,_that.tags,_that.workflows,_that.accessPolicy,_that.style);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String slug, @JsonKey(name: 'organization_id')  String organizationId, @JsonKey(name: 'created_by')  String createdBy,  String status, @JsonKey(name: 'ui_type')  String uiType, @JsonKey(name: 'active_version')  String? activeVersion,  List<FormVersion> versions,  String? description, @JsonKey(name: 'help_text')  String? helpText, @JsonKey(name: 'expires_at')  String? expiresAt, @JsonKey(name: 'publish_at')  String? publishAt, @JsonKey(name: 'is_template')  bool isTemplate, @JsonKey(name: 'is_public')  bool isPublic, @JsonKey(name: 'supported_languages')  List<String> supportedLanguages, @JsonKey(name: 'default_language')  String defaultLanguage,  List<String> tags,  Map<String, dynamic> workflows, @JsonKey(name: 'access_policy')  Map<String, dynamic> accessPolicy,  Map<String, dynamic> style)  $default,) {final _that = this;
switch (_that) {
case _Form():
return $default(_that.id,_that.title,_that.slug,_that.organizationId,_that.createdBy,_that.status,_that.uiType,_that.activeVersion,_that.versions,_that.description,_that.helpText,_that.expiresAt,_that.publishAt,_that.isTemplate,_that.isPublic,_that.supportedLanguages,_that.defaultLanguage,_that.tags,_that.workflows,_that.accessPolicy,_that.style);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String slug, @JsonKey(name: 'organization_id')  String organizationId, @JsonKey(name: 'created_by')  String createdBy,  String status, @JsonKey(name: 'ui_type')  String uiType, @JsonKey(name: 'active_version')  String? activeVersion,  List<FormVersion> versions,  String? description, @JsonKey(name: 'help_text')  String? helpText, @JsonKey(name: 'expires_at')  String? expiresAt, @JsonKey(name: 'publish_at')  String? publishAt, @JsonKey(name: 'is_template')  bool isTemplate, @JsonKey(name: 'is_public')  bool isPublic, @JsonKey(name: 'supported_languages')  List<String> supportedLanguages, @JsonKey(name: 'default_language')  String defaultLanguage,  List<String> tags,  Map<String, dynamic> workflows, @JsonKey(name: 'access_policy')  Map<String, dynamic> accessPolicy,  Map<String, dynamic> style)?  $default,) {final _that = this;
switch (_that) {
case _Form() when $default != null:
return $default(_that.id,_that.title,_that.slug,_that.organizationId,_that.createdBy,_that.status,_that.uiType,_that.activeVersion,_that.versions,_that.description,_that.helpText,_that.expiresAt,_that.publishAt,_that.isTemplate,_that.isPublic,_that.supportedLanguages,_that.defaultLanguage,_that.tags,_that.workflows,_that.accessPolicy,_that.style);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Form extends Form {
  const _Form({required this.id, required this.title, required this.slug, @JsonKey(name: 'organization_id') required this.organizationId, @JsonKey(name: 'created_by') required this.createdBy, this.status = 'draft', @JsonKey(name: 'ui_type') this.uiType = 'flex', @JsonKey(name: 'active_version') this.activeVersion, final  List<FormVersion> versions = const <FormVersion>[], this.description, @JsonKey(name: 'help_text') this.helpText, @JsonKey(name: 'expires_at') this.expiresAt, @JsonKey(name: 'publish_at') this.publishAt, @JsonKey(name: 'is_template') this.isTemplate = false, @JsonKey(name: 'is_public') this.isPublic = false, @JsonKey(name: 'supported_languages') final  List<String> supportedLanguages = const ['en'], @JsonKey(name: 'default_language') this.defaultLanguage = 'en', final  List<String> tags = const <String>[], final  Map<String, dynamic> workflows = const <String, dynamic>{}, @JsonKey(name: 'access_policy') final  Map<String, dynamic> accessPolicy = const <String, dynamic>{}, final  Map<String, dynamic> style = const <String, dynamic>{}}): _versions = versions,_supportedLanguages = supportedLanguages,_tags = tags,_workflows = workflows,_accessPolicy = accessPolicy,_style = style,super._();
  factory _Form.fromJson(Map<String, dynamic> json) => _$FormFromJson(json);

@override final  String id;
@override final  String title;
@override final  String slug;
@override@JsonKey(name: 'organization_id') final  String organizationId;
@override@JsonKey(name: 'created_by') final  String createdBy;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'ui_type') final  String uiType;
@override@JsonKey(name: 'active_version') final  String? activeVersion;
 final  List<FormVersion> _versions;
@override@JsonKey() List<FormVersion> get versions {
  if (_versions is EqualUnmodifiableListView) return _versions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_versions);
}

// Configurations
@override final  String? description;
@override@JsonKey(name: 'help_text') final  String? helpText;
@override@JsonKey(name: 'expires_at') final  String? expiresAt;
@override@JsonKey(name: 'publish_at') final  String? publishAt;
@override@JsonKey(name: 'is_template') final  bool isTemplate;
@override@JsonKey(name: 'is_public') final  bool isPublic;
 final  List<String> _supportedLanguages;
@override@JsonKey(name: 'supported_languages') List<String> get supportedLanguages {
  if (_supportedLanguages is EqualUnmodifiableListView) return _supportedLanguages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_supportedLanguages);
}

@override@JsonKey(name: 'default_language') final  String defaultLanguage;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

// Integrations & Policies
 final  Map<String, dynamic> _workflows;
// Integrations & Policies
@override@JsonKey() Map<String, dynamic> get workflows {
  if (_workflows is EqualUnmodifiableMapView) return _workflows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_workflows);
}

 final  Map<String, dynamic> _accessPolicy;
@override@JsonKey(name: 'access_policy') Map<String, dynamic> get accessPolicy {
  if (_accessPolicy is EqualUnmodifiableMapView) return _accessPolicy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_accessPolicy);
}

 final  Map<String, dynamic> _style;
@override@JsonKey() Map<String, dynamic> get style {
  if (_style is EqualUnmodifiableMapView) return _style;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_style);
}


/// Create a copy of Form
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormCopyWith<_Form> get copyWith => __$FormCopyWithImpl<_Form>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FormToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Form&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.status, status) || other.status == status)&&(identical(other.uiType, uiType) || other.uiType == uiType)&&(identical(other.activeVersion, activeVersion) || other.activeVersion == activeVersion)&&const DeepCollectionEquality().equals(other._versions, _versions)&&(identical(other.description, description) || other.description == description)&&(identical(other.helpText, helpText) || other.helpText == helpText)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.publishAt, publishAt) || other.publishAt == publishAt)&&(identical(other.isTemplate, isTemplate) || other.isTemplate == isTemplate)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&const DeepCollectionEquality().equals(other._supportedLanguages, _supportedLanguages)&&(identical(other.defaultLanguage, defaultLanguage) || other.defaultLanguage == defaultLanguage)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._workflows, _workflows)&&const DeepCollectionEquality().equals(other._accessPolicy, _accessPolicy)&&const DeepCollectionEquality().equals(other._style, _style));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,slug,organizationId,createdBy,status,uiType,activeVersion,const DeepCollectionEquality().hash(_versions),description,helpText,expiresAt,publishAt,isTemplate,isPublic,const DeepCollectionEquality().hash(_supportedLanguages),defaultLanguage,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_workflows),const DeepCollectionEquality().hash(_accessPolicy),const DeepCollectionEquality().hash(_style)]);

@override
String toString() {
  return 'Form(id: $id, title: $title, slug: $slug, organizationId: $organizationId, createdBy: $createdBy, status: $status, uiType: $uiType, activeVersion: $activeVersion, versions: $versions, description: $description, helpText: $helpText, expiresAt: $expiresAt, publishAt: $publishAt, isTemplate: $isTemplate, isPublic: $isPublic, supportedLanguages: $supportedLanguages, defaultLanguage: $defaultLanguage, tags: $tags, workflows: $workflows, accessPolicy: $accessPolicy, style: $style)';
}


}

/// @nodoc
abstract mixin class _$FormCopyWith<$Res> implements $FormCopyWith<$Res> {
  factory _$FormCopyWith(_Form value, $Res Function(_Form) _then) = __$FormCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String slug,@JsonKey(name: 'organization_id') String organizationId,@JsonKey(name: 'created_by') String createdBy, String status,@JsonKey(name: 'ui_type') String uiType,@JsonKey(name: 'active_version') String? activeVersion, List<FormVersion> versions, String? description,@JsonKey(name: 'help_text') String? helpText,@JsonKey(name: 'expires_at') String? expiresAt,@JsonKey(name: 'publish_at') String? publishAt,@JsonKey(name: 'is_template') bool isTemplate,@JsonKey(name: 'is_public') bool isPublic,@JsonKey(name: 'supported_languages') List<String> supportedLanguages,@JsonKey(name: 'default_language') String defaultLanguage, List<String> tags, Map<String, dynamic> workflows,@JsonKey(name: 'access_policy') Map<String, dynamic> accessPolicy, Map<String, dynamic> style
});




}
/// @nodoc
class __$FormCopyWithImpl<$Res>
    implements _$FormCopyWith<$Res> {
  __$FormCopyWithImpl(this._self, this._then);

  final _Form _self;
  final $Res Function(_Form) _then;

/// Create a copy of Form
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? slug = null,Object? organizationId = null,Object? createdBy = null,Object? status = null,Object? uiType = null,Object? activeVersion = freezed,Object? versions = null,Object? description = freezed,Object? helpText = freezed,Object? expiresAt = freezed,Object? publishAt = freezed,Object? isTemplate = null,Object? isPublic = null,Object? supportedLanguages = null,Object? defaultLanguage = null,Object? tags = null,Object? workflows = null,Object? accessPolicy = null,Object? style = null,}) {
  return _then(_Form(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,uiType: null == uiType ? _self.uiType : uiType // ignore: cast_nullable_to_non_nullable
as String,activeVersion: freezed == activeVersion ? _self.activeVersion : activeVersion // ignore: cast_nullable_to_non_nullable
as String?,versions: null == versions ? _self._versions : versions // ignore: cast_nullable_to_non_nullable
as List<FormVersion>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,helpText: freezed == helpText ? _self.helpText : helpText // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String?,publishAt: freezed == publishAt ? _self.publishAt : publishAt // ignore: cast_nullable_to_non_nullable
as String?,isTemplate: null == isTemplate ? _self.isTemplate : isTemplate // ignore: cast_nullable_to_non_nullable
as bool,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,supportedLanguages: null == supportedLanguages ? _self._supportedLanguages : supportedLanguages // ignore: cast_nullable_to_non_nullable
as List<String>,defaultLanguage: null == defaultLanguage ? _self.defaultLanguage : defaultLanguage // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,workflows: null == workflows ? _self._workflows : workflows // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,accessPolicy: null == accessPolicy ? _self._accessPolicy : accessPolicy // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,style: null == style ? _self._style : style // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on

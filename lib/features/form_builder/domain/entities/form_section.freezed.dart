// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form_section.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FormSection {

@JsonKey(readValue: IdReader.readIdCallback) String get id; Object? get title; Object? get description;@JsonKey(name: 'help_text') Object? get helpText; int get order; List<FormQuestion> get questions;@JsonKey(name: 'layout', fromJson: _sectionLayoutTypeFromJson) SectionLayoutType get layout;@JsonKey(name: 'grid_columns') int get gridColumns;@JsonKey(name: 'is_hidden') bool get isHidden;@JsonKey(name: 'is_repeatable') bool get isRepeatable;@JsonKey(name: 'repeat_min') int? get repeatMin;@JsonKey(name: 'repeat_max') int? get repeatMax;@JsonKey(name: 'conditional_logic') Map<String, dynamic>? get conditionalLogic; Map<String, dynamic>? get logic;@JsonKey(name: 'sections') List<FormSection> get sections;@JsonKey(name: 'response_templates') List<Map<String, dynamic>> get responseTemplates; List<String> get tags; SectionStyle get style;@JsonKey(name: 'meta_data') Map<String, dynamic> get metaData;
/// Create a copy of FormSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormSectionCopyWith<FormSection> get copyWith => _$FormSectionCopyWithImpl<FormSection>(this as FormSection, _$identity);

  /// Serializes this FormSection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormSection&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.title, title)&&const DeepCollectionEquality().equals(other.description, description)&&const DeepCollectionEquality().equals(other.helpText, helpText)&&(identical(other.order, order) || other.order == order)&&const DeepCollectionEquality().equals(other.questions, questions)&&(identical(other.layout, layout) || other.layout == layout)&&(identical(other.gridColumns, gridColumns) || other.gridColumns == gridColumns)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.isRepeatable, isRepeatable) || other.isRepeatable == isRepeatable)&&(identical(other.repeatMin, repeatMin) || other.repeatMin == repeatMin)&&(identical(other.repeatMax, repeatMax) || other.repeatMax == repeatMax)&&const DeepCollectionEquality().equals(other.conditionalLogic, conditionalLogic)&&const DeepCollectionEquality().equals(other.logic, logic)&&const DeepCollectionEquality().equals(other.sections, sections)&&const DeepCollectionEquality().equals(other.responseTemplates, responseTemplates)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.style, style) || other.style == style)&&const DeepCollectionEquality().equals(other.metaData, metaData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,const DeepCollectionEquality().hash(title),const DeepCollectionEquality().hash(description),const DeepCollectionEquality().hash(helpText),order,const DeepCollectionEquality().hash(questions),layout,gridColumns,isHidden,isRepeatable,repeatMin,repeatMax,const DeepCollectionEquality().hash(conditionalLogic),const DeepCollectionEquality().hash(logic),const DeepCollectionEquality().hash(sections),const DeepCollectionEquality().hash(responseTemplates),const DeepCollectionEquality().hash(tags),style,const DeepCollectionEquality().hash(metaData)]);

@override
String toString() {
  return 'FormSection(id: $id, title: $title, description: $description, helpText: $helpText, order: $order, questions: $questions, layout: $layout, gridColumns: $gridColumns, isHidden: $isHidden, isRepeatable: $isRepeatable, repeatMin: $repeatMin, repeatMax: $repeatMax, conditionalLogic: $conditionalLogic, logic: $logic, sections: $sections, responseTemplates: $responseTemplates, tags: $tags, style: $style, metaData: $metaData)';
}


}

/// @nodoc
abstract mixin class $FormSectionCopyWith<$Res>  {
  factory $FormSectionCopyWith(FormSection value, $Res Function(FormSection) _then) = _$FormSectionCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: IdReader.readIdCallback) String id, Object? title, Object? description,@JsonKey(name: 'help_text') Object? helpText, int order, List<FormQuestion> questions,@JsonKey(name: 'layout', fromJson: _sectionLayoutTypeFromJson) SectionLayoutType layout,@JsonKey(name: 'grid_columns') int gridColumns,@JsonKey(name: 'is_hidden') bool isHidden,@JsonKey(name: 'is_repeatable') bool isRepeatable,@JsonKey(name: 'repeat_min') int? repeatMin,@JsonKey(name: 'repeat_max') int? repeatMax,@JsonKey(name: 'conditional_logic') Map<String, dynamic>? conditionalLogic, Map<String, dynamic>? logic,@JsonKey(name: 'sections') List<FormSection> sections,@JsonKey(name: 'response_templates') List<Map<String, dynamic>> responseTemplates, List<String> tags, SectionStyle style,@JsonKey(name: 'meta_data') Map<String, dynamic> metaData
});


$SectionStyleCopyWith<$Res> get style;

}
/// @nodoc
class _$FormSectionCopyWithImpl<$Res>
    implements $FormSectionCopyWith<$Res> {
  _$FormSectionCopyWithImpl(this._self, this._then);

  final FormSection _self;
  final $Res Function(FormSection) _then;

/// Create a copy of FormSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = freezed,Object? description = freezed,Object? helpText = freezed,Object? order = null,Object? questions = null,Object? layout = null,Object? gridColumns = null,Object? isHidden = null,Object? isRepeatable = null,Object? repeatMin = freezed,Object? repeatMax = freezed,Object? conditionalLogic = freezed,Object? logic = freezed,Object? sections = null,Object? responseTemplates = null,Object? tags = null,Object? style = null,Object? metaData = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title ,description: freezed == description ? _self.description : description ,helpText: freezed == helpText ? _self.helpText : helpText ,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<FormQuestion>,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as SectionLayoutType,gridColumns: null == gridColumns ? _self.gridColumns : gridColumns // ignore: cast_nullable_to_non_nullable
as int,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,isRepeatable: null == isRepeatable ? _self.isRepeatable : isRepeatable // ignore: cast_nullable_to_non_nullable
as bool,repeatMin: freezed == repeatMin ? _self.repeatMin : repeatMin // ignore: cast_nullable_to_non_nullable
as int?,repeatMax: freezed == repeatMax ? _self.repeatMax : repeatMax // ignore: cast_nullable_to_non_nullable
as int?,conditionalLogic: freezed == conditionalLogic ? _self.conditionalLogic : conditionalLogic // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,logic: freezed == logic ? _self.logic : logic // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<FormSection>,responseTemplates: null == responseTemplates ? _self.responseTemplates : responseTemplates // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as SectionStyle,metaData: null == metaData ? _self.metaData : metaData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}
/// Create a copy of FormSection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SectionStyleCopyWith<$Res> get style {
  
  return $SectionStyleCopyWith<$Res>(_self.style, (value) {
    return _then(_self.copyWith(style: value));
  });
}
}


/// Adds pattern-matching-related methods to [FormSection].
extension FormSectionPatterns on FormSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormSection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormSection value)  $default,){
final _that = this;
switch (_that) {
case _FormSection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormSection value)?  $default,){
final _that = this;
switch (_that) {
case _FormSection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: IdReader.readIdCallback)  String id,  Object? title,  Object? description, @JsonKey(name: 'help_text')  Object? helpText,  int order,  List<FormQuestion> questions, @JsonKey(name: 'layout', fromJson: _sectionLayoutTypeFromJson)  SectionLayoutType layout, @JsonKey(name: 'grid_columns')  int gridColumns, @JsonKey(name: 'is_hidden')  bool isHidden, @JsonKey(name: 'is_repeatable')  bool isRepeatable, @JsonKey(name: 'repeat_min')  int? repeatMin, @JsonKey(name: 'repeat_max')  int? repeatMax, @JsonKey(name: 'conditional_logic')  Map<String, dynamic>? conditionalLogic,  Map<String, dynamic>? logic, @JsonKey(name: 'sections')  List<FormSection> sections, @JsonKey(name: 'response_templates')  List<Map<String, dynamic>> responseTemplates,  List<String> tags,  SectionStyle style, @JsonKey(name: 'meta_data')  Map<String, dynamic> metaData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormSection() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.helpText,_that.order,_that.questions,_that.layout,_that.gridColumns,_that.isHidden,_that.isRepeatable,_that.repeatMin,_that.repeatMax,_that.conditionalLogic,_that.logic,_that.sections,_that.responseTemplates,_that.tags,_that.style,_that.metaData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: IdReader.readIdCallback)  String id,  Object? title,  Object? description, @JsonKey(name: 'help_text')  Object? helpText,  int order,  List<FormQuestion> questions, @JsonKey(name: 'layout', fromJson: _sectionLayoutTypeFromJson)  SectionLayoutType layout, @JsonKey(name: 'grid_columns')  int gridColumns, @JsonKey(name: 'is_hidden')  bool isHidden, @JsonKey(name: 'is_repeatable')  bool isRepeatable, @JsonKey(name: 'repeat_min')  int? repeatMin, @JsonKey(name: 'repeat_max')  int? repeatMax, @JsonKey(name: 'conditional_logic')  Map<String, dynamic>? conditionalLogic,  Map<String, dynamic>? logic, @JsonKey(name: 'sections')  List<FormSection> sections, @JsonKey(name: 'response_templates')  List<Map<String, dynamic>> responseTemplates,  List<String> tags,  SectionStyle style, @JsonKey(name: 'meta_data')  Map<String, dynamic> metaData)  $default,) {final _that = this;
switch (_that) {
case _FormSection():
return $default(_that.id,_that.title,_that.description,_that.helpText,_that.order,_that.questions,_that.layout,_that.gridColumns,_that.isHidden,_that.isRepeatable,_that.repeatMin,_that.repeatMax,_that.conditionalLogic,_that.logic,_that.sections,_that.responseTemplates,_that.tags,_that.style,_that.metaData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: IdReader.readIdCallback)  String id,  Object? title,  Object? description, @JsonKey(name: 'help_text')  Object? helpText,  int order,  List<FormQuestion> questions, @JsonKey(name: 'layout', fromJson: _sectionLayoutTypeFromJson)  SectionLayoutType layout, @JsonKey(name: 'grid_columns')  int gridColumns, @JsonKey(name: 'is_hidden')  bool isHidden, @JsonKey(name: 'is_repeatable')  bool isRepeatable, @JsonKey(name: 'repeat_min')  int? repeatMin, @JsonKey(name: 'repeat_max')  int? repeatMax, @JsonKey(name: 'conditional_logic')  Map<String, dynamic>? conditionalLogic,  Map<String, dynamic>? logic, @JsonKey(name: 'sections')  List<FormSection> sections, @JsonKey(name: 'response_templates')  List<Map<String, dynamic>> responseTemplates,  List<String> tags,  SectionStyle style, @JsonKey(name: 'meta_data')  Map<String, dynamic> metaData)?  $default,) {final _that = this;
switch (_that) {
case _FormSection() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.helpText,_that.order,_that.questions,_that.layout,_that.gridColumns,_that.isHidden,_that.isRepeatable,_that.repeatMin,_that.repeatMax,_that.conditionalLogic,_that.logic,_that.sections,_that.responseTemplates,_that.tags,_that.style,_that.metaData);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormSection extends FormSection {
  const _FormSection({@JsonKey(readValue: IdReader.readIdCallback) required this.id, required this.title, this.description, @JsonKey(name: 'help_text') this.helpText, this.order = 0, required final  List<FormQuestion> questions, @JsonKey(name: 'layout', fromJson: _sectionLayoutTypeFromJson) this.layout = SectionLayoutType.standard, @JsonKey(name: 'grid_columns') this.gridColumns = 2, @JsonKey(name: 'is_hidden') this.isHidden = false, @JsonKey(name: 'is_repeatable') this.isRepeatable = false, @JsonKey(name: 'repeat_min') this.repeatMin, @JsonKey(name: 'repeat_max') this.repeatMax, @JsonKey(name: 'conditional_logic') final  Map<String, dynamic>? conditionalLogic, final  Map<String, dynamic>? logic, @JsonKey(name: 'sections') final  List<FormSection> sections = const <FormSection>[], @JsonKey(name: 'response_templates') final  List<Map<String, dynamic>> responseTemplates = const <Map<String, dynamic>>[], final  List<String> tags = const <String>[], this.style = const SectionStyle(), @JsonKey(name: 'meta_data') final  Map<String, dynamic> metaData = const {}}): _questions = questions,_conditionalLogic = conditionalLogic,_logic = logic,_sections = sections,_responseTemplates = responseTemplates,_tags = tags,_metaData = metaData,super._();
  factory _FormSection.fromJson(Map<String, dynamic> json) => _$FormSectionFromJson(json);

@override@JsonKey(readValue: IdReader.readIdCallback) final  String id;
@override final  Object? title;
@override final  Object? description;
@override@JsonKey(name: 'help_text') final  Object? helpText;
@override@JsonKey() final  int order;
 final  List<FormQuestion> _questions;
@override List<FormQuestion> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}

@override@JsonKey(name: 'layout', fromJson: _sectionLayoutTypeFromJson) final  SectionLayoutType layout;
@override@JsonKey(name: 'grid_columns') final  int gridColumns;
@override@JsonKey(name: 'is_hidden') final  bool isHidden;
@override@JsonKey(name: 'is_repeatable') final  bool isRepeatable;
@override@JsonKey(name: 'repeat_min') final  int? repeatMin;
@override@JsonKey(name: 'repeat_max') final  int? repeatMax;
 final  Map<String, dynamic>? _conditionalLogic;
@override@JsonKey(name: 'conditional_logic') Map<String, dynamic>? get conditionalLogic {
  final value = _conditionalLogic;
  if (value == null) return null;
  if (_conditionalLogic is EqualUnmodifiableMapView) return _conditionalLogic;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _logic;
@override Map<String, dynamic>? get logic {
  final value = _logic;
  if (value == null) return null;
  if (_logic is EqualUnmodifiableMapView) return _logic;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  List<FormSection> _sections;
@override@JsonKey(name: 'sections') List<FormSection> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}

 final  List<Map<String, dynamic>> _responseTemplates;
@override@JsonKey(name: 'response_templates') List<Map<String, dynamic>> get responseTemplates {
  if (_responseTemplates is EqualUnmodifiableListView) return _responseTemplates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_responseTemplates);
}

 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@JsonKey() final  SectionStyle style;
 final  Map<String, dynamic> _metaData;
@override@JsonKey(name: 'meta_data') Map<String, dynamic> get metaData {
  if (_metaData is EqualUnmodifiableMapView) return _metaData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metaData);
}


/// Create a copy of FormSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormSectionCopyWith<_FormSection> get copyWith => __$FormSectionCopyWithImpl<_FormSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FormSectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormSection&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.title, title)&&const DeepCollectionEquality().equals(other.description, description)&&const DeepCollectionEquality().equals(other.helpText, helpText)&&(identical(other.order, order) || other.order == order)&&const DeepCollectionEquality().equals(other._questions, _questions)&&(identical(other.layout, layout) || other.layout == layout)&&(identical(other.gridColumns, gridColumns) || other.gridColumns == gridColumns)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.isRepeatable, isRepeatable) || other.isRepeatable == isRepeatable)&&(identical(other.repeatMin, repeatMin) || other.repeatMin == repeatMin)&&(identical(other.repeatMax, repeatMax) || other.repeatMax == repeatMax)&&const DeepCollectionEquality().equals(other._conditionalLogic, _conditionalLogic)&&const DeepCollectionEquality().equals(other._logic, _logic)&&const DeepCollectionEquality().equals(other._sections, _sections)&&const DeepCollectionEquality().equals(other._responseTemplates, _responseTemplates)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.style, style) || other.style == style)&&const DeepCollectionEquality().equals(other._metaData, _metaData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,const DeepCollectionEquality().hash(title),const DeepCollectionEquality().hash(description),const DeepCollectionEquality().hash(helpText),order,const DeepCollectionEquality().hash(_questions),layout,gridColumns,isHidden,isRepeatable,repeatMin,repeatMax,const DeepCollectionEquality().hash(_conditionalLogic),const DeepCollectionEquality().hash(_logic),const DeepCollectionEquality().hash(_sections),const DeepCollectionEquality().hash(_responseTemplates),const DeepCollectionEquality().hash(_tags),style,const DeepCollectionEquality().hash(_metaData)]);

@override
String toString() {
  return 'FormSection(id: $id, title: $title, description: $description, helpText: $helpText, order: $order, questions: $questions, layout: $layout, gridColumns: $gridColumns, isHidden: $isHidden, isRepeatable: $isRepeatable, repeatMin: $repeatMin, repeatMax: $repeatMax, conditionalLogic: $conditionalLogic, logic: $logic, sections: $sections, responseTemplates: $responseTemplates, tags: $tags, style: $style, metaData: $metaData)';
}


}

/// @nodoc
abstract mixin class _$FormSectionCopyWith<$Res> implements $FormSectionCopyWith<$Res> {
  factory _$FormSectionCopyWith(_FormSection value, $Res Function(_FormSection) _then) = __$FormSectionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: IdReader.readIdCallback) String id, Object? title, Object? description,@JsonKey(name: 'help_text') Object? helpText, int order, List<FormQuestion> questions,@JsonKey(name: 'layout', fromJson: _sectionLayoutTypeFromJson) SectionLayoutType layout,@JsonKey(name: 'grid_columns') int gridColumns,@JsonKey(name: 'is_hidden') bool isHidden,@JsonKey(name: 'is_repeatable') bool isRepeatable,@JsonKey(name: 'repeat_min') int? repeatMin,@JsonKey(name: 'repeat_max') int? repeatMax,@JsonKey(name: 'conditional_logic') Map<String, dynamic>? conditionalLogic, Map<String, dynamic>? logic,@JsonKey(name: 'sections') List<FormSection> sections,@JsonKey(name: 'response_templates') List<Map<String, dynamic>> responseTemplates, List<String> tags, SectionStyle style,@JsonKey(name: 'meta_data') Map<String, dynamic> metaData
});


@override $SectionStyleCopyWith<$Res> get style;

}
/// @nodoc
class __$FormSectionCopyWithImpl<$Res>
    implements _$FormSectionCopyWith<$Res> {
  __$FormSectionCopyWithImpl(this._self, this._then);

  final _FormSection _self;
  final $Res Function(_FormSection) _then;

/// Create a copy of FormSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = freezed,Object? description = freezed,Object? helpText = freezed,Object? order = null,Object? questions = null,Object? layout = null,Object? gridColumns = null,Object? isHidden = null,Object? isRepeatable = null,Object? repeatMin = freezed,Object? repeatMax = freezed,Object? conditionalLogic = freezed,Object? logic = freezed,Object? sections = null,Object? responseTemplates = null,Object? tags = null,Object? style = null,Object? metaData = null,}) {
  return _then(_FormSection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title ,description: freezed == description ? _self.description : description ,helpText: freezed == helpText ? _self.helpText : helpText ,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<FormQuestion>,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as SectionLayoutType,gridColumns: null == gridColumns ? _self.gridColumns : gridColumns // ignore: cast_nullable_to_non_nullable
as int,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,isRepeatable: null == isRepeatable ? _self.isRepeatable : isRepeatable // ignore: cast_nullable_to_non_nullable
as bool,repeatMin: freezed == repeatMin ? _self.repeatMin : repeatMin // ignore: cast_nullable_to_non_nullable
as int?,repeatMax: freezed == repeatMax ? _self.repeatMax : repeatMax // ignore: cast_nullable_to_non_nullable
as int?,conditionalLogic: freezed == conditionalLogic ? _self._conditionalLogic : conditionalLogic // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,logic: freezed == logic ? _self._logic : logic // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<FormSection>,responseTemplates: null == responseTemplates ? _self._responseTemplates : responseTemplates // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as SectionStyle,metaData: null == metaData ? _self._metaData : metaData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

/// Create a copy of FormSection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SectionStyleCopyWith<$Res> get style {
  
  return $SectionStyleCopyWith<$Res>(_self.style, (value) {
    return _then(_self.copyWith(style: value));
  });
}
}

// dart format on

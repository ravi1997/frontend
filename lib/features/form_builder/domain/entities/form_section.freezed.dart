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

@JsonKey(readValue: _readId) String get id; Object? get title; Object? get description; List<FormQuestion> get questions; SectionLayoutType get layout; int get gridColumns; bool get isHidden; Map<String, dynamic>? get conditionalLogic; SectionStyle get style; Map<String, dynamic> get metadata;
/// Create a copy of FormSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormSectionCopyWith<FormSection> get copyWith => _$FormSectionCopyWithImpl<FormSection>(this as FormSection, _$identity);

  /// Serializes this FormSection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormSection&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.title, title)&&const DeepCollectionEquality().equals(other.description, description)&&const DeepCollectionEquality().equals(other.questions, questions)&&(identical(other.layout, layout) || other.layout == layout)&&(identical(other.gridColumns, gridColumns) || other.gridColumns == gridColumns)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&const DeepCollectionEquality().equals(other.conditionalLogic, conditionalLogic)&&(identical(other.style, style) || other.style == style)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(title),const DeepCollectionEquality().hash(description),const DeepCollectionEquality().hash(questions),layout,gridColumns,isHidden,const DeepCollectionEquality().hash(conditionalLogic),style,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'FormSection(id: $id, title: $title, description: $description, questions: $questions, layout: $layout, gridColumns: $gridColumns, isHidden: $isHidden, conditionalLogic: $conditionalLogic, style: $style, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $FormSectionCopyWith<$Res>  {
  factory $FormSectionCopyWith(FormSection value, $Res Function(FormSection) _then) = _$FormSectionCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: _readId) String id, Object? title, Object? description, List<FormQuestion> questions, SectionLayoutType layout, int gridColumns, bool isHidden, Map<String, dynamic>? conditionalLogic, SectionStyle style, Map<String, dynamic> metadata
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = freezed,Object? description = freezed,Object? questions = null,Object? layout = null,Object? gridColumns = null,Object? isHidden = null,Object? conditionalLogic = freezed,Object? style = null,Object? metadata = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title ,description: freezed == description ? _self.description : description ,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<FormQuestion>,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as SectionLayoutType,gridColumns: null == gridColumns ? _self.gridColumns : gridColumns // ignore: cast_nullable_to_non_nullable
as int,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,conditionalLogic: freezed == conditionalLogic ? _self.conditionalLogic : conditionalLogic // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as SectionStyle,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: _readId)  String id,  Object? title,  Object? description,  List<FormQuestion> questions,  SectionLayoutType layout,  int gridColumns,  bool isHidden,  Map<String, dynamic>? conditionalLogic,  SectionStyle style,  Map<String, dynamic> metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormSection() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.questions,_that.layout,_that.gridColumns,_that.isHidden,_that.conditionalLogic,_that.style,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: _readId)  String id,  Object? title,  Object? description,  List<FormQuestion> questions,  SectionLayoutType layout,  int gridColumns,  bool isHidden,  Map<String, dynamic>? conditionalLogic,  SectionStyle style,  Map<String, dynamic> metadata)  $default,) {final _that = this;
switch (_that) {
case _FormSection():
return $default(_that.id,_that.title,_that.description,_that.questions,_that.layout,_that.gridColumns,_that.isHidden,_that.conditionalLogic,_that.style,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: _readId)  String id,  Object? title,  Object? description,  List<FormQuestion> questions,  SectionLayoutType layout,  int gridColumns,  bool isHidden,  Map<String, dynamic>? conditionalLogic,  SectionStyle style,  Map<String, dynamic> metadata)?  $default,) {final _that = this;
switch (_that) {
case _FormSection() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.questions,_that.layout,_that.gridColumns,_that.isHidden,_that.conditionalLogic,_that.style,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormSection extends FormSection {
  const _FormSection({@JsonKey(readValue: _readId) required this.id, required this.title, this.description, required final  List<FormQuestion> questions, this.layout = SectionLayoutType.standard, this.gridColumns = 2, this.isHidden = false, final  Map<String, dynamic>? conditionalLogic, this.style = const SectionStyle(), final  Map<String, dynamic> metadata = const {}}): _questions = questions,_conditionalLogic = conditionalLogic,_metadata = metadata,super._();
  factory _FormSection.fromJson(Map<String, dynamic> json) => _$FormSectionFromJson(json);

@override@JsonKey(readValue: _readId) final  String id;
@override final  Object? title;
@override final  Object? description;
 final  List<FormQuestion> _questions;
@override List<FormQuestion> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}

@override@JsonKey() final  SectionLayoutType layout;
@override@JsonKey() final  int gridColumns;
@override@JsonKey() final  bool isHidden;
 final  Map<String, dynamic>? _conditionalLogic;
@override Map<String, dynamic>? get conditionalLogic {
  final value = _conditionalLogic;
  if (value == null) return null;
  if (_conditionalLogic is EqualUnmodifiableMapView) return _conditionalLogic;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey() final  SectionStyle style;
 final  Map<String, dynamic> _metadata;
@override@JsonKey() Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormSection&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.title, title)&&const DeepCollectionEquality().equals(other.description, description)&&const DeepCollectionEquality().equals(other._questions, _questions)&&(identical(other.layout, layout) || other.layout == layout)&&(identical(other.gridColumns, gridColumns) || other.gridColumns == gridColumns)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&const DeepCollectionEquality().equals(other._conditionalLogic, _conditionalLogic)&&(identical(other.style, style) || other.style == style)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(title),const DeepCollectionEquality().hash(description),const DeepCollectionEquality().hash(_questions),layout,gridColumns,isHidden,const DeepCollectionEquality().hash(_conditionalLogic),style,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'FormSection(id: $id, title: $title, description: $description, questions: $questions, layout: $layout, gridColumns: $gridColumns, isHidden: $isHidden, conditionalLogic: $conditionalLogic, style: $style, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$FormSectionCopyWith<$Res> implements $FormSectionCopyWith<$Res> {
  factory _$FormSectionCopyWith(_FormSection value, $Res Function(_FormSection) _then) = __$FormSectionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: _readId) String id, Object? title, Object? description, List<FormQuestion> questions, SectionLayoutType layout, int gridColumns, bool isHidden, Map<String, dynamic>? conditionalLogic, SectionStyle style, Map<String, dynamic> metadata
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = freezed,Object? description = freezed,Object? questions = null,Object? layout = null,Object? gridColumns = null,Object? isHidden = null,Object? conditionalLogic = freezed,Object? style = null,Object? metadata = null,}) {
  return _then(_FormSection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title ,description: freezed == description ? _self.description : description ,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<FormQuestion>,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as SectionLayoutType,gridColumns: null == gridColumns ? _self.gridColumns : gridColumns // ignore: cast_nullable_to_non_nullable
as int,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,conditionalLogic: freezed == conditionalLogic ? _self._conditionalLogic : conditionalLogic // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as SectionStyle,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
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

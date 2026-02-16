// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'builder_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BuilderForm {

 String get id; Object? get title; String get status; bool get isPublished; String get version; bool get isLatest; List<FormSection> get sections; FormLayoutType get layout;// ignore: invalid_annotation_target
@JsonKey(fromJson: _parseDateTime) DateTime? get updatedAt; FormStyle get style; List<FormVersionHistory> get versionHistory; Map<String, dynamic> get workflows;
/// Create a copy of BuilderForm
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BuilderFormCopyWith<BuilderForm> get copyWith => _$BuilderFormCopyWithImpl<BuilderForm>(this as BuilderForm, _$identity);

  /// Serializes this BuilderForm to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BuilderForm&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.title, title)&&(identical(other.status, status) || other.status == status)&&(identical(other.isPublished, isPublished) || other.isPublished == isPublished)&&(identical(other.version, version) || other.version == version)&&(identical(other.isLatest, isLatest) || other.isLatest == isLatest)&&const DeepCollectionEquality().equals(other.sections, sections)&&(identical(other.layout, layout) || other.layout == layout)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.style, style) || other.style == style)&&const DeepCollectionEquality().equals(other.versionHistory, versionHistory)&&const DeepCollectionEquality().equals(other.workflows, workflows));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(title),status,isPublished,version,isLatest,const DeepCollectionEquality().hash(sections),layout,updatedAt,style,const DeepCollectionEquality().hash(versionHistory),const DeepCollectionEquality().hash(workflows));

@override
String toString() {
  return 'BuilderForm(id: $id, title: $title, status: $status, isPublished: $isPublished, version: $version, isLatest: $isLatest, sections: $sections, layout: $layout, updatedAt: $updatedAt, style: $style, versionHistory: $versionHistory, workflows: $workflows)';
}


}

/// @nodoc
abstract mixin class $BuilderFormCopyWith<$Res>  {
  factory $BuilderFormCopyWith(BuilderForm value, $Res Function(BuilderForm) _then) = _$BuilderFormCopyWithImpl;
@useResult
$Res call({
 String id, Object? title, String status, bool isPublished, String version, bool isLatest, List<FormSection> sections, FormLayoutType layout,@JsonKey(fromJson: _parseDateTime) DateTime? updatedAt, FormStyle style, List<FormVersionHistory> versionHistory, Map<String, dynamic> workflows
});


$FormStyleCopyWith<$Res> get style;

}
/// @nodoc
class _$BuilderFormCopyWithImpl<$Res>
    implements $BuilderFormCopyWith<$Res> {
  _$BuilderFormCopyWithImpl(this._self, this._then);

  final BuilderForm _self;
  final $Res Function(BuilderForm) _then;

/// Create a copy of BuilderForm
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = freezed,Object? status = null,Object? isPublished = null,Object? version = null,Object? isLatest = null,Object? sections = null,Object? layout = null,Object? updatedAt = freezed,Object? style = null,Object? versionHistory = null,Object? workflows = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title ,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isPublished: null == isPublished ? _self.isPublished : isPublished // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,isLatest: null == isLatest ? _self.isLatest : isLatest // ignore: cast_nullable_to_non_nullable
as bool,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<FormSection>,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as FormLayoutType,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as FormStyle,versionHistory: null == versionHistory ? _self.versionHistory : versionHistory // ignore: cast_nullable_to_non_nullable
as List<FormVersionHistory>,workflows: null == workflows ? _self.workflows : workflows // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}
/// Create a copy of BuilderForm
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FormStyleCopyWith<$Res> get style {
  
  return $FormStyleCopyWith<$Res>(_self.style, (value) {
    return _then(_self.copyWith(style: value));
  });
}
}


/// Adds pattern-matching-related methods to [BuilderForm].
extension BuilderFormPatterns on BuilderForm {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BuilderForm value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BuilderForm() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BuilderForm value)  $default,){
final _that = this;
switch (_that) {
case _BuilderForm():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BuilderForm value)?  $default,){
final _that = this;
switch (_that) {
case _BuilderForm() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Object? title,  String status,  bool isPublished,  String version,  bool isLatest,  List<FormSection> sections,  FormLayoutType layout, @JsonKey(fromJson: _parseDateTime)  DateTime? updatedAt,  FormStyle style,  List<FormVersionHistory> versionHistory,  Map<String, dynamic> workflows)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BuilderForm() when $default != null:
return $default(_that.id,_that.title,_that.status,_that.isPublished,_that.version,_that.isLatest,_that.sections,_that.layout,_that.updatedAt,_that.style,_that.versionHistory,_that.workflows);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Object? title,  String status,  bool isPublished,  String version,  bool isLatest,  List<FormSection> sections,  FormLayoutType layout, @JsonKey(fromJson: _parseDateTime)  DateTime? updatedAt,  FormStyle style,  List<FormVersionHistory> versionHistory,  Map<String, dynamic> workflows)  $default,) {final _that = this;
switch (_that) {
case _BuilderForm():
return $default(_that.id,_that.title,_that.status,_that.isPublished,_that.version,_that.isLatest,_that.sections,_that.layout,_that.updatedAt,_that.style,_that.versionHistory,_that.workflows);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Object? title,  String status,  bool isPublished,  String version,  bool isLatest,  List<FormSection> sections,  FormLayoutType layout, @JsonKey(fromJson: _parseDateTime)  DateTime? updatedAt,  FormStyle style,  List<FormVersionHistory> versionHistory,  Map<String, dynamic> workflows)?  $default,) {final _that = this;
switch (_that) {
case _BuilderForm() when $default != null:
return $default(_that.id,_that.title,_that.status,_that.isPublished,_that.version,_that.isLatest,_that.sections,_that.layout,_that.updatedAt,_that.style,_that.versionHistory,_that.workflows);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BuilderForm extends BuilderForm {
  const _BuilderForm({required this.id, required this.title, this.status = 'draft', this.isPublished = false, this.version = '1.0.0', this.isLatest = true, required final  List<FormSection> sections, this.layout = FormLayoutType.singleColumn, @JsonKey(fromJson: _parseDateTime) this.updatedAt, this.style = const FormStyle(), final  List<FormVersionHistory> versionHistory = const [], final  Map<String, dynamic> workflows = const {}}): _sections = sections,_versionHistory = versionHistory,_workflows = workflows,super._();
  factory _BuilderForm.fromJson(Map<String, dynamic> json) => _$BuilderFormFromJson(json);

@override final  String id;
@override final  Object? title;
@override@JsonKey() final  String status;
@override@JsonKey() final  bool isPublished;
@override@JsonKey() final  String version;
@override@JsonKey() final  bool isLatest;
 final  List<FormSection> _sections;
@override List<FormSection> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}

@override@JsonKey() final  FormLayoutType layout;
// ignore: invalid_annotation_target
@override@JsonKey(fromJson: _parseDateTime) final  DateTime? updatedAt;
@override@JsonKey() final  FormStyle style;
 final  List<FormVersionHistory> _versionHistory;
@override@JsonKey() List<FormVersionHistory> get versionHistory {
  if (_versionHistory is EqualUnmodifiableListView) return _versionHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_versionHistory);
}

 final  Map<String, dynamic> _workflows;
@override@JsonKey() Map<String, dynamic> get workflows {
  if (_workflows is EqualUnmodifiableMapView) return _workflows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_workflows);
}


/// Create a copy of BuilderForm
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BuilderFormCopyWith<_BuilderForm> get copyWith => __$BuilderFormCopyWithImpl<_BuilderForm>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BuilderFormToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BuilderForm&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.title, title)&&(identical(other.status, status) || other.status == status)&&(identical(other.isPublished, isPublished) || other.isPublished == isPublished)&&(identical(other.version, version) || other.version == version)&&(identical(other.isLatest, isLatest) || other.isLatest == isLatest)&&const DeepCollectionEquality().equals(other._sections, _sections)&&(identical(other.layout, layout) || other.layout == layout)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.style, style) || other.style == style)&&const DeepCollectionEquality().equals(other._versionHistory, _versionHistory)&&const DeepCollectionEquality().equals(other._workflows, _workflows));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(title),status,isPublished,version,isLatest,const DeepCollectionEquality().hash(_sections),layout,updatedAt,style,const DeepCollectionEquality().hash(_versionHistory),const DeepCollectionEquality().hash(_workflows));

@override
String toString() {
  return 'BuilderForm(id: $id, title: $title, status: $status, isPublished: $isPublished, version: $version, isLatest: $isLatest, sections: $sections, layout: $layout, updatedAt: $updatedAt, style: $style, versionHistory: $versionHistory, workflows: $workflows)';
}


}

/// @nodoc
abstract mixin class _$BuilderFormCopyWith<$Res> implements $BuilderFormCopyWith<$Res> {
  factory _$BuilderFormCopyWith(_BuilderForm value, $Res Function(_BuilderForm) _then) = __$BuilderFormCopyWithImpl;
@override @useResult
$Res call({
 String id, Object? title, String status, bool isPublished, String version, bool isLatest, List<FormSection> sections, FormLayoutType layout,@JsonKey(fromJson: _parseDateTime) DateTime? updatedAt, FormStyle style, List<FormVersionHistory> versionHistory, Map<String, dynamic> workflows
});


@override $FormStyleCopyWith<$Res> get style;

}
/// @nodoc
class __$BuilderFormCopyWithImpl<$Res>
    implements _$BuilderFormCopyWith<$Res> {
  __$BuilderFormCopyWithImpl(this._self, this._then);

  final _BuilderForm _self;
  final $Res Function(_BuilderForm) _then;

/// Create a copy of BuilderForm
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = freezed,Object? status = null,Object? isPublished = null,Object? version = null,Object? isLatest = null,Object? sections = null,Object? layout = null,Object? updatedAt = freezed,Object? style = null,Object? versionHistory = null,Object? workflows = null,}) {
  return _then(_BuilderForm(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title ,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isPublished: null == isPublished ? _self.isPublished : isPublished // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,isLatest: null == isLatest ? _self.isLatest : isLatest // ignore: cast_nullable_to_non_nullable
as bool,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<FormSection>,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as FormLayoutType,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as FormStyle,versionHistory: null == versionHistory ? _self._versionHistory : versionHistory // ignore: cast_nullable_to_non_nullable
as List<FormVersionHistory>,workflows: null == workflows ? _self._workflows : workflows // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

/// Create a copy of BuilderForm
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FormStyleCopyWith<$Res> get style {
  
  return $FormStyleCopyWith<$Res>(_self.style, (value) {
    return _then(_self.copyWith(style: value));
  });
}
}

// dart format on

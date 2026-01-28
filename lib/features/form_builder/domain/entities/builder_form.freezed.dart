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

 String get id; String get title; String get status; List<FormSection> get sections; FormLayoutType get layout; DateTime? get updatedAt; FormStyle get style;
/// Create a copy of BuilderForm
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BuilderFormCopyWith<BuilderForm> get copyWith => _$BuilderFormCopyWithImpl<BuilderForm>(this as BuilderForm, _$identity);

  /// Serializes this BuilderForm to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BuilderForm&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.sections, sections)&&(identical(other.layout, layout) || other.layout == layout)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.style, style) || other.style == style));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,status,const DeepCollectionEquality().hash(sections),layout,updatedAt,style);

@override
String toString() {
  return 'BuilderForm(id: $id, title: $title, status: $status, sections: $sections, layout: $layout, updatedAt: $updatedAt, style: $style)';
}


}

/// @nodoc
abstract mixin class $BuilderFormCopyWith<$Res>  {
  factory $BuilderFormCopyWith(BuilderForm value, $Res Function(BuilderForm) _then) = _$BuilderFormCopyWithImpl;
@useResult
$Res call({
 String id, String title, String status, List<FormSection> sections, FormLayoutType layout, DateTime? updatedAt, FormStyle style
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? status = null,Object? sections = null,Object? layout = null,Object? updatedAt = freezed,Object? style = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<FormSection>,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as FormLayoutType,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as FormStyle,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String status,  List<FormSection> sections,  FormLayoutType layout,  DateTime? updatedAt,  FormStyle style)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BuilderForm() when $default != null:
return $default(_that.id,_that.title,_that.status,_that.sections,_that.layout,_that.updatedAt,_that.style);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String status,  List<FormSection> sections,  FormLayoutType layout,  DateTime? updatedAt,  FormStyle style)  $default,) {final _that = this;
switch (_that) {
case _BuilderForm():
return $default(_that.id,_that.title,_that.status,_that.sections,_that.layout,_that.updatedAt,_that.style);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String status,  List<FormSection> sections,  FormLayoutType layout,  DateTime? updatedAt,  FormStyle style)?  $default,) {final _that = this;
switch (_that) {
case _BuilderForm() when $default != null:
return $default(_that.id,_that.title,_that.status,_that.sections,_that.layout,_that.updatedAt,_that.style);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BuilderForm extends BuilderForm {
  const _BuilderForm({required this.id, required this.title, this.status = 'draft', required final  List<FormSection> sections, this.layout = FormLayoutType.singleColumn, this.updatedAt, this.style = const FormStyle()}): _sections = sections,super._();
  factory _BuilderForm.fromJson(Map<String, dynamic> json) => _$BuilderFormFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey() final  String status;
 final  List<FormSection> _sections;
@override List<FormSection> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}

@override@JsonKey() final  FormLayoutType layout;
@override final  DateTime? updatedAt;
@override@JsonKey() final  FormStyle style;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BuilderForm&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._sections, _sections)&&(identical(other.layout, layout) || other.layout == layout)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.style, style) || other.style == style));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,status,const DeepCollectionEquality().hash(_sections),layout,updatedAt,style);

@override
String toString() {
  return 'BuilderForm(id: $id, title: $title, status: $status, sections: $sections, layout: $layout, updatedAt: $updatedAt, style: $style)';
}


}

/// @nodoc
abstract mixin class _$BuilderFormCopyWith<$Res> implements $BuilderFormCopyWith<$Res> {
  factory _$BuilderFormCopyWith(_BuilderForm value, $Res Function(_BuilderForm) _then) = __$BuilderFormCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String status, List<FormSection> sections, FormLayoutType layout, DateTime? updatedAt, FormStyle style
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? status = null,Object? sections = null,Object? layout = null,Object? updatedAt = freezed,Object? style = null,}) {
  return _then(_BuilderForm(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<FormSection>,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as FormLayoutType,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as FormStyle,
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

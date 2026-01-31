// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form_version.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FormVersion {

 String get id; String get versionNumber; List<FormSection> get sections; FormStyle get style; FormLayoutType get layout; DateTime get createdAt; String? get description;
/// Create a copy of FormVersion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormVersionCopyWith<FormVersion> get copyWith => _$FormVersionCopyWithImpl<FormVersion>(this as FormVersion, _$identity);

  /// Serializes this FormVersion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormVersion&&(identical(other.id, id) || other.id == id)&&(identical(other.versionNumber, versionNumber) || other.versionNumber == versionNumber)&&const DeepCollectionEquality().equals(other.sections, sections)&&(identical(other.style, style) || other.style == style)&&(identical(other.layout, layout) || other.layout == layout)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,versionNumber,const DeepCollectionEquality().hash(sections),style,layout,createdAt,description);

@override
String toString() {
  return 'FormVersion(id: $id, versionNumber: $versionNumber, sections: $sections, style: $style, layout: $layout, createdAt: $createdAt, description: $description)';
}


}

/// @nodoc
abstract mixin class $FormVersionCopyWith<$Res>  {
  factory $FormVersionCopyWith(FormVersion value, $Res Function(FormVersion) _then) = _$FormVersionCopyWithImpl;
@useResult
$Res call({
 String id, String versionNumber, List<FormSection> sections, FormStyle style, FormLayoutType layout, DateTime createdAt, String? description
});


$FormStyleCopyWith<$Res> get style;

}
/// @nodoc
class _$FormVersionCopyWithImpl<$Res>
    implements $FormVersionCopyWith<$Res> {
  _$FormVersionCopyWithImpl(this._self, this._then);

  final FormVersion _self;
  final $Res Function(FormVersion) _then;

/// Create a copy of FormVersion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? versionNumber = null,Object? sections = null,Object? style = null,Object? layout = null,Object? createdAt = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,versionNumber: null == versionNumber ? _self.versionNumber : versionNumber // ignore: cast_nullable_to_non_nullable
as String,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<FormSection>,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as FormStyle,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as FormLayoutType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of FormVersion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FormStyleCopyWith<$Res> get style {
  
  return $FormStyleCopyWith<$Res>(_self.style, (value) {
    return _then(_self.copyWith(style: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String versionNumber,  List<FormSection> sections,  FormStyle style,  FormLayoutType layout,  DateTime createdAt,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormVersion() when $default != null:
return $default(_that.id,_that.versionNumber,_that.sections,_that.style,_that.layout,_that.createdAt,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String versionNumber,  List<FormSection> sections,  FormStyle style,  FormLayoutType layout,  DateTime createdAt,  String? description)  $default,) {final _that = this;
switch (_that) {
case _FormVersion():
return $default(_that.id,_that.versionNumber,_that.sections,_that.style,_that.layout,_that.createdAt,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String versionNumber,  List<FormSection> sections,  FormStyle style,  FormLayoutType layout,  DateTime createdAt,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _FormVersion() when $default != null:
return $default(_that.id,_that.versionNumber,_that.sections,_that.style,_that.layout,_that.createdAt,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormVersion implements FormVersion {
  const _FormVersion({required this.id, required this.versionNumber, required final  List<FormSection> sections, this.style = const FormStyle(), this.layout = FormLayoutType.singleColumn, required this.createdAt, this.description}): _sections = sections;
  factory _FormVersion.fromJson(Map<String, dynamic> json) => _$FormVersionFromJson(json);

@override final  String id;
@override final  String versionNumber;
 final  List<FormSection> _sections;
@override List<FormSection> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}

@override@JsonKey() final  FormStyle style;
@override@JsonKey() final  FormLayoutType layout;
@override final  DateTime createdAt;
@override final  String? description;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormVersion&&(identical(other.id, id) || other.id == id)&&(identical(other.versionNumber, versionNumber) || other.versionNumber == versionNumber)&&const DeepCollectionEquality().equals(other._sections, _sections)&&(identical(other.style, style) || other.style == style)&&(identical(other.layout, layout) || other.layout == layout)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,versionNumber,const DeepCollectionEquality().hash(_sections),style,layout,createdAt,description);

@override
String toString() {
  return 'FormVersion(id: $id, versionNumber: $versionNumber, sections: $sections, style: $style, layout: $layout, createdAt: $createdAt, description: $description)';
}


}

/// @nodoc
abstract mixin class _$FormVersionCopyWith<$Res> implements $FormVersionCopyWith<$Res> {
  factory _$FormVersionCopyWith(_FormVersion value, $Res Function(_FormVersion) _then) = __$FormVersionCopyWithImpl;
@override @useResult
$Res call({
 String id, String versionNumber, List<FormSection> sections, FormStyle style, FormLayoutType layout, DateTime createdAt, String? description
});


@override $FormStyleCopyWith<$Res> get style;

}
/// @nodoc
class __$FormVersionCopyWithImpl<$Res>
    implements _$FormVersionCopyWith<$Res> {
  __$FormVersionCopyWithImpl(this._self, this._then);

  final _FormVersion _self;
  final $Res Function(_FormVersion) _then;

/// Create a copy of FormVersion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? versionNumber = null,Object? sections = null,Object? style = null,Object? layout = null,Object? createdAt = null,Object? description = freezed,}) {
  return _then(_FormVersion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,versionNumber: null == versionNumber ? _self.versionNumber : versionNumber // ignore: cast_nullable_to_non_nullable
as String,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<FormSection>,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as FormStyle,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as FormLayoutType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of FormVersion
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

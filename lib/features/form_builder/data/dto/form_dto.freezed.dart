// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FormDto {

// Handle backend UUIDs from `id` or `_id`; do not fall back to slug.
@JsonKey(name: 'id', readValue: IdReader.readIdWithSlugCallback) String get id; String get title; String get status;@JsonKey(name: 'ui_type') String? get uiType;@JsonKey(name: 'active_version') String? get activeVersion;// The backend returns a list of version objects under 'versions'
 List<FormVersionDto> get versions;@JsonKey(name: 'created_at', fromJson: AppDateUtils.parse, toJson: AppDateUtils.toIso8601) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: AppDateUtils.parse, toJson: AppDateUtils.toIso8601) DateTime? get updatedAt;// Workflows might be a Map or dynamic
 Map<String, dynamic> get workflows;// Access Policy
@JsonKey(name: 'accessPolicy') Map<String, dynamic>? get accessPolicy;
/// Create a copy of FormDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormDtoCopyWith<FormDto> get copyWith => _$FormDtoCopyWithImpl<FormDto>(this as FormDto, _$identity);

  /// Serializes this FormDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.uiType, uiType) || other.uiType == uiType)&&(identical(other.activeVersion, activeVersion) || other.activeVersion == activeVersion)&&const DeepCollectionEquality().equals(other.versions, versions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.workflows, workflows)&&const DeepCollectionEquality().equals(other.accessPolicy, accessPolicy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,status,uiType,activeVersion,const DeepCollectionEquality().hash(versions),createdAt,updatedAt,const DeepCollectionEquality().hash(workflows),const DeepCollectionEquality().hash(accessPolicy));

@override
String toString() {
  return 'FormDto(id: $id, title: $title, status: $status, uiType: $uiType, activeVersion: $activeVersion, versions: $versions, createdAt: $createdAt, updatedAt: $updatedAt, workflows: $workflows, accessPolicy: $accessPolicy)';
}


}

/// @nodoc
abstract mixin class $FormDtoCopyWith<$Res>  {
  factory $FormDtoCopyWith(FormDto value, $Res Function(FormDto) _then) = _$FormDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id', readValue: IdReader.readIdWithSlugCallback) String id, String title, String status,@JsonKey(name: 'ui_type') String? uiType,@JsonKey(name: 'active_version') String? activeVersion, List<FormVersionDto> versions,@JsonKey(name: 'created_at', fromJson: AppDateUtils.parse, toJson: AppDateUtils.toIso8601) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: AppDateUtils.parse, toJson: AppDateUtils.toIso8601) DateTime? updatedAt, Map<String, dynamic> workflows,@JsonKey(name: 'accessPolicy') Map<String, dynamic>? accessPolicy
});




}
/// @nodoc
class _$FormDtoCopyWithImpl<$Res>
    implements $FormDtoCopyWith<$Res> {
  _$FormDtoCopyWithImpl(this._self, this._then);

  final FormDto _self;
  final $Res Function(FormDto) _then;

/// Create a copy of FormDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? status = null,Object? uiType = freezed,Object? activeVersion = freezed,Object? versions = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? workflows = null,Object? accessPolicy = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,uiType: freezed == uiType ? _self.uiType : uiType // ignore: cast_nullable_to_non_nullable
as String?,activeVersion: freezed == activeVersion ? _self.activeVersion : activeVersion // ignore: cast_nullable_to_non_nullable
as String?,versions: null == versions ? _self.versions : versions // ignore: cast_nullable_to_non_nullable
as List<FormVersionDto>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,workflows: null == workflows ? _self.workflows : workflows // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,accessPolicy: freezed == accessPolicy ? _self.accessPolicy : accessPolicy // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [FormDto].
extension FormDtoPatterns on FormDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormDto value)  $default,){
final _that = this;
switch (_that) {
case _FormDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormDto value)?  $default,){
final _that = this;
switch (_that) {
case _FormDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', readValue: IdReader.readIdWithSlugCallback)  String id,  String title,  String status, @JsonKey(name: 'ui_type')  String? uiType, @JsonKey(name: 'active_version')  String? activeVersion,  List<FormVersionDto> versions, @JsonKey(name: 'created_at', fromJson: AppDateUtils.parse, toJson: AppDateUtils.toIso8601)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: AppDateUtils.parse, toJson: AppDateUtils.toIso8601)  DateTime? updatedAt,  Map<String, dynamic> workflows, @JsonKey(name: 'accessPolicy')  Map<String, dynamic>? accessPolicy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormDto() when $default != null:
return $default(_that.id,_that.title,_that.status,_that.uiType,_that.activeVersion,_that.versions,_that.createdAt,_that.updatedAt,_that.workflows,_that.accessPolicy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', readValue: IdReader.readIdWithSlugCallback)  String id,  String title,  String status, @JsonKey(name: 'ui_type')  String? uiType, @JsonKey(name: 'active_version')  String? activeVersion,  List<FormVersionDto> versions, @JsonKey(name: 'created_at', fromJson: AppDateUtils.parse, toJson: AppDateUtils.toIso8601)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: AppDateUtils.parse, toJson: AppDateUtils.toIso8601)  DateTime? updatedAt,  Map<String, dynamic> workflows, @JsonKey(name: 'accessPolicy')  Map<String, dynamic>? accessPolicy)  $default,) {final _that = this;
switch (_that) {
case _FormDto():
return $default(_that.id,_that.title,_that.status,_that.uiType,_that.activeVersion,_that.versions,_that.createdAt,_that.updatedAt,_that.workflows,_that.accessPolicy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id', readValue: IdReader.readIdWithSlugCallback)  String id,  String title,  String status, @JsonKey(name: 'ui_type')  String? uiType, @JsonKey(name: 'active_version')  String? activeVersion,  List<FormVersionDto> versions, @JsonKey(name: 'created_at', fromJson: AppDateUtils.parse, toJson: AppDateUtils.toIso8601)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: AppDateUtils.parse, toJson: AppDateUtils.toIso8601)  DateTime? updatedAt,  Map<String, dynamic> workflows, @JsonKey(name: 'accessPolicy')  Map<String, dynamic>? accessPolicy)?  $default,) {final _that = this;
switch (_that) {
case _FormDto() when $default != null:
return $default(_that.id,_that.title,_that.status,_that.uiType,_that.activeVersion,_that.versions,_that.createdAt,_that.updatedAt,_that.workflows,_that.accessPolicy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormDto extends FormDto {
  const _FormDto({@JsonKey(name: 'id', readValue: IdReader.readIdWithSlugCallback) required this.id, this.title = 'Untitled Form', this.status = 'draft', @JsonKey(name: 'ui_type') this.uiType, @JsonKey(name: 'active_version') this.activeVersion, final  List<FormVersionDto> versions = const <FormVersionDto>[], @JsonKey(name: 'created_at', fromJson: AppDateUtils.parse, toJson: AppDateUtils.toIso8601) this.createdAt, @JsonKey(name: 'updated_at', fromJson: AppDateUtils.parse, toJson: AppDateUtils.toIso8601) this.updatedAt, final  Map<String, dynamic> workflows = const <String, dynamic>{}, @JsonKey(name: 'accessPolicy') final  Map<String, dynamic>? accessPolicy}): _versions = versions,_workflows = workflows,_accessPolicy = accessPolicy,super._();
  factory _FormDto.fromJson(Map<String, dynamic> json) => _$FormDtoFromJson(json);

// Handle backend UUIDs from `id` or `_id`; do not fall back to slug.
@override@JsonKey(name: 'id', readValue: IdReader.readIdWithSlugCallback) final  String id;
@override@JsonKey() final  String title;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'ui_type') final  String? uiType;
@override@JsonKey(name: 'active_version') final  String? activeVersion;
// The backend returns a list of version objects under 'versions'
 final  List<FormVersionDto> _versions;
// The backend returns a list of version objects under 'versions'
@override@JsonKey() List<FormVersionDto> get versions {
  if (_versions is EqualUnmodifiableListView) return _versions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_versions);
}

@override@JsonKey(name: 'created_at', fromJson: AppDateUtils.parse, toJson: AppDateUtils.toIso8601) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: AppDateUtils.parse, toJson: AppDateUtils.toIso8601) final  DateTime? updatedAt;
// Workflows might be a Map or dynamic
 final  Map<String, dynamic> _workflows;
// Workflows might be a Map or dynamic
@override@JsonKey() Map<String, dynamic> get workflows {
  if (_workflows is EqualUnmodifiableMapView) return _workflows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_workflows);
}

// Access Policy
 final  Map<String, dynamic>? _accessPolicy;
// Access Policy
@override@JsonKey(name: 'accessPolicy') Map<String, dynamic>? get accessPolicy {
  final value = _accessPolicy;
  if (value == null) return null;
  if (_accessPolicy is EqualUnmodifiableMapView) return _accessPolicy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of FormDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormDtoCopyWith<_FormDto> get copyWith => __$FormDtoCopyWithImpl<_FormDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FormDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.uiType, uiType) || other.uiType == uiType)&&(identical(other.activeVersion, activeVersion) || other.activeVersion == activeVersion)&&const DeepCollectionEquality().equals(other._versions, _versions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._workflows, _workflows)&&const DeepCollectionEquality().equals(other._accessPolicy, _accessPolicy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,status,uiType,activeVersion,const DeepCollectionEquality().hash(_versions),createdAt,updatedAt,const DeepCollectionEquality().hash(_workflows),const DeepCollectionEquality().hash(_accessPolicy));

@override
String toString() {
  return 'FormDto(id: $id, title: $title, status: $status, uiType: $uiType, activeVersion: $activeVersion, versions: $versions, createdAt: $createdAt, updatedAt: $updatedAt, workflows: $workflows, accessPolicy: $accessPolicy)';
}


}

/// @nodoc
abstract mixin class _$FormDtoCopyWith<$Res> implements $FormDtoCopyWith<$Res> {
  factory _$FormDtoCopyWith(_FormDto value, $Res Function(_FormDto) _then) = __$FormDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id', readValue: IdReader.readIdWithSlugCallback) String id, String title, String status,@JsonKey(name: 'ui_type') String? uiType,@JsonKey(name: 'active_version') String? activeVersion, List<FormVersionDto> versions,@JsonKey(name: 'created_at', fromJson: AppDateUtils.parse, toJson: AppDateUtils.toIso8601) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: AppDateUtils.parse, toJson: AppDateUtils.toIso8601) DateTime? updatedAt, Map<String, dynamic> workflows,@JsonKey(name: 'accessPolicy') Map<String, dynamic>? accessPolicy
});




}
/// @nodoc
class __$FormDtoCopyWithImpl<$Res>
    implements _$FormDtoCopyWith<$Res> {
  __$FormDtoCopyWithImpl(this._self, this._then);

  final _FormDto _self;
  final $Res Function(_FormDto) _then;

/// Create a copy of FormDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? status = null,Object? uiType = freezed,Object? activeVersion = freezed,Object? versions = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? workflows = null,Object? accessPolicy = freezed,}) {
  return _then(_FormDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,uiType: freezed == uiType ? _self.uiType : uiType // ignore: cast_nullable_to_non_nullable
as String?,activeVersion: freezed == activeVersion ? _self.activeVersion : activeVersion // ignore: cast_nullable_to_non_nullable
as String?,versions: null == versions ? _self._versions : versions // ignore: cast_nullable_to_non_nullable
as List<FormVersionDto>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,workflows: null == workflows ? _self._workflows : workflows // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,accessPolicy: freezed == accessPolicy ? _self._accessPolicy : accessPolicy // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$FormVersionDto {

 String get version;@JsonKey(fromJson: _sectionsFromJson) List<Map<String, dynamic>> get sections;@JsonKey(name: 'created_at', fromJson: AppDateUtils.parse, toJson: AppDateUtils.toIso8601) DateTime? get createdAt;
/// Create a copy of FormVersionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormVersionDtoCopyWith<FormVersionDto> get copyWith => _$FormVersionDtoCopyWithImpl<FormVersionDto>(this as FormVersionDto, _$identity);

  /// Serializes this FormVersionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormVersionDto&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.sections, sections)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(sections),createdAt);

@override
String toString() {
  return 'FormVersionDto(version: $version, sections: $sections, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $FormVersionDtoCopyWith<$Res>  {
  factory $FormVersionDtoCopyWith(FormVersionDto value, $Res Function(FormVersionDto) _then) = _$FormVersionDtoCopyWithImpl;
@useResult
$Res call({
 String version,@JsonKey(fromJson: _sectionsFromJson) List<Map<String, dynamic>> sections,@JsonKey(name: 'created_at', fromJson: AppDateUtils.parse, toJson: AppDateUtils.toIso8601) DateTime? createdAt
});




}
/// @nodoc
class _$FormVersionDtoCopyWithImpl<$Res>
    implements $FormVersionDtoCopyWith<$Res> {
  _$FormVersionDtoCopyWithImpl(this._self, this._then);

  final FormVersionDto _self;
  final $Res Function(FormVersionDto) _then;

/// Create a copy of FormVersionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? sections = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FormVersionDto].
extension FormVersionDtoPatterns on FormVersionDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormVersionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormVersionDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormVersionDto value)  $default,){
final _that = this;
switch (_that) {
case _FormVersionDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormVersionDto value)?  $default,){
final _that = this;
switch (_that) {
case _FormVersionDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String version, @JsonKey(fromJson: _sectionsFromJson)  List<Map<String, dynamic>> sections, @JsonKey(name: 'created_at', fromJson: AppDateUtils.parse, toJson: AppDateUtils.toIso8601)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormVersionDto() when $default != null:
return $default(_that.version,_that.sections,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String version, @JsonKey(fromJson: _sectionsFromJson)  List<Map<String, dynamic>> sections, @JsonKey(name: 'created_at', fromJson: AppDateUtils.parse, toJson: AppDateUtils.toIso8601)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _FormVersionDto():
return $default(_that.version,_that.sections,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String version, @JsonKey(fromJson: _sectionsFromJson)  List<Map<String, dynamic>> sections, @JsonKey(name: 'created_at', fromJson: AppDateUtils.parse, toJson: AppDateUtils.toIso8601)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _FormVersionDto() when $default != null:
return $default(_that.version,_that.sections,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormVersionDto implements FormVersionDto {
  const _FormVersionDto({this.version = '1.0', @JsonKey(fromJson: _sectionsFromJson) final  List<Map<String, dynamic>> sections = const <Map<String, dynamic>>[], @JsonKey(name: 'created_at', fromJson: AppDateUtils.parse, toJson: AppDateUtils.toIso8601) this.createdAt}): _sections = sections;
  factory _FormVersionDto.fromJson(Map<String, dynamic> json) => _$FormVersionDtoFromJson(json);

@override@JsonKey() final  String version;
 final  List<Map<String, dynamic>> _sections;
@override@JsonKey(fromJson: _sectionsFromJson) List<Map<String, dynamic>> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}

@override@JsonKey(name: 'created_at', fromJson: AppDateUtils.parse, toJson: AppDateUtils.toIso8601) final  DateTime? createdAt;

/// Create a copy of FormVersionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormVersionDtoCopyWith<_FormVersionDto> get copyWith => __$FormVersionDtoCopyWithImpl<_FormVersionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FormVersionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormVersionDto&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other._sections, _sections)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(_sections),createdAt);

@override
String toString() {
  return 'FormVersionDto(version: $version, sections: $sections, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$FormVersionDtoCopyWith<$Res> implements $FormVersionDtoCopyWith<$Res> {
  factory _$FormVersionDtoCopyWith(_FormVersionDto value, $Res Function(_FormVersionDto) _then) = __$FormVersionDtoCopyWithImpl;
@override @useResult
$Res call({
 String version,@JsonKey(fromJson: _sectionsFromJson) List<Map<String, dynamic>> sections,@JsonKey(name: 'created_at', fromJson: AppDateUtils.parse, toJson: AppDateUtils.toIso8601) DateTime? createdAt
});




}
/// @nodoc
class __$FormVersionDtoCopyWithImpl<$Res>
    implements _$FormVersionDtoCopyWith<$Res> {
  __$FormVersionDtoCopyWithImpl(this._self, this._then);

  final _FormVersionDto _self;
  final $Res Function(_FormVersionDto) _then;

/// Create a copy of FormVersionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? sections = null,Object? createdAt = freezed,}) {
  return _then(_FormVersionDto(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

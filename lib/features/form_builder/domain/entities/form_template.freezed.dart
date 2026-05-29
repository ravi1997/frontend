// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FormTemplate {

 String get id; String get name; String get description; FormTemplateCategory get category; Form get form; String get thumbnailUrl; List<String> get tags; int get usageCount; DateTime? get createdAt;
/// Create a copy of FormTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormTemplateCopyWith<FormTemplate> get copyWith => _$FormTemplateCopyWithImpl<FormTemplate>(this as FormTemplate, _$identity);

  /// Serializes this FormTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.form, form) || other.form == form)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.usageCount, usageCount) || other.usageCount == usageCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,category,form,thumbnailUrl,const DeepCollectionEquality().hash(tags),usageCount,createdAt);

@override
String toString() {
  return 'FormTemplate(id: $id, name: $name, description: $description, category: $category, form: $form, thumbnailUrl: $thumbnailUrl, tags: $tags, usageCount: $usageCount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $FormTemplateCopyWith<$Res>  {
  factory $FormTemplateCopyWith(FormTemplate value, $Res Function(FormTemplate) _then) = _$FormTemplateCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, FormTemplateCategory category, Form form, String thumbnailUrl, List<String> tags, int usageCount, DateTime? createdAt
});


$FormCopyWith<$Res> get form;

}
/// @nodoc
class _$FormTemplateCopyWithImpl<$Res>
    implements $FormTemplateCopyWith<$Res> {
  _$FormTemplateCopyWithImpl(this._self, this._then);

  final FormTemplate _self;
  final $Res Function(FormTemplate) _then;

/// Create a copy of FormTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? category = null,Object? form = null,Object? thumbnailUrl = null,Object? tags = null,Object? usageCount = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as FormTemplateCategory,form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as Form,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,usageCount: null == usageCount ? _self.usageCount : usageCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of FormTemplate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FormCopyWith<$Res> get form {
  
  return $FormCopyWith<$Res>(_self.form, (value) {
    return _then(_self.copyWith(form: value));
  });
}
}


/// Adds pattern-matching-related methods to [FormTemplate].
extension FormTemplatePatterns on FormTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormTemplate value)  $default,){
final _that = this;
switch (_that) {
case _FormTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _FormTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  FormTemplateCategory category,  Form form,  String thumbnailUrl,  List<String> tags,  int usageCount,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormTemplate() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.category,_that.form,_that.thumbnailUrl,_that.tags,_that.usageCount,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  FormTemplateCategory category,  Form form,  String thumbnailUrl,  List<String> tags,  int usageCount,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _FormTemplate():
return $default(_that.id,_that.name,_that.description,_that.category,_that.form,_that.thumbnailUrl,_that.tags,_that.usageCount,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  FormTemplateCategory category,  Form form,  String thumbnailUrl,  List<String> tags,  int usageCount,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _FormTemplate() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.category,_that.form,_that.thumbnailUrl,_that.tags,_that.usageCount,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormTemplate implements FormTemplate {
  const _FormTemplate({required this.id, required this.name, required this.description, required this.category, required this.form, this.thumbnailUrl = '', final  List<String> tags = const [], this.usageCount = 0, this.createdAt}): _tags = tags;
  factory _FormTemplate.fromJson(Map<String, dynamic> json) => _$FormTemplateFromJson(json);

@override final  String id;
@override final  String name;
@override final  String description;
@override final  FormTemplateCategory category;
@override final  Form form;
@override@JsonKey() final  String thumbnailUrl;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@JsonKey() final  int usageCount;
@override final  DateTime? createdAt;

/// Create a copy of FormTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormTemplateCopyWith<_FormTemplate> get copyWith => __$FormTemplateCopyWithImpl<_FormTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FormTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.form, form) || other.form == form)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.usageCount, usageCount) || other.usageCount == usageCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,category,form,thumbnailUrl,const DeepCollectionEquality().hash(_tags),usageCount,createdAt);

@override
String toString() {
  return 'FormTemplate(id: $id, name: $name, description: $description, category: $category, form: $form, thumbnailUrl: $thumbnailUrl, tags: $tags, usageCount: $usageCount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$FormTemplateCopyWith<$Res> implements $FormTemplateCopyWith<$Res> {
  factory _$FormTemplateCopyWith(_FormTemplate value, $Res Function(_FormTemplate) _then) = __$FormTemplateCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, FormTemplateCategory category, Form form, String thumbnailUrl, List<String> tags, int usageCount, DateTime? createdAt
});


@override $FormCopyWith<$Res> get form;

}
/// @nodoc
class __$FormTemplateCopyWithImpl<$Res>
    implements _$FormTemplateCopyWith<$Res> {
  __$FormTemplateCopyWithImpl(this._self, this._then);

  final _FormTemplate _self;
  final $Res Function(_FormTemplate) _then;

/// Create a copy of FormTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? category = null,Object? form = null,Object? thumbnailUrl = null,Object? tags = null,Object? usageCount = null,Object? createdAt = freezed,}) {
  return _then(_FormTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as FormTemplateCategory,form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as Form,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,usageCount: null == usageCount ? _self.usageCount : usageCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of FormTemplate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FormCopyWith<$Res> get form {
  
  return $FormCopyWith<$Res>(_self.form, (value) {
    return _then(_self.copyWith(form: value));
  });
}
}

// dart format on

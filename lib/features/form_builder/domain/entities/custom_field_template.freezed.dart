// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_field_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomFieldTemplate {

 String get id; String get name; String get category; FormQuestion get question;
/// Create a copy of CustomFieldTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomFieldTemplateCopyWith<CustomFieldTemplate> get copyWith => _$CustomFieldTemplateCopyWithImpl<CustomFieldTemplate>(this as CustomFieldTemplate, _$identity);

  /// Serializes this CustomFieldTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomFieldTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.question, question) || other.question == question));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,question);

@override
String toString() {
  return 'CustomFieldTemplate(id: $id, name: $name, category: $category, question: $question)';
}


}

/// @nodoc
abstract mixin class $CustomFieldTemplateCopyWith<$Res>  {
  factory $CustomFieldTemplateCopyWith(CustomFieldTemplate value, $Res Function(CustomFieldTemplate) _then) = _$CustomFieldTemplateCopyWithImpl;
@useResult
$Res call({
 String id, String name, String category, FormQuestion question
});


$FormQuestionCopyWith<$Res> get question;

}
/// @nodoc
class _$CustomFieldTemplateCopyWithImpl<$Res>
    implements $CustomFieldTemplateCopyWith<$Res> {
  _$CustomFieldTemplateCopyWithImpl(this._self, this._then);

  final CustomFieldTemplate _self;
  final $Res Function(CustomFieldTemplate) _then;

/// Create a copy of CustomFieldTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? category = null,Object? question = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as FormQuestion,
  ));
}
/// Create a copy of CustomFieldTemplate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FormQuestionCopyWith<$Res> get question {
  
  return $FormQuestionCopyWith<$Res>(_self.question, (value) {
    return _then(_self.copyWith(question: value));
  });
}
}


/// Adds pattern-matching-related methods to [CustomFieldTemplate].
extension CustomFieldTemplatePatterns on CustomFieldTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomFieldTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomFieldTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomFieldTemplate value)  $default,){
final _that = this;
switch (_that) {
case _CustomFieldTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomFieldTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _CustomFieldTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String category,  FormQuestion question)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomFieldTemplate() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.question);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String category,  FormQuestion question)  $default,) {final _that = this;
switch (_that) {
case _CustomFieldTemplate():
return $default(_that.id,_that.name,_that.category,_that.question);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String category,  FormQuestion question)?  $default,) {final _that = this;
switch (_that) {
case _CustomFieldTemplate() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.question);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomFieldTemplate implements CustomFieldTemplate {
  const _CustomFieldTemplate({required this.id, required this.name, required this.category, required this.question});
  factory _CustomFieldTemplate.fromJson(Map<String, dynamic> json) => _$CustomFieldTemplateFromJson(json);

@override final  String id;
@override final  String name;
@override final  String category;
@override final  FormQuestion question;

/// Create a copy of CustomFieldTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomFieldTemplateCopyWith<_CustomFieldTemplate> get copyWith => __$CustomFieldTemplateCopyWithImpl<_CustomFieldTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomFieldTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomFieldTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.question, question) || other.question == question));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,question);

@override
String toString() {
  return 'CustomFieldTemplate(id: $id, name: $name, category: $category, question: $question)';
}


}

/// @nodoc
abstract mixin class _$CustomFieldTemplateCopyWith<$Res> implements $CustomFieldTemplateCopyWith<$Res> {
  factory _$CustomFieldTemplateCopyWith(_CustomFieldTemplate value, $Res Function(_CustomFieldTemplate) _then) = __$CustomFieldTemplateCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String category, FormQuestion question
});


@override $FormQuestionCopyWith<$Res> get question;

}
/// @nodoc
class __$CustomFieldTemplateCopyWithImpl<$Res>
    implements _$CustomFieldTemplateCopyWith<$Res> {
  __$CustomFieldTemplateCopyWithImpl(this._self, this._then);

  final _CustomFieldTemplate _self;
  final $Res Function(_CustomFieldTemplate) _then;

/// Create a copy of CustomFieldTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? category = null,Object? question = null,}) {
  return _then(_CustomFieldTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as FormQuestion,
  ));
}

/// Create a copy of CustomFieldTemplate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FormQuestionCopyWith<$Res> get question {
  
  return $FormQuestionCopyWith<$Res>(_self.question, (value) {
    return _then(_self.copyWith(question: value));
  });
}
}

// dart format on

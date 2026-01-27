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

 String get id; String get title; String? get description; List<FormQuestion> get questions;
/// Create a copy of FormSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormSectionCopyWith<FormSection> get copyWith => _$FormSectionCopyWithImpl<FormSection>(this as FormSection, _$identity);

  /// Serializes this FormSection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormSection&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.questions, questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,const DeepCollectionEquality().hash(questions));

@override
String toString() {
  return 'FormSection(id: $id, title: $title, description: $description, questions: $questions)';
}


}

/// @nodoc
abstract mixin class $FormSectionCopyWith<$Res>  {
  factory $FormSectionCopyWith(FormSection value, $Res Function(FormSection) _then) = _$FormSectionCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? description, List<FormQuestion> questions
});




}
/// @nodoc
class _$FormSectionCopyWithImpl<$Res>
    implements $FormSectionCopyWith<$Res> {
  _$FormSectionCopyWithImpl(this._self, this._then);

  final FormSection _self;
  final $Res Function(FormSection) _then;

/// Create a copy of FormSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? questions = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<FormQuestion>,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  List<FormQuestion> questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormSection() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.questions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  List<FormQuestion> questions)  $default,) {final _that = this;
switch (_that) {
case _FormSection():
return $default(_that.id,_that.title,_that.description,_that.questions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? description,  List<FormQuestion> questions)?  $default,) {final _that = this;
switch (_that) {
case _FormSection() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.questions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormSection extends FormSection {
  const _FormSection({required this.id, required this.title, this.description, required final  List<FormQuestion> questions}): _questions = questions,super._();
  factory _FormSection.fromJson(Map<String, dynamic> json) => _$FormSectionFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? description;
 final  List<FormQuestion> _questions;
@override List<FormQuestion> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormSection&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._questions, _questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,const DeepCollectionEquality().hash(_questions));

@override
String toString() {
  return 'FormSection(id: $id, title: $title, description: $description, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$FormSectionCopyWith<$Res> implements $FormSectionCopyWith<$Res> {
  factory _$FormSectionCopyWith(_FormSection value, $Res Function(_FormSection) _then) = __$FormSectionCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? description, List<FormQuestion> questions
});




}
/// @nodoc
class __$FormSectionCopyWithImpl<$Res>
    implements _$FormSectionCopyWith<$Res> {
  __$FormSectionCopyWithImpl(this._self, this._then);

  final _FormSection _self;
  final $Res Function(_FormSection) _then;

/// Create a copy of FormSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? questions = null,}) {
  return _then(_FormSection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<FormQuestion>,
  ));
}


}

// dart format on

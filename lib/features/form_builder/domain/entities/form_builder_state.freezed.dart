// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form_builder_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FormBuilderState {

 BuilderForm get form; String? get selectedSectionId; String? get selectedQuestionId; bool get isFormSelected; bool get isSaving; bool get isLoading; String? get error;
/// Create a copy of FormBuilderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormBuilderStateCopyWith<FormBuilderState> get copyWith => _$FormBuilderStateCopyWithImpl<FormBuilderState>(this as FormBuilderState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormBuilderState&&(identical(other.form, form) || other.form == form)&&(identical(other.selectedSectionId, selectedSectionId) || other.selectedSectionId == selectedSectionId)&&(identical(other.selectedQuestionId, selectedQuestionId) || other.selectedQuestionId == selectedQuestionId)&&(identical(other.isFormSelected, isFormSelected) || other.isFormSelected == isFormSelected)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,form,selectedSectionId,selectedQuestionId,isFormSelected,isSaving,isLoading,error);

@override
String toString() {
  return 'FormBuilderState(form: $form, selectedSectionId: $selectedSectionId, selectedQuestionId: $selectedQuestionId, isFormSelected: $isFormSelected, isSaving: $isSaving, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class $FormBuilderStateCopyWith<$Res>  {
  factory $FormBuilderStateCopyWith(FormBuilderState value, $Res Function(FormBuilderState) _then) = _$FormBuilderStateCopyWithImpl;
@useResult
$Res call({
 BuilderForm form, String? selectedSectionId, String? selectedQuestionId, bool isFormSelected, bool isSaving, bool isLoading, String? error
});


$BuilderFormCopyWith<$Res> get form;

}
/// @nodoc
class _$FormBuilderStateCopyWithImpl<$Res>
    implements $FormBuilderStateCopyWith<$Res> {
  _$FormBuilderStateCopyWithImpl(this._self, this._then);

  final FormBuilderState _self;
  final $Res Function(FormBuilderState) _then;

/// Create a copy of FormBuilderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? form = null,Object? selectedSectionId = freezed,Object? selectedQuestionId = freezed,Object? isFormSelected = null,Object? isSaving = null,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as BuilderForm,selectedSectionId: freezed == selectedSectionId ? _self.selectedSectionId : selectedSectionId // ignore: cast_nullable_to_non_nullable
as String?,selectedQuestionId: freezed == selectedQuestionId ? _self.selectedQuestionId : selectedQuestionId // ignore: cast_nullable_to_non_nullable
as String?,isFormSelected: null == isFormSelected ? _self.isFormSelected : isFormSelected // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of FormBuilderState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BuilderFormCopyWith<$Res> get form {
  
  return $BuilderFormCopyWith<$Res>(_self.form, (value) {
    return _then(_self.copyWith(form: value));
  });
}
}


/// Adds pattern-matching-related methods to [FormBuilderState].
extension FormBuilderStatePatterns on FormBuilderState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormBuilderState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormBuilderState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormBuilderState value)  $default,){
final _that = this;
switch (_that) {
case _FormBuilderState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormBuilderState value)?  $default,){
final _that = this;
switch (_that) {
case _FormBuilderState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BuilderForm form,  String? selectedSectionId,  String? selectedQuestionId,  bool isFormSelected,  bool isSaving,  bool isLoading,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormBuilderState() when $default != null:
return $default(_that.form,_that.selectedSectionId,_that.selectedQuestionId,_that.isFormSelected,_that.isSaving,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BuilderForm form,  String? selectedSectionId,  String? selectedQuestionId,  bool isFormSelected,  bool isSaving,  bool isLoading,  String? error)  $default,) {final _that = this;
switch (_that) {
case _FormBuilderState():
return $default(_that.form,_that.selectedSectionId,_that.selectedQuestionId,_that.isFormSelected,_that.isSaving,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BuilderForm form,  String? selectedSectionId,  String? selectedQuestionId,  bool isFormSelected,  bool isSaving,  bool isLoading,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _FormBuilderState() when $default != null:
return $default(_that.form,_that.selectedSectionId,_that.selectedQuestionId,_that.isFormSelected,_that.isSaving,_that.isLoading,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _FormBuilderState implements FormBuilderState {
  const _FormBuilderState({required this.form, this.selectedSectionId, this.selectedQuestionId, this.isFormSelected = false, this.isSaving = false, this.isLoading = false, this.error});
  

@override final  BuilderForm form;
@override final  String? selectedSectionId;
@override final  String? selectedQuestionId;
@override@JsonKey() final  bool isFormSelected;
@override@JsonKey() final  bool isSaving;
@override@JsonKey() final  bool isLoading;
@override final  String? error;

/// Create a copy of FormBuilderState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormBuilderStateCopyWith<_FormBuilderState> get copyWith => __$FormBuilderStateCopyWithImpl<_FormBuilderState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormBuilderState&&(identical(other.form, form) || other.form == form)&&(identical(other.selectedSectionId, selectedSectionId) || other.selectedSectionId == selectedSectionId)&&(identical(other.selectedQuestionId, selectedQuestionId) || other.selectedQuestionId == selectedQuestionId)&&(identical(other.isFormSelected, isFormSelected) || other.isFormSelected == isFormSelected)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,form,selectedSectionId,selectedQuestionId,isFormSelected,isSaving,isLoading,error);

@override
String toString() {
  return 'FormBuilderState(form: $form, selectedSectionId: $selectedSectionId, selectedQuestionId: $selectedQuestionId, isFormSelected: $isFormSelected, isSaving: $isSaving, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class _$FormBuilderStateCopyWith<$Res> implements $FormBuilderStateCopyWith<$Res> {
  factory _$FormBuilderStateCopyWith(_FormBuilderState value, $Res Function(_FormBuilderState) _then) = __$FormBuilderStateCopyWithImpl;
@override @useResult
$Res call({
 BuilderForm form, String? selectedSectionId, String? selectedQuestionId, bool isFormSelected, bool isSaving, bool isLoading, String? error
});


@override $BuilderFormCopyWith<$Res> get form;

}
/// @nodoc
class __$FormBuilderStateCopyWithImpl<$Res>
    implements _$FormBuilderStateCopyWith<$Res> {
  __$FormBuilderStateCopyWithImpl(this._self, this._then);

  final _FormBuilderState _self;
  final $Res Function(_FormBuilderState) _then;

/// Create a copy of FormBuilderState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? form = null,Object? selectedSectionId = freezed,Object? selectedQuestionId = freezed,Object? isFormSelected = null,Object? isSaving = null,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_FormBuilderState(
form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as BuilderForm,selectedSectionId: freezed == selectedSectionId ? _self.selectedSectionId : selectedSectionId // ignore: cast_nullable_to_non_nullable
as String?,selectedQuestionId: freezed == selectedQuestionId ? _self.selectedQuestionId : selectedQuestionId // ignore: cast_nullable_to_non_nullable
as String?,isFormSelected: null == isFormSelected ? _self.isFormSelected : isFormSelected // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of FormBuilderState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BuilderFormCopyWith<$Res> get form {
  
  return $BuilderFormCopyWith<$Res>(_self.form, (value) {
    return _then(_self.copyWith(form: value));
  });
}
}

// dart format on

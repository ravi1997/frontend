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

 BuilderForm get form; String? get selectedSectionId; String? get selectedQuestionId; List<String> get selectedQuestionIds; bool get isFormSelected; bool get isDirty; bool get canUndo; bool get canRedo; bool get isSaving; bool get isLoading; String get editingLocale; String? get error;
/// Create a copy of FormBuilderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormBuilderStateCopyWith<FormBuilderState> get copyWith => _$FormBuilderStateCopyWithImpl<FormBuilderState>(this as FormBuilderState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormBuilderState&&(identical(other.form, form) || other.form == form)&&(identical(other.selectedSectionId, selectedSectionId) || other.selectedSectionId == selectedSectionId)&&(identical(other.selectedQuestionId, selectedQuestionId) || other.selectedQuestionId == selectedQuestionId)&&const DeepCollectionEquality().equals(other.selectedQuestionIds, selectedQuestionIds)&&(identical(other.isFormSelected, isFormSelected) || other.isFormSelected == isFormSelected)&&(identical(other.isDirty, isDirty) || other.isDirty == isDirty)&&(identical(other.canUndo, canUndo) || other.canUndo == canUndo)&&(identical(other.canRedo, canRedo) || other.canRedo == canRedo)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.editingLocale, editingLocale) || other.editingLocale == editingLocale)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,form,selectedSectionId,selectedQuestionId,const DeepCollectionEquality().hash(selectedQuestionIds),isFormSelected,isDirty,canUndo,canRedo,isSaving,isLoading,editingLocale,error);

@override
String toString() {
  return 'FormBuilderState(form: $form, selectedSectionId: $selectedSectionId, selectedQuestionId: $selectedQuestionId, selectedQuestionIds: $selectedQuestionIds, isFormSelected: $isFormSelected, isDirty: $isDirty, canUndo: $canUndo, canRedo: $canRedo, isSaving: $isSaving, isLoading: $isLoading, editingLocale: $editingLocale, error: $error)';
}


}

/// @nodoc
abstract mixin class $FormBuilderStateCopyWith<$Res>  {
  factory $FormBuilderStateCopyWith(FormBuilderState value, $Res Function(FormBuilderState) _then) = _$FormBuilderStateCopyWithImpl;
@useResult
$Res call({
 BuilderForm form, String? selectedSectionId, String? selectedQuestionId, List<String> selectedQuestionIds, bool isFormSelected, bool isDirty, bool canUndo, bool canRedo, bool isSaving, bool isLoading, String editingLocale, String? error
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
@pragma('vm:prefer-inline') @override $Res call({Object? form = null,Object? selectedSectionId = freezed,Object? selectedQuestionId = freezed,Object? selectedQuestionIds = null,Object? isFormSelected = null,Object? isDirty = null,Object? canUndo = null,Object? canRedo = null,Object? isSaving = null,Object? isLoading = null,Object? editingLocale = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as BuilderForm,selectedSectionId: freezed == selectedSectionId ? _self.selectedSectionId : selectedSectionId // ignore: cast_nullable_to_non_nullable
as String?,selectedQuestionId: freezed == selectedQuestionId ? _self.selectedQuestionId : selectedQuestionId // ignore: cast_nullable_to_non_nullable
as String?,selectedQuestionIds: null == selectedQuestionIds ? _self.selectedQuestionIds : selectedQuestionIds // ignore: cast_nullable_to_non_nullable
as List<String>,isFormSelected: null == isFormSelected ? _self.isFormSelected : isFormSelected // ignore: cast_nullable_to_non_nullable
as bool,isDirty: null == isDirty ? _self.isDirty : isDirty // ignore: cast_nullable_to_non_nullable
as bool,canUndo: null == canUndo ? _self.canUndo : canUndo // ignore: cast_nullable_to_non_nullable
as bool,canRedo: null == canRedo ? _self.canRedo : canRedo // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,editingLocale: null == editingLocale ? _self.editingLocale : editingLocale // ignore: cast_nullable_to_non_nullable
as String,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BuilderForm form,  String? selectedSectionId,  String? selectedQuestionId,  List<String> selectedQuestionIds,  bool isFormSelected,  bool isDirty,  bool canUndo,  bool canRedo,  bool isSaving,  bool isLoading,  String editingLocale,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormBuilderState() when $default != null:
return $default(_that.form,_that.selectedSectionId,_that.selectedQuestionId,_that.selectedQuestionIds,_that.isFormSelected,_that.isDirty,_that.canUndo,_that.canRedo,_that.isSaving,_that.isLoading,_that.editingLocale,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BuilderForm form,  String? selectedSectionId,  String? selectedQuestionId,  List<String> selectedQuestionIds,  bool isFormSelected,  bool isDirty,  bool canUndo,  bool canRedo,  bool isSaving,  bool isLoading,  String editingLocale,  String? error)  $default,) {final _that = this;
switch (_that) {
case _FormBuilderState():
return $default(_that.form,_that.selectedSectionId,_that.selectedQuestionId,_that.selectedQuestionIds,_that.isFormSelected,_that.isDirty,_that.canUndo,_that.canRedo,_that.isSaving,_that.isLoading,_that.editingLocale,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BuilderForm form,  String? selectedSectionId,  String? selectedQuestionId,  List<String> selectedQuestionIds,  bool isFormSelected,  bool isDirty,  bool canUndo,  bool canRedo,  bool isSaving,  bool isLoading,  String editingLocale,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _FormBuilderState() when $default != null:
return $default(_that.form,_that.selectedSectionId,_that.selectedQuestionId,_that.selectedQuestionIds,_that.isFormSelected,_that.isDirty,_that.canUndo,_that.canRedo,_that.isSaving,_that.isLoading,_that.editingLocale,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _FormBuilderState implements FormBuilderState {
  const _FormBuilderState({required this.form, this.selectedSectionId, this.selectedQuestionId, final  List<String> selectedQuestionIds = const <String>[], this.isFormSelected = false, this.isDirty = false, this.canUndo = false, this.canRedo = false, this.isSaving = false, this.isLoading = false, this.editingLocale = 'en', this.error}): _selectedQuestionIds = selectedQuestionIds;
  

@override final  BuilderForm form;
@override final  String? selectedSectionId;
@override final  String? selectedQuestionId;
 final  List<String> _selectedQuestionIds;
@override@JsonKey() List<String> get selectedQuestionIds {
  if (_selectedQuestionIds is EqualUnmodifiableListView) return _selectedQuestionIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedQuestionIds);
}

@override@JsonKey() final  bool isFormSelected;
@override@JsonKey() final  bool isDirty;
@override@JsonKey() final  bool canUndo;
@override@JsonKey() final  bool canRedo;
@override@JsonKey() final  bool isSaving;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  String editingLocale;
@override final  String? error;

/// Create a copy of FormBuilderState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormBuilderStateCopyWith<_FormBuilderState> get copyWith => __$FormBuilderStateCopyWithImpl<_FormBuilderState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormBuilderState&&(identical(other.form, form) || other.form == form)&&(identical(other.selectedSectionId, selectedSectionId) || other.selectedSectionId == selectedSectionId)&&(identical(other.selectedQuestionId, selectedQuestionId) || other.selectedQuestionId == selectedQuestionId)&&const DeepCollectionEquality().equals(other._selectedQuestionIds, _selectedQuestionIds)&&(identical(other.isFormSelected, isFormSelected) || other.isFormSelected == isFormSelected)&&(identical(other.isDirty, isDirty) || other.isDirty == isDirty)&&(identical(other.canUndo, canUndo) || other.canUndo == canUndo)&&(identical(other.canRedo, canRedo) || other.canRedo == canRedo)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.editingLocale, editingLocale) || other.editingLocale == editingLocale)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,form,selectedSectionId,selectedQuestionId,const DeepCollectionEquality().hash(_selectedQuestionIds),isFormSelected,isDirty,canUndo,canRedo,isSaving,isLoading,editingLocale,error);

@override
String toString() {
  return 'FormBuilderState(form: $form, selectedSectionId: $selectedSectionId, selectedQuestionId: $selectedQuestionId, selectedQuestionIds: $selectedQuestionIds, isFormSelected: $isFormSelected, isDirty: $isDirty, canUndo: $canUndo, canRedo: $canRedo, isSaving: $isSaving, isLoading: $isLoading, editingLocale: $editingLocale, error: $error)';
}


}

/// @nodoc
abstract mixin class _$FormBuilderStateCopyWith<$Res> implements $FormBuilderStateCopyWith<$Res> {
  factory _$FormBuilderStateCopyWith(_FormBuilderState value, $Res Function(_FormBuilderState) _then) = __$FormBuilderStateCopyWithImpl;
@override @useResult
$Res call({
 BuilderForm form, String? selectedSectionId, String? selectedQuestionId, List<String> selectedQuestionIds, bool isFormSelected, bool isDirty, bool canUndo, bool canRedo, bool isSaving, bool isLoading, String editingLocale, String? error
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
@override @pragma('vm:prefer-inline') $Res call({Object? form = null,Object? selectedSectionId = freezed,Object? selectedQuestionId = freezed,Object? selectedQuestionIds = null,Object? isFormSelected = null,Object? isDirty = null,Object? canUndo = null,Object? canRedo = null,Object? isSaving = null,Object? isLoading = null,Object? editingLocale = null,Object? error = freezed,}) {
  return _then(_FormBuilderState(
form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as BuilderForm,selectedSectionId: freezed == selectedSectionId ? _self.selectedSectionId : selectedSectionId // ignore: cast_nullable_to_non_nullable
as String?,selectedQuestionId: freezed == selectedQuestionId ? _self.selectedQuestionId : selectedQuestionId // ignore: cast_nullable_to_non_nullable
as String?,selectedQuestionIds: null == selectedQuestionIds ? _self._selectedQuestionIds : selectedQuestionIds // ignore: cast_nullable_to_non_nullable
as List<String>,isFormSelected: null == isFormSelected ? _self.isFormSelected : isFormSelected // ignore: cast_nullable_to_non_nullable
as bool,isDirty: null == isDirty ? _self.isDirty : isDirty // ignore: cast_nullable_to_non_nullable
as bool,canUndo: null == canUndo ? _self.canUndo : canUndo // ignore: cast_nullable_to_non_nullable
as bool,canRedo: null == canRedo ? _self.canRedo : canRedo // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,editingLocale: null == editingLocale ? _self.editingLocale : editingLocale // ignore: cast_nullable_to_non_nullable
as String,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
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

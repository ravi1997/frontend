// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analysis_builder_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnalysisBuilderState {

 AnalysisDashboard get dashboard; String? get selectedWidgetId; bool get isSaving; bool get isLoading; List<AnalysisDashboard> get undoStack; List<AnalysisDashboard> get redoStack; String? get error;
/// Create a copy of AnalysisBuilderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalysisBuilderStateCopyWith<AnalysisBuilderState> get copyWith => _$AnalysisBuilderStateCopyWithImpl<AnalysisBuilderState>(this as AnalysisBuilderState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalysisBuilderState&&(identical(other.dashboard, dashboard) || other.dashboard == dashboard)&&(identical(other.selectedWidgetId, selectedWidgetId) || other.selectedWidgetId == selectedWidgetId)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.undoStack, undoStack)&&const DeepCollectionEquality().equals(other.redoStack, redoStack)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,dashboard,selectedWidgetId,isSaving,isLoading,const DeepCollectionEquality().hash(undoStack),const DeepCollectionEquality().hash(redoStack),error);

@override
String toString() {
  return 'AnalysisBuilderState(dashboard: $dashboard, selectedWidgetId: $selectedWidgetId, isSaving: $isSaving, isLoading: $isLoading, undoStack: $undoStack, redoStack: $redoStack, error: $error)';
}


}

/// @nodoc
abstract mixin class $AnalysisBuilderStateCopyWith<$Res>  {
  factory $AnalysisBuilderStateCopyWith(AnalysisBuilderState value, $Res Function(AnalysisBuilderState) _then) = _$AnalysisBuilderStateCopyWithImpl;
@useResult
$Res call({
 AnalysisDashboard dashboard, String? selectedWidgetId, bool isSaving, bool isLoading, List<AnalysisDashboard> undoStack, List<AnalysisDashboard> redoStack, String? error
});


$AnalysisDashboardCopyWith<$Res> get dashboard;

}
/// @nodoc
class _$AnalysisBuilderStateCopyWithImpl<$Res>
    implements $AnalysisBuilderStateCopyWith<$Res> {
  _$AnalysisBuilderStateCopyWithImpl(this._self, this._then);

  final AnalysisBuilderState _self;
  final $Res Function(AnalysisBuilderState) _then;

/// Create a copy of AnalysisBuilderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dashboard = null,Object? selectedWidgetId = freezed,Object? isSaving = null,Object? isLoading = null,Object? undoStack = null,Object? redoStack = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
dashboard: null == dashboard ? _self.dashboard : dashboard // ignore: cast_nullable_to_non_nullable
as AnalysisDashboard,selectedWidgetId: freezed == selectedWidgetId ? _self.selectedWidgetId : selectedWidgetId // ignore: cast_nullable_to_non_nullable
as String?,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,undoStack: null == undoStack ? _self.undoStack : undoStack // ignore: cast_nullable_to_non_nullable
as List<AnalysisDashboard>,redoStack: null == redoStack ? _self.redoStack : redoStack // ignore: cast_nullable_to_non_nullable
as List<AnalysisDashboard>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of AnalysisBuilderState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalysisDashboardCopyWith<$Res> get dashboard {
  
  return $AnalysisDashboardCopyWith<$Res>(_self.dashboard, (value) {
    return _then(_self.copyWith(dashboard: value));
  });
}
}


/// Adds pattern-matching-related methods to [AnalysisBuilderState].
extension AnalysisBuilderStatePatterns on AnalysisBuilderState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalysisBuilderState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalysisBuilderState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalysisBuilderState value)  $default,){
final _that = this;
switch (_that) {
case _AnalysisBuilderState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalysisBuilderState value)?  $default,){
final _that = this;
switch (_that) {
case _AnalysisBuilderState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AnalysisDashboard dashboard,  String? selectedWidgetId,  bool isSaving,  bool isLoading,  List<AnalysisDashboard> undoStack,  List<AnalysisDashboard> redoStack,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalysisBuilderState() when $default != null:
return $default(_that.dashboard,_that.selectedWidgetId,_that.isSaving,_that.isLoading,_that.undoStack,_that.redoStack,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AnalysisDashboard dashboard,  String? selectedWidgetId,  bool isSaving,  bool isLoading,  List<AnalysisDashboard> undoStack,  List<AnalysisDashboard> redoStack,  String? error)  $default,) {final _that = this;
switch (_that) {
case _AnalysisBuilderState():
return $default(_that.dashboard,_that.selectedWidgetId,_that.isSaving,_that.isLoading,_that.undoStack,_that.redoStack,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AnalysisDashboard dashboard,  String? selectedWidgetId,  bool isSaving,  bool isLoading,  List<AnalysisDashboard> undoStack,  List<AnalysisDashboard> redoStack,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _AnalysisBuilderState() when $default != null:
return $default(_that.dashboard,_that.selectedWidgetId,_that.isSaving,_that.isLoading,_that.undoStack,_that.redoStack,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _AnalysisBuilderState implements AnalysisBuilderState {
  const _AnalysisBuilderState({required this.dashboard, this.selectedWidgetId, this.isSaving = false, this.isLoading = false, final  List<AnalysisDashboard> undoStack = const [], final  List<AnalysisDashboard> redoStack = const [], this.error}): _undoStack = undoStack,_redoStack = redoStack;
  

@override final  AnalysisDashboard dashboard;
@override final  String? selectedWidgetId;
@override@JsonKey() final  bool isSaving;
@override@JsonKey() final  bool isLoading;
 final  List<AnalysisDashboard> _undoStack;
@override@JsonKey() List<AnalysisDashboard> get undoStack {
  if (_undoStack is EqualUnmodifiableListView) return _undoStack;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_undoStack);
}

 final  List<AnalysisDashboard> _redoStack;
@override@JsonKey() List<AnalysisDashboard> get redoStack {
  if (_redoStack is EqualUnmodifiableListView) return _redoStack;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_redoStack);
}

@override final  String? error;

/// Create a copy of AnalysisBuilderState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalysisBuilderStateCopyWith<_AnalysisBuilderState> get copyWith => __$AnalysisBuilderStateCopyWithImpl<_AnalysisBuilderState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalysisBuilderState&&(identical(other.dashboard, dashboard) || other.dashboard == dashboard)&&(identical(other.selectedWidgetId, selectedWidgetId) || other.selectedWidgetId == selectedWidgetId)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._undoStack, _undoStack)&&const DeepCollectionEquality().equals(other._redoStack, _redoStack)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,dashboard,selectedWidgetId,isSaving,isLoading,const DeepCollectionEquality().hash(_undoStack),const DeepCollectionEquality().hash(_redoStack),error);

@override
String toString() {
  return 'AnalysisBuilderState(dashboard: $dashboard, selectedWidgetId: $selectedWidgetId, isSaving: $isSaving, isLoading: $isLoading, undoStack: $undoStack, redoStack: $redoStack, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AnalysisBuilderStateCopyWith<$Res> implements $AnalysisBuilderStateCopyWith<$Res> {
  factory _$AnalysisBuilderStateCopyWith(_AnalysisBuilderState value, $Res Function(_AnalysisBuilderState) _then) = __$AnalysisBuilderStateCopyWithImpl;
@override @useResult
$Res call({
 AnalysisDashboard dashboard, String? selectedWidgetId, bool isSaving, bool isLoading, List<AnalysisDashboard> undoStack, List<AnalysisDashboard> redoStack, String? error
});


@override $AnalysisDashboardCopyWith<$Res> get dashboard;

}
/// @nodoc
class __$AnalysisBuilderStateCopyWithImpl<$Res>
    implements _$AnalysisBuilderStateCopyWith<$Res> {
  __$AnalysisBuilderStateCopyWithImpl(this._self, this._then);

  final _AnalysisBuilderState _self;
  final $Res Function(_AnalysisBuilderState) _then;

/// Create a copy of AnalysisBuilderState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dashboard = null,Object? selectedWidgetId = freezed,Object? isSaving = null,Object? isLoading = null,Object? undoStack = null,Object? redoStack = null,Object? error = freezed,}) {
  return _then(_AnalysisBuilderState(
dashboard: null == dashboard ? _self.dashboard : dashboard // ignore: cast_nullable_to_non_nullable
as AnalysisDashboard,selectedWidgetId: freezed == selectedWidgetId ? _self.selectedWidgetId : selectedWidgetId // ignore: cast_nullable_to_non_nullable
as String?,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,undoStack: null == undoStack ? _self._undoStack : undoStack // ignore: cast_nullable_to_non_nullable
as List<AnalysisDashboard>,redoStack: null == redoStack ? _self._redoStack : redoStack // ignore: cast_nullable_to_non_nullable
as List<AnalysisDashboard>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of AnalysisBuilderState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalysisDashboardCopyWith<$Res> get dashboard {
  
  return $AnalysisDashboardCopyWith<$Res>(_self.dashboard, (value) {
    return _then(_self.copyWith(dashboard: value));
  });
}
}

// dart format on

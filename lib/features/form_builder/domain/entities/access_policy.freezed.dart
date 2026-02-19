// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'access_policy.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccessPolicy {

 List<String> get canViewResponses; List<String> get canEditResponses; List<String> get canDeleteResponses; String get responseVisibility;// 'all', 'own_only', 'department_only'
 List<String> get canCreateVersions; List<String> get canEditDesign; List<String> get canCloneForm; List<String> get canManageAccess; List<String> get canViewAuditLogs; List<String> get canDeleteForm; String get formVisibility;// 'public', 'private', 'restricted'
 List<String> get allowedDepartments;
/// Create a copy of AccessPolicy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccessPolicyCopyWith<AccessPolicy> get copyWith => _$AccessPolicyCopyWithImpl<AccessPolicy>(this as AccessPolicy, _$identity);

  /// Serializes this AccessPolicy to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccessPolicy&&const DeepCollectionEquality().equals(other.canViewResponses, canViewResponses)&&const DeepCollectionEquality().equals(other.canEditResponses, canEditResponses)&&const DeepCollectionEquality().equals(other.canDeleteResponses, canDeleteResponses)&&(identical(other.responseVisibility, responseVisibility) || other.responseVisibility == responseVisibility)&&const DeepCollectionEquality().equals(other.canCreateVersions, canCreateVersions)&&const DeepCollectionEquality().equals(other.canEditDesign, canEditDesign)&&const DeepCollectionEquality().equals(other.canCloneForm, canCloneForm)&&const DeepCollectionEquality().equals(other.canManageAccess, canManageAccess)&&const DeepCollectionEquality().equals(other.canViewAuditLogs, canViewAuditLogs)&&const DeepCollectionEquality().equals(other.canDeleteForm, canDeleteForm)&&(identical(other.formVisibility, formVisibility) || other.formVisibility == formVisibility)&&const DeepCollectionEquality().equals(other.allowedDepartments, allowedDepartments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(canViewResponses),const DeepCollectionEquality().hash(canEditResponses),const DeepCollectionEquality().hash(canDeleteResponses),responseVisibility,const DeepCollectionEquality().hash(canCreateVersions),const DeepCollectionEquality().hash(canEditDesign),const DeepCollectionEquality().hash(canCloneForm),const DeepCollectionEquality().hash(canManageAccess),const DeepCollectionEquality().hash(canViewAuditLogs),const DeepCollectionEquality().hash(canDeleteForm),formVisibility,const DeepCollectionEquality().hash(allowedDepartments));

@override
String toString() {
  return 'AccessPolicy(canViewResponses: $canViewResponses, canEditResponses: $canEditResponses, canDeleteResponses: $canDeleteResponses, responseVisibility: $responseVisibility, canCreateVersions: $canCreateVersions, canEditDesign: $canEditDesign, canCloneForm: $canCloneForm, canManageAccess: $canManageAccess, canViewAuditLogs: $canViewAuditLogs, canDeleteForm: $canDeleteForm, formVisibility: $formVisibility, allowedDepartments: $allowedDepartments)';
}


}

/// @nodoc
abstract mixin class $AccessPolicyCopyWith<$Res>  {
  factory $AccessPolicyCopyWith(AccessPolicy value, $Res Function(AccessPolicy) _then) = _$AccessPolicyCopyWithImpl;
@useResult
$Res call({
 List<String> canViewResponses, List<String> canEditResponses, List<String> canDeleteResponses, String responseVisibility, List<String> canCreateVersions, List<String> canEditDesign, List<String> canCloneForm, List<String> canManageAccess, List<String> canViewAuditLogs, List<String> canDeleteForm, String formVisibility, List<String> allowedDepartments
});




}
/// @nodoc
class _$AccessPolicyCopyWithImpl<$Res>
    implements $AccessPolicyCopyWith<$Res> {
  _$AccessPolicyCopyWithImpl(this._self, this._then);

  final AccessPolicy _self;
  final $Res Function(AccessPolicy) _then;

/// Create a copy of AccessPolicy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? canViewResponses = null,Object? canEditResponses = null,Object? canDeleteResponses = null,Object? responseVisibility = null,Object? canCreateVersions = null,Object? canEditDesign = null,Object? canCloneForm = null,Object? canManageAccess = null,Object? canViewAuditLogs = null,Object? canDeleteForm = null,Object? formVisibility = null,Object? allowedDepartments = null,}) {
  return _then(_self.copyWith(
canViewResponses: null == canViewResponses ? _self.canViewResponses : canViewResponses // ignore: cast_nullable_to_non_nullable
as List<String>,canEditResponses: null == canEditResponses ? _self.canEditResponses : canEditResponses // ignore: cast_nullable_to_non_nullable
as List<String>,canDeleteResponses: null == canDeleteResponses ? _self.canDeleteResponses : canDeleteResponses // ignore: cast_nullable_to_non_nullable
as List<String>,responseVisibility: null == responseVisibility ? _self.responseVisibility : responseVisibility // ignore: cast_nullable_to_non_nullable
as String,canCreateVersions: null == canCreateVersions ? _self.canCreateVersions : canCreateVersions // ignore: cast_nullable_to_non_nullable
as List<String>,canEditDesign: null == canEditDesign ? _self.canEditDesign : canEditDesign // ignore: cast_nullable_to_non_nullable
as List<String>,canCloneForm: null == canCloneForm ? _self.canCloneForm : canCloneForm // ignore: cast_nullable_to_non_nullable
as List<String>,canManageAccess: null == canManageAccess ? _self.canManageAccess : canManageAccess // ignore: cast_nullable_to_non_nullable
as List<String>,canViewAuditLogs: null == canViewAuditLogs ? _self.canViewAuditLogs : canViewAuditLogs // ignore: cast_nullable_to_non_nullable
as List<String>,canDeleteForm: null == canDeleteForm ? _self.canDeleteForm : canDeleteForm // ignore: cast_nullable_to_non_nullable
as List<String>,formVisibility: null == formVisibility ? _self.formVisibility : formVisibility // ignore: cast_nullable_to_non_nullable
as String,allowedDepartments: null == allowedDepartments ? _self.allowedDepartments : allowedDepartments // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AccessPolicy].
extension AccessPolicyPatterns on AccessPolicy {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccessPolicy value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccessPolicy() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccessPolicy value)  $default,){
final _that = this;
switch (_that) {
case _AccessPolicy():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccessPolicy value)?  $default,){
final _that = this;
switch (_that) {
case _AccessPolicy() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> canViewResponses,  List<String> canEditResponses,  List<String> canDeleteResponses,  String responseVisibility,  List<String> canCreateVersions,  List<String> canEditDesign,  List<String> canCloneForm,  List<String> canManageAccess,  List<String> canViewAuditLogs,  List<String> canDeleteForm,  String formVisibility,  List<String> allowedDepartments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccessPolicy() when $default != null:
return $default(_that.canViewResponses,_that.canEditResponses,_that.canDeleteResponses,_that.responseVisibility,_that.canCreateVersions,_that.canEditDesign,_that.canCloneForm,_that.canManageAccess,_that.canViewAuditLogs,_that.canDeleteForm,_that.formVisibility,_that.allowedDepartments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> canViewResponses,  List<String> canEditResponses,  List<String> canDeleteResponses,  String responseVisibility,  List<String> canCreateVersions,  List<String> canEditDesign,  List<String> canCloneForm,  List<String> canManageAccess,  List<String> canViewAuditLogs,  List<String> canDeleteForm,  String formVisibility,  List<String> allowedDepartments)  $default,) {final _that = this;
switch (_that) {
case _AccessPolicy():
return $default(_that.canViewResponses,_that.canEditResponses,_that.canDeleteResponses,_that.responseVisibility,_that.canCreateVersions,_that.canEditDesign,_that.canCloneForm,_that.canManageAccess,_that.canViewAuditLogs,_that.canDeleteForm,_that.formVisibility,_that.allowedDepartments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> canViewResponses,  List<String> canEditResponses,  List<String> canDeleteResponses,  String responseVisibility,  List<String> canCreateVersions,  List<String> canEditDesign,  List<String> canCloneForm,  List<String> canManageAccess,  List<String> canViewAuditLogs,  List<String> canDeleteForm,  String formVisibility,  List<String> allowedDepartments)?  $default,) {final _that = this;
switch (_that) {
case _AccessPolicy() when $default != null:
return $default(_that.canViewResponses,_that.canEditResponses,_that.canDeleteResponses,_that.responseVisibility,_that.canCreateVersions,_that.canEditDesign,_that.canCloneForm,_that.canManageAccess,_that.canViewAuditLogs,_that.canDeleteForm,_that.formVisibility,_that.allowedDepartments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccessPolicy implements AccessPolicy {
  const _AccessPolicy({final  List<String> canViewResponses = const [], final  List<String> canEditResponses = const [], final  List<String> canDeleteResponses = const [], this.responseVisibility = 'all', final  List<String> canCreateVersions = const [], final  List<String> canEditDesign = const [], final  List<String> canCloneForm = const [], final  List<String> canManageAccess = const [], final  List<String> canViewAuditLogs = const [], final  List<String> canDeleteForm = const [], this.formVisibility = 'private', final  List<String> allowedDepartments = const []}): _canViewResponses = canViewResponses,_canEditResponses = canEditResponses,_canDeleteResponses = canDeleteResponses,_canCreateVersions = canCreateVersions,_canEditDesign = canEditDesign,_canCloneForm = canCloneForm,_canManageAccess = canManageAccess,_canViewAuditLogs = canViewAuditLogs,_canDeleteForm = canDeleteForm,_allowedDepartments = allowedDepartments;
  factory _AccessPolicy.fromJson(Map<String, dynamic> json) => _$AccessPolicyFromJson(json);

 final  List<String> _canViewResponses;
@override@JsonKey() List<String> get canViewResponses {
  if (_canViewResponses is EqualUnmodifiableListView) return _canViewResponses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_canViewResponses);
}

 final  List<String> _canEditResponses;
@override@JsonKey() List<String> get canEditResponses {
  if (_canEditResponses is EqualUnmodifiableListView) return _canEditResponses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_canEditResponses);
}

 final  List<String> _canDeleteResponses;
@override@JsonKey() List<String> get canDeleteResponses {
  if (_canDeleteResponses is EqualUnmodifiableListView) return _canDeleteResponses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_canDeleteResponses);
}

@override@JsonKey() final  String responseVisibility;
// 'all', 'own_only', 'department_only'
 final  List<String> _canCreateVersions;
// 'all', 'own_only', 'department_only'
@override@JsonKey() List<String> get canCreateVersions {
  if (_canCreateVersions is EqualUnmodifiableListView) return _canCreateVersions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_canCreateVersions);
}

 final  List<String> _canEditDesign;
@override@JsonKey() List<String> get canEditDesign {
  if (_canEditDesign is EqualUnmodifiableListView) return _canEditDesign;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_canEditDesign);
}

 final  List<String> _canCloneForm;
@override@JsonKey() List<String> get canCloneForm {
  if (_canCloneForm is EqualUnmodifiableListView) return _canCloneForm;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_canCloneForm);
}

 final  List<String> _canManageAccess;
@override@JsonKey() List<String> get canManageAccess {
  if (_canManageAccess is EqualUnmodifiableListView) return _canManageAccess;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_canManageAccess);
}

 final  List<String> _canViewAuditLogs;
@override@JsonKey() List<String> get canViewAuditLogs {
  if (_canViewAuditLogs is EqualUnmodifiableListView) return _canViewAuditLogs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_canViewAuditLogs);
}

 final  List<String> _canDeleteForm;
@override@JsonKey() List<String> get canDeleteForm {
  if (_canDeleteForm is EqualUnmodifiableListView) return _canDeleteForm;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_canDeleteForm);
}

@override@JsonKey() final  String formVisibility;
// 'public', 'private', 'restricted'
 final  List<String> _allowedDepartments;
// 'public', 'private', 'restricted'
@override@JsonKey() List<String> get allowedDepartments {
  if (_allowedDepartments is EqualUnmodifiableListView) return _allowedDepartments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allowedDepartments);
}


/// Create a copy of AccessPolicy
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccessPolicyCopyWith<_AccessPolicy> get copyWith => __$AccessPolicyCopyWithImpl<_AccessPolicy>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccessPolicyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccessPolicy&&const DeepCollectionEquality().equals(other._canViewResponses, _canViewResponses)&&const DeepCollectionEquality().equals(other._canEditResponses, _canEditResponses)&&const DeepCollectionEquality().equals(other._canDeleteResponses, _canDeleteResponses)&&(identical(other.responseVisibility, responseVisibility) || other.responseVisibility == responseVisibility)&&const DeepCollectionEquality().equals(other._canCreateVersions, _canCreateVersions)&&const DeepCollectionEquality().equals(other._canEditDesign, _canEditDesign)&&const DeepCollectionEquality().equals(other._canCloneForm, _canCloneForm)&&const DeepCollectionEquality().equals(other._canManageAccess, _canManageAccess)&&const DeepCollectionEquality().equals(other._canViewAuditLogs, _canViewAuditLogs)&&const DeepCollectionEquality().equals(other._canDeleteForm, _canDeleteForm)&&(identical(other.formVisibility, formVisibility) || other.formVisibility == formVisibility)&&const DeepCollectionEquality().equals(other._allowedDepartments, _allowedDepartments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_canViewResponses),const DeepCollectionEquality().hash(_canEditResponses),const DeepCollectionEquality().hash(_canDeleteResponses),responseVisibility,const DeepCollectionEquality().hash(_canCreateVersions),const DeepCollectionEquality().hash(_canEditDesign),const DeepCollectionEquality().hash(_canCloneForm),const DeepCollectionEquality().hash(_canManageAccess),const DeepCollectionEquality().hash(_canViewAuditLogs),const DeepCollectionEquality().hash(_canDeleteForm),formVisibility,const DeepCollectionEquality().hash(_allowedDepartments));

@override
String toString() {
  return 'AccessPolicy(canViewResponses: $canViewResponses, canEditResponses: $canEditResponses, canDeleteResponses: $canDeleteResponses, responseVisibility: $responseVisibility, canCreateVersions: $canCreateVersions, canEditDesign: $canEditDesign, canCloneForm: $canCloneForm, canManageAccess: $canManageAccess, canViewAuditLogs: $canViewAuditLogs, canDeleteForm: $canDeleteForm, formVisibility: $formVisibility, allowedDepartments: $allowedDepartments)';
}


}

/// @nodoc
abstract mixin class _$AccessPolicyCopyWith<$Res> implements $AccessPolicyCopyWith<$Res> {
  factory _$AccessPolicyCopyWith(_AccessPolicy value, $Res Function(_AccessPolicy) _then) = __$AccessPolicyCopyWithImpl;
@override @useResult
$Res call({
 List<String> canViewResponses, List<String> canEditResponses, List<String> canDeleteResponses, String responseVisibility, List<String> canCreateVersions, List<String> canEditDesign, List<String> canCloneForm, List<String> canManageAccess, List<String> canViewAuditLogs, List<String> canDeleteForm, String formVisibility, List<String> allowedDepartments
});




}
/// @nodoc
class __$AccessPolicyCopyWithImpl<$Res>
    implements _$AccessPolicyCopyWith<$Res> {
  __$AccessPolicyCopyWithImpl(this._self, this._then);

  final _AccessPolicy _self;
  final $Res Function(_AccessPolicy) _then;

/// Create a copy of AccessPolicy
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? canViewResponses = null,Object? canEditResponses = null,Object? canDeleteResponses = null,Object? responseVisibility = null,Object? canCreateVersions = null,Object? canEditDesign = null,Object? canCloneForm = null,Object? canManageAccess = null,Object? canViewAuditLogs = null,Object? canDeleteForm = null,Object? formVisibility = null,Object? allowedDepartments = null,}) {
  return _then(_AccessPolicy(
canViewResponses: null == canViewResponses ? _self._canViewResponses : canViewResponses // ignore: cast_nullable_to_non_nullable
as List<String>,canEditResponses: null == canEditResponses ? _self._canEditResponses : canEditResponses // ignore: cast_nullable_to_non_nullable
as List<String>,canDeleteResponses: null == canDeleteResponses ? _self._canDeleteResponses : canDeleteResponses // ignore: cast_nullable_to_non_nullable
as List<String>,responseVisibility: null == responseVisibility ? _self.responseVisibility : responseVisibility // ignore: cast_nullable_to_non_nullable
as String,canCreateVersions: null == canCreateVersions ? _self._canCreateVersions : canCreateVersions // ignore: cast_nullable_to_non_nullable
as List<String>,canEditDesign: null == canEditDesign ? _self._canEditDesign : canEditDesign // ignore: cast_nullable_to_non_nullable
as List<String>,canCloneForm: null == canCloneForm ? _self._canCloneForm : canCloneForm // ignore: cast_nullable_to_non_nullable
as List<String>,canManageAccess: null == canManageAccess ? _self._canManageAccess : canManageAccess // ignore: cast_nullable_to_non_nullable
as List<String>,canViewAuditLogs: null == canViewAuditLogs ? _self._canViewAuditLogs : canViewAuditLogs // ignore: cast_nullable_to_non_nullable
as List<String>,canDeleteForm: null == canDeleteForm ? _self._canDeleteForm : canDeleteForm // ignore: cast_nullable_to_non_nullable
as List<String>,formVisibility: null == formVisibility ? _self.formVisibility : formVisibility // ignore: cast_nullable_to_non_nullable
as String,allowedDepartments: null == allowedDepartments ? _self._allowedDepartments : allowedDepartments // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on

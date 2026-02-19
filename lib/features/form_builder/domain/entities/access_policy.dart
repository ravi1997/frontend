import 'package:freezed_annotation/freezed_annotation.dart';

part 'access_policy.freezed.dart';
part 'access_policy.g.dart';

@freezed
abstract class AccessPolicy with _$AccessPolicy {
  const factory AccessPolicy({
    @Default([]) List<String> canViewResponses,
    @Default([]) List<String> canEditResponses,
    @Default([]) List<String> canDeleteResponses,
    @Default('all')
    String responseVisibility, // 'all', 'own_only', 'department_only'

    @Default([]) List<String> canCreateVersions,
    @Default([]) List<String> canEditDesign,
    @Default([]) List<String> canCloneForm,

    @Default([]) List<String> canManageAccess,
    @Default([]) List<String> canViewAuditLogs,
    @Default([]) List<String> canDeleteForm,

    @Default('private')
    String formVisibility, // 'public', 'private', 'restricted'
    @Default([]) List<String> allowedDepartments,
  }) = _AccessPolicy;

  factory AccessPolicy.fromJson(Map<String, dynamic> json) =>
      _$AccessPolicyFromJson(json);
}

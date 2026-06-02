class AccessPolicy {
  final List<String> canViewResponses;
  final List<String> canEditResponses;
  final List<String> canDeleteResponses;
  final String responseVisibility; // 'all', 'own_only', 'department_only'

  final List<String> canCreateVersions;
  final List<String> canEditDesign;
  final List<String> canCloneForm;

  final List<String> canManageAccess;
  final List<String> canViewAuditLogs;
  final List<String> canDeleteForm;

  final String formVisibility; // 'public', 'private', 'restricted'
  final List<String> allowedDepartments;

  AccessPolicy({
    this.canViewResponses = const [],
    this.canEditResponses = const [],
    this.canDeleteResponses = const [],
    this.responseVisibility = 'all',
    this.canCreateVersions = const [],
    this.canEditDesign = const [],
    this.canCloneForm = const [],
    this.canManageAccess = const [],
    this.canViewAuditLogs = const [],
    this.canDeleteForm = const [],
    this.formVisibility = 'private',
    this.allowedDepartments = const [],
  });

  factory AccessPolicy.fromJson(Map<String, dynamic> json) {
    return AccessPolicy(
      canViewResponses: List<String>.from(json['canViewResponses'] ?? []),
      canEditResponses: List<String>.from(json['canEditResponses'] ?? []),
      canDeleteResponses: List<String>.from(json['canDeleteResponses'] ?? []),
      responseVisibility: json['responseVisibility'] as String? ?? 'all',
      canCreateVersions: List<String>.from(json['canCreateVersions'] ?? []),
      canEditDesign: List<String>.from(json['canEditDesign'] ?? []),
      canCloneForm: List<String>.from(json['canCloneForm'] ?? []),
      canManageAccess: List<String>.from(json['canManageAccess'] ?? []),
      canViewAuditLogs: List<String>.from(json['canViewAuditLogs'] ?? []),
      canDeleteForm: List<String>.from(json['canDeleteForm'] ?? []),
      formVisibility: json['formVisibility'] as String? ?? 'private',
      allowedDepartments: List<String>.from(json['allowedDepartments'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'canViewResponses': canViewResponses,
      'canEditResponses': canEditResponses,
      'canDeleteResponses': canDeleteResponses,
      'responseVisibility': responseVisibility,
      'canCreateVersions': canCreateVersions,
      'canEditDesign': canEditDesign,
      'canCloneForm': canCloneForm,
      'canManageAccess': canManageAccess,
      'canViewAuditLogs': canViewAuditLogs,
      'canDeleteForm': canDeleteForm,
      'formVisibility': formVisibility,
      'allowedDepartments': allowedDepartments,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is AccessPolicy &&
      other.canViewResponses.toString() == canViewResponses.toString() &&
      other.canEditResponses.toString() == canEditResponses.toString() &&
      other.canDeleteResponses.toString() == canDeleteResponses.toString() &&
      other.responseVisibility == responseVisibility &&
      other.canCreateVersions.toString() == canCreateVersions.toString() &&
      other.canEditDesign.toString() == canEditDesign.toString() &&
      other.canCloneForm.toString() == canCloneForm.toString() &&
      other.canManageAccess.toString() == canManageAccess.toString() &&
      other.canViewAuditLogs.toString() == canViewAuditLogs.toString() &&
      other.canDeleteForm.toString() == canDeleteForm.toString() &&
      other.formVisibility == formVisibility &&
      other.allowedDepartments.toString() == allowedDepartments.toString();
  }

  @override
  int get hashCode {
    return canViewResponses.hashCode ^
      canEditResponses.hashCode ^
      canDeleteResponses.hashCode ^
      responseVisibility.hashCode ^
      canCreateVersions.hashCode ^
      canEditDesign.hashCode ^
      canCloneForm.hashCode ^
      canManageAccess.hashCode ^
      canViewAuditLogs.hashCode ^
      canDeleteForm.hashCode ^
      formVisibility.hashCode ^
      allowedDepartments.hashCode;
  }

  AccessPolicy copyWith({
    List<String>? canViewResponses,
    List<String>? canEditResponses,
    List<String>? canDeleteResponses,
    String? responseVisibility,
    List<String>? canCreateVersions,
    List<String>? canEditDesign,
    List<String>? canCloneForm,
    List<String>? canManageAccess,
    List<String>? canViewAuditLogs,
    List<String>? canDeleteForm,
    String? formVisibility,
    List<String>? allowedDepartments,
  }) {
    return AccessPolicy(
      canViewResponses: canViewResponses ?? this.canViewResponses,
      canEditResponses: canEditResponses ?? this.canEditResponses,
      canDeleteResponses: canDeleteResponses ?? this.canDeleteResponses,
      responseVisibility: responseVisibility ?? this.responseVisibility,
      canCreateVersions: canCreateVersions ?? this.canCreateVersions,
      canEditDesign: canEditDesign ?? this.canEditDesign,
      canCloneForm: canCloneForm ?? this.canCloneForm,
      canManageAccess: canManageAccess ?? this.canManageAccess,
      canViewAuditLogs: canViewAuditLogs ?? this.canViewAuditLogs,
      canDeleteForm: canDeleteForm ?? this.canDeleteForm,
      formVisibility: formVisibility ?? this.formVisibility,
      allowedDepartments: allowedDepartments ?? this.allowedDepartments,
    );
  }
}
class AccessPolicy {
  // New form access/privacy controls.
  final String accessMode; // 'public' | 'private'
  final List<String> allowedUserIds;
  final List<String> allowedGroupIds;
  final List<String> allowedRoles;
  final bool requireLogin;
  final String? privateAccessMessage;

  final bool passwordProtected;
  final String? passwordHash;
  final String? passwordHint;
  final bool passwordPromptEnabled;

  final bool inviteOnly;
  final List<Map<String, dynamic>> invites;
  final bool inviteRequiredForSubmission;

  final bool submissionLimitEnabled;
  final int? submissionLimitCount;
  final String submissionLimitScope; // 'total' | 'user' | 'email' | 'ip'
  final String submissionLimitAction; // 'close' | 'soft_warn' | 'block_submit'
  final String? limitReachedMessage;

  final String responseIdentityMode; // 'anonymous' | 'identified'
  final bool requireLoginForResponse;
  final bool collectName;
  final bool collectEmail;
  final bool storeUserIdOnResponse;

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
    this.accessMode = 'public',
    this.allowedUserIds = const [],
    this.allowedGroupIds = const [],
    this.allowedRoles = const [],
    this.requireLogin = false,
    this.privateAccessMessage,
    this.passwordProtected = false,
    this.passwordHash,
    this.passwordHint,
    this.passwordPromptEnabled = false,
    this.inviteOnly = false,
    this.invites = const [],
    this.inviteRequiredForSubmission = false,
    this.submissionLimitEnabled = false,
    this.submissionLimitCount,
    this.submissionLimitScope = 'total',
    this.submissionLimitAction = 'close',
    this.limitReachedMessage,
    this.responseIdentityMode = 'anonymous',
    this.requireLoginForResponse = false,
    this.collectName = false,
    this.collectEmail = false,
    this.storeUserIdOnResponse = false,
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
      accessMode:
          json['accessMode'] as String? ??
          json['access_mode'] as String? ??
          'public',
      allowedUserIds: List<String>.from(
        json['allowedUserIds'] ?? json['allowed_user_ids'] ?? [],
      ),
      allowedGroupIds: List<String>.from(
        json['allowedGroupIds'] ?? json['allowed_group_ids'] ?? [],
      ),
      allowedRoles: List<String>.from(
        json['allowedRoles'] ?? json['allowed_roles'] ?? [],
      ),
      requireLogin:
          json['requireLogin'] as bool? ??
          json['require_login'] as bool? ??
          false,
      privateAccessMessage:
          json['privateAccessMessage'] as String? ??
          json['private_access_message'] as String?,
      passwordProtected:
          json['passwordProtected'] as bool? ??
          json['password_protected'] as bool? ??
          false,
      passwordHash:
          json['passwordHash'] as String? ?? json['password_hash'] as String?,
      passwordHint:
          json['passwordHint'] as String? ?? json['password_hint'] as String?,
      passwordPromptEnabled:
          json['passwordPromptEnabled'] as bool? ??
          json['password_prompt_enabled'] as bool? ??
          false,
      inviteOnly:
          json['inviteOnly'] as bool? ?? json['invite_only'] as bool? ?? false,
      invites: (json['invites'] as List? ?? const [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList(),
      inviteRequiredForSubmission:
          json['inviteRequiredForSubmission'] as bool? ??
          json['invite_required_for_submission'] as bool? ??
          false,
      submissionLimitEnabled:
          json['submissionLimitEnabled'] as bool? ??
          json['submission_limit_enabled'] as bool? ??
          false,
      submissionLimitCount:
          (json['submissionLimitCount'] as num?)?.toInt() ??
          (json['submission_limit_count'] as num?)?.toInt(),
      submissionLimitScope:
          json['submissionLimitScope'] as String? ??
          json['submission_limit_scope'] as String? ??
          'total',
      submissionLimitAction:
          json['submissionLimitAction'] as String? ??
          json['submission_limit_action'] as String? ??
          'close',
      limitReachedMessage:
          json['limitReachedMessage'] as String? ??
          json['limit_reached_message'] as String?,
      responseIdentityMode:
          json['responseIdentityMode'] as String? ??
          json['response_identity_mode'] as String? ??
          'anonymous',
      requireLoginForResponse:
          json['requireLoginForResponse'] as bool? ??
          json['require_login_for_response'] as bool? ??
          false,
      collectName:
          json['collectName'] as bool? ??
          json['collect_name'] as bool? ??
          false,
      collectEmail:
          json['collectEmail'] as bool? ??
          json['collect_email'] as bool? ??
          false,
      storeUserIdOnResponse:
          json['storeUserIdOnResponse'] as bool? ??
          json['store_user_id_on_response'] as bool? ??
          false,
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
      'accessMode': accessMode,
      'allowedUserIds': allowedUserIds,
      'allowedGroupIds': allowedGroupIds,
      'allowedRoles': allowedRoles,
      'requireLogin': requireLogin,
      'privateAccessMessage': privateAccessMessage,
      'passwordProtected': passwordProtected,
      'passwordHash': passwordHash,
      'passwordHint': passwordHint,
      'passwordPromptEnabled': passwordPromptEnabled,
      'inviteOnly': inviteOnly,
      'invites': invites,
      'inviteRequiredForSubmission': inviteRequiredForSubmission,
      'submissionLimitEnabled': submissionLimitEnabled,
      'submissionLimitCount': submissionLimitCount,
      'submissionLimitScope': submissionLimitScope,
      'submissionLimitAction': submissionLimitAction,
      'limitReachedMessage': limitReachedMessage,
      'responseIdentityMode': responseIdentityMode,
      'requireLoginForResponse': requireLoginForResponse,
      'collectName': collectName,
      'collectEmail': collectEmail,
      'storeUserIdOnResponse': storeUserIdOnResponse,
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
        other.accessMode == accessMode &&
        other.allowedUserIds.toString() == allowedUserIds.toString() &&
        other.allowedGroupIds.toString() == allowedGroupIds.toString() &&
        other.allowedRoles.toString() == allowedRoles.toString() &&
        other.requireLogin == requireLogin &&
        other.privateAccessMessage == privateAccessMessage &&
        other.passwordProtected == passwordProtected &&
        other.passwordHash == passwordHash &&
        other.passwordHint == passwordHint &&
        other.passwordPromptEnabled == passwordPromptEnabled &&
        other.inviteOnly == inviteOnly &&
        other.invites.toString() == invites.toString() &&
        other.inviteRequiredForSubmission == inviteRequiredForSubmission &&
        other.submissionLimitEnabled == submissionLimitEnabled &&
        other.submissionLimitCount == submissionLimitCount &&
        other.submissionLimitScope == submissionLimitScope &&
        other.submissionLimitAction == submissionLimitAction &&
        other.limitReachedMessage == limitReachedMessage &&
        other.responseIdentityMode == responseIdentityMode &&
        other.requireLoginForResponse == requireLoginForResponse &&
        other.collectName == collectName &&
        other.collectEmail == collectEmail &&
        other.storeUserIdOnResponse == storeUserIdOnResponse &&
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
        accessMode.hashCode ^
        allowedUserIds.hashCode ^
        allowedGroupIds.hashCode ^
        allowedRoles.hashCode ^
        requireLogin.hashCode ^
        privateAccessMessage.hashCode ^
        passwordProtected.hashCode ^
        passwordHash.hashCode ^
        passwordHint.hashCode ^
        passwordPromptEnabled.hashCode ^
        inviteOnly.hashCode ^
        invites.hashCode ^
        inviteRequiredForSubmission.hashCode ^
        submissionLimitEnabled.hashCode ^
        submissionLimitCount.hashCode ^
        submissionLimitScope.hashCode ^
        submissionLimitAction.hashCode ^
        limitReachedMessage.hashCode ^
        responseIdentityMode.hashCode ^
        requireLoginForResponse.hashCode ^
        collectName.hashCode ^
        collectEmail.hashCode ^
        storeUserIdOnResponse.hashCode ^
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
    String? accessMode,
    List<String>? allowedUserIds,
    List<String>? allowedGroupIds,
    List<String>? allowedRoles,
    bool? requireLogin,
    String? privateAccessMessage,
    bool? passwordProtected,
    String? passwordHash,
    String? passwordHint,
    bool? passwordPromptEnabled,
    bool? inviteOnly,
    List<Map<String, dynamic>>? invites,
    bool? inviteRequiredForSubmission,
    bool? submissionLimitEnabled,
    int? submissionLimitCount,
    String? submissionLimitScope,
    String? submissionLimitAction,
    String? limitReachedMessage,
    String? responseIdentityMode,
    bool? requireLoginForResponse,
    bool? collectName,
    bool? collectEmail,
    bool? storeUserIdOnResponse,
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
      accessMode: accessMode ?? this.accessMode,
      allowedUserIds: allowedUserIds ?? this.allowedUserIds,
      allowedGroupIds: allowedGroupIds ?? this.allowedGroupIds,
      allowedRoles: allowedRoles ?? this.allowedRoles,
      requireLogin: requireLogin ?? this.requireLogin,
      privateAccessMessage: privateAccessMessage ?? this.privateAccessMessage,
      passwordProtected: passwordProtected ?? this.passwordProtected,
      passwordHash: passwordHash ?? this.passwordHash,
      passwordHint: passwordHint ?? this.passwordHint,
      passwordPromptEnabled:
          passwordPromptEnabled ?? this.passwordPromptEnabled,
      inviteOnly: inviteOnly ?? this.inviteOnly,
      invites: invites ?? this.invites,
      inviteRequiredForSubmission:
          inviteRequiredForSubmission ?? this.inviteRequiredForSubmission,
      submissionLimitEnabled:
          submissionLimitEnabled ?? this.submissionLimitEnabled,
      submissionLimitCount: submissionLimitCount ?? this.submissionLimitCount,
      submissionLimitScope: submissionLimitScope ?? this.submissionLimitScope,
      submissionLimitAction:
          submissionLimitAction ?? this.submissionLimitAction,
      limitReachedMessage: limitReachedMessage ?? this.limitReachedMessage,
      responseIdentityMode: responseIdentityMode ?? this.responseIdentityMode,
      requireLoginForResponse:
          requireLoginForResponse ?? this.requireLoginForResponse,
      collectName: collectName ?? this.collectName,
      collectEmail: collectEmail ?? this.collectEmail,
      storeUserIdOnResponse:
          storeUserIdOnResponse ?? this.storeUserIdOnResponse,
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

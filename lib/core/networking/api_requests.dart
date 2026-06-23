class LoginRequest {
  final String identifier;
  final String password;

  const LoginRequest({
    required this.identifier,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'identifier': identifier,
        'password': password,
      };
}

class OtpLoginRequest {
  final String mobile;
  final String otp;

  const OtpLoginRequest({
    required this.mobile,
    required this.otp,
  });

  Map<String, dynamic> toJson() => {'mobile': mobile, 'otp': otp};
}

class OtpRequest {
  final String mobile;

  const OtpRequest({required this.mobile});

  Map<String, dynamic> toJson() => {'mobile': mobile};
}

class PasswordResetRequest {
  final String email;

  const PasswordResetRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}

class RegisterRequest {
  final String username;
  final String email;
  final String password;
  final String? employeeId;
  final String? mobile;

  const RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
    this.employeeId,
    this.mobile,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
        'user_type': 'general',
        if (employeeId != null) 'employee_id': employeeId,
        if (mobile != null) 'mobile': mobile,
      };
}

class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
        'current_password': currentPassword,
        'new_password': newPassword,
      };
}

class ProjectRequest {
  final String name;
  final String? description;
  final String? helpText;

  const ProjectRequest({
    required this.name,
    this.description,
    this.helpText,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (description != null) 'description': description,
        if (helpText != null) 'help_text': helpText,
      };
}

class CreateFormRequest {
  final String title;
  final String? slug;
  final String defaultLanguage;
  final List<String> supportedLanguages;

  const CreateFormRequest({
    required this.title,
    this.slug,
    this.defaultLanguage = 'en',
    this.supportedLanguages = const ['en'],
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        if (slug != null && slug!.isNotEmpty) 'slug': slug,
        'default_language': defaultLanguage,
        'supported_languages': supportedLanguages,
      };
}

class UpdateFormRequest {
  final String title;
  final String status;

  const UpdateFormRequest({
    required this.title,
    required this.status,
  });

  Map<String, dynamic> toJson() => {'title': title, 'status': status};
}

class FormDraftRequest {
  final Map<String, dynamic> formData;

  const FormDraftRequest({required this.formData});

  Map<String, dynamic> toJson() => formData;
}

class PublishRequest {
  final bool major;
  final bool minor;

  const PublishRequest({this.major = false, this.minor = true});

  Map<String, dynamic> toJson() => {'major': major, 'minor': minor};
}

class CloneFormRequest {
  final String? title;
  final String? slug;

  const CloneFormRequest({this.title, this.slug});

  Map<String, dynamic> toJson() => {
        if (title != null) 'title': title,
        if (slug != null) 'slug': slug,
      };
}

class ResponseSubmissionRequest {
  final Map<String, dynamic> responses;
  final Map<String, dynamic>? metadata;
  final String? status;

  const ResponseSubmissionRequest({
    required this.responses,
    this.metadata,
    this.status,
  });

  Map<String, dynamic> toJson() => {
        'responses': responses,
        if (metadata != null) 'metadata': metadata,
        if (status != null) 'status': status,
      };
}

class ResponseFilterRequest {
  final List<Map<String, dynamic>> filters;

  const ResponseFilterRequest({required this.filters});

  Map<String, dynamic> toJson() => {'filters': filters};
}

class TranslationPreviewRequest {
  final String text;
  final String sourceLanguage;
  final String targetLanguage;

  const TranslationPreviewRequest({
    required this.text,
    required this.sourceLanguage,
    required this.targetLanguage,
  });

  Map<String, dynamic> toJson() => {
        'text': text,
        'source_language': sourceLanguage,
        'target_language': targetLanguage,
      };
}

class TranslationJobRequest {
  final String formId;
  final String sourceLanguage;
  final List<String> targetLanguages;
  final String createdBy;
  final int totalFields;

  const TranslationJobRequest({
    required this.formId,
    required this.sourceLanguage,
    required this.targetLanguages,
    required this.createdBy,
    required this.totalFields,
  });

  Map<String, dynamic> toJson() => {
        'form_id': formId,
        'source_language': sourceLanguage,
        'target_languages': targetLanguages,
        'createdBy': createdBy,
        'total_fields': totalFields,
      };
}

class DashboardCreateRequest {
  final String projectId;
  final String name;
  final String? description;

  const DashboardCreateRequest({
    required this.projectId,
    required this.name,
    this.description,
  });

  Map<String, dynamic> toJson() => {
        'project_id': projectId,
        'name': name,
        if (description != null) 'description': description,
        'canvas': {
          'width': 1920,
          'height': 1080,
          'background_color': '#F5F5F5',
          'widgets': <dynamic>[],
        },
        'settings': {
          'auto_refresh': false,
          'refresh_interval_seconds': 60,
        },
      };
}

class DashboardUpdateRequest {
  final String? name;
  final String? description;
  final Map<String, dynamic>? settings;

  const DashboardUpdateRequest({
    this.name,
    this.description,
    this.settings,
  });

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (settings != null) 'settings': settings,
      };
}

class ApiKeyCreateRequest {
  final String name;
  final List<String> scopes;

  const ApiKeyCreateRequest({
    required this.name,
    required this.scopes,
  });

  Map<String, dynamic> toJson() => {'name': name, 'scopes': scopes};
}

class OrgRequest {
  final String name;
  final String? description;

  const OrgRequest({required this.name, this.description});

  Map<String, dynamic> toJson() => {
        'name': name,
        if (description != null) 'description': description,
      };
}

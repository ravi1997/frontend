import 'app_config.dart';

/// Centralized API endpoint constants for the application.
///
/// This file contains all API endpoints used throughout the application,
/// organized by feature area for easy maintenance and updates.
///
/// The backend origin is configured through [AppConfig.apiServerUrl], which
/// reads the `API_BASE_URL` dart-define at build time and falls back to
/// `http://localhost:8051` for local development.
class ApiEndpoints {
  // Base configuration — driven by AppConfig (dart-define or default)
  static String get serverBaseUrl => AppConfig.apiServerUrl;

  static String get baseUrl => AppConfig.apiBaseUrl;

  // ============================================================================
  // Authentication Endpoints (§3)
  // ============================================================================

  /// POST - Login with email/username and password
  /// Body: { "identifier": string, "password": string }
  /// Returns: { "access_token": string, "refresh_token": string, "user": {...} }
  static const String login = '/auth/login';

  /// POST - Login with mobile and OTP
  /// Body: { "mobile": string, "otp": string }
  /// Returns: { "access_token": string, "refresh_token": string, "user": {...} }
  static const String loginWithOtp = '/auth/login';

  /// POST - Request OTP for mobile number
  /// Body: { "mobile": string }
  /// Returns: { "message": string }
  static const String requestOtp = '/auth/request-otp';

  /// POST - Revoke all sessions
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "message": string }
  static const String revokeAll = '/auth/revoke-all';

  /// POST - Register new user
  /// Body: {
  ///   "username": string,
  ///   "email": string,
  ///   "password": string,
  ///   "user_type": string,
  ///   "employee_id": string? (optional),
  ///   "mobile": string,
  ///   "roles": string[]
  /// }
  /// Returns: { "access_token": string, "refresh_token": string, "user": {...} }
  static const String register = '/auth/register';

  /// POST - Refresh access token
  /// Body: { "refresh_token": string }
  /// Returns: { "access_token": string }
  static const String refreshToken = '/auth/refresh';

  /// POST - Logout user
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "message": string }
  static const String logout = '/auth/logout';

  /// POST - Request password reset
  /// Body: { "email": string }
  /// Returns: { "message": string }
  static const String requestPasswordReset = '/auth/request-password-reset';

  // ============================================================================
  // User Endpoints (§4)
  // ============================================================================

  /// GET - Get current user status / profile
  /// Also available at: /user/profile
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "user": {...} }
  static const String userStatus = '/user/profile';
  static const String userProfile = '/user/profile';

  /// POST - Change password
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "current_password": string, "new_password": string }
  /// Rate limited: 3 per hour
  static const String changePassword = '/user/change-password';

  /// GET - List users (admin only)
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Query: ?page=int&page_size=int
  /// Returns: [{ "id": string, "username": string, "email": string, ... }]
  static const String adminListUsers = '/user/users';
  static const String adminListUsersAlt = '/users/users';

  /// GET - Get user by ID
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "id": string, "username": string, "email": string, ... }
  static String adminGetUser(String userId) => '/user/users/$userId';
  static String adminGetUserAlt(String userId) => '/users/users/$userId';

  /// GET - List departments (admin only)
  static const String adminListDepartments = '/user/departments';

  /// PUT - Update user
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "roles": string[]? }
  /// Returns: { "id": string, "message": string, ... }
  static String updateUser(String userId) => '/user/users/$userId';

  /// PATCH - Update user department
  static String adminUpdateUserDepartment(String userId) =>
      '/user/users/$userId/department';

  /// PATCH - Set user status (active/inactive)
  static String adminSetUserStatus(String userId) =>
      '/user/users/$userId/status';

  /// PATCH - Update user roles
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "roles": string[] }
  static String adminUpdateUserRoles(String userId) =>
      '/user/users/$userId/roles';

  /// POST - Reset user password
  static String adminResetUserPassword(String userId) =>
      '/user/users/$userId/reset-password';

  /// POST - Lock user account
  /// Headers: { "Authorization": "Bearer {token}" }
  static String adminLockUser(String userId) => '/user/users/$userId/lock';

  /// POST - Unlock user account
  /// Headers: { "Authorization": "Bearer {token}" }
  static String adminUnlockUser(String userId) => '/user/users/$userId/unlock';

  /// DELETE - Delete user
  static String adminDeleteUser(String userId) => '/user/users/$userId';

  /// GET - Get user activity
  static String adminGetUserActivity(String userId) =>
      '/user/users/$userId/activity';

  /// GET - Get lock status
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "is_locked": bool, "lock_until": string, "failed_login_attempts": int }
  static String getLockStatus(String userId) =>
      '/user/security/lock-status/$userId';

  // ============================================================================
  // System Settings Endpoints
  // ============================================================================

  /// GET - Get system settings (superadmin)
  static const String systemSettingsGet = '/admin/system-settings/';

  /// PATCH - Update system settings (superadmin)
  static const String systemSettingsPatch = '/admin/system-settings/';
  static const String systemSettingsPut = '/admin/system-settings/';

  /// POST - Reset system settings to defaults (superadmin)
  static const String systemSettingsReset = '/admin/system-settings/reset';

  // ============================================================================
  // Form Management Endpoints (§5-6)
  // ============================================================================

  /// GET - List all forms
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Query: ?page=int&page_size=int&is_template=bool
  /// Returns: [{ "id": string, "title": string, "status": string, ... }]
  static const String listForms = '/forms/';

  /// GET - Builder metadata used by schema-driven builder controls.
  static const String builderMetadata = '/forms/builder-metadata';

  /// GET - Get form by ID
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Optional: ?lang=string
  /// Returns: { "id": string, "title": string, "sections": [...], ... }
  static String getForm(String formId) => '/forms/$formId';

  /// GET - Get form by project and form ID
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "id": string, "title": string, "sections": [...], ... }
  static String getProjectForm(String projectId, String formId) =>
      '/projects/$projectId/forms/$formId';

  /// POST - Create new form
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "title": string, "slug": string?, "default_language": string, "supported_languages": string[] }
  /// Returns: { "form_id": string }
  static const String createForm = '/forms/';

  /// PUT - Update existing form
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "title": string?, "description": string? }
  /// Returns: { "id": string, "title": string, ... }
  static String updateForm(String formId) => '/forms/$formId';

  /// PUT - Update existing form within a project
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { ... full form canvas ... }
  /// Returns: { "id": string, "title": string, ... }
  static String updateProjectForm(String projectId, String formId) =>
      '/projects/$projectId/forms/$formId';

  /// PUT - Save full builder draft canvas with debounce-friendly semantics.
  static String saveFormDraft(String projectId, String formId) =>
      '/projects/$projectId/forms/$formId/draft';

  /// GET - Export the current form schema.
  static String exportFormSchema(String projectId, String formId) =>
      '/projects/$projectId/forms/$formId/schema';

  /// POST - Import a full form schema into a project.
  static String importFormSchema(String projectId) =>
      '/projects/$projectId/forms/import/schema';

  /// DELETE - Delete form (soft delete)
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "message": string }
  static String deleteForm(String formId) => '/forms/$formId';
  static String deleteProjectForm(String projectId, String formId) =>
      '/projects/$projectId/forms/$formId';

  /// POST - Publish form (async, returns 202)
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "major": bool, "minor": bool }
  /// Returns: { "task_id": string }
  static String publishForm(String formId) => '/forms/$formId/publish';
  static String publishProjectForm(String projectId, String formId) =>
      '/projects/$projectId/forms/$formId/publish';

  /// POST - Clone/duplicate form (async, returns 202)
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "title": string, "slug": string? }
  /// Returns: { "task_id": string }
  static String cloneForm(String formId) => '/forms/$formId/clone';
  static String cloneProjectForm(String projectId, String formId) =>
      '/projects/$projectId/forms/$formId/clone';

  // ============================================================================
  // Project Management Endpoints (§2b)
  // ============================================================================

  /// POST - Create a project
  static const String createProject = '/projects/';

  /// GET - List projects
  static const String listProjects = '/projects/';

  /// GET - Get a project
  static String getProject(String projectId) => '/projects/$projectId';

  /// PUT - Update a project
  static String updateProject(String projectId) => '/projects/$projectId';

  /// DELETE - Soft delete a project
  static String deleteProject(String projectId) => '/projects/$projectId';

  /// POST - Create a form inside a project
  static String createProjectForm(String projectId) =>
      '/projects/$projectId/forms';

  /// GET - List forms in a project
  static String listProjectForms(String projectId) =>
      '/projects/$projectId/forms';

  // ============================================================================
  // Form Version Endpoints
  // ============================================================================

  /// GET - List all versions for a form
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: [{ "version": string, "created_at": string, ... }]
  static String getFormVersions(String projectId, String formId) =>
      '/projects/$projectId/forms/$formId/versions';

  /// GET - Get a specific version of a form
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "id": string, "title": string, "sections": [...], ... }
  static String getFormVersion(
    String projectId,
    String formId,
    String version,
  ) => '/projects/$projectId/forms/$formId/versions/$version';

  /// POST - Restore a specific form version into the active draft.
  static String restoreFormVersion(
    String projectId,
    String formId,
    String version,
  ) => '/projects/$projectId/forms/$formId/versions/$version/restore';

  /// PUT - Update a specific version of a form
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { ... form fields ... }
  static String updateFormVersion(
    String projectId,
    String formId,
    String version,
  ) => '/projects/$projectId/forms/$formId/versions/$version';

  /// POST - Create a new version of a form
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "type": string, "activate": bool, ... }
  /// Returns: { "version": string, ... }
  static String createFormVersion(String projectId, String formId) =>
      '/projects/$projectId/forms/$formId/versions';

  /// GET - Check slug availability
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Query: ?slug=string
  /// Returns: { "data": { "available": bool } }
  static const String checkSlugAvailable = '/forms/slug-available';

  /// POST - Import form
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "title": string, "slug": string, "sections": [...] }
  static const String importForm = '/forms/import';

  /// GET - List form templates
  /// Headers: { "Authorization": "Bearer {token}" }
  static const String listFormTemplates = '/forms/templates';

  /// GET - Get form template by ID
  static String getFormTemplate(String templateId) =>
      '/forms/templates/$templateId';

  // ============================================================================
  // Section Management Endpoints (§6)
  // ============================================================================

  static String listSections(String projectId, String formId) =>
      '/projects/$projectId/forms/$formId/sections';

  // ============================================================================
  // Response Submission Endpoints (§8)
  // ============================================================================

  /// POST - Submit form response (authenticated)
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "data": { "field_id": value, ... } }
  /// Returns: { "response_id": string }
  static String submitResponse(String formId) => '/forms/$formId/responses';
  static String submitProjectResponse(String projectId, String formId) =>
      '/projects/$projectId/forms/$formId/responses';

  /// POST - Submit form response (anonymous/public)
  /// No authentication required. Form must have is_public=true and status="published"
  static String publicSubmit(String formId) => '/forms/$formId/public-submit';

  /// GET - List responses for a form
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Query: ?page=int&page_size=int
  static String listResponses(String formId) => '/forms/$formId/responses';
  static String listProjectResponses(String projectId, String formId) =>
      '/projects/$projectId/forms/$formId/responses';
  static String filterProjectResponses(String projectId, String formId) =>
      '/projects/$projectId/forms/$formId/responses/filter';

  /// GET - Get single response by ID
  /// Headers: { "Authorization": "Bearer {token}" }
  static String getResponse(String formId, String responseId) =>
      '/forms/$formId/responses/$responseId';
  static String getProjectResponse(
    String projectId,
    String formId,
    String responseId,
  ) => '/projects/$projectId/forms/$formId/responses/$responseId';

  /// PUT - Update response
  /// Headers: { "Authorization": "Bearer {token}" }
  static String updateResponse(String formId, String responseId) =>
      '/forms/$formId/responses/$responseId';
  static String updateProjectResponse(
    String projectId,
    String formId,
    String responseId,
  ) => '/projects/$projectId/forms/$formId/responses/$responseId';

  /// DELETE - Delete response
  /// Headers: { "Authorization": "Bearer {token}" }
  static String deleteResponse(String formId, String responseId) =>
      '/forms/$formId/responses/$responseId';
  static String deleteProjectResponse(
    String projectId,
    String formId,
    String responseId,
  ) => '/projects/$projectId/forms/$formId/responses/$responseId';

  /// GET - Count responses
  /// Headers: { "Authorization": "Bearer {token}" }
  static String responseCount(String formId) =>
      '/forms/$formId/responses/count';

  /// GET - Get last response
  /// Headers: { "Authorization": "Bearer {token}" }
  static String lastResponse(String formId) => '/forms/$formId/responses/last';

  /// POST - Check duplicate submission
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "data": { "field": value } }
  /// Returns: { "data": { "duplicate": bool } }
  static String checkDuplicate(String formId) =>
      '/forms/$formId/check-duplicate';

  /// DELETE - Delete all responses (admin, irreversible)
  /// Headers: { "Authorization": "Bearer {token}" }
  static String deleteAllResponses(String formId) => '/forms/$formId/responses';

  // ============================================================================
  // Form Admin Operations (§9)
  // ============================================================================

  /// PATCH - Archive form
  /// Headers: { "Authorization": "Bearer {token}" }
  static String archiveForm(String formId) => '/forms/$formId/archive';

  /// PATCH - Restore form
  /// Headers: { "Authorization": "Bearer {token}" }
  static String restoreForm(String formId) => '/forms/$formId/restore';

  /// PATCH - Toggle public access
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "data": { "is_public": bool } }
  static String togglePublic(String formId) => '/forms/$formId/toggle-public';

  /// POST - Share form (grant permissions)
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "editors": string[], "viewers": string[], "submitters": string[] }
  static String shareForm(String formId) => '/forms/$formId/share';

  /// PATCH - Set form expiration
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "expires_at": string }
  static String expireForm(String formId) => '/forms/$formId/expire';

  /// GET - List expired forms
  /// Headers: { "Authorization": "Bearer {token}" }
  static const String listExpiredForms = '/forms/expired';

  // ============================================================================
  // Access Control (§13)
  // ============================================================================

  /// GET - Get current user's permissions for a form
  /// Headers: { "Authorization": "Bearer {token}" }
  static String accessControl(String formId) => '/forms/$formId/access-control';

  /// POST/PUT - Update access policy
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "form_visibility": string, "response_visibility": string, ... }
  static String accessPolicy(String formId) => '/forms/$formId/access-policy';

  /// GET - Form audit trail.
  static String formAudit(String projectId, String formId) =>
      '/projects/$projectId/forms/$formId/audit';

  /// POST - Apply a theme or form-level theme override.
  static String applyFormTheme(String projectId, String formId) =>
      '/projects/$projectId/forms/$formId/theme';

  // ============================================================================
  // Workflow Integration (§12)
  // ============================================================================

  /// GET - List available workflows / next action for a form
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Optional: ?response_id=string
  static String nextAction(String formId) => '/forms/$formId/next-action';

  /// GET - List all workflows
  static const String listWorkflows = '/workflows/';

  /// POST - Create new workflow
  static const String createWorkflow = '/workflows/';

  /// PUT - Update existing workflow
  static String updateWorkflow(String workflowId) => '/workflows/$workflowId';

  // ============================================================================
  // Project / Hook Routes
  // ============================================================================

  /// POST - Trigger hooks for a project
  static String triggerProjectHooks(String projectId) =>
      '/forms/projects/$projectId/hooks/trigger';

  // ============================================================================
  // Submission History (§11)
  // ============================================================================

  /// GET - Get submission history
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Query: ?question_id=string&primary_value=string
  static String submissionHistory(String formId) => '/forms/$formId/history';

  /// GET - Get history for a specific response
  /// Headers: { "Authorization": "Bearer {token}" }
  static String getResponseHistory(String formId, String responseId) =>
      '/forms/$formId/responses/$responseId/history';

  // ============================================================================
  // Export API (§10)
  // ============================================================================

  /// GET - Export responses as CSV or JSON (streaming)
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Optional: ?version_id=string
  static String exportResponses(String formId, {String format = 'csv'}) =>
      '/forms/$formId/export/$format';

  static String exportProjectResponses(
    String projectId,
    String formId, {
    String format = 'csv',
  }) => '/projects/$projectId/forms/$formId/export/$format';

  /// POST - Start bulk export (async, returns 202)
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "form_ids": string[] }
  /// Returns: { "job_id": string, "status": string }
  static const String bulkExport = '/forms/export/bulk';
  static String projectBulkExport(String projectId) =>
      '/projects/$projectId/forms/export/bulk';

  /// GET - Generic async task status.
  static String taskStatus(String taskId) => '/tasks/$taskId';

  /// GET - Check bulk export status
  /// Headers: { "Authorization": "Bearer {token}" }
  static String bulkExportStatus(String jobId) => '/forms/export/bulk/$jobId';
  static String projectBulkExportStatus(String projectId, String jobId) =>
      '/projects/$projectId/forms/export/bulk/$jobId';

  /// GET - Download completed bulk export (ZIP)
  /// Headers: { "Authorization": "Bearer {token}" }
  static String bulkExportDownload(String jobId) =>
      '/forms/export/bulk/$jobId/download';
  static String projectBulkExportDownload(String projectId, String jobId) =>
      '/projects/$projectId/forms/export/bulk/$jobId/download';

  // ============================================================================
  // Advanced Response Queries (§14)
  // ============================================================================

  /// GET - Cross-form data lookup
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Query: ?form_id=string&question_id=string&value=string
  static String crossFormLookup(
    String formId,
    String questionId,
    String value,
  ) =>
      '/forms/fetch/external?form_id=$formId&question_id=$questionId&value=$value';

  /// GET - Same-form data lookup
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Query: ?question_id=string&value=string
  static String sameFormLookup(
    String formId,
    String questionId,
    String value,
  ) => '/forms/$formId/fetch/same?question_id=$questionId&value=$value';

  // ============================================================================
  // Summarization API (§15)
  // ============================================================================

  /// POST - Summarize form responses
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "response_ids": string[]? }
  /// Returns: { "summary": string, "form_id": string }
  static String summarizeFormResponses(String formId) =>
      '/forms/$formId/summarize';

  /// POST - Streaming summary (SSE)
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "response_ids": string[] }
  static String summarizeStream(String formId) =>
      '/forms/$formId/summarize-stream';

  // ============================================================================
  // Translation API (§16)
  // ============================================================================

  /// GET - Get translations for form
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Query: ?form_id=string&language=string
  static String getFormTranslations({String? formId, String? language}) {
    var url = '/forms/translations';
    final params = <String>[];
    if (formId != null) params.add('form_id=$formId');
    if (language != null) params.add('language=$language');
    return params.isNotEmpty ? '$url?${params.join('&')}' : url;
  }

  /// POST - Save translations
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "form_id": string, "language": string, "translations": {...} }
  static const String saveFormTranslations = '/forms/translations';

  /// POST - Start a new translation job (AI batch translation)
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "form_id": string, "source_language": string, "target_languages": string[], "total_fields": int }
  /// Returns: { "message": string, "job_id": string }
  static const String startTranslationJob = '/forms/translations/jobs';

  /// GET - List translation jobs for a form
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Query: ?form_id=string
  static String listTranslationJobs(String formId) =>
      '/forms/translations/jobs?form_id=$formId';

  /// GET - Get translation job details
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "job_id": string, "status": string, "progress": int, ... }
  static String getTranslationJob(String jobId) =>
      '/forms/translations/jobs/$jobId';

  /// PATCH - Cancel a translation job
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "message": string }
  static String cancelTranslationJob(String jobId) =>
      '/forms/translations/jobs/$jobId/cancel';

  /// DELETE - Delete a translation job
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "message": string }
  static String deleteTranslationJob(String jobId) =>
      '/forms/translations/jobs/$jobId';

  /// POST - Preview translation
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "text": string, "source_language": string, "target_language": string }
  /// Returns: { "translated_text": string }
  static const String previewTranslation = '/forms/translations/preview';

  /// GET - List available languages for translation
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: [{ "code": string, "name": string, "native_name": string }]
  static const String listTranslationLanguages =
      '/forms/translations/languages';

  /// GET - Get translated content for a job (completed jobs only)
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "form_id": string, "language": string, "translations": {...} }
  static String getTranslatedContent(String jobId) =>
      '/forms/translations/jobs/$jobId/content';

  // ============================================================================
  // AI / NLP Search API (§17)
  // ============================================================================

  /// POST - Generate form structure from a prompt using AI
  /// Body: { "prompt": string, "current_form": {...}? }
  static const String generateFormAI = '/ai/generate';

  /// POST - Get field suggestions based on current form context
  /// Body: { "current_form": {...} }
  static const String getFieldSuggestions = '/ai/suggestions';

  /// POST - Validate form design for UX/logical issues
  /// Body: { "form": {...} }
  static String validateFormDesign(String formId) =>
      '/ai/$formId/validate-design';

  /// GET - AI service health check (public)
  static const String aiHealthCheck = '/ai/health';

  /// POST - NLP search across form responses
  static String nlpSearch(String formId) => '/ai/search/$formId/nlp-search';

  /// POST - Semantic search across form responses
  static String semanticSearch(String formId) =>
      '/ai/search/$formId/semantic-search';

  /// POST - Semantic search (streaming SSE)
  static String semanticSearchStream(String formId) =>
      '/ai/search/$formId/semantic-search/stream';

  /// POST - Analyze a specific form response using AI
  static String analyzeResponseAI(String formId, String responseId) =>
      '/ai/$formId/responses/$responseId/analyze';

  /// POST - Moderate (flag/review) a specific form response using AI
  static String moderateResponseAI(String formId, String responseId) =>
      '/ai/$formId/responses/$responseId/moderate';

  /// GET - Get sentiment distribution for a form
  static String getFormSentimentTrends(String formId) =>
      '/ai/$formId/sentiment';

  /// POST - Detect anomalies in form responses using AI
  static String detectFormAnomalies(String formId) => '/ai/$formId/anomalies';

  /// POST - AI powered search for responses in a form
  static String aiPoweredSearch(String formId) => '/ai/$formId/search';

  // ============================================================================
  // Dashboard API (§18)
  // ============================================================================

  /// POST - Create dashboard
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "title": string, "slug": string, "widgets": [...] }
  static const String createDashboard = '/dashboards/';

  /// GET - Get dashboard (with live widget data)
  /// Headers: { "Authorization": "Bearer {token}" }
  static String getDashboard(String slug) => '/dashboards/$slug';

  /// PUT - Update dashboard
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "title": string? }
  static String updateDashboard(String dashboardId) =>
      '/dashboards/$dashboardId';

  /// Dashboard settings
  static const String dashboardSettings = '/dashboard-settings/settings';

  /// Public view route for a form
  static String viewForm(String formId) => '/view/$formId';

  // ============================================================================
  // Analytics Endpoints (§19)
  // ============================================================================

  /// GET - Get dashboard statistics
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Requires role: admin, superadmin, or manager
  /// Returns: { "total_forms": int, "active_forms": int, "total_responses": int, ... }
  static const String getDashboardStats = '/analytics/dashboard';

  /// GET - Get analytics for a specific form
  static String getAnalytics(String formId) => '/forms/$formId/analytics';
  static String getProjectAnalytics(String projectId, String formId) =>
      '/projects/$projectId/forms/$formId/analytics';

  /// GET - Get analytics summary
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Requires role: admin or superadmin
  static const String getSummary = '/analytics/summary';

  /// GET - Get analytics trends
  /// Headers: { "Authorization": "Bearer {token}" }
  static const String getTrends = '/analytics/trends';

  // ============================================================================
  // Webhook API (§20)
  // ============================================================================

  /// POST - Deliver webhook
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "url": string, "webhook_id": string, "form_id": string, "payload": {...}, ... }
  static const String deliverWebhook = '/webhooks/deliver';

  /// GET - Webhook status
  /// Headers: { "Authorization": "Bearer {token}" }
  static String webhookStatus(String deliveryId) =>
      '/webhooks/$deliveryId/status';

  /// GET - Webhook history
  /// Headers: { "Authorization": "Bearer {token}" }
  static String webhookHistory(String deliveryId) =>
      '/webhooks/$deliveryId/history';

  /// POST - Retry webhook
  /// Headers: { "Authorization": "Bearer {token}" }
  static String webhookRetry(String deliveryId) =>
      '/webhooks/$deliveryId/retry';

  /// POST - Cancel webhook
  /// Headers: { "Authorization": "Bearer {token}" }
  static String webhookCancel(String deliveryId) =>
      '/webhooks/$deliveryId/cancel';

  /// POST - Test webhook
  /// Headers: { "Authorization": "Bearer {token}" }
  static String webhookTest(String webhookId) => '/webhooks/test';

  /// GET - Webhook logs
  /// Headers: { "Authorization": "Bearer {token}" }
  static String webhookLogs(String webhookId) => '/webhooks/logs';

  // ============================================================================
  // SMS API (§21)
  // ============================================================================

  /// POST - Send SMS
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "mobile": string, "message": string }
  /// Rate limited: 10 per minute
  static const String sendSms = '/sms/single';

  /// POST - Send OTP via SMS (admin only)
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "mobile": string, "otp": string }
  /// Rate limited: 5 per minute
  static const String sendOtpSms = '/sms/otp';

  /// POST - Send notification
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "mobile": string, "title": string, "body": string }
  static const String sendNotification = '/sms/notify';

  /// GET - SMS health check
  /// Headers: { "Authorization": "Bearer {token}" }
  static const String smsHealth = '/sms/health';

  // ============================================================================
  // Custom Field / Library API (§22)
  // ============================================================================

  /// GET - List field templates
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: [{ "id": string, "name": string, "type": string, ... }]
  static const String listFieldTemplates = '/custom-fields/';

  /// POST - Create field template
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "name": string, "type": string, "config": {...} }
  /// Returns: { "id": string, "name": string, ... }
  static const String createFieldTemplate = '/custom-fields/';

  // ============================================================================
  // Theme API
  // ============================================================================

  /// GET/POST - Reusable organization themes.
  static const String themes = '/themes/';

  /// PUT/DELETE - Reusable organization theme by ID.
  static String theme(String themeId) => '/themes/$themeId';

  // ============================================================================
  // Health Check
  // ============================================================================

  /// GET - API health check (registered at /form/health)
  static const String healthCheck = '/health';

  // ============================================================================
  // File Management Endpoints
  // ============================================================================

  /// POST - Upload a file
  static const String uploadFile = '/forms/upload';

  /// POST - Upload a signature
  static const String uploadSignature = '/forms/signatures';

  // ============================================================================
  // Helper methods for building URLs
  // ============================================================================

  /// Build full URL with base URL
  static String buildUrl(String endpoint) => '$baseUrl$endpoint';

  /// Build URL with query parameters
  static String buildUrlWithParams(
    String endpoint,
    Map<String, dynamic> params,
  ) {
    final uri = Uri.parse('$baseUrl$endpoint');
    final newUri = uri.replace(
      queryParameters: params.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
    return newUri.toString();
  }
}

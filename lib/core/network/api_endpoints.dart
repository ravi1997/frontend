/// Centralized API endpoint constants for the application.
///
/// This file contains all API endpoints used throughout the application,
/// organized by feature area for easy maintenance and updates.
class ApiEndpoints {
  // Base configuration
  static const String serverBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5000',
  );

  static const String baseUrl = '$serverBaseUrl/form/api/v1';

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
  static const String userStatus = '/user/status';

  /// POST - Change password
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "current_password": string, "new_password": string }
  /// Rate limited: 3 per hour
  static const String changePassword = '/user/change-password';

  /// GET - List users (admin only)
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Query: ?page=int&page_size=int
  /// Returns: [{ "id": string, "username": string, "email": string, ... }]
  static const String listUsers = '/user/users';

  /// GET - Get user by ID
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "id": string, "username": string, "email": string, ... }
  static String getUser(String userId) => '/user/users/$userId';

  /// PUT - Update user
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "roles": string[]? }
  /// Returns: { "id": string, "message": string, ... }
  static String updateUser(String userId) => '/user/users/$userId';

  /// PUT - Update user roles
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "roles": string[] }
  static String updateUserRoles(String userId) => '/user/users/$userId/roles';

  /// POST - Lock user account
  /// Headers: { "Authorization": "Bearer {token}" }
  static String lockUser(String userId) => '/user/users/$userId/lock';

  /// POST - Unlock user account
  /// Headers: { "Authorization": "Bearer {token}" }
  static String unlockUser(String userId) => '/user/users/$userId/unlock';

  /// GET - Get lock status
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "is_locked": bool, "lock_until": string, "failed_login_attempts": int }
  static String getLockStatus(String userId) =>
      '/user/security/lock-status/$userId';

  // ============================================================================
  // Form Management Endpoints (§5-6)
  // ============================================================================

  /// GET - List all forms
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Query: ?page=int&page_size=int&is_template=bool
  /// Returns: [{ "id": string, "title": string, "status": string, ... }]
  static const String listForms = '/forms/';

  /// GET - Get form by ID
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Optional: ?lang=string
  /// Returns: { "id": string, "title": string, "sections": [...], ... }
  static String getForm(String formId) => '/forms/$formId';

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

  /// DELETE - Delete form (soft delete)
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "message": string }
  static String deleteForm(String formId) => '/forms/$formId';

  /// POST - Publish form (async, returns 202)
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "major": bool, "minor": bool }
  /// Returns: { "task_id": string }
  static String publishForm(String formId) => '/forms/$formId/publish';

  /// POST - Clone/duplicate form (async, returns 202)
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "title": string, "slug": string? }
  /// Returns: { "task_id": string }
  static String cloneForm(String formId) => '/forms/$formId/clone';

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
  static const String formTemplates = '/forms/templates';

  // ============================================================================
  // Section Management Endpoints (§6)
  // ============================================================================

  static String listSections(String formId) => '/forms/$formId/sections';
  static String createSection(String formId) => '/forms/$formId/sections';
  static String updateSection(String formId, String sectionId) =>
      '/forms/$formId/sections/$sectionId';
  static String deleteSection(String formId, String sectionId) =>
      '/forms/$formId/sections/$sectionId';
  static String reorderSections(String formId) =>
      '/forms/$formId/sections/reorder';

  // ============================================================================
  // Response Submission Endpoints (§8)
  // ============================================================================

  /// POST - Submit form response (authenticated)
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "data": { "field_id": value, ... } }
  /// Returns: { "response_id": string }
  static String submitResponse(String formId) => '/forms/$formId/responses';

  /// POST - Submit form response (anonymous/public)
  /// No authentication required. Form must have is_public=true and status="published"
  static String publicSubmit(String formId) => '/forms/$formId/public-submit';

  /// GET - List responses for a form
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Query: ?page=int&page_size=int
  static String listResponses(String formId) => '/forms/$formId/responses';

  /// GET - Get single response by ID
  /// Headers: { "Authorization": "Bearer {token}" }
  static String getResponse(String formId, String responseId) =>
      '/forms/$formId/responses/$responseId';

  /// PUT - Update response
  /// Headers: { "Authorization": "Bearer {token}" }
  static String updateResponse(String formId, String responseId) =>
      '/forms/$formId/responses/$responseId';

  /// DELETE - Delete response
  /// Headers: { "Authorization": "Bearer {token}" }
  static String deleteResponse(String formId, String responseId) =>
      '/forms/$formId/responses/$responseId';

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

  // ============================================================================
  // Workflow Integration (§12)
  // ============================================================================

  /// GET - List available workflows / next action for a form
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Optional: ?response_id=string
  static String nextAction(String formId) => '/forms/$formId/next-action';

  // ============================================================================
  // Submission History (§11)
  // ============================================================================

  /// GET - Get submission history
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Query: ?question_id=string&primary_value=string
  static String submissionHistory(String formId) => '/forms/$formId/history';

  // ============================================================================
  // Export API (§10)
  // ============================================================================

  /// GET - Export responses as CSV or JSON (streaming)
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Optional: ?version_id=string
  static String exportResponses(String formId, {String format = 'csv'}) =>
      '/forms/$formId/export/$format';

  /// POST - Start bulk export (async, returns 202)
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "form_ids": string[] }
  /// Returns: { "job_id": string, "status": string }
  static const String bulkExport = '/forms/export/bulk';

  /// GET - Check bulk export status
  /// Headers: { "Authorization": "Bearer {token}" }
  static String bulkExportStatus(String jobId) => '/forms/export/bulk/$jobId';

  /// GET - Download completed bulk export (ZIP)
  /// Headers: { "Authorization": "Bearer {token}" }
  static String bulkExportDownload(String jobId) =>
      '/forms/export/bulk/$jobId/download';

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

  /// GET - AI service health check (public)
  /// Returns: { "status": string, "ollama": {...}, "timestamp": string }
  static const String aiHealthCheck = '/ai/health';

  /// GET - NLP search
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Query: ?q=string
  static String nlpSearch(String query) => '/ai/search/nlp-search?q=$query';

  /// POST - Semantic search
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "query": string, "form_id": string }
  /// Results cached in Redis for 1 hour
  static const String semanticSearch = '/ai/search/semantic-search';

  /// POST - Semantic search (streaming SSE)
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "query": string }
  static const String semanticSearchStream =
      '/ai/search/semantic-search/stream';

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
  static const String dashboardSettings = '/dashboard-settings';

  // ============================================================================
  // Analytics Endpoints (§19)
  // ============================================================================

  /// GET - Get dashboard statistics
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Requires role: admin, superadmin, or manager
  /// Returns: { "total_forms": int, "active_forms": int, "total_responses": int, ... }
  static const String getDashboardStats = '/analytics/dashboard';

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
  static String webhookTest(String webhookId) => '/webhooks/$webhookId/test';

  /// GET - Webhook logs
  /// Headers: { "Authorization": "Bearer {token}" }
  static String webhookLogs(String webhookId) => '/webhooks/$webhookId/logs';

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
  // Health Check
  // ============================================================================

  /// GET - API health check
  /// Returns: { "status": "ok", "version": string, "timestamp": string }
  static const String healthCheck = '/health';

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

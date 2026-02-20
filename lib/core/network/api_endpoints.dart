/// Centralized API endpoint constants for the application.
///
/// This file contains all API endpoints used throughout the application,
/// organized by feature area for easy maintenance and updates.
class ApiEndpoints {
  // Base configuration
  // static const String baseUrl = 'http://localhost:5000/form/api/v1';
  static const String baseUrl = 'http://192.168.1.91:5000/form/api/v1';

  /// Base URL for the server root (without the /form/api/v1 prefix).
  /// Use this for endpoints that live outside the /form/api/v1 path, e.g. admin endpoints.
  // static const String serverBaseUrl = 'http://localhost:5000';
  static const String serverBaseUrl = 'http://192.168.1.91:5000';

  // ============================================================================
  // Admin User Management Endpoints  (prefix: /api/v1/admin/users)
  // ============================================================================

  /// GET - List all users (admin only)
  static const String adminListUsers = '$serverBaseUrl/api/v1/admin/users/';

  /// GET - List all unique departments
  static const String adminListDepartments =
      '$serverBaseUrl/api/v1/admin/users/departments';

  /// GET - Get a single user's full profile (admin)
  static String adminGetUser(String userId) =>
      '$serverBaseUrl/api/v1/admin/users/$userId';

  /// PATCH - Update a user's department
  static String adminUpdateUserDepartment(String userId) =>
      '$serverBaseUrl/api/v1/admin/users/$userId/department';

  /// PATCH - Update a user's roles
  static String adminUpdateUserRoles(String userId) =>
      '$serverBaseUrl/api/v1/admin/users/$userId/roles';

  /// POST - Admin force-reset a user's password
  static String adminResetUserPassword(String userId) =>
      '$serverBaseUrl/api/v1/admin/users/$userId/reset-password';

  /// POST - Lock a user account (admin)
  static String adminLockUser(String userId) =>
      '$serverBaseUrl/api/v1/admin/users/$userId/lock';

  /// POST - Unlock a user account (admin)
  static String adminUnlockUser(String userId) =>
      '$serverBaseUrl/api/v1/admin/users/$userId/unlock';

  /// PATCH - Set is_active status for a user (admin)
  static String adminSetUserStatus(String userId) =>
      '$serverBaseUrl/api/v1/admin/users/$userId/status';

  /// DELETE - Permanently delete a user (admin)
  static String adminDeleteUser(String userId) =>
      '$serverBaseUrl/api/v1/admin/users/$userId';

  /// GET - Get user activity / security timeline (admin)
  static String adminGetUserActivity(String userId) =>
      '$serverBaseUrl/api/v1/admin/users/$userId/activity';

  // ============================================================================
  // System Settings Endpoints  (prefix: /api/v1/admin/system-settings)
  // ============================================================================

  /// GET - Get current system settings (superadmin only)
  static const String systemSettingsGet =
      '$serverBaseUrl/api/v1/admin/system-settings/';

  /// PATCH - Update system settings (superadmin only)
  static const String systemSettingsPatch =
      '$serverBaseUrl/api/v1/admin/system-settings/';

  /// POST - Reset settings to factory defaults (superadmin only)
  static const String systemSettingsReset =
      '$serverBaseUrl/api/v1/admin/system-settings/reset';

  // ============================================================================
  // Authentication Endpoints
  // ============================================================================

  /// POST - Login with email/username and password
  /// Body: { "identifier": string, "password": string }
  /// Returns: { "access_token": string, "refresh_token": string, "user": {...} }
  static const String login = '/auth/login';

  /// POST - Login with mobile and OTP
  /// Body: { "mobile": string, "otp": string }
  /// Returns: { "access_token": string, "refresh_token": string, "user": {...} }
  static const String loginWithOtp = '/auth/login';

  /// POST - Generate OTP for mobile number
  /// Body: { "mobile": string }
  /// Returns: { "message": string }
  static const String generateOtp = '/auth/generate-otp';

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

  /// GET - Get current user status
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "user": {...} }
  static const String userStatus = '/user/status';

  // ============================================================================
  // Form Management Endpoints
  // ============================================================================

  /// GET - List all forms
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Query: ?page=int&limit=int&status=string&search=string
  /// Returns: [{ "id": string, "title": string, "status": string, ... }]
  static const String listForms = '/forms/';

  /// GET - Get form by ID
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "id": string, "title": string, "sections": [...], ... }
  static String getForm(String formId) => '/forms/$formId';

  /// POST - Create new form
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: {
  ///   "title": string,
  ///   "slug": string,
  ///   "status": string,
  ///   "versions": [{
  ///     "version": string,
  ///     "sections": [...],
  ///     "created_at": string
  ///   }],
  ///   "active_version": string
  /// }
  /// Returns: { "id": string, "title": string, ... }
  static const String createForm = '/forms/';

  /// PUT - Update existing form
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: Same as createForm
  /// Returns: { "id": string, "title": string, ... }
  static String updateForm(String formId) => '/forms/$formId';

  /// DELETE - Delete form
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "message": string }
  static String deleteForm(String formId) => '/forms/$formId';

  /// POST - Publish form
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "message": string, "form": {...} }
  static String publishForm(String formId) => '/forms/$formId/publish';

  /// POST - Clone/duplicate form
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "title": string }
  /// Returns: { "id": string, "title": string, ... }
  static String cloneForm(String formId) => '/forms/$formId/clone';

  /// GET - Get form version history
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: [{ "version": string, "created_at": string, ... }]
  /// GET - Get form version history
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: [{ "version": string, "created_at": string, ... }]
  static String getFormVersions(String formId) => '/forms/$formId/versions';

  /// POST - Create new form version
  static String createFormVersion(String formId) => '/forms/$formId/versions';

  /// GET - Get specific form version
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "id": string, "version": string, "sections": [...], ... }
  static String getFormVersion(String formId, String version) =>
      '/forms/$formId/versions/$version';

  /// PUT - Update specific form version
  static String updateFormVersion(String formId, String version) =>
      '/forms/$formId/versions/$version';

  // ============================================================================
  // Response Submission Endpoints
  // ============================================================================

  /// POST - Submit form response
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: {
  ///   "form_id": string,
  ///   "responses": { "field_id": value, ... },
  ///   "submitted_by": string,
  ///   "metadata": {...}
  /// }
  /// Returns: { "id": string, "submission_id": string, ... }
  static const String submitResponse = '/responses';

  /// GET - List responses for a form
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Query: ?form_id=string&page=int&limit=int&status=string
  /// Returns: [{ "id": string, "form_id": string, "responses": {...}, ... }]
  static const String listResponses = '/responses';

  /// GET - Get single response by ID
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "id": string, "form_id": string, "responses": {...}, ... }
  static String getResponse(String responseId) => '/responses/$responseId';
  static String getResponseHistory(String responseId) =>
      '/responses/$responseId/history';

  /// PUT - Update response
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: Same as submitResponse
  /// Returns: { "id": string, "message": string, ... }
  static String updateResponse(String responseId) => '/responses/$responseId';

  /// DELETE - Delete response
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "message": string }
  static String deleteResponse(String responseId) => '/responses/$responseId';

  /// GET - Export responses
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Query: ?form_id=string&format=csv|json|excel
  /// Returns: File download or JSON data
  static const String exportResponses = '/responses/export';

  // ============================================================================
  // Analytics Endpoints
  // ============================================================================

  /// GET - Get form analytics
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Query: ?form_id=string&start_date=string&end_date=string
  /// Returns: { "total_responses": int, "completion_rate": float, ... }
  static const String getAnalytics = '/analytics';

  /// GET - Get dashboard statistics
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: {
  ///   "total_forms": int,
  ///   "active_forms": int,
  ///   "total_responses": int,
  ///   "recent_activity": [...]
  /// }
  static const String getDashboardStats = '/analytics/dashboard';

  // ============================================================================
  // Field Library Endpoints
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
  // Template Library Endpoints
  // ============================================================================

  /// GET - List form templates
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Query: ?category=string&search=string
  /// Returns: [{ "id": string, "name": string, "category": string, ... }]
  static const String listFormTemplates = '/templates';

  /// GET - Get template by ID
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "id": string, "name": string, "sections": [...], ... }
  static String getFormTemplate(String templateId) => '/templates/$templateId';

  // ============================================================================
  // Workflow Endpoints
  // ============================================================================

  /// GET - List workflows
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: [{ "id": string, "name": string, "type": string, ... }]
  static const String listWorkflows = '/workflows';

  /// POST - Create workflow
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "name": string, "type": string, "config": {...} }
  /// Returns: { "id": string, "name": string, ... }
  static const String createWorkflow = '/workflows';

  /// PUT - Update workflow
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: Same as createWorkflow
  /// Returns: { "id": string, "message": string, ... }
  static String updateWorkflow(String workflowId) => '/workflows/$workflowId';

  // ============================================================================
  // User Management Endpoints
  // ============================================================================

  /// GET - List users (admin only)
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Query: ?page=int&limit=int&role=string
  /// Returns: [{ "id": string, "username": string, "email": string, ... }]
  static const String listUsers = '/users';

  /// GET - Get user by ID
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "id": string, "username": string, "email": string, ... }
  static String getUser(String userId) => '/users/$userId';

  /// PUT - Update user
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "username": string?, "email": string?, "roles": string[]? }
  /// Returns: { "id": string, "message": string, ... }
  static String updateUser(String userId) => '/users/$userId';

  // ============================================================================
  // File Upload Endpoints
  // ============================================================================

  /// POST - Upload file/image
  /// Headers: { "Authorization": "Bearer {token}", "Content-Type": "multipart/form-data" }
  /// Body: FormData with file
  /// Returns: { "url": string, "filename": string, "size": int }
  static const String uploadFile = '/upload';

  /// POST - Upload signature
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "signature": string (base64), "form_id": string }
  /// Returns: { "url": string, "signature_id": string }
  static const String uploadSignature = '/signatures';

  // ============================================================================
  // Condition/Logic Endpoints
  // ============================================================================

  /// POST - Evaluate conditional logic
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "form_id": string, "conditions": [...], "responses": {...} }
  /// Returns: { "visible_fields": string[], "required_fields": string[] }
  static const String evaluateConditions = '/conditions/evaluate';

  // ============================================================================
  // Translation Endpoints
  // ============================================================================

  /// GET - Get translations for form
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Query: ?form_id=string&language=string
  /// Returns: { "language": string, "translations": {...} }
  static const String getTranslations = '/forms/translations';

  /// POST - Save translations
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "form_id": string, "language": string, "translations": {...} }
  /// Returns: { "message": string }
  static const String saveTranslations = '/forms/translations';

  /// GET - Get translation job details
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "job_id": string, "status": string, "progress": int, ... }
  static String getTranslationJob(String jobId) =>
      '/forms/translations/jobs/$jobId'; // New

  /// POST - Start a new translation job
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "form_id": string, "source_language": string, "target_languages": string[], "total_fields": int }
  /// Returns: { "message": string, "job_id": string }
  static const String startTranslationJob = '/forms/translations/jobs'; // New

  /// PATCH - Cancel a translation job
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "message": string }
  static String cancelTranslationJob(String jobId) =>
      '/forms/translations/jobs/$jobId/cancel'; // New

  /// DELETE - Delete a translation job
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "message": string }
  static String deleteTranslationJob(String jobId) =>
      '/forms/translations/jobs/$jobId'; // New

  /// POST - Preview translation
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "text": string, "source_language": string, "target_language": string }
  /// Returns: { "translated_text": string }
  static const String previewTranslation = '/forms/translations/preview'; // New

  /// GET - List available languages for translation
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: [{ "code": string, "name": string, "native_name": string }]
  static const String listTranslationLanguages =
      '/forms/translations/languages'; // New

  /// GET - Get translated content for a job
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "form_id": string, "language": string, "translations": {...} }
  static String getTranslatedContent(String jobId) =>
      '/forms/translations/jobs/$jobId/content'; // New

  // ============================================================================
  // AI Endpoints
  // ============================================================================

  /// GET - AI service health check
  /// Returns: { "status": "healthy" | "degraded" | "unavailable", ... }
  static const String aiHealthCheck = '/ai/health';

  /// POST - Analyze response with AI (Sentiment, PII)
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "message": string, "results": {...} }
  static String analyzeResponseAI(String formId, String responseId) =>
      '/ai/$formId/responses/$responseId/analyze';

  /// POST - Moderate response with AI (PII, PHI, Profanity, Injection)
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "message": string, "moderation": {...} }
  static String moderateResponseAI(String formId, String responseId) =>
      '/ai/$formId/responses/$responseId/moderate';

  /// POST - Generate form structure with AI
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "prompt": string, "current_form": {...} (optional) }
  /// Returns: { "message": string, "suggestion": {...} }
  static const String generateFormAI = '/ai/generate';

  /// POST - AI Form Design Validation
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "form": {...} }
  /// Returns: { "score": int, "issues": [...], "suggestions": [...] }
  static String validateFormDesign(String formId) =>
      '/ai/$formId/validate-design';

  /// POST - Get AI field suggestions
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "theme": string }
  /// Returns: { "theme": string, "suggestions": [...] }
  static const String getFieldSuggestions = '/ai/suggestions';

  /// GET - List AI form templates
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: [{ "id": string, "name": string, "category": string }]
  static const String listAITemplates = '/ai/templates';

  /// GET - Get specific AI form template structure
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "template": {...} }
  static String getAITemplate(String templateId) => '/ai/templates/$templateId';

  /// GET - Get form sentiment trends
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "form_id": string, "distribution": {...}, "average_score": float }
  static String getFormSentimentTrends(String formId) =>
      '/ai/$formId/sentiment';

  /// POST - AI-Powered Smart Search for form responses
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "query": string, "nocache": boolean (optional) }
  /// Returns: { "query": string, "count": int, "results": [...] }
  static String aiPoweredSearch(String formId) => '/ai/$formId/search';

  /// POST - Detect form anomalies (duplicate content, outliers, gibberish)
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "form_id": string, "anomalies": [...] }
  static String detectFormAnomalies(String formId) => '/ai/$formId/anomalies';

  /// POST - Detect predictive anomalies (spam, statistical outliers, timing)
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "form_id": string, "flagged_responses": [...] }
  static String detectPredictiveAnomalies(String formId) =>
      '/ai/$formId/anomaly-detect';

  /// POST - Automated Security Scanning for Form Definitions
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "form_id": string, "security_score": int, "status": string, ... }
  static String scanFormSecurityAI(String formId) =>
      '/ai/$formId/security-scan';

  /// POST - Compare multiple forms' performance and sentiment
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "form_ids": string[] }
  /// Returns: { "summary": {...}, "details": [...] }
  static const String compareFormsAI = '/ai/cross-analysis';

  /// POST - NLP Summarization: Summarize form responses
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "response_ids": string[] (optional), "max_bullet_points": int, ... }
  /// Returns: { "form_id": string, "summary": {...} }
  static String summarizeFormResponses(String formId) =>
      '/ai/$formId/summarize';

  /// POST - Generate AI-powered export reports for form analytics
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "format": "pdf" | "excel" | "csv" | "json", "include_raw_data": boolean, ... }
  /// Returns: { "message": string, "data": {...} }
  static String exportFormAIReport(String formId) => '/ai/$formId/export';

  /// POST - Manual cache invalidation for a specific form
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "pattern": "all" | "nlp_search" | "summarization" | "by_query", "query": string (optional) }
  /// Returns: { "form_id": string, "keys_invalidated": int, ... }
  static String invalidateFormCache(String formId) =>
      '/ai/$formId/cache/invalidate';

  /// DELETE - Clear all cache for a specific form
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Returns: { "form_id": string, "keys_invalidated": int, ... }
  static String clearFormCache(String formId) => '/ai/$formId/cache';

  // ============================================================================
  // Offline Sync Endpoints
  // ============================================================================

  /// POST - Sync offline data
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Body: { "responses": [...], "last_sync": string }
  /// Returns: { "synced": int, "failed": int, "conflicts": [...] }
  static const String syncOfflineData = '/sync';

  /// GET - Get changes since last sync
  /// Headers: { "Authorization": "Bearer {token}" }
  /// Query: ?last_sync=string&types=forms,responses
  /// Returns: { "forms": [...], "responses": [...], "deleted": [...] }
  static const String getChanges = '/sync/changes';

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

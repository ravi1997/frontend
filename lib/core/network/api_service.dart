import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'api_client_wrapper.dart';
import 'api_endpoints.dart';

import '../../features/form_builder/data/dto/form_dto.dart';

part 'api_service.g.dart';

/// Comprehensive API service providing typed methods for all backend endpoints.
///
/// This service wraps the API client and provides convenient, type-safe methods
/// for interacting with the backend API. All methods automatically handle:
/// - JWT authentication via interceptors
/// - Token refresh on 401 errors
/// - Retry logic on network failures
/// - Error handling and user notifications
/// - Request/response logging
///
/// Usage:
/// ```dart
/// final apiService = ref.read(apiServiceProvider);
/// final forms = await apiService.listForms();
/// ```
class ApiService {
  final ApiClient _client;

  ApiService(this._client);

  // ============================================================================
  // Authentication Methods
  // ============================================================================

  /// Login with email/username and password
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    return response.data as Map<String, dynamic>;
  }

  /// Login with mobile number and OTP
  Future<Map<String, dynamic>> loginWithOtp({
    required String mobile,
    required String otp,
  }) async {
    final response = await _client.post(
      ApiEndpoints.loginWithOtp,
      data: {'mobile': mobile, 'otp': otp},
    );
    return response.data as Map<String, dynamic>;
  }

  /// Request OTP for mobile number
  Future<void> requestOtp(String mobile) async {
    await _client.post(ApiEndpoints.requestOtp, data: {'mobile': mobile});
  }

  /// Register new user
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    String? employeeId,
    String? mobile,
    String userType = 'general',
  }) async {
    final response = await _client.post(
      ApiEndpoints.register,
      data: {
        'username': username,
        'email': email,
        'password': password,
        'user_type': userType,
        if (employeeId != null) 'employee_id': employeeId,
        if (mobile != null) 'mobile': mobile,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// Refresh access token
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await _client.post(
      ApiEndpoints.refreshToken,
      options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
    );
    final data = response.data as Map<String, dynamic>;
    return {
      'access_token': data['access_token'],
      'refresh_token': data['refresh_token'],
      if (data['user'] != null) 'user': data['user'],
    };
  }

  /// Logout user
  Future<void> logout() async {
    await _client.post(ApiEndpoints.logout);
  }

  /// Request password reset
  Future<void> requestPasswordReset(String email) async {
    await _client.post(
      ApiEndpoints.requestPasswordReset,
      data: {'email': email},
    );
  }

  /// Get current user status
  Future<Map<String, dynamic>> getUserStatus() async {
    final response = await _client.get(ApiEndpoints.userStatus);
    return response.data as Map<String, dynamic>;
  }

  /// Revoke all sessions
  Future<void> revokeAll() async {
    await _client.post(ApiEndpoints.revokeAll);
  }

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _client.post(
      ApiEndpoints.changePassword,
      data: {'current_password': currentPassword, 'new_password': newPassword},
    );
  }

  // ============================================================================
  // Form Management Methods
  // ============================================================================

  /// List all forms with optional filters
  Future<List<FormDto>> listForms({
    int? page,
    int? limit,
    String? status,
    String? search,
  }) async {
    final response = await _client.get(
      ApiEndpoints.listForms,
      queryParameters: {
        if (page != null) 'page': page,
        if (limit != null) 'page_size': limit,
        if (status != null) 'status': status,
        if (search != null) 'search': search,
      },
    );
    final data = response.data as Map<String, dynamic>;
    final items = data['items'] as List? ?? (response.data as List? ?? []);
    return (items)
        .map((e) => FormDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Get form by ID
  Future<FormDto> getForm(String formId) async {
    final response = await _client.get(ApiEndpoints.getForm(formId));
    return FormDto.fromJson(response.data as Map<String, dynamic>);
  }

  /// Create new form
  Future<FormDto> createForm({
    required String title,
    String? slug,
    String? status,
    required List<Map<String, dynamic>> sections,
    String? version,
    Map<String, dynamic>? workflows,
  }) async {
    final response = await _client.post(
      ApiEndpoints.createForm,
      data: _buildFormBody(
        title: title,
        slug: slug,
        status: status,
        sections: sections,
        version: version,
        workflows: workflows,
      ),
    );
    // Backend returns { "form_id": "uuid" } after envelope unwrap
    final formId =
        response.data['form_id'] as String? ?? response.data['id'] as String?;
    return getForm(formId!);
  }

  /// Update existing form
  Future<FormDto> updateForm({
    required String formId,
    required String title,
    String? slug,
    String? status,
    required List<Map<String, dynamic>> sections,
    String? version,
    Map<String, dynamic>? workflows,
  }) async {
    await _client.put(
      ApiEndpoints.updateForm(formId),
      data: _buildFormBody(
        title: title,
        slug: slug,
        status: status,
        sections: sections,
        version: version,
        workflows: workflows,
      ),
    );
    return getForm(formId);
  }

  /// Delete form
  Future<void> deleteForm(String formId) async {
    await _client.delete(ApiEndpoints.deleteForm(formId));
  }

  /// Publish form
  Future<Map<String, dynamic>> publishForm(
    String formId, {
    bool major = false,
    bool minor = true,
  }) async {
    final response = await _client.post(
      ApiEndpoints.publishForm(formId),
      data: {'major': major, 'minor': minor},
    );
    return response.data as Map<String, dynamic>;
  }

  /// Clone/duplicate form
  Future<Map<String, dynamic>> cloneForm({
    required String formId,
    required String newTitle,
    String? newSlug,
  }) async {
    final response = await _client.post(
      ApiEndpoints.cloneForm(formId),
      data: {'title': newTitle, if (newSlug != null) 'slug': newSlug},
    );
    return response.data as Map<String, dynamic>;
  }

  /// Get form version history
  Future<List<dynamic>> getFormVersions(String formId) async {
    final response = await _client.get(ApiEndpoints.getFormVersions(formId));
    return response.data as List<dynamic>;
  }

  /// Get specific form version
  Future<Map<String, dynamic>> getFormVersion({
    required String formId,
    required String version,
  }) async {
    final response = await _client.get(
      ApiEndpoints.getFormVersion(formId, version),
    );
    return response.data as Map<String, dynamic>;
  }

  // ============================================================================
  // Response Submission Methods
  // ============================================================================

  /// Submit form response
  Future<Map<String, dynamic>> submitResponse({
    required String formId,
    required Map<String, dynamic> responses,
    String? submittedBy,
    Map<String, dynamic>? metadata,
  }) async {
    final response = await _client.post(
      ApiEndpoints.submitResponse(formId),
      data: {
        'data': responses,
        if (submittedBy != null) 'submitted_by': submittedBy,
        if (metadata != null) 'metadata': metadata,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// List responses with optional filters
  Future<List<dynamic>> listResponses({
    String? formId,
    int? page,
    int? limit,
    String? status,
  }) async {
    final response = await _client.get(
      ApiEndpoints.listResponses(formId!),
      queryParameters: {
        if (page != null) 'page': page,
        if (limit != null) 'page_size': limit,
        if (status != null) 'status': status,
      },
    );
    return response.data as List<dynamic>;
  }

  /// Get single response by ID
  Future<Map<String, dynamic>> getResponse(
    String formId,
    String responseId,
  ) async {
    final response = await _client.get(
      ApiEndpoints.getResponse(formId, responseId),
    );
    return response.data as Map<String, dynamic>;
  }

  /// Update response
  Future<Map<String, dynamic>> updateResponse({
    required String responseId,
    required String formId,
    required Map<String, dynamic> responses,
    String? submittedBy,
    Map<String, dynamic>? metadata,
  }) async {
    final response = await _client.put(
      ApiEndpoints.updateResponse(formId, responseId),
      data: {
        'responses': responses,
        if (submittedBy != null) 'submitted_by': submittedBy,
        if (metadata != null) 'metadata': metadata,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// Delete response
  Future<void> deleteResponse(String formId, String responseId) async {
    await _client.delete(ApiEndpoints.deleteResponse(formId, responseId));
  }

  /// Export responses
  Future<dynamic> exportResponses({
    required String formId,
    String format = 'json',
  }) async {
    final response = await _client.get(
      ApiEndpoints.exportResponses(formId, format: format),
    );
    return response.data;
  }

  // ============================================================================
  // Analytics Methods
  // ============================================================================

  /// Get form analytics
  Future<Map<String, dynamic>> getAnalytics({
    String? formId,
    String? startDate,
    String? endDate,
  }) async {
    final response = await _client.get(
      ApiEndpoints.getAnalytics(formId!),
      queryParameters: {
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// Get dashboard statistics
  Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await _client.get(ApiEndpoints.getDashboardStats);
    return response.data as Map<String, dynamic>;
  }

  // ============================================================================
  // Template Library Methods
  // ============================================================================

  /// List form templates
  Future<List<dynamic>> listFormTemplates({
    String? category,
    String? search,
  }) async {
    final response = await _client.get(
      ApiEndpoints.listFormTemplates,
      queryParameters: {
        if (category != null) 'category': category,
        if (search != null) 'search': search,
      },
    );
    return response.data as List<dynamic>;
  }

  /// Get template by ID
  Future<Map<String, dynamic>> getFormTemplate(String templateId) async {
    final response = await _client.get(
      ApiEndpoints.getFormTemplate(templateId),
    );
    return response.data as Map<String, dynamic>;
  }

  // ============================================================================
  // Workflow Methods
  // ============================================================================

  /// List workflows
  Future<List<dynamic>> listWorkflows() async {
    final response = await _client.get(ApiEndpoints.listWorkflows);
    return response.data as List<dynamic>;
  }

  /// Create workflow
  Future<Map<String, dynamic>> createWorkflow({
    required String name,
    required String type,
    required Map<String, dynamic> config,
  }) async {
    final response = await _client.post(
      ApiEndpoints.createWorkflow,
      data: {'name': name, 'type': type, 'config': config},
    );
    return response.data as Map<String, dynamic>;
  }

  /// Update workflow
  Future<Map<String, dynamic>> updateWorkflow({
    required String workflowId,
    required String name,
    required String type,
    required Map<String, dynamic> config,
  }) async {
    final response = await _client.put(
      ApiEndpoints.updateWorkflow(workflowId),
      data: {'name': name, 'type': type, 'config': config},
    );
    return response.data as Map<String, dynamic>;
  }

  // ============================================================================
  // File Upload Methods
  // ============================================================================

  /// Upload file
  Future<Map<String, dynamic>> uploadFile(FormData formData) async {
    final response = await _client.post(
      ApiEndpoints.uploadFile,
      data: formData,
    );
    return response.data as Map<String, dynamic>;
  }

  /// Upload signature
  Future<Map<String, dynamic>> uploadSignature({
    required String signature,
    required String formId,
  }) async {
    final response = await _client.post(
      ApiEndpoints.uploadSignature,
      data: {'signature': signature, 'form_id': formId},
    );
    return response.data as Map<String, dynamic>;
  }

  // ============================================================================
  // Health Check
  // ============================================================================

  /// Check API health status
  Future<Map<String, dynamic>> healthCheck() async {
    final response = await _client.get(ApiEndpoints.healthCheck);
    return response.data as Map<String, dynamic>;
  }

  /// Helper to build standardized form request body
  Map<String, dynamic> _buildFormBody({
    required String title,
    String? slug,
    String? status,
    required List<Map<String, dynamic>> sections,
    String? version,
    Map<String, dynamic>? workflows,
  }) {
    final v = version ?? '1.0';
    return {
      'title': title,
      if (slug != null) 'slug': slug,
      'status': status ?? 'draft',
      'versions': [
        {
          'version': v,
          'sections': sections,
          'created_at': DateTime.now().toIso8601String(),
        },
      ],
      'active_version': v,
      if (workflows != null) 'workflows': workflows,
    };
  }
}

/// Riverpod provider for ApiService
@riverpod
ApiService apiService(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiService(apiClient);
}

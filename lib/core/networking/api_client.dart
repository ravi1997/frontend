import 'package:dio/dio.dart';
import 'package:frontend/modules/dashboard_builder/models/dashboard_canvas_models.dart';
import 'package:frontend/modules/forms/models/condition_rule.dart';
import 'package:frontend/modules/forms/models/signature_request.dart';
import 'package:frontend/modules/forms/models/workflow.dart';
import 'package:frontend/modules/forms/models/form_template.dart';
import 'api_endpoints.dart';
import 'api_requests.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Map<String, dynamic> _map(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.get(path, queryParameters: queryParameters, options: options);

  Future<Response<dynamic>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

  Future<Response<dynamic>> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

  Future<Response<dynamic>> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

  Future<Response<dynamic>> deleteRaw(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

  List<dynamic> _list(dynamic value) => value is List ? value : const [];

  Future<Map<String, dynamic>> getMap(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.get(path, queryParameters: queryParameters);
    return _map(response.data);
  }

  Future<List<dynamic>> getList(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.get(path, queryParameters: queryParameters);
    final data = response.data;
    if (data is List) return data;
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      return _list(
        map['items'] ?? map['data'] ?? map['results'] ?? map['forms'],
      );
    }
    return const [];
  }

  Future<Map<String, dynamic>> postMap(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return _map(response.data);
  }

  Future<List<dynamic>> postList(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return _list(response.data);
  }

  Future<Map<String, dynamic>> putMap(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return _map(response.data);
  }

  Future<List<dynamic>> putList(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return _list(response.data);
  }

  Future<Map<String, dynamic>> patchMap(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return _map(response.data);
  }

  Future<void> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // Auth
  Future<Map<String, dynamic>> login(LoginRequest request) =>
      postMap(ApiEndpoints.login, data: request.toJson());
  Future<Map<String, dynamic>> loginWithOtp(OtpLoginRequest request) =>
      postMap(ApiEndpoints.loginWithOtp, data: request.toJson());
  Future<void> requestOtp(OtpRequest request) async {
    await postMap(ApiEndpoints.requestOtp, data: request.toJson());
  }

  Future<void> requestPasswordReset(PasswordResetRequest request) async {
    await postMap(ApiEndpoints.requestPasswordReset, data: request.toJson());
  }
  Future<Map<String, dynamic>> register(RegisterRequest request) =>
      postMap(ApiEndpoints.register, data: request.toJson());
  Future<void> logout() async {
    await postMap(ApiEndpoints.logout);
  }
  Future<Map<String, dynamic>> refreshToken(String refreshToken) =>
      postMap(
        ApiEndpoints.refreshToken,
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );
  Future<void> revokeAll() async {
    await postMap(ApiEndpoints.revokeAll);
  }

  Future<void> changePassword(ChangePasswordRequest request) async {
    await postMap(ApiEndpoints.changePassword, data: request.toJson());
  }
  Future<Map<String, dynamic>> oidcCallback(
    String code,
    String state,
  ) =>
      postMap('/auth/oidc/callback', data: {'code': code, 'state': state});
  Future<Map<String, dynamic>> currentUser() => getMap(ApiEndpoints.userProfile);

  // Projects
  Future<Map<String, dynamic>> createProject(ProjectRequest request) =>
      postMap(ApiEndpoints.createProject, data: request.toJson());
  Future<Map<String, dynamic>> createProjectRaw(Map<String, dynamic> data) =>
      postMap(ApiEndpoints.createProject, data: data);
  Future<List<dynamic>> listProjects() => getList(ApiEndpoints.listProjects);
  Future<Map<String, dynamic>> getProject(String projectId) =>
      getMap(ApiEndpoints.getProject(projectId));
  Future<Map<String, dynamic>> updateProject(
    String projectId,
    ProjectRequest request,
  ) =>
      putMap(ApiEndpoints.updateProject(projectId), data: request.toJson());
  Future<void> deleteProject(String projectId) =>
      delete(ApiEndpoints.deleteProject(projectId));
  Future<void> deleteProjectRaw(String projectId) =>
      delete(ApiEndpoints.deleteProject(projectId));

  // Forms
  Future<Map<String, dynamic>> createForm(
    String projectId,
    CreateFormRequest request,
  ) =>
      postMap(ApiEndpoints.createProjectForm(projectId), data: request.toJson());
  Future<Map<String, dynamic>> createProjectFormRaw(
    String projectId,
    Map<String, dynamic> data,
  ) =>
      postMap(ApiEndpoints.createProjectForm(projectId), data: data);
  Future<Map<String, dynamic>> updateForm(
    String projectId,
    String formId,
    UpdateFormRequest request,
  ) =>
      putMap(ApiEndpoints.updateProjectForm(projectId, formId), data: request.toJson());
  Future<Map<String, dynamic>> saveFormDraft(
    String projectId,
    String formId,
    FormDraftRequest request,
  ) =>
      putMap(ApiEndpoints.saveFormDraft(projectId, formId), data: request.toJson());
  Future<Map<String, dynamic>> publishForm(
    String projectId,
    String formId,
    PublishRequest request,
  ) =>
      postMap(ApiEndpoints.publishProjectForm(projectId, formId), data: request.toJson());
  Future<Map<String, dynamic>> cloneForm(
    String projectId,
    String formId,
    CloneFormRequest request,
  ) =>
      postMap(ApiEndpoints.cloneProjectForm(projectId, formId), data: request.toJson());
  Future<Map<String, dynamic>> getForm(String projectId, String formId) =>
      getMap(ApiEndpoints.getProjectForm(projectId, formId));
  Future<List<dynamic>> listProjectForms(String projectId) =>
      getList(ApiEndpoints.listProjectForms(projectId));
  Future<List<dynamic>> listSections(String projectId, String formId) =>
      getList(ApiEndpoints.listSections(projectId, formId));
  Future<List<dynamic>> getFormVersions(String projectId, String formId) =>
      getList(ApiEndpoints.getFormVersions(projectId, formId));
  Future<Map<String, dynamic>> getFormVersion(
    String projectId,
    String formId,
    String version,
  ) =>
      getMap(ApiEndpoints.getFormVersion(projectId, formId, version));
  Future<Map<String, dynamic>> restoreFormVersion(
    String projectId,
    String formId,
    String version,
  ) =>
      postMap(ApiEndpoints.restoreFormVersion(projectId, formId, version));
  Future<Map<String, dynamic>> updateFormVersion(
    String projectId,
    String formId,
    String version,
    Object data,
  ) =>
      putMap(ApiEndpoints.updateFormVersion(projectId, formId, version), data: data);
  Future<Map<String, dynamic>> createFormVersion(
    String projectId,
    String formId,
    Object data,
  ) =>
      postMap(ApiEndpoints.createFormVersion(projectId, formId), data: data);
  Future<Map<String, dynamic>> builderMetadata() =>
      getMap(ApiEndpoints.builderMetadata);
  Future<bool> isSlugAvailable(String slug, {String? formId}) async {
    final data = await getMap(
      ApiEndpoints.checkSlugAvailable,
      queryParameters: {'slug': slug, if (formId != null) 'form_id': formId},
    );
    final nested = data['data'];
    if (nested is Map) {
      final map = Map<String, dynamic>.from(nested);
      return map['available'] == true;
    }
    return data['available'] == true;
  }
  Future<Map<String, dynamic>> exportSchema(String projectId, String formId) =>
      getMap(ApiEndpoints.exportFormSchema(projectId, formId));
  Future<void> importSchema(String projectId, Object data) =>
      postMap(ApiEndpoints.importFormSchema(projectId), data: data);
  Future<List<dynamic>> listFieldTemplates() => getList(ApiEndpoints.listFieldTemplates);
  Future<List<dynamic>> listTemplates() => getList(ApiEndpoints.listFormTemplates);
  Future<Map<String, dynamic>> createFieldTemplate(Map<String, dynamic> data) =>
      postMap(ApiEndpoints.createFieldTemplate, data: data);
  Future<Map<String, dynamic>> getTemplate(String templateId) =>
      getMap(ApiEndpoints.getFormTemplate(templateId));
  Future<Map<String, dynamic>> createFormFromTemplate(
    String templateId,
    String formName,
  ) =>
      postMap('/templates/$templateId/create-form', data: {'name': formName});
  Future<void> incrementTemplateUsage(String templateId) =>
      postMap('/templates/$templateId/increment-usage');
  Future<Map<String, dynamic>> createCustomTemplate(
    String formId,
    String templateName,
    String description,
    FormTemplateCategory category,
    List<String> tags,
  ) =>
      postMap('/templates', data: {
        'formId': formId,
        'name': templateName,
        'description': description,
        'category': category.name,
        'tags': tags,
      });
  Future<void> deleteTemplate(String templateId) =>
      delete('/templates/$templateId');
  Future<Map<String, dynamic>> getTranslations({
    String? formId,
    String? language,
  }) =>
      getMap(
        ApiEndpoints.getFormTranslations(formId: formId, language: language),
      );
  Future<void> saveTranslations(Object data) =>
      postMap(ApiEndpoints.saveFormTranslations, data: data);
  Future<Map<String, dynamic>> startTranslationJob(
    TranslationJobRequest request,
  ) =>
      postMap(ApiEndpoints.startTranslationJob, data: request.toJson());
  Future<List<dynamic>> listTranslationJobs(String formId) =>
      getList(ApiEndpoints.listTranslationJobs(formId));
  Future<Map<String, dynamic>> getTranslationJob(String jobId) =>
      getMap(ApiEndpoints.getTranslationJob(jobId));
  Future<Map<String, dynamic>> cancelTranslationJob(String jobId) =>
      patchMap(ApiEndpoints.cancelTranslationJob(jobId));
  Future<void> deleteTranslationJob(String jobId) =>
      delete(ApiEndpoints.deleteTranslationJob(jobId));
  Future<Map<String, dynamic>> previewTranslation(
    TranslationPreviewRequest request,
  ) =>
      postMap(ApiEndpoints.previewTranslation, data: request.toJson());
  Future<List<dynamic>> listTranslationLanguages() =>
      getList(ApiEndpoints.listTranslationLanguages);
  Future<Map<String, dynamic>> getTranslatedContent(String jobId) =>
      getMap(ApiEndpoints.getTranslatedContent(jobId));
  Future<List<dynamic>> getFormConditions(String formId) =>
      getList('/forms/$formId/conditions');
  Future<List<dynamic>> getFormConditionsForField(
    String formId,
    String fieldId,
  ) =>
      getList('/forms/$formId/conditions', queryParameters: {'fieldId': fieldId});
  Future<List<dynamic>> getResponses(String projectId, String formId) =>
      getList(
        projectId.isEmpty
            ? ApiEndpoints.listResponses(formId)
            : ApiEndpoints.listProjectResponses(projectId, formId),
      );
  Future<Map<String, dynamic>> getResponseDetail(
    String projectId,
    String formId,
    String responseId,
  ) =>
      getMap(
        projectId.isEmpty
            ? ApiEndpoints.getResponse(formId, responseId)
            : ApiEndpoints.getProjectResponse(projectId, formId, responseId),
      );
  Future<void> submitFormResponse(
    String projectId,
    String formId,
    Map<String, dynamic> payload,
  ) =>
      postMap(
        projectId.isEmpty
            ? ApiEndpoints.submitResponse(formId)
            : ApiEndpoints.submitProjectResponse(projectId, formId),
        data: payload,
      );
  Future<List<dynamic>> searchResponses(String formId, String query) =>
      postList('/responses/search', data: {'form_id': formId, 'query': query});
  Future<List<dynamic>> getResponseHistory(
    String projectId,
    String formId,
    String responseId,
  ) =>
      getList(
        projectId.isEmpty
            ? ApiEndpoints.getResponseHistory(formId, responseId)
            : ApiEndpoints.getProjectResponseHistory(projectId, formId, responseId),
      );
  Future<List<dynamic>> getWorkflows(String formId) =>
      getList('/forms/$formId/workflows');
  Future<Map<String, dynamic>> getWorkflow(String workflowId) =>
      getMap('/workflows/$workflowId');
  Future<Map<String, dynamic>> createWorkflow(Workflow workflow) =>
      postMap('/forms/${workflow.formId}/workflows', data: workflow.toJson());
  Future<Map<String, dynamic>> updateWorkflow(Workflow workflow) =>
      putMap('/workflows/${workflow.id}', data: workflow.toJson());
  Future<void> deleteWorkflow(String workflowId) =>
      delete('/workflows/$workflowId');
  Future<Map<String, dynamic>> activateWorkflow(String workflowId) =>
      postMap('/workflows/$workflowId/activate');
  Future<Map<String, dynamic>> pauseWorkflow(String workflowId) =>
      postMap('/workflows/$workflowId/pause');
  Future<Map<String, dynamic>> resetWorkflow(String workflowId) =>
      postMap('/workflows/$workflowId/reset');
  Future<List<dynamic>> getRules(String formId) =>
      getList('/forms/$formId/conditions');
  Future<List<dynamic>> getRulesForField(String formId, String fieldId) =>
      getList('/forms/$formId/conditions', queryParameters: {'fieldId': fieldId});
  Future<Map<String, dynamic>> getRule(String ruleId) =>
      getMap('/conditions/$ruleId');
  Future<Map<String, dynamic>> createRule(ConditionalRule rule) =>
      postMap('/forms/${rule.targetId.split(".")[0]}/conditions', data: rule.toJson());
  Future<Map<String, dynamic>> updateRule(ConditionalRule rule) =>
      putMap('/conditions/${rule.id}', data: rule.toJson());
  Future<void> deleteRule(String ruleId) =>
      delete('/conditions/$ruleId');
  Future<void> reorderRules(String formId, List<String> ruleIds) =>
      putMap('/forms/$formId/conditions/reorder', data: {'ruleIds': ruleIds});
  Future<Map<String, dynamic>> evaluateRules(
    String formId,
    Map<String, dynamic> fieldValues,
  ) =>
      postMap('/forms/$formId/conditions/evaluate', data: {'fieldValues': fieldValues});
  Future<Map<String, dynamic>> createSignatureRequest(SignatureRequest request) =>
      postMap('/forms/${request.formId}/signature-requests', data: request.toJson());
  Future<Map<String, dynamic>> getSignatureRequest(String requestId) =>
      getMap('/signature-requests/$requestId');
  Future<List<dynamic>> getSignatureRequestsForForm(String formId) =>
      getList('/forms/$formId/signature-requests');
  Future<List<dynamic>> getSignatureRequestsForSigner(String email) =>
      getList('/signature-requests', queryParameters: {'email': email});
  Future<Map<String, dynamic>> sendSignatureRequest(String requestId) =>
      postMap('/signature-requests/$requestId/send');
  Future<Map<String, dynamic>> markSignatureViewed(
    String requestId, {
    required String ipAddress,
    required String userAgent,
  }) =>
      postMap('/signature-requests/$requestId/view', data: {'ipAddress': ipAddress, 'userAgent': userAgent});
  Future<Map<String, dynamic>> recordSignature(
    String requestId, {
    required String signatureData,
    required String ipAddress,
  }) =>
      postMap('/signature-requests/$requestId/sign', data: {'signatureData': signatureData, 'ipAddress': ipAddress});
  Future<Map<String, dynamic>> declineSignatureRequest(
    String requestId, {
    required String ipAddress,
    String? reason,
  }) =>
      postMap('/signature-requests/$requestId/decline', data: {'ipAddress': ipAddress, 'reason': reason});
  Future<void> cancelSignatureRequest(String requestId) =>
      delete('/signature-requests/$requestId');
  Future<List<dynamic>> getSignatureAuditTrail(String requestId) =>
      getList('/signature-requests/$requestId/audit');
  Future<Map<String, dynamic>> verifySignature(String requestId) =>
      getMap('/signature-requests/$requestId/verify');
  Future<Map<String, dynamic>> generateSigningDocument(String requestId) =>
      getMap('/signature-requests/$requestId/document');

  // Responses
  Future<Map<String, dynamic>> submitResponse(
    String projectId,
    String formId,
    ResponseSubmissionRequest request, {
    bool public = false,
  }) =>
      postMap(
        public
            ? ApiEndpoints.publicSubmit(formId)
            : (projectId.isEmpty
                ? ApiEndpoints.submitResponse(formId)
                : ApiEndpoints.submitProjectResponse(projectId, formId)),
        data: request.toJson(),
      );
  Future<List<dynamic>> listResponses(String projectId, String formId) =>
      getList(
        projectId.isEmpty
            ? ApiEndpoints.listResponses(formId)
            : ApiEndpoints.listProjectResponses(projectId, formId),
      );
  Future<Map<String, dynamic>> getResponse(
    String projectId,
    String formId,
    String responseId,
  ) =>
      getMap(
        projectId.isEmpty
            ? ApiEndpoints.getResponse(formId, responseId)
            : ApiEndpoints.getProjectResponse(projectId, formId, responseId),
      );
  Future<Map<String, dynamic>> updateResponse(
    String projectId,
    String formId,
    String responseId,
    ResponseSubmissionRequest request,
  ) =>
      putMap(
        projectId.isEmpty
            ? ApiEndpoints.updateResponse(formId, responseId)
            : ApiEndpoints.updateProjectResponse(projectId, formId, responseId),
        data: request.toJson(),
      );
  Future<void> deleteResponse(
    String projectId,
    String formId,
    String responseId,
  ) =>
      delete(
        projectId.isEmpty
            ? ApiEndpoints.deleteResponse(formId, responseId)
            : ApiEndpoints.deleteProjectResponse(projectId, formId, responseId),
      );
  Future<List<dynamic>> responseHistory(
    String projectId,
    String formId,
    String responseId,
  ) =>
      getList(
        projectId.isEmpty
            ? ApiEndpoints.getResponseHistory(formId, responseId)
            : ApiEndpoints.getProjectResponseHistory(projectId, formId, responseId),
      );
  Future<List<dynamic>> sameFormLookup(
    String formId,
    String questionId,
    String value,
  ) =>
      getList(ApiEndpoints.sameFormLookup(formId, questionId, value));
  Future<List<dynamic>> filteredResponses(
    String projectId,
    String formId,
    ResponseFilterRequest request,
  ) =>
      postList(
        projectId.isEmpty
            ? ApiEndpoints.filterResponses(formId)
            : '/projects/$projectId/forms/$formId/responses/filter',
        data: request.toJson(),
      );
  Future<List<dynamic>> submissionHistory(String formId) =>
      getList(ApiEndpoints.submissionHistory(formId));
  Future<Map<String, dynamic>> responseCount(String formId) =>
      getMap(ApiEndpoints.responseCount(formId));
  Future<Map<String, dynamic>> lastResponse(String formId) =>
      getMap(ApiEndpoints.lastResponse(formId));
  Future<Map<String, dynamic>> checkDuplicate(
    String formId,
    ResponseSubmissionRequest request,
  ) =>
      postMap(ApiEndpoints.checkDuplicate(formId), data: request.toJson());

  // Dashboard
  Future<List<dynamic>> listDashboardsForProject(String projectId) =>
      getList('/dashboards/', queryParameters: {'project_id': projectId});
  Future<Map<String, dynamic>> createDashboard(DashboardCreateRequest request) =>
      postMap(ApiEndpoints.createDashboard, data: request.toJson());
  Future<Map<String, dynamic>> getDashboardCanvas(
    String dashboardId, {
    bool includeData = false,
  }) =>
      getMap(
        '/dashboards/$dashboardId/canvas',
        queryParameters: includeData ? {'include_data': '1'} : null,
      );
  Future<void> saveDashboardCanvas(
    String dashboardId,
    DashboardCanvas canvas,
  ) =>
      putMap('/dashboards/$dashboardId/canvas', data: canvas.toJson());
  Future<Map<String, dynamic>> getDashboard(String dashboardId) =>
      getMap(ApiEndpoints.getDashboard(dashboardId));
  Future<Map<String, dynamic>> updateDashboard(
    String dashboardId,
    DashboardUpdateRequest request,
  ) =>
      putMap(ApiEndpoints.updateDashboard(dashboardId), data: request.toJson());
  Future<void> deleteDashboard(String dashboardId) =>
      delete('/dashboards/$dashboardId');
  Future<String?> shareDashboard(String dashboardId) async {
    final data = await postMap('/dashboards/$dashboardId/share');
    return data['public_token']?.toString() ??
        (data['dashboard'] is Map
            ? Map<String, dynamic>.from(data['dashboard'] as Map)['public_token']?.toString()
            : null);
  }
  Future<void> unshareDashboard(String dashboardId) =>
      delete('/dashboards/$dashboardId/share');
  Future<Map<String, dynamic>> publicDashboard(String shareToken) =>
      getMap('/dashboards/shared/$shareToken');
  Future<List<dynamic>> listThemes() => getList(ApiEndpoints.themes);
  Future<Map<String, dynamic>> createTheme(Map<String, dynamic> payload) =>
      postMap(ApiEndpoints.themes, data: payload);
  Future<Map<String, dynamic>> updateTheme(
    String themeId,
    Map<String, dynamic> payload,
  ) =>
      putMap(ApiEndpoints.theme(themeId), data: payload);
  Future<void> deleteTheme(String themeId) =>
      delete(ApiEndpoints.theme(themeId));
  Future<Map<String, dynamic>> applyFormTheme(
    String projectId,
    String formId,
    Map<String, dynamic> payload,
  ) =>
      postMap(ApiEndpoints.applyFormTheme(projectId, formId), data: payload);
  Future<Map<String, dynamic>> getFormAudit(
    String projectId,
    String formId, {
    int page = 1,
    int pageSize = 25,
    String? action,
    String? actorId,
  }) =>
      getMap(
        ApiEndpoints.formAudit(projectId, formId),
        queryParameters: {
          'page': page,
          'page_size': pageSize,
          if (action != null && action.isNotEmpty) 'action': action,
          if (actorId != null && actorId.isNotEmpty) 'actor_id': actorId,
        },
      );
  Future<Map<String, dynamic>> dashboardWidgetData(
    String dashboardId,
    String widgetId,
  ) =>
      getMap('/dashboards/$dashboardId/widgets/$widgetId/data');
  Future<Map<String, dynamic>> dashboardFilterOptions(String dashboardId) =>
      getMap('/dashboards/$dashboardId/filter-options');
  Future<List<dynamic>> dashboardSnapshots(String dashboardId) =>
      getList('/dashboards/$dashboardId/snapshots');
  Future<Map<String, dynamic>> dashboardSnapshot(
    String dashboardId,
    String snapshotId,
  ) =>
      getMap('/dashboards/$dashboardId/snapshots/$snapshotId');
  Future<Map<String, dynamic>> publicDashboardData(String dashboardId) =>
      getMap('/dashboards/$dashboardId/public-data');
  Future<Map<String, dynamic>> getAnalyticsSummary(String formId) =>
      getMap('/forms/$formId/analytics/summary');
  Future<dynamic> getAnalyticsTimeline(
    String formId, {
    int days = 30,
  }) =>
      get('/forms/$formId/analytics/timeline', queryParameters: {'days': days});
  Future<dynamic> getAnalyticsDistribution(String formId) =>
      get('/forms/$formId/analytics/distribution');
  Future<Map<String, dynamic>> getDashboardStats() =>
      getMap(ApiEndpoints.getDashboardStats);
  Future<Map<String, dynamic>> getTaskStatus(String taskId) =>
      getMap(ApiEndpoints.taskStatus(taskId));
  Future<Map<String, dynamic>> oidcLogin(String organizationId) =>
      getMap('/auth/oidc/login?organization_id=$organizationId');
  Future<List<dynamic>> listOrganizations() => getList('/admin/organizations');
  Future<List<dynamic>> listComplianceStandards() =>
      getList('/admin/compliance-standards');
  Future<Map<String, dynamic>> updateOrganizationCompliance(
    String orgId,
    List<String> complianceIds,
  ) =>
      putMap('/admin/organizations/$orgId/compliance',
          data: {'compliance_ids': complianceIds});
  Future<Map<String, dynamic>> createOrg(OrgRequest request) =>
      postMap(ApiEndpoints.createOrg, data: request.toJson());
  Future<List<dynamic>> listOrgs() => getList(ApiEndpoints.listOrgs);
  Future<Map<String, dynamic>> updateOrgStatus(
    String orgId,
    String status,
  ) =>
      putMap(ApiEndpoints.updateOrgStatus(orgId), data: {'status': status});
  Future<Map<String, dynamic>> assignOrgAdmin(
    String orgId,
    String adminEmail,
  ) =>
      putMap(ApiEndpoints.assignOrgAdmin(orgId), data: {'admin_email': adminEmail});
  Future<Map<String, dynamic>> getOrgStats(String orgId) =>
      getMap(ApiEndpoints.getOrgStats(orgId));
  Future<Map<String, dynamic>> getOrganizationQuota(String orgId) =>
      getMap('/admin/organizations/$orgId/quota');
  Future<Map<String, dynamic>> updateOrganizationQuota(
    String orgId,
    int quotaBytes,
  ) =>
      putMap('/admin/organizations/$orgId/quota', data: {'quota_bytes': quotaBytes});
  Future<List<dynamic>> listWebhooksRaw() => getList('/webhooks');
  Future<Map<String, dynamic>> createWebhookRaw(Map<String, dynamic> data) =>
      postMap('/webhooks', data: data);
  Future<Map<String, dynamic>> updateWebhookRaw(
    String webhookId,
    Map<String, dynamic> data,
  ) =>
      putMap('/webhooks/$webhookId', data: data);
  Future<void> deleteWebhookRaw(String webhookId) => delete('/webhooks/$webhookId');
  Future<Map<String, dynamic>> testWebhookRaw(String webhookId) =>
      postMap('/webhooks/$webhookId/test');

  // Admin / platform
  Future<Map<String, dynamic>> createApiKey(ApiKeyCreateRequest request) =>
      postMap(ApiEndpoints.createApiKey, data: request.toJson());
  Future<List<dynamic>> listApiKeys() => getList(ApiEndpoints.listApiKeys);
  Future<List<dynamic>> listFeatureFlags() =>
      getList(ApiEndpoints.listFeatureFlags);
  Future<Map<String, dynamic>> updateGlobalFeatureFlag(
    String flagKey,
    bool isEnabled,
  ) =>
      putMap(
        ApiEndpoints.updateGlobalFeatureFlag(flagKey),
        data: {'is_enabled': isEnabled},
      );
  Future<Map<String, dynamic>> updateFeatureFlagOverride(
    String flagKey,
    String orgId,
    bool isEnabled,
  ) =>
      putMap(
        ApiEndpoints.updateFeatureFlagOverride(flagKey, orgId),
        data: {'is_enabled': isEnabled},
      );
  Future<List<dynamic>> listWebhooks({String? formId}) =>
      getList(ApiEndpoints.adminWebhooks, queryParameters: {
        if (formId != null) 'form_id': formId,
      });
  Future<Map<String, dynamic>> createWebhook(Map<String, dynamic> payload) =>
      postMap(ApiEndpoints.createAdminWebhook, data: payload);
  Future<void> deleteWebhook(String webhookId) =>
      delete(ApiEndpoints.deleteAdminWebhook(webhookId));
  Future<Map<String, dynamic>> testWebhook(
    String? webhookId, {
    String? url,
    Map<String, dynamic>? payload,
  }) {
    if (webhookId == null || webhookId.isEmpty) {
      return postMap(
        ApiEndpoints.webhookTest('test'),
        data: {'url': url, 'payload': payload},
      );
    }
    return postMap(
      ApiEndpoints.testAdminWebhook(webhookId),
      data: {'payload': payload},
    );
  }
  Future<List<dynamic>> webhookLogs({
    String? webhookId,
    int? page,
    int? limit,
  }) =>
      getList(
        webhookId == null
            ? ApiEndpoints.webhookLogs('')
            : ApiEndpoints.adminWebhookLogs(webhookId),
        queryParameters: {
          if (page != null) 'page': page,
          if (limit != null) 'limit': limit,
        },
      );
  Future<Map<String, dynamic>> sendSms(Map<String, dynamic> payload) =>
      postMap(ApiEndpoints.sendSms, data: payload);
  Future<Map<String, dynamic>> sendNotification(Map<String, dynamic> payload) =>
      postMap(ApiEndpoints.sendNotification, data: payload);
}

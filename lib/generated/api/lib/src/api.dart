//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:dio/dio.dart';
import 'package:ridp_api/src/auth/api_key_auth.dart';
import 'package:ridp_api/src/auth/basic_auth.dart';
import 'package:ridp_api/src/auth/bearer_auth.dart';
import 'package:ridp_api/src/auth/oauth.dart';
import 'package:ridp_api/src/api/admin_tasks_api.dart';
import 'package:ridp_api/src/api/advanced_responses_api.dart';
import 'package:ridp_api/src/api/ai_api.dart';
import 'package:ridp_api/src/api/analysis_board_api.dart';
import 'package:ridp_api/src/api/analytics_api.dart';
import 'package:ridp_api/src/api/anomaly_api.dart';
import 'package:ridp_api/src/api/auth_api.dart';
import 'package:ridp_api/src/api/dashboard_api.dart';
import 'package:ridp_api/src/api/dashboard_settings_api.dart';
import 'package:ridp_api/src/api/env_config_api.dart';
import 'package:ridp_api/src/api/external_api_api.dart';
import 'package:ridp_api/src/api/form_api.dart';
import 'package:ridp_api/src/api/form_hooks_api.dart';
import 'package:ridp_api/src/api/library_api.dart';
import 'package:ridp_api/src/api/nlp_search_api.dart';
import 'package:ridp_api/src/api/permissions_api.dart';
import 'package:ridp_api/src/api/project_api.dart';
import 'package:ridp_api/src/api/project_hooks_api.dart';
import 'package:ridp_api/src/api/section_api.dart';
import 'package:ridp_api/src/api/section_hooks_api.dart';
import 'package:ridp_api/src/api/sms_api.dart';
import 'package:ridp_api/src/api/system_api.dart';
import 'package:ridp_api/src/api/system_settings_api.dart';
import 'package:ridp_api/src/api/tasks_api.dart';
import 'package:ridp_api/src/api/themes_api.dart';
import 'package:ridp_api/src/api/translation_api.dart';
import 'package:ridp_api/src/api/user_api.dart';
import 'package:ridp_api/src/api/view_api.dart';
import 'package:ridp_api/src/api/webhooks_api.dart';
import 'package:ridp_api/src/api/workflow_api.dart';

class RidpApi {
  static const String basePath = r'http://localhost';

  final Dio dio;
  RidpApi({
    Dio? dio,
    String? basePathOverride,
    List<Interceptor>? interceptors,
  })  : 
        this.dio = dio ??
            Dio(BaseOptions(
              baseUrl: basePathOverride ?? basePath,
              connectTimeout: const Duration(milliseconds: 5000),
              receiveTimeout: const Duration(milliseconds: 3000),
            )) {
    if (interceptors == null) {
      this.dio.interceptors.addAll([
        OAuthInterceptor(),
        BasicAuthInterceptor(),
        BearerAuthInterceptor(),
        ApiKeyAuthInterceptor(),
      ]);
    } else {
      this.dio.interceptors.addAll(interceptors);
    }
  }

  void setOAuthToken(String name, String token) {
    if (this.dio.interceptors.any((i) => i is OAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is OAuthInterceptor) as OAuthInterceptor).tokens[name] = token;
    }
  }

  void setBearerAuth(String name, String token) {
    if (this.dio.interceptors.any((i) => i is BearerAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BearerAuthInterceptor) as BearerAuthInterceptor).tokens[name] = token;
    }
  }

  void setBasicAuth(String name, String username, String password) {
    if (this.dio.interceptors.any((i) => i is BasicAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BasicAuthInterceptor) as BasicAuthInterceptor).authInfo[name] = BasicAuthInfo(username, password);
    }
  }

  void setApiKey(String name, String apiKey) {
    if (this.dio.interceptors.any((i) => i is ApiKeyAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((element) => element is ApiKeyAuthInterceptor) as ApiKeyAuthInterceptor).apiKeys[name] = apiKey;
    }
  }

  /// Get AdminTasksApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminTasksApi getAdminTasksApi() {
    return AdminTasksApi(dio);
  }

  /// Get AdvancedResponsesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdvancedResponsesApi getAdvancedResponsesApi() {
    return AdvancedResponsesApi(dio);
  }

  /// Get AiApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AiApi getAiApi() {
    return AiApi(dio);
  }

  /// Get AnalysisBoardApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AnalysisBoardApi getAnalysisBoardApi() {
    return AnalysisBoardApi(dio);
  }

  /// Get AnalyticsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AnalyticsApi getAnalyticsApi() {
    return AnalyticsApi(dio);
  }

  /// Get AnomalyApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AnomalyApi getAnomalyApi() {
    return AnomalyApi(dio);
  }

  /// Get AuthApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AuthApi getAuthApi() {
    return AuthApi(dio);
  }

  /// Get DashboardApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DashboardApi getDashboardApi() {
    return DashboardApi(dio);
  }

  /// Get DashboardSettingsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DashboardSettingsApi getDashboardSettingsApi() {
    return DashboardSettingsApi(dio);
  }

  /// Get EnvConfigApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  EnvConfigApi getEnvConfigApi() {
    return EnvConfigApi(dio);
  }

  /// Get ExternalApiApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ExternalApiApi getExternalApiApi() {
    return ExternalApiApi(dio);
  }

  /// Get FormApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  FormApi getFormApi() {
    return FormApi(dio);
  }

  /// Get FormHooksApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  FormHooksApi getFormHooksApi() {
    return FormHooksApi(dio);
  }

  /// Get LibraryApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  LibraryApi getLibraryApi() {
    return LibraryApi(dio);
  }

  /// Get NlpSearchApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  NlpSearchApi getNlpSearchApi() {
    return NlpSearchApi(dio);
  }

  /// Get PermissionsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  PermissionsApi getPermissionsApi() {
    return PermissionsApi(dio);
  }

  /// Get ProjectApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ProjectApi getProjectApi() {
    return ProjectApi(dio);
  }

  /// Get ProjectHooksApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ProjectHooksApi getProjectHooksApi() {
    return ProjectHooksApi(dio);
  }

  /// Get SectionApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  SectionApi getSectionApi() {
    return SectionApi(dio);
  }

  /// Get SectionHooksApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  SectionHooksApi getSectionHooksApi() {
    return SectionHooksApi(dio);
  }

  /// Get SmsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  SmsApi getSmsApi() {
    return SmsApi(dio);
  }

  /// Get SystemApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  SystemApi getSystemApi() {
    return SystemApi(dio);
  }

  /// Get SystemSettingsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  SystemSettingsApi getSystemSettingsApi() {
    return SystemSettingsApi(dio);
  }

  /// Get TasksApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  TasksApi getTasksApi() {
    return TasksApi(dio);
  }

  /// Get ThemesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ThemesApi getThemesApi() {
    return ThemesApi(dio);
  }

  /// Get TranslationApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  TranslationApi getTranslationApi() {
    return TranslationApi(dio);
  }

  /// Get UserApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  UserApi getUserApi() {
    return UserApi(dio);
  }

  /// Get ViewApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ViewApi getViewApi() {
    return ViewApi(dio);
  }

  /// Get WebhooksApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  WebhooksApi getWebhooksApi() {
    return WebhooksApi(dio);
  }

  /// Get WorkflowApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  WorkflowApi getWorkflowApi() {
    return WorkflowApi(dio);
  }
}

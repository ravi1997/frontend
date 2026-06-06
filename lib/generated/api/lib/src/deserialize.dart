import 'package:ridp_api/src/model/access_entry_schema.dart';
import 'package:ridp_api/src/model/analytics_state_schema.dart';
import 'package:ridp_api/src/model/approval_log_schema.dart';
import 'package:ridp_api/src/model/approval_step_schema.dart';
import 'package:ridp_api/src/model/approval_workflow_schema.dart';
import 'package:ridp_api/src/model/base_embedded_schema.dart';
import 'package:ridp_api/src/model/base_schema.dart';
import 'package:ridp_api/src/model/conditional_validation_schema.dart';
import 'package:ridp_api/src/model/dynamic_view_definition_schema.dart';
import 'package:ridp_api/src/model/form_blueprint_schema.dart';
import 'package:ridp_api/src/model/form_response_schema.dart';
import 'package:ridp_api/src/model/form_schema.dart';
import 'package:ridp_api/src/model/form_version_schema.dart';
import 'package:ridp_api/src/model/logic_component_schema.dart';
import 'package:ridp_api/src/model/login_request.dart';
import 'package:ridp_api/src/model/mahasangraha_api_v1_admin_feature_flags_flag_key_put_request.dart';
import 'package:ridp_api/src/model/mahasangraha_api_v1_admin_orgs_org_id_admin_put_request.dart';
import 'package:ridp_api/src/model/mahasangraha_api_v1_admin_orgs_org_id_status_put_request.dart';
import 'package:ridp_api/src/model/mahasangraha_api_v1_admin_orgs_post_request.dart';
import 'package:ridp_api/src/model/mahasangraha_api_v1_auth_login_post200_response.dart';
import 'package:ridp_api/src/model/mahasangraha_api_v1_auth_login_post200_response_data.dart';
import 'package:ridp_api/src/model/mahasangraha_api_v1_auth_refresh_post200_response.dart';
import 'package:ridp_api/src/model/mahasangraha_api_v1_auth_request_otp_post_request.dart';
import 'package:ridp_api/src/model/mahasangraha_api_v1_projects_project_id_forms_external_hooks_hook_id_approve_post_request.dart';
import 'package:ridp_api/src/model/mahasangraha_api_v1_projects_project_id_forms_external_hooks_register_post_request.dart';
import 'package:ridp_api/src/model/mahasangraha_api_v1_projects_project_id_forms_form_id_responses_filter_post_request.dart';
import 'package:ridp_api/src/model/mahasangraha_api_v1_projects_project_id_forms_form_id_responses_filter_post_request_filters_inner.dart';
import 'package:ridp_api/src/model/mahasangraha_api_v1_user_security_lock_status_user_id_get200_response.dart';
import 'package:ridp_api/src/model/option_schema.dart';
import 'package:ridp_api/src/model/paginated_result.dart';
import 'package:ridp_api/src/model/project_blueprint_schema.dart';
import 'package:ridp_api/src/model/project_schema.dart';
import 'package:ridp_api/src/model/project_version_schema.dart';
import 'package:ridp_api/src/model/question_logic_schema.dart';
import 'package:ridp_api/src/model/question_schema.dart';
import 'package:ridp_api/src/model/question_ui_schema.dart';
import 'package:ridp_api/src/model/resource_access_control_schema.dart';
import 'package:ridp_api/src/model/response_template_schema.dart';
import 'package:ridp_api/src/model/section_logic_schema.dart';
import 'package:ridp_api/src/model/section_schema_struct.dart';
import 'package:ridp_api/src/model/section_ui_schema.dart';
import 'package:ridp_api/src/model/soft_delete_base_schema.dart';
import 'package:ridp_api/src/model/system_settings_schema.dart';
import 'package:ridp_api/src/model/token_payload.dart';
import 'package:ridp_api/src/model/token_response.dart';
import 'package:ridp_api/src/model/trigger_schema.dart';
import 'package:ridp_api/src/model/ui_component_schema.dart';
import 'package:ridp_api/src/model/user_create_schema.dart';
import 'package:ridp_api/src/model/user_group_schema.dart';
import 'package:ridp_api/src/model/user_out.dart';
import 'package:ridp_api/src/model/user_schema.dart';
import 'package:ridp_api/src/model/user_update_schema.dart';
import 'package:ridp_api/src/model/validation_schema.dart';
import 'package:ridp_api/src/model/version_schema.dart';
import 'package:ridp_api/src/model/workflow_instance_schema.dart';

final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

  ReturnType deserialize<ReturnType, BaseType>(dynamic value, String targetType, {bool growable= true}) {
      switch (targetType) {
        case 'String':
          return '$value' as ReturnType;
        case 'int':
          return (value is int ? value : int.parse('$value')) as ReturnType;
        case 'bool':
          if (value is bool) {
            return value as ReturnType;
          }
          final valueString = '$value'.toLowerCase();
          return (valueString == 'true' || valueString == '1') as ReturnType;
        case 'double':
          return (value is double ? value : double.parse('$value')) as ReturnType;
        case 'AccessEntrySchema':
          return AccessEntrySchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AnalyticsStateSchema':
          return AnalyticsStateSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApprovalLogSchema':
          return ApprovalLogSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApprovalStepSchema':
          return ApprovalStepSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ApprovalWorkflowSchema':
          return ApprovalWorkflowSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BaseEmbeddedSchema':
          return BaseEmbeddedSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BaseSchema':
          return BaseSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ConditionalValidationSchema':
          return ConditionalValidationSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DynamicViewDefinitionSchema':
          return DynamicViewDefinitionSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'FormBlueprintSchema':
          return FormBlueprintSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'FormResponseSchema':
          return FormResponseSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'FormSchema':
          return FormSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'FormVersionSchema':
          return FormVersionSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LogicComponentSchema':
          return LogicComponentSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LoginRequest':
          return LoginRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MahasangrahaApiV1AdminFeatureFlagsFlagKeyPutRequest':
          return MahasangrahaApiV1AdminFeatureFlagsFlagKeyPutRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MahasangrahaApiV1AdminOrgsOrgIdAdminPutRequest':
          return MahasangrahaApiV1AdminOrgsOrgIdAdminPutRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MahasangrahaApiV1AdminOrgsOrgIdStatusPutRequest':
          return MahasangrahaApiV1AdminOrgsOrgIdStatusPutRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MahasangrahaApiV1AdminOrgsPostRequest':
          return MahasangrahaApiV1AdminOrgsPostRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MahasangrahaApiV1AuthLoginPost200Response':
          return MahasangrahaApiV1AuthLoginPost200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MahasangrahaApiV1AuthLoginPost200ResponseData':
          return MahasangrahaApiV1AuthLoginPost200ResponseData.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MahasangrahaApiV1AuthRefreshPost200Response':
          return MahasangrahaApiV1AuthRefreshPost200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MahasangrahaApiV1AuthRequestOtpPostRequest':
          return MahasangrahaApiV1AuthRequestOtpPostRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePostRequest':
          return MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePostRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksRegisterPostRequest':
          return MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksRegisterPostRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequest':
          return MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequestFiltersInner':
          return MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequestFiltersInner.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MahasangrahaApiV1UserSecurityLockStatusUserIdGet200Response':
          return MahasangrahaApiV1UserSecurityLockStatusUserIdGet200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OptionSchema':
          return OptionSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PaginatedResult':
          return PaginatedResult.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ProjectBlueprintSchema':
          return ProjectBlueprintSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ProjectSchema':
          return ProjectSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ProjectVersionSchema':
          return ProjectVersionSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'QuestionLogicSchema':
          return QuestionLogicSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'QuestionSchema':
          return QuestionSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'QuestionUISchema':
          return QuestionUISchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ResourceAccessControlSchema':
          return ResourceAccessControlSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ResponseTemplateSchema':
          return ResponseTemplateSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SectionLogicSchema':
          return SectionLogicSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SectionSchemaStruct':
          return SectionSchemaStruct.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SectionUISchema':
          return SectionUISchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SoftDeleteBaseSchema':
          return SoftDeleteBaseSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SystemSettingsSchema':
          return SystemSettingsSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TokenPayload':
          return TokenPayload.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TokenResponse':
          return TokenResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TriggerSchema':
          return TriggerSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UIComponentSchema':
          return UIComponentSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserCreateSchema':
          return UserCreateSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserGroupSchema':
          return UserGroupSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserOut':
          return UserOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserSchema':
          return UserSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserUpdateSchema':
          return UserUpdateSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ValidationSchema':
          return ValidationSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'VersionSchema':
          return VersionSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'WorkflowInstanceSchema':
          return WorkflowInstanceSchema.fromJson(value as Map<String, dynamic>) as ReturnType;
        default:
          RegExpMatch? match;

          if (value is List && (match = _regList.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toList(growable: growable) as ReturnType;
          }
          if (value is Set && (match = _regSet.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toSet() as ReturnType;
          }
          if (value is Map && (match = _regMap.firstMatch(targetType)) != null) {
            targetType = match![1]!.trim(); // ignore: parameter_assignments
            return Map<String, BaseType>.fromIterables(
              value.keys as Iterable<String>,
              value.values.map((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable)),
            ) as ReturnType;
          }
          break;
    }
    throw Exception('Cannot deserialize');
  }
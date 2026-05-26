# ridp_api.api.FormApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1FormsBuilderMetadataGet**](FormApi.md#formapiv1formsbuildermetadataget) | **GET** /form/api/v1/forms/builder-metadata | Return enum/config metadata needed by schema-driven Flutter builders.
[**formApiV1FormsConditionsEvaluatePost**](FormApi.md#formapiv1formsconditionsevaluatepost) | **POST** /form/api/v1/forms/conditions/evaluate | Evaluate conditional logic for dynamic form behavior.
[**formApiV1FormsExpiredGet**](FormApi.md#formapiv1formsexpiredget) | **GET** /form/api/v1/forms/expired | Admin only: List all forms that have passed their expiration date.
[**formApiV1FormsExportBulkPost**](FormApi.md#formapiv1formsexportbulkpost) | **POST** /form/api/v1/forms/export/bulk | Initiates an asynchronous bulk export job.
[**formApiV1FormsFormIdAnalyticsDistributionGet**](FormApi.md#formapiv1formsformidanalyticsdistributionget) | **GET** /form/api/v1/forms/{form_id}/analytics/distribution | 
[**formApiV1FormsFormIdAnalyticsGet**](FormApi.md#formapiv1formsformidanalyticsget) | **GET** /form/api/v1/forms/{form_id}/analytics | M-11 Aggregated Analytics Endpoint Returns: totalSubmissions, completionRate, trends, fieldDistributions
[**formApiV1FormsFormIdAnalyticsSummaryGet**](FormApi.md#formapiv1formsformidanalyticssummaryget) | **GET** /form/api/v1/forms/{form_id}/analytics/summary | 
[**formApiV1FormsFormIdAnalyticsTimelineGet**](FormApi.md#formapiv1formsformidanalyticstimelineget) | **GET** /form/api/v1/forms/{form_id}/analytics/timeline | 
[**formApiV1FormsFormIdArchivePatch**](FormApi.md#formapiv1formsformidarchivepatch) | **PATCH** /form/api/v1/forms/{form_id}/archive | Admin only: Change form status to &#39;archived&#39;.
[**formApiV1FormsFormIdCheckDuplicatePost**](FormApi.md#formapiv1formsformidcheckduplicatepost) | **POST** /form/api/v1/forms/{form_id}/check-duplicate | Check if the current user has already submitted this exact data.
[**formApiV1FormsFormIdClonePost**](FormApi.md#formapiv1formsformidclonepost) | **POST** /form/api/v1/forms/{form_id}/clone | Clone a form asynchronously.
[**formApiV1FormsFormIdDelete**](FormApi.md#formapiv1formsformiddelete) | **DELETE** /form/api/v1/forms/{form_id} | Soft delete a form.
[**formApiV1FormsFormIdExpirePatch**](FormApi.md#formapiv1formsformidexpirepatch) | **PATCH** /form/api/v1/forms/{form_id}/expire | Admin only: Set a date when the form automatically becomes unavailable.
[**formApiV1FormsFormIdExportCsvGet**](FormApi.md#formapiv1formsformidexportcsvget) | **GET** /form/api/v1/forms/{form_id}/export/csv | 
[**formApiV1FormsFormIdExportJsonGet**](FormApi.md#formapiv1formsformidexportjsonget) | **GET** /form/api/v1/forms/{form_id}/export/json | 
[**formApiV1FormsFormIdFilesQuestionIdFilenameGet**](FormApi.md#formapiv1formsformidfilesquestionidfilenameget) | **GET** /form/api/v1/forms/{form_id}/files/{question_id}/{filename} | Serve uploaded files. Can be accessed by users with view permissions or for public forms
[**formApiV1FormsFormIdGet**](FormApi.md#formapiv1formsformidget) | **GET** /form/api/v1/forms/{form_id} | Retrieve a single form, applying optional language filters.
[**formApiV1FormsFormIdHistoryGet**](FormApi.md#formapiv1formsformidhistoryget) | **GET** /form/api/v1/forms/{form_id}/history | 
[**formApiV1FormsFormIdNextActionGet**](FormApi.md#formapiv1formsformidnextactionget) | **GET** /form/api/v1/forms/{form_id}/next-action | Check if any active workflows should be triggered for this form.
[**formApiV1FormsFormIdPublicSubmitPost**](FormApi.md#formapiv1formsformidpublicsubmitpost) | **POST** /form/api/v1/forms/{form_id}/public-submit | 
[**formApiV1FormsFormIdPublishPost**](FormApi.md#formapiv1formsformidpublishpost) | **POST** /form/api/v1/forms/{form_id}/publish | Publish a form asynchronously.
[**formApiV1FormsFormIdPut**](FormApi.md#formapiv1formsformidput) | **PUT** /form/api/v1/forms/{form_id} | Update an existing form.
[**formApiV1FormsFormIdResponsesCountGet**](FormApi.md#formapiv1formsformidresponsescountget) | **GET** /form/api/v1/forms/{form_id}/responses/count | Get total submission count for a form.
[**formApiV1FormsFormIdResponsesDelete**](FormApi.md#formapiv1formsformidresponsesdelete) | **DELETE** /form/api/v1/forms/{form_id}/responses | Admin only: Purge all collected responses for a specific form (Soft delete).
[**formApiV1FormsFormIdResponsesGet**](FormApi.md#formapiv1formsformidresponsesget) | **GET** /form/api/v1/forms/{form_id}/responses | List responses for a specific form (paginated).
[**formApiV1FormsFormIdResponsesLastGet**](FormApi.md#formapiv1formsformidresponseslastget) | **GET** /form/api/v1/forms/{form_id}/responses/last | Fetch the most recent response record for a form.
[**formApiV1FormsFormIdResponsesPost**](FormApi.md#formapiv1formsformidresponsespost) | **POST** /form/api/v1/forms/{form_id}/responses | Authenticated form submission.
[**formApiV1FormsFormIdRestorePatch**](FormApi.md#formapiv1formsformidrestorepatch) | **PATCH** /form/api/v1/forms/{form_id}/restore | Admin only: Change form status from &#39;archived&#39; back to &#39;draft&#39;.
[**formApiV1FormsFormIdSharePost**](FormApi.md#formapiv1formsformidsharepost) | **POST** /form/api/v1/forms/{form_id}/share | Admin only: Grant editor/viewer/submitter permissions for a form.
[**formApiV1FormsFormIdSummarizePost**](FormApi.md#formapiv1formsformidsummarizepost) | **POST** /form/api/v1/forms/{form_id}/summarize | Generate summary from form responses.
[**formApiV1FormsFormIdTogglePublicPatch**](FormApi.md#formapiv1formsformidtogglepublicpatch) | **PATCH** /form/api/v1/forms/{form_id}/toggle-public | Admin only: Toggle between private and public access for a form.
[**formApiV1FormsFormIdTranslationsPost**](FormApi.md#formapiv1formsformidtranslationspost) | **POST** /form/api/v1/forms/{form_id}/translations | Update translation strings for a given language code.
[**formApiV1FormsImportPost**](FormApi.md#formapiv1formsimportpost) | **POST** /form/api/v1/forms/import | Import a full form structure from JSON.
[**formApiV1FormsPost**](FormApi.md#formapiv1formspost) | **POST** /form/api/v1/forms/ | Create a new form inside the current project context.
[**formApiV1FormsSignaturesPost**](FormApi.md#formapiv1formssignaturespost) | **POST** /form/api/v1/forms/signatures | 
[**formApiV1FormsSlugAvailableGet**](FormApi.md#formapiv1formsslugavailableget) | **GET** /form/api/v1/forms/slug-available | Check if a form slug is already taken.
[**formApiV1FormsTemplatesGet**](FormApi.md#formapiv1formstemplatesget) | **GET** /form/api/v1/forms/templates | List templates accessible to the current user.
[**formApiV1FormsTemplatesTemplateIdGet**](FormApi.md#formapiv1formstemplatestemplateidget) | **GET** /form/api/v1/forms/templates/{template_id} | Retrieve a single template.
[**formApiV1FormsUploadPost**](FormApi.md#formapiv1formsuploadpost) | **POST** /form/api/v1/forms/upload | 
[**formApiV1ProjectsProjectIdFormsBuilderMetadataGet**](FormApi.md#formapiv1projectsprojectidformsbuildermetadataget) | **GET** /form/api/v1/projects/{project_id}/forms/builder-metadata | Return enum/config metadata needed by schema-driven Flutter builders.
[**formApiV1ProjectsProjectIdFormsConditionsEvaluatePost**](FormApi.md#formapiv1projectsprojectidformsconditionsevaluatepost) | **POST** /form/api/v1/projects/{project_id}/forms/conditions/evaluate | Evaluate conditional logic for dynamic form behavior.
[**formApiV1ProjectsProjectIdFormsExpiredGet**](FormApi.md#formapiv1projectsprojectidformsexpiredget) | **GET** /form/api/v1/projects/{project_id}/forms/expired | Admin only: List all forms that have passed their expiration date.
[**formApiV1ProjectsProjectIdFormsExportBulkPost**](FormApi.md#formapiv1projectsprojectidformsexportbulkpost) | **POST** /form/api/v1/projects/{project_id}/forms/export/bulk | Initiates an asynchronous bulk export job.
[**formApiV1ProjectsProjectIdFormsFormIdAnalyticsDistributionGet**](FormApi.md#formapiv1projectsprojectidformsformidanalyticsdistributionget) | **GET** /form/api/v1/projects/{project_id}/forms/{form_id}/analytics/distribution | 
[**formApiV1ProjectsProjectIdFormsFormIdAnalyticsGet**](FormApi.md#formapiv1projectsprojectidformsformidanalyticsget) | **GET** /form/api/v1/projects/{project_id}/forms/{form_id}/analytics | M-11 Aggregated Analytics Endpoint Returns: totalSubmissions, completionRate, trends, fieldDistributions
[**formApiV1ProjectsProjectIdFormsFormIdAnalyticsSummaryGet**](FormApi.md#formapiv1projectsprojectidformsformidanalyticssummaryget) | **GET** /form/api/v1/projects/{project_id}/forms/{form_id}/analytics/summary | 
[**formApiV1ProjectsProjectIdFormsFormIdAnalyticsTimelineGet**](FormApi.md#formapiv1projectsprojectidformsformidanalyticstimelineget) | **GET** /form/api/v1/projects/{project_id}/forms/{form_id}/analytics/timeline | 
[**formApiV1ProjectsProjectIdFormsFormIdArchivePatch**](FormApi.md#formapiv1projectsprojectidformsformidarchivepatch) | **PATCH** /form/api/v1/projects/{project_id}/forms/{form_id}/archive | Admin only: Change form status to &#39;archived&#39;.
[**formApiV1ProjectsProjectIdFormsFormIdCheckDuplicatePost**](FormApi.md#formapiv1projectsprojectidformsformidcheckduplicatepost) | **POST** /form/api/v1/projects/{project_id}/forms/{form_id}/check-duplicate | Check if the current user has already submitted this exact data.
[**formApiV1ProjectsProjectIdFormsFormIdClonePost**](FormApi.md#formapiv1projectsprojectidformsformidclonepost) | **POST** /form/api/v1/projects/{project_id}/forms/{form_id}/clone | Clone a form asynchronously.
[**formApiV1ProjectsProjectIdFormsFormIdDelete**](FormApi.md#formapiv1projectsprojectidformsformiddelete) | **DELETE** /form/api/v1/projects/{project_id}/forms/{form_id} | Soft delete a form.
[**formApiV1ProjectsProjectIdFormsFormIdExpirePatch**](FormApi.md#formapiv1projectsprojectidformsformidexpirepatch) | **PATCH** /form/api/v1/projects/{project_id}/forms/{form_id}/expire | Admin only: Set a date when the form automatically becomes unavailable.
[**formApiV1ProjectsProjectIdFormsFormIdExportCsvGet**](FormApi.md#formapiv1projectsprojectidformsformidexportcsvget) | **GET** /form/api/v1/projects/{project_id}/forms/{form_id}/export/csv | 
[**formApiV1ProjectsProjectIdFormsFormIdExportJsonGet**](FormApi.md#formapiv1projectsprojectidformsformidexportjsonget) | **GET** /form/api/v1/projects/{project_id}/forms/{form_id}/export/json | 
[**formApiV1ProjectsProjectIdFormsFormIdFilesQuestionIdFilenameGet**](FormApi.md#formapiv1projectsprojectidformsformidfilesquestionidfilenameget) | **GET** /form/api/v1/projects/{project_id}/forms/{form_id}/files/{question_id}/{filename} | Serve uploaded files. Can be accessed by users with view permissions or for public forms
[**formApiV1ProjectsProjectIdFormsFormIdGet**](FormApi.md#formapiv1projectsprojectidformsformidget) | **GET** /form/api/v1/projects/{project_id}/forms/{form_id} | Retrieve a single form, applying optional language filters.
[**formApiV1ProjectsProjectIdFormsFormIdHistoryGet**](FormApi.md#formapiv1projectsprojectidformsformidhistoryget) | **GET** /form/api/v1/projects/{project_id}/forms/{form_id}/history | 
[**formApiV1ProjectsProjectIdFormsFormIdNextActionGet**](FormApi.md#formapiv1projectsprojectidformsformidnextactionget) | **GET** /form/api/v1/projects/{project_id}/forms/{form_id}/next-action | Check if any active workflows should be triggered for this form.
[**formApiV1ProjectsProjectIdFormsFormIdPublicSubmitPost**](FormApi.md#formapiv1projectsprojectidformsformidpublicsubmitpost) | **POST** /form/api/v1/projects/{project_id}/forms/{form_id}/public-submit | 
[**formApiV1ProjectsProjectIdFormsFormIdPublishPost**](FormApi.md#formapiv1projectsprojectidformsformidpublishpost) | **POST** /form/api/v1/projects/{project_id}/forms/{form_id}/publish | Publish a form asynchronously.
[**formApiV1ProjectsProjectIdFormsFormIdPut**](FormApi.md#formapiv1projectsprojectidformsformidput) | **PUT** /form/api/v1/projects/{project_id}/forms/{form_id} | Update an existing form.
[**formApiV1ProjectsProjectIdFormsFormIdResponsesCountGet**](FormApi.md#formapiv1projectsprojectidformsformidresponsescountget) | **GET** /form/api/v1/projects/{project_id}/forms/{form_id}/responses/count | Get total submission count for a form.
[**formApiV1ProjectsProjectIdFormsFormIdResponsesDelete**](FormApi.md#formapiv1projectsprojectidformsformidresponsesdelete) | **DELETE** /form/api/v1/projects/{project_id}/forms/{form_id}/responses | Admin only: Purge all collected responses for a specific form (Soft delete).
[**formApiV1ProjectsProjectIdFormsFormIdResponsesGet**](FormApi.md#formapiv1projectsprojectidformsformidresponsesget) | **GET** /form/api/v1/projects/{project_id}/forms/{form_id}/responses | List responses for a specific form (paginated).
[**formApiV1ProjectsProjectIdFormsFormIdResponsesLastGet**](FormApi.md#formapiv1projectsprojectidformsformidresponseslastget) | **GET** /form/api/v1/projects/{project_id}/forms/{form_id}/responses/last | Fetch the most recent response record for a form.
[**formApiV1ProjectsProjectIdFormsFormIdResponsesPost**](FormApi.md#formapiv1projectsprojectidformsformidresponsespost) | **POST** /form/api/v1/projects/{project_id}/forms/{form_id}/responses | Authenticated form submission.
[**formApiV1ProjectsProjectIdFormsFormIdRestorePatch**](FormApi.md#formapiv1projectsprojectidformsformidrestorepatch) | **PATCH** /form/api/v1/projects/{project_id}/forms/{form_id}/restore | Admin only: Change form status from &#39;archived&#39; back to &#39;draft&#39;.
[**formApiV1ProjectsProjectIdFormsFormIdSharePost**](FormApi.md#formapiv1projectsprojectidformsformidsharepost) | **POST** /form/api/v1/projects/{project_id}/forms/{form_id}/share | Admin only: Grant editor/viewer/submitter permissions for a form.
[**formApiV1ProjectsProjectIdFormsFormIdSummarizePost**](FormApi.md#formapiv1projectsprojectidformsformidsummarizepost) | **POST** /form/api/v1/projects/{project_id}/forms/{form_id}/summarize | Generate summary from form responses.
[**formApiV1ProjectsProjectIdFormsFormIdTogglePublicPatch**](FormApi.md#formapiv1projectsprojectidformsformidtogglepublicpatch) | **PATCH** /form/api/v1/projects/{project_id}/forms/{form_id}/toggle-public | Admin only: Toggle between private and public access for a form.
[**formApiV1ProjectsProjectIdFormsFormIdTranslationsPost**](FormApi.md#formapiv1projectsprojectidformsformidtranslationspost) | **POST** /form/api/v1/projects/{project_id}/forms/{form_id}/translations | Update translation strings for a given language code.
[**formApiV1ProjectsProjectIdFormsGet**](FormApi.md#formapiv1projectsprojectidformsget) | **GET** /form/api/v1/projects/{project_id}/forms/ | List forms belonging to the current project.
[**formApiV1ProjectsProjectIdFormsImportPost**](FormApi.md#formapiv1projectsprojectidformsimportpost) | **POST** /form/api/v1/projects/{project_id}/forms/import | Import a full form structure from JSON.
[**formApiV1ProjectsProjectIdFormsPost**](FormApi.md#formapiv1projectsprojectidformspost) | **POST** /form/api/v1/projects/{project_id}/forms/ | Create a new form inside the current project context.
[**formApiV1ProjectsProjectIdFormsSignaturesPost**](FormApi.md#formapiv1projectsprojectidformssignaturespost) | **POST** /form/api/v1/projects/{project_id}/forms/signatures | 
[**formApiV1ProjectsProjectIdFormsSlugAvailableGet**](FormApi.md#formapiv1projectsprojectidformsslugavailableget) | **GET** /form/api/v1/projects/{project_id}/forms/slug-available | Check if a form slug is already taken.
[**formApiV1ProjectsProjectIdFormsTemplatesGet**](FormApi.md#formapiv1projectsprojectidformstemplatesget) | **GET** /form/api/v1/projects/{project_id}/forms/templates | List templates accessible to the current user.
[**formApiV1ProjectsProjectIdFormsTemplatesTemplateIdGet**](FormApi.md#formapiv1projectsprojectidformstemplatestemplateidget) | **GET** /form/api/v1/projects/{project_id}/forms/templates/{template_id} | Retrieve a single template.
[**formApiV1ProjectsProjectIdFormsUploadPost**](FormApi.md#formapiv1projectsprojectidformsuploadpost) | **POST** /form/api/v1/projects/{project_id}/forms/upload | 


# **formApiV1FormsBuilderMetadataGet**
> formApiV1FormsBuilderMetadataGet()

Return enum/config metadata needed by schema-driven Flutter builders.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.formApiV1FormsBuilderMetadataGet();
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsBuilderMetadataGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsConditionsEvaluatePost**
> formApiV1FormsConditionsEvaluatePost()

Evaluate conditional logic for dynamic form behavior.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.formApiV1FormsConditionsEvaluatePost();
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsConditionsEvaluatePost: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsExpiredGet**
> formApiV1FormsExpiredGet()

Admin only: List all forms that have passed their expiration date.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.formApiV1FormsExpiredGet();
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsExpiredGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsExportBulkPost**
> formApiV1FormsExportBulkPost()

Initiates an asynchronous bulk export job.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.formApiV1FormsExportBulkPost();
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsExportBulkPost: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdAnalyticsDistributionGet**
> formApiV1FormsFormIdAnalyticsDistributionGet(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdAnalyticsDistributionGet(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdAnalyticsDistributionGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdAnalyticsGet**
> formApiV1FormsFormIdAnalyticsGet(formId)

M-11 Aggregated Analytics Endpoint Returns: totalSubmissions, completionRate, trends, fieldDistributions

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdAnalyticsGet(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdAnalyticsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdAnalyticsSummaryGet**
> formApiV1FormsFormIdAnalyticsSummaryGet(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdAnalyticsSummaryGet(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdAnalyticsSummaryGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdAnalyticsTimelineGet**
> formApiV1FormsFormIdAnalyticsTimelineGet(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdAnalyticsTimelineGet(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdAnalyticsTimelineGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdArchivePatch**
> formApiV1FormsFormIdArchivePatch(formId)

Admin only: Change form status to 'archived'.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdArchivePatch(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdArchivePatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdCheckDuplicatePost**
> formApiV1FormsFormIdCheckDuplicatePost(formId)

Check if the current user has already submitted this exact data.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdCheckDuplicatePost(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdCheckDuplicatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdClonePost**
> formApiV1FormsFormIdClonePost(formId)

Clone a form asynchronously.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdClonePost(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdClonePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdDelete**
> formApiV1FormsFormIdDelete(formId)

Soft delete a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdDelete(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdExpirePatch**
> formApiV1FormsFormIdExpirePatch(formId)

Admin only: Set a date when the form automatically becomes unavailable.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdExpirePatch(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdExpirePatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdExportCsvGet**
> formApiV1FormsFormIdExportCsvGet(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdExportCsvGet(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdExportCsvGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdExportJsonGet**
> formApiV1FormsFormIdExportJsonGet(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdExportJsonGet(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdExportJsonGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdFilesQuestionIdFilenameGet**
> formApiV1FormsFormIdFilesQuestionIdFilenameGet(formId, questionId, filename)

Serve uploaded files. Can be accessed by users with view permissions or for public forms

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 
final String questionId = questionId_example; // String | 
final String filename = filename_example; // String | 

try {
    api.formApiV1FormsFormIdFilesQuestionIdFilenameGet(formId, questionId, filename);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdFilesQuestionIdFilenameGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 
 **questionId** | **String**|  | 
 **filename** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdGet**
> formApiV1FormsFormIdGet(formId)

Retrieve a single form, applying optional language filters.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdGet(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdHistoryGet**
> formApiV1FormsFormIdHistoryGet(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdHistoryGet(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdHistoryGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdNextActionGet**
> formApiV1FormsFormIdNextActionGet(formId)

Check if any active workflows should be triggered for this form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdNextActionGet(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdNextActionGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdPublicSubmitPost**
> formApiV1FormsFormIdPublicSubmitPost(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdPublicSubmitPost(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdPublicSubmitPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdPublishPost**
> formApiV1FormsFormIdPublishPost(formId)

Publish a form asynchronously.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdPublishPost(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdPublishPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdPut**
> formApiV1FormsFormIdPut(formId, body)

Update an existing form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 
final FormUpdateSchema body = ; // FormUpdateSchema | 

try {
    api.formApiV1FormsFormIdPut(formId, body);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 
 **body** | **FormUpdateSchema**|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdResponsesCountGet**
> formApiV1FormsFormIdResponsesCountGet(formId)

Get total submission count for a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdResponsesCountGet(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdResponsesCountGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdResponsesDelete**
> formApiV1FormsFormIdResponsesDelete(formId)

Admin only: Purge all collected responses for a specific form (Soft delete).

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdResponsesDelete(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdResponsesDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdResponsesGet**
> formApiV1FormsFormIdResponsesGet(formId)

List responses for a specific form (paginated).

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdResponsesGet(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdResponsesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdResponsesLastGet**
> formApiV1FormsFormIdResponsesLastGet(formId)

Fetch the most recent response record for a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdResponsesLastGet(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdResponsesLastGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdResponsesPost**
> formApiV1FormsFormIdResponsesPost(formId, body)

Authenticated form submission.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 
final FormResponseCreateSchema body = ; // FormResponseCreateSchema | 

try {
    api.formApiV1FormsFormIdResponsesPost(formId, body);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdResponsesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 
 **body** | **FormResponseCreateSchema**|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdRestorePatch**
> formApiV1FormsFormIdRestorePatch(formId)

Admin only: Change form status from 'archived' back to 'draft'.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdRestorePatch(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdRestorePatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdSharePost**
> formApiV1FormsFormIdSharePost(formId)

Admin only: Grant editor/viewer/submitter permissions for a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdSharePost(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdSharePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdSummarizePost**
> formApiV1FormsFormIdSummarizePost(formId)

Generate summary from form responses.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdSummarizePost(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdSummarizePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdTogglePublicPatch**
> formApiV1FormsFormIdTogglePublicPatch(formId)

Admin only: Toggle between private and public access for a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdTogglePublicPatch(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdTogglePublicPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdTranslationsPost**
> formApiV1FormsFormIdTranslationsPost(formId)

Update translation strings for a given language code.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdTranslationsPost(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsFormIdTranslationsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsImportPost**
> formApiV1FormsImportPost()

Import a full form structure from JSON.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.formApiV1FormsImportPost();
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsImportPost: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsPost**
> formApiV1FormsPost(body)

Create a new form inside the current project context.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final FormCreateSchema body = ; // FormCreateSchema | 

try {
    api.formApiV1FormsPost(body);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | **FormCreateSchema**|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsSignaturesPost**
> formApiV1FormsSignaturesPost()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.formApiV1FormsSignaturesPost();
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsSignaturesPost: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsSlugAvailableGet**
> formApiV1FormsSlugAvailableGet()

Check if a form slug is already taken.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.formApiV1FormsSlugAvailableGet();
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsSlugAvailableGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsTemplatesGet**
> formApiV1FormsTemplatesGet()

List templates accessible to the current user.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.formApiV1FormsTemplatesGet();
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsTemplatesGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsTemplatesTemplateIdGet**
> formApiV1FormsTemplatesTemplateIdGet(templateId)

Retrieve a single template.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String templateId = templateId_example; // String | 

try {
    api.formApiV1FormsTemplatesTemplateIdGet(templateId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsTemplatesTemplateIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **templateId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsUploadPost**
> formApiV1FormsUploadPost()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.formApiV1FormsUploadPost();
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1FormsUploadPost: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsBuilderMetadataGet**
> formApiV1ProjectsProjectIdFormsBuilderMetadataGet()

Return enum/config metadata needed by schema-driven Flutter builders.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.formApiV1ProjectsProjectIdFormsBuilderMetadataGet();
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsBuilderMetadataGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsConditionsEvaluatePost**
> formApiV1ProjectsProjectIdFormsConditionsEvaluatePost()

Evaluate conditional logic for dynamic form behavior.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.formApiV1ProjectsProjectIdFormsConditionsEvaluatePost();
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsConditionsEvaluatePost: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsExpiredGet**
> formApiV1ProjectsProjectIdFormsExpiredGet()

Admin only: List all forms that have passed their expiration date.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.formApiV1ProjectsProjectIdFormsExpiredGet();
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsExpiredGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsExportBulkPost**
> formApiV1ProjectsProjectIdFormsExportBulkPost()

Initiates an asynchronous bulk export job.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.formApiV1ProjectsProjectIdFormsExportBulkPost();
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsExportBulkPost: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdAnalyticsDistributionGet**
> formApiV1ProjectsProjectIdFormsFormIdAnalyticsDistributionGet(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdAnalyticsDistributionGet(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdAnalyticsDistributionGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdAnalyticsGet**
> formApiV1ProjectsProjectIdFormsFormIdAnalyticsGet(formId)

M-11 Aggregated Analytics Endpoint Returns: totalSubmissions, completionRate, trends, fieldDistributions

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdAnalyticsGet(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdAnalyticsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdAnalyticsSummaryGet**
> formApiV1ProjectsProjectIdFormsFormIdAnalyticsSummaryGet(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdAnalyticsSummaryGet(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdAnalyticsSummaryGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdAnalyticsTimelineGet**
> formApiV1ProjectsProjectIdFormsFormIdAnalyticsTimelineGet(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdAnalyticsTimelineGet(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdAnalyticsTimelineGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdArchivePatch**
> formApiV1ProjectsProjectIdFormsFormIdArchivePatch(formId)

Admin only: Change form status to 'archived'.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdArchivePatch(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdArchivePatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdCheckDuplicatePost**
> formApiV1ProjectsProjectIdFormsFormIdCheckDuplicatePost(formId)

Check if the current user has already submitted this exact data.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdCheckDuplicatePost(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdCheckDuplicatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdClonePost**
> formApiV1ProjectsProjectIdFormsFormIdClonePost(formId)

Clone a form asynchronously.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdClonePost(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdClonePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdDelete**
> formApiV1ProjectsProjectIdFormsFormIdDelete(formId)

Soft delete a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdDelete(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdExpirePatch**
> formApiV1ProjectsProjectIdFormsFormIdExpirePatch(formId)

Admin only: Set a date when the form automatically becomes unavailable.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdExpirePatch(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdExpirePatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdExportCsvGet**
> formApiV1ProjectsProjectIdFormsFormIdExportCsvGet(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdExportCsvGet(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdExportCsvGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdExportJsonGet**
> formApiV1ProjectsProjectIdFormsFormIdExportJsonGet(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdExportJsonGet(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdExportJsonGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdFilesQuestionIdFilenameGet**
> formApiV1ProjectsProjectIdFormsFormIdFilesQuestionIdFilenameGet(formId, questionId, filename)

Serve uploaded files. Can be accessed by users with view permissions or for public forms

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 
final String questionId = questionId_example; // String | 
final String filename = filename_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdFilesQuestionIdFilenameGet(formId, questionId, filename);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdFilesQuestionIdFilenameGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 
 **questionId** | **String**|  | 
 **filename** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdGet**
> formApiV1ProjectsProjectIdFormsFormIdGet(formId)

Retrieve a single form, applying optional language filters.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdGet(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdHistoryGet**
> formApiV1ProjectsProjectIdFormsFormIdHistoryGet(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdHistoryGet(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdHistoryGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdNextActionGet**
> formApiV1ProjectsProjectIdFormsFormIdNextActionGet(formId)

Check if any active workflows should be triggered for this form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdNextActionGet(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdNextActionGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdPublicSubmitPost**
> formApiV1ProjectsProjectIdFormsFormIdPublicSubmitPost(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdPublicSubmitPost(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdPublicSubmitPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdPublishPost**
> formApiV1ProjectsProjectIdFormsFormIdPublishPost(formId)

Publish a form asynchronously.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdPublishPost(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdPublishPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdPut**
> formApiV1ProjectsProjectIdFormsFormIdPut(formId, body)

Update an existing form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 
final FormUpdateSchema body = ; // FormUpdateSchema | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdPut(formId, body);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 
 **body** | **FormUpdateSchema**|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdResponsesCountGet**
> formApiV1ProjectsProjectIdFormsFormIdResponsesCountGet(formId)

Get total submission count for a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdResponsesCountGet(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdResponsesCountGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdResponsesDelete**
> formApiV1ProjectsProjectIdFormsFormIdResponsesDelete(formId)

Admin only: Purge all collected responses for a specific form (Soft delete).

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdResponsesDelete(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdResponsesDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdResponsesGet**
> formApiV1ProjectsProjectIdFormsFormIdResponsesGet(formId)

List responses for a specific form (paginated).

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdResponsesGet(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdResponsesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdResponsesLastGet**
> formApiV1ProjectsProjectIdFormsFormIdResponsesLastGet(formId)

Fetch the most recent response record for a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdResponsesLastGet(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdResponsesLastGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdResponsesPost**
> formApiV1ProjectsProjectIdFormsFormIdResponsesPost(formId, body)

Authenticated form submission.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 
final FormResponseCreateSchema body = ; // FormResponseCreateSchema | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdResponsesPost(formId, body);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdResponsesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 
 **body** | **FormResponseCreateSchema**|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdRestorePatch**
> formApiV1ProjectsProjectIdFormsFormIdRestorePatch(formId)

Admin only: Change form status from 'archived' back to 'draft'.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdRestorePatch(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdRestorePatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdSharePost**
> formApiV1ProjectsProjectIdFormsFormIdSharePost(formId)

Admin only: Grant editor/viewer/submitter permissions for a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdSharePost(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdSharePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdSummarizePost**
> formApiV1ProjectsProjectIdFormsFormIdSummarizePost(formId)

Generate summary from form responses.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdSummarizePost(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdSummarizePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdTogglePublicPatch**
> formApiV1ProjectsProjectIdFormsFormIdTogglePublicPatch(formId)

Admin only: Toggle between private and public access for a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdTogglePublicPatch(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdTogglePublicPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdTranslationsPost**
> formApiV1ProjectsProjectIdFormsFormIdTranslationsPost(formId)

Update translation strings for a given language code.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdTranslationsPost(formId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdTranslationsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsGet**
> formApiV1ProjectsProjectIdFormsGet()

List forms belonging to the current project.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.formApiV1ProjectsProjectIdFormsGet();
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsImportPost**
> formApiV1ProjectsProjectIdFormsImportPost()

Import a full form structure from JSON.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.formApiV1ProjectsProjectIdFormsImportPost();
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsImportPost: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsPost**
> formApiV1ProjectsProjectIdFormsPost(body)

Create a new form inside the current project context.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final FormCreateSchema body = ; // FormCreateSchema | 

try {
    api.formApiV1ProjectsProjectIdFormsPost(body);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | **FormCreateSchema**|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsSignaturesPost**
> formApiV1ProjectsProjectIdFormsSignaturesPost()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.formApiV1ProjectsProjectIdFormsSignaturesPost();
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsSignaturesPost: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsSlugAvailableGet**
> formApiV1ProjectsProjectIdFormsSlugAvailableGet()

Check if a form slug is already taken.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.formApiV1ProjectsProjectIdFormsSlugAvailableGet();
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsSlugAvailableGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsTemplatesGet**
> formApiV1ProjectsProjectIdFormsTemplatesGet()

List templates accessible to the current user.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.formApiV1ProjectsProjectIdFormsTemplatesGet();
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsTemplatesGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsTemplatesTemplateIdGet**
> formApiV1ProjectsProjectIdFormsTemplatesTemplateIdGet(templateId)

Retrieve a single template.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String templateId = templateId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsTemplatesTemplateIdGet(templateId);
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsTemplatesTemplateIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **templateId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsUploadPost**
> formApiV1ProjectsProjectIdFormsUploadPost()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.formApiV1ProjectsProjectIdFormsUploadPost();
} catch on DioError (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsUploadPost: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


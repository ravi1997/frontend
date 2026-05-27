# ridp_api.api.FormApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1FormsBuilderMetadataGet**](FormApi.md#formapiv1formsbuildermetadataget) | **GET** /form/api/v1/forms/builder-metadata | 
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



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.formApiV1FormsBuilderMetadataGet();
} on DioException catch (e) {
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

# **formApiV1ProjectsProjectIdFormsBuilderMetadataGet**
> formApiV1ProjectsProjectIdFormsBuilderMetadataGet()

Return enum/config metadata needed by schema-driven Flutter builders.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.formApiV1ProjectsProjectIdFormsBuilderMetadataGet();
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
final Map<String, Object> body = Object; // Map<String, Object> | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdPut(formId, body);
} on DioException catch (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 
 **body** | [**Map&lt;String, Object&gt;**](Object.md)|  | [optional] 

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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
final Map<String, Object> body = Object; // Map<String, Object> | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdResponsesPost(formId, body);
} on DioException catch (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsFormIdResponsesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 
 **body** | [**Map&lt;String, Object&gt;**](Object.md)|  | [optional] 

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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
final Map<String, Object> body = Object; // Map<String, Object> | 

try {
    api.formApiV1ProjectsProjectIdFormsPost(body);
} on DioException catch (e) {
    print('Exception when calling FormApi->formApiV1ProjectsProjectIdFormsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**Map&lt;String, Object&gt;**](Object.md)|  | [optional] 

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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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
} on DioException catch (e) {
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


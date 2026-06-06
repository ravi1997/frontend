# ridp_api.api.FormApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1FormsBuilderMetadataGet**](FormApi.md#mahasangrahaapiv1formsbuildermetadataget) | **GET** /mahasangraha/api/v1/forms/builder-metadata | 
[**mahasangrahaApiV1FormsExportBulkPost**](FormApi.md#mahasangrahaapiv1formsexportbulkpost) | **POST** /mahasangraha/api/v1/forms/export/bulk | 
[**mahasangrahaApiV1FormsSlugAvailableGet**](FormApi.md#mahasangrahaapiv1formsslugavailableget) | **GET** /mahasangraha/api/v1/forms/slug-available | 
[**mahasangrahaApiV1ProjectsProjectIdFormsConditionsEvaluatePost**](FormApi.md#mahasangrahaapiv1projectsprojectidformsconditionsevaluatepost) | **POST** /mahasangraha/api/v1/projects/{project_id}/forms/conditions/evaluate | Evaluate conditional logic for dynamic form behavior.
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnalyticsDistributionGet**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidanalyticsdistributionget) | **GET** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/analytics/distribution | 
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnalyticsGet**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidanalyticsget) | **GET** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/analytics | M-11 Aggregated Analytics Endpoint Returns: totalSubmissions, completionRate, trends, fieldDistributions
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnalyticsSummaryGet**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidanalyticssummaryget) | **GET** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/analytics/summary | 
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnalyticsTimelineGet**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidanalyticstimelineget) | **GET** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/analytics/timeline | 
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdArchivePatch**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidarchivepatch) | **PATCH** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/archive | Admin only: Change form status to &#39;archived&#39;.
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdCheckDuplicatePost**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidcheckduplicatepost) | **POST** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/check-duplicate | Check if the current user has already submitted this exact data.
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdClonePost**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidclonepost) | **POST** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/clone | Clone a form asynchronously.
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdDelete**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformiddelete) | **DELETE** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id} | Soft delete a form.
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdExpirePatch**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidexpirepatch) | **PATCH** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/expire | Admin only: Set a date when the form automatically becomes unavailable.
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdExportCsvGet**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidexportcsvget) | **GET** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/export/csv | 
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdExportJsonGet**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidexportjsonget) | **GET** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/export/json | 
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdFilesQuestionIdFilenameGet**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidfilesquestionidfilenameget) | **GET** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/files/{question_id}/{filename} | Serve uploaded files. Can be accessed by users with view permissions or for public forms
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdGet**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidget) | **GET** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id} | Retrieve a single form, applying optional language filters.
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdHistoryGet**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidhistoryget) | **GET** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/history | 
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdNextActionGet**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidnextactionget) | **GET** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/next-action | Check if any active workflows should be triggered for this form.
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdPublicSubmitPost**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidpublicsubmitpost) | **POST** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/public-submit | 
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdPublishPost**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidpublishpost) | **POST** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/publish | Publish a form asynchronously.
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdPut**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidput) | **PUT** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id} | Update an existing form.
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesCountGet**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidresponsescountget) | **GET** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/responses/count | Get total submission count for a form.
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesDelete**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidresponsesdelete) | **DELETE** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/responses | Admin only: Purge all collected responses for a specific form (Soft delete).
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesGet**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidresponsesget) | **GET** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/responses | List responses for a specific form (paginated).
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesLastGet**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidresponseslastget) | **GET** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/responses/last | Fetch the most recent response record for a form.
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesPost**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidresponsespost) | **POST** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/responses | Authenticated form submission.
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdRestorePatch**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidrestorepatch) | **PATCH** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/restore | Admin only: Change form status from &#39;archived&#39; back to &#39;draft&#39;.
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdSharePost**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidsharepost) | **POST** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/share | Admin only: Grant editor/viewer/submitter permissions for a form.
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdSummarizePost**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidsummarizepost) | **POST** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/summarize | Generate summary from form responses.
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdTogglePublicPatch**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidtogglepublicpatch) | **PATCH** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/toggle-public | Admin only: Toggle between private and public access for a form.
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdTranslationsPost**](FormApi.md#mahasangrahaapiv1projectsprojectidformsformidtranslationspost) | **POST** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/translations | Update translation strings for a given language code.
[**mahasangrahaApiV1ProjectsProjectIdFormsImportPost**](FormApi.md#mahasangrahaapiv1projectsprojectidformsimportpost) | **POST** /mahasangraha/api/v1/projects/{project_id}/forms/import | Import a full form structure from JSON.
[**mahasangrahaApiV1ProjectsProjectIdFormsPost**](FormApi.md#mahasangrahaapiv1projectsprojectidformspost) | **POST** /mahasangraha/api/v1/projects/{project_id}/forms/ | Create a new form inside the current project context.


# **mahasangrahaApiV1FormsBuilderMetadataGet**
> mahasangrahaApiV1FormsBuilderMetadataGet()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.mahasangrahaApiV1FormsBuilderMetadataGet();
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1FormsBuilderMetadataGet: $e\n');
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

# **mahasangrahaApiV1FormsExportBulkPost**
> mahasangrahaApiV1FormsExportBulkPost()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.mahasangrahaApiV1FormsExportBulkPost();
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1FormsExportBulkPost: $e\n');
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

# **mahasangrahaApiV1FormsSlugAvailableGet**
> mahasangrahaApiV1FormsSlugAvailableGet()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.mahasangrahaApiV1FormsSlugAvailableGet();
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1FormsSlugAvailableGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsConditionsEvaluatePost**
> mahasangrahaApiV1ProjectsProjectIdFormsConditionsEvaluatePost()

Evaluate conditional logic for dynamic form behavior.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsConditionsEvaluatePost();
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsConditionsEvaluatePost: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnalyticsDistributionGet**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnalyticsDistributionGet(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnalyticsDistributionGet(formId);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnalyticsDistributionGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnalyticsGet**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnalyticsGet(formId)

M-11 Aggregated Analytics Endpoint Returns: totalSubmissions, completionRate, trends, fieldDistributions

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnalyticsGet(formId);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnalyticsGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnalyticsSummaryGet**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnalyticsSummaryGet(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnalyticsSummaryGet(formId);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnalyticsSummaryGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnalyticsTimelineGet**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnalyticsTimelineGet(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnalyticsTimelineGet(formId);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnalyticsTimelineGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdArchivePatch**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdArchivePatch(formId)

Admin only: Change form status to 'archived'.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdArchivePatch(formId);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdArchivePatch: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdCheckDuplicatePost**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdCheckDuplicatePost(formId)

Check if the current user has already submitted this exact data.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdCheckDuplicatePost(formId);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdCheckDuplicatePost: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdClonePost**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdClonePost(formId)

Clone a form asynchronously.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdClonePost(formId);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdClonePost: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdDelete**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdDelete(formId)

Soft delete a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdDelete(formId);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdDelete: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdExpirePatch**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdExpirePatch(formId)

Admin only: Set a date when the form automatically becomes unavailable.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdExpirePatch(formId);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdExpirePatch: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdExportCsvGet**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdExportCsvGet(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdExportCsvGet(formId);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdExportCsvGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdExportJsonGet**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdExportJsonGet(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdExportJsonGet(formId);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdExportJsonGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdFilesQuestionIdFilenameGet**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdFilesQuestionIdFilenameGet(formId, questionId, filename)

Serve uploaded files. Can be accessed by users with view permissions or for public forms

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 
final String questionId = questionId_example; // String | 
final String filename = filename_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdFilesQuestionIdFilenameGet(formId, questionId, filename);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdFilesQuestionIdFilenameGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdGet**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdGet(formId)

Retrieve a single form, applying optional language filters.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdGet(formId);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdHistoryGet**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdHistoryGet(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdHistoryGet(formId);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdHistoryGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdNextActionGet**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdNextActionGet(formId)

Check if any active workflows should be triggered for this form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdNextActionGet(formId);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdNextActionGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdPublicSubmitPost**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdPublicSubmitPost(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdPublicSubmitPost(formId);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdPublicSubmitPost: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdPublishPost**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdPublishPost(formId)

Publish a form asynchronously.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdPublishPost(formId);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdPublishPost: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdPut**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdPut(formId, body)

Update an existing form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 
final FormUpdateSchema body = ; // FormUpdateSchema | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdPut(formId, body);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdPut: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesCountGet**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesCountGet(formId)

Get total submission count for a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesCountGet(formId);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesCountGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesDelete**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesDelete(formId)

Admin only: Purge all collected responses for a specific form (Soft delete).

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesDelete(formId);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesDelete: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesGet**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesGet(formId)

List responses for a specific form (paginated).

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesGet(formId);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesLastGet**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesLastGet(formId)

Fetch the most recent response record for a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesLastGet(formId);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesLastGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesPost**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesPost(formId, body)

Authenticated form submission.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 
final FormResponseCreateSchema body = ; // FormResponseCreateSchema | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesPost(formId, body);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesPost: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdRestorePatch**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdRestorePatch(formId)

Admin only: Change form status from 'archived' back to 'draft'.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdRestorePatch(formId);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdRestorePatch: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdSharePost**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdSharePost(formId)

Admin only: Grant editor/viewer/submitter permissions for a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdSharePost(formId);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdSharePost: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdSummarizePost**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdSummarizePost(formId)

Generate summary from form responses.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdSummarizePost(formId);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdSummarizePost: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdTogglePublicPatch**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdTogglePublicPatch(formId)

Admin only: Toggle between private and public access for a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdTogglePublicPatch(formId);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdTogglePublicPatch: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdTranslationsPost**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdTranslationsPost(formId)

Update translation strings for a given language code.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdTranslationsPost(formId);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdTranslationsPost: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsImportPost**
> mahasangrahaApiV1ProjectsProjectIdFormsImportPost()

Import a full form structure from JSON.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsImportPost();
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsImportPost: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsPost**
> mahasangrahaApiV1ProjectsProjectIdFormsPost(body)

Create a new form inside the current project context.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormApi();
final FormCreateSchema body = ; // FormCreateSchema | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsPost(body);
} on DioException catch (e) {
    print('Exception when calling FormApi->mahasangrahaApiV1ProjectsProjectIdFormsPost: $e\n');
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


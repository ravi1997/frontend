# ridp_api.api.AdvancedResponsesApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1ProjectsProjectIdFormsFetchExternalGet**](AdvancedResponsesApi.md#mahasangrahaapiv1projectsprojectidformsfetchexternalget) | **GET** /mahasangraha/api/v1/projects/{project_id}/forms/fetch/external | Fetch data from another form response where some question may have match for a value. Query Params: form_id, question_id, value
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdAccessControlGet**](AdvancedResponsesApi.md#mahasangrahaapiv1projectsprojectidformsformidaccesscontrolget) | **GET** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/access-control | User access control for a forms. Returns a detailed JSON report of the current user&#39;s permissions.
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdAccessPolicyPost**](AdvancedResponsesApi.md#mahasangrahaapiv1projectsprojectidformsformidaccesspolicypost) | **POST** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/access-policy | Management route to update the Access Policy for a form. Requires &#39;manage_access&#39; permission.
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdAccessPolicyPut**](AdvancedResponsesApi.md#mahasangrahaapiv1projectsprojectidformsformidaccesspolicyput) | **PUT** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/access-policy | Management route to update the Access Policy for a form. Requires &#39;manage_access&#39; permission.
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdFetchSameGet**](AdvancedResponsesApi.md#mahasangrahaapiv1projectsprojectidformsformidfetchsameget) | **GET** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/fetch/same | Fetch data from same form response where some question may have match for a value. Query Params: question_id, value
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPost**](AdvancedResponsesApi.md#mahasangrahaapiv1projectsprojectidformsformidresponsesfilterpost) | **POST** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/responses/filter | POST /advanced_responses/&lt;form_id&gt;/responses/filter  Accept a JSON body with a &#x60;&#x60;filters&#x60;&#x60; array and return paginated FormResponse documents matching all supplied criteria.  The filter engine guarantees: - Every query is scoped to the caller&#39;s organisation and the specified form. - No MongoDB operator injection is possible via filter input. - Unsupported operators or invalid types raise a 400 error.
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesMetaGet**](AdvancedResponsesApi.md#mahasangrahaapiv1projectsprojectidformsformidresponsesmetaget) | **GET** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/responses/meta | Fetching meta information about a form response like number of response etc.
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesQuestionsGet**](AdvancedResponsesApi.md#mahasangrahaapiv1projectsprojectidformsformidresponsesquestionsget) | **GET** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/responses/questions | Fetching particular questions responses from a form only. Query Params: question_ids (comma separated)
[**mahasangrahaApiV1ProjectsProjectIdFormsGet**](AdvancedResponsesApi.md#mahasangrahaapiv1projectsprojectidformsget) | **GET** /mahasangraha/api/v1/projects/{project_id}/forms/ | Compatibility endpoint for the dashboard client.  The Flutter dashboard expects GET /mahasangraha/api/v1/forms/, so we expose a tenant-scoped listing here that mirrors the newer form listing behavior.


# **mahasangrahaApiV1ProjectsProjectIdFormsFetchExternalGet**
> mahasangrahaApiV1ProjectsProjectIdFormsFetchExternalGet()

Fetch data from another form response where some question may have match for a value. Query Params: form_id, question_id, value

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAdvancedResponsesApi();

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFetchExternalGet();
} on DioException catch (e) {
    print('Exception when calling AdvancedResponsesApi->mahasangrahaApiV1ProjectsProjectIdFormsFetchExternalGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdAccessControlGet**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdAccessControlGet(formId)

User access control for a forms. Returns a detailed JSON report of the current user's permissions.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAdvancedResponsesApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdAccessControlGet(formId);
} on DioException catch (e) {
    print('Exception when calling AdvancedResponsesApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdAccessControlGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdAccessPolicyPost**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdAccessPolicyPost(formId)

Management route to update the Access Policy for a form. Requires 'manage_access' permission.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAdvancedResponsesApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdAccessPolicyPost(formId);
} on DioException catch (e) {
    print('Exception when calling AdvancedResponsesApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdAccessPolicyPost: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdAccessPolicyPut**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdAccessPolicyPut(formId)

Management route to update the Access Policy for a form. Requires 'manage_access' permission.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAdvancedResponsesApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdAccessPolicyPut(formId);
} on DioException catch (e) {
    print('Exception when calling AdvancedResponsesApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdAccessPolicyPut: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdFetchSameGet**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdFetchSameGet(formId)

Fetch data from same form response where some question may have match for a value. Query Params: question_id, value

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAdvancedResponsesApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdFetchSameGet(formId);
} on DioException catch (e) {
    print('Exception when calling AdvancedResponsesApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdFetchSameGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPost**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPost(formId, body)

POST /advanced_responses/<form_id>/responses/filter  Accept a JSON body with a ``filters`` array and return paginated FormResponse documents matching all supplied criteria.  The filter engine guarantees: - Every query is scoped to the caller's organisation and the specified form. - No MongoDB operator injection is possible via filter input. - Unsupported operators or invalid types raise a 400 error.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAdvancedResponsesApi();
final String formId = formId_example; // String | ID of the form whose responses to filter
final MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequest body = ; // MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequest | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPost(formId, body);
} on DioException catch (e) {
    print('Exception when calling AdvancedResponsesApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**| ID of the form whose responses to filter | 
 **body** | [**MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequest**](MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesMetaGet**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesMetaGet(formId)

Fetching meta information about a form response like number of response etc.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAdvancedResponsesApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesMetaGet(formId);
} on DioException catch (e) {
    print('Exception when calling AdvancedResponsesApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesMetaGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesQuestionsGet**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesQuestionsGet(formId)

Fetching particular questions responses from a form only. Query Params: question_ids (comma separated)

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAdvancedResponsesApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesQuestionsGet(formId);
} on DioException catch (e) {
    print('Exception when calling AdvancedResponsesApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesQuestionsGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsGet**
> mahasangrahaApiV1ProjectsProjectIdFormsGet()

Compatibility endpoint for the dashboard client.  The Flutter dashboard expects GET /mahasangraha/api/v1/forms/, so we expose a tenant-scoped listing here that mirrors the newer form listing behavior.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAdvancedResponsesApi();

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsGet();
} on DioException catch (e) {
    print('Exception when calling AdvancedResponsesApi->mahasangrahaApiV1ProjectsProjectIdFormsGet: $e\n');
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


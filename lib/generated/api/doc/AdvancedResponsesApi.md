# ridp_api.api.AdvancedResponsesApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1FormsFetchExternalGet**](AdvancedResponsesApi.md#formapiv1formsfetchexternalget) | **GET** /form/api/v1/forms/fetch/external | Fetch data from another form response where some question may have match for a value. Query Params: form_id, question_id, value
[**formApiV1FormsFormIdAccessControlGet**](AdvancedResponsesApi.md#formapiv1formsformidaccesscontrolget) | **GET** /form/api/v1/forms/{form_id}/access-control | User access control for a forms. Returns a detailed JSON report of the current user&#39;s permissions.
[**formApiV1FormsFormIdAccessPolicyPost**](AdvancedResponsesApi.md#formapiv1formsformidaccesspolicypost) | **POST** /form/api/v1/forms/{form_id}/access-policy | Management route to update the Access Policy for a form. Requires &#39;manage_access&#39; permission.
[**formApiV1FormsFormIdAccessPolicyPut**](AdvancedResponsesApi.md#formapiv1formsformidaccesspolicyput) | **PUT** /form/api/v1/forms/{form_id}/access-policy | Management route to update the Access Policy for a form. Requires &#39;manage_access&#39; permission.
[**formApiV1FormsFormIdFetchSameGet**](AdvancedResponsesApi.md#formapiv1formsformidfetchsameget) | **GET** /form/api/v1/forms/{form_id}/fetch/same | Fetch data from same form response where some question may have match for a value. Query Params: question_id, value
[**formApiV1FormsFormIdResponsesMetaGet**](AdvancedResponsesApi.md#formapiv1formsformidresponsesmetaget) | **GET** /form/api/v1/forms/{form_id}/responses/meta | Fetching meta information about a form response like number of response etc.
[**formApiV1FormsFormIdResponsesQuestionsGet**](AdvancedResponsesApi.md#formapiv1formsformidresponsesquestionsget) | **GET** /form/api/v1/forms/{form_id}/responses/questions | Fetching particular questions responses from a form only. Query Params: question_ids (comma separated)
[**formApiV1FormsGet**](AdvancedResponsesApi.md#formapiv1formsget) | **GET** /form/api/v1/forms/ | Compatibility endpoint for the dashboard client.  The Flutter dashboard expects GET /form/api/v1/forms/, so we expose a tenant-scoped listing here that mirrors the newer form listing behavior.


# **formApiV1FormsFetchExternalGet**
> formApiV1FormsFetchExternalGet()

Fetch data from another form response where some question may have match for a value. Query Params: form_id, question_id, value

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAdvancedResponsesApi();

try {
    api.formApiV1FormsFetchExternalGet();
} catch on DioError (e) {
    print('Exception when calling AdvancedResponsesApi->formApiV1FormsFetchExternalGet: $e\n');
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

# **formApiV1FormsFormIdAccessControlGet**
> formApiV1FormsFormIdAccessControlGet(formId)

User access control for a forms. Returns a detailed JSON report of the current user's permissions.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAdvancedResponsesApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdAccessControlGet(formId);
} catch on DioError (e) {
    print('Exception when calling AdvancedResponsesApi->formApiV1FormsFormIdAccessControlGet: $e\n');
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

# **formApiV1FormsFormIdAccessPolicyPost**
> formApiV1FormsFormIdAccessPolicyPost(formId)

Management route to update the Access Policy for a form. Requires 'manage_access' permission.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAdvancedResponsesApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdAccessPolicyPost(formId);
} catch on DioError (e) {
    print('Exception when calling AdvancedResponsesApi->formApiV1FormsFormIdAccessPolicyPost: $e\n');
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

# **formApiV1FormsFormIdAccessPolicyPut**
> formApiV1FormsFormIdAccessPolicyPut(formId)

Management route to update the Access Policy for a form. Requires 'manage_access' permission.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAdvancedResponsesApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdAccessPolicyPut(formId);
} catch on DioError (e) {
    print('Exception when calling AdvancedResponsesApi->formApiV1FormsFormIdAccessPolicyPut: $e\n');
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

# **formApiV1FormsFormIdFetchSameGet**
> formApiV1FormsFormIdFetchSameGet(formId)

Fetch data from same form response where some question may have match for a value. Query Params: question_id, value

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAdvancedResponsesApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdFetchSameGet(formId);
} catch on DioError (e) {
    print('Exception when calling AdvancedResponsesApi->formApiV1FormsFormIdFetchSameGet: $e\n');
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

# **formApiV1FormsFormIdResponsesMetaGet**
> formApiV1FormsFormIdResponsesMetaGet(formId)

Fetching meta information about a form response like number of response etc.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAdvancedResponsesApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdResponsesMetaGet(formId);
} catch on DioError (e) {
    print('Exception when calling AdvancedResponsesApi->formApiV1FormsFormIdResponsesMetaGet: $e\n');
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

# **formApiV1FormsFormIdResponsesQuestionsGet**
> formApiV1FormsFormIdResponsesQuestionsGet(formId)

Fetching particular questions responses from a form only. Query Params: question_ids (comma separated)

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAdvancedResponsesApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1FormsFormIdResponsesQuestionsGet(formId);
} catch on DioError (e) {
    print('Exception when calling AdvancedResponsesApi->formApiV1FormsFormIdResponsesQuestionsGet: $e\n');
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

# **formApiV1FormsGet**
> formApiV1FormsGet()

Compatibility endpoint for the dashboard client.  The Flutter dashboard expects GET /form/api/v1/forms/, so we expose a tenant-scoped listing here that mirrors the newer form listing behavior.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAdvancedResponsesApi();

try {
    api.formApiV1FormsGet();
} catch on DioError (e) {
    print('Exception when calling AdvancedResponsesApi->formApiV1FormsGet: $e\n');
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


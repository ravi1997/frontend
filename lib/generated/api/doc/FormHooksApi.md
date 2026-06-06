# ridp_api.api.FormHooksApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePost**](FormHooksApi.md#mahasangrahaapiv1projectsprojectidformsexternalhookshookidapprovepost) | **POST** /mahasangraha/api/v1/projects/{project_id}/forms/external-hooks/{hook_id}/approve | Approve or reject a registered external hook (Admin only)
[**mahasangrahaApiV1ProjectsProjectIdFormsExternalHooksRegisterPost**](FormHooksApi.md#mahasangrahaapiv1projectsprojectidformsexternalhooksregisterpost) | **POST** /mahasangraha/api/v1/projects/{project_id}/forms/external-hooks/register | Register a new external hook for approval
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdHooksTriggerPost**](FormHooksApi.md#mahasangrahaapiv1projectsprojectidformsformidhookstriggerpost) | **POST** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/hooks/trigger | Synchronously trigger all top-level hooks for a form
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdQuestionsQuestionIdHooksTriggerPost**](FormHooksApi.md#mahasangrahaapiv1projectsprojectidformsformidquestionsquestionidhookstriggerpost) | **POST** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/questions/{question_id}/hooks/trigger | Synchronously trigger all hooks for a question


# **mahasangrahaApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePost**
> mahasangrahaApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePost(hookId, body)

Approve or reject a registered external hook (Admin only)

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormHooksApi();
final String hookId = hookId_example; // String | 
final MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePostRequest body = ; // MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePostRequest | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePost(hookId, body);
} on DioException catch (e) {
    print('Exception when calling FormHooksApi->mahasangrahaApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **hookId** | **String**|  | 
 **body** | [**MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePostRequest**](MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePostRequest.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1ProjectsProjectIdFormsExternalHooksRegisterPost**
> mahasangrahaApiV1ProjectsProjectIdFormsExternalHooksRegisterPost(body)

Register a new external hook for approval

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormHooksApi();
final MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksRegisterPostRequest body = ; // MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksRegisterPostRequest | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsExternalHooksRegisterPost(body);
} on DioException catch (e) {
    print('Exception when calling FormHooksApi->mahasangrahaApiV1ProjectsProjectIdFormsExternalHooksRegisterPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksRegisterPostRequest**](MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksRegisterPostRequest.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdHooksTriggerPost**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdHooksTriggerPost(formId, body)

Synchronously trigger all top-level hooks for a form

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormHooksApi();
final String formId = formId_example; // String | 
final Object body = Object; // Object | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdHooksTriggerPost(formId, body);
} on DioException catch (e) {
    print('Exception when calling FormHooksApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdHooksTriggerPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 
 **body** | **Object**|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdQuestionsQuestionIdHooksTriggerPost**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdQuestionsQuestionIdHooksTriggerPost(formId, questionId, body)

Synchronously trigger all hooks for a question

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormHooksApi();
final String formId = formId_example; // String | 
final String questionId = questionId_example; // String | 
final Object body = Object; // Object | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdQuestionsQuestionIdHooksTriggerPost(formId, questionId, body);
} on DioException catch (e) {
    print('Exception when calling FormHooksApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdQuestionsQuestionIdHooksTriggerPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 
 **questionId** | **String**|  | 
 **body** | **Object**|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


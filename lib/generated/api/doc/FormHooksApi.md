# ridp_api.api.FormHooksApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePost**](FormHooksApi.md#formapiv1projectsprojectidformsexternalhookshookidapprovepost) | **POST** /form/api/v1/projects/{project_id}/forms/external-hooks/{hook_id}/approve | Approve or reject a registered external hook (Admin only)
[**formApiV1ProjectsProjectIdFormsExternalHooksRegisterPost**](FormHooksApi.md#formapiv1projectsprojectidformsexternalhooksregisterpost) | **POST** /form/api/v1/projects/{project_id}/forms/external-hooks/register | Register a new external hook for approval
[**formApiV1ProjectsProjectIdFormsFormIdHooksTriggerPost**](FormHooksApi.md#formapiv1projectsprojectidformsformidhookstriggerpost) | **POST** /form/api/v1/projects/{project_id}/forms/{form_id}/hooks/trigger | Synchronously trigger all top-level hooks for a form
[**formApiV1ProjectsProjectIdFormsFormIdQuestionsQuestionIdHooksTriggerPost**](FormHooksApi.md#formapiv1projectsprojectidformsformidquestionsquestionidhookstriggerpost) | **POST** /form/api/v1/projects/{project_id}/forms/{form_id}/questions/{question_id}/hooks/trigger | Synchronously trigger all hooks for a question


# **formApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePost**
> formApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePost(hookId, body)

Approve or reject a registered external hook (Admin only)

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormHooksApi();
final String hookId = hookId_example; // String | 
final FormApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePostRequest body = ; // FormApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePostRequest | 

try {
    api.formApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePost(hookId, body);
} on DioException catch (e) {
    print('Exception when calling FormHooksApi->formApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **hookId** | **String**|  | 
 **body** | [**FormApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePostRequest**](FormApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePostRequest.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsExternalHooksRegisterPost**
> formApiV1ProjectsProjectIdFormsExternalHooksRegisterPost(body)

Register a new external hook for approval

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormHooksApi();
final FormApiV1ProjectsProjectIdFormsExternalHooksRegisterPostRequest body = ; // FormApiV1ProjectsProjectIdFormsExternalHooksRegisterPostRequest | 

try {
    api.formApiV1ProjectsProjectIdFormsExternalHooksRegisterPost(body);
} on DioException catch (e) {
    print('Exception when calling FormHooksApi->formApiV1ProjectsProjectIdFormsExternalHooksRegisterPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**FormApiV1ProjectsProjectIdFormsExternalHooksRegisterPostRequest**](FormApiV1ProjectsProjectIdFormsExternalHooksRegisterPostRequest.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdHooksTriggerPost**
> formApiV1ProjectsProjectIdFormsFormIdHooksTriggerPost(formId, body)

Synchronously trigger all top-level hooks for a form

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormHooksApi();
final String formId = formId_example; // String | 
final Object body = Object; // Object | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdHooksTriggerPost(formId, body);
} on DioException catch (e) {
    print('Exception when calling FormHooksApi->formApiV1ProjectsProjectIdFormsFormIdHooksTriggerPost: $e\n');
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

# **formApiV1ProjectsProjectIdFormsFormIdQuestionsQuestionIdHooksTriggerPost**
> formApiV1ProjectsProjectIdFormsFormIdQuestionsQuestionIdHooksTriggerPost(formId, questionId, body)

Synchronously trigger all hooks for a question

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormHooksApi();
final String formId = formId_example; // String | 
final String questionId = questionId_example; // String | 
final Object body = Object; // Object | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdQuestionsQuestionIdHooksTriggerPost(formId, questionId, body);
} on DioException catch (e) {
    print('Exception when calling FormHooksApi->formApiV1ProjectsProjectIdFormsFormIdQuestionsQuestionIdHooksTriggerPost: $e\n');
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


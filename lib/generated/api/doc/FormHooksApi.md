# ridp_api.api.FormHooksApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1FormsExternalHooksHookIdApprovePost**](FormHooksApi.md#formapiv1formsexternalhookshookidapprovepost) | **POST** /form/api/v1/forms/external-hooks/{hook_id}/approve | Approve or reject a registered external hook (Admin only)
[**formApiV1FormsExternalHooksRegisterPost**](FormHooksApi.md#formapiv1formsexternalhooksregisterpost) | **POST** /form/api/v1/forms/external-hooks/register | Register a new external hook for approval
[**formApiV1FormsFormIdHooksTriggerPost**](FormHooksApi.md#formapiv1formsformidhookstriggerpost) | **POST** /form/api/v1/forms/{form_id}/hooks/trigger | Synchronously trigger all top-level hooks for a form
[**formApiV1FormsFormIdQuestionsQuestionIdHooksTriggerPost**](FormHooksApi.md#formapiv1formsformidquestionsquestionidhookstriggerpost) | **POST** /form/api/v1/forms/{form_id}/questions/{question_id}/hooks/trigger | Synchronously trigger all hooks for a question
[**formApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePost**](FormHooksApi.md#formapiv1projectsprojectidformsexternalhookshookidapprovepost) | **POST** /form/api/v1/projects/{project_id}/forms/external-hooks/{hook_id}/approve | Approve or reject a registered external hook (Admin only)
[**formApiV1ProjectsProjectIdFormsExternalHooksRegisterPost**](FormHooksApi.md#formapiv1projectsprojectidformsexternalhooksregisterpost) | **POST** /form/api/v1/projects/{project_id}/forms/external-hooks/register | Register a new external hook for approval
[**formApiV1ProjectsProjectIdFormsFormIdHooksTriggerPost**](FormHooksApi.md#formapiv1projectsprojectidformsformidhookstriggerpost) | **POST** /form/api/v1/projects/{project_id}/forms/{form_id}/hooks/trigger | Synchronously trigger all top-level hooks for a form
[**formApiV1ProjectsProjectIdFormsFormIdQuestionsQuestionIdHooksTriggerPost**](FormHooksApi.md#formapiv1projectsprojectidformsformidquestionsquestionidhookstriggerpost) | **POST** /form/api/v1/projects/{project_id}/forms/{form_id}/questions/{question_id}/hooks/trigger | Synchronously trigger all hooks for a question


# **formApiV1FormsExternalHooksHookIdApprovePost**
> formApiV1FormsExternalHooksHookIdApprovePost(hookId, body)

Approve or reject a registered external hook (Admin only)

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormHooksApi();
final String hookId = hookId_example; // String | 
final FormApiV1FormsExternalHooksHookIdApprovePostRequest body = ; // FormApiV1FormsExternalHooksHookIdApprovePostRequest | 

try {
    api.formApiV1FormsExternalHooksHookIdApprovePost(hookId, body);
} catch on DioError (e) {
    print('Exception when calling FormHooksApi->formApiV1FormsExternalHooksHookIdApprovePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **hookId** | **String**|  | 
 **body** | [**FormApiV1FormsExternalHooksHookIdApprovePostRequest**](FormApiV1FormsExternalHooksHookIdApprovePostRequest.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsExternalHooksRegisterPost**
> formApiV1FormsExternalHooksRegisterPost(body)

Register a new external hook for approval

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormHooksApi();
final FormApiV1FormsExternalHooksRegisterPostRequest body = ; // FormApiV1FormsExternalHooksRegisterPostRequest | 

try {
    api.formApiV1FormsExternalHooksRegisterPost(body);
} catch on DioError (e) {
    print('Exception when calling FormHooksApi->formApiV1FormsExternalHooksRegisterPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**FormApiV1FormsExternalHooksRegisterPostRequest**](FormApiV1FormsExternalHooksRegisterPostRequest.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsFormIdHooksTriggerPost**
> formApiV1FormsFormIdHooksTriggerPost(formId, body)

Synchronously trigger all top-level hooks for a form

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormHooksApi();
final String formId = formId_example; // String | 
final Object body = Object; // Object | 

try {
    api.formApiV1FormsFormIdHooksTriggerPost(formId, body);
} catch on DioError (e) {
    print('Exception when calling FormHooksApi->formApiV1FormsFormIdHooksTriggerPost: $e\n');
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

# **formApiV1FormsFormIdQuestionsQuestionIdHooksTriggerPost**
> formApiV1FormsFormIdQuestionsQuestionIdHooksTriggerPost(formId, questionId, body)

Synchronously trigger all hooks for a question

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormHooksApi();
final String formId = formId_example; // String | 
final String questionId = questionId_example; // String | 
final Object body = Object; // Object | 

try {
    api.formApiV1FormsFormIdQuestionsQuestionIdHooksTriggerPost(formId, questionId, body);
} catch on DioError (e) {
    print('Exception when calling FormHooksApi->formApiV1FormsFormIdQuestionsQuestionIdHooksTriggerPost: $e\n');
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

# **formApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePost**
> formApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePost(hookId, body)

Approve or reject a registered external hook (Admin only)

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFormHooksApi();
final String hookId = hookId_example; // String | 
final FormApiV1FormsExternalHooksHookIdApprovePostRequest body = ; // FormApiV1FormsExternalHooksHookIdApprovePostRequest | 

try {
    api.formApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePost(hookId, body);
} catch on DioError (e) {
    print('Exception when calling FormHooksApi->formApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **hookId** | **String**|  | 
 **body** | [**FormApiV1FormsExternalHooksHookIdApprovePostRequest**](FormApiV1FormsExternalHooksHookIdApprovePostRequest.md)|  | [optional] 

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
final FormApiV1FormsExternalHooksRegisterPostRequest body = ; // FormApiV1FormsExternalHooksRegisterPostRequest | 

try {
    api.formApiV1ProjectsProjectIdFormsExternalHooksRegisterPost(body);
} catch on DioError (e) {
    print('Exception when calling FormHooksApi->formApiV1ProjectsProjectIdFormsExternalHooksRegisterPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**FormApiV1FormsExternalHooksRegisterPostRequest**](FormApiV1FormsExternalHooksRegisterPostRequest.md)|  | [optional] 

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
} catch on DioError (e) {
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
} catch on DioError (e) {
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


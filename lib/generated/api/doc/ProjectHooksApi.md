# ridp_api.api.ProjectHooksApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1FormsHooksTriggerPost**](ProjectHooksApi.md#formapiv1formshookstriggerpost) | **POST** /form/api/v1/forms/hooks/trigger | Synchronously trigger all hooks for a project
[**formApiV1ProjectsProjectIdFormsHooksTriggerPost**](ProjectHooksApi.md#formapiv1projectsprojectidformshookstriggerpost) | **POST** /form/api/v1/projects/{project_id}/forms/hooks/trigger | Synchronously trigger all hooks for a project


# **formApiV1FormsHooksTriggerPost**
> formApiV1FormsHooksTriggerPost(projectId, body)

Synchronously trigger all hooks for a project

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getProjectHooksApi();
final String projectId = projectId_example; // String | 
final Object body = Object; // Object | 

try {
    api.formApiV1FormsHooksTriggerPost(projectId, body);
} catch on DioError (e) {
    print('Exception when calling ProjectHooksApi->formApiV1FormsHooksTriggerPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectId** | **String**|  | 
 **body** | **Object**|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsHooksTriggerPost**
> formApiV1ProjectsProjectIdFormsHooksTriggerPost(projectId, body)

Synchronously trigger all hooks for a project

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getProjectHooksApi();
final String projectId = projectId_example; // String | 
final Object body = Object; // Object | 

try {
    api.formApiV1ProjectsProjectIdFormsHooksTriggerPost(projectId, body);
} catch on DioError (e) {
    print('Exception when calling ProjectHooksApi->formApiV1ProjectsProjectIdFormsHooksTriggerPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectId** | **String**|  | 
 **body** | **Object**|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


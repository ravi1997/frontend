# ridp_api.api.ProjectHooksApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1ProjectsProjectIdFormsHooksTriggerPost**](ProjectHooksApi.md#mahasangrahaapiv1projectsprojectidformshookstriggerpost) | **POST** /mahasangraha/api/v1/projects/{project_id}/forms/hooks/trigger | Synchronously trigger all hooks for a project


# **mahasangrahaApiV1ProjectsProjectIdFormsHooksTriggerPost**
> mahasangrahaApiV1ProjectsProjectIdFormsHooksTriggerPost(projectId, body)

Synchronously trigger all hooks for a project

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getProjectHooksApi();
final String projectId = projectId_example; // String | 
final Object body = Object; // Object | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsHooksTriggerPost(projectId, body);
} on DioException catch (e) {
    print('Exception when calling ProjectHooksApi->mahasangrahaApiV1ProjectsProjectIdFormsHooksTriggerPost: $e\n');
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


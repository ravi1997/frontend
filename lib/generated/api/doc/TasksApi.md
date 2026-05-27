# ridp_api.api.TasksApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1TasksTaskIdGet**](TasksApi.md#formapiv1taskstaskidget) | **GET** /form/api/v1/tasks/{task_id} | 


# **formApiV1TasksTaskIdGet**
> formApiV1TasksTaskIdGet(taskId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getTasksApi();
final String taskId = taskId_example; // String | 

try {
    api.formApiV1TasksTaskIdGet(taskId);
} on DioException catch (e) {
    print('Exception when calling TasksApi->formApiV1TasksTaskIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **taskId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


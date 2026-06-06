# ridp_api.api.AdminTasksApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1AdminTasksTaskIdGet**](AdminTasksApi.md#mahasangrahaapiv1admintaskstaskidget) | **GET** /mahasangraha/api/v1/admin/tasks/{task_id} | Get the status, progress, and results of any Celery task (admin only).


# **mahasangrahaApiV1AdminTasksTaskIdGet**
> mahasangrahaApiV1AdminTasksTaskIdGet(taskId)

Get the status, progress, and results of any Celery task (admin only).

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAdminTasksApi();
final String taskId = taskId_example; // String | 

try {
    api.mahasangrahaApiV1AdminTasksTaskIdGet(taskId);
} on DioException catch (e) {
    print('Exception when calling AdminTasksApi->mahasangrahaApiV1AdminTasksTaskIdGet: $e\n');
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


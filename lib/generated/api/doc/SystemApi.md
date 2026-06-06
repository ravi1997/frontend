# ridp_api.api.SystemApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1SystemAnalyticsTrendsOrgIdGet**](SystemApi.md#mahasangrahaapiv1systemanalyticstrendsorgidget) | **GET** /mahasangraha/api/v1/system/analytics-trends/{org_id} | Returns submission trends from the OLAP engine.
[**mahasangrahaApiV1SystemEventHealthGet**](SystemApi.md#mahasangrahaapiv1systemeventhealthget) | **GET** /mahasangraha/api/v1/system/event-health | Returns metrics about the health of the internal event system. Includes consumer lag, DLQ sizes, and stream lengths.
[**mahasangrahaApiV1SystemGdprCleanupPost**](SystemApi.md#mahasangrahaapiv1systemgdprcleanuppost) | **POST** /mahasangraha/api/v1/system/gdpr-cleanup | Initiate GDPR compliance cleanup of soft-deleted records. This is an opt-in operation that permanently deletes records older than the retention period.
[**mahasangrahaApiV1SystemTasksTaskIdGet**](SystemApi.md#mahasangrahaapiv1systemtaskstaskidget) | **GET** /mahasangraha/api/v1/system/tasks/{task_id} | Get the status of an async Celery task. Supports polling for async_publish_form, async_clone_form, async_bulk_export, and async_process_translation_job.


# **mahasangrahaApiV1SystemAnalyticsTrendsOrgIdGet**
> mahasangrahaApiV1SystemAnalyticsTrendsOrgIdGet(orgId)

Returns submission trends from the OLAP engine.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getSystemApi();
final String orgId = orgId_example; // String | 

try {
    api.mahasangrahaApiV1SystemAnalyticsTrendsOrgIdGet(orgId);
} on DioException catch (e) {
    print('Exception when calling SystemApi->mahasangrahaApiV1SystemAnalyticsTrendsOrgIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orgId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1SystemEventHealthGet**
> mahasangrahaApiV1SystemEventHealthGet()

Returns metrics about the health of the internal event system. Includes consumer lag, DLQ sizes, and stream lengths.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getSystemApi();

try {
    api.mahasangrahaApiV1SystemEventHealthGet();
} on DioException catch (e) {
    print('Exception when calling SystemApi->mahasangrahaApiV1SystemEventHealthGet: $e\n');
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

# **mahasangrahaApiV1SystemGdprCleanupPost**
> mahasangrahaApiV1SystemGdprCleanupPost()

Initiate GDPR compliance cleanup of soft-deleted records. This is an opt-in operation that permanently deletes records older than the retention period.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getSystemApi();

try {
    api.mahasangrahaApiV1SystemGdprCleanupPost();
} on DioException catch (e) {
    print('Exception when calling SystemApi->mahasangrahaApiV1SystemGdprCleanupPost: $e\n');
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

# **mahasangrahaApiV1SystemTasksTaskIdGet**
> mahasangrahaApiV1SystemTasksTaskIdGet(taskId)

Get the status of an async Celery task. Supports polling for async_publish_form, async_clone_form, async_bulk_export, and async_process_translation_job.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getSystemApi();
final String taskId = taskId_example; // String | Celery task ID

try {
    api.mahasangrahaApiV1SystemTasksTaskIdGet(taskId);
} on DioException catch (e) {
    print('Exception when calling SystemApi->mahasangrahaApiV1SystemTasksTaskIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **taskId** | **String**| Celery task ID | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


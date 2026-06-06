# ridp_api.api.WorkflowApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1WorkflowsGet**](WorkflowApi.md#mahasangrahaapiv1workflowsget) | **GET** /mahasangraha/api/v1/workflows/ | List all workflows for the current organization.
[**mahasangrahaApiV1WorkflowsPost**](WorkflowApi.md#mahasangrahaapiv1workflowspost) | **POST** /mahasangraha/api/v1/workflows/ | Create a new multi-step approval workflow.
[**mahasangrahaApiV1WorkflowsWorkflowIdDelete**](WorkflowApi.md#mahasangrahaapiv1workflowsworkflowiddelete) | **DELETE** /mahasangraha/api/v1/workflows/{workflow_id} | Soft-delete a workflow.
[**mahasangrahaApiV1WorkflowsWorkflowIdGet**](WorkflowApi.md#mahasangrahaapiv1workflowsworkflowidget) | **GET** /mahasangraha/api/v1/workflows/{workflow_id} | Get detailed workflow definition.
[**mahasangrahaApiV1WorkflowsWorkflowIdPut**](WorkflowApi.md#mahasangrahaapiv1workflowsworkflowidput) | **PUT** /mahasangraha/api/v1/workflows/{workflow_id} | Update an existing workflow.


# **mahasangrahaApiV1WorkflowsGet**
> mahasangrahaApiV1WorkflowsGet()

List all workflows for the current organization.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWorkflowApi();

try {
    api.mahasangrahaApiV1WorkflowsGet();
} on DioException catch (e) {
    print('Exception when calling WorkflowApi->mahasangrahaApiV1WorkflowsGet: $e\n');
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

# **mahasangrahaApiV1WorkflowsPost**
> mahasangrahaApiV1WorkflowsPost()

Create a new multi-step approval workflow.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWorkflowApi();

try {
    api.mahasangrahaApiV1WorkflowsPost();
} on DioException catch (e) {
    print('Exception when calling WorkflowApi->mahasangrahaApiV1WorkflowsPost: $e\n');
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

# **mahasangrahaApiV1WorkflowsWorkflowIdDelete**
> mahasangrahaApiV1WorkflowsWorkflowIdDelete(workflowId)

Soft-delete a workflow.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWorkflowApi();
final String workflowId = workflowId_example; // String | 

try {
    api.mahasangrahaApiV1WorkflowsWorkflowIdDelete(workflowId);
} on DioException catch (e) {
    print('Exception when calling WorkflowApi->mahasangrahaApiV1WorkflowsWorkflowIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **workflowId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1WorkflowsWorkflowIdGet**
> mahasangrahaApiV1WorkflowsWorkflowIdGet(workflowId)

Get detailed workflow definition.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWorkflowApi();
final String workflowId = workflowId_example; // String | 

try {
    api.mahasangrahaApiV1WorkflowsWorkflowIdGet(workflowId);
} on DioException catch (e) {
    print('Exception when calling WorkflowApi->mahasangrahaApiV1WorkflowsWorkflowIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **workflowId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1WorkflowsWorkflowIdPut**
> mahasangrahaApiV1WorkflowsWorkflowIdPut(workflowId)

Update an existing workflow.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWorkflowApi();
final String workflowId = workflowId_example; // String | 

try {
    api.mahasangrahaApiV1WorkflowsWorkflowIdPut(workflowId);
} on DioException catch (e) {
    print('Exception when calling WorkflowApi->mahasangrahaApiV1WorkflowsWorkflowIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **workflowId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


# ridp_api.api.WorkflowApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1WorkflowsGet**](WorkflowApi.md#formapiv1workflowsget) | **GET** /form/api/v1/workflows/ | List all workflows for the current organization.
[**formApiV1WorkflowsPost**](WorkflowApi.md#formapiv1workflowspost) | **POST** /form/api/v1/workflows/ | Create a new multi-step approval workflow.
[**formApiV1WorkflowsWorkflowIdDelete**](WorkflowApi.md#formapiv1workflowsworkflowiddelete) | **DELETE** /form/api/v1/workflows/{workflow_id} | Soft-delete a workflow.
[**formApiV1WorkflowsWorkflowIdGet**](WorkflowApi.md#formapiv1workflowsworkflowidget) | **GET** /form/api/v1/workflows/{workflow_id} | Get detailed workflow definition.
[**formApiV1WorkflowsWorkflowIdPut**](WorkflowApi.md#formapiv1workflowsworkflowidput) | **PUT** /form/api/v1/workflows/{workflow_id} | Update an existing workflow.


# **formApiV1WorkflowsGet**
> formApiV1WorkflowsGet()

List all workflows for the current organization.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWorkflowApi();

try {
    api.formApiV1WorkflowsGet();
} catch on DioError (e) {
    print('Exception when calling WorkflowApi->formApiV1WorkflowsGet: $e\n');
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

# **formApiV1WorkflowsPost**
> formApiV1WorkflowsPost()

Create a new multi-step approval workflow.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWorkflowApi();

try {
    api.formApiV1WorkflowsPost();
} catch on DioError (e) {
    print('Exception when calling WorkflowApi->formApiV1WorkflowsPost: $e\n');
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

# **formApiV1WorkflowsWorkflowIdDelete**
> formApiV1WorkflowsWorkflowIdDelete(workflowId)

Soft-delete a workflow.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWorkflowApi();
final String workflowId = workflowId_example; // String | 

try {
    api.formApiV1WorkflowsWorkflowIdDelete(workflowId);
} catch on DioError (e) {
    print('Exception when calling WorkflowApi->formApiV1WorkflowsWorkflowIdDelete: $e\n');
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

# **formApiV1WorkflowsWorkflowIdGet**
> formApiV1WorkflowsWorkflowIdGet(workflowId)

Get detailed workflow definition.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWorkflowApi();
final String workflowId = workflowId_example; // String | 

try {
    api.formApiV1WorkflowsWorkflowIdGet(workflowId);
} catch on DioError (e) {
    print('Exception when calling WorkflowApi->formApiV1WorkflowsWorkflowIdGet: $e\n');
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

# **formApiV1WorkflowsWorkflowIdPut**
> formApiV1WorkflowsWorkflowIdPut(workflowId)

Update an existing workflow.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWorkflowApi();
final String workflowId = workflowId_example; // String | 

try {
    api.formApiV1WorkflowsWorkflowIdPut(workflowId);
} catch on DioError (e) {
    print('Exception when calling WorkflowApi->formApiV1WorkflowsWorkflowIdPut: $e\n');
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


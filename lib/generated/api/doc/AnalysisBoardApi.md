# ridp_api.api.AnalysisBoardApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1ProjectsProjectIdAnalysisBoardsBoardIdDelete**](AnalysisBoardApi.md#formapiv1projectsprojectidanalysisboardsboardiddelete) | **DELETE** /form/api/v1/projects/{project_id}/analysis-boards/{board_id} | Delete an Analysis Board.
[**formApiV1ProjectsProjectIdAnalysisBoardsBoardIdExecuteGet**](AnalysisBoardApi.md#formapiv1projectsprojectidanalysisboardsboardidexecuteget) | **GET** /form/api/v1/projects/{project_id}/analysis-boards/{board_id}/execute | Execute calculations on an Analysis Board.
[**formApiV1ProjectsProjectIdAnalysisBoardsBoardIdGet**](AnalysisBoardApi.md#formapiv1projectsprojectidanalysisboardsboardidget) | **GET** /form/api/v1/projects/{project_id}/analysis-boards/{board_id} | Retrieve an Analysis Board by ID.
[**formApiV1ProjectsProjectIdAnalysisBoardsBoardIdPut**](AnalysisBoardApi.md#formapiv1projectsprojectidanalysisboardsboardidput) | **PUT** /form/api/v1/projects/{project_id}/analysis-boards/{board_id} | Update an Analysis Board.
[**formApiV1ProjectsProjectIdAnalysisBoardsGet**](AnalysisBoardApi.md#formapiv1projectsprojectidanalysisboardsget) | **GET** /form/api/v1/projects/{project_id}/analysis-boards/ | List all active Analysis Boards in a Project.
[**formApiV1ProjectsProjectIdAnalysisBoardsPost**](AnalysisBoardApi.md#formapiv1projectsprojectidanalysisboardspost) | **POST** /form/api/v1/projects/{project_id}/analysis-boards/ | Create a new Analysis Board in a Project.


# **formApiV1ProjectsProjectIdAnalysisBoardsBoardIdDelete**
> formApiV1ProjectsProjectIdAnalysisBoardsBoardIdDelete(projectId, boardId)

Delete an Analysis Board.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAnalysisBoardApi();
final String projectId = projectId_example; // String | 
final String boardId = boardId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdAnalysisBoardsBoardIdDelete(projectId, boardId);
} catch on DioError (e) {
    print('Exception when calling AnalysisBoardApi->formApiV1ProjectsProjectIdAnalysisBoardsBoardIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectId** | **String**|  | 
 **boardId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdAnalysisBoardsBoardIdExecuteGet**
> formApiV1ProjectsProjectIdAnalysisBoardsBoardIdExecuteGet(projectId, boardId)

Execute calculations on an Analysis Board.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAnalysisBoardApi();
final String projectId = projectId_example; // String | 
final String boardId = boardId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdAnalysisBoardsBoardIdExecuteGet(projectId, boardId);
} catch on DioError (e) {
    print('Exception when calling AnalysisBoardApi->formApiV1ProjectsProjectIdAnalysisBoardsBoardIdExecuteGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectId** | **String**|  | 
 **boardId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdAnalysisBoardsBoardIdGet**
> formApiV1ProjectsProjectIdAnalysisBoardsBoardIdGet(projectId, boardId)

Retrieve an Analysis Board by ID.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAnalysisBoardApi();
final String projectId = projectId_example; // String | 
final String boardId = boardId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdAnalysisBoardsBoardIdGet(projectId, boardId);
} catch on DioError (e) {
    print('Exception when calling AnalysisBoardApi->formApiV1ProjectsProjectIdAnalysisBoardsBoardIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectId** | **String**|  | 
 **boardId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdAnalysisBoardsBoardIdPut**
> formApiV1ProjectsProjectIdAnalysisBoardsBoardIdPut(projectId, boardId, body)

Update an Analysis Board.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAnalysisBoardApi();
final String projectId = projectId_example; // String | 
final String boardId = boardId_example; // String | 
final AnalysisBoardUpdateSchema body = ; // AnalysisBoardUpdateSchema | 

try {
    api.formApiV1ProjectsProjectIdAnalysisBoardsBoardIdPut(projectId, boardId, body);
} catch on DioError (e) {
    print('Exception when calling AnalysisBoardApi->formApiV1ProjectsProjectIdAnalysisBoardsBoardIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectId** | **String**|  | 
 **boardId** | **String**|  | 
 **body** | **AnalysisBoardUpdateSchema**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdAnalysisBoardsGet**
> formApiV1ProjectsProjectIdAnalysisBoardsGet(projectId, page, pageSize)

List all active Analysis Boards in a Project.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAnalysisBoardApi();
final String projectId = projectId_example; // String | ID of the parent Project
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    api.formApiV1ProjectsProjectIdAnalysisBoardsGet(projectId, page, pageSize);
} catch on DioError (e) {
    print('Exception when calling AnalysisBoardApi->formApiV1ProjectsProjectIdAnalysisBoardsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectId** | **String**| ID of the parent Project | 
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 50]

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdAnalysisBoardsPost**
> formApiV1ProjectsProjectIdAnalysisBoardsPost(projectId, body)

Create a new Analysis Board in a Project.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAnalysisBoardApi();
final String projectId = projectId_example; // String | ID of the parent Project
final AnalysisBoardCreateSchema body = ; // AnalysisBoardCreateSchema | 

try {
    api.formApiV1ProjectsProjectIdAnalysisBoardsPost(projectId, body);
} catch on DioError (e) {
    print('Exception when calling AnalysisBoardApi->formApiV1ProjectsProjectIdAnalysisBoardsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectId** | **String**| ID of the parent Project | 
 **body** | **AnalysisBoardCreateSchema**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


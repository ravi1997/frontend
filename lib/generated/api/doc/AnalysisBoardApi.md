# ridp_api.api.AnalysisBoardApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdDelete**](AnalysisBoardApi.md#mahasangrahaapiv1projectsprojectidanalysisboardsboardiddelete) | **DELETE** /mahasangraha/api/v1/projects/{project_id}/analysis-boards/{board_id} | Delete an Analysis Board.
[**mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdExecuteGet**](AnalysisBoardApi.md#mahasangrahaapiv1projectsprojectidanalysisboardsboardidexecuteget) | **GET** /mahasangraha/api/v1/projects/{project_id}/analysis-boards/{board_id}/execute | Execute calculations on an Analysis Board.
[**mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdGet**](AnalysisBoardApi.md#mahasangrahaapiv1projectsprojectidanalysisboardsboardidget) | **GET** /mahasangraha/api/v1/projects/{project_id}/analysis-boards/{board_id} | Retrieve an Analysis Board by ID.
[**mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdPut**](AnalysisBoardApi.md#mahasangrahaapiv1projectsprojectidanalysisboardsboardidput) | **PUT** /mahasangraha/api/v1/projects/{project_id}/analysis-boards/{board_id} | Update an Analysis Board.
[**mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsGet**](AnalysisBoardApi.md#mahasangrahaapiv1projectsprojectidanalysisboardsget) | **GET** /mahasangraha/api/v1/projects/{project_id}/analysis-boards/ | List all active Analysis Boards in a Project.
[**mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsPost**](AnalysisBoardApi.md#mahasangrahaapiv1projectsprojectidanalysisboardspost) | **POST** /mahasangraha/api/v1/projects/{project_id}/analysis-boards/ | Create a new Analysis Board in a Project.


# **mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdDelete**
> mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdDelete(projectId, boardId)

Delete an Analysis Board.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAnalysisBoardApi();
final String projectId = projectId_example; // String | 
final String boardId = boardId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdDelete(projectId, boardId);
} on DioException catch (e) {
    print('Exception when calling AnalysisBoardApi->mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdDelete: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdExecuteGet**
> mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdExecuteGet(projectId, boardId)

Execute calculations on an Analysis Board.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAnalysisBoardApi();
final String projectId = projectId_example; // String | 
final String boardId = boardId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdExecuteGet(projectId, boardId);
} on DioException catch (e) {
    print('Exception when calling AnalysisBoardApi->mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdExecuteGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdGet**
> mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdGet(projectId, boardId)

Retrieve an Analysis Board by ID.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAnalysisBoardApi();
final String projectId = projectId_example; // String | 
final String boardId = boardId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdGet(projectId, boardId);
} on DioException catch (e) {
    print('Exception when calling AnalysisBoardApi->mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdPut**
> mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdPut(projectId, boardId, body)

Update an Analysis Board.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAnalysisBoardApi();
final String projectId = projectId_example; // String | 
final String boardId = boardId_example; // String | 
final AnalysisBoardUpdateSchema body = ; // AnalysisBoardUpdateSchema | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdPut(projectId, boardId, body);
} on DioException catch (e) {
    print('Exception when calling AnalysisBoardApi->mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsBoardIdPut: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsGet**
> mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsGet(projectId, page, pageSize)

List all active Analysis Boards in a Project.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAnalysisBoardApi();
final String projectId = projectId_example; // String | ID of the parent Project
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsGet(projectId, page, pageSize);
} on DioException catch (e) {
    print('Exception when calling AnalysisBoardApi->mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsPost**
> mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsPost(projectId, body)

Create a new Analysis Board in a Project.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAnalysisBoardApi();
final String projectId = projectId_example; // String | ID of the parent Project
final AnalysisBoardCreateSchema body = ; // AnalysisBoardCreateSchema | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsPost(projectId, body);
} on DioException catch (e) {
    print('Exception when calling AnalysisBoardApi->mahasangrahaApiV1ProjectsProjectIdAnalysisBoardsPost: $e\n');
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


# ridp_api.api.ProjectApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1ProjectsPost**](ProjectApi.md#formapiv1projectspost) | **POST** /form/api/v1/projects/ | 


# **formApiV1ProjectsPost**
> formApiV1ProjectsPost(body)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getProjectApi();
final ProjectSchema body = ; // ProjectSchema | 

try {
    api.formApiV1ProjectsPost(body);
} on DioException catch (e) {
    print('Exception when calling ProjectApi->formApiV1ProjectsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**ProjectSchema**](ProjectSchema.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


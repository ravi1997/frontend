# ridp_api.api.PermissionsApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1ProjectsProjectIdFormsFormIdPermissionsGet**](PermissionsApi.md#formapiv1projectsprojectidformsformidpermissionsget) | **GET** /form/api/v1/projects/{project_id}/forms/{form_id}/permissions | 
[**formApiV1ProjectsProjectIdFormsFormIdPermissionsPost**](PermissionsApi.md#formapiv1projectsprojectidformsformidpermissionspost) | **POST** /form/api/v1/projects/{project_id}/forms/{form_id}/permissions | 


# **formApiV1ProjectsProjectIdFormsFormIdPermissionsGet**
> formApiV1ProjectsProjectIdFormsFormIdPermissionsGet(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getPermissionsApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdPermissionsGet(formId);
} on DioException catch (e) {
    print('Exception when calling PermissionsApi->formApiV1ProjectsProjectIdFormsFormIdPermissionsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ProjectsProjectIdFormsFormIdPermissionsPost**
> formApiV1ProjectsProjectIdFormsFormIdPermissionsPost(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getPermissionsApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ProjectsProjectIdFormsFormIdPermissionsPost(formId);
} on DioException catch (e) {
    print('Exception when calling PermissionsApi->formApiV1ProjectsProjectIdFormsFormIdPermissionsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


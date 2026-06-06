# ridp_api.api.PermissionsApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdPermissionsGet**](PermissionsApi.md#mahasangrahaapiv1projectsprojectidformsformidpermissionsget) | **GET** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/permissions | 
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdPermissionsPost**](PermissionsApi.md#mahasangrahaapiv1projectsprojectidformsformidpermissionspost) | **POST** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/permissions | 


# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdPermissionsGet**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdPermissionsGet(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getPermissionsApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdPermissionsGet(formId);
} on DioException catch (e) {
    print('Exception when calling PermissionsApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdPermissionsGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdPermissionsPost**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdPermissionsPost(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getPermissionsApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdPermissionsPost(formId);
} on DioException catch (e) {
    print('Exception when calling PermissionsApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdPermissionsPost: $e\n');
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


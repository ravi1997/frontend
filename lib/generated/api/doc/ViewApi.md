# ridp_api.api.ViewApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1ViewFormIdGet**](ViewApi.md#formapiv1viewformidget) | **GET** /form/api/v1/view/{form_id} | View a form. Supports both public and authenticated access. Public forms are accessible without authentication. Private forms require authentication and organization match.
[**formApiV1ViewFormIdInfoGet**](ViewApi.md#formapiv1viewformidinfoget) | **GET** /form/api/v1/view/{form_id}/info | Get form metadata without authentication for public forms. Used for initial form discovery.
[**formApiV1ViewGet**](ViewApi.md#formapiv1viewget) | **GET** /form/api/v1/view/ | 


# **formApiV1ViewFormIdGet**
> formApiV1ViewFormIdGet(formId)

View a form. Supports both public and authenticated access. Public forms are accessible without authentication. Private forms require authentication and organization match.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getViewApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ViewFormIdGet(formId);
} on DioException catch (e) {
    print('Exception when calling ViewApi->formApiV1ViewFormIdGet: $e\n');
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

# **formApiV1ViewFormIdInfoGet**
> formApiV1ViewFormIdInfoGet(formId)

Get form metadata without authentication for public forms. Used for initial form discovery.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getViewApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1ViewFormIdInfoGet(formId);
} on DioException catch (e) {
    print('Exception when calling ViewApi->formApiV1ViewFormIdInfoGet: $e\n');
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

# **formApiV1ViewGet**
> formApiV1ViewGet()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getViewApi();

try {
    api.formApiV1ViewGet();
} on DioException catch (e) {
    print('Exception when calling ViewApi->formApiV1ViewGet: $e\n');
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


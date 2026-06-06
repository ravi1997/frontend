# ridp_api.api.ViewApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1ViewFormIdGet**](ViewApi.md#mahasangrahaapiv1viewformidget) | **GET** /mahasangraha/api/v1/view/{form_id} | View a form. Supports both public and authenticated access. Public forms are accessible without authentication. Private forms require authentication and organization match.
[**mahasangrahaApiV1ViewFormIdInfoGet**](ViewApi.md#mahasangrahaapiv1viewformidinfoget) | **GET** /mahasangraha/api/v1/view/{form_id}/info | Get form metadata without authentication for public forms. Used for initial form discovery.
[**mahasangrahaApiV1ViewGet**](ViewApi.md#mahasangrahaapiv1viewget) | **GET** /mahasangraha/api/v1/view/ | 


# **mahasangrahaApiV1ViewFormIdGet**
> mahasangrahaApiV1ViewFormIdGet(formId)

View a form. Supports both public and authenticated access. Public forms are accessible without authentication. Private forms require authentication and organization match.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getViewApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ViewFormIdGet(formId);
} on DioException catch (e) {
    print('Exception when calling ViewApi->mahasangrahaApiV1ViewFormIdGet: $e\n');
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

# **mahasangrahaApiV1ViewFormIdInfoGet**
> mahasangrahaApiV1ViewFormIdInfoGet(formId)

Get form metadata without authentication for public forms. Used for initial form discovery.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getViewApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ViewFormIdInfoGet(formId);
} on DioException catch (e) {
    print('Exception when calling ViewApi->mahasangrahaApiV1ViewFormIdInfoGet: $e\n');
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

# **mahasangrahaApiV1ViewGet**
> mahasangrahaApiV1ViewGet()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getViewApi();

try {
    api.mahasangrahaApiV1ViewGet();
} on DioException catch (e) {
    print('Exception when calling ViewApi->mahasangrahaApiV1ViewGet: $e\n');
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


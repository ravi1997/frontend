# ridp_api.api.ExternalApiApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1ExternalEmployeeEmployeeIdGet**](ExternalApiApi.md#formapiv1externalemployeeemployeeidget) | **GET** /form/api/v1/external/employee/{employee_id} | Fetch details of EMPLOYEE (Empty Route Placeholder).
[**formApiV1ExternalMailPost**](ExternalApiApi.md#formapiv1externalmailpost) | **POST** /form/api/v1/external/mail | Send mail (Empty Route Placeholder).
[**formApiV1ExternalSmsPost**](ExternalApiApi.md#formapiv1externalsmspost) | **POST** /form/api/v1/external/sms | Send SMS (Empty Route Placeholder).
[**formApiV1ExternalUhidUhidGet**](ExternalApiApi.md#formapiv1externaluhiduhidget) | **GET** /form/api/v1/external/uhid/{uhid} | Fetch details of UHID (Empty Route Placeholder).


# **formApiV1ExternalEmployeeEmployeeIdGet**
> formApiV1ExternalEmployeeEmployeeIdGet(employeeId)

Fetch details of EMPLOYEE (Empty Route Placeholder).

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getExternalApiApi();
final String employeeId = employeeId_example; // String | 

try {
    api.formApiV1ExternalEmployeeEmployeeIdGet(employeeId);
} on DioException catch (e) {
    print('Exception when calling ExternalApiApi->formApiV1ExternalEmployeeEmployeeIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **employeeId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1ExternalMailPost**
> formApiV1ExternalMailPost()

Send mail (Empty Route Placeholder).

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getExternalApiApi();

try {
    api.formApiV1ExternalMailPost();
} on DioException catch (e) {
    print('Exception when calling ExternalApiApi->formApiV1ExternalMailPost: $e\n');
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

# **formApiV1ExternalSmsPost**
> formApiV1ExternalSmsPost()

Send SMS (Empty Route Placeholder).

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getExternalApiApi();

try {
    api.formApiV1ExternalSmsPost();
} on DioException catch (e) {
    print('Exception when calling ExternalApiApi->formApiV1ExternalSmsPost: $e\n');
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

# **formApiV1ExternalUhidUhidGet**
> formApiV1ExternalUhidUhidGet(uhid)

Fetch details of UHID (Empty Route Placeholder).

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getExternalApiApi();
final String uhid = uhid_example; // String | 

try {
    api.formApiV1ExternalUhidUhidGet(uhid);
} on DioException catch (e) {
    print('Exception when calling ExternalApiApi->formApiV1ExternalUhidUhidGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uhid** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


# ridp_api.api.ExternalApiApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1ExternalEmployeeEmployeeIdGet**](ExternalApiApi.md#mahasangrahaapiv1externalemployeeemployeeidget) | **GET** /mahasangraha/api/v1/external/employee/{employee_id} | Fetch details of EMPLOYEE (Empty Route Placeholder).
[**mahasangrahaApiV1ExternalMailPost**](ExternalApiApi.md#mahasangrahaapiv1externalmailpost) | **POST** /mahasangraha/api/v1/external/mail | Send mail (Empty Route Placeholder).
[**mahasangrahaApiV1ExternalSmsPost**](ExternalApiApi.md#mahasangrahaapiv1externalsmspost) | **POST** /mahasangraha/api/v1/external/sms | Send SMS (Empty Route Placeholder).
[**mahasangrahaApiV1ExternalUhidUhidGet**](ExternalApiApi.md#mahasangrahaapiv1externaluhiduhidget) | **GET** /mahasangraha/api/v1/external/uhid/{uhid} | Fetch details of UHID (Empty Route Placeholder).


# **mahasangrahaApiV1ExternalEmployeeEmployeeIdGet**
> mahasangrahaApiV1ExternalEmployeeEmployeeIdGet(employeeId)

Fetch details of EMPLOYEE (Empty Route Placeholder).

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getExternalApiApi();
final String employeeId = employeeId_example; // String | 

try {
    api.mahasangrahaApiV1ExternalEmployeeEmployeeIdGet(employeeId);
} on DioException catch (e) {
    print('Exception when calling ExternalApiApi->mahasangrahaApiV1ExternalEmployeeEmployeeIdGet: $e\n');
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

# **mahasangrahaApiV1ExternalMailPost**
> mahasangrahaApiV1ExternalMailPost()

Send mail (Empty Route Placeholder).

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getExternalApiApi();

try {
    api.mahasangrahaApiV1ExternalMailPost();
} on DioException catch (e) {
    print('Exception when calling ExternalApiApi->mahasangrahaApiV1ExternalMailPost: $e\n');
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

# **mahasangrahaApiV1ExternalSmsPost**
> mahasangrahaApiV1ExternalSmsPost()

Send SMS (Empty Route Placeholder).

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getExternalApiApi();

try {
    api.mahasangrahaApiV1ExternalSmsPost();
} on DioException catch (e) {
    print('Exception when calling ExternalApiApi->mahasangrahaApiV1ExternalSmsPost: $e\n');
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

# **mahasangrahaApiV1ExternalUhidUhidGet**
> mahasangrahaApiV1ExternalUhidUhidGet(uhid)

Fetch details of UHID (Empty Route Placeholder).

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getExternalApiApi();
final String uhid = uhid_example; // String | 

try {
    api.mahasangrahaApiV1ExternalUhidUhidGet(uhid);
} on DioException catch (e) {
    print('Exception when calling ExternalApiApi->mahasangrahaApiV1ExternalUhidUhidGet: $e\n');
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


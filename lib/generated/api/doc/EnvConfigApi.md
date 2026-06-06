# ridp_api.api.EnvConfigApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1AdminEnvConfigGet**](EnvConfigApi.md#mahasangrahaapiv1adminenvconfigget) | **GET** /mahasangraha/api/v1/admin/env-config/ | Retrieve all backend environment configurations. SUPERADMIN ONLY.
[**mahasangrahaApiV1AdminEnvConfigPost**](EnvConfigApi.md#mahasangrahaapiv1adminenvconfigpost) | **POST** /mahasangraha/api/v1/admin/env-config/ | Update backend environment configurations. SUPERADMIN ONLY.
[**mahasangrahaApiV1AdminEnvConfigPut**](EnvConfigApi.md#mahasangrahaapiv1adminenvconfigput) | **PUT** /mahasangraha/api/v1/admin/env-config/ | Update backend environment configurations. SUPERADMIN ONLY.


# **mahasangrahaApiV1AdminEnvConfigGet**
> mahasangrahaApiV1AdminEnvConfigGet()

Retrieve all backend environment configurations. SUPERADMIN ONLY.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getEnvConfigApi();

try {
    api.mahasangrahaApiV1AdminEnvConfigGet();
} on DioException catch (e) {
    print('Exception when calling EnvConfigApi->mahasangrahaApiV1AdminEnvConfigGet: $e\n');
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

# **mahasangrahaApiV1AdminEnvConfigPost**
> mahasangrahaApiV1AdminEnvConfigPost()

Update backend environment configurations. SUPERADMIN ONLY.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getEnvConfigApi();

try {
    api.mahasangrahaApiV1AdminEnvConfigPost();
} on DioException catch (e) {
    print('Exception when calling EnvConfigApi->mahasangrahaApiV1AdminEnvConfigPost: $e\n');
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

# **mahasangrahaApiV1AdminEnvConfigPut**
> mahasangrahaApiV1AdminEnvConfigPut()

Update backend environment configurations. SUPERADMIN ONLY.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getEnvConfigApi();

try {
    api.mahasangrahaApiV1AdminEnvConfigPut();
} on DioException catch (e) {
    print('Exception when calling EnvConfigApi->mahasangrahaApiV1AdminEnvConfigPut: $e\n');
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


# ridp_api.api.EnvConfigApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1AdminEnvConfigGet**](EnvConfigApi.md#formapiv1adminenvconfigget) | **GET** /form/api/v1/admin/env-config/ | Retrieve all backend environment configurations. SUPERADMIN ONLY.
[**formApiV1AdminEnvConfigPost**](EnvConfigApi.md#formapiv1adminenvconfigpost) | **POST** /form/api/v1/admin/env-config/ | Update backend environment configurations. SUPERADMIN ONLY.
[**formApiV1AdminEnvConfigPut**](EnvConfigApi.md#formapiv1adminenvconfigput) | **PUT** /form/api/v1/admin/env-config/ | Update backend environment configurations. SUPERADMIN ONLY.


# **formApiV1AdminEnvConfigGet**
> formApiV1AdminEnvConfigGet()

Retrieve all backend environment configurations. SUPERADMIN ONLY.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getEnvConfigApi();

try {
    api.formApiV1AdminEnvConfigGet();
} catch on DioError (e) {
    print('Exception when calling EnvConfigApi->formApiV1AdminEnvConfigGet: $e\n');
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

# **formApiV1AdminEnvConfigPost**
> formApiV1AdminEnvConfigPost()

Update backend environment configurations. SUPERADMIN ONLY.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getEnvConfigApi();

try {
    api.formApiV1AdminEnvConfigPost();
} catch on DioError (e) {
    print('Exception when calling EnvConfigApi->formApiV1AdminEnvConfigPost: $e\n');
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

# **formApiV1AdminEnvConfigPut**
> formApiV1AdminEnvConfigPut()

Update backend environment configurations. SUPERADMIN ONLY.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getEnvConfigApi();

try {
    api.formApiV1AdminEnvConfigPut();
} catch on DioError (e) {
    print('Exception when calling EnvConfigApi->formApiV1AdminEnvConfigPut: $e\n');
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


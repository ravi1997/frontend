# ridp_api.api.SystemSettingsApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1AdminSystemSettingsGet**](SystemSettingsApi.md#formapiv1adminsystemsettingsget) | **GET** /form/api/v1/admin/system-settings/ | Retrieve the global system configuration.
[**formApiV1AdminSystemSettingsPut**](SystemSettingsApi.md#formapiv1adminsystemsettingsput) | **PUT** /form/api/v1/admin/system-settings/ | Update the global system configuration.


# **formApiV1AdminSystemSettingsGet**
> formApiV1AdminSystemSettingsGet()

Retrieve the global system configuration.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getSystemSettingsApi();

try {
    api.formApiV1AdminSystemSettingsGet();
} catch on DioError (e) {
    print('Exception when calling SystemSettingsApi->formApiV1AdminSystemSettingsGet: $e\n');
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

# **formApiV1AdminSystemSettingsPut**
> formApiV1AdminSystemSettingsPut(body)

Update the global system configuration.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getSystemSettingsApi();
final SystemSettingsUpdateSchema body = ; // SystemSettingsUpdateSchema | 

try {
    api.formApiV1AdminSystemSettingsPut(body);
} catch on DioError (e) {
    print('Exception when calling SystemSettingsApi->formApiV1AdminSystemSettingsPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | **SystemSettingsUpdateSchema**|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


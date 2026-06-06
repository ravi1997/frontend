# ridp_api.api.SystemSettingsApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1AdminSystemSettingsGet**](SystemSettingsApi.md#mahasangrahaapiv1adminsystemsettingsget) | **GET** /mahasangraha/api/v1/admin/system-settings/ | Retrieve the global system configuration.
[**mahasangrahaApiV1AdminSystemSettingsPut**](SystemSettingsApi.md#mahasangrahaapiv1adminsystemsettingsput) | **PUT** /mahasangraha/api/v1/admin/system-settings/ | Update the global system configuration.


# **mahasangrahaApiV1AdminSystemSettingsGet**
> mahasangrahaApiV1AdminSystemSettingsGet()

Retrieve the global system configuration.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getSystemSettingsApi();

try {
    api.mahasangrahaApiV1AdminSystemSettingsGet();
} on DioException catch (e) {
    print('Exception when calling SystemSettingsApi->mahasangrahaApiV1AdminSystemSettingsGet: $e\n');
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

# **mahasangrahaApiV1AdminSystemSettingsPut**
> mahasangrahaApiV1AdminSystemSettingsPut(body)

Update the global system configuration.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getSystemSettingsApi();
final SystemSettingsUpdateSchema body = ; // SystemSettingsUpdateSchema | 

try {
    api.mahasangrahaApiV1AdminSystemSettingsPut(body);
} on DioException catch (e) {
    print('Exception when calling SystemSettingsApi->mahasangrahaApiV1AdminSystemSettingsPut: $e\n');
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


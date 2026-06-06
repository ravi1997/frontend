# ridp_api.api.ThemesApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1ThemesGet**](ThemesApi.md#mahasangrahaapiv1themesget) | **GET** /mahasangraha/api/v1/themes/ | List all themes for the organization.
[**mahasangrahaApiV1ThemesPost**](ThemesApi.md#mahasangrahaapiv1themespost) | **POST** /mahasangraha/api/v1/themes/ | Create a new custom theme.
[**mahasangrahaApiV1ThemesThemeIdDelete**](ThemesApi.md#mahasangrahaapiv1themesthemeiddelete) | **DELETE** /mahasangraha/api/v1/themes/{theme_id} | Delete a custom theme.
[**mahasangrahaApiV1ThemesThemeIdPut**](ThemesApi.md#mahasangrahaapiv1themesthemeidput) | **PUT** /mahasangraha/api/v1/themes/{theme_id} | Update custom theme settings.


# **mahasangrahaApiV1ThemesGet**
> mahasangrahaApiV1ThemesGet()

List all themes for the organization.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getThemesApi();

try {
    api.mahasangrahaApiV1ThemesGet();
} on DioException catch (e) {
    print('Exception when calling ThemesApi->mahasangrahaApiV1ThemesGet: $e\n');
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

# **mahasangrahaApiV1ThemesPost**
> mahasangrahaApiV1ThemesPost()

Create a new custom theme.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getThemesApi();

try {
    api.mahasangrahaApiV1ThemesPost();
} on DioException catch (e) {
    print('Exception when calling ThemesApi->mahasangrahaApiV1ThemesPost: $e\n');
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

# **mahasangrahaApiV1ThemesThemeIdDelete**
> mahasangrahaApiV1ThemesThemeIdDelete()

Delete a custom theme.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getThemesApi();

try {
    api.mahasangrahaApiV1ThemesThemeIdDelete();
} on DioException catch (e) {
    print('Exception when calling ThemesApi->mahasangrahaApiV1ThemesThemeIdDelete: $e\n');
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

# **mahasangrahaApiV1ThemesThemeIdPut**
> mahasangrahaApiV1ThemesThemeIdPut()

Update custom theme settings.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getThemesApi();

try {
    api.mahasangrahaApiV1ThemesThemeIdPut();
} on DioException catch (e) {
    print('Exception when calling ThemesApi->mahasangrahaApiV1ThemesThemeIdPut: $e\n');
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


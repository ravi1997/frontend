# ridp_api.api.DashboardSettingsApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1DashboardSettingsLayoutPut**](DashboardSettingsApi.md#mahasangrahaapiv1dashboardsettingslayoutput) | **PUT** /mahasangraha/api/v1/dashboard-settings/layout | Update only the layout configuration.
[**mahasangrahaApiV1DashboardSettingsResetPost**](DashboardSettingsApi.md#mahasangrahaapiv1dashboardsettingsresetpost) | **POST** /mahasangraha/api/v1/dashboard-settings/reset | Reset user dashboard settings to defaults.
[**mahasangrahaApiV1DashboardSettingsSettingsGet**](DashboardSettingsApi.md#mahasangrahaapiv1dashboardsettingssettingsget) | **GET** /mahasangraha/api/v1/dashboard-settings/settings | Get user dashboard settings.
[**mahasangrahaApiV1DashboardSettingsSettingsPut**](DashboardSettingsApi.md#mahasangrahaapiv1dashboardsettingssettingsput) | **PUT** /mahasangraha/api/v1/dashboard-settings/settings | Update user dashboard settings.
[**mahasangrahaApiV1DashboardSettingsWidgetsGet**](DashboardSettingsApi.md#mahasangrahaapiv1dashboardsettingswidgetsget) | **GET** /mahasangraha/api/v1/dashboard-settings/widgets | Get list of available widget types.
[**mahasangrahaApiV1DashboardSettingsWidgetsPositionsPut**](DashboardSettingsApi.md#mahasangrahaapiv1dashboardsettingswidgetspositionsput) | **PUT** /mahasangraha/api/v1/dashboard-settings/widgets/positions | Update positions for multiple widgets.
[**mahasangrahaApiV1DashboardSettingsWidgetsPost**](DashboardSettingsApi.md#mahasangrahaapiv1dashboardsettingswidgetspost) | **POST** /mahasangraha/api/v1/dashboard-settings/widgets | 
[**mahasangrahaApiV1DashboardSettingsWidgetsWidgetIdDelete**](DashboardSettingsApi.md#mahasangrahaapiv1dashboardsettingswidgetswidgetiddelete) | **DELETE** /mahasangraha/api/v1/dashboard-settings/widgets/{widget_id} | Remove a widget from the user&#39;s dashboard.
[**mahasangrahaApiV1DashboardSettingsWidgetsWidgetIdPut**](DashboardSettingsApi.md#mahasangrahaapiv1dashboardsettingswidgetswidgetidput) | **PUT** /mahasangraha/api/v1/dashboard-settings/widgets/{widget_id} | Update a widget&#39;s configuration.


# **mahasangrahaApiV1DashboardSettingsLayoutPut**
> mahasangrahaApiV1DashboardSettingsLayoutPut()

Update only the layout configuration.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getDashboardSettingsApi();

try {
    api.mahasangrahaApiV1DashboardSettingsLayoutPut();
} on DioException catch (e) {
    print('Exception when calling DashboardSettingsApi->mahasangrahaApiV1DashboardSettingsLayoutPut: $e\n');
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

# **mahasangrahaApiV1DashboardSettingsResetPost**
> mahasangrahaApiV1DashboardSettingsResetPost()

Reset user dashboard settings to defaults.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getDashboardSettingsApi();

try {
    api.mahasangrahaApiV1DashboardSettingsResetPost();
} on DioException catch (e) {
    print('Exception when calling DashboardSettingsApi->mahasangrahaApiV1DashboardSettingsResetPost: $e\n');
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

# **mahasangrahaApiV1DashboardSettingsSettingsGet**
> mahasangrahaApiV1DashboardSettingsSettingsGet()

Get user dashboard settings.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getDashboardSettingsApi();

try {
    api.mahasangrahaApiV1DashboardSettingsSettingsGet();
} on DioException catch (e) {
    print('Exception when calling DashboardSettingsApi->mahasangrahaApiV1DashboardSettingsSettingsGet: $e\n');
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

# **mahasangrahaApiV1DashboardSettingsSettingsPut**
> mahasangrahaApiV1DashboardSettingsSettingsPut()

Update user dashboard settings.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getDashboardSettingsApi();

try {
    api.mahasangrahaApiV1DashboardSettingsSettingsPut();
} on DioException catch (e) {
    print('Exception when calling DashboardSettingsApi->mahasangrahaApiV1DashboardSettingsSettingsPut: $e\n');
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

# **mahasangrahaApiV1DashboardSettingsWidgetsGet**
> mahasangrahaApiV1DashboardSettingsWidgetsGet()

Get list of available widget types.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getDashboardSettingsApi();

try {
    api.mahasangrahaApiV1DashboardSettingsWidgetsGet();
} on DioException catch (e) {
    print('Exception when calling DashboardSettingsApi->mahasangrahaApiV1DashboardSettingsWidgetsGet: $e\n');
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

# **mahasangrahaApiV1DashboardSettingsWidgetsPositionsPut**
> mahasangrahaApiV1DashboardSettingsWidgetsPositionsPut()

Update positions for multiple widgets.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getDashboardSettingsApi();

try {
    api.mahasangrahaApiV1DashboardSettingsWidgetsPositionsPut();
} on DioException catch (e) {
    print('Exception when calling DashboardSettingsApi->mahasangrahaApiV1DashboardSettingsWidgetsPositionsPut: $e\n');
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

# **mahasangrahaApiV1DashboardSettingsWidgetsPost**
> mahasangrahaApiV1DashboardSettingsWidgetsPost()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getDashboardSettingsApi();

try {
    api.mahasangrahaApiV1DashboardSettingsWidgetsPost();
} on DioException catch (e) {
    print('Exception when calling DashboardSettingsApi->mahasangrahaApiV1DashboardSettingsWidgetsPost: $e\n');
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

# **mahasangrahaApiV1DashboardSettingsWidgetsWidgetIdDelete**
> mahasangrahaApiV1DashboardSettingsWidgetsWidgetIdDelete(widgetId)

Remove a widget from the user's dashboard.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getDashboardSettingsApi();
final String widgetId = widgetId_example; // String | 

try {
    api.mahasangrahaApiV1DashboardSettingsWidgetsWidgetIdDelete(widgetId);
} on DioException catch (e) {
    print('Exception when calling DashboardSettingsApi->mahasangrahaApiV1DashboardSettingsWidgetsWidgetIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **widgetId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1DashboardSettingsWidgetsWidgetIdPut**
> mahasangrahaApiV1DashboardSettingsWidgetsWidgetIdPut(widgetId)

Update a widget's configuration.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getDashboardSettingsApi();
final String widgetId = widgetId_example; // String | 

try {
    api.mahasangrahaApiV1DashboardSettingsWidgetsWidgetIdPut(widgetId);
} on DioException catch (e) {
    print('Exception when calling DashboardSettingsApi->mahasangrahaApiV1DashboardSettingsWidgetsWidgetIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **widgetId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


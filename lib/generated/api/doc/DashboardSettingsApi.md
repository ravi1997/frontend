# ridp_api.api.DashboardSettingsApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1DashboardSettingsLayoutPut**](DashboardSettingsApi.md#formapiv1dashboardsettingslayoutput) | **PUT** /form/api/v1/dashboard-settings/layout | Update only the layout configuration.  Request Body:     {         \&quot;columns\&quot;: 4,         \&quot;rowHeight\&quot;: 120,         \&quot;margin\&quot;: [15, 15],         \&quot;compactType\&quot;: \&quot;vertical\&quot;,         \&quot;positions\&quot;: {             \&quot;widget_id_1\&quot;: {\&quot;x\&quot;: 0, \&quot;y\&quot;: 0}         }     }  Returns:     200: Updated settings object     400: Validation error     401: Unauthorized
[**formApiV1DashboardSettingsResetPost**](DashboardSettingsApi.md#formapiv1dashboardsettingsresetpost) | **POST** /form/api/v1/dashboard-settings/reset | Reset user dashboard settings to defaults.
[**formApiV1DashboardSettingsSettingsGet**](DashboardSettingsApi.md#formapiv1dashboardsettingssettingsget) | **GET** /form/api/v1/dashboard-settings/settings | Get user dashboard settings.
[**formApiV1DashboardSettingsSettingsPut**](DashboardSettingsApi.md#formapiv1dashboardsettingssettingsput) | **PUT** /form/api/v1/dashboard-settings/settings | Update user dashboard settings.
[**formApiV1DashboardSettingsWidgetsGet**](DashboardSettingsApi.md#formapiv1dashboardsettingswidgetsget) | **GET** /form/api/v1/dashboard-settings/widgets | Get list of available widget types.
[**formApiV1DashboardSettingsWidgetsPositionsPut**](DashboardSettingsApi.md#formapiv1dashboardsettingswidgetspositionsput) | **PUT** /form/api/v1/dashboard-settings/widgets/positions | Update positions for multiple widgets.  Used for drag-and-drop reordering of widgets.  Request Body:     {         \&quot;positions\&quot;: {             \&quot;widget_id_1\&quot;: {\&quot;x\&quot;: 0, \&quot;y\&quot;: 0},             \&quot;widget_id_2\&quot;: {\&quot;x\&quot;: 2, \&quot;y\&quot;: 0}         }     }  Returns:     200: List of updated widgets     400: Validation error     401: Unauthorized
[**formApiV1DashboardSettingsWidgetsPost**](DashboardSettingsApi.md#formapiv1dashboardsettingswidgetspost) | **POST** /form/api/v1/dashboard-settings/widgets | 
[**formApiV1DashboardSettingsWidgetsWidgetIdDelete**](DashboardSettingsApi.md#formapiv1dashboardsettingswidgetswidgetiddelete) | **DELETE** /form/api/v1/dashboard-settings/widgets/{widget_id} | Remove a widget from the user&#39;s dashboard.  Args:     widget_id: ID of the widget to remove  Returns:     200: Success message     404: Widget not found     401: Unauthorized
[**formApiV1DashboardSettingsWidgetsWidgetIdPut**](DashboardSettingsApi.md#formapiv1dashboardsettingswidgetswidgetidput) | **PUT** /form/api/v1/dashboard-settings/widgets/{widget_id} | Update a widget&#39;s configuration.  Args:     widget_id: ID of the widget to update  Request Body:     {         \&quot;position\&quot;: {\&quot;x\&quot;: 0, \&quot;y\&quot;: 4},  // Optional new position         \&quot;size\&quot;: {\&quot;w\&quot;: 2, \&quot;h\&quot;: 2},      // Optional new size         \&quot;config\&quot;: {...},               // Optional config updates         \&quot;is_visible\&quot;: True             // Optional visibility     }  Returns:     200: Updated widget object     404: Widget not found     401: Unauthorized


# **formApiV1DashboardSettingsLayoutPut**
> formApiV1DashboardSettingsLayoutPut()

Update only the layout configuration.  Request Body:     {         \"columns\": 4,         \"rowHeight\": 120,         \"margin\": [15, 15],         \"compactType\": \"vertical\",         \"positions\": {             \"widget_id_1\": {\"x\": 0, \"y\": 0}         }     }  Returns:     200: Updated settings object     400: Validation error     401: Unauthorized

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getDashboardSettingsApi();

try {
    api.formApiV1DashboardSettingsLayoutPut();
} catch on DioError (e) {
    print('Exception when calling DashboardSettingsApi->formApiV1DashboardSettingsLayoutPut: $e\n');
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

# **formApiV1DashboardSettingsResetPost**
> formApiV1DashboardSettingsResetPost()

Reset user dashboard settings to defaults.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getDashboardSettingsApi();

try {
    api.formApiV1DashboardSettingsResetPost();
} catch on DioError (e) {
    print('Exception when calling DashboardSettingsApi->formApiV1DashboardSettingsResetPost: $e\n');
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

# **formApiV1DashboardSettingsSettingsGet**
> formApiV1DashboardSettingsSettingsGet()

Get user dashboard settings.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getDashboardSettingsApi();

try {
    api.formApiV1DashboardSettingsSettingsGet();
} catch on DioError (e) {
    print('Exception when calling DashboardSettingsApi->formApiV1DashboardSettingsSettingsGet: $e\n');
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

# **formApiV1DashboardSettingsSettingsPut**
> formApiV1DashboardSettingsSettingsPut()

Update user dashboard settings.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getDashboardSettingsApi();

try {
    api.formApiV1DashboardSettingsSettingsPut();
} catch on DioError (e) {
    print('Exception when calling DashboardSettingsApi->formApiV1DashboardSettingsSettingsPut: $e\n');
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

# **formApiV1DashboardSettingsWidgetsGet**
> formApiV1DashboardSettingsWidgetsGet()

Get list of available widget types.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getDashboardSettingsApi();

try {
    api.formApiV1DashboardSettingsWidgetsGet();
} catch on DioError (e) {
    print('Exception when calling DashboardSettingsApi->formApiV1DashboardSettingsWidgetsGet: $e\n');
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

# **formApiV1DashboardSettingsWidgetsPositionsPut**
> formApiV1DashboardSettingsWidgetsPositionsPut()

Update positions for multiple widgets.  Used for drag-and-drop reordering of widgets.  Request Body:     {         \"positions\": {             \"widget_id_1\": {\"x\": 0, \"y\": 0},             \"widget_id_2\": {\"x\": 2, \"y\": 0}         }     }  Returns:     200: List of updated widgets     400: Validation error     401: Unauthorized

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getDashboardSettingsApi();

try {
    api.formApiV1DashboardSettingsWidgetsPositionsPut();
} catch on DioError (e) {
    print('Exception when calling DashboardSettingsApi->formApiV1DashboardSettingsWidgetsPositionsPut: $e\n');
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

# **formApiV1DashboardSettingsWidgetsPost**
> formApiV1DashboardSettingsWidgetsPost()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getDashboardSettingsApi();

try {
    api.formApiV1DashboardSettingsWidgetsPost();
} catch on DioError (e) {
    print('Exception when calling DashboardSettingsApi->formApiV1DashboardSettingsWidgetsPost: $e\n');
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

# **formApiV1DashboardSettingsWidgetsWidgetIdDelete**
> formApiV1DashboardSettingsWidgetsWidgetIdDelete(widgetId)

Remove a widget from the user's dashboard.  Args:     widget_id: ID of the widget to remove  Returns:     200: Success message     404: Widget not found     401: Unauthorized

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getDashboardSettingsApi();
final String widgetId = widgetId_example; // String | 

try {
    api.formApiV1DashboardSettingsWidgetsWidgetIdDelete(widgetId);
} catch on DioError (e) {
    print('Exception when calling DashboardSettingsApi->formApiV1DashboardSettingsWidgetsWidgetIdDelete: $e\n');
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

# **formApiV1DashboardSettingsWidgetsWidgetIdPut**
> formApiV1DashboardSettingsWidgetsWidgetIdPut(widgetId)

Update a widget's configuration.  Args:     widget_id: ID of the widget to update  Request Body:     {         \"position\": {\"x\": 0, \"y\": 4},  // Optional new position         \"size\": {\"w\": 2, \"h\": 2},      // Optional new size         \"config\": {...},               // Optional config updates         \"is_visible\": True             // Optional visibility     }  Returns:     200: Updated widget object     404: Widget not found     401: Unauthorized

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getDashboardSettingsApi();
final String widgetId = widgetId_example; // String | 

try {
    api.formApiV1DashboardSettingsWidgetsWidgetIdPut(widgetId);
} catch on DioError (e) {
    print('Exception when calling DashboardSettingsApi->formApiV1DashboardSettingsWidgetsWidgetIdPut: $e\n');
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


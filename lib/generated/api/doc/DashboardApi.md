# ridp_api.api.DashboardApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1DashboardsDashboardIdPut**](DashboardApi.md#formapiv1dashboardsdashboardidput) | **PUT** /form/api/v1/dashboards/{dashboard_id} | Update Dashboard configuration.
[**formApiV1DashboardsPost**](DashboardApi.md#formapiv1dashboardspost) | **POST** /form/api/v1/dashboards/ | Create a new Dashboard configuration.
[**formApiV1DashboardsSlugGet**](DashboardApi.md#formapiv1dashboardsslugget) | **GET** /form/api/v1/dashboards/{slug} | Get dashboard details AND fetch data for widgets.


# **formApiV1DashboardsDashboardIdPut**
> formApiV1DashboardsDashboardIdPut(dashboardId, body)

Update Dashboard configuration.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getDashboardApi();
final String dashboardId = dashboardId_example; // String | 
final Map<String, Object> body = Object; // Map<String, Object> | 

try {
    api.formApiV1DashboardsDashboardIdPut(dashboardId, body);
} on DioException catch (e) {
    print('Exception when calling DashboardApi->formApiV1DashboardsDashboardIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dashboardId** | **String**|  | 
 **body** | [**Map&lt;String, Object&gt;**](Object.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1DashboardsPost**
> formApiV1DashboardsPost(body)

Create a new Dashboard configuration.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getDashboardApi();
final Map<String, Object> body = Object; // Map<String, Object> | 

try {
    api.formApiV1DashboardsPost(body);
} on DioException catch (e) {
    print('Exception when calling DashboardApi->formApiV1DashboardsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**Map&lt;String, Object&gt;**](Object.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1DashboardsSlugGet**
> formApiV1DashboardsSlugGet(slug)

Get dashboard details AND fetch data for widgets.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getDashboardApi();
final String slug = slug_example; // String | 

try {
    api.formApiV1DashboardsSlugGet(slug);
} on DioException catch (e) {
    print('Exception when calling DashboardApi->formApiV1DashboardsSlugGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **slug** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


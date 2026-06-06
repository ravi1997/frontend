# ridp_api.api.DashboardApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1DashboardsDashboardIdPut**](DashboardApi.md#mahasangrahaapiv1dashboardsdashboardidput) | **PUT** /mahasangraha/api/v1/dashboards/{dashboard_id} | Update Dashboard configuration.
[**mahasangrahaApiV1DashboardsPost**](DashboardApi.md#mahasangrahaapiv1dashboardspost) | **POST** /mahasangraha/api/v1/dashboards/ | Create a new Dashboard configuration.
[**mahasangrahaApiV1DashboardsSlugGet**](DashboardApi.md#mahasangrahaapiv1dashboardsslugget) | **GET** /mahasangraha/api/v1/dashboards/{slug} | Get dashboard details AND fetch data for widgets.


# **mahasangrahaApiV1DashboardsDashboardIdPut**
> mahasangrahaApiV1DashboardsDashboardIdPut(dashboardId, body)

Update Dashboard configuration.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getDashboardApi();
final String dashboardId = dashboardId_example; // String | 
final DashboardUpdateSchema body = ; // DashboardUpdateSchema | 

try {
    api.mahasangrahaApiV1DashboardsDashboardIdPut(dashboardId, body);
} on DioException catch (e) {
    print('Exception when calling DashboardApi->mahasangrahaApiV1DashboardsDashboardIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dashboardId** | **String**|  | 
 **body** | **DashboardUpdateSchema**|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1DashboardsPost**
> mahasangrahaApiV1DashboardsPost(body)

Create a new Dashboard configuration.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getDashboardApi();
final DashboardCreateSchema body = ; // DashboardCreateSchema | 

try {
    api.mahasangrahaApiV1DashboardsPost(body);
} on DioException catch (e) {
    print('Exception when calling DashboardApi->mahasangrahaApiV1DashboardsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | **DashboardCreateSchema**|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1DashboardsSlugGet**
> mahasangrahaApiV1DashboardsSlugGet(slug)

Get dashboard details AND fetch data for widgets.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getDashboardApi();
final String slug = slug_example; // String | 

try {
    api.mahasangrahaApiV1DashboardsSlugGet(slug);
} on DioException catch (e) {
    print('Exception when calling DashboardApi->mahasangrahaApiV1DashboardsSlugGet: $e\n');
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


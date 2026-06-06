# ridp_api.api.AnalyticsApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1AnalyticsDashboardGet**](AnalyticsApi.md#mahasangrahaapiv1analyticsdashboardget) | **GET** /mahasangraha/api/v1/analytics/dashboard | Compute and return system-wide dashboard statistics. Restricted to privileged users to prevent sensitive data leakage.
[**mahasangrahaApiV1AnalyticsSummaryGet**](AnalyticsApi.md#mahasangrahaapiv1analyticssummaryget) | **GET** /mahasangraha/api/v1/analytics/summary | Returns organization-wide summary statistics.


# **mahasangrahaApiV1AnalyticsDashboardGet**
> mahasangrahaApiV1AnalyticsDashboardGet()

Compute and return system-wide dashboard statistics. Restricted to privileged users to prevent sensitive data leakage.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAnalyticsApi();

try {
    api.mahasangrahaApiV1AnalyticsDashboardGet();
} on DioException catch (e) {
    print('Exception when calling AnalyticsApi->mahasangrahaApiV1AnalyticsDashboardGet: $e\n');
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

# **mahasangrahaApiV1AnalyticsSummaryGet**
> mahasangrahaApiV1AnalyticsSummaryGet()

Returns organization-wide summary statistics.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAnalyticsApi();

try {
    api.mahasangrahaApiV1AnalyticsSummaryGet();
} on DioException catch (e) {
    print('Exception when calling AnalyticsApi->mahasangrahaApiV1AnalyticsSummaryGet: $e\n');
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


# ridp_api.api.FeatureFlagsApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1AdminFeatureFlagsFlagKeyOverrideOrgIdPut**](FeatureFlagsApi.md#mahasangrahaapiv1adminfeatureflagsflagkeyoverrideorgidput) | **PUT** /mahasangraha/api/v1/admin/feature-flags/{flag_key}/override/{org_id} | Configure feature flag override for a specific organization (Superadmin only)
[**mahasangrahaApiV1AdminFeatureFlagsFlagKeyPut**](FeatureFlagsApi.md#mahasangrahaapiv1adminfeatureflagsflagkeyput) | **PUT** /mahasangraha/api/v1/admin/feature-flags/{flag_key} | Update global feature flag default state (Superadmin only)
[**mahasangrahaApiV1AdminFeatureFlagsGet**](FeatureFlagsApi.md#mahasangrahaapiv1adminfeatureflagsget) | **GET** /mahasangraha/api/v1/admin/feature-flags/ | Get all feature flags and overrides (Superadmin only)


# **mahasangrahaApiV1AdminFeatureFlagsFlagKeyOverrideOrgIdPut**
> mahasangrahaApiV1AdminFeatureFlagsFlagKeyOverrideOrgIdPut(flagKey, orgId, body)

Configure feature flag override for a specific organization (Superadmin only)

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFeatureFlagsApi();
final String flagKey = flagKey_example; // String | 
final String orgId = orgId_example; // String | 
final MahasangrahaApiV1AdminFeatureFlagsFlagKeyPutRequest body = ; // MahasangrahaApiV1AdminFeatureFlagsFlagKeyPutRequest | 

try {
    api.mahasangrahaApiV1AdminFeatureFlagsFlagKeyOverrideOrgIdPut(flagKey, orgId, body);
} on DioException catch (e) {
    print('Exception when calling FeatureFlagsApi->mahasangrahaApiV1AdminFeatureFlagsFlagKeyOverrideOrgIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **flagKey** | **String**|  | 
 **orgId** | **String**|  | 
 **body** | [**MahasangrahaApiV1AdminFeatureFlagsFlagKeyPutRequest**](MahasangrahaApiV1AdminFeatureFlagsFlagKeyPutRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1AdminFeatureFlagsFlagKeyPut**
> mahasangrahaApiV1AdminFeatureFlagsFlagKeyPut(flagKey, body)

Update global feature flag default state (Superadmin only)

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFeatureFlagsApi();
final String flagKey = flagKey_example; // String | 
final MahasangrahaApiV1AdminFeatureFlagsFlagKeyPutRequest body = ; // MahasangrahaApiV1AdminFeatureFlagsFlagKeyPutRequest | 

try {
    api.mahasangrahaApiV1AdminFeatureFlagsFlagKeyPut(flagKey, body);
} on DioException catch (e) {
    print('Exception when calling FeatureFlagsApi->mahasangrahaApiV1AdminFeatureFlagsFlagKeyPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **flagKey** | **String**|  | 
 **body** | [**MahasangrahaApiV1AdminFeatureFlagsFlagKeyPutRequest**](MahasangrahaApiV1AdminFeatureFlagsFlagKeyPutRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1AdminFeatureFlagsGet**
> mahasangrahaApiV1AdminFeatureFlagsGet()

Get all feature flags and overrides (Superadmin only)

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getFeatureFlagsApi();

try {
    api.mahasangrahaApiV1AdminFeatureFlagsGet();
} on DioException catch (e) {
    print('Exception when calling FeatureFlagsApi->mahasangrahaApiV1AdminFeatureFlagsGet: $e\n');
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


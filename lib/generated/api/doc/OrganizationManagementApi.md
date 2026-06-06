# ridp_api.api.OrganizationManagementApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1AdminOrgsGet**](OrganizationManagementApi.md#mahasangrahaapiv1adminorgsget) | **GET** /mahasangraha/api/v1/admin/orgs/ | List all organizations (Superadmin only)
[**mahasangrahaApiV1AdminOrgsOrgIdAdminPut**](OrganizationManagementApi.md#mahasangrahaapiv1adminorgsorgidadminput) | **PUT** /mahasangraha/api/v1/admin/orgs/{org_id}/admin | Assign an administrator user to an organization (Superadmin only)
[**mahasangrahaApiV1AdminOrgsOrgIdStatsGet**](OrganizationManagementApi.md#mahasangrahaapiv1adminorgsorgidstatsget) | **GET** /mahasangraha/api/v1/admin/orgs/{org_id}/stats | Retrieve standard organization metrics (Admin and Superadmin)
[**mahasangrahaApiV1AdminOrgsOrgIdStatusPut**](OrganizationManagementApi.md#mahasangrahaapiv1adminorgsorgidstatusput) | **PUT** /mahasangraha/api/v1/admin/orgs/{org_id}/status | Suspend or activate an organization (Superadmin only)
[**mahasangrahaApiV1AdminOrgsPost**](OrganizationManagementApi.md#mahasangrahaapiv1adminorgspost) | **POST** /mahasangraha/api/v1/admin/orgs/ | Create an Enterprise Organization (Superadmin only)


# **mahasangrahaApiV1AdminOrgsGet**
> mahasangrahaApiV1AdminOrgsGet()

List all organizations (Superadmin only)

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getOrganizationManagementApi();

try {
    api.mahasangrahaApiV1AdminOrgsGet();
} on DioException catch (e) {
    print('Exception when calling OrganizationManagementApi->mahasangrahaApiV1AdminOrgsGet: $e\n');
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

# **mahasangrahaApiV1AdminOrgsOrgIdAdminPut**
> mahasangrahaApiV1AdminOrgsOrgIdAdminPut(orgId, body)

Assign an administrator user to an organization (Superadmin only)

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getOrganizationManagementApi();
final String orgId = orgId_example; // String | 
final MahasangrahaApiV1AdminOrgsOrgIdAdminPutRequest body = ; // MahasangrahaApiV1AdminOrgsOrgIdAdminPutRequest | 

try {
    api.mahasangrahaApiV1AdminOrgsOrgIdAdminPut(orgId, body);
} on DioException catch (e) {
    print('Exception when calling OrganizationManagementApi->mahasangrahaApiV1AdminOrgsOrgIdAdminPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orgId** | **String**|  | 
 **body** | [**MahasangrahaApiV1AdminOrgsOrgIdAdminPutRequest**](MahasangrahaApiV1AdminOrgsOrgIdAdminPutRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1AdminOrgsOrgIdStatsGet**
> mahasangrahaApiV1AdminOrgsOrgIdStatsGet(orgId)

Retrieve standard organization metrics (Admin and Superadmin)

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getOrganizationManagementApi();
final String orgId = orgId_example; // String | 

try {
    api.mahasangrahaApiV1AdminOrgsOrgIdStatsGet(orgId);
} on DioException catch (e) {
    print('Exception when calling OrganizationManagementApi->mahasangrahaApiV1AdminOrgsOrgIdStatsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orgId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1AdminOrgsOrgIdStatusPut**
> mahasangrahaApiV1AdminOrgsOrgIdStatusPut(orgId, body)

Suspend or activate an organization (Superadmin only)

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getOrganizationManagementApi();
final String orgId = orgId_example; // String | 
final MahasangrahaApiV1AdminOrgsOrgIdStatusPutRequest body = ; // MahasangrahaApiV1AdminOrgsOrgIdStatusPutRequest | 

try {
    api.mahasangrahaApiV1AdminOrgsOrgIdStatusPut(orgId, body);
} on DioException catch (e) {
    print('Exception when calling OrganizationManagementApi->mahasangrahaApiV1AdminOrgsOrgIdStatusPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orgId** | **String**|  | 
 **body** | [**MahasangrahaApiV1AdminOrgsOrgIdStatusPutRequest**](MahasangrahaApiV1AdminOrgsOrgIdStatusPutRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1AdminOrgsPost**
> mahasangrahaApiV1AdminOrgsPost(body)

Create an Enterprise Organization (Superadmin only)

Registers a new organization and atomically configures its default tenant settings/quotas.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getOrganizationManagementApi();
final MahasangrahaApiV1AdminOrgsPostRequest body = ; // MahasangrahaApiV1AdminOrgsPostRequest | 

try {
    api.mahasangrahaApiV1AdminOrgsPost(body);
} on DioException catch (e) {
    print('Exception when calling OrganizationManagementApi->mahasangrahaApiV1AdminOrgsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**MahasangrahaApiV1AdminOrgsPostRequest**](MahasangrahaApiV1AdminOrgsPostRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


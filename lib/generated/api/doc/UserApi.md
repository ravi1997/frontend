# ridp_api.api.UserApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1UserChangePasswordPost**](UserApi.md#mahasangrahaapiv1userchangepasswordpost) | **POST** /mahasangraha/api/v1/user/change-password | Securely change current user&#39;s password.
[**mahasangrahaApiV1UserProfileGet**](UserApi.md#mahasangrahaapiv1userprofileget) | **GET** /mahasangraha/api/v1/user/profile | Return currently authenticated user&#39;s profile.
[**mahasangrahaApiV1UserSecurityLockStatusUserIdGet**](UserApi.md#mahasangrahaapiv1usersecuritylockstatususeridget) | **GET** /mahasangraha/api/v1/user/security/lock-status/{user_id} | Get account lock status for a specific user. Admin only.
[**mahasangrahaApiV1UserStatusGet**](UserApi.md#mahasangrahaapiv1userstatusget) | **GET** /mahasangraha/api/v1/user/status | Return currently authenticated user&#39;s profile.
[**mahasangrahaApiV1UserUsersGet**](UserApi.md#mahasangrahaapiv1userusersget) | **GET** /mahasangraha/api/v1/user/users | List all registered users. Admin only.
[**mahasangrahaApiV1UserUsersPost**](UserApi.md#mahasangrahaapiv1useruserspost) | **POST** /mahasangraha/api/v1/user/users | Provision a new user account. Admin only.
[**mahasangrahaApiV1UserUsersUserIdDelete**](UserApi.md#mahasangrahaapiv1userusersuseriddelete) | **DELETE** /mahasangraha/api/v1/user/users/{user_id} | Soft-delete a user account. Superadmin only.
[**mahasangrahaApiV1UserUsersUserIdGet**](UserApi.md#mahasangrahaapiv1userusersuseridget) | **GET** /mahasangraha/api/v1/user/users/{user_id} | Fetch details of a specific user. Admin only.
[**mahasangrahaApiV1UserUsersUserIdLockPost**](UserApi.md#mahasangrahaapiv1userusersuseridlockpost) | **POST** /mahasangraha/api/v1/user/users/{user_id}/lock | Manually lock a user account. Admin only.
[**mahasangrahaApiV1UserUsersUserIdPut**](UserApi.md#mahasangrahaapiv1userusersuseridput) | **PUT** /mahasangraha/api/v1/user/users/{user_id} | Update user attributes. Admin only.
[**mahasangrahaApiV1UserUsersUserIdRolesPut**](UserApi.md#mahasangrahaapiv1userusersuseridrolesput) | **PUT** /mahasangraha/api/v1/user/users/{user_id}/roles | Update user roles. Admin only.
[**mahasangrahaApiV1UserUsersUserIdUnlockPost**](UserApi.md#mahasangrahaapiv1userusersuseridunlockpost) | **POST** /mahasangraha/api/v1/user/users/{user_id}/unlock | Manually unlock a user account. Admin only.
[**mahasangrahaApiV1UsersChangePasswordPost**](UserApi.md#mahasangrahaapiv1userschangepasswordpost) | **POST** /mahasangraha/api/v1/users/change-password | Securely change current user&#39;s password.
[**mahasangrahaApiV1UsersProfileGet**](UserApi.md#mahasangrahaapiv1usersprofileget) | **GET** /mahasangraha/api/v1/users/profile | Return currently authenticated user&#39;s profile.
[**mahasangrahaApiV1UsersSecurityLockStatusUserIdGet**](UserApi.md#mahasangrahaapiv1userssecuritylockstatususeridget) | **GET** /mahasangraha/api/v1/users/security/lock-status/{user_id} | Get account lock status for a specific user. Admin only.
[**mahasangrahaApiV1UsersStatusGet**](UserApi.md#mahasangrahaapiv1usersstatusget) | **GET** /mahasangraha/api/v1/users/status | Return currently authenticated user&#39;s profile.
[**mahasangrahaApiV1UsersUsersGet**](UserApi.md#mahasangrahaapiv1usersusersget) | **GET** /mahasangraha/api/v1/users/users | List all registered users. Admin only.
[**mahasangrahaApiV1UsersUsersPost**](UserApi.md#mahasangrahaapiv1usersuserspost) | **POST** /mahasangraha/api/v1/users/users | Provision a new user account. Admin only.
[**mahasangrahaApiV1UsersUsersUserIdDelete**](UserApi.md#mahasangrahaapiv1usersusersuseriddelete) | **DELETE** /mahasangraha/api/v1/users/users/{user_id} | Soft-delete a user account. Superadmin only.
[**mahasangrahaApiV1UsersUsersUserIdGet**](UserApi.md#mahasangrahaapiv1usersusersuseridget) | **GET** /mahasangraha/api/v1/users/users/{user_id} | Fetch details of a specific user. Admin only.
[**mahasangrahaApiV1UsersUsersUserIdLockPost**](UserApi.md#mahasangrahaapiv1usersusersuseridlockpost) | **POST** /mahasangraha/api/v1/users/users/{user_id}/lock | Manually lock a user account. Admin only.
[**mahasangrahaApiV1UsersUsersUserIdPut**](UserApi.md#mahasangrahaapiv1usersusersuseridput) | **PUT** /mahasangraha/api/v1/users/users/{user_id} | Update user attributes. Admin only.
[**mahasangrahaApiV1UsersUsersUserIdRolesPut**](UserApi.md#mahasangrahaapiv1usersusersuseridrolesput) | **PUT** /mahasangraha/api/v1/users/users/{user_id}/roles | Update user roles. Admin only.
[**mahasangrahaApiV1UsersUsersUserIdUnlockPost**](UserApi.md#mahasangrahaapiv1usersusersuseridunlockpost) | **POST** /mahasangraha/api/v1/users/users/{user_id}/unlock | Manually unlock a user account. Admin only.


# **mahasangrahaApiV1UserChangePasswordPost**
> mahasangrahaApiV1UserChangePasswordPost()

Securely change current user's password.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();

try {
    api.mahasangrahaApiV1UserChangePasswordPost();
} on DioException catch (e) {
    print('Exception when calling UserApi->mahasangrahaApiV1UserChangePasswordPost: $e\n');
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

# **mahasangrahaApiV1UserProfileGet**
> UserOut mahasangrahaApiV1UserProfileGet()

Return currently authenticated user's profile.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();

try {
    final response = api.mahasangrahaApiV1UserProfileGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->mahasangrahaApiV1UserProfileGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserOut**](UserOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1UserSecurityLockStatusUserIdGet**
> MahasangrahaApiV1UserSecurityLockStatusUserIdGet200Response mahasangrahaApiV1UserSecurityLockStatusUserIdGet(userId)

Get account lock status for a specific user. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 

try {
    final response = api.mahasangrahaApiV1UserSecurityLockStatusUserIdGet(userId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->mahasangrahaApiV1UserSecurityLockStatusUserIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

[**MahasangrahaApiV1UserSecurityLockStatusUserIdGet200Response**](MahasangrahaApiV1UserSecurityLockStatusUserIdGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1UserStatusGet**
> UserOut mahasangrahaApiV1UserStatusGet()

Return currently authenticated user's profile.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();

try {
    final response = api.mahasangrahaApiV1UserStatusGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->mahasangrahaApiV1UserStatusGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserOut**](UserOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1UserUsersGet**
> UserOut mahasangrahaApiV1UserUsersGet()

List all registered users. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();

try {
    final response = api.mahasangrahaApiV1UserUsersGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->mahasangrahaApiV1UserUsersGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserOut**](UserOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1UserUsersPost**
> UserOut mahasangrahaApiV1UserUsersPost(body)

Provision a new user account. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final UserUpdateSchema body = ; // UserUpdateSchema | 

try {
    final response = api.mahasangrahaApiV1UserUsersPost(body);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->mahasangrahaApiV1UserUsersPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**UserUpdateSchema**](UserUpdateSchema.md)|  | [optional] 

### Return type

[**UserOut**](UserOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1UserUsersUserIdDelete**
> mahasangrahaApiV1UserUsersUserIdDelete(userId)

Soft-delete a user account. Superadmin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 

try {
    api.mahasangrahaApiV1UserUsersUserIdDelete(userId);
} on DioException catch (e) {
    print('Exception when calling UserApi->mahasangrahaApiV1UserUsersUserIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1UserUsersUserIdGet**
> UserOut mahasangrahaApiV1UserUsersUserIdGet(userId)

Fetch details of a specific user. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 

try {
    final response = api.mahasangrahaApiV1UserUsersUserIdGet(userId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->mahasangrahaApiV1UserUsersUserIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

[**UserOut**](UserOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1UserUsersUserIdLockPost**
> mahasangrahaApiV1UserUsersUserIdLockPost(userId)

Manually lock a user account. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 

try {
    api.mahasangrahaApiV1UserUsersUserIdLockPost(userId);
} on DioException catch (e) {
    print('Exception when calling UserApi->mahasangrahaApiV1UserUsersUserIdLockPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1UserUsersUserIdPut**
> UserOut mahasangrahaApiV1UserUsersUserIdPut(userId, body)

Update user attributes. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 
final UserUpdateSchema body = ; // UserUpdateSchema | 

try {
    final response = api.mahasangrahaApiV1UserUsersUserIdPut(userId, body);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->mahasangrahaApiV1UserUsersUserIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **body** | [**UserUpdateSchema**](UserUpdateSchema.md)|  | [optional] 

### Return type

[**UserOut**](UserOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1UserUsersUserIdRolesPut**
> UserOut mahasangrahaApiV1UserUsersUserIdRolesPut(userId)

Update user roles. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 

try {
    final response = api.mahasangrahaApiV1UserUsersUserIdRolesPut(userId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->mahasangrahaApiV1UserUsersUserIdRolesPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

[**UserOut**](UserOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1UserUsersUserIdUnlockPost**
> mahasangrahaApiV1UserUsersUserIdUnlockPost(userId)

Manually unlock a user account. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 

try {
    api.mahasangrahaApiV1UserUsersUserIdUnlockPost(userId);
} on DioException catch (e) {
    print('Exception when calling UserApi->mahasangrahaApiV1UserUsersUserIdUnlockPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1UsersChangePasswordPost**
> mahasangrahaApiV1UsersChangePasswordPost()

Securely change current user's password.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();

try {
    api.mahasangrahaApiV1UsersChangePasswordPost();
} on DioException catch (e) {
    print('Exception when calling UserApi->mahasangrahaApiV1UsersChangePasswordPost: $e\n');
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

# **mahasangrahaApiV1UsersProfileGet**
> UserOut mahasangrahaApiV1UsersProfileGet()

Return currently authenticated user's profile.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();

try {
    final response = api.mahasangrahaApiV1UsersProfileGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->mahasangrahaApiV1UsersProfileGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserOut**](UserOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1UsersSecurityLockStatusUserIdGet**
> MahasangrahaApiV1UserSecurityLockStatusUserIdGet200Response mahasangrahaApiV1UsersSecurityLockStatusUserIdGet(userId)

Get account lock status for a specific user. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 

try {
    final response = api.mahasangrahaApiV1UsersSecurityLockStatusUserIdGet(userId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->mahasangrahaApiV1UsersSecurityLockStatusUserIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

[**MahasangrahaApiV1UserSecurityLockStatusUserIdGet200Response**](MahasangrahaApiV1UserSecurityLockStatusUserIdGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1UsersStatusGet**
> UserOut mahasangrahaApiV1UsersStatusGet()

Return currently authenticated user's profile.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();

try {
    final response = api.mahasangrahaApiV1UsersStatusGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->mahasangrahaApiV1UsersStatusGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserOut**](UserOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1UsersUsersGet**
> UserOut mahasangrahaApiV1UsersUsersGet()

List all registered users. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();

try {
    final response = api.mahasangrahaApiV1UsersUsersGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->mahasangrahaApiV1UsersUsersGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserOut**](UserOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1UsersUsersPost**
> UserOut mahasangrahaApiV1UsersUsersPost(body)

Provision a new user account. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final UserUpdateSchema body = ; // UserUpdateSchema | 

try {
    final response = api.mahasangrahaApiV1UsersUsersPost(body);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->mahasangrahaApiV1UsersUsersPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**UserUpdateSchema**](UserUpdateSchema.md)|  | [optional] 

### Return type

[**UserOut**](UserOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1UsersUsersUserIdDelete**
> mahasangrahaApiV1UsersUsersUserIdDelete(userId)

Soft-delete a user account. Superadmin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 

try {
    api.mahasangrahaApiV1UsersUsersUserIdDelete(userId);
} on DioException catch (e) {
    print('Exception when calling UserApi->mahasangrahaApiV1UsersUsersUserIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1UsersUsersUserIdGet**
> UserOut mahasangrahaApiV1UsersUsersUserIdGet(userId)

Fetch details of a specific user. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 

try {
    final response = api.mahasangrahaApiV1UsersUsersUserIdGet(userId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->mahasangrahaApiV1UsersUsersUserIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

[**UserOut**](UserOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1UsersUsersUserIdLockPost**
> mahasangrahaApiV1UsersUsersUserIdLockPost(userId)

Manually lock a user account. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 

try {
    api.mahasangrahaApiV1UsersUsersUserIdLockPost(userId);
} on DioException catch (e) {
    print('Exception when calling UserApi->mahasangrahaApiV1UsersUsersUserIdLockPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1UsersUsersUserIdPut**
> UserOut mahasangrahaApiV1UsersUsersUserIdPut(userId, body)

Update user attributes. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 
final UserUpdateSchema body = ; // UserUpdateSchema | 

try {
    final response = api.mahasangrahaApiV1UsersUsersUserIdPut(userId, body);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->mahasangrahaApiV1UsersUsersUserIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **body** | [**UserUpdateSchema**](UserUpdateSchema.md)|  | [optional] 

### Return type

[**UserOut**](UserOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1UsersUsersUserIdRolesPut**
> UserOut mahasangrahaApiV1UsersUsersUserIdRolesPut(userId)

Update user roles. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 

try {
    final response = api.mahasangrahaApiV1UsersUsersUserIdRolesPut(userId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->mahasangrahaApiV1UsersUsersUserIdRolesPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

[**UserOut**](UserOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1UsersUsersUserIdUnlockPost**
> mahasangrahaApiV1UsersUsersUserIdUnlockPost(userId)

Manually unlock a user account. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 

try {
    api.mahasangrahaApiV1UsersUsersUserIdUnlockPost(userId);
} on DioException catch (e) {
    print('Exception when calling UserApi->mahasangrahaApiV1UsersUsersUserIdUnlockPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


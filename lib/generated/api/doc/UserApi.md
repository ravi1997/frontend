# ridp_api.api.UserApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1UserChangePasswordPost**](UserApi.md#formapiv1userchangepasswordpost) | **POST** /form/api/v1/user/change-password | Securely change current user&#39;s password.
[**formApiV1UserProfileGet**](UserApi.md#formapiv1userprofileget) | **GET** /form/api/v1/user/profile | Return currently authenticated user&#39;s profile.
[**formApiV1UserSecurityLockStatusUserIdGet**](UserApi.md#formapiv1usersecuritylockstatususeridget) | **GET** /form/api/v1/user/security/lock-status/{user_id} | Get account lock status for a specific user. Admin only.
[**formApiV1UserStatusGet**](UserApi.md#formapiv1userstatusget) | **GET** /form/api/v1/user/status | Return currently authenticated user&#39;s profile.
[**formApiV1UserUsersGet**](UserApi.md#formapiv1userusersget) | **GET** /form/api/v1/user/users | List all registered users. Admin only.
[**formApiV1UserUsersPost**](UserApi.md#formapiv1useruserspost) | **POST** /form/api/v1/user/users | Provision a new user account. Admin only.
[**formApiV1UserUsersUserIdDelete**](UserApi.md#formapiv1userusersuseriddelete) | **DELETE** /form/api/v1/user/users/{user_id} | Soft-delete a user account. Superadmin only.
[**formApiV1UserUsersUserIdGet**](UserApi.md#formapiv1userusersuseridget) | **GET** /form/api/v1/user/users/{user_id} | Fetch details of a specific user. Admin only.
[**formApiV1UserUsersUserIdLockPost**](UserApi.md#formapiv1userusersuseridlockpost) | **POST** /form/api/v1/user/users/{user_id}/lock | Manually lock a user account. Admin only.
[**formApiV1UserUsersUserIdPut**](UserApi.md#formapiv1userusersuseridput) | **PUT** /form/api/v1/user/users/{user_id} | Update user attributes. Admin only.
[**formApiV1UserUsersUserIdRolesPut**](UserApi.md#formapiv1userusersuseridrolesput) | **PUT** /form/api/v1/user/users/{user_id}/roles | Update user roles. Admin only.
[**formApiV1UserUsersUserIdUnlockPost**](UserApi.md#formapiv1userusersuseridunlockpost) | **POST** /form/api/v1/user/users/{user_id}/unlock | Manually unlock a user account. Admin only.
[**formApiV1UsersChangePasswordPost**](UserApi.md#formapiv1userschangepasswordpost) | **POST** /form/api/v1/users/change-password | Securely change current user&#39;s password.
[**formApiV1UsersProfileGet**](UserApi.md#formapiv1usersprofileget) | **GET** /form/api/v1/users/profile | Return currently authenticated user&#39;s profile.
[**formApiV1UsersSecurityLockStatusUserIdGet**](UserApi.md#formapiv1userssecuritylockstatususeridget) | **GET** /form/api/v1/users/security/lock-status/{user_id} | Get account lock status for a specific user. Admin only.
[**formApiV1UsersStatusGet**](UserApi.md#formapiv1usersstatusget) | **GET** /form/api/v1/users/status | Return currently authenticated user&#39;s profile.
[**formApiV1UsersUsersGet**](UserApi.md#formapiv1usersusersget) | **GET** /form/api/v1/users/users | List all registered users. Admin only.
[**formApiV1UsersUsersPost**](UserApi.md#formapiv1usersuserspost) | **POST** /form/api/v1/users/users | Provision a new user account. Admin only.
[**formApiV1UsersUsersUserIdDelete**](UserApi.md#formapiv1usersusersuseriddelete) | **DELETE** /form/api/v1/users/users/{user_id} | Soft-delete a user account. Superadmin only.
[**formApiV1UsersUsersUserIdGet**](UserApi.md#formapiv1usersusersuseridget) | **GET** /form/api/v1/users/users/{user_id} | Fetch details of a specific user. Admin only.
[**formApiV1UsersUsersUserIdLockPost**](UserApi.md#formapiv1usersusersuseridlockpost) | **POST** /form/api/v1/users/users/{user_id}/lock | Manually lock a user account. Admin only.
[**formApiV1UsersUsersUserIdPut**](UserApi.md#formapiv1usersusersuseridput) | **PUT** /form/api/v1/users/users/{user_id} | Update user attributes. Admin only.
[**formApiV1UsersUsersUserIdRolesPut**](UserApi.md#formapiv1usersusersuseridrolesput) | **PUT** /form/api/v1/users/users/{user_id}/roles | Update user roles. Admin only.
[**formApiV1UsersUsersUserIdUnlockPost**](UserApi.md#formapiv1usersusersuseridunlockpost) | **POST** /form/api/v1/users/users/{user_id}/unlock | Manually unlock a user account. Admin only.


# **formApiV1UserChangePasswordPost**
> UserOut formApiV1UserChangePasswordPost()

Securely change current user's password.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();

try {
    final response = api.formApiV1UserChangePasswordPost();
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->formApiV1UserChangePasswordPost: $e\n');
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

# **formApiV1UserProfileGet**
> UserOut formApiV1UserProfileGet()

Return currently authenticated user's profile.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();

try {
    final response = api.formApiV1UserProfileGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->formApiV1UserProfileGet: $e\n');
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

# **formApiV1UserSecurityLockStatusUserIdGet**
> FormApiV1UserSecurityLockStatusUserIdGet200Response formApiV1UserSecurityLockStatusUserIdGet(userId)

Get account lock status for a specific user. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 

try {
    final response = api.formApiV1UserSecurityLockStatusUserIdGet(userId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->formApiV1UserSecurityLockStatusUserIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

[**FormApiV1UserSecurityLockStatusUserIdGet200Response**](FormApiV1UserSecurityLockStatusUserIdGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1UserStatusGet**
> UserOut formApiV1UserStatusGet()

Return currently authenticated user's profile.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();

try {
    final response = api.formApiV1UserStatusGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->formApiV1UserStatusGet: $e\n');
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

# **formApiV1UserUsersGet**
> UserOut formApiV1UserUsersGet()

List all registered users. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();

try {
    final response = api.formApiV1UserUsersGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->formApiV1UserUsersGet: $e\n');
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

# **formApiV1UserUsersPost**
> UserOut formApiV1UserUsersPost(body)

Provision a new user account. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final UserUpdateSchema body = ; // UserUpdateSchema | 

try {
    final response = api.formApiV1UserUsersPost(body);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->formApiV1UserUsersPost: $e\n');
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

# **formApiV1UserUsersUserIdDelete**
> formApiV1UserUsersUserIdDelete(userId)

Soft-delete a user account. Superadmin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 

try {
    api.formApiV1UserUsersUserIdDelete(userId);
} on DioException catch (e) {
    print('Exception when calling UserApi->formApiV1UserUsersUserIdDelete: $e\n');
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

# **formApiV1UserUsersUserIdGet**
> UserOut formApiV1UserUsersUserIdGet(userId)

Fetch details of a specific user. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 

try {
    final response = api.formApiV1UserUsersUserIdGet(userId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->formApiV1UserUsersUserIdGet: $e\n');
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

# **formApiV1UserUsersUserIdLockPost**
> formApiV1UserUsersUserIdLockPost(userId)

Manually lock a user account. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 

try {
    api.formApiV1UserUsersUserIdLockPost(userId);
} on DioException catch (e) {
    print('Exception when calling UserApi->formApiV1UserUsersUserIdLockPost: $e\n');
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

# **formApiV1UserUsersUserIdPut**
> UserOut formApiV1UserUsersUserIdPut(userId, body)

Update user attributes. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 
final UserUpdateSchema body = ; // UserUpdateSchema | 

try {
    final response = api.formApiV1UserUsersUserIdPut(userId, body);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->formApiV1UserUsersUserIdPut: $e\n');
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

# **formApiV1UserUsersUserIdRolesPut**
> UserOut formApiV1UserUsersUserIdRolesPut(userId)

Update user roles. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 

try {
    final response = api.formApiV1UserUsersUserIdRolesPut(userId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->formApiV1UserUsersUserIdRolesPut: $e\n');
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

# **formApiV1UserUsersUserIdUnlockPost**
> formApiV1UserUsersUserIdUnlockPost(userId)

Manually unlock a user account. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 

try {
    api.formApiV1UserUsersUserIdUnlockPost(userId);
} on DioException catch (e) {
    print('Exception when calling UserApi->formApiV1UserUsersUserIdUnlockPost: $e\n');
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

# **formApiV1UsersChangePasswordPost**
> UserOut formApiV1UsersChangePasswordPost()

Securely change current user's password.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();

try {
    final response = api.formApiV1UsersChangePasswordPost();
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->formApiV1UsersChangePasswordPost: $e\n');
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

# **formApiV1UsersProfileGet**
> UserOut formApiV1UsersProfileGet()

Return currently authenticated user's profile.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();

try {
    final response = api.formApiV1UsersProfileGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->formApiV1UsersProfileGet: $e\n');
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

# **formApiV1UsersSecurityLockStatusUserIdGet**
> FormApiV1UserSecurityLockStatusUserIdGet200Response formApiV1UsersSecurityLockStatusUserIdGet(userId)

Get account lock status for a specific user. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 

try {
    final response = api.formApiV1UsersSecurityLockStatusUserIdGet(userId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->formApiV1UsersSecurityLockStatusUserIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

[**FormApiV1UserSecurityLockStatusUserIdGet200Response**](FormApiV1UserSecurityLockStatusUserIdGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1UsersStatusGet**
> UserOut formApiV1UsersStatusGet()

Return currently authenticated user's profile.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();

try {
    final response = api.formApiV1UsersStatusGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->formApiV1UsersStatusGet: $e\n');
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

# **formApiV1UsersUsersGet**
> UserOut formApiV1UsersUsersGet()

List all registered users. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();

try {
    final response = api.formApiV1UsersUsersGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->formApiV1UsersUsersGet: $e\n');
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

# **formApiV1UsersUsersPost**
> UserOut formApiV1UsersUsersPost(body)

Provision a new user account. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final UserUpdateSchema body = ; // UserUpdateSchema | 

try {
    final response = api.formApiV1UsersUsersPost(body);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->formApiV1UsersUsersPost: $e\n');
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

# **formApiV1UsersUsersUserIdDelete**
> formApiV1UsersUsersUserIdDelete(userId)

Soft-delete a user account. Superadmin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 

try {
    api.formApiV1UsersUsersUserIdDelete(userId);
} on DioException catch (e) {
    print('Exception when calling UserApi->formApiV1UsersUsersUserIdDelete: $e\n');
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

# **formApiV1UsersUsersUserIdGet**
> UserOut formApiV1UsersUsersUserIdGet(userId)

Fetch details of a specific user. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 

try {
    final response = api.formApiV1UsersUsersUserIdGet(userId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->formApiV1UsersUsersUserIdGet: $e\n');
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

# **formApiV1UsersUsersUserIdLockPost**
> formApiV1UsersUsersUserIdLockPost(userId)

Manually lock a user account. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 

try {
    api.formApiV1UsersUsersUserIdLockPost(userId);
} on DioException catch (e) {
    print('Exception when calling UserApi->formApiV1UsersUsersUserIdLockPost: $e\n');
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

# **formApiV1UsersUsersUserIdPut**
> UserOut formApiV1UsersUsersUserIdPut(userId, body)

Update user attributes. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 
final UserUpdateSchema body = ; // UserUpdateSchema | 

try {
    final response = api.formApiV1UsersUsersUserIdPut(userId, body);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->formApiV1UsersUsersUserIdPut: $e\n');
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

# **formApiV1UsersUsersUserIdRolesPut**
> UserOut formApiV1UsersUsersUserIdRolesPut(userId)

Update user roles. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 

try {
    final response = api.formApiV1UsersUsersUserIdRolesPut(userId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UserApi->formApiV1UsersUsersUserIdRolesPut: $e\n');
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

# **formApiV1UsersUsersUserIdUnlockPost**
> formApiV1UsersUsersUserIdUnlockPost(userId)

Manually unlock a user account. Admin only.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getUserApi();
final String userId = userId_example; // String | 

try {
    api.formApiV1UsersUsersUserIdUnlockPost(userId);
} on DioException catch (e) {
    print('Exception when calling UserApi->formApiV1UsersUsersUserIdUnlockPost: $e\n');
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


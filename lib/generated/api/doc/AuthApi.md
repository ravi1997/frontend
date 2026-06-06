# ridp_api.api.AuthApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1AuthLoginPost**](AuthApi.md#mahasangrahaapiv1authloginpost) | **POST** /mahasangraha/api/v1/auth/login | Authenticate via password or OTP and issue JWT tokens.
[**mahasangrahaApiV1AuthLogoutPost**](AuthApi.md#mahasangrahaapiv1authlogoutpost) | **POST** /mahasangraha/api/v1/auth/logout | Revoke the current JWT session.
[**mahasangrahaApiV1AuthRefreshPost**](AuthApi.md#mahasangrahaapiv1authrefreshpost) | **POST** /mahasangraha/api/v1/auth/refresh | Issue a new access token using a valid refresh token.
[**mahasangrahaApiV1AuthRegisterPost**](AuthApi.md#mahasangrahaapiv1authregisterpost) | **POST** /mahasangraha/api/v1/auth/register | Register a new user account.
[**mahasangrahaApiV1AuthRequestOtpPost**](AuthApi.md#mahasangrahaapiv1authrequestotppost) | **POST** /mahasangraha/api/v1/auth/request-otp | Generate and send an OTP to the given mobile/email.
[**mahasangrahaApiV1AuthRevokeAllPost**](AuthApi.md#mahasangrahaapiv1authrevokeallpost) | **POST** /mahasangraha/api/v1/auth/revoke-all | Revoke all active sessions for the authenticated user.


# **mahasangrahaApiV1AuthLoginPost**
> MahasangrahaApiV1AuthLoginPost200Response mahasangrahaApiV1AuthLoginPost(body)

Authenticate via password or OTP and issue JWT tokens.

Authenticate via password or OTP and issue JWT tokens.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAuthApi();
final LoginRequest body = ; // LoginRequest | 

try {
    final response = api.mahasangrahaApiV1AuthLoginPost(body);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->mahasangrahaApiV1AuthLoginPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**LoginRequest**](LoginRequest.md)|  | 

### Return type

[**MahasangrahaApiV1AuthLoginPost200Response**](MahasangrahaApiV1AuthLoginPost200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1AuthLogoutPost**
> mahasangrahaApiV1AuthLogoutPost()

Revoke the current JWT session.

Revokes the user's access and refresh tokens.

### Example
```dart
import 'package:ridp_api/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api = RidpApi().getAuthApi();

try {
    api.mahasangrahaApiV1AuthLogoutPost();
} on DioException catch (e) {
    print('Exception when calling AuthApi->mahasangrahaApiV1AuthLogoutPost: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1AuthRefreshPost**
> MahasangrahaApiV1AuthRefreshPost200Response mahasangrahaApiV1AuthRefreshPost()

Issue a new access token using a valid refresh token.

Generates a new access token using a valid refresh token.

### Example
```dart
import 'package:ridp_api/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api = RidpApi().getAuthApi();

try {
    final response = api.mahasangrahaApiV1AuthRefreshPost();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->mahasangrahaApiV1AuthRefreshPost: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**MahasangrahaApiV1AuthRefreshPost200Response**](MahasangrahaApiV1AuthRefreshPost200Response.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1AuthRegisterPost**
> UserOut mahasangrahaApiV1AuthRegisterPost(body)

Register a new user account.

Registers a new user and returns user details.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAuthApi();
final UserCreateSchema body = ; // UserCreateSchema | 

try {
    final response = api.mahasangrahaApiV1AuthRegisterPost(body);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->mahasangrahaApiV1AuthRegisterPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**UserCreateSchema**](UserCreateSchema.md)|  | 

### Return type

[**UserOut**](UserOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1AuthRequestOtpPost**
> mahasangrahaApiV1AuthRequestOtpPost(body)

Generate and send an OTP to the given mobile/email.

Generate and send an OTP to the given mobile/email.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAuthApi();
final MahasangrahaApiV1AuthRequestOtpPostRequest body = ; // MahasangrahaApiV1AuthRequestOtpPostRequest | 

try {
    api.mahasangrahaApiV1AuthRequestOtpPost(body);
} on DioException catch (e) {
    print('Exception when calling AuthApi->mahasangrahaApiV1AuthRequestOtpPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**MahasangrahaApiV1AuthRequestOtpPostRequest**](MahasangrahaApiV1AuthRequestOtpPostRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1AuthRevokeAllPost**
> mahasangrahaApiV1AuthRevokeAllPost()

Revoke all active sessions for the authenticated user.

Revokes all active JWT sessions for the authenticated user.

### Example
```dart
import 'package:ridp_api/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api = RidpApi().getAuthApi();

try {
    api.mahasangrahaApiV1AuthRevokeAllPost();
} on DioException catch (e) {
    print('Exception when calling AuthApi->mahasangrahaApiV1AuthRevokeAllPost: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


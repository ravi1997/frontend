# ridp_api.api.SmsApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1SmsHealthGet**](SmsApi.md#formapiv1smshealthget) | **GET** /form/api/v1/sms/health | Verify SMS provider connectivity.
[**formApiV1SmsNotifyPost**](SmsApi.md#formapiv1smsnotifypost) | **POST** /form/api/v1/sms/notify | Send triggered notifications.
[**formApiV1SmsOtpPost**](SmsApi.md#formapiv1smsotppost) | **POST** /form/api/v1/sms/otp | Manually send an OTP. Restrict to admins to prevent spam.
[**formApiV1SmsSinglePost**](SmsApi.md#formapiv1smssinglepost) | **POST** /form/api/v1/sms/single | Forward a single SMS request to the external provider.


# **formApiV1SmsHealthGet**
> formApiV1SmsHealthGet()

Verify SMS provider connectivity.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getSmsApi();

try {
    api.formApiV1SmsHealthGet();
} catch on DioError (e) {
    print('Exception when calling SmsApi->formApiV1SmsHealthGet: $e\n');
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

# **formApiV1SmsNotifyPost**
> formApiV1SmsNotifyPost()

Send triggered notifications.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getSmsApi();

try {
    api.formApiV1SmsNotifyPost();
} catch on DioError (e) {
    print('Exception when calling SmsApi->formApiV1SmsNotifyPost: $e\n');
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

# **formApiV1SmsOtpPost**
> formApiV1SmsOtpPost()

Manually send an OTP. Restrict to admins to prevent spam.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getSmsApi();

try {
    api.formApiV1SmsOtpPost();
} catch on DioError (e) {
    print('Exception when calling SmsApi->formApiV1SmsOtpPost: $e\n');
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

# **formApiV1SmsSinglePost**
> formApiV1SmsSinglePost()

Forward a single SMS request to the external provider.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getSmsApi();

try {
    api.formApiV1SmsSinglePost();
} catch on DioError (e) {
    print('Exception when calling SmsApi->formApiV1SmsSinglePost: $e\n');
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


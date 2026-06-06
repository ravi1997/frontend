# ridp_api.api.SmsApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1SmsHealthGet**](SmsApi.md#mahasangrahaapiv1smshealthget) | **GET** /mahasangraha/api/v1/sms/health | Verify SMS provider connectivity.
[**mahasangrahaApiV1SmsNotifyPost**](SmsApi.md#mahasangrahaapiv1smsnotifypost) | **POST** /mahasangraha/api/v1/sms/notify | Send triggered notifications.
[**mahasangrahaApiV1SmsOtpPost**](SmsApi.md#mahasangrahaapiv1smsotppost) | **POST** /mahasangraha/api/v1/sms/otp | Manually send an OTP. Restrict to admins to prevent spam.
[**mahasangrahaApiV1SmsSinglePost**](SmsApi.md#mahasangrahaapiv1smssinglepost) | **POST** /mahasangraha/api/v1/sms/single | Forward a single SMS request to the external provider.


# **mahasangrahaApiV1SmsHealthGet**
> mahasangrahaApiV1SmsHealthGet()

Verify SMS provider connectivity.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getSmsApi();

try {
    api.mahasangrahaApiV1SmsHealthGet();
} on DioException catch (e) {
    print('Exception when calling SmsApi->mahasangrahaApiV1SmsHealthGet: $e\n');
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

# **mahasangrahaApiV1SmsNotifyPost**
> mahasangrahaApiV1SmsNotifyPost()

Send triggered notifications.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getSmsApi();

try {
    api.mahasangrahaApiV1SmsNotifyPost();
} on DioException catch (e) {
    print('Exception when calling SmsApi->mahasangrahaApiV1SmsNotifyPost: $e\n');
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

# **mahasangrahaApiV1SmsOtpPost**
> mahasangrahaApiV1SmsOtpPost()

Manually send an OTP. Restrict to admins to prevent spam.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getSmsApi();

try {
    api.mahasangrahaApiV1SmsOtpPost();
} on DioException catch (e) {
    print('Exception when calling SmsApi->mahasangrahaApiV1SmsOtpPost: $e\n');
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

# **mahasangrahaApiV1SmsSinglePost**
> mahasangrahaApiV1SmsSinglePost()

Forward a single SMS request to the external provider.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getSmsApi();

try {
    api.mahasangrahaApiV1SmsSinglePost();
} on DioException catch (e) {
    print('Exception when calling SmsApi->mahasangrahaApiV1SmsSinglePost: $e\n');
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


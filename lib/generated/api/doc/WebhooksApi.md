# ridp_api.api.WebhooksApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1WebhooksDeliverPost**](WebhooksApi.md#mahasangrahaapiv1webhooksdeliverpost) | **POST** /mahasangraha/api/v1/webhooks/deliver | Trigger webhook delivery. Restricted to managers and above.
[**mahasangrahaApiV1WebhooksDeliveryIdCancelDelete**](WebhooksApi.md#mahasangrahaapiv1webhooksdeliveryidcanceldelete) | **DELETE** /mahasangraha/api/v1/webhooks/{delivery_id}/cancel | Admin only: Cancel a pending/retrying delivery.
[**mahasangrahaApiV1WebhooksDeliveryIdHistoryGet**](WebhooksApi.md#mahasangrahaapiv1webhooksdeliveryidhistoryget) | **GET** /mahasangraha/api/v1/webhooks/{delivery_id}/history | View system-wide or specific delivery history. Manager restricted.
[**mahasangrahaApiV1WebhooksDeliveryIdRetryPost**](WebhooksApi.md#mahasangrahaapiv1webhooksdeliveryidretrypost) | **POST** /mahasangraha/api/v1/webhooks/{delivery_id}/retry | Admin only: Manually retry a failed delivery.
[**mahasangrahaApiV1WebhooksDeliveryIdStatusGet**](WebhooksApi.md#mahasangrahaapiv1webhooksdeliveryidstatusget) | **GET** /mahasangraha/api/v1/webhooks/{delivery_id}/status | View status of a specific delivery.
[**mahasangrahaApiV1WebhooksHistoryGet**](WebhooksApi.md#mahasangrahaapiv1webhookshistoryget) | **GET** /mahasangraha/api/v1/webhooks/history | View system-wide or specific delivery history. Manager restricted.
[**mahasangrahaApiV1WebhooksLogsGet**](WebhooksApi.md#mahasangrahaapiv1webhookslogsget) | **GET** /mahasangraha/api/v1/webhooks/logs | Admin only: Retrieve low-level delivery logs.
[**mahasangrahaApiV1WebhooksTestPost**](WebhooksApi.md#mahasangrahaapiv1webhookstestpost) | **POST** /mahasangraha/api/v1/webhooks/test | Admin only: Test webhook delivery to a specific URL.


# **mahasangrahaApiV1WebhooksDeliverPost**
> mahasangrahaApiV1WebhooksDeliverPost()

Trigger webhook delivery. Restricted to managers and above.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWebhooksApi();

try {
    api.mahasangrahaApiV1WebhooksDeliverPost();
} on DioException catch (e) {
    print('Exception when calling WebhooksApi->mahasangrahaApiV1WebhooksDeliverPost: $e\n');
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

# **mahasangrahaApiV1WebhooksDeliveryIdCancelDelete**
> mahasangrahaApiV1WebhooksDeliveryIdCancelDelete(deliveryId)

Admin only: Cancel a pending/retrying delivery.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWebhooksApi();
final String deliveryId = deliveryId_example; // String | 

try {
    api.mahasangrahaApiV1WebhooksDeliveryIdCancelDelete(deliveryId);
} on DioException catch (e) {
    print('Exception when calling WebhooksApi->mahasangrahaApiV1WebhooksDeliveryIdCancelDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deliveryId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1WebhooksDeliveryIdHistoryGet**
> mahasangrahaApiV1WebhooksDeliveryIdHistoryGet()

View system-wide or specific delivery history. Manager restricted.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWebhooksApi();

try {
    api.mahasangrahaApiV1WebhooksDeliveryIdHistoryGet();
} on DioException catch (e) {
    print('Exception when calling WebhooksApi->mahasangrahaApiV1WebhooksDeliveryIdHistoryGet: $e\n');
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

# **mahasangrahaApiV1WebhooksDeliveryIdRetryPost**
> mahasangrahaApiV1WebhooksDeliveryIdRetryPost(deliveryId)

Admin only: Manually retry a failed delivery.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWebhooksApi();
final String deliveryId = deliveryId_example; // String | 

try {
    api.mahasangrahaApiV1WebhooksDeliveryIdRetryPost(deliveryId);
} on DioException catch (e) {
    print('Exception when calling WebhooksApi->mahasangrahaApiV1WebhooksDeliveryIdRetryPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deliveryId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1WebhooksDeliveryIdStatusGet**
> mahasangrahaApiV1WebhooksDeliveryIdStatusGet(deliveryId)

View status of a specific delivery.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWebhooksApi();
final String deliveryId = deliveryId_example; // String | 

try {
    api.mahasangrahaApiV1WebhooksDeliveryIdStatusGet(deliveryId);
} on DioException catch (e) {
    print('Exception when calling WebhooksApi->mahasangrahaApiV1WebhooksDeliveryIdStatusGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deliveryId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1WebhooksHistoryGet**
> mahasangrahaApiV1WebhooksHistoryGet()

View system-wide or specific delivery history. Manager restricted.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWebhooksApi();

try {
    api.mahasangrahaApiV1WebhooksHistoryGet();
} on DioException catch (e) {
    print('Exception when calling WebhooksApi->mahasangrahaApiV1WebhooksHistoryGet: $e\n');
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

# **mahasangrahaApiV1WebhooksLogsGet**
> mahasangrahaApiV1WebhooksLogsGet()

Admin only: Retrieve low-level delivery logs.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWebhooksApi();

try {
    api.mahasangrahaApiV1WebhooksLogsGet();
} on DioException catch (e) {
    print('Exception when calling WebhooksApi->mahasangrahaApiV1WebhooksLogsGet: $e\n');
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

# **mahasangrahaApiV1WebhooksTestPost**
> mahasangrahaApiV1WebhooksTestPost()

Admin only: Test webhook delivery to a specific URL.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWebhooksApi();

try {
    api.mahasangrahaApiV1WebhooksTestPost();
} on DioException catch (e) {
    print('Exception when calling WebhooksApi->mahasangrahaApiV1WebhooksTestPost: $e\n');
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


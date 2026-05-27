# ridp_api.api.WebhooksApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1WebhooksDeliverPost**](WebhooksApi.md#formapiv1webhooksdeliverpost) | **POST** /form/api/v1/webhooks/deliver | Trigger webhook delivery. Restricted to managers and above.
[**formApiV1WebhooksDeliveryIdCancelDelete**](WebhooksApi.md#formapiv1webhooksdeliveryidcanceldelete) | **DELETE** /form/api/v1/webhooks/{delivery_id}/cancel | Admin only: Cancel a pending/retrying delivery.
[**formApiV1WebhooksDeliveryIdHistoryGet**](WebhooksApi.md#formapiv1webhooksdeliveryidhistoryget) | **GET** /form/api/v1/webhooks/{delivery_id}/history | View system-wide or specific delivery history. Manager restricted.
[**formApiV1WebhooksDeliveryIdRetryPost**](WebhooksApi.md#formapiv1webhooksdeliveryidretrypost) | **POST** /form/api/v1/webhooks/{delivery_id}/retry | Admin only: Manually retry a failed delivery.
[**formApiV1WebhooksDeliveryIdStatusGet**](WebhooksApi.md#formapiv1webhooksdeliveryidstatusget) | **GET** /form/api/v1/webhooks/{delivery_id}/status | View status of a specific delivery.
[**formApiV1WebhooksHistoryGet**](WebhooksApi.md#formapiv1webhookshistoryget) | **GET** /form/api/v1/webhooks/history | View system-wide or specific delivery history. Manager restricted.
[**formApiV1WebhooksLogsGet**](WebhooksApi.md#formapiv1webhookslogsget) | **GET** /form/api/v1/webhooks/logs | Admin only: Retrieve low-level delivery logs.
[**formApiV1WebhooksTestPost**](WebhooksApi.md#formapiv1webhookstestpost) | **POST** /form/api/v1/webhooks/test | Admin only: Test webhook delivery to a specific URL.


# **formApiV1WebhooksDeliverPost**
> formApiV1WebhooksDeliverPost()

Trigger webhook delivery. Restricted to managers and above.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWebhooksApi();

try {
    api.formApiV1WebhooksDeliverPost();
} on DioException catch (e) {
    print('Exception when calling WebhooksApi->formApiV1WebhooksDeliverPost: $e\n');
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

# **formApiV1WebhooksDeliveryIdCancelDelete**
> formApiV1WebhooksDeliveryIdCancelDelete(deliveryId)

Admin only: Cancel a pending/retrying delivery.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWebhooksApi();
final String deliveryId = deliveryId_example; // String | 

try {
    api.formApiV1WebhooksDeliveryIdCancelDelete(deliveryId);
} on DioException catch (e) {
    print('Exception when calling WebhooksApi->formApiV1WebhooksDeliveryIdCancelDelete: $e\n');
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

# **formApiV1WebhooksDeliveryIdHistoryGet**
> formApiV1WebhooksDeliveryIdHistoryGet()

View system-wide or specific delivery history. Manager restricted.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWebhooksApi();

try {
    api.formApiV1WebhooksDeliveryIdHistoryGet();
} on DioException catch (e) {
    print('Exception when calling WebhooksApi->formApiV1WebhooksDeliveryIdHistoryGet: $e\n');
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

# **formApiV1WebhooksDeliveryIdRetryPost**
> formApiV1WebhooksDeliveryIdRetryPost(deliveryId)

Admin only: Manually retry a failed delivery.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWebhooksApi();
final String deliveryId = deliveryId_example; // String | 

try {
    api.formApiV1WebhooksDeliveryIdRetryPost(deliveryId);
} on DioException catch (e) {
    print('Exception when calling WebhooksApi->formApiV1WebhooksDeliveryIdRetryPost: $e\n');
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

# **formApiV1WebhooksDeliveryIdStatusGet**
> formApiV1WebhooksDeliveryIdStatusGet(deliveryId)

View status of a specific delivery.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWebhooksApi();
final String deliveryId = deliveryId_example; // String | 

try {
    api.formApiV1WebhooksDeliveryIdStatusGet(deliveryId);
} on DioException catch (e) {
    print('Exception when calling WebhooksApi->formApiV1WebhooksDeliveryIdStatusGet: $e\n');
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

# **formApiV1WebhooksHistoryGet**
> formApiV1WebhooksHistoryGet()

View system-wide or specific delivery history. Manager restricted.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWebhooksApi();

try {
    api.formApiV1WebhooksHistoryGet();
} on DioException catch (e) {
    print('Exception when calling WebhooksApi->formApiV1WebhooksHistoryGet: $e\n');
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

# **formApiV1WebhooksLogsGet**
> formApiV1WebhooksLogsGet()

Admin only: Retrieve low-level delivery logs.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWebhooksApi();

try {
    api.formApiV1WebhooksLogsGet();
} on DioException catch (e) {
    print('Exception when calling WebhooksApi->formApiV1WebhooksLogsGet: $e\n');
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

# **formApiV1WebhooksTestPost**
> formApiV1WebhooksTestPost()

Admin only: Test webhook delivery to a specific URL.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getWebhooksApi();

try {
    api.formApiV1WebhooksTestPost();
} on DioException catch (e) {
    print('Exception when calling WebhooksApi->formApiV1WebhooksTestPost: $e\n');
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


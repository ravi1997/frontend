# ridp_api.api.AIOpsApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1AdminAiOpsLoraImprovePost**](AIOpsApi.md#mahasangrahaapiv1adminaiopsloraimprovepost) | **POST** /mahasangraha/api/v1/admin/ai-ops/lora/improve | Trigger the LoRA dataset building, validation, and training loop asynchronously.
[**mahasangrahaApiV1AdminAiOpsLoraStatusGet**](AIOpsApi.md#mahasangrahaapiv1adminaiopslorastatusget) | **GET** /mahasangraha/api/v1/admin/ai-ops/lora/status | Retrieve current pipeline cycles, last execution timing, and performance scores.


# **mahasangrahaApiV1AdminAiOpsLoraImprovePost**
> mahasangrahaApiV1AdminAiOpsLoraImprovePost(body)

Trigger the LoRA dataset building, validation, and training loop asynchronously.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAIOpsApi();
final MahasangrahaApiV1AdminAiOpsLoraImprovePostRequest body = ; // MahasangrahaApiV1AdminAiOpsLoraImprovePostRequest | 

try {
    api.mahasangrahaApiV1AdminAiOpsLoraImprovePost(body);
} on DioException catch (e) {
    print('Exception when calling AIOpsApi->mahasangrahaApiV1AdminAiOpsLoraImprovePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**MahasangrahaApiV1AdminAiOpsLoraImprovePostRequest**](MahasangrahaApiV1AdminAiOpsLoraImprovePostRequest.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1AdminAiOpsLoraStatusGet**
> mahasangrahaApiV1AdminAiOpsLoraStatusGet()

Retrieve current pipeline cycles, last execution timing, and performance scores.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAIOpsApi();

try {
    api.mahasangrahaApiV1AdminAiOpsLoraStatusGet();
} on DioException catch (e) {
    print('Exception when calling AIOpsApi->mahasangrahaApiV1AdminAiOpsLoraStatusGet: $e\n');
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


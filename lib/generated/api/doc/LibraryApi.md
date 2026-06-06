# ridp_api.api.LibraryApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1CustomFieldsGet**](LibraryApi.md#mahasangrahaapiv1customfieldsget) | **GET** /mahasangraha/api/v1/custom-fields/ | 
[**mahasangrahaApiV1CustomFieldsPost**](LibraryApi.md#mahasangrahaapiv1customfieldspost) | **POST** /mahasangraha/api/v1/custom-fields/ | 
[**mahasangrahaApiV1CustomFieldsTemplateIdDelete**](LibraryApi.md#mahasangrahaapiv1customfieldstemplateiddelete) | **DELETE** /mahasangraha/api/v1/custom-fields/{template_id} | 
[**mahasangrahaApiV1CustomFieldsTemplateIdGet**](LibraryApi.md#mahasangrahaapiv1customfieldstemplateidget) | **GET** /mahasangraha/api/v1/custom-fields/{template_id} | 
[**mahasangrahaApiV1TemplatesGet**](LibraryApi.md#mahasangrahaapiv1templatesget) | **GET** /mahasangraha/api/v1/templates/ | 
[**mahasangrahaApiV1TemplatesPost**](LibraryApi.md#mahasangrahaapiv1templatespost) | **POST** /mahasangraha/api/v1/templates/ | 
[**mahasangrahaApiV1TemplatesTemplateIdDelete**](LibraryApi.md#mahasangrahaapiv1templatestemplateiddelete) | **DELETE** /mahasangraha/api/v1/templates/{template_id} | 
[**mahasangrahaApiV1TemplatesTemplateIdGet**](LibraryApi.md#mahasangrahaapiv1templatestemplateidget) | **GET** /mahasangraha/api/v1/templates/{template_id} | 


# **mahasangrahaApiV1CustomFieldsGet**
> mahasangrahaApiV1CustomFieldsGet()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getLibraryApi();

try {
    api.mahasangrahaApiV1CustomFieldsGet();
} on DioException catch (e) {
    print('Exception when calling LibraryApi->mahasangrahaApiV1CustomFieldsGet: $e\n');
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

# **mahasangrahaApiV1CustomFieldsPost**
> mahasangrahaApiV1CustomFieldsPost()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getLibraryApi();

try {
    api.mahasangrahaApiV1CustomFieldsPost();
} on DioException catch (e) {
    print('Exception when calling LibraryApi->mahasangrahaApiV1CustomFieldsPost: $e\n');
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

# **mahasangrahaApiV1CustomFieldsTemplateIdDelete**
> mahasangrahaApiV1CustomFieldsTemplateIdDelete(templateId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getLibraryApi();
final String templateId = templateId_example; // String | 

try {
    api.mahasangrahaApiV1CustomFieldsTemplateIdDelete(templateId);
} on DioException catch (e) {
    print('Exception when calling LibraryApi->mahasangrahaApiV1CustomFieldsTemplateIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **templateId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1CustomFieldsTemplateIdGet**
> mahasangrahaApiV1CustomFieldsTemplateIdGet(templateId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getLibraryApi();
final String templateId = templateId_example; // String | 

try {
    api.mahasangrahaApiV1CustomFieldsTemplateIdGet(templateId);
} on DioException catch (e) {
    print('Exception when calling LibraryApi->mahasangrahaApiV1CustomFieldsTemplateIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **templateId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1TemplatesGet**
> mahasangrahaApiV1TemplatesGet()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getLibraryApi();

try {
    api.mahasangrahaApiV1TemplatesGet();
} on DioException catch (e) {
    print('Exception when calling LibraryApi->mahasangrahaApiV1TemplatesGet: $e\n');
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

# **mahasangrahaApiV1TemplatesPost**
> mahasangrahaApiV1TemplatesPost()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getLibraryApi();

try {
    api.mahasangrahaApiV1TemplatesPost();
} on DioException catch (e) {
    print('Exception when calling LibraryApi->mahasangrahaApiV1TemplatesPost: $e\n');
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

# **mahasangrahaApiV1TemplatesTemplateIdDelete**
> mahasangrahaApiV1TemplatesTemplateIdDelete(templateId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getLibraryApi();
final String templateId = templateId_example; // String | 

try {
    api.mahasangrahaApiV1TemplatesTemplateIdDelete(templateId);
} on DioException catch (e) {
    print('Exception when calling LibraryApi->mahasangrahaApiV1TemplatesTemplateIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **templateId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1TemplatesTemplateIdGet**
> mahasangrahaApiV1TemplatesTemplateIdGet(templateId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getLibraryApi();
final String templateId = templateId_example; // String | 

try {
    api.mahasangrahaApiV1TemplatesTemplateIdGet(templateId);
} on DioException catch (e) {
    print('Exception when calling LibraryApi->mahasangrahaApiV1TemplatesTemplateIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **templateId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


# ridp_api.api.LibraryApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1CustomFieldsGet**](LibraryApi.md#formapiv1customfieldsget) | **GET** /form/api/v1/custom-fields/ | 
[**formApiV1CustomFieldsPost**](LibraryApi.md#formapiv1customfieldspost) | **POST** /form/api/v1/custom-fields/ | 
[**formApiV1CustomFieldsTemplateIdDelete**](LibraryApi.md#formapiv1customfieldstemplateiddelete) | **DELETE** /form/api/v1/custom-fields/{template_id} | 
[**formApiV1CustomFieldsTemplateIdGet**](LibraryApi.md#formapiv1customfieldstemplateidget) | **GET** /form/api/v1/custom-fields/{template_id} | 
[**formApiV1TemplatesGet**](LibraryApi.md#formapiv1templatesget) | **GET** /form/api/v1/templates/ | 
[**formApiV1TemplatesPost**](LibraryApi.md#formapiv1templatespost) | **POST** /form/api/v1/templates/ | 
[**formApiV1TemplatesTemplateIdDelete**](LibraryApi.md#formapiv1templatestemplateiddelete) | **DELETE** /form/api/v1/templates/{template_id} | 
[**formApiV1TemplatesTemplateIdGet**](LibraryApi.md#formapiv1templatestemplateidget) | **GET** /form/api/v1/templates/{template_id} | 


# **formApiV1CustomFieldsGet**
> formApiV1CustomFieldsGet()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getLibraryApi();

try {
    api.formApiV1CustomFieldsGet();
} on DioException catch (e) {
    print('Exception when calling LibraryApi->formApiV1CustomFieldsGet: $e\n');
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

# **formApiV1CustomFieldsPost**
> formApiV1CustomFieldsPost()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getLibraryApi();

try {
    api.formApiV1CustomFieldsPost();
} on DioException catch (e) {
    print('Exception when calling LibraryApi->formApiV1CustomFieldsPost: $e\n');
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

# **formApiV1CustomFieldsTemplateIdDelete**
> formApiV1CustomFieldsTemplateIdDelete(templateId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getLibraryApi();
final String templateId = templateId_example; // String | 

try {
    api.formApiV1CustomFieldsTemplateIdDelete(templateId);
} on DioException catch (e) {
    print('Exception when calling LibraryApi->formApiV1CustomFieldsTemplateIdDelete: $e\n');
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

# **formApiV1CustomFieldsTemplateIdGet**
> formApiV1CustomFieldsTemplateIdGet(templateId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getLibraryApi();
final String templateId = templateId_example; // String | 

try {
    api.formApiV1CustomFieldsTemplateIdGet(templateId);
} on DioException catch (e) {
    print('Exception when calling LibraryApi->formApiV1CustomFieldsTemplateIdGet: $e\n');
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

# **formApiV1TemplatesGet**
> formApiV1TemplatesGet()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getLibraryApi();

try {
    api.formApiV1TemplatesGet();
} on DioException catch (e) {
    print('Exception when calling LibraryApi->formApiV1TemplatesGet: $e\n');
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

# **formApiV1TemplatesPost**
> formApiV1TemplatesPost()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getLibraryApi();

try {
    api.formApiV1TemplatesPost();
} on DioException catch (e) {
    print('Exception when calling LibraryApi->formApiV1TemplatesPost: $e\n');
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

# **formApiV1TemplatesTemplateIdDelete**
> formApiV1TemplatesTemplateIdDelete(templateId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getLibraryApi();
final String templateId = templateId_example; // String | 

try {
    api.formApiV1TemplatesTemplateIdDelete(templateId);
} on DioException catch (e) {
    print('Exception when calling LibraryApi->formApiV1TemplatesTemplateIdDelete: $e\n');
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

# **formApiV1TemplatesTemplateIdGet**
> formApiV1TemplatesTemplateIdGet(templateId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getLibraryApi();
final String templateId = templateId_example; // String | 

try {
    api.formApiV1TemplatesTemplateIdGet(templateId);
} on DioException catch (e) {
    print('Exception when calling LibraryApi->formApiV1TemplatesTemplateIdGet: $e\n');
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


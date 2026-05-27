# ridp_api.api.TranslationApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1FormsTranslationsGet**](TranslationApi.md#formapiv1formstranslationsget) | **GET** /form/api/v1/forms/translations | 
[**formApiV1FormsTranslationsJobsGet**](TranslationApi.md#formapiv1formstranslationsjobsget) | **GET** /form/api/v1/forms/translations/jobs | 
[**formApiV1FormsTranslationsJobsJobIdCancelPatch**](TranslationApi.md#formapiv1formstranslationsjobsjobidcancelpatch) | **PATCH** /form/api/v1/forms/translations/jobs/{job_id}/cancel | 
[**formApiV1FormsTranslationsJobsJobIdContentGet**](TranslationApi.md#formapiv1formstranslationsjobsjobidcontentget) | **GET** /form/api/v1/forms/translations/jobs/{job_id}/content | 
[**formApiV1FormsTranslationsJobsJobIdDelete**](TranslationApi.md#formapiv1formstranslationsjobsjobiddelete) | **DELETE** /form/api/v1/forms/translations/jobs/{job_id} | 
[**formApiV1FormsTranslationsJobsJobIdGet**](TranslationApi.md#formapiv1formstranslationsjobsjobidget) | **GET** /form/api/v1/forms/translations/jobs/{job_id} | 
[**formApiV1FormsTranslationsJobsPost**](TranslationApi.md#formapiv1formstranslationsjobspost) | **POST** /form/api/v1/forms/translations/jobs | 
[**formApiV1FormsTranslationsLanguagesGet**](TranslationApi.md#formapiv1formstranslationslanguagesget) | **GET** /form/api/v1/forms/translations/languages | 
[**formApiV1FormsTranslationsPost**](TranslationApi.md#formapiv1formstranslationspost) | **POST** /form/api/v1/forms/translations | 
[**formApiV1FormsTranslationsPreviewPost**](TranslationApi.md#formapiv1formstranslationspreviewpost) | **POST** /form/api/v1/forms/translations/preview | 


# **formApiV1FormsTranslationsGet**
> formApiV1FormsTranslationsGet()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getTranslationApi();

try {
    api.formApiV1FormsTranslationsGet();
} on DioException catch (e) {
    print('Exception when calling TranslationApi->formApiV1FormsTranslationsGet: $e\n');
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

# **formApiV1FormsTranslationsJobsGet**
> formApiV1FormsTranslationsJobsGet()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getTranslationApi();

try {
    api.formApiV1FormsTranslationsJobsGet();
} on DioException catch (e) {
    print('Exception when calling TranslationApi->formApiV1FormsTranslationsJobsGet: $e\n');
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

# **formApiV1FormsTranslationsJobsJobIdCancelPatch**
> formApiV1FormsTranslationsJobsJobIdCancelPatch(jobId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getTranslationApi();
final String jobId = jobId_example; // String | 

try {
    api.formApiV1FormsTranslationsJobsJobIdCancelPatch(jobId);
} on DioException catch (e) {
    print('Exception when calling TranslationApi->formApiV1FormsTranslationsJobsJobIdCancelPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **jobId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsTranslationsJobsJobIdContentGet**
> formApiV1FormsTranslationsJobsJobIdContentGet(jobId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getTranslationApi();
final String jobId = jobId_example; // String | 

try {
    api.formApiV1FormsTranslationsJobsJobIdContentGet(jobId);
} on DioException catch (e) {
    print('Exception when calling TranslationApi->formApiV1FormsTranslationsJobsJobIdContentGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **jobId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsTranslationsJobsJobIdDelete**
> formApiV1FormsTranslationsJobsJobIdDelete(jobId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getTranslationApi();
final String jobId = jobId_example; // String | 

try {
    api.formApiV1FormsTranslationsJobsJobIdDelete(jobId);
} on DioException catch (e) {
    print('Exception when calling TranslationApi->formApiV1FormsTranslationsJobsJobIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **jobId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsTranslationsJobsJobIdGet**
> formApiV1FormsTranslationsJobsJobIdGet(jobId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getTranslationApi();
final String jobId = jobId_example; // String | 

try {
    api.formApiV1FormsTranslationsJobsJobIdGet(jobId);
} on DioException catch (e) {
    print('Exception when calling TranslationApi->formApiV1FormsTranslationsJobsJobIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **jobId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1FormsTranslationsJobsPost**
> formApiV1FormsTranslationsJobsPost()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getTranslationApi();

try {
    api.formApiV1FormsTranslationsJobsPost();
} on DioException catch (e) {
    print('Exception when calling TranslationApi->formApiV1FormsTranslationsJobsPost: $e\n');
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

# **formApiV1FormsTranslationsLanguagesGet**
> formApiV1FormsTranslationsLanguagesGet()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getTranslationApi();

try {
    api.formApiV1FormsTranslationsLanguagesGet();
} on DioException catch (e) {
    print('Exception when calling TranslationApi->formApiV1FormsTranslationsLanguagesGet: $e\n');
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

# **formApiV1FormsTranslationsPost**
> formApiV1FormsTranslationsPost()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getTranslationApi();

try {
    api.formApiV1FormsTranslationsPost();
} on DioException catch (e) {
    print('Exception when calling TranslationApi->formApiV1FormsTranslationsPost: $e\n');
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

# **formApiV1FormsTranslationsPreviewPost**
> formApiV1FormsTranslationsPreviewPost()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getTranslationApi();

try {
    api.formApiV1FormsTranslationsPreviewPost();
} on DioException catch (e) {
    print('Exception when calling TranslationApi->formApiV1FormsTranslationsPreviewPost: $e\n');
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


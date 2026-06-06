# ridp_api.api.TranslationApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1TranslationsGet**](TranslationApi.md#mahasangrahaapiv1translationsget) | **GET** /mahasangraha/api/v1/translations | 
[**mahasangrahaApiV1TranslationsJobsGet**](TranslationApi.md#mahasangrahaapiv1translationsjobsget) | **GET** /mahasangraha/api/v1/translations/jobs | 
[**mahasangrahaApiV1TranslationsJobsJobIdCancelPatch**](TranslationApi.md#mahasangrahaapiv1translationsjobsjobidcancelpatch) | **PATCH** /mahasangraha/api/v1/translations/jobs/{job_id}/cancel | 
[**mahasangrahaApiV1TranslationsJobsJobIdContentGet**](TranslationApi.md#mahasangrahaapiv1translationsjobsjobidcontentget) | **GET** /mahasangraha/api/v1/translations/jobs/{job_id}/content | 
[**mahasangrahaApiV1TranslationsJobsJobIdDelete**](TranslationApi.md#mahasangrahaapiv1translationsjobsjobiddelete) | **DELETE** /mahasangraha/api/v1/translations/jobs/{job_id} | 
[**mahasangrahaApiV1TranslationsJobsJobIdGet**](TranslationApi.md#mahasangrahaapiv1translationsjobsjobidget) | **GET** /mahasangraha/api/v1/translations/jobs/{job_id} | 
[**mahasangrahaApiV1TranslationsJobsPost**](TranslationApi.md#mahasangrahaapiv1translationsjobspost) | **POST** /mahasangraha/api/v1/translations/jobs | 
[**mahasangrahaApiV1TranslationsLanguagesGet**](TranslationApi.md#mahasangrahaapiv1translationslanguagesget) | **GET** /mahasangraha/api/v1/translations/languages | 
[**mahasangrahaApiV1TranslationsPost**](TranslationApi.md#mahasangrahaapiv1translationspost) | **POST** /mahasangraha/api/v1/translations | 
[**mahasangrahaApiV1TranslationsPreviewPost**](TranslationApi.md#mahasangrahaapiv1translationspreviewpost) | **POST** /mahasangraha/api/v1/translations/preview | 


# **mahasangrahaApiV1TranslationsGet**
> mahasangrahaApiV1TranslationsGet()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getTranslationApi();

try {
    api.mahasangrahaApiV1TranslationsGet();
} on DioException catch (e) {
    print('Exception when calling TranslationApi->mahasangrahaApiV1TranslationsGet: $e\n');
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

# **mahasangrahaApiV1TranslationsJobsGet**
> mahasangrahaApiV1TranslationsJobsGet()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getTranslationApi();

try {
    api.mahasangrahaApiV1TranslationsJobsGet();
} on DioException catch (e) {
    print('Exception when calling TranslationApi->mahasangrahaApiV1TranslationsJobsGet: $e\n');
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

# **mahasangrahaApiV1TranslationsJobsJobIdCancelPatch**
> mahasangrahaApiV1TranslationsJobsJobIdCancelPatch(jobId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getTranslationApi();
final String jobId = jobId_example; // String | 

try {
    api.mahasangrahaApiV1TranslationsJobsJobIdCancelPatch(jobId);
} on DioException catch (e) {
    print('Exception when calling TranslationApi->mahasangrahaApiV1TranslationsJobsJobIdCancelPatch: $e\n');
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

# **mahasangrahaApiV1TranslationsJobsJobIdContentGet**
> mahasangrahaApiV1TranslationsJobsJobIdContentGet(jobId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getTranslationApi();
final String jobId = jobId_example; // String | 

try {
    api.mahasangrahaApiV1TranslationsJobsJobIdContentGet(jobId);
} on DioException catch (e) {
    print('Exception when calling TranslationApi->mahasangrahaApiV1TranslationsJobsJobIdContentGet: $e\n');
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

# **mahasangrahaApiV1TranslationsJobsJobIdDelete**
> mahasangrahaApiV1TranslationsJobsJobIdDelete(jobId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getTranslationApi();
final String jobId = jobId_example; // String | 

try {
    api.mahasangrahaApiV1TranslationsJobsJobIdDelete(jobId);
} on DioException catch (e) {
    print('Exception when calling TranslationApi->mahasangrahaApiV1TranslationsJobsJobIdDelete: $e\n');
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

# **mahasangrahaApiV1TranslationsJobsJobIdGet**
> mahasangrahaApiV1TranslationsJobsJobIdGet(jobId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getTranslationApi();
final String jobId = jobId_example; // String | 

try {
    api.mahasangrahaApiV1TranslationsJobsJobIdGet(jobId);
} on DioException catch (e) {
    print('Exception when calling TranslationApi->mahasangrahaApiV1TranslationsJobsJobIdGet: $e\n');
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

# **mahasangrahaApiV1TranslationsJobsPost**
> mahasangrahaApiV1TranslationsJobsPost()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getTranslationApi();

try {
    api.mahasangrahaApiV1TranslationsJobsPost();
} on DioException catch (e) {
    print('Exception when calling TranslationApi->mahasangrahaApiV1TranslationsJobsPost: $e\n');
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

# **mahasangrahaApiV1TranslationsLanguagesGet**
> mahasangrahaApiV1TranslationsLanguagesGet()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getTranslationApi();

try {
    api.mahasangrahaApiV1TranslationsLanguagesGet();
} on DioException catch (e) {
    print('Exception when calling TranslationApi->mahasangrahaApiV1TranslationsLanguagesGet: $e\n');
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

# **mahasangrahaApiV1TranslationsPost**
> mahasangrahaApiV1TranslationsPost()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getTranslationApi();

try {
    api.mahasangrahaApiV1TranslationsPost();
} on DioException catch (e) {
    print('Exception when calling TranslationApi->mahasangrahaApiV1TranslationsPost: $e\n');
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

# **mahasangrahaApiV1TranslationsPreviewPost**
> mahasangrahaApiV1TranslationsPreviewPost()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getTranslationApi();

try {
    api.mahasangrahaApiV1TranslationsPreviewPost();
} on DioException catch (e) {
    print('Exception when calling TranslationApi->mahasangrahaApiV1TranslationsPreviewPost: $e\n');
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


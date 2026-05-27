# ridp_api.api.NlpSearchApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1AiSearchFormIdNlpSearchPost**](NlpSearchApi.md#formapiv1aisearchformidnlpsearchpost) | **POST** /form/api/v1/ai/search/{form_id}/nlp-search | Natural language search across form responses with advanced filtering.
[**formApiV1AiSearchFormIdPopularQueriesGet**](NlpSearchApi.md#formapiv1aisearchformidpopularqueriesget) | **GET** /form/api/v1/ai/search/{form_id}/popular-queries | Get popular search queries for a form.
[**formApiV1AiSearchFormIdQuerySuggestionsGet**](NlpSearchApi.md#formapiv1aisearchformidquerysuggestionsget) | **GET** /form/api/v1/ai/search/{form_id}/query-suggestions | Get query suggestions/autocomplete for a form.
[**formApiV1AiSearchFormIdSearchHistoryDelete**](NlpSearchApi.md#formapiv1aisearchformidsearchhistorydelete) | **DELETE** /form/api/v1/ai/search/{form_id}/search-history | Clear user&#39;s search history for a form.
[**formApiV1AiSearchFormIdSearchHistoryGet**](NlpSearchApi.md#formapiv1aisearchformidsearchhistoryget) | **GET** /form/api/v1/ai/search/{form_id}/search-history | Get user&#39;s search history for a form.
[**formApiV1AiSearchFormIdSearchHistoryPost**](NlpSearchApi.md#formapiv1aisearchformidsearchhistorypost) | **POST** /form/api/v1/ai/search/{form_id}/search-history | Save a search query to user&#39;s search history.
[**formApiV1AiSearchFormIdSearchHistorySearchIdDelete**](NlpSearchApi.md#formapiv1aisearchformidsearchhistorysearchiddelete) | **DELETE** /form/api/v1/ai/search/{form_id}/search-history/{search_id} | Delete a specific search history item.
[**formApiV1AiSearchFormIdSearchStatsGet**](NlpSearchApi.md#formapiv1aisearchformidsearchstatsget) | **GET** /form/api/v1/ai/search/{form_id}/search-stats | Get search-related statistics for a form.
[**formApiV1AiSearchFormIdSemanticSearchPost**](NlpSearchApi.md#formapiv1aisearchformidsemanticsearchpost) | **POST** /form/api/v1/ai/search/{form_id}/semantic-search | Pure semantic search using Ollama embeddings with advanced filtering.
[**formApiV1AiSearchFormIdSemanticSearchStreamPost**](NlpSearchApi.md#formapiv1aisearchformidsemanticsearchstreampost) | **POST** /form/api/v1/ai/search/{form_id}/semantic-search/stream | Pure semantic search using Ollama embeddings with streaming response and advanced filtering.
[**formApiV1AiSearchHealthGet**](NlpSearchApi.md#formapiv1aisearchhealthget) | **GET** /form/api/v1/ai/search/health | Health check for NLP search service.


# **formApiV1AiSearchFormIdNlpSearchPost**
> formApiV1AiSearchFormIdNlpSearchPost(formId)

Natural language search across form responses with advanced filtering.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getNlpSearchApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1AiSearchFormIdNlpSearchPost(formId);
} on DioException catch (e) {
    print('Exception when calling NlpSearchApi->formApiV1AiSearchFormIdNlpSearchPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1AiSearchFormIdPopularQueriesGet**
> formApiV1AiSearchFormIdPopularQueriesGet(formId)

Get popular search queries for a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getNlpSearchApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1AiSearchFormIdPopularQueriesGet(formId);
} on DioException catch (e) {
    print('Exception when calling NlpSearchApi->formApiV1AiSearchFormIdPopularQueriesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1AiSearchFormIdQuerySuggestionsGet**
> formApiV1AiSearchFormIdQuerySuggestionsGet(formId)

Get query suggestions/autocomplete for a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getNlpSearchApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1AiSearchFormIdQuerySuggestionsGet(formId);
} on DioException catch (e) {
    print('Exception when calling NlpSearchApi->formApiV1AiSearchFormIdQuerySuggestionsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1AiSearchFormIdSearchHistoryDelete**
> formApiV1AiSearchFormIdSearchHistoryDelete(formId)

Clear user's search history for a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getNlpSearchApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1AiSearchFormIdSearchHistoryDelete(formId);
} on DioException catch (e) {
    print('Exception when calling NlpSearchApi->formApiV1AiSearchFormIdSearchHistoryDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1AiSearchFormIdSearchHistoryGet**
> formApiV1AiSearchFormIdSearchHistoryGet(formId)

Get user's search history for a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getNlpSearchApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1AiSearchFormIdSearchHistoryGet(formId);
} on DioException catch (e) {
    print('Exception when calling NlpSearchApi->formApiV1AiSearchFormIdSearchHistoryGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1AiSearchFormIdSearchHistoryPost**
> formApiV1AiSearchFormIdSearchHistoryPost(formId)

Save a search query to user's search history.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getNlpSearchApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1AiSearchFormIdSearchHistoryPost(formId);
} on DioException catch (e) {
    print('Exception when calling NlpSearchApi->formApiV1AiSearchFormIdSearchHistoryPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1AiSearchFormIdSearchHistorySearchIdDelete**
> formApiV1AiSearchFormIdSearchHistorySearchIdDelete(formId, searchId)

Delete a specific search history item.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getNlpSearchApi();
final String formId = formId_example; // String | 
final String searchId = searchId_example; // String | 

try {
    api.formApiV1AiSearchFormIdSearchHistorySearchIdDelete(formId, searchId);
} on DioException catch (e) {
    print('Exception when calling NlpSearchApi->formApiV1AiSearchFormIdSearchHistorySearchIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 
 **searchId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1AiSearchFormIdSearchStatsGet**
> formApiV1AiSearchFormIdSearchStatsGet(formId)

Get search-related statistics for a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getNlpSearchApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1AiSearchFormIdSearchStatsGet(formId);
} on DioException catch (e) {
    print('Exception when calling NlpSearchApi->formApiV1AiSearchFormIdSearchStatsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1AiSearchFormIdSemanticSearchPost**
> formApiV1AiSearchFormIdSemanticSearchPost(formId)

Pure semantic search using Ollama embeddings with advanced filtering.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getNlpSearchApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1AiSearchFormIdSemanticSearchPost(formId);
} on DioException catch (e) {
    print('Exception when calling NlpSearchApi->formApiV1AiSearchFormIdSemanticSearchPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1AiSearchFormIdSemanticSearchStreamPost**
> formApiV1AiSearchFormIdSemanticSearchStreamPost(formId)

Pure semantic search using Ollama embeddings with streaming response and advanced filtering.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getNlpSearchApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1AiSearchFormIdSemanticSearchStreamPost(formId);
} on DioException catch (e) {
    print('Exception when calling NlpSearchApi->formApiV1AiSearchFormIdSemanticSearchStreamPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **formApiV1AiSearchHealthGet**
> formApiV1AiSearchHealthGet()

Health check for NLP search service.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getNlpSearchApi();

try {
    api.formApiV1AiSearchHealthGet();
} on DioException catch (e) {
    print('Exception when calling NlpSearchApi->formApiV1AiSearchHealthGet: $e\n');
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


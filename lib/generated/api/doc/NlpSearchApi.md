# ridp_api.api.NlpSearchApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1AiSearchFormIdNlpSearchPost**](NlpSearchApi.md#mahasangrahaapiv1aisearchformidnlpsearchpost) | **POST** /mahasangraha/api/v1/ai/search/{form_id}/nlp-search | Natural language search across form responses with advanced filtering.
[**mahasangrahaApiV1AiSearchFormIdPopularQueriesGet**](NlpSearchApi.md#mahasangrahaapiv1aisearchformidpopularqueriesget) | **GET** /mahasangraha/api/v1/ai/search/{form_id}/popular-queries | Get popular search queries for a form.
[**mahasangrahaApiV1AiSearchFormIdQuerySuggestionsGet**](NlpSearchApi.md#mahasangrahaapiv1aisearchformidquerysuggestionsget) | **GET** /mahasangraha/api/v1/ai/search/{form_id}/query-suggestions | Get query suggestions/autocomplete for a form.
[**mahasangrahaApiV1AiSearchFormIdSearchHistoryDelete**](NlpSearchApi.md#mahasangrahaapiv1aisearchformidsearchhistorydelete) | **DELETE** /mahasangraha/api/v1/ai/search/{form_id}/search-history | Clear user&#39;s search history for a form.
[**mahasangrahaApiV1AiSearchFormIdSearchHistoryGet**](NlpSearchApi.md#mahasangrahaapiv1aisearchformidsearchhistoryget) | **GET** /mahasangraha/api/v1/ai/search/{form_id}/search-history | Get user&#39;s search history for a form.
[**mahasangrahaApiV1AiSearchFormIdSearchHistoryPost**](NlpSearchApi.md#mahasangrahaapiv1aisearchformidsearchhistorypost) | **POST** /mahasangraha/api/v1/ai/search/{form_id}/search-history | Save a search query to user&#39;s search history.
[**mahasangrahaApiV1AiSearchFormIdSearchHistorySearchIdDelete**](NlpSearchApi.md#mahasangrahaapiv1aisearchformidsearchhistorysearchiddelete) | **DELETE** /mahasangraha/api/v1/ai/search/{form_id}/search-history/{search_id} | Delete a specific search history item.
[**mahasangrahaApiV1AiSearchFormIdSearchStatsGet**](NlpSearchApi.md#mahasangrahaapiv1aisearchformidsearchstatsget) | **GET** /mahasangraha/api/v1/ai/search/{form_id}/search-stats | Get search-related statistics for a form.
[**mahasangrahaApiV1AiSearchFormIdSemanticSearchPost**](NlpSearchApi.md#mahasangrahaapiv1aisearchformidsemanticsearchpost) | **POST** /mahasangraha/api/v1/ai/search/{form_id}/semantic-search | Pure semantic search using Ollama embeddings with advanced filtering.
[**mahasangrahaApiV1AiSearchFormIdSemanticSearchStreamPost**](NlpSearchApi.md#mahasangrahaapiv1aisearchformidsemanticsearchstreampost) | **POST** /mahasangraha/api/v1/ai/search/{form_id}/semantic-search/stream | Pure semantic search using Ollama embeddings with streaming response and advanced filtering.
[**mahasangrahaApiV1AiSearchHealthGet**](NlpSearchApi.md#mahasangrahaapiv1aisearchhealthget) | **GET** /mahasangraha/api/v1/ai/search/health | Health check for NLP search service.


# **mahasangrahaApiV1AiSearchFormIdNlpSearchPost**
> mahasangrahaApiV1AiSearchFormIdNlpSearchPost(formId)

Natural language search across form responses with advanced filtering.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getNlpSearchApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1AiSearchFormIdNlpSearchPost(formId);
} on DioException catch (e) {
    print('Exception when calling NlpSearchApi->mahasangrahaApiV1AiSearchFormIdNlpSearchPost: $e\n');
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

# **mahasangrahaApiV1AiSearchFormIdPopularQueriesGet**
> mahasangrahaApiV1AiSearchFormIdPopularQueriesGet(formId)

Get popular search queries for a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getNlpSearchApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1AiSearchFormIdPopularQueriesGet(formId);
} on DioException catch (e) {
    print('Exception when calling NlpSearchApi->mahasangrahaApiV1AiSearchFormIdPopularQueriesGet: $e\n');
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

# **mahasangrahaApiV1AiSearchFormIdQuerySuggestionsGet**
> mahasangrahaApiV1AiSearchFormIdQuerySuggestionsGet(formId)

Get query suggestions/autocomplete for a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getNlpSearchApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1AiSearchFormIdQuerySuggestionsGet(formId);
} on DioException catch (e) {
    print('Exception when calling NlpSearchApi->mahasangrahaApiV1AiSearchFormIdQuerySuggestionsGet: $e\n');
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

# **mahasangrahaApiV1AiSearchFormIdSearchHistoryDelete**
> mahasangrahaApiV1AiSearchFormIdSearchHistoryDelete(formId)

Clear user's search history for a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getNlpSearchApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1AiSearchFormIdSearchHistoryDelete(formId);
} on DioException catch (e) {
    print('Exception when calling NlpSearchApi->mahasangrahaApiV1AiSearchFormIdSearchHistoryDelete: $e\n');
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

# **mahasangrahaApiV1AiSearchFormIdSearchHistoryGet**
> mahasangrahaApiV1AiSearchFormIdSearchHistoryGet(formId)

Get user's search history for a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getNlpSearchApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1AiSearchFormIdSearchHistoryGet(formId);
} on DioException catch (e) {
    print('Exception when calling NlpSearchApi->mahasangrahaApiV1AiSearchFormIdSearchHistoryGet: $e\n');
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

# **mahasangrahaApiV1AiSearchFormIdSearchHistoryPost**
> mahasangrahaApiV1AiSearchFormIdSearchHistoryPost(formId)

Save a search query to user's search history.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getNlpSearchApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1AiSearchFormIdSearchHistoryPost(formId);
} on DioException catch (e) {
    print('Exception when calling NlpSearchApi->mahasangrahaApiV1AiSearchFormIdSearchHistoryPost: $e\n');
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

# **mahasangrahaApiV1AiSearchFormIdSearchHistorySearchIdDelete**
> mahasangrahaApiV1AiSearchFormIdSearchHistorySearchIdDelete(formId, searchId)

Delete a specific search history item.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getNlpSearchApi();
final String formId = formId_example; // String | 
final String searchId = searchId_example; // String | 

try {
    api.mahasangrahaApiV1AiSearchFormIdSearchHistorySearchIdDelete(formId, searchId);
} on DioException catch (e) {
    print('Exception when calling NlpSearchApi->mahasangrahaApiV1AiSearchFormIdSearchHistorySearchIdDelete: $e\n');
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

# **mahasangrahaApiV1AiSearchFormIdSearchStatsGet**
> mahasangrahaApiV1AiSearchFormIdSearchStatsGet(formId)

Get search-related statistics for a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getNlpSearchApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1AiSearchFormIdSearchStatsGet(formId);
} on DioException catch (e) {
    print('Exception when calling NlpSearchApi->mahasangrahaApiV1AiSearchFormIdSearchStatsGet: $e\n');
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

# **mahasangrahaApiV1AiSearchFormIdSemanticSearchPost**
> mahasangrahaApiV1AiSearchFormIdSemanticSearchPost(formId)

Pure semantic search using Ollama embeddings with advanced filtering.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getNlpSearchApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1AiSearchFormIdSemanticSearchPost(formId);
} on DioException catch (e) {
    print('Exception when calling NlpSearchApi->mahasangrahaApiV1AiSearchFormIdSemanticSearchPost: $e\n');
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

# **mahasangrahaApiV1AiSearchFormIdSemanticSearchStreamPost**
> mahasangrahaApiV1AiSearchFormIdSemanticSearchStreamPost(formId)

Pure semantic search using Ollama embeddings with streaming response and advanced filtering.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getNlpSearchApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1AiSearchFormIdSemanticSearchStreamPost(formId);
} on DioException catch (e) {
    print('Exception when calling NlpSearchApi->mahasangrahaApiV1AiSearchFormIdSemanticSearchStreamPost: $e\n');
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

# **mahasangrahaApiV1AiSearchHealthGet**
> mahasangrahaApiV1AiSearchHealthGet()

Health check for NLP search service.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getNlpSearchApi();

try {
    api.mahasangrahaApiV1AiSearchHealthGet();
} on DioException catch (e) {
    print('Exception when calling NlpSearchApi->mahasangrahaApiV1AiSearchHealthGet: $e\n');
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


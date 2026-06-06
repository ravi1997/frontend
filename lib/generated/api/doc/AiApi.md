# ridp_api.api.AiApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1AiCrossAnalysisPost**](AiApi.md#mahasangrahaapiv1aicrossanalysispost) | **POST** /mahasangraha/api/v1/ai/cross-analysis | Compare multiple forms&#39; performance and sentiment. Payload: { \&quot;form_ids\&quot;: [\&quot;id1\&quot;, \&quot;id2\&quot;] }
[**mahasangrahaApiV1AiFormIdAnomaliesPost**](AiApi.md#mahasangrahaapiv1aiformidanomaliespost) | **POST** /mahasangraha/api/v1/ai/{form_id}/anomalies | 
[**mahasangrahaApiV1AiFormIdAnomalyDetectPost**](AiApi.md#mahasangrahaapiv1aiformidanomalydetectpost) | **POST** /mahasangraha/api/v1/ai/{form_id}/anomaly-detect | 
[**mahasangrahaApiV1AiFormIdCacheDelete**](AiApi.md#mahasangrahaapiv1aiformidcachedelete) | **DELETE** /mahasangraha/api/v1/ai/{form_id}/cache | Clear all cache for a specific form.  This endpoint clears all cached data for a form including: - NLP search results - Semantic search results - Summarization results - Popular queries - Executive summaries  Response: {     \&quot;form_id\&quot;: \&quot;form-id\&quot;,     \&quot;keys_invalidated\&quot;: 10,     \&quot;cleared_at\&quot;: \&quot;2026-02-04T10:00:00Z\&quot; }
[**mahasangrahaApiV1AiFormIdCacheInvalidatePost**](AiApi.md#mahasangrahaapiv1aiformidcacheinvalidatepost) | **POST** /mahasangraha/api/v1/ai/{form_id}/cache/invalidate | Manual cache invalidation for a specific form.  Allows selective cache invalidation based on pattern: - all: Invalidate all cache for the form - nlp_search: Invalidate NLP search cache only - summarization: Invalidate summarization cache only - by_query: Invalidate cache for a specific query (requires &#39;query&#39; parameter)  Payload: {     \&quot;pattern\&quot;: \&quot;all\&quot; | \&quot;nlp_search\&quot; | \&quot;summarization\&quot; | \&quot;by_query\&quot;,     \&quot;query\&quot;: \&quot;search query text\&quot; (required for by_query pattern) }  Response: {     \&quot;form_id\&quot;: \&quot;form-id\&quot;,     \&quot;pattern\&quot;: \&quot;all\&quot;,     \&quot;keys_invalidated\&quot;: 5,     \&quot;invalidated_at\&quot;: \&quot;2026-02-04T10:00:00Z\&quot; }
[**mahasangrahaApiV1AiFormIdExportPost**](AiApi.md#mahasangrahaapiv1aiformidexportpost) | **POST** /mahasangraha/api/v1/ai/{form_id}/export | 
[**mahasangrahaApiV1AiFormIdResponsesResponseIdAnalyzePost**](AiApi.md#mahasangrahaapiv1aiformidresponsesresponseidanalyzepost) | **POST** /mahasangraha/api/v1/ai/{form_id}/responses/{response_id}/analyze | 
[**mahasangrahaApiV1AiFormIdResponsesResponseIdClassifyPost**](AiApi.md#mahasangrahaapiv1aiformidresponsesresponseidclassifypost) | **POST** /mahasangraha/api/v1/ai/{form_id}/responses/{response_id}/classify | Manually triggers AI auto-tagging and classification for a specific response. Returns 202 with scheduled task ID.
[**mahasangrahaApiV1AiFormIdResponsesResponseIdModeratePost**](AiApi.md#mahasangrahaapiv1aiformidresponsesresponseidmoderatepost) | **POST** /mahasangraha/api/v1/ai/{form_id}/responses/{response_id}/moderate | 
[**mahasangrahaApiV1AiFormIdSearchPost**](AiApi.md#mahasangrahaapiv1aiformidsearchpost) | **POST** /mahasangraha/api/v1/ai/{form_id}/search | 
[**mahasangrahaApiV1AiFormIdSecurityScanPost**](AiApi.md#mahasangrahaapiv1aiformidsecurityscanpost) | **POST** /mahasangraha/api/v1/ai/{form_id}/security-scan | 
[**mahasangrahaApiV1AiFormIdSentimentGet**](AiApi.md#mahasangrahaapiv1aiformidsentimentget) | **GET** /mahasangraha/api/v1/ai/{form_id}/sentiment | 
[**mahasangrahaApiV1AiFormIdSummarizePost**](AiApi.md#mahasangrahaapiv1aiformidsummarizepost) | **POST** /mahasangraha/api/v1/ai/{form_id}/summarize | NLP Summarization: Summarize hundreds of feedback responses into 3 bullet points.  Uses extractive summarization with keyword extraction and sentiment grouping.  Payload: {     \&quot;response_ids\&quot;: [\&quot;id1\&quot;, \&quot;id2\&quot;, ...] (optional, defaults to all responses),     \&quot;max_bullet_points\&quot;: 3,     \&quot;include_sentiment\&quot;: True,     \&quot;nocache\&quot;: False (optional, default: False) }
[**mahasangrahaApiV1AiFormIdTaxonomyGet**](AiApi.md#mahasangrahaapiv1aiformidtaxonomyget) | **GET** /mahasangraha/api/v1/ai/{form_id}/taxonomy | Retrieve classification configuration details (enabled status and taxonomy list) for a form.
[**mahasangrahaApiV1AiFormIdValidateDesignPost**](AiApi.md#mahasangrahaapiv1aiformidvalidatedesignpost) | **POST** /mahasangraha/api/v1/ai/{form_id}/validate-design | Analyzes the form design for UX/logical issues.
[**mahasangrahaApiV1AiGeneratePost**](AiApi.md#mahasangrahaapiv1aigeneratepost) | **POST** /mahasangraha/api/v1/ai/generate | 
[**mahasangrahaApiV1AiHealthGet**](AiApi.md#mahasangrahaapiv1aihealthget) | **GET** /mahasangraha/api/v1/ai/health | 
[**mahasangrahaApiV1AiSuggestionsPost**](AiApi.md#mahasangrahaapiv1aisuggestionspost) | **POST** /mahasangraha/api/v1/ai/suggestions | AI Field Suggestions based on current form context.
[**mahasangrahaApiV1AiTemplatesGet**](AiApi.md#mahasangrahaapiv1aitemplatesget) | **GET** /mahasangraha/api/v1/ai/templates | List available AI form templates.
[**mahasangrahaApiV1AiTemplatesTemplateIdGet**](AiApi.md#mahasangrahaapiv1aitemplatestemplateidget) | **GET** /mahasangraha/api/v1/ai/templates/{template_id} | Get a specific AI template structure.


# **mahasangrahaApiV1AiCrossAnalysisPost**
> mahasangrahaApiV1AiCrossAnalysisPost()

Compare multiple forms' performance and sentiment. Payload: { \"form_ids\": [\"id1\", \"id2\"] }

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();

try {
    api.mahasangrahaApiV1AiCrossAnalysisPost();
} on DioException catch (e) {
    print('Exception when calling AiApi->mahasangrahaApiV1AiCrossAnalysisPost: $e\n');
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

# **mahasangrahaApiV1AiFormIdAnomaliesPost**
> mahasangrahaApiV1AiFormIdAnomaliesPost(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1AiFormIdAnomaliesPost(formId);
} on DioException catch (e) {
    print('Exception when calling AiApi->mahasangrahaApiV1AiFormIdAnomaliesPost: $e\n');
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

# **mahasangrahaApiV1AiFormIdAnomalyDetectPost**
> mahasangrahaApiV1AiFormIdAnomalyDetectPost(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1AiFormIdAnomalyDetectPost(formId);
} on DioException catch (e) {
    print('Exception when calling AiApi->mahasangrahaApiV1AiFormIdAnomalyDetectPost: $e\n');
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

# **mahasangrahaApiV1AiFormIdCacheDelete**
> mahasangrahaApiV1AiFormIdCacheDelete(formId)

Clear all cache for a specific form.  This endpoint clears all cached data for a form including: - NLP search results - Semantic search results - Summarization results - Popular queries - Executive summaries  Response: {     \"form_id\": \"form-id\",     \"keys_invalidated\": 10,     \"cleared_at\": \"2026-02-04T10:00:00Z\" }

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1AiFormIdCacheDelete(formId);
} on DioException catch (e) {
    print('Exception when calling AiApi->mahasangrahaApiV1AiFormIdCacheDelete: $e\n');
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

# **mahasangrahaApiV1AiFormIdCacheInvalidatePost**
> mahasangrahaApiV1AiFormIdCacheInvalidatePost(formId)

Manual cache invalidation for a specific form.  Allows selective cache invalidation based on pattern: - all: Invalidate all cache for the form - nlp_search: Invalidate NLP search cache only - summarization: Invalidate summarization cache only - by_query: Invalidate cache for a specific query (requires 'query' parameter)  Payload: {     \"pattern\": \"all\" | \"nlp_search\" | \"summarization\" | \"by_query\",     \"query\": \"search query text\" (required for by_query pattern) }  Response: {     \"form_id\": \"form-id\",     \"pattern\": \"all\",     \"keys_invalidated\": 5,     \"invalidated_at\": \"2026-02-04T10:00:00Z\" }

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1AiFormIdCacheInvalidatePost(formId);
} on DioException catch (e) {
    print('Exception when calling AiApi->mahasangrahaApiV1AiFormIdCacheInvalidatePost: $e\n');
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

# **mahasangrahaApiV1AiFormIdExportPost**
> mahasangrahaApiV1AiFormIdExportPost(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1AiFormIdExportPost(formId);
} on DioException catch (e) {
    print('Exception when calling AiApi->mahasangrahaApiV1AiFormIdExportPost: $e\n');
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

# **mahasangrahaApiV1AiFormIdResponsesResponseIdAnalyzePost**
> mahasangrahaApiV1AiFormIdResponsesResponseIdAnalyzePost(formId, responseId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 
final String responseId = responseId_example; // String | 

try {
    api.mahasangrahaApiV1AiFormIdResponsesResponseIdAnalyzePost(formId, responseId);
} on DioException catch (e) {
    print('Exception when calling AiApi->mahasangrahaApiV1AiFormIdResponsesResponseIdAnalyzePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 
 **responseId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1AiFormIdResponsesResponseIdClassifyPost**
> mahasangrahaApiV1AiFormIdResponsesResponseIdClassifyPost(formId, responseId)

Manually triggers AI auto-tagging and classification for a specific response. Returns 202 with scheduled task ID.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 
final String responseId = responseId_example; // String | 

try {
    api.mahasangrahaApiV1AiFormIdResponsesResponseIdClassifyPost(formId, responseId);
} on DioException catch (e) {
    print('Exception when calling AiApi->mahasangrahaApiV1AiFormIdResponsesResponseIdClassifyPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 
 **responseId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1AiFormIdResponsesResponseIdModeratePost**
> mahasangrahaApiV1AiFormIdResponsesResponseIdModeratePost(formId, responseId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 
final String responseId = responseId_example; // String | 

try {
    api.mahasangrahaApiV1AiFormIdResponsesResponseIdModeratePost(formId, responseId);
} on DioException catch (e) {
    print('Exception when calling AiApi->mahasangrahaApiV1AiFormIdResponsesResponseIdModeratePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formId** | **String**|  | 
 **responseId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mahasangrahaApiV1AiFormIdSearchPost**
> mahasangrahaApiV1AiFormIdSearchPost(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1AiFormIdSearchPost(formId);
} on DioException catch (e) {
    print('Exception when calling AiApi->mahasangrahaApiV1AiFormIdSearchPost: $e\n');
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

# **mahasangrahaApiV1AiFormIdSecurityScanPost**
> mahasangrahaApiV1AiFormIdSecurityScanPost(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1AiFormIdSecurityScanPost(formId);
} on DioException catch (e) {
    print('Exception when calling AiApi->mahasangrahaApiV1AiFormIdSecurityScanPost: $e\n');
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

# **mahasangrahaApiV1AiFormIdSentimentGet**
> mahasangrahaApiV1AiFormIdSentimentGet(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1AiFormIdSentimentGet(formId);
} on DioException catch (e) {
    print('Exception when calling AiApi->mahasangrahaApiV1AiFormIdSentimentGet: $e\n');
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

# **mahasangrahaApiV1AiFormIdSummarizePost**
> mahasangrahaApiV1AiFormIdSummarizePost(formId)

NLP Summarization: Summarize hundreds of feedback responses into 3 bullet points.  Uses extractive summarization with keyword extraction and sentiment grouping.  Payload: {     \"response_ids\": [\"id1\", \"id2\", ...] (optional, defaults to all responses),     \"max_bullet_points\": 3,     \"include_sentiment\": True,     \"nocache\": False (optional, default: False) }

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1AiFormIdSummarizePost(formId);
} on DioException catch (e) {
    print('Exception when calling AiApi->mahasangrahaApiV1AiFormIdSummarizePost: $e\n');
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

# **mahasangrahaApiV1AiFormIdTaxonomyGet**
> mahasangrahaApiV1AiFormIdTaxonomyGet(formId)

Retrieve classification configuration details (enabled status and taxonomy list) for a form.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1AiFormIdTaxonomyGet(formId);
} on DioException catch (e) {
    print('Exception when calling AiApi->mahasangrahaApiV1AiFormIdTaxonomyGet: $e\n');
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

# **mahasangrahaApiV1AiFormIdValidateDesignPost**
> mahasangrahaApiV1AiFormIdValidateDesignPost(formId)

Analyzes the form design for UX/logical issues.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1AiFormIdValidateDesignPost(formId);
} on DioException catch (e) {
    print('Exception when calling AiApi->mahasangrahaApiV1AiFormIdValidateDesignPost: $e\n');
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

# **mahasangrahaApiV1AiGeneratePost**
> mahasangrahaApiV1AiGeneratePost()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();

try {
    api.mahasangrahaApiV1AiGeneratePost();
} on DioException catch (e) {
    print('Exception when calling AiApi->mahasangrahaApiV1AiGeneratePost: $e\n');
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

# **mahasangrahaApiV1AiHealthGet**
> mahasangrahaApiV1AiHealthGet()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();

try {
    api.mahasangrahaApiV1AiHealthGet();
} on DioException catch (e) {
    print('Exception when calling AiApi->mahasangrahaApiV1AiHealthGet: $e\n');
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

# **mahasangrahaApiV1AiSuggestionsPost**
> mahasangrahaApiV1AiSuggestionsPost()

AI Field Suggestions based on current form context.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();

try {
    api.mahasangrahaApiV1AiSuggestionsPost();
} on DioException catch (e) {
    print('Exception when calling AiApi->mahasangrahaApiV1AiSuggestionsPost: $e\n');
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

# **mahasangrahaApiV1AiTemplatesGet**
> mahasangrahaApiV1AiTemplatesGet()

List available AI form templates.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();

try {
    api.mahasangrahaApiV1AiTemplatesGet();
} on DioException catch (e) {
    print('Exception when calling AiApi->mahasangrahaApiV1AiTemplatesGet: $e\n');
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

# **mahasangrahaApiV1AiTemplatesTemplateIdGet**
> mahasangrahaApiV1AiTemplatesTemplateIdGet(templateId)

Get a specific AI template structure.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String templateId = templateId_example; // String | 

try {
    api.mahasangrahaApiV1AiTemplatesTemplateIdGet(templateId);
} on DioException catch (e) {
    print('Exception when calling AiApi->mahasangrahaApiV1AiTemplatesTemplateIdGet: $e\n');
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


# ridp_api.api.AiApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**formApiV1AiCrossAnalysisPost**](AiApi.md#formapiv1aicrossanalysispost) | **POST** /form/api/v1/ai/cross-analysis | Compare multiple forms&#39; performance and sentiment. Payload: { \&quot;form_ids\&quot;: [\&quot;id1\&quot;, \&quot;id2\&quot;] }
[**formApiV1AiFormIdAnomaliesPost**](AiApi.md#formapiv1aiformidanomaliespost) | **POST** /form/api/v1/ai/{form_id}/anomalies | 
[**formApiV1AiFormIdAnomalyDetectPost**](AiApi.md#formapiv1aiformidanomalydetectpost) | **POST** /form/api/v1/ai/{form_id}/anomaly-detect | 
[**formApiV1AiFormIdCacheDelete**](AiApi.md#formapiv1aiformidcachedelete) | **DELETE** /form/api/v1/ai/{form_id}/cache | Clear all cache for a specific form.  This endpoint clears all cached data for a form including: - NLP search results - Semantic search results - Summarization results - Popular queries - Executive summaries  Response: {     \&quot;form_id\&quot;: \&quot;form-id\&quot;,     \&quot;keys_invalidated\&quot;: 10,     \&quot;cleared_at\&quot;: \&quot;2026-02-04T10:00:00Z\&quot; }
[**formApiV1AiFormIdCacheInvalidatePost**](AiApi.md#formapiv1aiformidcacheinvalidatepost) | **POST** /form/api/v1/ai/{form_id}/cache/invalidate | Manual cache invalidation for a specific form.  Allows selective cache invalidation based on pattern: - all: Invalidate all cache for the form - nlp_search: Invalidate NLP search cache only - summarization: Invalidate summarization cache only - by_query: Invalidate cache for a specific query (requires &#39;query&#39; parameter)  Payload: {     \&quot;pattern\&quot;: \&quot;all\&quot; | \&quot;nlp_search\&quot; | \&quot;summarization\&quot; | \&quot;by_query\&quot;,     \&quot;query\&quot;: \&quot;search query text\&quot; (required for by_query pattern) }  Response: {     \&quot;form_id\&quot;: \&quot;form-id\&quot;,     \&quot;pattern\&quot;: \&quot;all\&quot;,     \&quot;keys_invalidated\&quot;: 5,     \&quot;invalidated_at\&quot;: \&quot;2026-02-04T10:00:00Z\&quot; }
[**formApiV1AiFormIdExportPost**](AiApi.md#formapiv1aiformidexportpost) | **POST** /form/api/v1/ai/{form_id}/export | 
[**formApiV1AiFormIdResponsesResponseIdAnalyzePost**](AiApi.md#formapiv1aiformidresponsesresponseidanalyzepost) | **POST** /form/api/v1/ai/{form_id}/responses/{response_id}/analyze | 
[**formApiV1AiFormIdResponsesResponseIdModeratePost**](AiApi.md#formapiv1aiformidresponsesresponseidmoderatepost) | **POST** /form/api/v1/ai/{form_id}/responses/{response_id}/moderate | 
[**formApiV1AiFormIdSearchPost**](AiApi.md#formapiv1aiformidsearchpost) | **POST** /form/api/v1/ai/{form_id}/search | 
[**formApiV1AiFormIdSecurityScanPost**](AiApi.md#formapiv1aiformidsecurityscanpost) | **POST** /form/api/v1/ai/{form_id}/security-scan | 
[**formApiV1AiFormIdSentimentGet**](AiApi.md#formapiv1aiformidsentimentget) | **GET** /form/api/v1/ai/{form_id}/sentiment | 
[**formApiV1AiFormIdSummarizePost**](AiApi.md#formapiv1aiformidsummarizepost) | **POST** /form/api/v1/ai/{form_id}/summarize | NLP Summarization: Summarize hundreds of feedback responses into 3 bullet points.  Uses extractive summarization with keyword extraction and sentiment grouping.  Payload: {     \&quot;response_ids\&quot;: [\&quot;id1\&quot;, \&quot;id2\&quot;, ...] (optional, defaults to all responses),     \&quot;max_bullet_points\&quot;: 3,     \&quot;include_sentiment\&quot;: True,     \&quot;nocache\&quot;: False (optional, default: False) }
[**formApiV1AiFormIdValidateDesignPost**](AiApi.md#formapiv1aiformidvalidatedesignpost) | **POST** /form/api/v1/ai/{form_id}/validate-design | Analyzes the form design for UX/logical issues.
[**formApiV1AiGeneratePost**](AiApi.md#formapiv1aigeneratepost) | **POST** /form/api/v1/ai/generate | 
[**formApiV1AiHealthGet**](AiApi.md#formapiv1aihealthget) | **GET** /form/api/v1/ai/health | 
[**formApiV1AiSuggestionsPost**](AiApi.md#formapiv1aisuggestionspost) | **POST** /form/api/v1/ai/suggestions | AI Field Suggestions based on current form context.
[**formApiV1AiTemplatesGet**](AiApi.md#formapiv1aitemplatesget) | **GET** /form/api/v1/ai/templates | List available AI form templates.
[**formApiV1AiTemplatesTemplateIdGet**](AiApi.md#formapiv1aitemplatestemplateidget) | **GET** /form/api/v1/ai/templates/{template_id} | Get a specific AI template structure.


# **formApiV1AiCrossAnalysisPost**
> formApiV1AiCrossAnalysisPost()

Compare multiple forms' performance and sentiment. Payload: { \"form_ids\": [\"id1\", \"id2\"] }

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();

try {
    api.formApiV1AiCrossAnalysisPost();
} on DioException catch (e) {
    print('Exception when calling AiApi->formApiV1AiCrossAnalysisPost: $e\n');
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

# **formApiV1AiFormIdAnomaliesPost**
> formApiV1AiFormIdAnomaliesPost(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1AiFormIdAnomaliesPost(formId);
} on DioException catch (e) {
    print('Exception when calling AiApi->formApiV1AiFormIdAnomaliesPost: $e\n');
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

# **formApiV1AiFormIdAnomalyDetectPost**
> formApiV1AiFormIdAnomalyDetectPost(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1AiFormIdAnomalyDetectPost(formId);
} on DioException catch (e) {
    print('Exception when calling AiApi->formApiV1AiFormIdAnomalyDetectPost: $e\n');
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

# **formApiV1AiFormIdCacheDelete**
> formApiV1AiFormIdCacheDelete(formId)

Clear all cache for a specific form.  This endpoint clears all cached data for a form including: - NLP search results - Semantic search results - Summarization results - Popular queries - Executive summaries  Response: {     \"form_id\": \"form-id\",     \"keys_invalidated\": 10,     \"cleared_at\": \"2026-02-04T10:00:00Z\" }

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1AiFormIdCacheDelete(formId);
} on DioException catch (e) {
    print('Exception when calling AiApi->formApiV1AiFormIdCacheDelete: $e\n');
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

# **formApiV1AiFormIdCacheInvalidatePost**
> formApiV1AiFormIdCacheInvalidatePost(formId)

Manual cache invalidation for a specific form.  Allows selective cache invalidation based on pattern: - all: Invalidate all cache for the form - nlp_search: Invalidate NLP search cache only - summarization: Invalidate summarization cache only - by_query: Invalidate cache for a specific query (requires 'query' parameter)  Payload: {     \"pattern\": \"all\" | \"nlp_search\" | \"summarization\" | \"by_query\",     \"query\": \"search query text\" (required for by_query pattern) }  Response: {     \"form_id\": \"form-id\",     \"pattern\": \"all\",     \"keys_invalidated\": 5,     \"invalidated_at\": \"2026-02-04T10:00:00Z\" }

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1AiFormIdCacheInvalidatePost(formId);
} on DioException catch (e) {
    print('Exception when calling AiApi->formApiV1AiFormIdCacheInvalidatePost: $e\n');
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

# **formApiV1AiFormIdExportPost**
> formApiV1AiFormIdExportPost(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1AiFormIdExportPost(formId);
} on DioException catch (e) {
    print('Exception when calling AiApi->formApiV1AiFormIdExportPost: $e\n');
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

# **formApiV1AiFormIdResponsesResponseIdAnalyzePost**
> formApiV1AiFormIdResponsesResponseIdAnalyzePost(formId, responseId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 
final String responseId = responseId_example; // String | 

try {
    api.formApiV1AiFormIdResponsesResponseIdAnalyzePost(formId, responseId);
} on DioException catch (e) {
    print('Exception when calling AiApi->formApiV1AiFormIdResponsesResponseIdAnalyzePost: $e\n');
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

# **formApiV1AiFormIdResponsesResponseIdModeratePost**
> formApiV1AiFormIdResponsesResponseIdModeratePost(formId, responseId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 
final String responseId = responseId_example; // String | 

try {
    api.formApiV1AiFormIdResponsesResponseIdModeratePost(formId, responseId);
} on DioException catch (e) {
    print('Exception when calling AiApi->formApiV1AiFormIdResponsesResponseIdModeratePost: $e\n');
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

# **formApiV1AiFormIdSearchPost**
> formApiV1AiFormIdSearchPost(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1AiFormIdSearchPost(formId);
} on DioException catch (e) {
    print('Exception when calling AiApi->formApiV1AiFormIdSearchPost: $e\n');
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

# **formApiV1AiFormIdSecurityScanPost**
> formApiV1AiFormIdSecurityScanPost(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1AiFormIdSecurityScanPost(formId);
} on DioException catch (e) {
    print('Exception when calling AiApi->formApiV1AiFormIdSecurityScanPost: $e\n');
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

# **formApiV1AiFormIdSentimentGet**
> formApiV1AiFormIdSentimentGet(formId)



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1AiFormIdSentimentGet(formId);
} on DioException catch (e) {
    print('Exception when calling AiApi->formApiV1AiFormIdSentimentGet: $e\n');
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

# **formApiV1AiFormIdSummarizePost**
> formApiV1AiFormIdSummarizePost(formId)

NLP Summarization: Summarize hundreds of feedback responses into 3 bullet points.  Uses extractive summarization with keyword extraction and sentiment grouping.  Payload: {     \"response_ids\": [\"id1\", \"id2\", ...] (optional, defaults to all responses),     \"max_bullet_points\": 3,     \"include_sentiment\": True,     \"nocache\": False (optional, default: False) }

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1AiFormIdSummarizePost(formId);
} on DioException catch (e) {
    print('Exception when calling AiApi->formApiV1AiFormIdSummarizePost: $e\n');
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

# **formApiV1AiFormIdValidateDesignPost**
> formApiV1AiFormIdValidateDesignPost(formId)

Analyzes the form design for UX/logical issues.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String formId = formId_example; // String | 

try {
    api.formApiV1AiFormIdValidateDesignPost(formId);
} on DioException catch (e) {
    print('Exception when calling AiApi->formApiV1AiFormIdValidateDesignPost: $e\n');
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

# **formApiV1AiGeneratePost**
> formApiV1AiGeneratePost()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();

try {
    api.formApiV1AiGeneratePost();
} on DioException catch (e) {
    print('Exception when calling AiApi->formApiV1AiGeneratePost: $e\n');
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

# **formApiV1AiHealthGet**
> formApiV1AiHealthGet()



### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();

try {
    api.formApiV1AiHealthGet();
} on DioException catch (e) {
    print('Exception when calling AiApi->formApiV1AiHealthGet: $e\n');
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

# **formApiV1AiSuggestionsPost**
> formApiV1AiSuggestionsPost()

AI Field Suggestions based on current form context.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();

try {
    api.formApiV1AiSuggestionsPost();
} on DioException catch (e) {
    print('Exception when calling AiApi->formApiV1AiSuggestionsPost: $e\n');
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

# **formApiV1AiTemplatesGet**
> formApiV1AiTemplatesGet()

List available AI form templates.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();

try {
    api.formApiV1AiTemplatesGet();
} on DioException catch (e) {
    print('Exception when calling AiApi->formApiV1AiTemplatesGet: $e\n');
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

# **formApiV1AiTemplatesTemplateIdGet**
> formApiV1AiTemplatesTemplateIdGet(templateId)

Get a specific AI template structure.

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAiApi();
final String templateId = templateId_example; // String | 

try {
    api.formApiV1AiTemplatesTemplateIdGet(templateId);
} on DioException catch (e) {
    print('Exception when calling AiApi->formApiV1AiTemplatesTemplateIdGet: $e\n');
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


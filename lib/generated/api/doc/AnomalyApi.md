# ridp_api.api.AnomalyApi

## Load the API package
```dart
import 'package:ridp_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnomaliesResponseIdGet**](AnomalyApi.md#mahasangrahaapiv1projectsprojectidformsformidanomaliesresponseidget) | **GET** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/anomalies/{response_id} | Get detailed anomaly information for a specific response.  Returns:     {         \&quot;response_id\&quot;: \&quot;resp_789\&quot;,         \&quot;anomaly_flags\&quot;: {...},         \&quot;response_data\&quot;: {...},         \&quot;review_status\&quot;: \&quot;pending\&quot;,         \&quot;suggested_actions\&quot;: [...]     }
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdDetectAnomaliesBatchPost**](AnomalyApi.md#mahasangrahaapiv1projectsprojectidformsformiddetectanomaliesbatchpost) | **POST** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/detect-anomalies/batch | Run anomaly detection on a batch of form responses.  Request Body:     {         \&quot;response_ids\&quot;: [\&quot;id1\&quot;, \&quot;id2\&quot;, \&quot;id3\&quot;],  // Required: List of response IDs to scan         \&quot;scan_config\&quot;: {             \&quot;detection_types\&quot;: [\&quot;spam\&quot;, \&quot;outlier\&quot;],  // Optional             \&quot;sensitivity\&quot;: \&quot;medium\&quot;,  // Optional: \&quot;auto\&quot;, \&quot;low\&quot;, \&quot;medium\&quot;, \&quot;high\&quot;             \&quot;use_dynamic_thresholds\&quot;: False  // Optional         },         \&quot;batch_id\&quot;: \&quot;batch_123\&quot;  // Optional: Custom batch ID     }  Returns:     {         \&quot;batch_id\&quot;: \&quot;batch_abc123_1234567890\&quot;,         \&quot;status\&quot;: \&quot;completed\&quot;,         \&quot;form_id\&quot;: \&quot;form_123\&quot;,         \&quot;total_responses\&quot;: 100,         \&quot;scanned_count\&quot;: 100,         \&quot;anomalies_detected\&quot;: 12,         \&quot;summary\&quot;: {...},         \&quot;results\&quot;: {...},         \&quot;started_at\&quot;: \&quot;2025-01-15T10:00:00Z\&quot;,         \&quot;completed_at\&quot;: \&quot;2025-01-15T10:01:30Z\&quot;     }  Task: M2-EXT-04c - Add batch scanning for anomaly detection
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdDetectAnomaliesPost**](AnomalyApi.md#mahasangrahaapiv1projectsprojectidformsformiddetectanomaliespost) | **POST** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/detect-anomalies | Run anomaly detection on form responses.  Request Body:     {         \&quot;scan_type\&quot;: \&quot;full\&quot; | \&quot;incremental\&quot;,         \&quot;response_ids\&quot;: [\&quot;id1\&quot;, \&quot;id2\&quot;],  // Optional         \&quot;detection_types\&quot;: [\&quot;spam\&quot;, \&quot;outlier\&quot;, \&quot;impossible_value\&quot;, \&quot;duplicate\&quot;],         \&quot;sensitivity\&quot;: \&quot;auto\&quot; | \&quot;low\&quot; | \&quot;medium\&quot; | \&quot;high\&quot;,         \&quot;use_dynamic_thresholds\&quot;: True,  // Use thresholds from database         \&quot;save_results\&quot;: True     }  Returns:     {         \&quot;form_id\&quot;: \&quot;form_123\&quot;,         \&quot;scan_type\&quot;: \&quot;full\&quot;,         \&quot;responses_scanned\&quot;: 250,         \&quot;anomalies_detected\&quot;: 12,         \&quot;baseline\&quot;: {...},         \&quot;thresholds_used\&quot;: {...},         \&quot;anomalies\&quot;: [...],         \&quot;summary_by_type\&quot;: {...}     }
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdThresholdsHistoryGet**](AnomalyApi.md#mahasangrahaapiv1projectsprojectidformsformidthresholdshistoryget) | **GET** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/thresholds/history | Get threshold history for a form.  Query Parameters:     limit: Maximum number of records to return (default: 50)  Returns:     {         \&quot;form_id\&quot;: \&quot;form_123\&quot;,         \&quot;threshold_history\&quot;: [...]     }
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdThresholdsLatestGet**](AnomalyApi.md#mahasangrahaapiv1projectsprojectidformsformidthresholdslatestget) | **GET** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/thresholds/latest | Get the latest threshold configuration for a form.  Query Parameters:     sensitivity: Filter by sensitivity (auto, low, medium, high)  Returns:     {         \&quot;threshold_id\&quot;: \&quot;...\&quot;,         \&quot;form_id\&quot;: \&quot;form_123\&quot;,         \&quot;thresholds\&quot;: {...},         \&quot;sensitivity\&quot;: \&quot;auto\&quot;,         \&quot;baseline_stats\&quot;: {...},         \&quot;response_count\&quot;: 150,         \&quot;created_by\&quot;: \&quot;user_123\&quot;,         \&quot;is_manual\&quot;: False     }
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdThresholdsManualPost**](AnomalyApi.md#mahasangrahaapiv1projectsprojectidformsformidthresholdsmanualpost) | **POST** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/thresholds/manual | Manually set a threshold configuration for a form.  Request Body:     {         \&quot;thresholds\&quot;: {             \&quot;z_score_threshold\&quot;: 2.5,             \&quot;sensitivity\&quot;: \&quot;high\&quot;,             ...         },         \&quot;reason\&quot;: \&quot;Too many false positives\&quot;     }  Returns:     {         \&quot;message\&quot;: \&quot;Manual threshold set successfully\&quot;,         \&quot;threshold_id\&quot;: \&quot;...\&quot;,         \&quot;thresholds\&quot;: {...},         \&quot;baseline_stats\&quot;: {...}     }
[**mahasangrahaApiV1ProjectsProjectIdFormsFormIdThresholdsUpdateBaselinePost**](AnomalyApi.md#mahasangrahaapiv1projectsprojectidformsformidthresholdsupdatebaselinepost) | **POST** /mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/thresholds/update-baseline | Update baseline statistics and calculate dynamic thresholds for a form.  Returns:     {         \&quot;message\&quot;: \&quot;Baseline updated successfully\&quot;,         \&quot;baseline_stats\&quot;: {...},         \&quot;thresholds\&quot;: {...},         \&quot;response_count\&quot;: 150,         \&quot;threshold_id\&quot;: \&quot;...\&quot;     }


# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnomaliesResponseIdGet**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnomaliesResponseIdGet(formId, responseId)

Get detailed anomaly information for a specific response.  Returns:     {         \"response_id\": \"resp_789\",         \"anomaly_flags\": {...},         \"response_data\": {...},         \"review_status\": \"pending\",         \"suggested_actions\": [...]     }

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAnomalyApi();
final String formId = formId_example; // String | 
final String responseId = responseId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnomaliesResponseIdGet(formId, responseId);
} on DioException catch (e) {
    print('Exception when calling AnomalyApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnomaliesResponseIdGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdDetectAnomaliesBatchPost**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdDetectAnomaliesBatchPost(formId)

Run anomaly detection on a batch of form responses.  Request Body:     {         \"response_ids\": [\"id1\", \"id2\", \"id3\"],  // Required: List of response IDs to scan         \"scan_config\": {             \"detection_types\": [\"spam\", \"outlier\"],  // Optional             \"sensitivity\": \"medium\",  // Optional: \"auto\", \"low\", \"medium\", \"high\"             \"use_dynamic_thresholds\": False  // Optional         },         \"batch_id\": \"batch_123\"  // Optional: Custom batch ID     }  Returns:     {         \"batch_id\": \"batch_abc123_1234567890\",         \"status\": \"completed\",         \"form_id\": \"form_123\",         \"total_responses\": 100,         \"scanned_count\": 100,         \"anomalies_detected\": 12,         \"summary\": {...},         \"results\": {...},         \"started_at\": \"2025-01-15T10:00:00Z\",         \"completed_at\": \"2025-01-15T10:01:30Z\"     }  Task: M2-EXT-04c - Add batch scanning for anomaly detection

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAnomalyApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdDetectAnomaliesBatchPost(formId);
} on DioException catch (e) {
    print('Exception when calling AnomalyApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdDetectAnomaliesBatchPost: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdDetectAnomaliesPost**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdDetectAnomaliesPost(formId)

Run anomaly detection on form responses.  Request Body:     {         \"scan_type\": \"full\" | \"incremental\",         \"response_ids\": [\"id1\", \"id2\"],  // Optional         \"detection_types\": [\"spam\", \"outlier\", \"impossible_value\", \"duplicate\"],         \"sensitivity\": \"auto\" | \"low\" | \"medium\" | \"high\",         \"use_dynamic_thresholds\": True,  // Use thresholds from database         \"save_results\": True     }  Returns:     {         \"form_id\": \"form_123\",         \"scan_type\": \"full\",         \"responses_scanned\": 250,         \"anomalies_detected\": 12,         \"baseline\": {...},         \"thresholds_used\": {...},         \"anomalies\": [...],         \"summary_by_type\": {...}     }

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAnomalyApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdDetectAnomaliesPost(formId);
} on DioException catch (e) {
    print('Exception when calling AnomalyApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdDetectAnomaliesPost: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdThresholdsHistoryGet**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdThresholdsHistoryGet(formId)

Get threshold history for a form.  Query Parameters:     limit: Maximum number of records to return (default: 50)  Returns:     {         \"form_id\": \"form_123\",         \"threshold_history\": [...]     }

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAnomalyApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdThresholdsHistoryGet(formId);
} on DioException catch (e) {
    print('Exception when calling AnomalyApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdThresholdsHistoryGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdThresholdsLatestGet**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdThresholdsLatestGet(formId)

Get the latest threshold configuration for a form.  Query Parameters:     sensitivity: Filter by sensitivity (auto, low, medium, high)  Returns:     {         \"threshold_id\": \"...\",         \"form_id\": \"form_123\",         \"thresholds\": {...},         \"sensitivity\": \"auto\",         \"baseline_stats\": {...},         \"response_count\": 150,         \"created_by\": \"user_123\",         \"is_manual\": False     }

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAnomalyApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdThresholdsLatestGet(formId);
} on DioException catch (e) {
    print('Exception when calling AnomalyApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdThresholdsLatestGet: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdThresholdsManualPost**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdThresholdsManualPost(formId)

Manually set a threshold configuration for a form.  Request Body:     {         \"thresholds\": {             \"z_score_threshold\": 2.5,             \"sensitivity\": \"high\",             ...         },         \"reason\": \"Too many false positives\"     }  Returns:     {         \"message\": \"Manual threshold set successfully\",         \"threshold_id\": \"...\",         \"thresholds\": {...},         \"baseline_stats\": {...}     }

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAnomalyApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdThresholdsManualPost(formId);
} on DioException catch (e) {
    print('Exception when calling AnomalyApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdThresholdsManualPost: $e\n');
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

# **mahasangrahaApiV1ProjectsProjectIdFormsFormIdThresholdsUpdateBaselinePost**
> mahasangrahaApiV1ProjectsProjectIdFormsFormIdThresholdsUpdateBaselinePost(formId)

Update baseline statistics and calculate dynamic thresholds for a form.  Returns:     {         \"message\": \"Baseline updated successfully\",         \"baseline_stats\": {...},         \"thresholds\": {...},         \"response_count\": 150,         \"threshold_id\": \"...\"     }

### Example
```dart
import 'package:ridp_api/api.dart';

final api = RidpApi().getAnomalyApi();
final String formId = formId_example; // String | 

try {
    api.mahasangrahaApiV1ProjectsProjectIdFormsFormIdThresholdsUpdateBaselinePost(formId);
} on DioException catch (e) {
    print('Exception when calling AnomalyApi->mahasangrahaApiV1ProjectsProjectIdFormsFormIdThresholdsUpdateBaselinePost: $e\n');
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


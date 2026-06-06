//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

// ignore: unused_import
import 'dart:convert';
import 'package:ridp_api/src/deserialize.dart';
import 'package:dio/dio.dart';


class AnomalyApi {

  final Dio _dio;

  const AnomalyApi(this._dio);

  /// Get detailed anomaly information for a specific response.  Returns:     {         \&quot;response_id\&quot;: \&quot;resp_789\&quot;,         \&quot;anomaly_flags\&quot;: {...},         \&quot;response_data\&quot;: {...},         \&quot;review_status\&quot;: \&quot;pending\&quot;,         \&quot;suggested_actions\&quot;: [...]     }
  /// 
  ///
  /// Parameters:
  /// * [formId] 
  /// * [responseId] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future]
  /// Throws [DioException] if API call or serialization fails
  Future<Response<void>> mahasangrahaApiV1ProjectsProjectIdFormsFormIdAnomaliesResponseIdGet({ 
    required String formId,
    required String responseId,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/anomalies/{response_id}'.replaceAll('{' r'form_id' '}', formId.toString()).replaceAll('{' r'response_id' '}', responseId.toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    return _response;
  }

  /// Run anomaly detection on a batch of form responses.  Request Body:     {         \&quot;response_ids\&quot;: [\&quot;id1\&quot;, \&quot;id2\&quot;, \&quot;id3\&quot;],  // Required: List of response IDs to scan         \&quot;scan_config\&quot;: {             \&quot;detection_types\&quot;: [\&quot;spam\&quot;, \&quot;outlier\&quot;],  // Optional             \&quot;sensitivity\&quot;: \&quot;medium\&quot;,  // Optional: \&quot;auto\&quot;, \&quot;low\&quot;, \&quot;medium\&quot;, \&quot;high\&quot;             \&quot;use_dynamic_thresholds\&quot;: False  // Optional         },         \&quot;batch_id\&quot;: \&quot;batch_123\&quot;  // Optional: Custom batch ID     }  Returns:     {         \&quot;batch_id\&quot;: \&quot;batch_abc123_1234567890\&quot;,         \&quot;status\&quot;: \&quot;completed\&quot;,         \&quot;form_id\&quot;: \&quot;form_123\&quot;,         \&quot;total_responses\&quot;: 100,         \&quot;scanned_count\&quot;: 100,         \&quot;anomalies_detected\&quot;: 12,         \&quot;summary\&quot;: {...},         \&quot;results\&quot;: {...},         \&quot;started_at\&quot;: \&quot;2025-01-15T10:00:00Z\&quot;,         \&quot;completed_at\&quot;: \&quot;2025-01-15T10:01:30Z\&quot;     }  Task: M2-EXT-04c - Add batch scanning for anomaly detection
  /// 
  ///
  /// Parameters:
  /// * [formId] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future]
  /// Throws [DioException] if API call or serialization fails
  Future<Response<void>> mahasangrahaApiV1ProjectsProjectIdFormsFormIdDetectAnomaliesBatchPost({ 
    required String formId,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/detect-anomalies/batch'.replaceAll('{' r'form_id' '}', formId.toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    return _response;
  }

  /// Run anomaly detection on form responses.  Request Body:     {         \&quot;scan_type\&quot;: \&quot;full\&quot; | \&quot;incremental\&quot;,         \&quot;response_ids\&quot;: [\&quot;id1\&quot;, \&quot;id2\&quot;],  // Optional         \&quot;detection_types\&quot;: [\&quot;spam\&quot;, \&quot;outlier\&quot;, \&quot;impossible_value\&quot;, \&quot;duplicate\&quot;],         \&quot;sensitivity\&quot;: \&quot;auto\&quot; | \&quot;low\&quot; | \&quot;medium\&quot; | \&quot;high\&quot;,         \&quot;use_dynamic_thresholds\&quot;: True,  // Use thresholds from database         \&quot;save_results\&quot;: True     }  Returns:     {         \&quot;form_id\&quot;: \&quot;form_123\&quot;,         \&quot;scan_type\&quot;: \&quot;full\&quot;,         \&quot;responses_scanned\&quot;: 250,         \&quot;anomalies_detected\&quot;: 12,         \&quot;baseline\&quot;: {...},         \&quot;thresholds_used\&quot;: {...},         \&quot;anomalies\&quot;: [...],         \&quot;summary_by_type\&quot;: {...}     }
  /// 
  ///
  /// Parameters:
  /// * [formId] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future]
  /// Throws [DioException] if API call or serialization fails
  Future<Response<void>> mahasangrahaApiV1ProjectsProjectIdFormsFormIdDetectAnomaliesPost({ 
    required String formId,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/detect-anomalies'.replaceAll('{' r'form_id' '}', formId.toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    return _response;
  }

  /// Get threshold history for a form.  Query Parameters:     limit: Maximum number of records to return (default: 50)  Returns:     {         \&quot;form_id\&quot;: \&quot;form_123\&quot;,         \&quot;threshold_history\&quot;: [...]     }
  /// 
  ///
  /// Parameters:
  /// * [formId] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future]
  /// Throws [DioException] if API call or serialization fails
  Future<Response<void>> mahasangrahaApiV1ProjectsProjectIdFormsFormIdThresholdsHistoryGet({ 
    required String formId,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/thresholds/history'.replaceAll('{' r'form_id' '}', formId.toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    return _response;
  }

  /// Get the latest threshold configuration for a form.  Query Parameters:     sensitivity: Filter by sensitivity (auto, low, medium, high)  Returns:     {         \&quot;threshold_id\&quot;: \&quot;...\&quot;,         \&quot;form_id\&quot;: \&quot;form_123\&quot;,         \&quot;thresholds\&quot;: {...},         \&quot;sensitivity\&quot;: \&quot;auto\&quot;,         \&quot;baseline_stats\&quot;: {...},         \&quot;response_count\&quot;: 150,         \&quot;created_by\&quot;: \&quot;user_123\&quot;,         \&quot;is_manual\&quot;: False     }
  /// 
  ///
  /// Parameters:
  /// * [formId] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future]
  /// Throws [DioException] if API call or serialization fails
  Future<Response<void>> mahasangrahaApiV1ProjectsProjectIdFormsFormIdThresholdsLatestGet({ 
    required String formId,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/thresholds/latest'.replaceAll('{' r'form_id' '}', formId.toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    return _response;
  }

  /// Manually set a threshold configuration for a form.  Request Body:     {         \&quot;thresholds\&quot;: {             \&quot;z_score_threshold\&quot;: 2.5,             \&quot;sensitivity\&quot;: \&quot;high\&quot;,             ...         },         \&quot;reason\&quot;: \&quot;Too many false positives\&quot;     }  Returns:     {         \&quot;message\&quot;: \&quot;Manual threshold set successfully\&quot;,         \&quot;threshold_id\&quot;: \&quot;...\&quot;,         \&quot;thresholds\&quot;: {...},         \&quot;baseline_stats\&quot;: {...}     }
  /// 
  ///
  /// Parameters:
  /// * [formId] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future]
  /// Throws [DioException] if API call or serialization fails
  Future<Response<void>> mahasangrahaApiV1ProjectsProjectIdFormsFormIdThresholdsManualPost({ 
    required String formId,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/thresholds/manual'.replaceAll('{' r'form_id' '}', formId.toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    return _response;
  }

  /// Update baseline statistics and calculate dynamic thresholds for a form.  Returns:     {         \&quot;message\&quot;: \&quot;Baseline updated successfully\&quot;,         \&quot;baseline_stats\&quot;: {...},         \&quot;thresholds\&quot;: {...},         \&quot;response_count\&quot;: 150,         \&quot;threshold_id\&quot;: \&quot;...\&quot;     }
  /// 
  ///
  /// Parameters:
  /// * [formId] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future]
  /// Throws [DioException] if API call or serialization fails
  Future<Response<void>> mahasangrahaApiV1ProjectsProjectIdFormsFormIdThresholdsUpdateBaselinePost({ 
    required String formId,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/mahasangraha/api/v1/projects/{project_id}/forms/{form_id}/thresholds/update-baseline'.replaceAll('{' r'form_id' '}', formId.toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    return _response;
  }

}

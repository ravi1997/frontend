import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'analytics_distribution.dart';
import 'analytics_repository.dart';
import 'analytics_summary.dart';
import 'analytics_timeline.dart';
import 'form_analytics.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final Dio _apiClient;
  final Logger _logger = Logger();

  AnalyticsRepositoryImpl(this._apiClient);

  @override
  Future<FormAnalytics> getFormAnalytics(String formId) async {
    final summary = await getAnalyticsSummary(formId);
    final timeline = await getAnalyticsTimeline(formId);
    final distribution = await getAnalyticsDistribution(formId);
    return FormAnalytics(
      formId: formId,
      totalSubmissions: summary.totalSubmissions,
      completionRate: summary.completionRate,
      trends: timeline.dataPoints
          .map((p) => TimeSeriesData(date: p.date, value: p.count))
          .toList(),
      fieldDistributions: {
        for (final field in distribution.fieldDistributions)
          field.fieldLabel: field.options
              .map(
                (o) => DistributionData(
                  label: o.label,
                  count: o.count,
                  percentage: o.percentage,
                ),
              )
              .toList(),
      },
    );
  }

  @override
  Future<AnalyticsSummary> getAnalyticsSummary(String formId) async {
    try {
      final response = await _apiClient.get('/forms/$formId/analytics/summary');
      final data = _asMap(response.data);
      final total = _readInt(data, [
        'total_submissions',
        'total_responses',
        'count',
      ]);
      final completionRate =
          _readNullableDouble(data, [
            'completion_rate',
            'completion_percentage',
          ]) ??
          (total == 0 ? 0 : 1);
      return AnalyticsSummary(
        formId: formId,
        totalSubmissions: total,
        completionRate: completionRate,
        uniqueResponders: _readNullableInt(data, [
          'unique_responders',
          'unique_users',
        ]),
        averageCompletionTime: _readNullableDouble(data, [
          'average_completion_time',
          'average_duration',
        ]),
        statusBreakdown: _readStatusBreakdown(data),
      );
    } catch (e, st) {
      _logger.e('analytics summary failed', error: e, stackTrace: st);
      return AnalyticsSummary(
        formId: formId,
        totalSubmissions: 0,
        completionRate: 0,
      );
    }
  }

  @override
  Future<AnalyticsTimeline> getAnalyticsTimeline(
    String formId, {
    int days = 30,
  }) async {
    try {
      final response = await _apiClient.get(
        '/forms/$formId/analytics/timeline',
        queryParameters: {'days': days},
      );
      if (response.data is List) {
        return AnalyticsTimeline(
          formId: formId,
          dataPoints: (response.data as List)
              .map((e) => TimelineDataPoint.fromJson(_asMap(e)))
              .toList(),
        );
      }
      final data = _asMap(response.data);
      return AnalyticsTimeline.fromJson({
        ...data,
        'form_id': data['form_id'] ?? formId,
        'data_points': data['data_points'] ?? data['timeline'] ?? const [],
      });
    } catch (e, st) {
      _logger.e('analytics timeline failed', error: e, stackTrace: st);
      return AnalyticsTimeline(formId: formId, dataPoints: const []);
    }
  }

  @override
  Future<AnalyticsDistribution> getAnalyticsDistribution(String formId) async {
    try {
      final response = await _apiClient.get(
        '/forms/$formId/analytics/distribution',
      );
      if (response.data is List) {
        return AnalyticsDistribution(
          formId: formId,
          fieldDistributions: (response.data as List)
              .map((e) => FieldDistribution.fromJson(_asMap(e)))
              .toList(),
        );
      }
      final data = _asMap(response.data);
      return AnalyticsDistribution.fromJson({
        ...data,
        'form_id': data['form_id'] ?? formId,
        'field_distributions':
            data['field_distributions'] ?? data['fields'] ?? const [],
      });
    } catch (e, st) {
      _logger.e('analytics distribution failed', error: e, stackTrace: st);
      return AnalyticsDistribution(
        formId: formId,
        fieldDistributions: const [],
      );
    }
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return <String, dynamic>{};
  }

  int _readInt(
    Map<String, dynamic> data,
    List<String> keys, {
    int fallback = 0,
  }) {
    for (final key in keys) {
      final value = data[key];
      if (value is num) return value.toInt();
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) return parsed;
      }
    }
    return fallback;
  }

  int? _readNullableInt(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is num) return value.toInt();
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) return parsed;
      }
    }
    return null;
  }

  double? _readNullableDouble(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is num) return value.toDouble();
      if (value is String) {
        final parsed = double.tryParse(value);
        if (parsed != null) return parsed;
      }
    }
    return null;
  }

  Map<String, int>? _readStatusBreakdown(Map<String, dynamic> data) {
    final raw = data['status_breakdown'];
    if (raw is Map) {
      return raw.map((key, value) {
        if (value is num) return MapEntry(key.toString(), value.toInt());
        if (value is String) {
          return MapEntry(key.toString(), int.tryParse(value) ?? 0);
        }
        return MapEntry(key.toString(), 0);
      });
    }
    return null;
  }
}

# 02. Technical Architecture - Advanced Analytics & Reporting

## System Architecture Overview

The Advanced Analytics & Reporting Epic extends the existing Flutter application with a comprehensive business intelligence layer. The architecture follows the existing clean architecture pattern with dedicated analytics services.

```
┌─────────────────────────────────────────────────────────────────┐
│                     Presentation Layer                          │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Dashboard Builder│  │ Report Viewer   │  │ Forecast UI  │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Domain Layer                                 │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Dashboard Entity │  │ Report Entity   │  │ Forecast     │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Widget Registry  │  │ Template Library │  │ Anomaly      │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Data Layer                                   │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Analytics Repo   │  │ Dashboard Repo   │  │ Report Repo  │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Forecast Service │  │ Anomaly Service  │  │ Export       │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Infrastructure Layer                         │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ API Client       │  │ Cache Manager    │  │ Export Libs  │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Scheduler        │  │ Notification     │  │ Chart Libs   │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## Component Architecture

### Presentation Layer

#### New Flutter Packages Required

```yaml
dependencies:
  # Advanced charting
  syncfusion_flutter_charts: ^27.0.0
  fl_chart: ^1.1.1  # Existing, extend usage
  
  # Dashboard builder
  flutter_draggable_gridview: ^0.0.8
  
  # Export formats
  pdf: ^3.10.0
  excel: ^4.0.0
  pptx: ^0.3.0
  
  # Scheduling
  workmanager: ^0.5.0
  
  # Heatmap visualization
  heatmap_calendar: ^1.0.0
```

#### New Presentation Components

```dart
// Dashboard Builder
lib/features/analytics/presentation/pages/
  ├── dashboard_builder_page.dart
  ├── dashboard_viewer_page.dart
  ├── report_scheduler_page.dart
  ├── forecast_viewer_page.dart
  └── funnel_analysis_page.dart

// Widgets
lib/features/analytics/presentation/widgets/
  ├── dashboard_canvas_widget.dart
  ├── widget_palette_widget.dart
  ├── widget_configuration_dialog.dart
  ├── forecast_chart_widget.dart
  ├── funnel_visualization_widget.dart
  ├── heatmap_overlay_widget.dart
  └── kpi_card_widget.dart
```

### Domain Layer

#### New Domain Entities

```dart
// lib/features/analytics/domain/entities/

class AnalyticsDashboard {
  final String id;
  final String name;
  final String description;
  final List<DashboardWidget> widgets;
  final DashboardLayout layout;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final Set<String> sharedWith;
  final DashboardPermissions permissions;
}

class DashboardWidget {
  final String id;
  final WidgetType type;
  final String title;
  final WidgetConfiguration configuration;
  final WidgetPosition position;
  final WidgetSize size;
  final List<String> dataSourceIds;
}

enum WidgetType {
  kpiCard,
  lineChart,
  barChart,
  pieChart,
  table,
  funnel,
  heatmap,
  gauge,
}

class ForecastResult {
  final String formId;
  final DateTime forecastDate;
  final List<ForecastDataPoint> dataPoints;
  final List<ConfidenceInterval> confidenceIntervals;
  final ForecastAccuracy accuracy;
}

class ConversionFunnel {
  final String formId;
  final List<FunnelStep> steps;
  final DateTime startDate;
  final DateTime endDate;
  final FunnelMetrics metrics;
}

class AnomalyDetection {
  final String id;
  final String metricId;
  final AnomalyType type;
  final double deviation;
  final DateTime detectedAt;
  final String context;
  final AlertSeverity severity;
}
```

#### New Domain Services

```dart
// lib/features/analytics/domain/services/

class ForecastingService {
  Future<ForecastResult> generateForecast({
    required String formId,
    required int horizonDays,
    ForecastModel model = ForecastModel.arima,
  });
  
  Future<ForecastAccuracy> evaluateModelAccuracy({
    required String formId,
    required int testPeriodDays,
  });
}

class AnomalyDetectionService {
  Future<List<AnomalyDetection>> detectAnomalies({
    required String metricId,
    required DateTime startDate,
    required DateTime endDate,
    required double threshold,
  });
  
  Future<void> configureAlertRules({
    required String metricId,
    required AlertRule rule,
  });
}

class ReportGenerationService {
  Future<ReportDocument> generateReport({
    required ReportTemplate template,
    required Map<String, dynamic> parameters,
  });
  
  Future<void> scheduleReport({
    required ScheduledReport schedule,
  });
}
```

### Data Layer

#### New Repository Interfaces

```dart
// lib/features/analytics/domain/repositories/

abstract class DashboardRepository {
  Future<List<AnalyticsDashboard>> getDashboards(String userId);
  Future<AnalyticsDashboard> getDashboard(String dashboardId);
  Future<AnalyticsDashboard> createDashboard(AnalyticsDashboard dashboard);
  Future<AnalyticsDashboard> updateDashboard(AnalyticsDashboard dashboard);
  Future<void> deleteDashboard(String dashboardId);
}

abstract class ReportRepository {
  Future<List<ScheduledReport>> getScheduledReports(String userId);
  Future<ScheduledReport> createScheduledReport(ScheduledReport report);
  Future<void> updateScheduledReport(ScheduledReport report);
  Future<void> deleteScheduledReport(String reportId);
  Future<ReportDocument> generateReport(String reportId);
}

abstract class ForecastRepository {
  Future<ForecastResult> getForecast(String formId, int horizonDays);
  Future<List<ForecastResult>> getHistoricalForecasts(String formId);
}
```

#### Repository Implementation

```dart
// lib/features/analytics/data/repositories/

class DashboardRepositoryImpl implements DashboardRepository {
  final ApiClient _apiClient;
  final CacheManager _cacheManager;
  
  @override
  Future<List<AnalyticsDashboard>> getDashboards(String userId) async {
    final cached = await _cacheManager.get('dashboards_$userId');
    if (cached != null) {
      return AnalyticsDashboard.fromJsonList(cached);
    }
    
    final response = await _apiClient.get('/api/analytics/dashboards', 
      queryParameters: {'userId': userId});
    
    await _cacheManager.set('dashboards_$userId', response.data);
    return AnalyticsDashboard.fromJsonList(response.data);
  }
  
  // ... other methods
}
```

## Data Model Extensions

### New Database Tables (Hive)

```dart
// lib/features/analytics/data/models/

@HiveType(typeId: 100)
class DashboardModel extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String name;
  
  @HiveField(2)
  String description;
  
  @HiveField(3)
  List<WidgetModel> widgets;
  
  @HiveField(4)
  String createdBy;
  
  @HiveField(5)
  DateTime createdAt;
  
  @HiveField(6)
  DateTime updatedAt;
}

@HiveType(typeId: 101)
class ScheduledReportModel extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String name;
  
  @HiveField(2)
  ReportTemplateModel template;
  
  @HiveField(3)
  ScheduleModel schedule;
  
  @HiveField(4)
  List<String> recipients;
  
  @HiveField(5)
  DateTime nextRunAt;
  
  @HiveField(6)
  ReportStatus status;
}
```

## API Integration

### New API Endpoints

```dart
// lib/features/analytics/data/datasources/

class AnalyticsRemoteDataSource {
  final Dio dio;
  
  // Dashboard endpoints
  Future<List<DashboardDto>> getDashboards() async {
    final response = await dio.get('/api/analytics/dashboards');
    return (response.data as List)
        .map((json) => DashboardDto.fromJson(json))
        .toList();
  }
  
  Future<DashboardDto> createDashboard(CreateDashboardDto dto) async {
    final response = await dio.post(
      '/api/analytics/dashboards',
      data: dto.toJson(),
    );
    return DashboardDto.fromJson(response.data);
  }
  
  // Forecast endpoints
  Future<ForecastDto> generateForecast(ForecastRequestDto request) async {
    final response = await dio.post(
      '/api/analytics/forecasts',
      data: request.toJson(),
    );
    return ForecastDto.fromJson(response.data);
  }
  
  // Funnel analysis
  Future<FunnelDto> getConversionFunnel(String formId, FunnelFilterDto filter) async {
    final response = await dio.get(
      '/api/analytics/funnels/$formId',
      queryParameters: filter.toJson(),
    );
    return FunnelDto.fromJson(response.data);
  }
  
  // Anomaly detection
  Future<List<AnomalyDto>> detectAnomalies(AnomalyRequestDto request) async {
    final response = await dio.post(
      '/api/analytics/anomalies',
      data: request.toJson(),
    );
    return (response.data as List)
        .map((json) => AnomalyDto.fromJson(json))
        .toList();
  }
  
  // Report scheduling
  Future<ScheduledReportDto> scheduleReport(ScheduleReportDto dto) async {
    final response = await dio.post(
      '/api/analytics/reports/schedule',
      data: dto.toJson(),
    );
    return ScheduledReportDto.fromJson(response.data);
  }
}
```

## State Management

### New Riverpod Providers

```dart
// lib/features/analytics/presentation/providers/

@riverpod
class DashboardController extends _$DashboardController {
  @override
  Future<List<AnalyticsDashboard>> build() async {
    final repository = ref.watch(dashboardRepositoryProvider);
    return repository.getDashboards(ref.watch(currentUserProvider)!.id);
  }
  
  Future<void> createDashboard(AnalyticsDashboard dashboard) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.watch(dashboardRepositoryProvider);
      return repository.createDashboard(dashboard);
    });
  }
  
  Future<void> updateDashboard(AnalyticsDashboard dashboard) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.watch(dashboardRepositoryProvider);
      return repository.updateDashboard(dashboard);
    });
  }
}

@riverpod
class ForecastController extends _$ForecastController {
  @override
  Future<ForecastResult?> build(String formId) => null;
  
  Future<void> generateForecast({
    required String formId,
    required int horizonDays,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.watch(forecastRepositoryProvider);
      return repository.getForecast(formId, horizonDays);
    });
  }
}

@riverpod
class AnomalyController extends _$AnomalyController {
  @override
  Future<List<AnomalyDetection>> build() => [];
  
  Future<void> detectAnomalies({
    required String metricId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.watch(anomalyDetectionServiceProvider);
      return service.detectAnomalies(
        metricId: metricId,
        startDate: startDate,
        endDate: endDate,
        threshold: 2.0, // 2 standard deviations
      );
    });
  }
}
```

## Caching Strategy

### Multi-Level Cache Architecture

```dart
// lib/core/cache/

class AnalyticsCacheManager {
  final CacheManager _memoryCache;
  final CacheManager _diskCache;
  
  Future<T?> get<T>(String key) async {
    // Check memory cache first
    final memoryValue = await _memoryCache.get(key);
    if (memoryValue != null) return memoryValue as T;
    
    // Check disk cache
    final diskValue = await _diskCache.get(key);
    if (diskValue != null) {
      // Promote to memory cache
      await _memoryCache.set(key, diskValue);
      return diskValue as T;
    }
    
    return null;
  }
  
  Future<void> set<T>(String key, T value, {Duration? ttl}) async {
    await _memoryCache.set(key, value, ttl: ttl);
    await _diskCache.set(key, value, ttl: ttl);
  }
  
  Future<void> invalidate(String key) async {
    await _memoryCache.remove(key);
    await _diskCache.remove(key);
  }
  
  Future<void> invalidatePattern(String pattern) async {
    // Invalidate all keys matching pattern
    await _memoryCache.removeAll();
    await _diskCache.removeAll();
  }
}
```

## Background Processing

### Report Scheduling with WorkManager

```dart
// lib/features/analytics/data/services/

class ReportSchedulerService {
  final ReportRepository _reportRepository;
  final NotificationService _notificationService;
  
  Future<void> initializeScheduler() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );
    
    await _scheduleAllReports();
  }
  
  Future<void> _scheduleAllReports() async {
    final reports = await _reportRepository.getScheduledReports(
      ref.read(currentUserProvider)!.id,
    );
    
    for (final report in reports) {
      await _scheduleReport(report);
    }
  }
  
  Future<void> _scheduleReport(ScheduledReport report) async {
    final task = PeriodicTask(
      uniqueName: 'report_${report.id}',
      taskName: 'generateReport',
      frequency: _convertFrequency(report.schedule.frequency),
      initialDelay: report.nextRunAt.difference(DateTime.now()),
      inputData: {'reportId': report.id},
    );
    
    await Workmanager().registerOneOffTask(task);
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final reportId = inputData?['reportId'] as String?;
    if (reportId != null) {
      await generateAndDeliverReport(reportId);
    }
    return true;
  });
}
```

## Performance Optimization

### Data Aggregation Strategy

```dart
// lib/features/analytics/data/services/

class DataAggregationService {
  Future<AggregatedData> aggregateData({
    required String formId,
    required DateTime startDate,
    required DateTime endDate,
    required List<String> dimensions,
  }) async {
    // Use pre-aggregated data when available
    final preAggregated = await _getPreAggregatedData(
      formId,
      startDate,
      endDate,
      dimensions,
    );
    
    if (preAggregated != null) {
      return preAggregated;
    }
    
    // Fall back to real-time aggregation
    return _performRealTimeAggregation(
      formId,
      startDate,
      endDate,
      dimensions,
    );
  }
  
  Future<AggregatedData?> _getPreAggregatedData(
    String formId,
    DateTime startDate,
    DateTime endDate,
    List<String> dimensions,
  ) async {
    // Check for cached aggregation
    final cacheKey = _buildCacheKey(formId, startDate, endDate, dimensions);
    return await _cacheManager.get<AggregatedData>(cacheKey);
  }
}
```

## Security Considerations

### Row-Level Security Implementation

```dart
// lib/features/analytics/domain/services/

class AnalyticsSecurityService {
  Future<bool> canAccessDashboard(String userId, String dashboardId) async {
    final dashboard = await _dashboardRepository.getDashboard(dashboardId);
    
    // Owner can always access
    if (dashboard.createdBy == userId) return true;
    
    // Check shared permissions
    return dashboard.sharedWith.contains(userId) ||
           dashboard.permissions.isPublic;
  }
  
  Future<bool> canEditDashboard(String userId, String dashboardId) async {
    final dashboard = await _dashboardRepository.getDashboard(dashboardId);
    
    // Only owner can edit
    return dashboard.createdBy == userId;
  }
}
```

## Integration Points

### Existing Component Extensions

```dart
// Extend existing analytics_repository.dart
abstract class AnalyticsRepository {
  // Existing methods...
  
  // New methods for advanced analytics
  Future<ForecastResult> getForecast(String formId, int horizonDays);
  Future<ConversionFunnel> getConversionFunnel(String formId, FunnelFilter filter);
  Future<List<AnomalyDetection>> detectAnomalies(AnomalyRequest request);
  Future<HeatmapData> getHeatmapData(String formId, DateTimeRange range);
}

// Extend existing csv_exporter.dart
class EnhancedCsvExporter extends CsvExporter {
  Future<void> exportReport(
    ReportDocument report,
    ExportFormat format,
    String outputPath,
  ) async {
    switch (format) {
      case ExportFormat.csv:
        await exportToCsv(report, outputPath);
        break;
      case ExportFormat.excel:
        await exportToExcel(report, outputPath);
        break;
      case ExportFormat.pdf:
        await exportToPdf(report, outputPath);
        break;
    }
  }
}
```

## Testing Strategy

### Unit Tests

```dart
// test/features/analytics/domain/services/

void main() {
  group('ForecastingService', () {
    late ForecastingService service;
    late MockForecastRepository mockRepository;
    
    setUp(() {
      mockRepository = MockForecastRepository();
      service = ForecastingService(mockRepository);
    });
    
    test('generateForecast returns valid forecast', () async {
      // Arrange
      const formId = 'test-form';
      const horizonDays = 30;
      final expectedForecast = ForecastResult(
        formId: formId,
        forecastDate: DateTime.now(),
        dataPoints: [],
        confidenceIntervals: [],
        accuracy: ForecastAccuracy.high,
      );
      
      when(mockRepository.getHistoricalData(formId))
          .thenAnswer((_) async => []);
      
      // Act
      final result = await service.generateForecast(
        formId: formId,
        horizonDays: horizonDays,
      );
      
      // Assert
      expect(result.formId, equals(formId));
      verify(mockRepository.getHistoricalData(formId)).called(1);
    });
  });
}
```

## Deployment Considerations

### Backend Requirements

1. **Analytics Database Extensions**
   - Time-series database (e.g., TimescaleDB) for efficient time-based queries
   - Materialized views for pre-aggregated data
   - Indexing strategy for analytics queries

2. **ML Model Deployment**
   - Model serving infrastructure (e.g., TensorFlow Serving, ONNX Runtime)
   - Model versioning and A/B testing capabilities
   - Monitoring for model drift detection

3. **Background Job Processing**
   - Job queue system (e.g., Redis Queue, Celery)
   - Scheduled task execution
   - Failure handling and retry logic

4. **CDN Configuration**
   - Static asset caching for chart libraries
   - Report document caching
   - Geographic distribution for global users

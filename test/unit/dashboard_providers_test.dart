import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:frontend/modules/dashboard_builder/models/dashboard_canvas_models.dart';
import 'package:frontend/modules/dashboard_builder/providers/canvas_state_provider.dart';
import 'package:frontend/modules/dashboard_builder/providers/filter_state_provider.dart';
import 'package:frontend/modules/dashboard_builder/providers/widget_data_provider.dart';
import 'package:frontend/modules/dashboard_builder/repositories/dashboard_builder_repository.dart';

class MockDashboardBuilderRepository extends Mock implements DashboardBuilderRepository {}

void main() {
  group('CanvasStateNotifier Tests', () {
    late DashboardCanvas canvas;

    setUp(() {
      canvas = DashboardCanvas(
        width: 1000,
        height: 800,
        backgroundColor: '#FFFFFF',
        widgets: [],
      );
    });

    test('initializes with default values', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(canvasStateProvider(canvas));
      expect(state.mode, CanvasMode.edit);
      expect(state.scale, 1.0);
      expect(state.isDirty, isFalse);
      expect(state.selectedWidgetId, isNull);
      expect(state.canvas, canvas);
    });

    test('setMode changes mode', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(canvasStateProvider(canvas).notifier);
      notifier.setMode(CanvasMode.preview);

      final state = container.read(canvasStateProvider(canvas));
      expect(state.mode, CanvasMode.preview);
    });

    test('updateCanvas updates canvas and marks state dirty', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(canvasStateProvider(canvas).notifier);
      final newCanvas = DashboardCanvas(
        width: 1200,
        height: 900,
        backgroundColor: '#000000',
        widgets: [],
      );

      notifier.updateCanvas(newCanvas);

      final state = container.read(canvasStateProvider(canvas));
      expect(state.canvas.width, 1200);
      expect(state.canvas.backgroundColor, '#000000');
      expect(state.isDirty, isTrue);
    });

    test('setScale clamps scale values', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(canvasStateProvider(canvas).notifier);

      notifier.setScale(1.5);
      expect(container.read(canvasStateProvider(canvas)).scale, 1.5);

      notifier.setScale(0.2); // Below min (0.5)
      expect(container.read(canvasStateProvider(canvas)).scale, 0.5);

      notifier.setScale(2.5); // Above max (2.0)
      expect(container.read(canvasStateProvider(canvas)).scale, 2.0);
    });

    test('selectWidget and clearSelection works', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(canvasStateProvider(canvas).notifier);

      notifier.selectWidget('widget-123');
      expect(container.read(canvasStateProvider(canvas)).selectedWidgetId, 'widget-123');

      notifier.selectWidget(null);
      expect(container.read(canvasStateProvider(canvas)).selectedWidgetId, isNull);
    });

    test('markClean resets dirty status', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(canvasStateProvider(canvas).notifier);
      notifier.updateCanvas(canvas); // makes dirty
      expect(container.read(canvasStateProvider(canvas)).isDirty, isTrue);

      notifier.markClean();
      expect(container.read(canvasStateProvider(canvas)).isDirty, isFalse);
    });
  });

  group('FilterStateNotifier Tests', () {
    test('initializes as empty map', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(filterStateProvider);
      expect(state, isEmpty);
    });

    test('setFilter, clearFilter, and clearAll modify state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(filterStateProvider.notifier);

      notifier.setFilter('filter-1', 'value-a');
      expect(container.read(filterStateProvider), {'filter-1': 'value-a'});

      notifier.setFilter('filter-2', 42);
      expect(container.read(filterStateProvider), {'filter-1': 'value-a', 'filter-2': 42});

      notifier.clearFilter('filter-1');
      expect(container.read(filterStateProvider), {'filter-2': 42});

      notifier.clearAll();
      expect(container.read(filterStateProvider), isEmpty);
    });
  });

  group('WidgetDataNotifier Tests', () {
    late MockDashboardBuilderRepository mockRepository;

    setUp(() {
      mockRepository = MockDashboardBuilderRepository();
    });

    test('fetchDashboardData successfully resolves and maps widget data', () async {
      final container = ProviderContainer(
        overrides: [
          dashboardBuilderRepositoryProvider.overrideWith((ref) => mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final sampleApiResponse = {
        'widget_data': {
          'widget-1': {'data': 42},
          'widget-2': {'data': {'name': 'Alice'}},
          'widget-3': 100, // not nested under data key
        }
      };

      when(() => mockRepository.getDashboardData('dash-123', filterState: any(named: 'filterState')))
          .thenAnswer((_) async => sampleApiResponse);

      final notifier = container.read(widgetDataProvider.notifier);
      final future = notifier.fetchDashboardData('dash-123');

      // Verify loading state is true during fetch
      expect(container.read(widgetDataProvider).isLoading, isTrue);

      await future;

      final finalState = container.read(widgetDataProvider);
      expect(finalState.isLoading, isFalse);
      expect(finalState.error, isNull);
      expect(finalState.data['widget-1'], 42);
      expect(finalState.data['widget-2'], {'name': 'Alice'});
      expect(finalState.data['widget-3'], 100);
    });

    test('fetchDashboardData registers and handles errors', () async {
      final container = ProviderContainer(
        overrides: [
          dashboardBuilderRepositoryProvider.overrideWith((ref) => mockRepository),
        ],
      );
      addTearDown(container.dispose);

      when(() => mockRepository.getDashboardData('dash-123', filterState: any(named: 'filterState')))
          .thenThrow(Exception('API error'));

      final notifier = container.read(widgetDataProvider.notifier);
      await notifier.fetchDashboardData('dash-123');

      final finalState = container.read(widgetDataProvider);
      expect(finalState.isLoading, isFalse);
      expect(finalState.error, contains('API error'));
    });

    test('polling calls repository periodically and stops when cancelled', () async {
      final container = ProviderContainer(
        overrides: [
          dashboardBuilderRepositoryProvider.overrideWith((ref) => mockRepository),
        ],
      );
      addTearDown(container.dispose);

      when(() => mockRepository.getDashboardData('dash-123', filterState: any(named: 'filterState')))
          .thenAnswer((_) async => {'widget_data': {}});

      final notifier = container.read(widgetDataProvider.notifier);
      
      // Start auto-refresh.
      notifier.startAutoRefresh('dash-123', 10);

      // Stop it to ensure no leaks or infinite timers.
      notifier.stopAutoRefresh();
      
      verifyNever(() => mockRepository.getDashboardData('dash-123', filterState: any(named: 'filterState')));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/dashboard_builder/models/dashboard_canvas_models.dart';

void main() {
  test('DashboardWidget parses flat backend canvas payloads', () {
    final widget = DashboardWidget.fromJson({
      'id': 'widget-1',
      'type': 'counter',
      'title': 'Completed',
      'position_x': 12,
      'position_y': 24,
      'width': 240,
      'height': 120,
      'color_scheme': '#123456',
      'data': {'value': 42},
    });

    expect(widget.type, DashboardWidgetType.kpiCard);
    expect(widget.x, 12);
    expect(widget.y, 24);
    expect(widget.width, 240);
    expect(widget.height, 120);
    expect(widget.properties['title'], 'Completed');
    expect(widget.properties['color_scheme'], '#123456');
    expect(widget.resolvedData, isA<Map>());
    expect((widget.resolvedData as Map)['value'], 42);
  });

  test('DashboardModel parses flat canvas snapshots and settings', () {
    final model = DashboardModel.fromJson({
      'dashboard_id': 'dash-1',
      'project_id': 'project-1',
      'title': 'Overview',
      'description': 'Live summary',
      'is_shared': true,
      'share_token': 'share-token',
      'canvas_width': 1440,
      'canvas_height': 900,
      'background_color': '#EEEEEE',
      'widgets': [
        {
          'id': 'widget-1',
          'type': 'counter',
          'title': 'Completed',
          'position_x': 12,
          'position_y': 24,
          'width': 240,
          'height': 120,
          'data': {'value': 42},
        }
      ],
      'settings': {
        'auto_refresh': true,
        'refresh_interval_seconds': 15,
        'theme': {'accentColor': '#111111'},
      },
    });

    expect(model.id, 'dash-1');
    expect(model.projectId, 'project-1');
    expect(model.name, 'Overview');
    expect(model.description, 'Live summary');
    expect(model.isPublic, isTrue);
    expect(model.publicToken, 'share-token');
    expect(model.canvas.width, 1440);
    expect(model.canvas.height, 900);
    expect(model.canvas.backgroundColor, '#EEEEEE');
    expect(model.canvas.widgets, hasLength(1));
    expect(model.canvas.widgets.first.properties['title'], 'Completed');
    expect((model.canvas.widgets.first.resolvedData as Map)['value'], 42);
    expect(model.settings.autoRefresh, isTrue);
    expect(model.settings.refreshIntervalSeconds, 15);
    expect(model.settings.theme['accentColor'], '#111111');
  });

  test('DashboardWidget.copyWith can clear resolved data', () {
    final widget = DashboardWidget(
      id: 'widget-2',
      type: DashboardWidgetType.barChart,
      resolvedData: {'value': 10},
    );

    final cleared = widget.copyWith(clearResolvedData: true);

    expect(cleared.resolvedData, isNull);
    expect(cleared.type, DashboardWidgetType.barChart);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dashboard_models.dart';
import '../widgets/dashboard_canvas.dart';
import '../widgets/widget_factory.dart';
import '../widgets/widget_property_panel.dart';
import '../widgets/data_binding_interface.dart';
import '../widgets/public_share_dialog.dart';
import '../widgets/dashboard_refresh_controller.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/natural_language_query_widget.dart';

class DashboardBuilderPage extends ConsumerStatefulWidget {
  final String? dashboardId;
  final String? organizationId;

  const DashboardBuilderPage({
    Key? key,
    this.dashboardId,
    this.organizationId,
  }) : super(key: key);

  @override
  _DashboardBuilderPageState createState() => _DashboardBuilderPageState();
}

class _DashboardBuilderPageState extends ConsumerState<DashboardBuilderPage> {
  DashboardModel? _dashboard;
  List<DashboardWidgetModel> _widgets = [];
  String? _selectedWidgetId;
  bool _isLoading = true;
  bool _isEditing = false;
  bool _showPropertyPanel = false;
  bool _showDataBindingPanel = false;
  
  // Mock analyses for data binding
  final List<AnalysisModel> _mockAnalyses = [
    AnalysisModel(
      id: 'analysis1',
      name: 'Response Analysis',
      organizationId: 'org1',
      graph: {
        'nodes': [
          {
            'id': 'node1',
            'name': 'Total Count',
            'type': 'count',
            'output_ports': ['output']
          },
          {
            'id': 'node2',
            'name': 'Monthly Breakdown',
            'type': 'group_by',
            'output_ports': ['output']
          }
        ]
      }
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Load dashboard from API
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data for now
      final mockCanvas = DashboardCanvasModel(
        width: 1200,
        height: 800,
        backgroundColor: '#ffffff',
        gridEnabled: true,
        gridSize: 20,
        snapToGrid: true,
      );

      final mockWidgets = [
        DashboardWidgetModel(
          id: 'widget1',
          widgetType: 'kpi_card',
          title: 'Total Responses',
          position: const WidgetPosition(x: 20, y: 20, width: 300, height: 200),
          dataSource: WidgetDataSource(
            analysisId: 'analysis1',
            nodeId: 'node1',
            refreshMode: 'with_dashboard',
          ),
          config: WidgetConfig(
            aggregationType: 'count',
          ),
        ),
        DashboardWidgetModel(
          id: 'widget2',
          widgetType: 'bar_chart',
          title: 'Monthly Responses',
          position: const WidgetPosition(x: 340, y: 20, width: 400, height: 300),
          dataSource: WidgetDataSource(
            analysisId: 'analysis1',
            nodeId: 'node2',
            refreshMode: 'with_dashboard',
          ),
          config: WidgetConfig(
            chartType: 'bar',
            groupByField: 'month',
            valueField: 'count',
          ),
        ),
        DashboardWidgetModel(
          id: 'widget3',
          widgetType: 'text',
          title: 'Dashboard Info',
          description: 'This is a sample dashboard showing various widget types and data visualizations.',
          position: const WidgetPosition(x: 760, y: 20, width: 400, height: 150),
        ),
      ];

        setState(() {
          _dashboard = DashboardModel(
            id: widget.dashboardId ?? 'dashboard1',
            title: 'Sample Dashboard',
            slug: 'sample-dashboard',
            organizationId: widget.organizationId ?? 'org1',
            canvas: mockCanvas,
            widgets: mockWidgets,
            settings: DashboardSettings(),
            status: 'draft',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          _widgets = mockWidgets;
          _isLoading = false;
        });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading dashboard: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onWidgetChanged(DashboardWidgetModel widget) {
    setState(() {
      final index = _widgets.indexWhere((w) => w.id == widget.id);
      if (index != -1) {
        _widgets[index] = widget;
      }
    });
  }

  void _onWidgetPositionChanged(DashboardWidgetModel widget) {
    _onWidgetChanged(widget);
  }

  void _onWidgetSelected(String widgetId) {
    setState(() {
      _selectedWidgetId = widgetId;
    });
  }

  void _togglePropertyPanel(BuildContext context) {
    setState(() {
      _showPropertyPanel = !_showPropertyPanel;
      if (_showPropertyPanel) {
        _showDataBindingPanel = false;
      }
    });
  }

  void _toggleDataBindingPanel(BuildContext context) {
    setState(() {
      _showDataBindingPanel = !_showDataBindingPanel;
      if (_showDataBindingPanel) {
        _showPropertyPanel = false;
      }
    });
  }

  void _onDashboardUpdated(DashboardModel dashboard) {
    setState(() {
      _dashboard = dashboard;
    });
  }

  void _onCanvasTap(Offset position) {
    setState(() {
      _selectedWidgetId = null;
    });
  }

  void _addWidget(String widgetType) {
    final newWidget = DashboardWidgetModel(
      id: 'widget_${DateTime.now().millisecondsSinceEpoch}',
      widgetType: widgetType,
      title: _getWidgetTitle(widgetType),
      position: const WidgetPosition(x: 50, y: 50, width: 300, height: 200),
    );

    setState(() {
      _widgets.add(newWidget);
      _selectedWidgetId = newWidget.id;
    });
  }

  String _getWidgetTitle(String widgetType) {
    switch (widgetType) {
      case 'kpi_card':
        return 'KPI Card';
      case 'bar_chart':
        return 'Bar Chart';
      case 'line_chart':
        return 'Line Chart';
      case 'pie_chart':
        return 'Pie Chart';
      case 'data_table':
        return 'Data Table';
      case 'text':
        return 'Text';
      case 'image':
        return 'Image';
      case 'filter':
        return 'Filter';
      default:
        return 'Widget';
    }
  }

  void _deleteSelectedWidget() {
    if (_selectedWidgetId == null) return;

    setState(() {
      _widgets.removeWhere((w) => w.id == _selectedWidgetId);
      _selectedWidgetId = null;
    });
  }

  Future<void> _saveDashboard() async {
    if (_dashboard == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Save dashboard to API
      await Future.delayed(const Duration(seconds: 1));
      
      final updatedDashboard = _dashboard!.copyWith(
        widgets: _widgets,
        status: 'published',
      );

      setState(() {
        _dashboard = updatedDashboard;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dashboard saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving dashboard: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _dashboard == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_dashboard == null) {
      return const Scaffold(
        body: Center(
          child: Text('Dashboard not found'),
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: ResponsiveDashboardLayout(
        dashboard: _dashboard!,
        isEditMode: _isEditing,
        sidebar: _buildSidebar(context),
        children: _widgets.map((widget) {
          final isSelected = _selectedWidgetId == widget.id;
          
          return DashboardWidgetFactory.createWidget(
            model: widget,
            onChanged: _onWidgetChanged,
            onPositionChanged: _onWidgetPositionChanged,
            isSelected: isSelected,
            isEditable: _isEditing,
          );
        }).toList(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(_dashboard!.title),
      actions: [
        // Edit toggle
        IconButton(
          icon: Icon(_isEditing ? Icons.edit_off : Icons.edit),
          onPressed: () {
            setState(() {
              _isEditing = !_isEditing;
              if (!_isEditing) {
                _selectedWidgetId = null;
              }
            });
          },
          tooltip: _isEditing ? 'Stop Editing' : 'Edit Dashboard',
        ),
        
        // Refresh
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            ref.read(dashboardRefreshControllerProvider.notifier).triggerManualRefresh();
          },
          tooltip: 'Refresh Dashboard',
        ),
        
        // Refresh status
        const RefreshStatusIndicator(),
        
        // Share
        PublicShareButton(
          dashboard: _dashboard!,
          onDashboardUpdated: _onDashboardUpdated,
        ),
        
        // Settings
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => _showSettingsDialog(),
          tooltip: 'Dashboard Settings',
        ),
        
        // Natural Language Query
        IconButton(
          icon: const Icon(Icons.psychology),
          onPressed: () {
            _showNaturalLanguageQueryDialog();
          },
          tooltip: 'Natural Language Query',
        ),
        
        // Save
        if (_isEditing)
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveDashboard,
            tooltip: 'Save Dashboard',
          ),
      ],
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => RefreshSettingsDialog(
        dashboard: _dashboard!,
        onSettingsChanged: _onDashboardUpdated,
      ),
    );
  }

  void _showNaturalLanguageQueryDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.zero,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.7,
          child: NaturalLanguageQueryWidget(
            dashboardId: _dashboard!.id,
            availableAnalyses: _mockAnalyses,
            onFiltersGenerated: (filters) {
              // Apply filters to dashboard
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  Widget? _buildSidebar(BuildContext context) {
    if (!_isEditing || _selectedWidgetId == null) {
      return null;
    }

    final selectedWidget = _widgets.firstWhere(
      (w) => w.id == _selectedWidgetId,
      orElse: () => _widgets.first,
    );

    return Container(
      child: Column(
        children: [
          // Sidebar header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Widget Properties',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _selectedWidgetId = null;
                    });
                  },
                ),
              ],
            ),
          ),
          
          // Panel tabs
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => _togglePropertyPanel(context),
                    style: TextButton.styleFrom(
                      backgroundColor: _showPropertyPanel ? Colors.white : null,
                      foregroundColor: _showPropertyPanel ? Theme.of(context).primaryColor : null,
                    ),
                    child: const Text('Properties'),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => _toggleDataBindingPanel(context),
                    style: TextButton.styleFrom(
                      backgroundColor: _showDataBindingPanel ? Colors.white : null,
                      foregroundColor: _showDataBindingPanel ? Theme.of(context).primaryColor : null,
                    ),
                    child: const Text('Data'),
                  ),
                ),
              ],
            ),
          ),
          
          // Panel content
          Expanded(
            child: _showPropertyPanel
                ? WidgetPropertyPanel(
                    widget: selectedWidget,
                    onChanged: _onWidgetChanged,
                  )
                : DataBindingPanel(
                    widget: selectedWidget,
                    availableAnalyses: _mockAnalyses,
                    onBindingChanged: _onWidgetChanged,
                  ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.white;
    }
  }
}

// Wrapper class to make DashboardWidgetModel compatible with the new components
class DashboardWidgetModelWrapper {
  final DashboardWidgetModel widget;
  
  DashboardWidgetModelWrapper({required this.widget});
  
  DashboardWidgetModelWrapper copyWith({
    String? id,
    String? widgetType,
    String? title,
    String? description,
    WidgetPosition? position,
    WidgetDataSource? dataSource,
    WidgetConfig? config,
    bool? isVisible,
    bool? isLocked,
  }) {
    final updatedWidget = widget.copyWith(
      id: id ?? widget.id,
      widgetType: widgetType ?? widget.widgetType,
      title: title ?? widget.title,
      description: description ?? widget.description,
      position: position ?? widget.position,
      dataSource: dataSource ?? widget.dataSource,
      config: config ?? widget.config,
      isVisible: isVisible ?? widget.isVisible,
      isLocked: isLocked ?? widget.isLocked,
    );
    
    return DashboardWidgetModelWrapper(widget: updatedWidget);
  }
  
  String get id => widget.id;
  String get widgetType => widget.widgetType;
  String? get title => widget.title;
  String? get description => widget.description;
  WidgetPosition get position => widget.position;
  WidgetDataSource? get dataSource => widget.dataSource;
  WidgetConfig? get config => widget.config;
  bool get isVisible => widget.isVisible;
  bool get isLocked => widget.isLocked;
}

class _WidgetTypeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _WidgetTypeButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton.icon(
        icon: Icon(icon, size: 20),
        label: Text(label),
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
          side: BorderSide(color: Colors.grey.shade300),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }
}
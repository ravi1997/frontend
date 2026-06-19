import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dashboard_models.dart';

class WidgetPropertyPanel extends ConsumerStatefulWidget {
  final DashboardWidgetModel widget;
  final Function(DashboardWidgetModel)? onChanged;

  const WidgetPropertyPanel({
    Key? key,
    required this.widget,
    this.onChanged,
  }) : super(key: key);

  @override
  _WidgetPropertyPanelState createState() => _WidgetPropertyPanelState();
}

class _WidgetPropertyPanelState extends ConsumerState<WidgetPropertyPanel> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _widthController;
  late TextEditingController _heightController;
  late TextEditingController _xController;
  late TextEditingController _yController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.widget.title ?? '');
    _descriptionController = TextEditingController(text: widget.widget.description ?? '');
    _widthController = TextEditingController(text: widget.widget.position.width.toString());
    _heightController = TextEditingController(text: widget.widget.position.height.toString());
    _xController = TextEditingController(text: widget.widget.position.x.toString());
    _yController = TextEditingController(text: widget.widget.position.y.toString());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _xController.dispose();
    _yController.dispose();
    super.dispose();
  }

  void _updateWidget() {
    final updatedWidget = widget.widget.copyWith(
      title: _titleController.text.isEmpty ? null : _titleController.text,
      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      position: WidgetPosition(
        x: double.tryParse(_xController.text) ?? widget.widget.position.x,
        y: double.tryParse(_yController.text) ?? widget.widget.position.y,
        width: double.tryParse(_widthController.text) ?? widget.widget.position.width,
        height: double.tryParse(_heightController.text) ?? widget.widget.position.height,
        zIndex: widget.widget.position.zIndex,
      ),
    );

    widget.onChanged?.call(updatedWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Icon(
                  _getWidgetIcon(widget.widget.widgetType),
                  size: 24,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getWidgetTypeName(widget.widget.widgetType),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.widget.id,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Properties
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic Properties
                  _buildSectionTitle('Basic Properties'),
                  const SizedBox(height: 12),
                  
                  _buildTextField(
                    controller: _titleController,
                    label: 'Title',
                    onChanged: _updateWidget,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    maxLines: 3,
                    onChanged: _updateWidget,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Position & Size
                  _buildSectionTitle('Position & Size'),
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _xController,
                          label: 'X Position',
                          keyboardType: TextInputType.number,
                          onChanged: _updateWidget,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _yController,
                          label: 'Y Position',
                          keyboardType: TextInputType.number,
                          onChanged: _updateWidget,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _widthController,
                          label: 'Width',
                          keyboardType: TextInputType.number,
                          onChanged: _updateWidget,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _heightController,
                          label: 'Height',
                          keyboardType: TextInputType.number,
                          onChanged: _updateWidget,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Data Source
                  if (widget.widget.dataSource != null) ...[
                    _buildSectionTitle('Data Source'),
                    const SizedBox(height: 12),
                    
                    _buildInfoRow('Analysis ID', widget.widget.dataSource!.analysisId ?? 'Not set'),
                    const SizedBox(height: 8),
                    _buildInfoRow('Node ID', widget.widget.dataSource!.nodeId ?? 'Not set'),
                    const SizedBox(height: 8),
                    _buildInfoRow('Refresh Mode', widget.widget.dataSource!.refreshMode),
                    
                    const SizedBox(height: 24),
                  ],
                  
                  // Widget-specific properties
                  _buildWidgetSpecificProperties(),
                  
                  const SizedBox(height: 24),
                  
                  // Visibility
                  _buildSectionTitle('Visibility'),
                  const SizedBox(height: 12),
                  
                  SwitchListTile(
                    title: const Text('Visible'),
                    value: widget.widget.isVisible,
                    onChanged: (value) {
                      final updatedWidget = widget.widget.copyWith(isVisible: value);
                      widget.onChanged?.call(updatedWidget);
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  SwitchListTile(
                    title: const Text('Locked'),
                    value: widget.widget.isLocked,
                    onChanged: (value) {
                      final updatedWidget = widget.widget.copyWith(isLocked: value);
                      widget.onChanged?.call(updatedWidget);
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade700,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWidgetSpecificProperties() {
    switch (widget.widget.widgetType) {
      case 'kpi_card':
        return _buildKpiCardProperties();
      case 'bar_chart':
      case 'line_chart':
      case 'pie_chart':
        return _buildChartProperties();
      case 'data_table':
        return _buildDataTableProperties();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildKpiCardProperties() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('KPI Card Properties'),
        const SizedBox(height: 12),
        
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Aggregation Type',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          value: widget.widget.config?.aggregationType ?? 'count',
          items: const [
            DropdownMenuItem(value: 'count', child: Text('Count')),
            DropdownMenuItem(value: 'sum', child: Text('Sum')),
            DropdownMenuItem(value: 'average', child: Text('Average')),
            DropdownMenuItem(value: 'max', child: Text('Maximum')),
            DropdownMenuItem(value: 'min', child: Text('Minimum')),
          ],
          onChanged: (value) {
            if (value != null) {
              final updatedConfig = widget.widget.config?.copyWith(
                aggregationType: value,
              ) ?? WidgetConfig(aggregationType: value);
              
              final updatedWidget = widget.widget.copyWith(config: updatedConfig);
              widget.onChanged?.call(updatedWidget);
            }
          },
        ),
      ],
    );
  }

  Widget _buildChartProperties() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Chart Properties'),
        const SizedBox(height: 12),
        
        DropdownButtonFormField<String?>(
          decoration: const InputDecoration(
            labelText: 'Group By Field',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          value: widget.widget.config?.groupByField,
          items: const [
            DropdownMenuItem(value: null, child: Text('None')),
            DropdownMenuItem(value: 'category', child: Text('Category')),
            DropdownMenuItem(value: 'date', child: Text('Date')),
            DropdownMenuItem(value: 'status', child: Text('Status')),
          ],
          onChanged: (value) {
            final updatedConfig = widget.widget.config?.copyWith(
              groupByField: value,
            ) ?? WidgetConfig(groupByField: value);
            
            final updatedWidget = widget.widget.copyWith(config: updatedConfig);
            widget.onChanged?.call(updatedWidget);
          },
        ),
        
        const SizedBox(height: 12),
        
        DropdownButtonFormField<String?>(
          decoration: const InputDecoration(
            labelText: 'Value Field',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          value: widget.widget.config?.valueField,
          items: const [
            DropdownMenuItem(value: null, child: Text('None')),
            DropdownMenuItem(value: 'count', child: Text('Count')),
            DropdownMenuItem(value: 'amount', child: Text('Amount')),
            DropdownMenuItem(value: 'value', child: Text('Value')),
          ],
          onChanged: (value) {
            final updatedConfig = widget.widget.config?.copyWith(
              valueField: value,
            ) ?? WidgetConfig(valueField: value);
            
            final updatedWidget = widget.widget.copyWith(config: updatedConfig);
            widget.onChanged?.call(updatedWidget);
          },
        ),
      ],
    );
  }

  Widget _buildDataTableProperties() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Data Table Properties'),
        const SizedBox(height: 12),
        
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Display Columns (comma-separated)',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            hintText: 'e.g., name, value, status',
          ),
          initialValue: widget.widget.config?.displayColumns.join(', ') ?? '',
          onChanged: (value) {
            final columns = value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
            final updatedConfig = widget.widget.config?.copyWith(
              displayColumns: columns,
            ) ?? WidgetConfig(displayColumns: columns);
            
            final updatedWidget = widget.widget.copyWith(config: updatedConfig);
            widget.onChanged?.call(updatedWidget);
          },
        ),
      ],
    );
  }

  IconData _getWidgetIcon(String widgetType) {
    switch (widgetType) {
      case 'kpi_card':
        return Icons.dashboard;
      case 'bar_chart':
        return Icons.bar_chart;
      case 'line_chart':
        return Icons.show_chart;
      case 'pie_chart':
        return Icons.pie_chart;
      case 'data_table':
        return Icons.table_chart;
      case 'text':
        return Icons.text_fields;
      case 'image':
        return Icons.image;
      case 'filter':
        return Icons.filter_list;
      default:
        return Icons.widgets;
    }
  }

  String _getWidgetTypeName(String widgetType) {
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
}
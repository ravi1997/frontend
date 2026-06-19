import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_widget.dart';
import '../models/dashboard_models.dart';

class PieChartWidget extends DashboardWidget {
  const PieChartWidget({
    Key? key,
    required DashboardWidgetModel model,
    Function(DashboardWidgetModel)? onChanged,
    Function(DashboardWidgetModel)? onPositionChanged,
    bool isSelected = false,
    bool isEditable = true,
  }) : super(
          key: key,
          model: model,
          onChanged: onChanged,
          onPositionChanged: onPositionChanged,
          isSelected: isSelected,
          isEditable: isEditable,
        );

  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends ConsumerState<PieChartWidget> {
  dynamic _data;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (widget.model.dataSource == null) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // TODO: Implement data loading from API
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _data = {
          'labels': ['Category A', 'Category B', 'Category C', 'Category D'],
          'values': [30, 25, 20, 25],
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget buildWidget(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'Error loading data',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    if (_data == null) {
      return const Center(
        child: Text('No data available'),
      );
    }

    final labels = List<String>.from(_data['labels'] ?? []);
    final values = List<num>.from(_data['values'] ?? []);
    final total = values.fold(0, (sum, value) => sum + value);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart title
          if (widget.model.title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                widget.model.title!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          
          // Chart area
          Expanded(
            child: Row(
              children: [
                // Pie chart
                Expanded(
                  flex: 3,
                  child: CustomPaint(
                    painter: PieChartPainter(
                      values: values.map((v) => v.toDouble()).toList(),
                      colors: _getChartColors(values.length),
                    ),
                  ),
                ),
                
                // Legend
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(labels.length, (index) {
                        final percentage = total > 0 ? (values[index] / total * 100) : 0;
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: _getChartColors(values.length)[index],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${labels[index]} (${percentage.toStringAsFixed(1)}%)',
                                  style: Theme.of(context).textTheme.bodySmall,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getChartColors(int count) {
    final colors = <Color>[
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];
    
    return List.generate(count, (index) => colors[index % colors.length]);
  }
}

class PieChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  PieChartPainter({
    required this.values,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final total = values.fold(0.0, (sum, value) => sum + value);
    if (total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;

    double startAngle = -math.pi / 2; // Start from top

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * 2 * math.pi;
      
      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.fill;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DataTableWidget extends DashboardWidget {
  const DataTableWidget({
    Key? key,
    required DashboardWidgetModel model,
    Function(DashboardWidgetModel)? onChanged,
    Function(DashboardWidgetModel)? onPositionChanged,
    bool isSelected = false,
    bool isEditable = true,
  }) : super(
          key: key,
          model: model,
          onChanged: onChanged,
          onPositionChanged: onPositionChanged,
          isSelected: isSelected,
          isEditable: isEditable,
        );

  @override
  _DataTableWidgetState createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends ConsumerState<DataTableWidget> {
  dynamic _data;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (widget.model.dataSource == null) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // TODO: Implement data loading from API
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _data = {
          'columns': ['Name', 'Value', 'Status'],
          'rows': [
            {'Name': 'Item 1', 'Value': 100, 'Status': 'Active'},
            {'Name': 'Item 2', 'Value': 200, 'Status': 'Inactive'},
            {'Name': 'Item 3', 'Value': 150, 'Status': 'Active'},
            {'Name': 'Item 4', 'Value': 300, 'Status': 'Pending'},
            {'Name': 'Item 5', 'Value': 250, 'Status': 'Active'},
          ],
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget buildWidget(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'Error loading data',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    if (_data == null) {
      return const Center(
        child: Text('No data available'),
      );
    }

    final columns = List<String>.from(_data['columns'] ?? []);
    final rows = List<Map<String, dynamic>>.from(_data['rows'] ?? []);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table title
          if (widget.model.title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                widget.model.title!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          
          // Table
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: columns.map((column) => DataColumn(
                  label: Text(
                    column,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )).toList(),
                rows: rows.map((row) => DataRow(
                  cells: columns.map((column) => DataCell(
                    Text(
                      row[column]?.toString() ?? '',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )).toList(),
                )).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TextWidget extends DashboardWidget {
  const TextWidget({
    Key? key,
    required DashboardWidgetModel model,
    Function(DashboardWidgetModel)? onChanged,
    Function(DashboardWidgetModel)? onPositionChanged,
    bool isSelected = false,
    bool isEditable = true,
  }) : super(
          key: key,
          model: model,
          onChanged: onChanged,
          onPositionChanged: onPositionChanged,
          isSelected: isSelected,
          isEditable: isEditable,
        );

  @override
  _TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends ConsumerState<TextWidget> {
  @override
  Widget buildWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.model.title != null)
            Text(
              widget.model.title!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          
          if (widget.model.description != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.model.description!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}

class ImageWidget extends DashboardWidget {
  const ImageWidget({
    Key? key,
    required DashboardWidgetModel model,
    Function(DashboardWidgetModel)? onChanged,
    Function(DashboardWidgetModel)? onPositionChanged,
    bool isSelected = false,
    bool isEditable = true,
  }) : super(
          key: key,
          model: model,
          onChanged: onChanged,
          onPositionChanged: onPositionChanged,
          isSelected: isSelected,
          isEditable: isEditable,
        );

  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}

class _ImageWidgetState extends ConsumerState<ImageWidget> {
  @override
  Widget buildWidget(BuildContext context) {
    // TODO: Load image from URL or data source
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.model.title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                widget.model.title!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          
          // Placeholder image
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      size: 48,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Image Placeholder',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterWidget extends DashboardWidget {
  const FilterWidget({
    Key? key,
    required DashboardWidgetModel model,
    Function(DashboardWidgetModel)? onChanged,
    Function(DashboardWidgetModel)? onPositionChanged,
    bool isSelected = false,
    bool isEditable = true,
  }) : super(
          key: key,
          model: model,
          onChanged: onChanged,
          onPositionChanged: onPositionChanged,
          isSelected: isSelected,
          isEditable: isEditable,
        );

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends ConsumerState<FilterWidget> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.model.config?.customStyling['default_value'];
  }

  @override
  Widget buildWidget(BuildContext context) {
    // TODO: Load filter options from data source
    final filterOptions = [
      {'label': 'All', 'value': 'all'},
      {'label': 'Option 1', 'value': 'option1'},
      {'label': 'Option 2', 'value': 'option2'},
      {'label': 'Option 3', 'value': 'option3'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.model.title != null)
            Text(
              widget.model.title!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          
          const SizedBox(height: 8),
          
          // Filter dropdown
          DropdownButtonFormField<String>(
            value: _selectedValue,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            hint: const Text('Select filter value'),
            items: filterOptions.map((option) => DropdownMenuItem<String>(
              value: option['value'],
              child: Text(option['label']!),
            )).toList(),
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
              });
              
              // TODO: Apply filter to affected widgets
            },
          ),
        ],
      ),
    );
  }
}
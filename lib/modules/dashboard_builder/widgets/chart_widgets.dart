import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_widget.dart';
import '../models/dashboard_models.dart';

class KpiCardWidget extends DashboardWidget {
  const KpiCardWidget({
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
  _KpiCardWidgetState createState() => _KpiCardWidgetState();
}

class _KpiCardWidgetState extends ConsumerState<KpiCardWidget> {
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
      // For now, use mock data
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _data = {
          'value': 1234,
          'label': 'Total Responses',
          'change': '+12.5%',
          'changeType': 'positive',
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

  Color _getChangeColor(String? changeType) {
    switch (changeType) {
      case 'positive':
        return Colors.green;
      case 'negative':
        return Colors.red;
      default:
        return Colors.grey;
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

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main value
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                _data['value']?.toString() ?? '0',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Label
          Text(
            _data['label'] ?? 'KPI',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // Change indicator
          if (_data['change'] != null)
            Row(
              children: [
                Icon(
                  _data['changeType'] == 'positive' 
                      ? Icons.trending_up 
                      : Icons.trending_down,
                  color: _getChangeColor(_data['changeType']),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  _data['change'],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _getChangeColor(_data['changeType']),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class BarChartWidget extends DashboardWidget {
  const BarChartWidget({
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
  _BarChartWidgetState createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends ConsumerState<BarChartWidget> {
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
          'labels': ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
          'values': [65, 59, 80, 81, 56, 55],
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
    final maxValue = values.isEmpty ? 1 : values.reduce((max, value) => max > value ? max : value);

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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(labels.length, (index) {
                final value = values[index].toDouble();
                final percentage = maxValue > 0 ? value / maxValue : 0;
                
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Bar
                        Container(
                          height: 100 * percentage,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Label
                        Text(
                          labels[index],
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const SizedBox(height: 4),
                        
                        // Value
                        Text(
                          value.toString(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class LineChartWidget extends DashboardWidget {
  const LineChartWidget({
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
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends ConsumerState<LineChartWidget> {
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
          'labels': ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
          'values': [65, 59, 80, 81, 56, 55],
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
            child: CustomPaint(
              painter: LineChartPainter(
                labels: labels,
                values: values.map((v) => v.toDouble()).toList(),
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<String> labels;
  final List<double> values;
  final Color color;

  LineChartPainter({
    required this.labels,
    required this.values,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final padding = 40.0;
    final chartWidth = size.width - 2 * padding;
    final chartHeight = size.height - 2 * padding;
    
    final maxValue = values.reduce((max, value) => max > value ? max : value);
    final minValue = values.reduce((min, value) => min < value ? min : value);
    final valueRange = maxValue - minValue;
    
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    // Draw line
    final path = Path();
    for (int i = 0; i < values.length; i++) {
      final x = padding + (i / (values.length - 1)) * chartWidth;
      final y = padding + (1 - (values[i] - minValue) / valueRange) * chartHeight;
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    canvas.drawPath(path, paint);
    
    // Draw points
    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < values.length; i++) {
      final x = padding + (i / (values.length - 1)) * chartWidth;
      final y = padding + (1 - (values[i] - minValue) / valueRange) * chartHeight;
      
      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
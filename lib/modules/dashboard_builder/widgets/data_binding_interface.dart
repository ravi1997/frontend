import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dashboard_models.dart';

class DataBindingDialog extends ConsumerStatefulWidget {
  final DashboardWidgetModel widget;
  final List<AnalysisModel> availableAnalyses;
  final Function(DashboardWidgetModel)? onBindingChanged;

  const DataBindingDialog({
    Key? key,
    required this.widget,
    required this.availableAnalyses,
    this.onBindingChanged,
  }) : super(key: key);

  @override
  _DataBindingDialogState createState() => _DataBindingDialogState();
}

class _DataBindingDialogState extends ConsumerState<DataBindingDialog> {
  String? _selectedAnalysisId;
  String? _selectedNodeId;
  String _refreshMode = 'with_dashboard';
  int? _refreshInterval;

  @override
  void initState() {
    super.initState();
    _selectedAnalysisId = widget.widget.dataSource?.analysisId;
    _selectedNodeId = widget.widget.dataSource?.nodeId;
    _refreshMode = widget.widget.dataSource?.refreshMode ?? 'with_dashboard';
    _refreshInterval = widget.widget.dataSource?.refreshInterval;
  }

  void _saveBinding() {
    if (_selectedAnalysisId == null || _selectedNodeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both analysis and node'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final updatedDataSource = WidgetDataSource(
      analysisId: _selectedAnalysisId,
      nodeId: _selectedNodeId,
      refreshMode: _refreshMode,
      refreshInterval: _refreshInterval,
    );

    final updatedWidget = widget.widget.copyWith(dataSource: updatedDataSource);
    widget.onBindingChanged?.call(updatedWidget);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Data Binding'),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Analysis Selection
            Text(
              'Select Analysis',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            DropdownButtonFormField<String?>(
              value: _selectedAnalysisId,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              hint: const Text('Choose an analysis'),
              items: widget.availableAnalyses.map((analysis) => DropdownMenuItem<String>(
                value: analysis.id,
                child: Text(analysis.name),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedAnalysisId = value;
                  _selectedNodeId = null; // Reset node selection when analysis changes
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Node Selection
            if (_selectedAnalysisId != null) ...[
              Text(
                'Select Output Node',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              DropdownButtonFormField<String?>(
                value: _selectedNodeId,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                hint: const Text('Choose an output node'),
                items: _getAvailableNodes(_selectedAnalysisId!).map((node) => DropdownMenuItem<String>(
                  value: node.id,
                  child: Text('${node.name} (${node.type})'),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedNodeId = value;
                  });
                },
              ),
              
              const SizedBox(height: 16),
            ],
            
            // Refresh Settings
            Text(
              'Refresh Settings',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            DropdownButtonFormField<String>(
              value: _refreshMode,
              decoration: const InputDecoration(
                labelText: 'Refresh Mode',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: 'with_dashboard', child: Text('With Dashboard')),
                DropdownMenuItem(value: 'independent', child: Text('Independent')),
                DropdownMenuItem(value: 'manual', child: Text('Manual')),
              ],
              onChanged: (value) {
                setState(() {
                  _refreshMode = value!;
                });
              },
            ),
            
            if (_refreshMode == 'independent') ...[
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Refresh Interval (seconds)',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  hintText: 'e.g., 300',
                ),
                keyboardType: TextInputType.number,
                initialValue: _refreshInterval?.toString() ?? '',
                onChanged: (value) {
                  setState(() {
                    _refreshInterval = int.tryParse(value);
                  });
                },
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveBinding,
          child: const Text('Save'),
        ),
      ],
    );
  }

  List<AnalysisNode> _getAvailableNodes(String analysisId) {
    final analysis = widget.availableAnalyses.firstWhere(
      (a) => a.id == analysisId,
      orElse: () => AnalysisModel(id: '', name: '', organizationId: '', graph: {}),
    );
    
    return analysis.outputNodes;
  }
}

class AnalysisModel {
  final String id;
  final String name;
  final String organizationId;
  final Map<String, dynamic> graph;

  AnalysisModel({
    required this.id,
    required this.name,
    required this.organizationId,
    required this.graph,
  });

  List<AnalysisNode> get outputNodes {
    final nodes = graph['nodes'] as List? ?? [];
    return nodes.map((nodeJson) => AnalysisNode.fromJson(nodeJson)).toList();
  }
}

class AnalysisNode {
  final String id;
  final String name;
  final String type;
  final List<String> outputPorts;

  AnalysisNode({
    required this.id,
    required this.name,
    required this.type,
    required this.outputPorts,
  });

  factory AnalysisNode.fromJson(Map<String, dynamic> json) {
    return AnalysisNode(
      id: json['id'],
      name: json['name'] ?? json['id'],
      type: json['type'],
      outputPorts: List<String>.from(json['output_ports'] ?? []),
    );
  }
}

class DataBindingPanel extends ConsumerStatefulWidget {
  final DashboardWidgetModel widget;
  final List<AnalysisModel> availableAnalyses;
  final Function(DashboardWidgetModel)? onBindingChanged;

  const DataBindingPanel({
    Key? key,
    required this.widget,
    required this.availableAnalyses,
    this.onBindingChanged,
  }) : super(key: key);

  @override
  _DataBindingPanelState createState() => _DataBindingPanelState();
}

class _DataBindingPanelState extends ConsumerState<DataBindingPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.link,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Data Binding',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (widget.widget.dataSource != null)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showBindingDialog(),
                  tooltip: 'Edit Binding',
                ),
            ],
          ),
          
          const Divider(),
          
          if (widget.widget.dataSource != null) ...[
            _buildBindingInfo(),
            const SizedBox(height: 16),
            _buildActionButton(),
          ] else ...[
            _buildNoBindingState(),
          ],
        ],
      ),
    );
  }

  Widget _buildBindingInfo() {
    final dataSource = widget.widget.dataSource!;
    final analysis = widget.availableAnalyses.firstWhere(
      (a) => a.id == dataSource.analysisId,
      orElse: () => AnalysisModel(id: '', name: 'Unknown Analysis', organizationId: '', graph: {}),
    );
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Analysis', analysis.name),
        const SizedBox(height: 4),
        _buildInfoRow('Node', dataSource.nodeId ?? 'Unknown'),
        const SizedBox(height: 4),
        _buildInfoRow('Refresh Mode', _formatRefreshMode(dataSource.refreshMode)),
        if (dataSource.refreshInterval != null)
          _buildInfoRow('Refresh Interval', '${dataSource.refreshInterval} seconds'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text('Edit Binding'),
            onPressed: _showBindingDialog,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.unlink),
            label: const Text('Unbind'),
            onPressed: _unbindWidget,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoBindingState() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.link_off,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          Text(
            'No data binding configured',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.add_link),
            label: const Text('Bind to Data'),
            onPressed: _showBindingDialog,
          ),
        ],
      ),
    );
  }

  void _showBindingDialog() {
    showDialog(
      context: context,
      builder: (context) => DataBindingDialog(
        widget: widget.widget,
        availableAnalyses: widget.availableAnalyses,
        onBindingChanged: widget.onBindingChanged,
      ),
    );
  }

  void _unbindWidget() {
    final updatedWidget = widget.widget.copyWith(
      dataSource: null,
    );
    
    widget.onBindingChanged?.call(updatedWidget);
  }

  String _formatRefreshMode(String mode) {
    switch (mode) {
      case 'with_dashboard':
        return 'With Dashboard';
      case 'independent':
        return 'Independent';
      case 'manual':
        return 'Manual';
      default:
        return mode;
    }
  }
}
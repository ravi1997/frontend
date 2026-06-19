"""
lib/modules/analysis_coder/screens/analysis_coder_screen.dart
Main screen for the analysis coder module.
"""

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/analysis_models.dart';
import '../services/analysis_service.dart';
import '../theme/analysis_theme.dart';
import '../widgets/analysis_graph_widget.dart';
import '../widgets/node_palette_widget.dart';
import '../widgets/node_config_dialog.dart';

class AnalysisCoderScreen extends ConsumerStatefulWidget {
  final String projectId;
  final String? analysisId;

  const AnalysisCoderScreen({
    super.key,
    required this.projectId,
    this.analysisId,
  });

  @override
  ConsumerState<AnalysisCoderScreen> createState() => _AnalysisCoderScreenState();
}

class _AnalysisCoderScreenState extends ConsumerState<AnalysisCoderScreen> {
  final AnalysisService _analysisService = AnalysisService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  Analysis? _analysis;
  AnalysisGraph _graph = AnalysisGraph(nodes: [], edges: []);
  AnalysisNode? _selectedNode;
  AnalysisEdge? _selectedEdge;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isExecuting = false;
  bool _showNodePalette = true;
  
  @override
  void initState() {
    super.initState();
    _loadAnalysis();
  }

  Future<void> _loadAnalysis() async {
    try {
      if (widget.analysisId != null) {
        _analysis = await _analysisService.getAnalysis(
          widget.analysisId!,
          projectId: widget.projectId,
        );
        _graph = _analysis!.graph;
      } else {
        // Create new analysis
        _analysis = Analysis(
          id: '',
          orgId: '',
          projectId: widget.projectId,
          name: 'New Analysis',
          description: '',
          linkedFormIds: [],
          executionModes: ['on_demand'],
          schedule: null,
          reactiveDebounceMs: 1000,
          graph: _graph,
          lastRunId: null,
          status: 'idle',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          createdBy: '',
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading analysis: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveAnalysis() async {
    if (_analysis == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final updatedAnalysis = _analysis!.copyWith(graph: _graph);
      
      if (_analysis!.id.isEmpty) {
        // Create new analysis
        _analysis = await _analysisService.createAnalysis(
          projectId: widget.projectId,
          name: _analysis!.name,
          description: _analysis!.description,
          linkedFormIds: _analysis!.linkedFormIds,
          executionModes: _analysis!.executionModes,
          schedule: _analysis!.schedule,
          reactiveDebounceMs: _analysis!.reactiveDebounceMs,
          graph: _graph,
        );
      } else {
        // Update existing analysis
        _analysis = await _analysisService.updateAnalysis(
          analysisId: _analysis!.id,
          projectId: widget.projectId,
          name: _analysis!.name,
          description: _analysis!.description,
          linkedFormIds: _analysis!.linkedFormIds,
          executionModes: _analysis!.executionModes,
          schedule: _analysis!.schedule,
          reactiveDebounceMs: _analysis!.reactiveDebounceMs,
          graph: _graph,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Analysis saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving analysis: $e')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<void> _executeAnalysis() async {
    if (_analysis == null || _analysis!.id.isEmpty) return;

    setState(() {
      _isExecuting = true;
    });

    try {
      final taskId = await _analysisService.executeAnalysis(
        analysisId: _analysis!.id,
        projectId: widget.projectId,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Analysis execution started: $taskId')),
      );

      // TODO: Show execution status dialog
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error executing analysis: $e')),
      );
    } finally {
      setState(() {
        _isExecuting = false;
      });
    }
  }

  void _handleGraphChanged(AnalysisGraph graph) {
    setState(() {
      _graph = graph;
    });
  }

  void _handleNodeSelected(AnalysisNode node) {
    setState(() {
      _selectedNode = node.id.isEmpty ? null : node;
      _selectedEdge = null;
    });
  }

  void _handleEdgeSelected(AnalysisEdge edge) {
    setState(() {
      _selectedEdge = edge.id.isEmpty ? null : edge;
      _selectedNode = null;
    });
  }

  void _handleNodeConfigRequested(AnalysisNode node) {
    showDialog(
      context: context,
      builder: (context) => NodeConfigDialog(
        node: node,
        onConfigChanged: (updatedNode) {
          final updatedNodes = _graph.nodes.map((n) {
            return n.id == updatedNode.id ? updatedNode : n;
          }).toList();
          
          setState(() {
            _graph = _graph.copyWith(nodes: updatedNodes);
          });
        },
      ),
    );
  }

  void _handleNodeAdded(Offset position) {
    // Show node selection dialog
    showDialog(
      context: context,
      builder: (context) => _NodeSelectionDialog(
        onNodeSelected: (nodeDefinition) {
          final newNode = AnalysisNode(
            id: _analysisService.generateNodeId(),
            nodeType: nodeDefinition.type,
            name: nodeDefinition.name,
            description: nodeDefinition.description,
            config: Map<String, dynamic>.from(nodeDefinition.defaultConfig),
            inputPorts: nodeDefinition.inputPorts,
            outputPorts: nodeDefinition.outputPorts,
            position: {'x': position.dx, 'y': position.dy},
          );

          setState(() {
            _graph = _graph.copyWith(
              nodes: [..._graph.nodes, newNode],
            );
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return AnalysisTheme(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _buildAppBar(),
        body: Row(
          children: [
            if (_showNodePalette) _buildNodePalette(),
            Expanded(child: _buildGraph()),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(_analysis?.name ?? 'Analysis Coder'),
      actions: [
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: _isSaving ? null : _saveAnalysis,
          tooltip: 'Save Analysis',
        ),
        IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: _isExecuting ? null : _executeAnalysis,
          tooltip: 'Execute Analysis',
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'settings':
                _showSettingsDialog();
                break;
              case 'export':
                _showExportDialog();
                break;
              case 'history':
                _showHistoryDialog();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'settings',
              child: Text('Settings'),
            ),
            const PopupMenuItem(
              value: 'export',
              child: Text('Export'),
            ),
            const PopupMenuItem(
              value: 'history',
              child: Text('Execution History'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNodePalette() {
    return NodePaletteWidget(
      nodeDefinitions: _getNodeDefinitions(),
      onNodeSelected: (nodeDefinition, position) {
        final newNode = AnalysisNode(
          id: _analysisService.generateNodeId(),
          nodeType: nodeDefinition.type,
          name: nodeDefinition.name,
          description: nodeDefinition.description,
          config: Map<String, dynamic>.from(nodeDefinition.defaultConfig),
          inputPorts: nodeDefinition.inputPorts,
          outputPorts: nodeDefinition.outputPorts,
          position: {'x': position.dx, 'y': position.dy},
        );

        setState(() {
          _graph = _graph.copyWith(
            nodes: [..._graph.nodes, newNode],
          );
        });
      },
    );
  }

  Widget _buildGraph() {
    return AnalysisGraphWidget(
      graph: _graph,
      onGraphChanged: _handleGraphChanged,
      onNodeSelected: _handleNodeSelected,
      onEdgeSelected: _handleEdgeSelected,
      onConfigRequested: _handleNodeConfigRequested,
      selectedNode: _selectedNode,
      selectedEdge: _selectedEdge,
      onNodeAdded: _handleNodeAdded,
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          _showNodePalette = !_showNodePalette;
        });
      },
      child: Icon(_showNodePalette ? Icons.visibility_off : Icons.visibility),
    );
  }

  List<NodeDefinition> _getNodeDefinitions() {
    // Return all available node definitions
    return [
      // Data Sources
      NodeDefinition(
        type: 'form_responses',
        name: 'Form Responses',
        description: 'Load responses from a form',
        category: NodeCategory.dataSource,
        icon: Icons.description,
        inputPorts: [],
        outputPorts: [
          NodePort(id: 'output', label: 'Responses', dataType: 'dataframe'),
        ],
        defaultConfig: {'form_id': '', 'branch': 'main'},
        properties: [
          NodeProperty(
            key: 'form_id',
            label: 'Form ID',
            type: 'string',
            required: true,
          ),
          NodeProperty(
            key: 'branch',
            label: 'Branch',
            type: 'string',
            default: 'main',
            options: ['main', 'develop'],
          ),
        ],
      ),
      NodeDefinition(
        type: 'csv_upload',
        name: 'CSV Upload',
        description: 'Upload and parse a CSV file',
        category: NodeCategory.dataSource,
        icon: Icons.upload_file,
        inputPorts: [],
        outputPorts: [
          NodePort(id: 'output', label: 'Data', dataType: 'dataframe'),
        ],
        defaultConfig: {'file_path': '', 'delimiter': ','},
        properties: [
          NodeProperty(
            key: 'file_path',
            label: 'File Path',
            type: 'string',
            required: true,
          ),
          NodeProperty(
            key: 'delimiter',
            label: 'Delimiter',
            type: 'string',
            default: ',',
          ),
        ],
      ),
      // Transforms
      NodeDefinition(
        type: 'filter',
        name: 'Filter',
        description: 'Filter rows by condition',
        category: NodeCategory.transform,
        icon: Icons.filter_list,
        inputPorts: [
          NodePort(id: 'input', label: 'Input', dataType: 'dataframe'),
        ],
        outputPorts: [
          NodePort(id: 'output', label: 'Filtered', dataType: 'dataframe'),
        ],
        defaultConfig: {'condition': ''},
        properties: [
          NodeProperty(
            key: 'condition',
            label: 'Condition',
            type: 'string',
            required: true,
          ),
        ],
      ),
      NodeDefinition(
        type: 'sort',
        name: 'Sort',
        description: 'Sort rows by column',
        category: NodeCategory.transform,
        icon: Icons.sort,
        inputPorts: [
          NodePort(id: 'input', label: 'Input', dataType: 'dataframe'),
        ],
        outputPorts: [
          NodePort(id: 'output', label: 'Sorted', dataType: 'dataframe'),
        ],
        defaultConfig: {'column': '', 'ascending': true},
        properties: [
          NodeProperty(
            key: 'column',
            label: 'Column',
            type: 'string',
            required: true,
          ),
          NodeProperty(
            key: 'ascending',
            label: 'Ascending',
            type: 'boolean',
            default: true,
          ),
        ],
      ),
      // Aggregations
      NodeDefinition(
        type: 'count',
        name: 'Count',
        description: 'Count rows',
        category: NodeCategory.aggregation,
        icon: Icons.tag,
        inputPorts: [
          NodePort(id: 'input', label: 'Input', dataType: 'dataframe'),
        ],
        outputPorts: [
          NodePort(id: 'output', label: 'Count', dataType: 'number'),
        ],
        defaultConfig: {},
        properties: [],
      ),
      NodeDefinition(
        type: 'sum',
        name: 'Sum',
        description: 'Sum a numeric column',
        category: NodeCategory.aggregation,
        icon: Icons.calculate,
        inputPorts: [
          NodePort(id: 'input', label: 'Input', dataType: 'dataframe'),
        ],
        outputPorts: [
          NodePort(id: 'output', label: 'Sum', dataType: 'number'),
        ],
        defaultConfig: {'column': ''},
        properties: [
          NodeProperty(
            key: 'column',
            label: 'Column',
            type: 'string',
            required: true,
          ),
        ],
      ),
      // Outputs
      NodeDefinition(
        type: 'table_output',
        name: 'Table',
        description: 'Display data as table',
        category: NodeCategory.output,
        icon: Icons.table_chart,
        inputPorts: [
          NodePort(id: 'input', label: 'Data', dataType: 'dataframe'),
        ],
        outputPorts: [],
        defaultConfig: {'title': 'Data Table'},
        properties: [
          NodeProperty(
            key: 'title',
            label: 'Title',
            type: 'string',
            default: 'Data Table',
          ),
        ],
      ),
      NodeDefinition(
        type: 'kpi_value',
        name: 'KPI Value',
        description: 'Display a single KPI value',
        category: NodeCategory.output,
        icon: Icons.speed,
        inputPorts: [
          NodePort(id: 'input', label: 'Value', dataType: 'number'),
        ],
        outputPorts: [],
        defaultConfig: {'title': 'KPI', 'format': '0.0'},
        properties: [
          NodeProperty(
            key: 'title',
            label: 'Title',
            type: 'string',
            default: 'KPI',
          ),
          NodeProperty(
            key: 'format',
            label: 'Format',
            type: 'string',
            default: '0.0',
          ),
        ],
      ),
    ];
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Analysis Settings',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Analysis Name',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: _analysis?.name ?? ''),
                onChanged: (value) {
                  if (_analysis != null) {
                    setState(() {
                      _analysis = _analysis!.copyWith(name: value);
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: _analysis?.description ?? ''),
                onChanged: (value) {
                  if (_analysis != null) {
                    setState(() {
                      _analysis = _analysis!.copyWith(description: value);
                    });
                  }
                },
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExportDialog() {
    // TODO: Implement export dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export functionality coming soon')),
    );
  }

  void _showHistoryDialog() {
    // TODO: Implement history dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Execution history coming soon')),
    );
  }
}

class _NodeSelectionDialog extends StatelessWidget {
  final Function(NodeDefinition) onNodeSelected;

  const _NodeSelectionDialog({required this.onNodeSelected});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        height: 600,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Node',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            // TODO: Implement node selection UI
            const Expanded(
              child: Center(
                child: Text('Node selection UI coming soon'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
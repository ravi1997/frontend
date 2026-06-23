// lib/modules/analysis_coder/screens/analysis_coder_screen.dart
// Interactive canvas and properties editor for visual DAG analysis pipelines.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/networking/dio_provider.dart';

import '../models/analysis_models.dart';
import '../models/node_types.dart';
import '../services/analysis_service.dart';
import '../providers/analysis_provider.dart';

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
  // Graph state
  String _analysisName = 'New Analysis';
  String _analysisDescription = 'Created via visual builder';
  String? _currentAnalysisId;
  List<AnalysisNode> _nodes = [];
  List<AnalysisEdge> _edges = [];
  
  // Selection and UI state
  String? _selectedNodeId;
  String? _connectingNodeId;
  String? _connectingPortId;
  bool _isConnectingOutput = false; // true if connection started from output port
  
  // Execution state
  bool _isSaving = false;
  bool _isRunning = false;
  String? _currentRunId;
  String _runStatus = 'idle';
  String? _errorMessage;
  List<AnalysisResult> _results = [];
  
  // List of forms in project for configuration dropdowns
  List<dynamic> _projectForms = [];
  bool _isLoadingForms = false;

  @override
  void initState() {
    super.initState();
    _currentAnalysisId = widget.analysisId;
    _loadProjectForms();
    _loadAnalysis();
  }

  Future<void> _loadProjectForms() async {
    setState(() => _isLoadingForms = true);
    try {
      final client = ref.read(apiClientProvider);
      final forms = await client.listProjectForms(widget.projectId);
      setState(() {
        _projectForms = forms;
        _isLoadingForms = false;
      });
    } catch (e) {
      setState(() => _isLoadingForms = false);
    }
  }

  Future<void> _loadAnalysis() async {
    if (_currentAnalysisId == null) {
      // Create template DAG
      setState(() {
        _nodes = [
          AnalysisNode(
            id: 'node_responses',
            nodeType: 'form_responses',
            name: 'Source Responses',
            description: 'Get responses from selected form',
            config: {'form_id': ''},
            inputPorts: [],
            outputPorts: [NodePort(id: 'output', name: 'Responses', dataType: 'dataframe', isRequired: true)],
            position: {'x': 100.0, 'y': 150.0},
          ),
          AnalysisNode(
            id: 'node_table',
            nodeType: 'table_output',
            name: 'Table Output',
            description: 'Render tabular view of the outputs',
            config: {'title': 'Results Table'},
            inputPorts: [NodePort(id: 'input', name: 'Data', dataType: 'dataframe', isRequired: true)],
            outputPorts: [],
            position: {'x': 500.0, 'y': 150.0},
          ),
        ];
        _edges = [
          AnalysisEdge(
            id: 'edge_init',
            source: 'node_responses',
            target: 'node_table',
            sourcePort: 'output',
            targetPort: 'input',
          )
        ];
      });
      return;
    }

    try {
      final service = ref.read(analysisServiceProvider);
      final analysis = await service.getAnalysis(_currentAnalysisId!, projectId: widget.projectId);
      if (analysis != null) {
        setState(() {
          _analysisName = analysis.name;
          _analysisDescription = analysis.description ?? '';
          _nodes = analysis.graph.nodes;
          _edges = analysis.graph.edges;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load analysis graph: $e';
      });
    }
  }

  Future<void> _saveGraph() async {
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final service = ref.read(analysisServiceProvider);
    final graph = AnalysisGraph(nodes: _nodes, edges: _edges);

    try {
      if (_currentAnalysisId == null) {
        final analysis = await service.createAnalysis(
          projectId: widget.projectId,
          name: _analysisName,
          description: _analysisDescription,
          graph: graph,
        );
        setState(() {
          _currentAnalysisId = analysis.id;
          _isSaving = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Analysis DAG created successfully')),
        );
      } else {
        await service.updateAnalysis(
          analysisId: _currentAnalysisId!,
          projectId: widget.projectId,
          name: _analysisName,
          description: _analysisDescription,
          graph: graph,
        );
        setState(() => _isSaving = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Analysis DAG updated successfully')),
        );
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
        _errorMessage = 'Validation or save failed:\n$e';
      });
    }
  }

  Future<void> _runAnalysis() async {
    await _saveGraph();
    if (_errorMessage != null) return; // Stop if saving/validation failed

    setState(() {
      _isRunning = true;
      _runStatus = 'running';
      _results = [];
    });

    final service = ref.read(analysisServiceProvider);
    try {
      final runInfo = await service.executeAnalysis(widget.projectId, _currentAnalysisId!);
      final runId = runInfo['run_id'] ?? runInfo['task_id'];
      if (runId != null) {
        setState(() {
          _currentRunId = runId;
        });
        _pollRunStatus(runId);
      } else {
        setState(() {
          _isRunning = false;
          _runStatus = 'failed';
          _errorMessage = 'No execution run ID returned from backend.';
        });
      }
    } catch (e) {
      setState(() {
        _isRunning = false;
        _runStatus = 'failed';
        _errorMessage = 'Execution failed: $e';
      });
    }
  }

  void _pollRunStatus(String runId) {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      try {
        final service = ref.read(analysisServiceProvider);
        final runData = await service.getAnalysisRun(widget.projectId, _currentAnalysisId!, runId);
        
        final status = runData['run']?['status'] ?? runData['status'] ?? 'pending';
        if (status == 'completed' || status == 'success') {
          timer.cancel();
          final resultsRaw = runData['results'] as List? ?? [];
          final parsedResults = resultsRaw.map((e) => AnalysisResult.fromJson(Map<String, dynamic>.from(e))).toList();
          setState(() {
            _runStatus = 'completed';
            _isRunning = false;
            _results = parsedResults;
          });
        } else if (status == 'failed') {
          timer.cancel();
          setState(() {
            _runStatus = 'failed';
            _isRunning = false;
            _errorMessage = runData['run']?['error_summary'] ?? 'Run failed on the engine.';
          });
        }
      } catch (e) {
        timer.cancel();
        setState(() {
          _runStatus = 'failed';
          _isRunning = false;
          _errorMessage = 'Failed to poll run status: $e';
        });
      }
    });
  }

  void _addNode(NodeDefinition def) {
    final newId = AnalysisHelpers.generateNodeId();
    final newNode = AnalysisNode(
      id: newId,
      nodeType: def.type,
      name: def.name,
      description: def.description,
      config: Map<String, dynamic>.from(def.defaultConfig),
      inputPorts: List<NodePort>.from(def.inputPorts),
      outputPorts: List<NodePort>.from(def.outputPorts),
      position: {'x': 250.0, 'y': 200.0},
    );
    setState(() {
      _nodes.add(newNode);
      _selectedNodeId = newId;
    });
  }

  void _deleteNode(String nodeId) {
    setState(() {
      _nodes.removeWhere((node) => node.id == nodeId);
      _edges.removeWhere((edge) => edge.source == nodeId || edge.target == nodeId);
      if (_selectedNodeId == nodeId) {
        _selectedNodeId = null;
      }
    });
  }

  void _handlePortTap(String nodeId, String portId, bool isOutput) {
    if (_connectingNodeId == null) {
      // Start connection
      setState(() {
        _connectingNodeId = nodeId;
        _connectingPortId = portId;
        _isConnectingOutput = isOutput;
      });
    } else {
      // Finish connection
      final sourceId = _isConnectingOutput ? _connectingNodeId! : nodeId;
      final sourcePort = _isConnectingOutput ? _connectingPortId! : portId;
      final targetId = _isConnectingOutput ? nodeId : _connectingNodeId!;
      final targetPort = _isConnectingOutput ? portId : _connectingPortId!;

      // Validate connection
      if (sourceId != targetId && _isConnectingOutput != isOutput) {
        // Prevent duplicate edges
        final edgeExists = _edges.any((e) =>
            e.source == sourceId &&
            e.target == targetId &&
            e.sourcePort == sourcePort &&
            e.targetPort == targetPort);

        if (!edgeExists) {
          setState(() {
            _edges.add(AnalysisEdge(
              id: AnalysisHelpers.generateEdgeId(),
              source: sourceId,
              target: targetId,
              sourcePort: sourcePort,
              targetPort: targetPort,
            ));
          });
        }
      }
      // Reset connection state
      setState(() {
        _connectingNodeId = null;
        _connectingPortId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161622),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _analysisName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              'Visual DAG Builder • Project ${widget.projectId}',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            tooltip: 'Rename Analysis',
            onPressed: _showRenameDialog,
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
            ),
            icon: _isSaving
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.save),
            label: const Text('Save'),
            onPressed: _isSaving ? null : _saveGraph,
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            icon: _isRunning
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.play_arrow),
            label: const Text('Run Pipeline'),
            onPressed: _isRunning ? null : _runAnalysis,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          // Sidebar: Library
          _buildLibrarySidebar(theme),
          
          // Canvas & Live Preview Split
          Expanded(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      // Grid background & connecting lines
                      CustomPaint(
                        painter: GridAndEdgesPainter(_nodes, _edges, _connectingNodeId, _connectingPortId, _isConnectingOutput),
                        child: Container(),
                      ),
                      
                      // Drag/Drop Node Cards
                      ..._nodes.map((node) => _buildNodeCard(node, theme)),
                    ],
                  ),
                ),
                
                // Execution Log & Output Results Panel
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF161622),
                      border: Border(top: BorderSide(color: Color(0xFF2E2E3E), width: 1.5)),
                    ),
                    child: _buildResultsPanel(theme),
                  ),
                )
              ],
            ),
          ),
          
          // Properties Panel
          _buildPropertiesSidebar(theme),
        ],
      ),
    );
  }

  Widget _buildLibrarySidebar(ThemeData theme) {
    final libraryNodes = NodeLibrary.getNodes();
    
    return Container(
      width: 220,
      decoration: const BoxDecoration(
        color: Color(0xFF161622),
        border: Border(right: BorderSide(color: Color(0xFF2E2E3E))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Node Library',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
            ),
          ),
          const Divider(color: Color(0xFF2E2E3E)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildLibrarySection('Data Sources', libraryNodes.where((n) => n.category == NodeCategory.dataSource), Colors.orange),
                _buildLibrarySection('Transforms', libraryNodes.where((n) => n.category == NodeCategory.transform), Colors.blue),
                _buildLibrarySection('Aggregations', libraryNodes.where((n) => n.category == NodeCategory.aggregation), Colors.teal),
                _buildLibrarySection('Outputs', libraryNodes.where((n) => n.category == NodeCategory.output), Colors.green),
                _buildLibrarySection('LLM AI', libraryNodes.where((n) => n.category == NodeCategory.llm), Colors.purple),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLibrarySection(String title, Iterable<NodeDefinition> items, Color accent) {
    if (items.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
          child: Text(title, style: TextStyle(color: accent, fontSize: 11, fontWeight: FontWeight.w600)),
        ),
        ...items.map((node) => Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: InkWell(
            onTap: () => _addNode(node),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF2E2E3E)),
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFF1E1E2C),
              ),
              child: Row(
                children: [
                  Icon(Icons.add_box, size: 16, color: accent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      node.name,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildNodeCard(AnalysisNode node, ThemeData theme) {
    final isSelected = _selectedNodeId == node.id;
    final pos = node.position;
    final double x = pos['x'] ?? 100.0;
    final double y = pos['y'] ?? 100.0;

    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            node.position['x'] = (node.position['x'] ?? 0) + details.delta.dx;
            node.position['y'] = (node.position['y'] ?? 0) + details.delta.dy;
          });
        },
        onTap: () {
          setState(() {
            _selectedNodeId = node.id;
          });
        },
        child: Container(
          width: 180,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFF6C63FF) : const Color(0xFF2E2E3E),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Node Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: const BoxDecoration(
                  color: Color(0xFF161622),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
                ),
                child: Row(
                  children: [
                    _getCategoryIcon(node.nodeType),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        node.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 14, color: Colors.redAccent),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _deleteNode(node.id),
                    )
                  ],
                ),
              ),
              
              // Node body details
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  node.description.isNotEmpty ? node.description : node.nodeType,
                  style: const TextStyle(color: Colors.grey, fontSize: 9),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Inputs / Outputs Ports Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Inputs (Left)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: node.inputPorts.map((port) => _buildPortCircle(node.id, port, false)).toList(),
                    ),
                    
                    // Outputs (Right)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: node.outputPorts.map((port) => _buildPortCircle(node.id, port, true)).toList(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortCircle(String nodeId, NodePort port, bool isOutput) {
    final isConnectingThis = _connectingNodeId == nodeId && _connectingPortId == port.id;

    return GestureDetector(
      onTap: () => _handlePortTap(nodeId, port.id, isOutput),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFF161622),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isOutput) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isConnectingThis ? Colors.yellow : Colors.blue,
                ),
              ),
              const SizedBox(width: 4),
            ],
            Text(port.name, style: const TextStyle(fontSize: 8, color: Colors.white70)),
            if (isOutput) ...[
              const SizedBox(width: 4),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isConnectingThis ? Colors.yellow : Colors.green,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildPropertiesSidebar(ThemeData theme) {
    if (_selectedNodeId == null) {
      return Container(
        width: 260,
        decoration: const BoxDecoration(
          color: Color(0xFF161622),
          border: Border(left: BorderSide(color: Color(0xFF2E2E3E))),
        ),
        child: const Center(
          child: Text('Select a node to edit settings', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    final selectedNode = _nodes.firstWhere((n) => n.id == _selectedNodeId);
    final def = NodeLibrary.getNodes().firstWhere((n) => n.type == selectedNode.nodeType);

    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: Color(0xFF161622),
        border: Border(left: BorderSide(color: Color(0xFF2E2E3E))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Node Properties', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey, size: 16),
                  onPressed: () => setState(() => _selectedNodeId = null),
                )
              ],
            ),
          ),
          const Divider(color: Color(0xFF2E2E3E)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(selectedNode.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Type: ${selectedNode.nodeType}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 16),
                ...def.properties.map((prop) => _buildPropertyField(selectedNode, prop)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPropertyField(AnalysisNode node, NodeProperty prop) {
    if (prop.key == 'form_id') {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(prop.label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
            const SizedBox(height: 4),
            _isLoadingForms
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : DropdownButtonFormField<String>(
                    dropdownColor: const Color(0xFF1E1E2C),
                    value: node.config[prop.key]?.toString().isEmpty ?? true ? null : node.config[prop.key],
                    items: _projectForms.map<DropdownMenuItem<String>>((form) {
                      return DropdownMenuItem<String>(
                        value: form['id']?.toString() ?? '',
                        child: Text(
                          form['title']?.toString() ?? 'Form',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        node.config[prop.key] = val;
                      });
                    },
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                  ),
          ],
        ),
      );
    }

    if (prop.type == 'enum_') {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(prop.label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              dropdownColor: const Color(0xFF1E1E2C),
              value: node.config[prop.key] ?? prop.defaultValue,
              items: (prop.options ?? []).map<DropdownMenuItem<String>>((opt) {
                return DropdownMenuItem<String>(
                  value: opt.toString(),
                  child: Text(opt.toString(), style: const TextStyle(color: Colors.white, fontSize: 12)),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  node.config[prop.key] = val;
                });
              },
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
            ),
          ],
        ),
      );
    }

    // Default string/text input
    final controller = TextEditingController(text: node.config[prop.key]?.toString() ?? '');
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(prop.label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            onChanged: (val) {
              node.config[prop.key] = val;
            },
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsPanel(ThemeData theme) {
    if (_errorMessage != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        color: const Color(0xFF2D1E2A),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.error, color: Colors.redAccent),
                SizedBox(width: 8),
                Text('Validation / Execution Error', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(fontFamily: 'Courier', color: Colors.white70, fontSize: 11),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_isRunning) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Color(0xFF6C63FF)),
            const SizedBox(height: 12),
            Text('Executing DAG Pipeline on Flask Engine (Status: $_runStatus)...', style: const TextStyle(color: Colors.white)),
            Text('Active Run: ${_currentRunId ?? "Queued"}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      );
    }

    if (_results.isEmpty) {
      return const Center(
        child: Text('Pipeline idle. Setup nodes and click "Run Pipeline" to compute output.', style: TextStyle(color: Colors.grey)),
      );
    }

    // Display output tables/KPIs
    return DefaultTabController(
      length: _results.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: const Color(0xFF11111A),
            child: TabBar(
              isScrollable: true,
              indicatorColor: const Color(0xFF6C63FF),
              tabs: _results.map((res) {
                final sourceNode = _nodes.firstWhere((n) => n.id == res.nodeId, orElse: () => _nodes.first);
                return Tab(
                  child: Row(
                    children: [
                      const Icon(Icons.table_chart, size: 14),
                      const SizedBox(width: 6),
                      Text(sourceNode.name),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: _results.map((res) => _buildResultView(res)).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildResultView(AnalysisResult result) {
    final columns = result.columnDefinitions;
    final List<dynamic> rows = result.data['rows'] as List? ?? [];

    if (rows.isEmpty) {
      return const Center(
        child: Text('No data output from this node', style: TextStyle(color: Colors.grey)),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(const Color(0xFF161622)),
          dataRowColor: MaterialStateProperty.all(const Color(0xFF1E1E2C)),
          columns: columns.map<DataColumn>((col) {
            return DataColumn(
              label: Text(
                col['name']?.toString() ?? col['id']?.toString() ?? 'Col',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
          rows: rows.map<DataRow>((row) {
            final rowMap = Map<String, dynamic>.from(row as Map);
            return DataRow(
              cells: columns.map<DataCell>((col) {
                final key = col['id']?.toString() ?? col['name']?.toString() ?? '';
                final val = rowMap[key]?.toString() ?? '';
                return DataCell(
                  Text(val, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _getCategoryIcon(String type) {
    if (type.contains('responses') || type.contains('csv')) {
      return const Icon(Icons.storage, size: 14, color: Colors.orange);
    } else if (type.contains('filter') || type.contains('group')) {
      return const Icon(Icons.transform, size: 14, color: Colors.blue);
    } else if (type.contains('sum') || type.contains('count')) {
      return const Icon(Icons.functions, size: 14, color: Colors.teal);
    } else if (type.contains('llm')) {
      return const Icon(Icons.psychology, size: 14, color: Colors.purple);
    } else {
      return const Icon(Icons.table_view, size: 14, color: Colors.green);
    }
  }

  void _showRenameDialog() {
    final controller = TextEditingController(text: _analysisName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C),
          title: const Text('Rename Analysis', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Enter name',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF)),
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  _analysisName = controller.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// Painter to draw grid dots and connection curves between nodes
class GridAndEdgesPainter extends CustomPainter {
  final List<AnalysisNode> nodes;
  final List<AnalysisEdge> edges;
  final String? connectingNodeId;
  final String? connectingPortId;
  final bool isConnectingOutput;

  GridAndEdgesPainter(this.nodes, this.edges, this.connectingNodeId, this.connectingPortId, this.isConnectingOutput);

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Grid Dots
    final paintGrid = Paint()..color = const Color(0xFF2E2E3E).withOpacity(0.4);
    for (double x = 0; x < size.width; x += 20) {
      for (double y = 0; y < size.height; y += 20) {
        canvas.drawCircle(Offset(x, y), 1, paintGrid);
      }
    }

    // 2. Draw Connected Edges
    final edgePaint = Paint()
      ..color = const Color(0xFF6C63FF)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (final edge in edges) {
      final sourceNode = nodes.firstWhere((n) => n.id == edge.source, orElse: () => _nullNode());
      final targetNode = nodes.firstWhere((n) => n.id == edge.target, orElse: () => _nullNode());

      if (sourceNode.id.isNotEmpty && targetNode.id.isNotEmpty) {
        final start = _getPortOffset(sourceNode, edge.sourcePort, true);
        final end = _getPortOffset(targetNode, edge.targetPort, false);
        _drawConnectionCurve(canvas, start, end, edgePaint);
      }
    }
  }

  static AnalysisNode _nullNode() => AnalysisNode(
        id: '',
        nodeType: '',
        name: '',
        description: '',
        config: {},
        inputPorts: [],
        outputPorts: [],
        position: {},
      );

  Offset _getPortOffset(AnalysisNode node, String portId, bool isOutput) {
    final x = node.position['x'] ?? 0;
    final y = node.position['y'] ?? 0;

    // Estimate relative offsets based on typical card layout
    // Card width = 180
    // Port column: Inputs are on left edge (0), Outputs are on right edge (180)
    final double relativeX = isOutput ? 180 : 0;
    
    // Estimate Y offset: Header = 32px. Ports start at +50px, each is around 24px.
    final ports = isOutput ? node.outputPorts : node.inputPorts;
    final idx = ports.indexWhere((p) => p.id == portId);
    final double relativeY = 50.0 + (idx >= 0 ? idx * 24.0 : 0.0);

    return Offset(x + relativeX, y + relativeY);
  }

  void _drawConnectionCurve(Canvas canvas, Offset start, Offset end, Paint paint) {
    final path = Path();
    path.moveTo(start.dx, start.dy);
    
    // Control points for cubic bezier curve
    final controlOffset = (end.dx - start.dx).abs() / 2;
    path.cubicTo(
      start.dx + controlOffset, start.dy,
      end.dx - controlOffset, end.dy,
      end.dx, end.dy,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

"""
lib/modules/analysis_coder/widgets/analysis_graph_widget.dart
Main widget for the analysis graph canvas.
"""

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/analysis_models.dart';
import '../theme/analysis_theme.dart';
import 'analysis_node_widget.dart';
import 'analysis_edge_widget.dart';

class AnalysisGraphWidget extends StatefulWidget {
  final AnalysisGraph graph;
  final Function(AnalysisGraph) onGraphChanged;
  final Function(AnalysisNode) onNodeSelected;
  final Function(AnalysisEdge) onEdgeSelected;
  final Function(AnalysisNode) onConfigRequested;
  final AnalysisNode? selectedNode;
  final AnalysisEdge? selectedEdge;
  final Function(Offset) onNodeAdded;

  const AnalysisGraphWidget({
    super.key,
    required this.graph,
    required this.onGraphChanged,
    required this.onNodeSelected,
    required this.onEdgeSelected,
    required this.onConfigRequested,
    this.selectedNode,
    this.selectedEdge,
    required this.onNodeAdded,
  });

  @override
  State<AnalysisGraphWidget> createState() => _AnalysisGraphWidgetState();
}

class _AnalysisGraphWidgetState extends State<AnalysisGraphWidget> {
  final Map<String, GlobalKey> _nodeKeys = {};
  final Map<String, Offset> _portPositions = {};
  AnalysisNode? _connectingSourceNode;
  String? _connectingSourcePortId;
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    _initializeNodeKeys();
  }

  void _initializeNodeKeys() {
    for (final node in widget.graph.nodes) {
      _nodeKeys[node.id] = GlobalKey();
    }
  }

  void _handleNodeChanged(AnalysisNode updatedNode) {
    final updatedNodes = widget.graph.nodes.map((node) {
      return node.id == updatedNode.id ? updatedNode : node;
    }).toList();

    final updatedGraph = widget.graph.copyWith(nodes: updatedNodes);
    widget.onGraphChanged(updatedGraph);
  }

  void _handleNodeMoved(AnalysisNode node, Offset position) {
    final updatedNode = node.copyWith(
      position: {'x': position.dx, 'y': position.dy},
    );
    _handleNodeChanged(updatedNode);
  }

  void _handleNodeDeleted(AnalysisNode node) {
    // Remove all edges connected to this node
    final updatedEdges = widget.graph.edges.where((edge) {
      return edge.source != node.id && edge.target != node.id;
    }).toList();

    final updatedNodes = widget.graph.nodes.where((n) => n.id != node.id).toList();

    final updatedGraph = widget.graph.copyWith(
      nodes: updatedNodes,
      edges: updatedEdges,
    );

    widget.onGraphChanged(updatedGraph);

    if (widget.selectedNode?.id == node.id) {
      widget.onNodeSelected(const AnalysisNode(
        id: '',
        nodeType: '',
        name: '',
        description: '',
        config: {},
        inputPorts: [],
        outputPorts: [],
        position: {},
      ));
    }
  }

  void _handleEdgeDeleted(AnalysisEdge edge) {
    final updatedEdges = widget.graph.edges.where((e) {
      return e.source != edge.source || e.target != edge.target;
    }).toList();

    final updatedGraph = widget.graph.copyWith(edges: updatedEdges);
    widget.onGraphChanged(updatedGraph);

    if (widget.selectedEdge?.id == edge.id) {
      widget.onEdgeSelected(const AnalysisEdge(
        id: '',
        source: '',
        target: '',
        sourcePort: '',
        targetPort: '',
      ));
    }
  }

  void _handlePortTap(
    String nodeId,
    String portId,
    bool isInput,
  ) {
    if (!_isConnecting) {
      // Start connection
      final node = widget.graph.nodes.firstWhere((n) => n.id == nodeId);
      if (isInput) {
        // Can only connect from output ports
        return;
      }

      setState(() {
        _isConnecting = true;
        _connectingSourceNode = node;
        _connectingSourcePortId = portId;
      });
    } else {
      // Complete connection
      if (_connectingSourceNode != null && nodeId != _connectingSourceNode!.id) {
        final targetNode = widget.graph.nodes.firstWhere((n) => n.id == nodeId);
        if (!isInput) {
          // Can only connect to input ports
          setState(() {
            _isConnecting = false;
            _connectingSourceNode = null;
            _connectingSourcePortId = null;
          });
          return;
        }

        // Check if connection already exists
        final existingEdge = widget.graph.edges.firstWhere(
          (edge) =>
              edge.source == _connectingSourceNode!.id &&
              edge.target == nodeId &&
              edge.sourcePort == _connectingSourcePortId &&
              edge.targetPort == portId,
          orElse: () => const AnalysisEdge(
            id: '',
            source: '',
            target: '',
            sourcePort: '',
            targetPort: '',
          ),
        );

        if (existingEdge.id.isEmpty) {
          // Create new edge
          final newEdge = AnalysisEdge(
            id: 'edge_${DateTime.now().millisecondsSinceEpoch}',
            source: _connectingSourceNode!.id,
            target: nodeId,
            sourcePort: _connectingSourcePortId!,
            targetPort: portId,
          );

          final updatedEdges = [...widget.graph.edges, newEdge];
          final updatedGraph = widget.graph.copyWith(edges: updatedEdges);
          widget.onGraphChanged(updatedGraph);
        }
      }

      setState(() {
        _isConnecting = false;
        _connectingSourceNode = null;
        _connectingSourcePortId = null;
      });
    }
  }

  void _handleGraphTap() {
    if (_isConnecting) {
      setState(() {
        _isConnecting = false;
        _connectingSourceNode = null;
        _connectingSourcePortId = null;
      });
    }

    widget.onNodeSelected(const AnalysisNode(
      id: '',
      nodeType: '',
      name: '',
      description: '',
      config: {},
      inputPorts: [],
      outputPorts: [],
      position: {},
    ));
    widget.onEdgeSelected(const AnalysisEdge(
      id: '',
      source: '',
      target: '',
      sourcePort: '',
      targetPort: '',
    ));
  }

  void _handleAddNode(Offset position) {
    widget.onNodeAdded(position);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnalysisTheme.of(context);

    return GestureDetector(
      onTap: _handleGraphTap,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: theme.canvasBackgroundColor,
        child: Stack(
          children: [
            // Grid background
            CustomPaint(
              painter: _GridPainter(theme: theme),
              size: const Size(double.infinity, double.infinity),
            ),
            // Edges
            ...widget.graph.edges.map((edge) {
              final sourceNode = widget.graph.nodes.firstWhere(
                (node) => node.id == edge.source,
              );
              final targetNode = widget.graph.nodes.firstWhere(
                (node) => node.id == edge.target,
              );

              final sourcePosition = Offset(
                sourceNode.position['x']?.toDouble() ?? 0,
                sourceNode.position['y']?.toDouble() ?? 0,
              );
              final targetPosition = Offset(
                targetNode.position['x']?.toDouble() ?? 0,
                targetNode.position['y']?.toDouble() ?? 0,
              );

              return AnalysisEdgeWidget(
                key: ValueKey(edge.id),
                edge: edge,
                onEdgeSelected: widget.onEdgeSelected,
                onEdgeDeleted: _handleEdgeDeleted,
                isSelected: widget.selectedEdge?.id == edge.id,
                sourcePosition: sourcePosition,
                targetPosition: targetPosition,
                sourcePortType: edge.sourcePort,
                targetPortType: edge.targetPort,
              );
            }),
            // Nodes
            ...widget.graph.nodes.map((node) {
              return AnalysisNodeWidget(
                key: ValueKey(node.id),
                node: node,
                onNodeChanged: _handleNodeChanged,
                onNodeSelected: widget.onNodeSelected,
                onNodeDeleted: _handleNodeDeleted,
                isSelected: widget.selectedNode?.id == node.id,
                onNodeMoved: _handleNodeMoved,
                onPortConnected: _handlePortTap,
                onPortDisconnected: (nodeId, portId) {},
                onConfigRequested: widget.onConfigRequested,
              );
            }),
            // Connection line (when connecting)
            if (_isConnecting && _connectingSourceNode != null)
              _buildConnectionLine(),
            // Add node button
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton(
                onPressed: () => _handleAddNode(const Offset(100, 100)),
                backgroundColor: theme.primaryColor,
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionLine() {
    return Positioned.fill(
      child: CustomPaint(
        painter: _ConnectionLinePainter(
          sourcePosition: Offset(
            _connectingSourceNode!.position['x']?.toDouble() ?? 0,
            _connectingSourceNode!.position['y']?.toDouble() ?? 0,
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final AnalysisThemeData theme;

  _GridPainter({required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = theme.gridColor
      ..strokeWidth = 1;

    const gridSize = 20.0;

    // Draw vertical lines
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => false;
}

class _ConnectionLinePainter extends CustomPainter {
  final Offset sourcePosition;

  _ConnectionLinePainter({required this.sourcePosition});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(sourcePosition, Offset.zero, paint);
  }

  @override
  bool shouldRepaint(covariant _ConnectionLinePainter oldDelegate) {
    return oldDelegate.sourcePosition != sourcePosition;
  }
}
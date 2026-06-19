"""
lib/modules/analysis_coder/widgets/analysis_node_widget.dart
Widget for rendering an analysis node in the graph.
"""

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/analysis_models.dart';
import '../theme/analysis_theme.dart';
import 'llm_analysis_node_config.dart';

class AnalysisNodeWidget extends StatefulWidget {
  final AnalysisNode node;
  final Function(AnalysisNode) onNodeChanged;
  final Function(AnalysisNode) onNodeSelected;
  final Function(AnalysisNode) onNodeDeleted;
  final bool isSelected;
  final Function(AnalysisNode, Offset) onNodeMoved;
  final Function(String, String, String) onPortConnected;
  final Function(String, String) onPortDisconnected;
  final Function(AnalysisNode) onConfigRequested;

  const AnalysisNodeWidget({
    super.key,
    required this.node,
    required this.onNodeChanged,
    required this.onNodeSelected,
    required this.onNodeDeleted,
    required this.isSelected,
    required this.onNodeMoved,
    required this.onPortConnected,
    required this.onPortDisconnected,
    required this.onConfigRequested,
  });

  @override
  State<AnalysisNodeWidget> createState() => _AnalysisNodeWidgetState();
}

class _AnalysisNodeWidgetState extends State<AnalysisNodeWidget> {
  Offset _position = Offset.zero;
  bool _isDragging = false;
  Offset _dragOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _position = Offset(
      widget.node.position['x']?.toDouble() ?? 0,
      widget.node.position['y']?.toDouble() ?? 0,
    );
  }

  @override
  void didUpdateWidget(AnalysisNodeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.node.position != widget.node.position) {
      _position = Offset(
        widget.node.position['x']?.toDouble() ?? 0,
        widget.node.position['y']?.toDouble() ?? 0,
      );
    }
  }

  void _handleDragStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
      _dragOffset = details.localPosition;
    });
    widget.onNodeSelected(widget.node);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;

    setState(() {
      _position += details.delta;
    });

    widget.onNodeMoved(
      widget.node,
      _position,
    );
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });

    final updatedNode = widget.node.copyWith(
      position: {'x': _position.dx, 'y': _position.dy},
    );
    widget.onNodeChanged(updatedNode);
  }

  void _handlePortTap(
    String nodeId,
    String portId,
    bool isInput,
  ) {
    // This will be handled by the parent graph widget
    // which manages the connection state
  }

  void _handleDelete() {
    widget.onNodeDeleted(widget.node);
  }

  void _handleConfig() {
    if (widget.node.nodeType == 'llm_analysis') {
      _showLLMConfigDialog();
    } else {
      widget.onConfigRequested(widget.node);
    }
  }

  void _showLLMConfigDialog() {
    showDialog(
      context: context,
      builder: (context) => LLMAnalysisNodeConfig(
        node: widget.node,
        onNodeUpdated: widget.onNodeChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnalysisTheme.of(context);
    final nodeType = _getNodeTypeDefinition(widget.node.nodeType);

    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onTap: () => widget.onNodeSelected(widget.node),
        onSecondaryTap: _handleConfig,
        child: Draggable(
          feedback: _buildNodeWidget(context, isDragging: true),
          childWhenDragging: const SizedBox.shrink(),
          onDragStarted: _handleDragStart,
          onDragUpdate: _handleDragUpdate,
          onDragEnd: _handleDragEnd,
          child: _buildNodeWidget(context),
        ),
      ),
    );
  }

  Widget _buildNodeWidget(BuildContext context, {bool isDragging = false}) {
    final theme = AnalysisTheme.of(context);
    final nodeType = _getNodeTypeDefinition(widget.node.nodeType);
    final isInputOnly = widget.node.inputPorts.isNotEmpty && widget.node.outputPorts.isEmpty;
    final isOutputOnly = widget.node.inputPorts.isEmpty && widget.node.outputPorts.isNotEmpty;

    Color nodeColor;
    switch (nodeType.category) {
      case NodeCategory.dataSource:
        nodeColor = theme.dataSourceColor;
        break;
      case NodeCategory.transform:
        nodeColor = theme.transformColor;
        break;
      case NodeCategory.aggregation:
        nodeColor = theme.aggregationColor;
        break;
      case NodeCategory.output:
        nodeColor = theme.outputColor;
        break;
      default:
        nodeColor = Colors.purple; // Default for LLM and other nodes
        break;
    }

    return Opacity(
      opacity: isDragging ? 0.7 : 1.0,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: theme.nodeBackgroundColor,
          borderRadius: theme.nodeBorderRadius,
          border: Border.all(
            color: widget.isSelected
                ? theme.selectedBorderColor
                : theme.nodeBorderColor,
            width: widget.isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.nodeShadowColor,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: nodeColor.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  // Node icon
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: nodeColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      nodeType.icon,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Node name
                  Expanded(
                    child: Text(
                      widget.node.name,
                      style: theme.nodeTitleStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Delete button
                  if (!isDragging)
                    GestureDetector(
                      onTap: _handleDelete,
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: theme.deleteButtonColor,
                      ),
                    ),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  if (widget.node.description.isNotEmpty)
                    Text(
                      widget.node.description,
                      style: theme.nodeDescriptionStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  // Input ports
                  if (widget.node.inputPorts.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ...widget.node.inputPorts.map((port) => _buildPortWidget(
                      port: port,
                      isInput: true,
                      nodeColor: nodeColor,
                    )),
                  ],
                  // Output ports
                  if (widget.node.outputPorts.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ...widget.node.outputPorts.map((port) => _buildPortWidget(
                      port: port,
                      isInput: false,
                      nodeColor: nodeColor,
                    )),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortWidget({
    required NodePort port,
    required bool isInput,
    required Color nodeColor,
  }) {
    final theme = AnalysisTheme.of(context);

    return Container(
      height: 24,
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          if (isInput) ...[
            _buildPortCircle(nodeColor),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              port.label,
              style: theme.portLabelStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (!isInput) ...[
            const SizedBox(width: 8),
            _buildPortCircle(nodeColor),
          ],
        ],
      ),
    );
  }

  Widget _buildPortCircle(Color nodeColor) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: nodeColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
    );
  }

  NodeDefinition _getNodeTypeDefinition(String nodeType) {
    // This should be replaced with a proper registry
    // For now, return a default definition
    return NodeDefinition(
      type: nodeType,
      name: nodeType,
      description: '',
      category: NodeCategory.transform,
      icon: Icons.code,
      inputPorts: const [],
      outputPorts: const [],
      defaultConfig: const {},
      properties: const [],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnalysisNode {
  final String id;
  String title;
  double x;
  double y;
  String calculationType; // SUM, AVG, MIN, MAX
  String? fieldId;
  String? fieldLabel;
  double? computedValue;

  AnalysisNode({
    required this.id,
    required this.title,
    required this.x,
    required this.y,
    required this.calculationType,
    this.fieldId,
    this.fieldLabel,
    this.computedValue,
  });
}

class NodeConnection {
  final String fromNodeId;
  final String toNodeId;

  NodeConnection({required this.fromNodeId, required this.toNodeId});
}

class AnalysisBoardCanvas extends StatefulWidget {
  final String formId;
  final String projectId;
  final List<dynamic> questions; // FormQuestions

  const AnalysisBoardCanvas({
    super.key,
    required this.formId,
    required this.projectId,
    required this.questions,
  });

  @override
  State<AnalysisBoardCanvas> createState() => _AnalysisBoardCanvasState();
}

class _AnalysisBoardCanvasState extends State<AnalysisBoardCanvas> {
  // Canvas offset & scale
  Offset _panOffset = Offset.zero;
  double _scale = 1.0;

  // Nodes & connections lists
  final List<AnalysisNode> _nodes = [];
  final List<NodeConnection> _connections = [];

  // Dragging connection state
  String? _connectingFromNodeId;
  Offset? _connectionDragPosition;

  // Autosave status state
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Pre-populate with default math engine nodes
    _nodes.addAll([
      AnalysisNode(
        id: 'node-1',
        title: 'Form Submissions Metric',
        x: 150,
        y: 200,
        calculationType: 'AVG',
        fieldId: 'age',
        fieldLabel: 'Age of Responders',
        computedValue: 28.4,
      ),
      AnalysisNode(
        id: 'node-2',
        title: 'Response Max Engine',
        x: 600,
        y: 180,
        calculationType: 'MAX',
        fieldId: 'score',
        fieldLabel: 'Test Score',
        computedValue: 98.0,
      ),
      AnalysisNode(
        id: 'node-3',
        title: 'Aggregation Output Node',
        x: 950,
        y: 300,
        calculationType: 'SUM',
        fieldId: 'income',
        fieldLabel: 'Monthly Income',
        computedValue: 142500.0,
      ),
    ]);

    // Connect node 1 to node 2, and node 2 to node 3
    _connections.add(NodeConnection(fromNodeId: 'node-1', toNodeId: 'node-2'));
    _connections.add(NodeConnection(fromNodeId: 'node-2', toNodeId: 'node-3'));
  }

  void _triggerAutosave() {
    setState(() {
      _isSaving = true;
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C29),
      body: Stack(
        children: [
          // 1. Grid Background & Interactive Canvas Panning/Scaling
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _panOffset += details.delta / _scale;
              });
            },
            child: Stack(
              children: [
                // Infinite Canvas Grid Background
                CustomPaint(
                  size: Size.infinite,
                  painter: _GridPainter(panOffset: _panOffset, scale: _scale),
                ),

                // Connection Lines Custom Paint layer
                CustomPaint(
                  size: Size.infinite,
                  painter: _ConnectionPainter(
                    nodes: _nodes,
                    connections: _connections,
                    panOffset: _panOffset,
                    scale: _scale,
                    connectingFromNodeId: _connectingFromNodeId,
                    connectionDragPosition: _connectionDragPosition,
                  ),
                ),

                // Interactive Nodes
                ..._nodes.map((node) => _buildNodeCard(node)),
              ],
            ),
          ),

          // 2. Neon Overlay Control Bar
          _buildCanvasHeader(),

          // 3. Right Side Actions panel / Node creator list
          _buildFloatingCreatorPanel(),
        ],
      ),
    );
  }

  Widget _buildNodeCard(AnalysisNode node) {
    final double cardWidth = 260.0;
    final double cardHeight = 175.0;

    // Apply canvas scale and offset translation calculations
    final double left = (_panOffset.dx + node.x) * _scale;
    final double top = (_panOffset.dy + node.y) * _scale;

    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            node.x += details.delta.dx / _scale;
            node.y += details.delta.dy / _scale;
          });
        },
        onPanEnd: (_) => _triggerAutosave(),
        child: Container(
          width: cardWidth * _scale,
          height: cardHeight * _scale,
          decoration: BoxDecoration(
            color: const Color(0xAA161435),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF6366F1).withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withOpacity(0.15),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card Title Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              node.title,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13 * _scale,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6366F1).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              node.calculationType,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF818CF8),
                                fontSize: 10 * _scale,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // Node configurations / Field selector description
                      Text(
                        'Target Field',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF9CA3AF),
                          fontSize: 10 * _scale,
                        ),
                      ),
                      Text(
                        node.fieldLabel ?? 'Unconfigured Field',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFE5E7EB),
                          fontSize: 12 * _scale,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),

                      // Computed visual engine outputs
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Result',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF9CA3AF),
                              fontSize: 11 * _scale,
                            ),
                          ),
                          Text(
                            node.computedValue?.toString() ?? '—',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF34D399),
                              fontWeight: FontWeight.bold,
                              fontSize: 16 * _scale,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Left Connection Socket handle (Input)
                Positioned(
                  left: 0,
                  top: cardHeight * _scale / 2 - 8,
                  child: Container(
                    width: 8 * _scale,
                    height: 16 * _scale,
                    decoration: const BoxDecoration(
                      color: Color(0xFF34D399),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                  ),
                ),

                // Right Connection Socket handle (Output)
                Positioned(
                  right: 0,
                  top: cardHeight * _scale / 2 - 8,
                  child: GestureDetector(
                    onPanStart: (details) {
                      setState(() {
                        _connectingFromNodeId = node.id;
                        _connectionDragPosition = details.globalPosition;
                      });
                    },
                    onPanUpdate: (details) {
                      setState(() {
                        _connectionDragPosition = details.globalPosition;
                      });
                    },
                    onPanEnd: (_) {
                      // Attempt connection logic to closest target node
                      if (_connectingFromNodeId != null && _connectionDragPosition != null) {
                        final RenderBox renderBox = context.findRenderObject() as RenderBox;
                        final localPos = renderBox.globalToLocal(_connectionDragPosition!);
                        final canvasPos = Offset(
                          localPos.dx / _scale - _panOffset.dx,
                          localPos.dy / _scale - _panOffset.dy,
                        );

                        // Find any target node within 120 pixels of the drop target
                        String? targetNodeId;
                        for (final targetNode in _nodes) {
                          if (targetNode.id == _connectingFromNodeId) continue;
                          final dist = (Offset(targetNode.x, targetNode.y + cardHeight / 2) - canvasPos).distance;
                          if (dist < 150) {
                            targetNodeId = targetNode.id;
                            break;
                          }
                        }

                        if (targetNodeId != null) {
                          setState(() {
                            _connections.add(NodeConnection(
                              fromNodeId: _connectingFromNodeId!,
                              toNodeId: targetNodeId!,
                            ));
                          });
                          _triggerAutosave();
                        }
                      }
                      setState(() {
                        _connectingFromNodeId = null;
                        _connectionDragPosition = null;
                      });
                    },
                    child: Container(
                      width: 10 * _scale,
                      height: 20 * _scale,
                      decoration: const BoxDecoration(
                        color: Color(0xFF6366F1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCanvasHeader() {
    return Positioned(
      top: 24,
      left: 24,
      right: 24,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: const Color(0xDD0B091B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF3730A3).withOpacity(0.6),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Analysis Node Canvas',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Infinite Drag-and-Zoom Multi-Rule Mathematics Engines',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF9CA3AF),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Sync indicator
            Row(
              children: [
                Icon(
                  _isSaving ? Icons.sync : Icons.cloud_done_rounded,
                  color: _isSaving ? const Color(0xFFF59E0B) : const Color(0xFF34D399),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  _isSaving ? 'Autosaving...' : 'Canvas Synced',
                  style: GoogleFonts.inter(
                    color: _isSaving ? const Color(0xFFF59E0B) : const Color(0xFF34D399),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            // Zoom controls
            IconButton(
              icon: const Icon(Icons.zoom_in, color: Colors.white),
              onPressed: () => setState(() => _scale = (_scale + 0.1).clamp(0.5, 2.0)),
            ),
            IconButton(
              icon: const Icon(Icons.zoom_out, color: Colors.white),
              onPressed: () => setState(() => _scale = (_scale - 0.1).clamp(0.5, 2.0)),
            ),
            IconButton(
              icon: const Icon(Icons.settings_backup_restore, color: Colors.white),
              onPressed: () => setState(() {
                _scale = 1.0;
                _panOffset = Offset.zero;
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingCreatorPanel() {
    return Positioned(
      top: 104,
      right: 24,
      bottom: 24,
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: const Color(0xEE0B091B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF3730A3).withOpacity(0.6),
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Math Node',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildCreatorCard('SUM', 'Sum Aggregator', 'Computes addition value of questions.', const Color(0xFFEF4444)),
                  const SizedBox(height: 12),
                  _buildCreatorCard('AVG', 'Average Evaluator', 'Computes division scale value.', const Color(0xFF3B82F6)),
                  const SizedBox(height: 12),
                  _buildCreatorCard('MIN', 'Minimum Scale', 'Determines the minimum result.', const Color(0xFFF59E0B)),
                  const SizedBox(height: 12),
                  _buildCreatorCard('MAX', 'Maximum Peak', 'Determines peak boundary level.', const Color(0xFF10B981)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatorCard(String type, String title, String desc, Color highlight) {
    return InkWell(
      onTap: () {
        setState(() {
          final nextId = 'node-${_nodes.length + 1}';
          _nodes.add(AnalysisNode(
            id: nextId,
            title: title,
            x: 200 - _panOffset.dx,
            y: 250 - _panOffset.dy,
            calculationType: type,
            fieldId: 'new-field',
            fieldLabel: 'Created Field metric',
            computedValue: 12.5,
          ));
        });
        _triggerAutosave();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF161435),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF3730A3), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: highlight.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  type,
                  style: GoogleFonts.inter(
                    color: highlight,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    desc,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF9CA3AF),
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Custom Painters for infinite grid + lines
// ─────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  final Offset panOffset;
  final double scale;

  _GridPainter({required this.panOffset, required this.scale});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6366F1).withOpacity(0.06)
      ..strokeWidth = 1.0;

    final double step = 40.0 * scale;
    final double startX = (panOffset.dx * scale) % step;
    final double startY = (panOffset.dy * scale) % step;

    for (double x = startX; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = startY; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) =>
      oldDelegate.panOffset != panOffset || oldDelegate.scale != scale;
}

class _ConnectionPainter extends CustomPainter {
  final List<AnalysisNode> nodes;
  final List<NodeConnection> connections;
  final Offset panOffset;
  final double scale;
  final String? connectingFromNodeId;
  final Offset? connectionDragPosition;

  _ConnectionPainter({
    required this.nodes,
    required this.connections,
    required this.panOffset,
    required this.scale,
    this.connectingFromNodeId,
    this.connectionDragPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6366F1).withOpacity(0.65)
      ..strokeWidth = 2.5 * scale
      ..style = PaintingStyle.stroke;

    final double cardWidth = 260.0;
    final double cardHeight = 175.0;

    // Draw active connections
    for (final conn in connections) {
      final from = nodes.firstWhere((n) => n.id == conn.fromNodeId, orElse: () => nodes.first);
      final to = nodes.firstWhere((n) => n.id == conn.toNodeId, orElse: () => nodes.first);

      final startPos = Offset(
        (panOffset.dx + from.x + cardWidth) * scale,
        (panOffset.dy + from.y + cardHeight / 2) * scale,
      );

      final endPos = Offset(
        (panOffset.dx + to.x) * scale,
        (panOffset.dy + to.y + cardHeight / 2) * scale,
      );

      // Distinct green glowing line for validated, and glowing red dashes for errors
      final isError = from.computedValue == null || to.computedValue == null;
      final pathPaint = Paint()
        ..color = isError ? const Color(0xFFEF4444) : const Color(0xFF10B981)
        ..strokeWidth = 3.0 * scale
        ..style = PaintingStyle.stroke;

      _drawBezier(canvas, startPos, endPos, pathPaint);
    }

    // Draw dynamic dragging lines
    if (connectingFromNodeId != null && connectionDragPosition != null) {
      final from = nodes.firstWhere((n) => n.id == connectingFromNodeId!);
      final startPos = Offset(
        (panOffset.dx + from.x + cardWidth) * scale,
        (panOffset.dy + from.y + cardHeight / 2) * scale,
      );

      // Dynamic compatibility indicators (Orange while dragging)
      final dragPaint = Paint()
        ..color = const Color(0xFFF59E0B).withOpacity(0.8)
        ..strokeWidth = 2.5 * scale
        ..style = PaintingStyle.stroke;

      _drawBezier(canvas, startPos, connectionDragPosition!, dragPaint);
    }
  }

  void _drawBezier(Canvas canvas, Offset start, Offset end, Paint paint) {
    final path = Path();
    path.moveTo(start.dx, start.dy);

    final controlPoint1 = Offset(start.dx + 80 * scale, start.dy);
    final controlPoint2 = Offset(end.dx - 80 * scale, end.dy);

    path.cubicTo(
      controlPoint1.dx,
      controlPoint1.dy,
      controlPoint2.dx,
      controlPoint2.dy,
      end.dx,
      end.dy,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ConnectionPainter oldDelegate) => true;
}

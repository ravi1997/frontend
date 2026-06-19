"""
lib/modules/analysis_coder/widgets/analysis_edge_widget.dart
Widget for rendering an edge/connection between nodes.
"""

import 'package:flutter/material.dart';

import '../models/analysis_models.dart';
import '../theme/analysis_theme.dart';

class AnalysisEdgeWidget extends StatelessWidget {
  final AnalysisEdge edge;
  final Function(AnalysisEdge) onEdgeSelected;
  final Function(AnalysisEdge) onEdgeDeleted;
  final bool isSelected;
  final Offset sourcePosition;
  final Offset targetPosition;
  final String sourcePortType;
  final String targetPortType;

  const AnalysisEdgeWidget({
    super.key,
    required this.edge,
    required this.onEdgeSelected,
    required this.onEdgeDeleted,
    required this.isSelected,
    required this.sourcePosition,
    required this.targetPosition,
    required this.sourcePortType,
    required this.targetPortType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AnalysisTheme.of(context);
    
    return GestureDetector(
      onTap: () => onEdgeSelected(edge),
      onSecondaryTap: () => onEdgeDeleted(edge),
      child: CustomPaint(
        painter: _EdgePainter(
          sourcePosition: sourcePosition,
          targetPosition: targetPosition,
          isSelected: isSelected,
          theme: theme,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _EdgePainter extends CustomPainter {
  final Offset sourcePosition;
  final Offset targetPosition;
  final bool isSelected;
  final AnalysisThemeData theme;

  _EdgePainter({
    required this.sourcePosition,
    required this.targetPosition,
    required this.isSelected,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isSelected ? theme.selectedBorderColor : theme.edgeColor
      ..strokeWidth = isSelected ? 3 : 2
      ..style = PaintingStyle.stroke;

    // Calculate control points for bezier curve
    final distance = (targetPosition - sourcePosition).distance;
    final controlPoint1 = Offset(
      sourcePosition.dx + distance * 0.5,
      sourcePosition.dy,
    );
    final controlPoint2 = Offset(
      targetPosition.dx - distance * 0.5,
      targetPosition.dy,
    );

    // Draw bezier curve
    final path = Path()
      ..moveTo(sourcePosition.dx, sourcePosition.dy)
      ..cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        targetPosition.dx,
        targetPosition.dy,
      );

    canvas.drawPath(path, paint);

    // Draw arrow head
    _drawArrowHead(canvas, path);
  }

  void _drawArrowHead(Canvas canvas, Path path) {
    final metrics = path.computeMetrics().first;
    final tangent = metrics.getTangentForOffset(metrics.length - 10)!;
    
    final angle = tangent.angle;
    final arrowSize = 8.0;
    
    final arrowPath = Path()
      ..moveTo(
        tangent.position.dx,
        tangent.position.dy,
      )
      ..lineTo(
        tangent.position.dx - arrowSize * math.cos(angle - math.pi / 6),
        tangent.position.dy - arrowSize * math.sin(angle - math.pi / 6),
      )
      ..lineTo(
        tangent.position.dx - arrowSize * math.cos(angle + math.pi / 6),
        tangent.position.dy - arrowSize * math.sin(angle + math.pi / 6),
      )
      ..close();

    final arrowPaint = Paint()
      ..color = isSelected ? theme.selectedBorderColor : theme.edgeColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(arrowPath, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant _EdgePainter oldDelegate) {
    return oldDelegate.sourcePosition != sourcePosition ||
           oldDelegate.targetPosition != targetPosition ||
           oldDelegate.isSelected != isSelected;
  }
}

// Helper function to get math import
import 'dart:math' as math;
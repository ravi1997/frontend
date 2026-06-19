import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardCanvas extends StatefulWidget {
  final double width;
  final double height;
  final Color backgroundColor;
  final bool gridEnabled;
  final double gridSize;
  final bool snapToGrid;
  final List<Widget> children;
  final Function(Offset)? onTap;
  final Function(DragUpdateDetails)? onDragUpdate;
  final Function(DragEndDetails)? onDragEnd;

  const DashboardCanvas({
    Key? key,
    required this.width,
    required this.height,
    this.backgroundColor = Colors.white,
    this.gridEnabled = true,
    this.gridSize = 20.0,
    this.snapToGrid = true,
    this.children = const [],
    this.onTap,
    this.onDragUpdate,
    this.onDragEnd,
  }) : super(key: key);

  @override
  _DashboardCanvasState createState() => _DashboardCanvasState();
}

class _DashboardCanvasState extends State<DashboardCanvas> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.backgroundColor,
      child: Stack(
        children: [
          // Grid background
          if (widget.gridEnabled)
            CustomPaint(
              size: Size(widget.width, widget.height),
              painter: GridPainter(
                gridSize: widget.gridSize,
                color: Colors.grey.withOpacity(0.2),
              ),
            ),
          // Interactive area
          GestureDetector(
            onTapDown: (details) {
              if (widget.onTap != null) {
                widget.onTap!(details.localPosition);
              }
            },
            onPanUpdate: widget.onDragUpdate,
            onPanEnd: widget.onDragEnd,
            child: Container(
              width: widget.width,
              height: widget.height,
              child: Stack(
                children: widget.children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final double gridSize;
  final Color color;

  GridPainter({required this.gridSize, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

extension OffsetExtension on Offset {
  Offset snapToGrid(double gridSize) {
    return Offset(
      (dx / gridSize).round() * gridSize,
      (dy / gridSize).round() * gridSize,
    );
  }
}
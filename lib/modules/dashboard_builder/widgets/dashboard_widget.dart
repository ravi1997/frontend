import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dashboard_models.dart';

abstract class DashboardWidget extends ConsumerStatefulWidget {
  final DashboardWidgetModel model;
  final Function(DashboardWidgetModel)? onChanged;
  final Function(DashboardWidgetModel)? onPositionChanged;
  final bool isSelected;
  final bool isEditable;

  const DashboardWidget({
    Key? key,
    required this.model,
    this.onChanged,
    this.onPositionChanged,
    this.isSelected = false,
    this.isEditable = true,
  }) : super(key: key);

  @override
  ConsumerState<DashboardWidget> createState();
}

abstract class DashboardWidgetState<T extends DashboardWidget> extends ConsumerState<T> {
  bool _isDragging = false;
  bool _isResizing = false;
  Offset _dragOffset = Offset.zero;
  WidgetPosition _originalPosition = const WidgetPosition(x: 0, y: 0, width: 200, height: 150);

  @override
  void initState() {
    super.initState();
    _originalPosition = widget.model.position;
  }

  Widget buildWidget(BuildContext context);

  Widget buildResizeHandle(Alignment alignment) {
    if (!widget.isEditable) return const SizedBox();
    
    return Positioned(
      left: alignment.x < 0 ? 0 : null,
      right: alignment.x > 0 ? 0 : null,
      top: alignment.y < 0 ? 0 : null,
      bottom: alignment.y > 0 ? 0 : null,
      child: GestureDetector(
        onPanStart: (details) {
          setState(() {
            _isResizing = true;
            _originalPosition = widget.model.position;
          });
        },
        onPanUpdate: (details) {
          if (!_isResizing) return;
          
          setState(() {
            final newPosition = _originalPosition.copyWith(
              width: (_originalPosition.width + details.delta.dx).clamp(50, 800),
              height: (_originalPosition.height + details.delta.dy).clamp(50, 600),
            );
            
            final updatedModel = widget.model.copyWith(position: newPosition);
            widget.onPositionChanged?.call(updatedModel);
          });
        },
        onPanEnd: (details) {
          setState(() {
            _isResizing = false;
          });
        },
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: widget.isSelected ? Colors.blue : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      ),
    );
  }

  Widget buildWidgetContainer(BuildContext context, Widget child) {
    final position = widget.model.position;
    
    return Positioned(
      left: position.x,
      top: position.y,
      width: position.width,
      height: position.height,
      child: Stack(
        children: [
          // Main widget container
          GestureDetector(
            onPanStart: (details) {
              if (!widget.isEditable) return;
              setState(() {
                _isDragging = true;
                _dragOffset = details.localPosition;
                _originalPosition = widget.model.position;
              });
            },
            onPanUpdate: (details) {
              if (!_isDragging || !widget.isEditable) return;
              
              setState(() {
                final newPosition = _originalPosition.copyWith(
                  x: _originalPosition.x + details.globalPosition.dx - _dragOffset.dx,
                  y: _originalPosition.y + details.globalPosition.dy - _dragOffset.dy,
                );
                
                final updatedModel = widget.model.copyWith(position: newPosition);
                widget.onPositionChanged?.call(updatedModel);
              });
            },
            onPanEnd: (details) {
              if (!widget.isEditable) return;
              setState(() {
                _isDragging = false;
              });
            },
            child: Container(
              width: position.width,
              height: position.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: widget.isSelected ? Colors.blue : Colors.grey.shade300,
                  width: widget.isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: child,
              ),
            ),
          ),
          
          // Resize handles
          if (widget.isEditable && widget.isSelected) ...[
            buildResizeHandle(const Alignment(-1, -1)), // Top-left
            buildResizeHandle(const Alignment(1, -1)),  // Top-right
            buildResizeHandle(const Alignment(-1, 1)),  // Bottom-left
            buildResizeHandle(const Alignment(1, 1)),   // Bottom-right
            buildResizeHandle(const Alignment(0, -1)),  // Top-center
            buildResizeHandle(const Alignment(0, 1)),   // Bottom-center
            buildResizeHandle(const Alignment(-1, 0)), // Left-center
            buildResizeHandle(const Alignment(1, 0)),   // Right-center
          ],
          
          // Widget title bar
          if (widget.model.title != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Text(
                  widget.model.title!,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildWidgetContainer(context, buildWidget(context));
  }
}
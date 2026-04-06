import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/analysis_dashboard.dart';

class AnalysisWidgetCard extends StatefulWidget {
  final AnalysisWidget widget;
  final bool isSelected;
  final VoidCallback onTap;
  final Function(int x, int y) onPositionChanged;
  final Function(int w, int h) onSizeChanged;
  final bool isPreview;

  const AnalysisWidgetCard({
    super.key,
    required this.widget,
    required this.isSelected,
    required this.onTap,
    required this.onPositionChanged,
    required this.onSizeChanged,
    this.isPreview = false,
  });

  @override
  State<AnalysisWidgetCard> createState() => _AnalysisWidgetCardState();
}

class _AnalysisWidgetCardState extends State<AnalysisWidgetCard> {
  late double _localX;
  late double _localY;
  late double _localW;
  late double _localH;
  bool _isDragging = false;
  bool _isResizing = false;

  @override
  void initState() {
    super.initState();
    _localX = widget.widget.positionX.toDouble() * 40;
    _localY = widget.widget.positionY.toDouble() * 40;
    _localW = widget.widget.width.toDouble() * 40;
    _localH = widget.widget.height.toDouble() * 40;
  }

  @override
  void didUpdateWidget(AnalysisWidgetCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isDragging && !_isResizing) {
      _localX = widget.widget.positionX.toDouble() * 40;
      _localY = widget.widget.positionY.toDouble() * 40;
      _localW = widget.widget.width.toDouble() * 40;
      _localH = widget.widget.height.toDouble() * 40;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _localX,
      top: _localY,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onPanStart: (_) {
              if (widget.isPreview) return;
              widget.onTap();
              setState(() => _isDragging = true);
            },
            onPanUpdate: (details) {
              if (widget.isPreview) return;
              setState(() {
                _localX += details.delta.dx;
                _localY += details.delta.dy;
              });
            },
            onPanEnd: (_) {
              if (widget.isPreview) return;
              setState(() => _isDragging = false);
              final int gridX = (_localX / 40).round();
              final int gridY = (_localY / 40).round();
              widget.onPositionChanged(gridX, gridY);
            },
            child: Container(
              width: _localW,
              height: _localH,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.isSelected
                      ? const Color(0xFF2563EB)
                      : const Color(0xFFE5E7EB),
                  width: widget.isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: widget.isSelected ? 0.12 : 0.05,
                    ),
                    blurRadius: widget.isSelected ? 12 : 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  Expanded(child: _buildContent()),
                ],
              ),
            ),
          ),
          if (widget.isSelected && !widget.isPreview)
            Positioned(
              right: -4,
              bottom: -4,
              child: GestureDetector(
                onPanStart: (_) => setState(() => _isResizing = true),
                onPanUpdate: (details) {
                  setState(() {
                    _localW += details.delta.dx;
                    _localH += details.delta.dy;
                    if (_localW < 80) _localW = 80;
                    if (_localH < 80) _localH = 80;
                  });
                },
                onPanEnd: (_) {
                  setState(() => _isResizing = false);
                  final int gridW = (_localW / 40).round();
                  final int gridH = (_localH / 40).round();
                  widget.onSizeChanged(gridW, gridH);
                },
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2563EB),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.south_east,
                    size: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Icon(
            _getIconForType(widget.widget.type),
            size: 16,
            color: AppColors.textGrey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (widget.isSelected)
            const Icon(
              Icons.drag_indicator,
              size: 16,
              color: AppColors.textGrey,
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (widget.widget.type == 'ai_insight') {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.auto_awesome, color: Color(0xFF8B5CF6), size: 24),
            const SizedBox(height: 12),
            Container(
              height: 8,
              color: const Color(0xFFF3F4F6),
              margin: const EdgeInsets.only(bottom: 8),
            ),
            Container(
              height: 8,
              color: const Color(0xFFF3F4F6),
              margin: const EdgeInsets.only(bottom: 8),
              width: 100,
            ),
            Container(height: 8, color: const Color(0xFFF3F4F6), width: 60),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIconForType(widget.widget.type),
            size: 40,
            color: const Color(0xFFE5E7EB),
          ),
          const SizedBox(height: 8),
          Text(
            'Chart Preview',
            style: TextStyle(
              color: const Color(0xFF9CA3AF),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'chart_bar':
        return Icons.bar_chart;
      case 'chart_line':
        return Icons.show_chart;
      case 'chart_pie':
        return Icons.pie_chart;
      case 'kpi':
        return Icons.analytics;
      case 'table':
        return Icons.table_chart;
      default:
        return Icons.widgets;
    }
  }
}

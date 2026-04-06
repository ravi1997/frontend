import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/analysis_builder_controller.dart';
import '../widgets/analysis_canvas.dart';
import '../widgets/analysis_properties_panel.dart';
import '../widgets/analysis_filter_bar.dart';

class AnalysisBuilderPage extends ConsumerStatefulWidget {
  final String? dashboardId;
  final String? formId;
  const AnalysisBuilderPage({super.key, this.dashboardId, this.formId});

  @override
  ConsumerState<AnalysisBuilderPage> createState() =>
      _AnalysisBuilderPageState();
}

class _AnalysisBuilderPageState extends ConsumerState<AnalysisBuilderPage> {
  double _leftPanelWidth = 300;
  double _rightPanelWidth = 320;
  bool _isPreviewMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: _buildAppBar(),
      body: Row(
        children: [
          if (!_isPreviewMode) ...[
            // Left Panel: Widget Library
            SizedBox(width: _leftPanelWidth, child: _buildWidgetLibrary()),
            _buildResizeHandle(isLeft: true),
          ],

          // Center: Dashboard Canvas
          Expanded(
            child: Column(
              children: [
                AnalysisFilterBar(dashboardId: widget.dashboardId),
                Expanded(child: _buildCanvas()),
              ],
            ),
          ),

          if (!_isPreviewMode) ...[
            _buildResizeHandle(isLeft: false),
            // Right Panel: Properties
            SizedBox(width: _rightPanelWidth, child: _buildPropertiesPanel()),
          ],
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        widget.dashboardId == null
            ? 'New Analysis Dashboard'
            : 'Edit Analysis Dashboard',
        style: const TextStyle(
          color: Color(0xFF111827),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF374151)),
        onPressed: () => Navigator.of(context).pop(),
      ),
      shape: const Border(
        bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.undo, size: 20),
          onPressed: () => ref
              .read(
                analysisBuilderControllerProvider(widget.dashboardId).notifier,
              )
              .undo(),
          tooltip: 'Undo (Ctrl+Z)',
        ),
        IconButton(
          icon: const Icon(Icons.redo, size: 20),
          onPressed: () => ref
              .read(
                analysisBuilderControllerProvider(widget.dashboardId).notifier,
              )
              .redo(),
          tooltip: 'Redo (Ctrl+Y)',
        ),
        const SizedBox(width: 8),
        Container(width: 1, height: 24, color: const Color(0xFFE5E7EB)),
        const SizedBox(width: 16),
        Row(
          children: [
            Text(
              'Preview',
              style: TextStyle(
                color: _isPreviewMode
                    ? AppColors.primary
                    : const Color(0xFF6B7280),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Switch(
              value: _isPreviewMode,
              activeThumbColor: AppColors.primary,
              onChanged: (val) => setState(() => _isPreviewMode = val),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ElevatedButton.icon(
            onPressed: () => ref
                .read(
                  analysisBuilderControllerProvider(
                    widget.dashboardId,
                  ).notifier,
                )
                .saveDashboard(),
            icon: const Icon(Icons.save, size: 18),
            label: const Text('Save Changes'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),
      ],
    );
  }

  Widget _buildWidgetLibrary() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Components',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Drag and drop onto canvas',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildLibraryItem('Bar Chart', Icons.bar_chart, 'chart_bar'),
                _buildLibraryItem('Line Chart', Icons.show_chart, 'chart_line'),
                _buildLibraryItem('Pie Chart', Icons.pie_chart, 'chart_pie'),
                _buildLibraryItem('KPI Card', Icons.analytics, 'kpi'),
                _buildLibraryItem('Data Table', Icons.table_chart, 'table'),
                _buildLibraryItem('Text Label', Icons.title, 'text'),
                _buildLibraryItem(
                  'AI Insight',
                  Icons.auto_awesome,
                  'ai_insight',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLibraryItem(String title, IconData icon, String type) {
    return Draggable<String>(
      data: type,
      feedback: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 12),
              Text(title),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _buildLibraryCard(title, icon),
      ),
      child: _buildLibraryCard(title, icon),
    );
  }

  Widget _buildLibraryCard(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        dense: true,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: const Color(0xFF4B5563), size: 18),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        trailing: const Icon(
          Icons.drag_indicator,
          size: 16,
          color: Color(0xFFD1D5DB),
        ),
      ),
    );
  }

  Widget _buildCanvas() {
    return DragTarget<String>(
      onAcceptWithDetails: (details) {
        ref
            .read(
              analysisBuilderControllerProvider(widget.dashboardId).notifier,
            )
            .addWidget(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        return Stack(
          children: [
            AnalysisCanvas(dashboardId: widget.dashboardId),
            if (candidateData.isNotEmpty)
              Positioned.fill(
                child: Container(
                  margin: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF2563EB),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            color: Color(0xFF2563EB),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Drop to add component',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildPropertiesPanel() {
    return AnalysisPropertiesPanel(dashboardId: widget.dashboardId);
  }

  Widget _buildResizeHandle({required bool isLeft}) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          setState(() {
            if (isLeft) {
              _leftPanelWidth += details.delta.dx;
              if (_leftPanelWidth < 200) _leftPanelWidth = 200;
              if (_leftPanelWidth > 400) _leftPanelWidth = 400;
            } else {
              _rightPanelWidth -= details.delta.dx;
              if (_rightPanelWidth < 250) _rightPanelWidth = 250;
              if (_rightPanelWidth > 500) _rightPanelWidth = 500;
            }
          });
        },
        child: Container(
          width: 8,
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: 1.5,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/analysis_builder_controller.dart';
import 'analysis_widget_card.dart';

class AnalysisCanvas extends ConsumerWidget {
  final String? dashboardId;

  const AnalysisCanvas({super.key, this.dashboardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final builderState = ref.watch(
      analysisBuilderControllerProvider(dashboardId),
    );
    final widgets = builderState.dashboard.widgets;

    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(child: _buildGridBackground()),
          ...widgets.map(
            (w) => Consumer(
              key: ValueKey(w.id),
              builder: (context, ref, child) {
                final widget = ref.watch(
                  analysisBuilderControllerProvider(dashboardId).select(
                    (s) => s.dashboard.widgets.firstWhere(
                      (item) => item.id == w.id,
                    ),
                  ),
                );
                final isSelected = ref.watch(
                  analysisBuilderControllerProvider(
                    dashboardId,
                  ).select((s) => s.selectedWidgetId == widget.id),
                );

                return AnalysisWidgetCard(
                  widget: widget,
                  isSelected: isSelected,
                  onTap: () => ref
                      .read(
                        analysisBuilderControllerProvider(dashboardId).notifier,
                      )
                      .selectWidget(widget.id),
                  onPositionChanged: (x, y) {
                    ref
                        .read(
                          analysisBuilderControllerProvider(
                            dashboardId,
                          ).notifier,
                        )
                        .updateWidgetPosition(widget.id, x, y);
                  },
                  onSizeChanged: (width, height) {
                    ref
                        .read(
                          analysisBuilderControllerProvider(
                            dashboardId,
                          ).notifier,
                        )
                        .updateWidgetSize(widget.id, width, height);
                  },
                );
              },
            ),
          ),
          if (widgets.isEmpty)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Drag components from the library or use a template',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTemplateButton(
                        ref,
                        label: 'Response Summary',
                        icon: Icons.dashboard_customize,
                        onPressed: () => ref
                            .read(
                              analysisBuilderControllerProvider(
                                dashboardId,
                              ).notifier,
                            )
                            .applyTemplate('response_summary'),
                      ),
                      const SizedBox(width: 16),
                      _buildTemplateButton(
                        ref,
                        label: 'Completion Funnel',
                        icon: Icons.filter_alt,
                        onPressed: () => ref
                            .read(
                              analysisBuilderControllerProvider(
                                dashboardId,
                              ).notifier,
                            )
                            .applyTemplate('completion_funnel'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTemplateButton(
    WidgetRef ref, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2563EB),
        side: const BorderSide(color: Color(0xFF2563EB)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        elevation: 0,
      ),
    );
  }

  Widget _buildGridBackground() {
    return CustomPaint(painter: GridPainter());
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE5E7EB).withOpacity(0.5)
      ..strokeWidth = 0.5;

    const double step = 40; // Size of each grid cell

    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

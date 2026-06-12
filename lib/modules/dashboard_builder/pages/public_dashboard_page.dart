import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:frontend/modules/dashboard_builder/models/dashboard_canvas_models.dart';
import 'package:frontend/modules/dashboard_builder/repositories/dashboard_builder_repository.dart';

/// Public (unauthenticated) dashboard view via share token.
/// Route: /d/:shareToken
class PublicDashboardPage extends ConsumerStatefulWidget {
  final String shareToken;

  const PublicDashboardPage({super.key, required this.shareToken});

  @override
  ConsumerState<PublicDashboardPage> createState() =>
      _PublicDashboardPageState();
}

class _PublicDashboardPageState extends ConsumerState<PublicDashboardPage> {
  DashboardModel? _dashboard;
  bool _loading = true;
  String? _error;
  final TransformationController _tc = TransformationController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _tc.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final dash = await ref
          .read(dashboardBuilderRepositoryProvider)
          .getPublic(widget.shareToken);
      setState(() {
        _dashboard = dash;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Color _hexColor(String hex) {
    try {
      return Color(0xFF000000 |
          int.parse(hex.replaceAll('#', ''), radix: 16));
    } catch (_) {
      return const Color(0xFFF5F5F5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _dashboard == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.dashboard_outlined, size: 64, color: cs.outlineVariant),
              const SizedBox(height: 16),
              Text(
                'Dashboard not found',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This dashboard link may be expired or revoked.',
                style: GoogleFonts.inter(color: cs.onSurfaceVariant),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: GoogleFonts.inter(fontSize: 11, color: cs.error),
                ),
              ],
            ],
          ),
        ),
      );
    }

    final dash = _dashboard!;
    final bgColor = _hexColor(dash.canvas.backgroundColor);
    final canvasW = dash.canvas.width;
    final canvasH = dash.canvas.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: SafeArea(
        child: Column(
          children: [
            // Minimal top bar
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.black.withOpacity(0.3),
              child: Row(
                children: [
                  Icon(Icons.dashboard_rounded,
                      size: 18, color: Colors.white.withOpacity(0.7)),
                  const SizedBox(width: 8),
                  Text(
                    dash.name,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.public_rounded,
                            size: 12, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(
                          'Public',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Canvas
            Expanded(
              child: InteractiveViewer(
                transformationController: _tc,
                minScale: 0.2,
                maxScale: 2.0,
                constrained: false,
                child: Container(
                  width: canvasW,
                  height: canvasH,
                  color: bgColor,
                  child: Stack(
                    children: [
                      for (final w in dash.canvas.widgets)
                        Positioned(
                          left: w.x,
                          top: w.y,
                          child: SizedBox(
                            width: w.width,
                            height: w.height,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: _PublicWidgetRenderer(widget: w),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Lightweight widget renderer for public view ──────────────────────────────

class _PublicWidgetRenderer extends StatelessWidget {
  final DashboardWidget widget;
  const _PublicWidgetRenderer({required this.widget});

  Color _hex(String? h) {
    if (h == null) return const Color(0xFF6366F1);
    try {
      return Color(0xFF000000 | int.parse(h.replaceAll('#', ''), radix: 16));
    } catch (_) {
      return const Color(0xFF6366F1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final props = widget.properties;

    switch (widget.type) {
      case DashboardWidgetType.kpiCard:
        final color = _hex(props['color_scheme'] as String?);
        final val = widget.resolvedData is Map
            ? (widget.resolvedData as Map)['value']?.toString() ?? '—'
            : widget.resolvedData?.toString() ?? '—';
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color.withAlpha(230), color]),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(props['title'] as String? ?? 'Metric',
                  style: GoogleFonts.inter(
                      color: Colors.white.withAlpha(210), fontSize: 12)),
              const Spacer(),
              Text(val,
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800)),
            ],
          ),
        );

      case DashboardWidgetType.textLabel:
        final color = _hex(props['color'] as String?);
        return Container(
          color: Colors.transparent,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            props['content'] as String? ?? '',
            style: GoogleFonts.inter(
              fontSize:
                  (props['font_size'] as num?)?.toDouble() ?? 16,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        );

      default:
        final title = props['title'] as String? ?? widget.type.label;
        return Container(
          color: cs.surfaceContainerLowest,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.inter(
                      fontSize: 13, fontWeight: FontWeight.w700)),
              Expanded(
                child: Center(
                  child: Icon(Icons.bar_chart_rounded,
                      size: 40, color: cs.outlineVariant),
                ),
              ),
            ],
          ),
        );
    }
  }
}

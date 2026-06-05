import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

/// Signature pad widget for capturing signatures.
///
/// Provides a drawing surface for users to sign with touch/mouse.
class SignaturePadWidget extends StatefulWidget {
  /// Callback when signature is captured.
  final void Function(String signatureData)? onSigned;

  /// Whether the signature pad is read-only.
  final bool readOnly;

  /// Background color of the pad.
  final Color backgroundColor;

  /// Stroke color for drawing.
  final Color strokeColor;

  /// Stroke width for drawing.
  final double strokeWidth;

  /// Initial signature data (base64).
  final String? initialData;

  const SignaturePadWidget({
    super.key,
    this.onSigned,
    this.readOnly = false,
    this.backgroundColor = Colors.white,
    this.strokeColor = Colors.black,
    this.strokeWidth = 2.5,
    this.initialData,
  });

  @override
  State<SignaturePadWidget> createState() => _SignaturePadWidgetState();
}

class _SignaturePadWidgetState extends State<SignaturePadWidget> {
  final GlobalKey _repaintKey = GlobalKey();
  final List<Offset?> _points = <Offset?>[];
  final List<List<Offset?>> _strokes = [];
  Offset? _currentPoint;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _loadInitialSignature(widget.initialData!);
    }
  }

  Future<void> _loadInitialSignature(String data) async {
    try {
      final bytes = base64Decode(data);
      await _loadImage(bytes);
      setState(() {});
    } catch (e) {
      debugPrint('Failed to load initial signature: $e');
    }
  }

  Future<ui.Image> _loadImage(Uint8List bytes) async {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: RepaintBoundary(
            key: _repaintKey,
            child: GestureDetector(
              onPanStart: widget.readOnly ? null : _onPanStart,
              onPanUpdate: widget.readOnly ? null : _onPanUpdate,
              onPanEnd: widget.readOnly ? null : _onPanEnd,
              child: CustomPaint(
                size: const Size(double.infinity, 200),
                painter: _SignaturePainter(
                  strokes: _strokes,
                  currentPoint: _currentPoint,
                  strokeColor: widget.strokeColor,
                  strokeWidth: widget.strokeWidth,
                  backgroundColor: widget.backgroundColor,
                ),
              ),
            ),
          ),
        ),
        if (!widget.readOnly) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: _clear,
                icon: const Icon(Icons.clear, color: Colors.red),
                label: const Text('Clear'),
              ),
              ElevatedButton.icon(
                onPressed: _strokes.isEmpty ? null : _save,
                icon: const Icon(Icons.check),
                label: const Text('Save Signature'),
              ),
            ],
          ),
        ],
      ],
    );
  }

  void _onPanStart(DragStartDetails details) {
    final renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    setState(() {
      _currentPoint = localPosition;
      _points.add(localPosition);
      _strokes.add([localPosition]);
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    setState(() {
      _currentPoint = localPosition;
      _points.add(localPosition);
      _strokes.last.add(localPosition);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _currentPoint = null;
      _points.add(null);
    });
  }

  void _clear() {
    setState(() {
      _points.clear();
      _strokes.clear();
      _currentPoint = null;
    });
    widget.onSigned?.call('');
  }

  Future<void> _save() async {
    try {
      final boundary =
          _repaintKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData?.buffer.asUint8List();
      if (bytes == null) return;

      final base64Data = base64Encode(bytes);
      widget.onSigned?.call(base64Data);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Signature saved!')));
      }
    } catch (e) {
      debugPrint('Failed to save signature: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
      }
    }
  }
}

class _SignaturePainter extends CustomPainter {
  final List<List<Offset?>> strokes;
  final Offset? currentPoint;
  final Color strokeColor;
  final double strokeWidth;
  final Color backgroundColor;

  _SignaturePainter({
    required this.strokes,
    this.currentPoint,
    required this.strokeColor,
    required this.strokeWidth,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Draw background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = backgroundColor,
    );

    // Draw completed strokes
    for (final stroke in strokes) {
      if (stroke.length < 2) continue;
      final path = Path()..moveTo(stroke[0]!.dx, stroke[0]!.dy);
      for (int i = 1; i < stroke.length; i++) {
        if (stroke[i] != null) {
          path.lineTo(stroke[i]!.dx, stroke[i]!.dy);
        }
      }
      canvas.drawPath(path, paint);
    }

    // Draw current stroke
    if (currentPoint != null && strokes.isNotEmpty) {
      final lastStroke = strokes.last;
      if (lastStroke.isNotEmpty) {
        final path = Path()..moveTo(lastStroke.last!.dx, lastStroke.last!.dy);
        path.lineTo(currentPoint!.dx, currentPoint!.dy);
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) {
    return oldDelegate.strokes != strokes ||
        oldDelegate.currentPoint != currentPoint ||
        oldDelegate.strokeColor != strokeColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

/// A dialog that embeds a [SignaturePadWidget] and returns the captured 
/// signature as [Uint8List] bytes, or [null] if cancelled.
class SignaturePadDialog extends StatelessWidget {
  const SignaturePadDialog({super.key});

  static Future<Uint8List?> show(BuildContext context) {
    return showDialog<Uint8List>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const SignaturePadDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Row(
                children: [
                  const Icon(Icons.draw, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Sign Here',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(null),
                    icon: const Icon(Icons.close, color: Colors.white),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SignaturePadWidget(
                onSigned: (base64String) {
                  if (base64String.isNotEmpty) {
                    Navigator.of(context).pop(base64Decode(base64String));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

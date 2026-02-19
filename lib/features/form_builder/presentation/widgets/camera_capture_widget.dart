import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import '../../../../core/theme/app_colors.dart';

/// A dialog that opens the browser camera via [getUserMedia], shows a live
/// preview with [HtmlElementView], and lets the user capture a still frame.
/// Returns the captured image as [Uint8List] bytes, or [null] if cancelled.
class CameraCaptureDialog extends StatefulWidget {
  const CameraCaptureDialog({super.key});

  static Future<Uint8List?> show(BuildContext context) {
    return showDialog<Uint8List>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const CameraCaptureDialog(),
    );
  }

  @override
  State<CameraCaptureDialog> createState() => _CameraCaptureDialogState();
}

class _CameraCaptureDialogState extends State<CameraCaptureDialog> {
  // Unique per instance so simultaneous dialogs don't collide.
  late final String _viewType;

  // Created eagerly in initState so the factory always returns the
  // same element that we later attach the stream to.
  late final web.HTMLVideoElement _videoEl;

  web.MediaStream? _stream;

  bool _isLoading = true;
  bool _permissionDenied = false;
  bool _capturing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _viewType = 'camera-preview-${DateTime.now().microsecondsSinceEpoch}';

    // ── 1. Create the <video> element BEFORE registering the factory ──────
    _videoEl = web.HTMLVideoElement()
      ..autoplay = true
      ..muted = true;

    // setAttribute for cross-browser safety on mobile/iOS
    _videoEl.setAttribute('playsinline', '');
    _videoEl.setAttribute('autoplay', '');
    _videoEl.setAttribute('muted', '');

    _videoEl.style
      ..setProperty('width', '100%', '')
      ..setProperty('height', '100%', '')
      ..setProperty('object-fit', 'cover', '')
      ..setProperty('background-color', '#000000', '');

    // ── 2. Register the factory — just hand back the existing element ──────
    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) => _videoEl,
    );

    // ── 3. Start the camera ───────────────────────────────────────────────
    WidgetsBinding.instance.addPostFrameCallback((_) => _startCamera());
  }

  Future<void> _startCamera() async {
    try {
      final stream = await web.window.navigator.mediaDevices
          .getUserMedia(
            web.MediaStreamConstraints(video: true.toJS, audio: false.toJS),
          )
          .toDart;

      _stream = stream;

      // Attach stream and play — element is already constructed so this
      // works even before HtmlElementView renders it into the DOM.
      _videoEl.srcObject = stream;
      await _videoEl.play().toDart;

      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      final msg = e.toString();
      if (mounted) {
        setState(() {
          _isLoading = false;
          _permissionDenied =
              msg.contains('NotAllowed') || msg.contains('Permission');
          _errorMessage = msg;
        });
      }
    }
  }

  Future<Uint8List?> _captureFrame() async {
    if (_capturing) return null;
    setState(() => _capturing = true);

    try {
      final w = _videoEl.videoWidth;
      final h = _videoEl.videoHeight;
      if (w == 0 || h == 0) return null;

      final canvas = web.HTMLCanvasElement()
        ..width = w
        ..height = h;

      final ctx = canvas.getContext('2d') as web.CanvasRenderingContext2D?;
      if (ctx == null) return null;

      ctx.drawImage(_videoEl, 0, 0);

      // toDataURL returns a Dart String: "data:image/jpeg;base64,..."
      final dataUrl = canvas.toDataURL('image/jpeg', 0.9.toJS);
      final base64Part = dataUrl.split(',').last;
      return base64Decode(base64Part);
    } catch (e) {
      debugPrint('Capture error: $e');
      return null;
    } finally {
      if (mounted) setState(() => _capturing = false);
    }
  }

  void _stopStream() {
    try {
      _stream?.getTracks().toDart.forEach((t) => t.stop());
      _videoEl.srcObject = null;
    } catch (_) {}
  }

  void _cancel() {
    _stopStream();
    if (mounted) Navigator.of(context).pop(null);
  }

  @override
  void dispose() {
    _stopStream();
    super.dispose();
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
            // ── Header ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(color: AppColors.primary),
              child: Row(
                children: [
                  const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Camera',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _cancel,
                    icon: const Icon(Icons.close, color: Colors.white),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),

            // ── Body ────────────────────────────────────────────────
            if (_isLoading)
              _buildStatus(
                icon: const Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(),
                ),
                message:
                    'Requesting camera access…\n\n'
                    'Please click "Allow" when your browser asks for permission.',
              )
            else if (_permissionDenied)
              _buildStatus(
                icon: const Icon(
                  Icons.no_photography,
                  size: 64,
                  color: Colors.redAccent,
                ),
                message:
                    'Camera access was denied.\n\n'
                    'Click the 🔒 / camera icon in your browser\'s address bar '
                    'and allow camera access, then try again.',
                isError: true,
              )
            else if (_errorMessage != null)
              _buildStatus(
                icon: const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.orange,
                ),
                message: 'Could not open camera:\n$_errorMessage',
                isError: true,
              )
            else ...[
              // ── Live viewfinder ─────────────────────────────────
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ColoredBox(
                  color: Colors.black,
                  child: HtmlElementView(viewType: _viewType),
                ),
              ),

              // ── Shutter bar ─────────────────────────────────────
              Container(
                color: const Color(0xFF111827),
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Cancel
                    TextButton.icon(
                      onPressed: _cancel,
                      icon: const Icon(Icons.close, color: Colors.white54),
                      label: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),

                    // Shutter
                    GestureDetector(
                      onTap: () async {
                        final nav = Navigator.of(context);
                        final bytes = await _captureFrame();
                        if (bytes != null && mounted) {
                          _stopStream();
                          nav.pop(bytes);
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _capturing ? Colors.grey : Colors.white,
                          border: Border.all(color: Colors.white38, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.25),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: _capturing
                            ? const Padding(
                                padding: EdgeInsets.all(18),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.camera,
                                size: 34,
                                color: Colors.black87,
                              ),
                      ),
                    ),

                    // Spacer to balance layout
                    const SizedBox(width: 88),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatus({
    required Widget icon,
    required String message,
    bool isError = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 44),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(height: 20),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isError ? Colors.red.shade700 : AppColors.textDark,
              fontSize: 14,
              height: 1.65,
            ),
          ),
          if (isError) ...[
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: _cancel,
              icon: const Icon(Icons.close),
              label: const Text('Close'),
            ),
          ],
        ],
      ),
    );
  }
}

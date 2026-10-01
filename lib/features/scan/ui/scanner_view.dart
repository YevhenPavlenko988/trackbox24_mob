import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:trackbox24_mob/core/util/scan_code.dart';

/// Camera preview that reports normalized codes, at most once per [debounce] per code.
class ScannerView extends StatefulWidget {
  const ScannerView({
    required this.onCode,
    this.enabled = true,
    this.debounce = const Duration(milliseconds: 1500),
    super.key,
  });

  final void Function(String code) onCode;

  /// While false, detections are ignored (e.g. a request is in flight).
  final bool enabled;
  final Duration debounce;

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  final _controller = MobileScannerController(
    formats: const [
      BarcodeFormat.code128,
      BarcodeFormat.ean13,
      BarcodeFormat.qrCode,
    ],
    detectionTimeoutMs: 500,
  );
  final _lastSeen = <String, DateTime>{};

  void _onDetect(BarcodeCapture capture) {
    if (!widget.enabled) return;
    final now = DateTime.now();
    for (final b in capture.barcodes) {
      final raw = b.rawValue;
      if (raw == null || raw.isEmpty) continue;
      final code = normalizeScanCode(raw);
      final last = _lastSeen[code];
      if (last != null && now.difference(last) < widget.debounce) continue;
      _lastSeen[code] = now;
      widget.onCode(code);
      return;
    }
  }

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          controller: _controller,
          onDetect: _onDetect,
          errorBuilder: (context, error) => _CameraError(error),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, state, _) => IconButton.filledTonal(
              onPressed: state.isInitialized ? _controller.toggleTorch : null,
              icon: Icon(
                state.torchState == TorchState.on
                    ? Icons.flashlight_on
                    : Icons.flashlight_off,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CameraError extends StatelessWidget {
  const _CameraError(this.error);

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            error.errorDetails?.message ?? error.errorCode.name,
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

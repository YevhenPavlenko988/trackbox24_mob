import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
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

/// Scan screens can be alive two at a time: one sits in the "Сканувати" tab and another is pushed on top of it
/// from a trip. The platform runs one camera, so the newcomer used to be told the controller is already running
/// and showed a dead preview. The newest view owns the camera and the ones underneath wait their turn.
final List<_ScannerViewState> _liveScanners = [];

Future<void> _handOverCamera() async {
  final top = _liveScanners.isEmpty ? null : _liveScanners.last;
  for (final other in List.of(_liveScanners)) {
    if (!identical(other, top)) {
      await other._stop();
    }
  }
  // Starting only once the others have let go, or the platform refuses again.
  if (top != null && top.mounted) {
    await top._start();
  }
}

/// The camera is started/stopped by this widget, not by mobile_scanner's own lifecycle handling: the package
/// fires `stop()` on inactive and `start()` on resumed without waiting for the previous call, which races on the
/// first launch (permission dialog → inactive → resumed) and ends in "controller is already running".
class _ScannerViewState extends State<ScannerView> with WidgetsBindingObserver {
  final _controller = MobileScannerController(
    formats: const [
      BarcodeFormat.code128,
      BarcodeFormat.ean13,
      BarcodeFormat.qrCode,
    ],
    detectionTimeoutMs: 500,
    autoStart: false,
  );
  final _lastSeen = <String, DateTime>{};

  /// Start/stop calls are chained so they never overlap.
  Future<void> _ops = Future.value();
  MobileScannerException? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _liveScanners.add(this);
    unawaited(_handOverCamera());
  }

  Future<void> _start() {
    return _ops = _ops.then((_) async {
      if (!mounted || _controller.value.isRunning) return;
      try {
        await _controller.start();
        if (mounted && _error != null) setState(() => _error = null);
      } on MobileScannerException catch (e) {
        // Native side says the camera is already on: that is the state we want.
        if (e.errorCode ==
            MobileScannerErrorCode.controllerAlreadyInitialized) {
          return;
        }
        if (mounted) setState(() => _error = e);
      }
    });
  }

  Future<void> _stop() {
    return _ops = _ops.then((_) async {
      if (!_controller.value.isRunning) return;
      try {
        await _controller.stop();
      } on MobileScannerException {
        // Nothing to do: the next start() checks the real state.
      }
    });
  }

  void _restart() {
    setState(() => _error = null);
    _ops = _ops.then((_) async {
      try {
        await _controller.stop();
      } on MobileScannerException {
        // ignore, we only want a clean start
      }
    });
    // Whoever else holds the camera has to let go first, otherwise the retry fails the same way.
    unawaited(_handOverCamera());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_controller.value.hasCameraPermission) return;
    switch (state) {
      case AppLifecycleState.resumed:
        // Only the view on top takes the camera back; the ones underneath stay quiet.
        if (identical(_liveScanners.lastOrNull, this)) unawaited(_start());
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        unawaited(_stop());
      case AppLifecycleState.detached:
        break;
    }
  }

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
    WidgetsBinding.instance.removeObserver(this);
    _liveScanners.remove(this);
    // The camera goes back to the view underneath, but only once this one has really let go of it.
    unawaited(
      _ops.then((_) async {
        await _controller.dispose();
        await _handOverCamera();
      }),
    );
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
          useAppLifecycleState: false,
          errorBuilder: (context, error) =>
              _CameraError(error, onRetry: _restart),
        ),
        if (_error != null) _CameraError(_error!, onRetry: _restart),
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
  const _CameraError(this.error, {required this.onRetry});

  final MobileScannerException error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                error.errorDetails?.message ?? error.errorCode.name,
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(AppLocalizations.of(context).scan_cameraRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

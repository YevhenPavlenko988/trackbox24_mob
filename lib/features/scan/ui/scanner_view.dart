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
    _start();
  }

  void _start() {
    _ops = _ops.then((_) async {
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

  void _stop() {
    _ops = _ops.then((_) async {
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
    _start();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_controller.value.hasCameraPermission) return;
    switch (state) {
      case AppLifecycleState.resumed:
        _start();
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        _stop();
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
    unawaited(_ops.then((_) => _controller.dispose()));
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

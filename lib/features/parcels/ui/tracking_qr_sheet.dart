import 'dart:async';

import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';

/// The parcel's public tracking page as a QR code: the driver shows the phone, the sender or recipient scans it
/// with the camera and opens the status without signing in. Sharing the link is one tap away for those not at hand.
Future<void> showTrackingQr(BuildContext context, Parcel parcel) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => TrackingQrSheet(parcel: parcel),
    );

class TrackingQrSheet extends StatelessWidget {
  const TrackingQrSheet({required this.parcel, super.key});

  final Parcel parcel;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final url = parcel.trackingUrl!;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l.tracking_title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              parcel.code,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            // White with a quiet zone even in dark mode: cameras read dark modules on a light field.
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SizedBox.square(
                dimension: 240,
                child: TrackingQr(data: url),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l.tracking_hint,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.copy),
                    label: Text(l.tracking_copy),
                    onPressed: () {
                      unawaited(Clipboard.setData(ClipboardData(text: url)));
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(l.np_copied)));
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Builder(
                    builder: (button) => FilledButton.icon(
                      icon: const Icon(Icons.share),
                      label: Text(l.tracking_share),
                      onPressed: () => _share(button, l, url),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _share(
    BuildContext button,
    AppLocalizations l,
    String url,
  ) async {
    // The share sheet on an iPad anchors to the button that opened it.
    final box = button.findRenderObject() as RenderBox?;
    await SharePlus.instance.share(
      ShareParams(
        text: l.tracking_shareText(parcel.code, url),
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }
}

/// A QR code filling its box, modules snapped to whole pixels so the edges stay crisp.
class TrackingQr extends StatelessWidget {
  const TrackingQr({required this.data, super.key});

  final String data;

  @override
  Widget build(BuildContext context) => Semantics(
    label: data,
    image: true,
    child: CustomPaint(painter: _QrPainter(data), size: Size.infinite),
  );
}

class _QrPainter extends CustomPainter {
  _QrPainter(this.data);

  final String data;

  @override
  void paint(Canvas canvas, Size size) {
    final side = size.shortestSide;
    final paint = Paint()..color = Colors.black;
    for (final bar in qrModules(data, side)) {
      canvas.drawRect(
        Rect.fromLTRB(
          bar.left.floorToDouble(),
          bar.top.floorToDouble(),
          bar.right.ceilToDouble(),
          bar.bottom.ceilToDouble(),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_QrPainter old) => old.data != data;
}

/// Dark modules of the QR code for [data] in a square of [side]; medium error correction survives a cracked screen.
Iterable<BarcodeBar> qrModules(String data, double side) =>
    Barcode.qrCode(errorCorrectLevel: BarcodeQRCorrectionLevel.medium)
        .make(data, width: side, height: side)
        .whereType<BarcodeBar>()
        .where((b) => b.black);

import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:trackbox24_mob/core/ui/np_number.dart';
import 'package:trackbox24_mob/features/parcels/label/label_data.dart';

/// 70×40 mm at 8 dots per mm — the 203 dpi of a NIIMBOT B3S. The painter works in these dots, so a bar is
/// always a whole number of printer dots and the codes stay crisp after the app's 1-bit rasterisation.
const labelWidthDots = 560.0;
const labelHeightDots = 320.0;

/// Draws a [ParcelLabel] into any box, keeping the 70:40 proportions of the tape.
class LabelPainter extends CustomPainter {
  LabelPainter(this.label);

  final ParcelLabel label;

  static const _pad = 16.0; // 2 mm
  static const _gap = 12.0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..scale(size.width / labelWidthDots, size.height / labelHeightDots)
      ..drawRect(
        const Rect.fromLTWH(0, 0, labelWidthDots, labelHeightDots),
        Paint()..color = Colors.white,
      );
    const width = labelWidthDots - 2 * _pad;
    var top = _pad;

    final waybill = label.waybill;
    if (waybill != null) {
      // The whole number above the bars, grouped as Nova Poshta prints it; the last four digits bigger and
      // bold, because that is what the branch asks for. The bars then take the full width.
      final caption = _painter(
        TextSpan(
          children: [
            const TextSpan(text: 'НП  '),
            npNumberSpan(
              waybill,
              grouped: true,
              style: _style(26),
              emphasis: 1.35,
            ),
          ],
        ),
        font: 26,
        maxWidth: width,
      );
      caption.paint(canvas, Offset(_pad, top));
      top += caption.height + 4;
      const barsHeight = 64.0;
      drawBarcode(canvas, waybill, Rect.fromLTWH(_pad, top, width, barsHeight));
      top += barsHeight + 10;
    }

    final meta = [
      if (label.seat != null) '${label.seat}/${label.total}',
      if (label.weightKg != null) '${_weight(label.weightKg!)} кг',
    ].join(' · ');
    top += _textRow(
      canvas,
      left: label.line ?? '',
      right: meta,
      top: top,
      width: width,
    );
    top += _gap;

    final codeHeight = labelHeightDots - _pad - top;
    _codeRow(
      canvas,
      label.code,
      label.code,
      top: top,
      width: width,
      height: codeHeight,
      font: 22,
      mono: true,
    );
    canvas.restore();
  }

  /// A Code 128 on the left, its human-readable number on the right. The number is never cut: it is
  /// measured first and the bars get the rest of the row (down to two dots per module).
  void _codeRow(
    Canvas canvas,
    String data,
    Object text, {
    required double top,
    required double width,
    required double height,
    required double font,
    bool bold = false,
    bool mono = false,
  }) {
    final wanted = _painter(
      text,
      font: font,
      bold: bold,
      mono: mono,
      maxLines: 2,
    );
    final drawn = drawBarcode(
      canvas,
      data,
      Rect.fromLTWH(_pad, top, width - wanted.width - _gap, height),
    );
    final painter = _painter(
      text,
      font: font,
      bold: bold,
      mono: mono,
      maxLines: 2,
      maxWidth: width - drawn - _gap,
    );
    painter.paint(
      canvas,
      Offset(_pad + drawn + _gap, top + (height - painter.height) / 2),
    );
  }

  /// Who gets the parcel and where (up to two lines), the seat and the weight on the right. Returns the height.
  double _textRow(
    Canvas canvas, {
    required String left,
    required String right,
    required double top,
    required double width,
  }) {
    final rightPainter = _painter(right, font: 23, bold: true);
    final leftPainter = _painter(
      left,
      font: 23,
      maxLines: 2,
      maxWidth: width - rightPainter.width - _gap,
    );
    leftPainter.paint(canvas, Offset(_pad, top));
    rightPainter.paint(canvas, Offset(_pad + width - rightPainter.width, top));
    return math.max(leftPainter.height, rightPainter.height);
  }

  /// [text] is a plain string or a ready [TextSpan] (its own styles win over the row style).
  TextPainter _painter(
    Object text, {
    required double font,
    bool bold = false,
    bool mono = false,
    int maxLines = 1,
    double maxWidth = double.infinity,
  }) {
    final style = _style(font, bold: bold, mono: mono);
    return TextPainter(
      text: text is TextSpan
          ? TextSpan(style: style, children: [text])
          : TextSpan(text: text as String, style: style),
      textDirection: TextDirection.ltr,
      maxLines: maxLines,
      ellipsis: '…',
    )..layout(maxWidth: maxWidth);
  }

  static TextStyle _style(
    double font, {
    bool bold = false,
    bool mono = false,
  }) => TextStyle(
    color: Colors.black,
    fontSize: font,
    height: 1.15,
    fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
    fontFamily: mono ? 'monospace' : null,
    fontFeatures: const [ui.FontFeature.tabularFigures()],
  );

  static String _weight(double kg) =>
      kg == kg.roundToDouble() ? '${kg.toInt()}' : kg.toString();

  @override
  bool shouldRepaint(LabelPainter old) => old.label != label;
}

/// Paints [data] as Code 128 into [box], left-aligned, with every module a whole number of dots (at least two).
/// Returns the width actually used, so a caption can sit right next to the bars.
double drawBarcode(Canvas canvas, String data, Rect box) {
  final code = Barcode.code128();
  // One pass to learn the module count: the narrowest bar is one module wide.
  final probe = code
      .make(data, width: 10000, height: 1)
      .whereType<BarcodeBar>();
  final module = probe.map((b) => b.width).reduce(math.min);
  final modules = (10000 / module).round();
  final dotsPerModule = math.max(2, (box.width / modules).floor());
  final width = modules * dotsPerModule.toDouble();
  final paint = Paint()..color = Colors.black;
  for (final bar
      in code
          .make(data, width: width, height: box.height)
          .whereType<BarcodeBar>()) {
    if (!bar.black) continue;
    canvas.drawRect(
      Rect.fromLTWH(
        box.left + bar.left.roundToDouble(),
        box.top + bar.top,
        bar.width.roundToDouble(),
        bar.height,
      ),
      paint,
    );
  }
  return width;
}

/// The label as a PNG for the NIIMBOT app: [scale] × the printer's own dots.
Future<Uint8List> renderLabelPng(ParcelLabel label, {int scale = 2}) async {
  final recorder = ui.PictureRecorder();
  final size = Size(labelWidthDots * scale, labelHeightDots * scale);
  LabelPainter(label).paint(Canvas(recorder), size);
  final image = await recorder.endRecording().toImage(
    size.width.toInt(),
    size.height.toInt(),
  );
  try {
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  } finally {
    image.dispose();
  }
}

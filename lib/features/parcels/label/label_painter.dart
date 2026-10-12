import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
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
  static const _lineHeight = 30.0;

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
      const height = 90.0;
      _codeRow(
        canvas,
        waybill,
        'НП\n${groupWaybill(waybill)}',
        top: top,
        width: width,
        height: height,
        textWidth: 150,
        font: 22,
        bold: true,
      );
      top += height + _gap;
    }

    final meta = [
      if (label.seat != null) '${label.seat}/${label.total}',
      if (label.weightKg != null) '${_weight(label.weightKg!)} кг',
    ].join(' · ');
    _textRow(
      canvas,
      left: label.line ?? '',
      right: meta,
      top: top,
      width: width,
    );
    top += _lineHeight + _gap;

    final codeHeight = labelHeightDots - _pad - top;
    _codeRow(
      canvas,
      label.code,
      label.code,
      top: top,
      width: width,
      height: codeHeight,
      // `PT…-N` is 14 monospace characters: room for them on one line, the bars take the rest.
      textWidth: 195,
      font: 22,
      mono: true,
    );
    canvas.restore();
  }

  /// A Code 128 on the left, its human-readable number on the right.
  void _codeRow(
    Canvas canvas,
    String data,
    String text, {
    required double top,
    required double width,
    required double height,
    required double textWidth,
    required double font,
    bool bold = false,
    bool mono = false,
  }) {
    final codeWidth = width - textWidth - _gap;
    final drawn = drawBarcode(
      canvas,
      data,
      Rect.fromLTWH(_pad, top, codeWidth, height),
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

  void _textRow(
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
      maxWidth: width - rightPainter.width - _gap,
    );
    leftPainter.paint(canvas, Offset(_pad, top));
    rightPainter.paint(canvas, Offset(_pad + width - rightPainter.width, top));
  }

  TextPainter _painter(
    String text, {
    required double font,
    bool bold = false,
    bool mono = false,
    int maxLines = 1,
    double maxWidth = double.infinity,
  }) {
    return TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.black,
          fontSize: font,
          height: 1.15,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          fontFamily: mono ? 'monospace' : null,
          fontFeatures: const [ui.FontFeature.tabularFigures()],
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: maxLines,
      ellipsis: '…',
    )..layout(maxWidth: maxWidth);
  }

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
  final probe = code.make(data, width: 10000, height: 1).whereType<BarcodeBar>();
  final module = probe.map((b) => b.width).reduce(math.min);
  final modules = (10000 / module).round();
  final dotsPerModule = math.max(2, (box.width / modules).floor());
  final width = modules * dotsPerModule.toDouble();
  final paint = Paint()..color = Colors.black;
  for (final bar in code
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

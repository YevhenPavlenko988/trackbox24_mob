import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:trackbox24_mob/core/ui/np_number.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/parcels/label/label_data.dart';
import 'package:trackbox24_mob/features/printer/niimbot/label_bitmap.dart';

/// 70 mm long at 8 dots per mm — the 203 dpi of a NIIMBOT B3S. The painter works in these dots, so a bar is
/// always a whole number of printer dots and the codes stay crisp after the app's 1-bit rasterisation. The
/// short side follows the roll: 50 mm (the client's 50×70 rolls) unless told otherwise.
const labelWidthDots = 560.0;
const labelHeightDots = 400.0;

/// Draws a [ParcelLabel] into any box, keeping the proportions of the label (70 mm by [heightDots]).
///
/// Three bands, top to bottom: the Nova Poshta waybill (its number with the last four digits bold, the bars
/// under it) when it exists, then who gets the parcel — name, city with the phone, branch or street — and at
/// the bottom our `PT…` code with its bars. The printer gets this picture turned 90°, so on the 40 mm tape it
/// reads along the label.
class LabelPainter extends CustomPainter {
  LabelPainter(this.label, {this.heightDots = labelHeightDots});

  final ParcelLabel label;
  final double heightDots;

  static const _pad = 16.0; // 2 mm
  static const _gap = 12.0;
  static const _npBarsHeight = 60.0;
  static const _ptBarsMin = 48.0;
  static const _ptBarsMax = 130.0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..scale(size.width / labelWidthDots, size.height / heightDots)
      ..drawRect(
        Rect.fromLTWH(0, 0, labelWidthDots, heightDots),
        Paint()..color = Colors.white,
      );
    const width = labelWidthDots - 2 * _pad;
    final black = Paint()..color = Colors.black;
    var top = _pad;

    if (label.move) {
      top = _paintMoveTop(canvas, width, top);
    }
    final waybill = label.move ? null : label.waybill;
    if (waybill != null) {
      // The number grouped as Nova Poshta prints it, the last four digits bold — that is what the branch asks
      // for; a small «НП» at the right says which of the two codes this is.
      final tag = _painter('НП', font: 22, bold: true);
      final number = _painter(
        npNumberSpan(waybill, grouped: true, style: _style(38), emphasis: 1),
        font: 38,
        maxWidth: width - tag.width - _gap,
      );
      number.paint(canvas, Offset(_pad, top));
      tag.paint(
        canvas,
        Offset(_pad + width - tag.width, top + number.height - tag.height - 4),
      );
      top += number.height + 2;
      drawBarcode(
        canvas,
        waybill,
        Rect.fromLTWH(_pad, top, width, _npBarsHeight),
        center: true,
      );
      top += _npBarsHeight + 8;
      canvas.drawRect(Rect.fromLTWH(_pad, top, width, 2), black);
      top += 2 + 8;
    }

    if (!label.move) top = _paintRecipient(canvas, width, top);

    // Our code at the bottom: the number above the bars, the seat at the right; the bars take what is left.
    final seat = label.seat == null || label.move
        ? null
        : _painter('${label.seat}/${label.total}', font: 26, bold: true);
    final code = _painter(label.code, font: 26, mono: true, bold: true);
    final codeTop = top;
    top += code.height + 2;
    // a move's label has nothing under the code: its bars take the rest of the tape
    final barsHeight = (heightDots - _pad - top).clamp(
      _ptBarsMin,
      label.move ? heightDots : _ptBarsMax,
    );
    final bars = drawBarcode(
      canvas,
      label.code,
      Rect.fromLTWH(_pad, top, width, barsHeight),
      center: true,
    );
    // The caption sits over the middle of its bars; the seat hugs the right edge.
    code.paint(canvas, Offset(bars.center.dx - code.width / 2, codeTop));
    seat?.paint(canvas, Offset(_pad + width - seat.width, codeTop));
    canvas.restore();
  }

  /// A move's item: «17/120» big with the route at the right, the customer under it, then what the item is on up
  /// to two lines.
  double _paintMoveTop(Canvas canvas, double width, double top) {
    final number = _painter(
      '${label.seat ?? 1}/${label.total}',
      font: 58,
      bold: true,
    );
    final route = label.route == null
        ? null
        : _painter(
            label.route!,
            font: 26,
            bold: true,
            maxWidth: width - number.width - _gap,
          );
    number.paint(canvas, Offset(_pad, top));
    route?.paint(
      canvas,
      Offset(
        _pad + width - route.width,
        top + number.height - route.height - 6,
      ),
    );
    var y = top + number.height;
    if (label.recipient != null) {
      final customer = _painter(label.recipient!, font: 28, maxWidth: width);
      customer.paint(canvas, Offset(_pad, y));
      y += customer.height;
    }
    final what = _painter(
      label.description ?? '—',
      font: 34,
      bold: true,
      maxLines: 2,
      maxWidth: width,
    );
    what.paint(canvas, Offset(_pad, y));
    return y + what.height + 6;
  }

  /// Who gets it: name big, the weight at the right of that line, then the city with the phone and the place.
  double _paintRecipient(Canvas canvas, double width, double start) {
    var top = start;
    final kg = label.weightKg;
    final weight = kg == null
        ? null
        : _painter('${_weight(kg)} кг', font: 24, bold: true);
    final recipient = _painter(
      label.recipient ?? '—',
      font: 40,
      bold: true,
      maxWidth: width - (weight == null ? 0 : weight.width + _gap),
    );
    recipient.paint(canvas, Offset(_pad, top));
    weight?.paint(
      canvas,
      Offset(
        _pad + width - weight.width,
        top + recipient.height - weight.height - 3,
      ),
    );
    top += recipient.height;

    final phone = label.phone == null ? null : formatPhone(label.phone);
    final cityLine = [
      label.city,
      if (phone != null && phone != '—') phone,
    ].where((x) => x != null && x.isNotEmpty).join('  ·  ');
    if (cityLine.isNotEmpty) {
      final city = _painter(cityLine, font: 27, maxWidth: width);
      city.paint(canvas, Offset(_pad, top));
      top += city.height;
    }
    final place = label.place;
    if (place != null && place.isNotEmpty) {
      final p = _painter(place, font: 32, bold: true, maxWidth: width);
      p.paint(canvas, Offset(_pad, top));
      top += p.height;
    }
    return top + 4;
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
  bool shouldRepaint(LabelPainter old) =>
      old.label != label || old.heightDots != heightDots;
}

/// Paints [data] as Code 128 into [box], every module a whole number of dots (at least two), left-aligned or
/// centred. Returns the rectangle the bars actually cover, so a caption can line up with them.
Rect drawBarcode(Canvas canvas, String data, Rect box, {bool center = false}) {
  final code = Barcode.code128();
  // One pass to learn the module count: the narrowest bar is one module wide.
  final probe = code
      .make(data, width: 10000, height: 1)
      .whereType<BarcodeBar>();
  final module = probe.map((b) => b.width).reduce((a, b) => a < b ? a : b);
  final modules = (10000 / module).round();
  final dotsPerModule = (box.width / modules).floor().clamp(2, 1 << 16);
  final width = modules * dotsPerModule.toDouble();
  final left = center
      ? box.left + ((box.width - width) / 2).floorToDouble()
      : box.left;
  final paint = Paint()..color = Colors.black;
  for (final bar
      in code
          .make(data, width: width, height: box.height)
          .whereType<BarcodeBar>()) {
    if (!bar.black) continue;
    canvas.drawRect(
      Rect.fromLTWH(
        left + bar.left.roundToDouble(),
        box.top + bar.top,
        bar.width.roundToDouble(),
        bar.height,
      ),
      paint,
    );
  }
  return Rect.fromLTWH(left, box.top, width, box.height);
}

/// The label as a PNG for the NIIMBOT app: [scale] × the printer's own dots.
Future<Uint8List> renderLabelPng(
  ParcelLabel label, {
  int scale = 2,
  double heightDots = labelHeightDots,
}) async {
  final recorder = ui.PictureRecorder();
  final size = Size(labelWidthDots * scale, heightDots * scale);
  LabelPainter(label, heightDots: heightDots).paint(Canvas(recorder), size);
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

/// The label as the printer's own 1-bit dots, one per dot of the 203 dpi head.
Future<LabelBitmap> renderLabelBitmap(
  ParcelLabel label, {
  double heightDots = labelHeightDots,
}) async {
  final recorder = ui.PictureRecorder();
  final size = Size(labelWidthDots, heightDots);
  LabelPainter(label, heightDots: heightDots).paint(Canvas(recorder), size);
  final image = await recorder.endRecording().toImage(
    labelWidthDots.toInt(),
    heightDots.toInt(),
  );
  try {
    final data = await image.toByteData();
    return LabelBitmap.fromRgba(
      data!.buffer.asUint8List(),
      width: labelWidthDots.toInt(),
      height: heightDots.toInt(),
    );
  } finally {
    image.dispose();
  }
}

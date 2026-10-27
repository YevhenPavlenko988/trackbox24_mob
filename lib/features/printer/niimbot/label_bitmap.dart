import 'dart:typed_data';

import 'package:trackbox24_mob/features/printer/niimbot/niimbot_packet.dart';

/// A 1-bit image the way the printer wants it: rows of `width / 8` bytes, most significant bit first, a set bit
/// being a black dot. The first row is the edge that leaves the printer first.
class LabelBitmap {
  LabelBitmap({required this.width, required this.height, required this.rows})
    : assert(width % 8 == 0, 'width must be a multiple of 8 dots'),
      assert(
        rows.length == width ~/ 8 * height,
        'rows must hold width/8 bytes per row',
      );

  /// Thresholds an RGBA image (as `ui.Image.toByteData(format: rawRgba)` gives it): a dot is black when the pixel
  /// is darker than mid-grey, which keeps anti-aliased text readable and leaves whole-dot barcodes exact.
  factory LabelBitmap.fromRgba(
    Uint8List rgba, {
    required int width,
    required int height,
  }) {
    final rowBytes = width ~/ 8;
    final rows = Uint8List(rowBytes * height);
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final i = (y * width + x) * 4;
        // Rec. 601 luma, integer arithmetic; alpha is ignored (the label is drawn on white).
        final luma =
            (rgba[i] * 299 + rgba[i + 1] * 587 + rgba[i + 2] * 114) ~/ 1000;
        if (luma < 128) rows[y * rowBytes + (x >> 3)] |= 0x80 >> (x & 7);
      }
    }
    return LabelBitmap(width: width, height: height, rows: rows);
  }

  final int width;
  final int height;
  final Uint8List rows;

  int get rowBytes => width ~/ 8;

  Uint8List row(int y) =>
      Uint8List.sublistView(rows, y * rowBytes, (y + 1) * rowBytes);

  bool isBlack(int x, int y) =>
      rows[y * rowBytes + (x >> 3)] & (0x80 >> (x & 7)) != 0;
}

/// Turns a bitmap into the row packets of a page: equal rows are sent once with a repeat count, blank rows as
/// `PrintEmptyRow`, rows with at most six dots as a list of dot positions (`PrintBitmapRowIndexed`).
///
/// [printheadPixels] is the printer's head width; the packet carries black-dot counts of each third of the head.
List<NiimbotPacket> encodeBitmapRows(
  LabelBitmap bitmap, {
  required int printheadPixels,
}) {
  final packets = <NiimbotPacket>[];
  Uint8List? lastRow;
  var lastStart = 0;

  void flush(int end) {
    final row = lastRow;
    if (row == null) return;
    // The repeat count is one byte.
    for (var start = lastStart; start < end; start += 255) {
      final repeats = end - start < 255 ? end - start : 255;
      final black = _countBlack(row);
      if (black == 0) {
        packets.add(
          NiimbotPacket(NiimbotCmd.printEmptyRow, [...u16(start), repeats]),
        );
      } else if (black <= 6) {
        packets.add(
          NiimbotPacket(NiimbotCmd.printBitmapRowIndexed, [
            ...u16(start),
            ..._thirds(row, printheadPixels),
            repeats,
            ..._indexes(row),
          ]),
        );
      } else {
        packets.add(
          NiimbotPacket(NiimbotCmd.printBitmapRow, [
            ...u16(start),
            ..._thirds(row, printheadPixels),
            repeats,
            ...row,
          ]),
        );
      }
    }
  }

  for (var y = 0; y < bitmap.height; y++) {
    final row = bitmap.row(y);
    if (lastRow != null && _equal(lastRow, row)) continue;
    flush(y);
    lastRow = row;
    lastStart = y;
  }
  flush(bitmap.height);
  return packets;
}

int _countBlack(Uint8List row) {
  var n = 0;
  for (final b in row) {
    n += _bitCount[b];
  }
  return n;
}

/// Black dots in each third of the head (`split` mode of niimbluelib); the row fits the head here, so the
/// alternative `total` encoding is never needed.
List<int> _thirds(Uint8List row, int printheadPixels) {
  final chunk = printheadPixels ~/ 8 ~/ 3;
  final parts = [0, 0, 0];
  for (var i = 0; i < row.length; i++) {
    final idx = i ~/ chunk;
    if (idx > 2) break;
    parts[idx] += _bitCount[row[i]];
  }
  return parts.map((p) => p & 0xff).toList();
}

List<int> _indexes(Uint8List row) {
  final out = <int>[];
  for (var i = 0; i < row.length; i++) {
    final b = row[i];
    if (b == 0) continue;
    for (var bit = 0; bit < 8; bit++) {
      if (b & (0x80 >> bit) != 0) out.addAll(u16(i * 8 + bit));
    }
  }
  return out;
}

bool _equal(Uint8List a, Uint8List b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

final _bitCount = List<int>.generate(256, (v) {
  var n = 0;
  for (var x = v; x != 0; x >>= 1) {
    n += x & 1;
  }
  return n;
});

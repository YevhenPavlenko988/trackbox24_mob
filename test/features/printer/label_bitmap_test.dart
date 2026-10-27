import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/features/printer/niimbot/label_bitmap.dart';
import 'package:trackbox24_mob/features/printer/niimbot/niimbot_packet.dart';

/// A bitmap from rows of '#' and '.'; every row must be the same width.
LabelBitmap bitmap(List<String> rows) {
  final width = rows.first.length;
  final rgba = Uint8List(width * rows.length * 4);
  for (var y = 0; y < rows.length; y++) {
    for (var x = 0; x < width; x++) {
      final v = rows[y][x] == '#' ? 0 : 255;
      final i = (y * width + x) * 4;
      rgba[i] = v;
      rgba[i + 1] = v;
      rgba[i + 2] = v;
      rgba[i + 3] = 255;
    }
  }
  return LabelBitmap.fromRgba(rgba, width: width, height: rows.length);
}

void main() {
  test('thresholds RGBA into MSB-first dots', () {
    final b = bitmap(['#.......#.......', '................']);
    expect(b.rowBytes, 2);
    expect(b.row(0), [0x80, 0x80]);
    expect(b.row(1), [0, 0]);
    expect(b.isBlack(8, 0), isTrue);
    expect(b.isBlack(9, 0), isFalse);
  });

  test('encodes blank runs, sparse rows as indexes, dense rows as bitmaps, with repeats', () {
    final b = bitmap([
      '................',
      '................',
      '#.......#.......', // two dots → indexed
      '#.......#.......',
      '########........', // eight dots → full row
      '................',
    ]);
    final packets = encodeBitmapRows(b, printheadPixels: 576);
    expect(packets.map((p) => p.command), [
      NiimbotCmd.printEmptyRow,
      NiimbotCmd.printBitmapRowIndexed,
      NiimbotCmd.printBitmapRow,
      NiimbotCmd.printEmptyRow,
    ]);
    // Row 0, two blank rows.
    expect(packets[0].data, [0, 0, 2]);
    // Row 2 twice: counts per third of the head, dot indexes 0 and 8.
    expect(packets[1].data, [0, 2, 2, 0, 0, 2, 0, 0, 0, 8]);
    // Row 4 once: eight dots, then the row bytes.
    expect(packets[2].data, [0, 4, 8, 0, 0, 1, 0xff, 0]);
    expect(packets[3].data, [0, 5, 1]);
  });

  test('splits a blank run longer than one byte of repeats', () {
    final b = bitmap(List.filled(300, '........'));
    final packets = encodeBitmapRows(b, printheadPixels: 576);
    expect(packets.map((p) => p.data), [
      [0, 0, 255],
      [0, 255, 45],
    ]);
  });

  test(
    'turns the label clockwise for a roll whose labels lie along the tape',
    () {
      // 16×8: a dot in the top-left corner and one at the top-right.
      final b = bitmap([
        '#..............#',
        '................',
        '................',
        '................',
        '................',
        '................',
        '................',
        '................',
      ]);
      final r = b.rotatedClockwise();
      expect((r.width, r.height), (8, 16));
      // Top-left → top-right; top-right → bottom-right.
      expect(r.isBlack(7, 0), isTrue);
      expect(r.isBlack(7, 15), isTrue);
      expect(r.isBlack(0, 0), isFalse);
    },
  );

  test('pads the page to the head width with the image at the right edge', () {
    final b = bitmap(['#.......', '........']);
    final p = b.padToWidth(32);
    expect((p.width, p.height), (32, 2));
    expect(p.row(0), [0, 0, 0, 0x80]);
    expect(p.row(1), [0, 0, 0, 0]);
    expect(b.padToWidth(8), same(b));
  });
}

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/features/printer/niimbot/label_bitmap.dart';
import 'package:trackbox24_mob/features/printer/niimbot/niimbot_packet.dart';
import 'package:trackbox24_mob/features/printer/niimbot/niimbot_printer.dart';

/// A printer that answers every command the way a B3S does; [statusPolls] print statuses are returned before
/// the page counts as printed.
class FakeB3S implements NiimbotTransport {
  FakeB3S({
    this.statusPolls = 2,
    this.errorOn,
    this.errorCode = NiimbotErrorCode.coverOpen,
  });

  final int statusPolls;

  /// Command that gets a `PrintError` instead of its answer.
  final int? errorOn;
  final int errorCode;

  final sent = <NiimbotPacket>[];
  final _out = StreamController<List<int>>();
  final _reader = NiimbotPacketReader();
  var _polls = 0;
  bool closed = false;

  @override
  Stream<List<int>> get received => _out.stream;

  @override
  Future<void> write(Uint8List bytes) async {
    // The connect packet carries its 0x03 prefix, which the reader drops like the printer does.
    for (final packet in _reader.feed(bytes)) {
      sent.add(packet);
      final reply = _reply(packet);
      if (reply != null) {
        // Answers come back in two chunks, with the stray byte seen on iOS.
        final b = reply.toBytes();
        _out.add([0x03, ...b.sublist(0, 3)]);
        _out.add(b.sublist(3));
      }
    }
  }

  NiimbotPacket? _reply(NiimbotPacket p) {
    if (p.command == errorOn) {
      return NiimbotPacket(NiimbotRsp.printError, [errorCode]);
    }
    return switch (p.command) {
      NiimbotCmd.connect => NiimbotPacket(NiimbotRsp.connect, [
        NiimbotConnectResult.connectedV3,
      ]),
      NiimbotCmd.printerStatusData => NiimbotPacket(
        NiimbotRsp.printerStatusData,
        [
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 1, // protocol 3.01 → version 4
        ],
      ),
      NiimbotCmd.printerInfo
          when p.data.first == NiimbotInfoType.printerModelId =>
        NiimbotPacket(NiimbotRsp.printerInfoModelId, [1, 16]), // 272 = B3S_P
      NiimbotCmd.printerInfo => NiimbotPacket(
        NiimbotRsp.printerInfoChargeLevel,
        [77],
      ),
      NiimbotCmd.setDensity => NiimbotPacket(NiimbotRsp.setDensity, [1]),
      NiimbotCmd.setLabelType => NiimbotPacket(NiimbotRsp.setLabelType, [1]),
      NiimbotCmd.printStart => NiimbotPacket(NiimbotRsp.printStart, [1]),
      NiimbotCmd.pageStart => NiimbotPacket(NiimbotRsp.pageStart, [1]),
      NiimbotCmd.setPageSize => NiimbotPacket(NiimbotRsp.setPageSize, [1]),
      NiimbotCmd.pageEnd => NiimbotPacket(NiimbotRsp.pageEnd, [1]),
      NiimbotCmd.printStatus =>
        ++_polls < statusPolls
            ? NiimbotPacket(NiimbotRsp.printStatus, [0, 0, 50, 0])
            : NiimbotPacket(NiimbotRsp.printStatus, [0, 1, 100, 100]),
      NiimbotCmd.printEnd => NiimbotPacket(NiimbotRsp.printEnd, [1]),
      _ => null, // rows are one-way
    };
  }

  @override
  Future<void> close() async {
    closed = true;
    await _out.close();
  }
}

LabelBitmap testBitmap() {
  // 16×4: a blank row, a sparse row, a dense row, a blank row.
  final rows = Uint8List.fromList([0, 0, 0x80, 0, 0xff, 0xff, 0, 0]);
  return LabelBitmap(width: 16, height: 4, rows: rows);
}

void main() {
  test('connects and reads the model and the charge', () async {
    final fake = FakeB3S();
    final printer = NiimbotPrinter(fake, packetInterval: Duration.zero);
    final info = await printer.connect();
    expect(info.modelId, 272);
    expect(info.modelName, 'B3S_P');
    expect(info.protocolVersion, 4);
    expect(info.batteryPercent, 77);
    expect(info.printheadPixels, 576);
    await printer.close();
    expect(fake.closed, isTrue);
  });

  test('prints a page with the B1 sequence and ends the print', () async {
    final fake = FakeB3S();
    final printer = NiimbotPrinter(fake, packetInterval: Duration.zero);
    await printer.connect();
    final progress = <double>[];
    await printer.printLabel(
      testBitmap(),
      density: 3,
      onProgress: progress.add,
    );
    final commands = fake.sent.map((p) => p.command).toList();
    expect(commands.sublist(0, 4), [
      NiimbotCmd.connect,
      NiimbotCmd.printerStatusData,
      NiimbotCmd.printerInfo,
      NiimbotCmd.printerInfo,
    ]);
    expect(commands.sublist(4), [
      NiimbotCmd.setDensity,
      NiimbotCmd.setLabelType,
      NiimbotCmd.printStart,
      NiimbotCmd.pageStart,
      NiimbotCmd.setPageSize,
      NiimbotCmd.printEmptyRow,
      NiimbotCmd.printBitmapRowIndexed,
      NiimbotCmd.printBitmapRow,
      NiimbotCmd.printEmptyRow,
      NiimbotCmd.pageEnd,
      NiimbotCmd.printStatus,
      NiimbotCmd.printStatus,
      NiimbotCmd.printEnd,
    ]);
    final start = fake.sent.firstWhere(
      (p) => p.command == NiimbotCmd.printStart,
    );
    expect(start.data, [0, 1, 0, 0, 0, 0, 0]);
    final size = fake.sent.firstWhere(
      (p) => p.command == NiimbotCmd.setPageSize,
    );
    // The page is the full 576-dot head, the 16-dot image at its right edge.
    expect(size.data, [0, 4, 2, 64, 0, 1]); // rows, cols, copies
    final sparse = fake.sent.firstWhere(
      (p) => p.command == NiimbotCmd.printBitmapRowIndexed,
    );
    expect(sparse.data.sublist(6), [
      2,
      48,
    ]); // the one dot of row 1 at column 560
    // Rotated: the 16×4 image becomes 4×16 → 16 rows.
    fake.sent.clear();
    await printer.printLabel(testBitmap(), density: 3, rotate: true);
    final rotated = fake.sent.firstWhere(
      (p) => p.command == NiimbotCmd.setPageSize,
    );
    expect(rotated.data.sublist(0, 2), [0, 16]);
    expect(
      fake.sent.firstWhere((p) => p.command == NiimbotCmd.setDensity).data,
      [3],
    );
    expect(progress.last, 1);
    await printer.close();
  });

  test('a printer error aborts the page but still ends the print', () async {
    final fake = FakeB3S(errorOn: NiimbotCmd.pageEnd);
    final printer = NiimbotPrinter(fake, packetInterval: Duration.zero);
    await printer.connect();
    await expectLater(
      printer.printLabel(testBitmap(), density: 3),
      throwsA(
        isA<NiimbotException>()
            .having((e) => e.failure, 'failure', NiimbotFailure.printerError)
            .having((e) => e.code, 'code', NiimbotErrorCode.coverOpen),
      ),
    );
    expect(fake.sent.last.command, NiimbotCmd.printEnd);
    await printer.close();
  });

  test('silence is a timeout', () async {
    final fake = FakeB3S(errorOn: -1);
    final printer = NiimbotPrinter(_Mute(fake), packetInterval: Duration.zero);
    await expectLater(
      printer.connect(),
      throwsA(
        isA<NiimbotException>().having(
          (e) => e.failure,
          'failure',
          NiimbotFailure.timeout,
        ),
      ),
    );
    await printer.close();
  }, timeout: const Timeout(Duration(seconds: 10)));
}

/// Swallows everything.
class _Mute implements NiimbotTransport {
  _Mute(this.inner);

  final FakeB3S inner;

  @override
  Stream<List<int>> get received => inner.received;

  @override
  Future<void> write(Uint8List bytes) async {}

  @override
  Future<void> close() => inner.close();
}

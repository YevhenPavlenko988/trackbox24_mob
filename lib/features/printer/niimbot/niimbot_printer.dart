import 'dart:async';
import 'dart:typed_data';

import 'package:trackbox24_mob/features/printer/niimbot/label_bitmap.dart';
import 'package:trackbox24_mob/features/printer/niimbot/niimbot_packet.dart';

/// A byte pipe to the printer; the Bluetooth one lives in `ble_transport.dart`, tests script their own.
abstract class NiimbotTransport {
  /// Raw notifications from the printer, as they arrive (packets may be split or bundled).
  Stream<List<int>> get received;

  Future<void> write(Uint8List bytes);

  Future<void> close();
}

/// Why a print did not happen.
enum NiimbotFailure {
  /// No answer in time: the printer is off, asleep, out of range or taken by another app.
  timeout,

  /// The printer reported an error; see [NiimbotException.code].
  printerError,

  /// The printer refused a command it does not know.
  notSupported,

  /// The link dropped mid-way.
  disconnected,
}

class NiimbotException implements Exception {
  const NiimbotException(this.failure, {this.code, this.detail});

  final NiimbotFailure failure;

  /// A [NiimbotErrorCode] when [failure] is [NiimbotFailure.printerError].
  final int? code;
  final String? detail;

  @override
  String toString() => 'NiimbotException($failure, code: $code, $detail)';
}

/// What the printer told about itself at connection.
class NiimbotPrinterInfo {
  const NiimbotPrinterInfo({
    required this.modelId,
    required this.protocolVersion,
    this.batteryPercent,
  });

  final int modelId;
  final int protocolVersion;
  final int? batteryPercent;

  /// Model name for the B3S family the app targets; other ids are shown as numbers.
  String get modelName => switch (modelId) {
    256 || 260 || 262 => 'B3S',
    272 => 'B3S_P',
    275 => 'B3S_A',
    _ => 'NIIMBOT #$modelId',
  };

  /// Dots across the print head: 576 for the 75 mm B3S family, which is also the safe guess for anything else
  /// — the counts it drives are advisory, the firmware does not check them.
  int get printheadPixels => switch (modelId) {
    4096 || 4097 || 4098 => 384, // B1
    768 || 769 || 771 || 775 || 776 => 384, // B21
    512 || 513 || 514 || 2304 || 2305 => 96, // D11 / D110
    _ => 576,
  };
}

/// The printer side of a print: connect handshake, then for each label the «B1» sequence that the B3S family
/// (B3S, B3S_P) runs — `SetDensity → SetLabelType → PrintStart(7 bytes) → PageStart → SetPageSize(6 bytes) → rows →
/// PageEnd → poll PrintStatus → PrintEnd`. Row packets get no answer; everything else is waited for.
class NiimbotPrinter {
  NiimbotPrinter(
    this._transport, {
    this._packetInterval = const Duration(milliseconds: 10),
  }) {
    _subscription = _transport.received.listen(
      (chunk) => _reader.feed(chunk).forEach(_incoming.add),
      onDone: () => _incoming.addError(
        const NiimbotException(NiimbotFailure.disconnected),
      ),
    );
  }

  static const _responseTimeout = Duration(seconds: 3);
  static const _statusPollInterval = Duration(milliseconds: 300);
  static const _printTimeout = Duration(seconds: 40);

  /// Label stock with gaps between labels (the 70×40 rolls).
  static const labelTypeWithGaps = 1;

  final NiimbotTransport _transport;
  final Duration _packetInterval;
  final _reader = NiimbotPacketReader();
  final _incoming = StreamController<NiimbotPacket>.broadcast();
  late final StreamSubscription<List<int>> _subscription;
  NiimbotPrinterInfo? _info;

  NiimbotPrinterInfo? get info => _info;

  /// The `Connect` handshake plus the model id and the charge level.
  Future<NiimbotPrinterInfo> connect() async {
    final connect = await _send(
      NiimbotPacket(NiimbotCmd.connect, [1]),
      expect: [NiimbotRsp.connect],
    );
    var protocolVersion = 0;
    final result = connect.data.isEmpty
        ? NiimbotConnectResult.disconnect
        : connect.data[0];
    if (result == NiimbotConnectResult.connectedNew) {
      protocolVersion = 1;
    } else if (result == NiimbotConnectResult.connectedV3) {
      final status = await _send(
        NiimbotPacket(NiimbotCmd.printerStatusData, [1]),
        expect: [NiimbotRsp.printerStatusData],
      );
      if (status.data.length >= 13) {
        final n = status.data[11] * 100 + status.data[12];
        protocolVersion = n >= 302
            ? 5
            : n >= 300
            ? 4
            : n >= 204
            ? 3
            : 0;
      }
    }
    final model = await _send(
      NiimbotPacket(NiimbotCmd.printerInfo, [NiimbotInfoType.printerModelId]),
      expect: [NiimbotRsp.printerInfoModelId],
    );
    final modelId = model.data.length == 1
        ? model.data[0] << 8
        : readU16(model.data, 0);
    int? battery;
    try {
      final charge = await _send(
        NiimbotPacket(NiimbotCmd.printerInfo, [
          NiimbotInfoType.batteryChargeLevel,
        ]),
        expect: [NiimbotRsp.printerInfoChargeLevel],
      );
      if (charge.data.isNotEmpty) battery = charge.data[0];
    } on NiimbotException catch (e) {
      if (e.failure == NiimbotFailure.disconnected) rethrow;
    }
    return _info = NiimbotPrinterInfo(
      modelId: modelId,
      protocolVersion: protocolVersion,
      batteryPercent: battery,
    );
  }

  /// Prints one page. [onProgress] gets 0…1 while the rows are sent.
  Future<void> printLabel(
    LabelBitmap bitmap, {
    required int density,
    int labelType = labelTypeWithGaps,
    void Function(double)? onProgress,
  }) async {
    final printhead = _info?.printheadPixels ?? 576;
    final rows = encodeBitmapRows(bitmap, printheadPixels: printhead);
    await _send(
      NiimbotPacket(NiimbotCmd.setDensity, [density]),
      expect: [NiimbotRsp.setDensity],
    );
    await _send(
      NiimbotPacket(NiimbotCmd.setLabelType, [labelType]),
      expect: [NiimbotRsp.setLabelType],
    );
    await _send(
      NiimbotPacket(NiimbotCmd.printStart, [...u16(1), 0, 0, 0, 0, 0]),
      expect: [NiimbotRsp.printStart],
    );
    try {
      await _send(
        NiimbotPacket(NiimbotCmd.pageStart, [1]),
        expect: [NiimbotRsp.pageStart],
      );
      await _send(
        NiimbotPacket(NiimbotCmd.setPageSize, [
          ...u16(bitmap.height),
          ...u16(bitmap.width),
          ...u16(1),
        ]),
        expect: [NiimbotRsp.setPageSize],
      );
      for (var i = 0; i < rows.length; i++) {
        await _write(rows[i]);
        onProgress?.call((i + 1) / rows.length);
      }
      await _send(
        NiimbotPacket(NiimbotCmd.pageEnd, [1]),
        expect: [NiimbotRsp.pageEnd],
      );
      await _waitUntilPrinted();
    } finally {
      // Also the way to abort: the printer drops the page and feeds the label out.
      try {
        await _send(
          NiimbotPacket(NiimbotCmd.printEnd, [1]),
          expect: [NiimbotRsp.printEnd],
        );
      } on NiimbotException {
        // The primary failure is what the caller should see.
      }
    }
  }

  Future<void> _waitUntilPrinted() async {
    final deadline = DateTime.now().add(_printTimeout);
    while (true) {
      await Future<void>.delayed(_statusPollInterval);
      final status = await _send(
        NiimbotPacket(NiimbotCmd.printStatus, [1]),
        expect: [NiimbotRsp.printStatus],
        timeout: const Duration(seconds: 5),
      );
      if (status.data.length >= 4) {
        final page = readU16(status.data, 0);
        final printed = status.data[2];
        final fed = status.data[3];
        if (status.data.length == 10 && status.data[6] != 0) {
          throw NiimbotException(
            NiimbotFailure.printerError,
            code: status.data[6],
          );
        }
        if (page >= 1 && printed >= 100 && fed >= 100) return;
      }
      if (DateTime.now().isAfter(deadline)) {
        throw const NiimbotException(
          NiimbotFailure.timeout,
          detail: 'print status',
        );
      }
    }
  }

  /// Sends [packet] and waits for a packet whose command is one of [expect]; a `PrintError` or `NotSupported`
  /// answer in the meantime fails the wait. Unrelated packets (page notifications, heartbeats) are skipped.
  Future<NiimbotPacket> _send(
    NiimbotPacket packet, {
    required List<int> expect,
    Duration timeout = _responseTimeout,
  }) async {
    final answer = _incoming.stream
        .firstWhere((p) {
          if (p.command == NiimbotRsp.printError) {
            throw NiimbotException(
              NiimbotFailure.printerError,
              code: p.data.isEmpty ? null : p.data[0],
            );
          }
          if (p.command == NiimbotRsp.notSupported) {
            throw NiimbotException(
              NiimbotFailure.notSupported,
              detail: packet.toString(),
            );
          }
          return expect.contains(p.command);
        })
        .timeout(
          timeout,
          onTimeout: () => throw NiimbotException(
            NiimbotFailure.timeout,
            detail: packet.toString(),
          ),
        );
    await _write(packet);
    return await answer;
  }

  Future<void> _write(NiimbotPacket packet) async {
    await _transport.write(packet.toBytes());
    if (_packetInterval > Duration.zero) {
      await Future<void>.delayed(_packetInterval);
    }
  }

  Future<void> close() async {
    await _subscription.cancel();
    await _incoming.close();
    await _transport.close();
  }
}

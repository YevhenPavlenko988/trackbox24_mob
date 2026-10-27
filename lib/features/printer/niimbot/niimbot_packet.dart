import 'dart:typed_data';

/// Request command ids of the NIIMBOT printer protocol (the subset this app sends).
///
/// Reverse-engineered by the niimbluelib project; the numbers are what the official app sends.
abstract final class NiimbotCmd {
  /// Must be sent with a leading `0x03` before the packet head.
  static const connect = 0xc1;
  static const printerStatusData = 0xa5;
  static const printerInfo = 0x40;
  static const heartbeat = 0xdc;
  static const setDensity = 0x21;
  static const setLabelType = 0x23;
  static const printStart = 0x01;
  static const pageStart = 0x03;
  static const setPageSize = 0x13;
  static const printBitmapRow = 0x85;
  static const printBitmapRowIndexed = 0x83;
  static const printEmptyRow = 0x84;
  static const pageEnd = 0xe3;
  static const printStatus = 0xa3;
  static const printEnd = 0xf3;
}

/// Response command ids.
abstract final class NiimbotRsp {
  static const notSupported = 0x00;
  static const connect = 0xc2;
  static const printerStatusData = 0xb5;
  static const printerInfoModelId = 0x48;
  static const printerInfoChargeLevel = 0x4a;
  static const setDensity = 0x31;
  static const setLabelType = 0x33;
  static const printStart = 0x02;
  static const pageStart = 0x04;
  static const setPageSize = 0x14;
  static const pageEnd = 0xe4;
  static const printStatus = 0xb3;
  static const printEnd = 0xf4;

  /// One byte of data: a [NiimbotErrorCode].
  static const printError = 0xdb;
}

/// `PrinterInfo` request payloads.
abstract final class NiimbotInfoType {
  static const printerModelId = 8;
  static const batteryChargeLevel = 10;
}

/// What the printer answers to `Connect`.
abstract final class NiimbotConnectResult {
  static const disconnect = 0;
  static const connected = 1;
  static const connectedNew = 2;
  static const connectedV3 = 3;
}

/// Error codes carried by a [NiimbotRsp.printError] packet or by the print status.
abstract final class NiimbotErrorCode {
  static const coverOpen = 0x01;
  static const lackPaper = 0x02;
  static const lowBattery = 0x03;
  static const batteryException = 0x04;
  static const userCancel = 0x05;
  static const dataError = 0x06;
  static const overheat = 0x07;
  static const paperOutException = 0x08;
  static const printerBusy = 0x09;
  static const noPrinterHead = 0x0a;
  static const temperatureLow = 0x0b;
  static const printerHeadLoose = 0x0c;
  static const wrongPaper = 0x10;
  static const b3sAbnormalPaperOutput = 0x1b;
  static const receiveDataTimeout = 0x34;
}

/// One frame of the protocol: `55 55 CMD LEN DATA… CHECKSUM AA AA`, the checksum being the XOR of command,
/// length and data.
class NiimbotPacket {
  NiimbotPacket(this.command, List<int> data) : data = Uint8List.fromList(data);

  static const head = [0x55, 0x55];
  static const tail = [0xaa, 0xaa];

  final int command;
  final Uint8List data;

  int get checksum {
    var checksum = command ^ data.length;
    for (final b in data) {
      checksum ^= b;
    }
    return checksum & 0xff;
  }

  Uint8List toBytes() {
    final out = BytesBuilder(copy: false);
    // The connect packet alone is prefixed, as the official app does it.
    if (command == NiimbotCmd.connect) out.addByte(0x03);
    out
      ..add(head)
      ..addByte(command)
      ..addByte(data.length)
      ..add(data)
      ..addByte(checksum)
      ..add(tail);
    return out.toBytes();
  }

  @override
  String toString() =>
      'NiimbotPacket(0x${command.toRadixString(16)}, ${hex(data)})';

  static String hex(List<int> bytes) =>
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
}

/// Reassembles packets from the byte stream of the notify characteristic.
///
/// A notification may hold several packets, a packet may be split across notifications, and on iOS the
/// printer's answers often arrive with a stray byte before the `55 55` head — all three are handled here.
class NiimbotPacketReader {
  final _buffer = BytesBuilder(copy: false);

  /// Appends [chunk] and returns every packet that is complete now.
  List<NiimbotPacket> feed(List<int> chunk) {
    _buffer.add(chunk);
    var bytes = _buffer.takeBytes();
    final packets = <NiimbotPacket>[];
    while (true) {
      final start = _indexOfHead(bytes);
      if (start < 0) {
        // No head at all: keep a trailing 0x55 in case the head is split across chunks.
        bytes = bytes.isNotEmpty && bytes.last == 0x55
            ? Uint8List.fromList([0x55])
            : Uint8List(0);
        break;
      }
      if (start > 0) bytes = bytes.sublist(start);
      if (bytes.length < 4) break;
      final dataLength = bytes[3];
      final total = 2 + 1 + 1 + dataLength + 1 + 2;
      if (bytes.length < total) break;
      final command = bytes[2];
      final data = bytes.sublist(4, 4 + dataLength);
      final packet = NiimbotPacket(command, data);
      final checksumOk = bytes[4 + dataLength] == packet.checksum;
      final tailOk = bytes[total - 2] == 0xaa && bytes[total - 1] == 0xaa;
      if (checksumOk && tailOk) {
        packets.add(packet);
        bytes = bytes.sublist(total);
      } else {
        // Not a frame after all: skip this head and look for the next one.
        bytes = bytes.sublist(2);
      }
    }
    _buffer.add(bytes);
    return packets;
  }

  static int _indexOfHead(Uint8List bytes) {
    for (var i = 0; i + 1 < bytes.length; i++) {
      if (bytes[i] == 0x55 && bytes[i + 1] == 0x55) return i;
    }
    return -1;
  }
}

/// Big-endian helpers for packet payloads.
List<int> u16(int value) => [(value >> 8) & 0xff, value & 0xff];

int readU16(Uint8List data, int offset) =>
    (data[offset] << 8) | data[offset + 1];

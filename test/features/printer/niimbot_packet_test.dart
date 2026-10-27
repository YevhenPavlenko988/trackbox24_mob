import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/features/printer/niimbot/niimbot_packet.dart';

List<int> hex(String s) => [
  for (final h in s.split(RegExp(r'\s+')).where((h) => h.isNotEmpty))
    int.parse(h, radix: 16),
];

void main() {
  group('NiimbotPacket', () {
    test('frames a packet with the XOR checksum', () {
      // An indexed bitmap row captured from the official app (documented by niimbluelib).
      final packet = NiimbotPacket(
        NiimbotCmd.printBitmapRowIndexed,
        hex('00 7e 00 04 00 01 00 27 00 28 00 29 00 2a'),
      );
      expect(
        packet.toBytes(),
        hex('55 55 83 0e 00 7e 00 04 00 01 00 27 00 28 00 29 00 2a fa aa aa'),
      );
    });

    test('prefixes the connect packet with 0x03', () {
      expect(
        NiimbotPacket(NiimbotCmd.connect, [1]).toBytes(),
        hex('03 55 55 c1 01 01 c1 aa aa'),
      );
    });
  });

  group('NiimbotPacketReader', () {
    test('parses a whole packet', () {
      final packets = NiimbotPacketReader().feed(
        hex('55 55 c2 01 03 c0 aa aa'),
      );
      expect(packets, hasLength(1));
      expect(packets.single.command, NiimbotRsp.connect);
      expect(packets.single.data, [3]);
    });

    test('drops the stray byte iOS puts before the head', () {
      final packets = NiimbotPacketReader().feed(
        hex('03 55 55 c2 01 03 c0 aa aa'),
      );
      expect(packets.map((p) => p.command), [NiimbotRsp.connect]);
    });

    test(
      'reassembles a packet split across notifications and splits a bundle',
      () {
        final reader = NiimbotPacketReader();
        expect(reader.feed(hex('55 55 b3 04 00')), isEmpty);
        final packets = reader.feed(
          hex('01 64 64 b6 aa aa 55 55 e4 01 01 e4 aa aa'),
        );
        expect(packets.map((p) => p.command), [
          NiimbotRsp.printStatus,
          NiimbotRsp.pageEnd,
        ]);
        expect(packets.first.data, [0, 1, 100, 100]);
      },
    );

    test('skips a corrupt frame and finds the next one', () {
      final packets = NiimbotPacketReader().feed(
        hex('55 55 c2 01 03 ff aa aa 55 55 31 01 01 31 aa aa'),
      );
      expect(packets.map((p) => p.command), [NiimbotRsp.setDensity]);
    });
  });
}

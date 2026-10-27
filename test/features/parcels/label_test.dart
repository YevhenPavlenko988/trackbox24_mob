import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/label/label_data.dart';
import 'package:trackbox24_mob/features/parcels/label/label_painter.dart';

void main() {
  group('label text', () {
    test('groups the waybill the way Nova Poshta prints it', () {
      expect(groupWaybill('20451558819168'), '20 4515 5881 9168');
      expect(groupWaybill('20 4515 5881 9168'), '20 4515 5881 9168');
      // Not a waybill: left alone rather than mangled.
      expect(groupWaybill('PT9117009599'), 'PT9117009599');
    });

    test('shortens the recipient and the branch to fit 70 mm', () {
      expect(shortName('Коваль', 'Іван'), 'Коваль І.');
      expect(shortName('Коваль', null), 'Коваль');
      expect(shortName(null, 'Іван'), 'Іван');
      expect(shortName(' ', ''), isNull);
      expect(
        shortWarehouse('Відділення №1: вул. Пирогівський шлях, 135'),
        'Відд. №1',
      );
      expect(
        shortWarehouse('Поштомат №123: вул. Хрещатик, 1'),
        'Поштомат №123',
      );
      expect(shortWarehouse(null), isNull);
      // A pickup point has no number: the address tells it apart, the building glued to its street.
      expect(
        shortWarehouse('Пункт приймання-видачі (до 30 кг): вул. Центральна, 1'),
        'Пункт: вул. Центральна,\u00A01',
      );
    });

    test('names the recipient and the destination, or the client', () {
      const branch = Parcel(
        id: 1,
        clientName: 'Петренко О.',
        npShipment: NpShipment(
          recipientLastName: 'Коваль',
          recipientFirstName: 'Іван',
          deliveryType: NpDeliveryType.WAREHOUSE,
          cityName: 'Київ',
          warehouseName: 'Відділення №2: просп. Перемоги, 10',
        ),
      );
      expect(destinationLine(branch), 'Коваль І., Київ, Відд. №2');

      const courier = Parcel(
        id: 2,
        npShipment: NpShipment(
          recipientLastName: 'Коваль',
          deliveryType: NpDeliveryType.ADDRESS,
          cityName: 'Київ',
          streetName: 'вул. Хрещатик',
          building: '12А',
        ),
      );
      expect(destinationLine(courier), 'Коваль, Київ, вул. Хрещатик, 12А');

      // Nothing about the shipment yet: the client the driver took the parcel from.
      const plain = Parcel(
        id: 3,
        clientName: 'Петренко О.',
        clientCity: 'Львів',
      );
      expect(destinationLine(plain), 'Петренко О., Львів');
      expect(destinationLine(const Parcel(id: 4)), isNull);
    });
  });

  group('labelsFor', () {
    test('one label per seat, the waybill on each', () {
      const parcel = Parcel(
        id: 7,
        barcode: 'PT9117009599',
        weightKg: 2.5,
        seatsAmount: 2,
        seats: [
          Seat(seatNumber: 1, barcode: 'PT9117009599-1'),
          Seat(seatNumber: 2, barcode: 'PT9117009599-2'),
        ],
        npShipment: NpShipment(waybillNumber: '20451558819168'),
      );
      final labels = labelsFor(parcel);
      expect(labels.map((l) => l.code), ['PT9117009599-1', 'PT9117009599-2']);
      expect(labels.map((l) => l.seat), [1, 2]);
      expect(labels.every((l) => l.total == 2), isTrue);
      expect(labels.every((l) => l.waybill == '20451558819168'), isTrue);
      expect(labels.first.weightKg, 2.5);
      expect(labels.first.fileName, 'PT9117009599-1.png');
    });

    test('a one-seat parcel is labelled with its own code, no «-1»', () {
      const parcel = Parcel(
        id: 10,
        barcode: 'PT9117009599',
        seatsAmount: 1,
        seats: [Seat(seatNumber: 1, barcode: 'PT9117009599-1')],
      );
      final labels = labelsFor(parcel);
      expect(labels, hasLength(1));
      expect(labels.single.code, 'PT9117009599');
      expect(labels.single.seat, isNull);
    });

    test('a parcel without seats gets one label for its own barcode', () {
      const parcel = Parcel(id: 8, barcode: 'PT9117009599');
      final labels = labelsFor(parcel);
      expect(labels, hasLength(1));
      expect(labels.single.code, 'PT9117009599');
      expect(labels.single.seat, isNull);
      expect(labels.single.waybill, isNull);
      expect(labelsFor(const Parcel(id: 9)), isEmpty);
    });
  });

  group('rendering', () {
    test('renders a 70×40 label at the printer resolution as a PNG', () async {
      final bytes = await renderLabelPng(
        const ParcelLabel(
          code: 'PT9117009599-1',
          seat: 1,
          total: 2,
          waybill: '20451558819168',
          recipient: 'Коваль І.',
          city: 'Київ',
          place: 'Відд. №2',
          phone: '380671234567',
          weightKg: 1,
        ),
        scale: 1,
      );
      // PNG signature, then the IHDR chunk with the width and the height.
      expect(bytes.sublist(0, 8), [137, 80, 78, 71, 13, 10, 26, 10]);
      int be32(int at) =>
          (bytes[at] << 24) |
          (bytes[at + 1] << 16) |
          (bytes[at + 2] << 8) |
          bytes[at + 3];
      expect(be32(16), labelWidthDots.toInt());
      expect(be32(20), labelHeightDots.toInt());
    });
  });
}

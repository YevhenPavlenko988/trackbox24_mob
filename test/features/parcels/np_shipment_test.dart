import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/state/np_shipment_form.dart';

void main() {
  group('npShipmentBody', () {
    test('sends the whole form, half-filled or not', () {
      final body = npShipmentBody(
        const NpShipmentFormValues(
          lastName: ' Коваль ',
          firstName: 'Іван',
          cityRef: 'city-1',
          cityName: 'Київ',
        ),
      );
      expect(body['recipientLastName'], 'Коваль');
      expect(body['recipientFirstName'], 'Іван');
      // The backend replaces every field, so what is not filled in has to go out as null.
      expect(body.containsKey('recipientPhone'), isTrue);
      expect(body['recipientPhone'], isNull);
      expect(body['deliveryType'], 'WAREHOUSE');
      expect(body['cargoType'], 'PARCEL');
      expect(body['payerType'], 'RECIPIENT');
      expect(body['paymentMethod'], 'CASH');
    });

    test('a branch is dropped when the parcel goes to an address', () {
      final body = npShipmentBody(
        const NpShipmentFormValues(
          deliveryType: NpDeliveryType.ADDRESS,
          branchRef: 'branch-1',
          branchName: 'Відділення №1',
          streetRef: 'street-1',
          streetName: 'вул. Хрещатик',
          building: '12А',
          flat: '5',
          codAmount: '1200',
        ),
      );
      expect(body['warehouseRef'], isNull);
      expect(body['warehouseName'], isNull);
      expect(body['streetRef'], 'street-1');
      expect(body['building'], '12А');
      expect(body['flat'], '5');
      expect(body['codAmount'], 1200);
    });

    test('an address is dropped when the parcel goes to a locker', () {
      final body = npShipmentBody(
        const NpShipmentFormValues(
          deliveryType: NpDeliveryType.POSTOMAT,
          branchRef: 'locker-1',
          streetRef: 'street-1',
          building: '12А',
        ),
      );
      expect(body['warehouseRef'], 'locker-1');
      expect(body['streetRef'], isNull);
      expect(body['building'], isNull);
    });

    test('round-trips through the form values', () {
      const original = NpShipmentFormValues(
        lastName: 'Коваль',
        firstName: 'Іван',
        phone: '380671234567',
        deliveryType: NpDeliveryType.POSTOMAT,
        cityRef: 'city-1',
        cityName: 'Київ',
        branchRef: 'locker-1',
        branchName: 'Поштомат №3',
        payerType: NpPayerType.SENDER,
        paymentMethod: NpPaymentMethod.NON_CASH,
        codAmount: '500',
      );
      final back = NpShipmentFormValues.fromShipment(
        NpShipment.fromJson(npShipmentBody(original)),
      );
      expect(back.lastName, original.lastName);
      expect(back.phone, original.phone);
      expect(back.deliveryType, NpDeliveryType.POSTOMAT);
      expect(back.branchName, 'Поштомат №3');
      expect(back.payerType, NpPayerType.SENDER);
      expect(back.paymentMethod, NpPaymentMethod.NON_CASH);
      expect(back.codAmount, '500');
    });
  });

  group('splitFullName', () {
    test('splits a Ukrainian full name the way it is written', () {
      final full = splitFullName(' Коваль  Іван Петрович ');
      expect(full.lastName, 'Коваль');
      expect(full.firstName, 'Іван');
      expect(full.middleName, 'Петрович');
    });

    test('takes what it is given', () {
      expect(splitFullName('Коваль').lastName, 'Коваль');
      expect(splitFullName('Коваль').firstName, isNull);
      expect(splitFullName('Коваль Іван').middleName, isNull);
      // Anything past the third word belongs to the patronymic rather than being dropped.
      expect(
        splitFullName('Коваль Іван Петрович Молодший').middleName,
        'Петрович Молодший',
      );
      expect(splitFullName('   ').lastName, isNull);
    });
  });

  group('NpShipment', () {
    test('reads the recipient and the destination as one line', () {
      const branch = NpShipment(
        recipientLastName: 'Коваль',
        recipientFirstName: 'Іван',
        deliveryType: NpDeliveryType.WAREHOUSE,
        cityName: 'Київ',
        warehouseName: 'Відділення №1',
      );
      expect(branch.recipientName, 'Коваль Іван');
      expect(branch.destination, 'Київ · Відділення №1');

      const courier = NpShipment(
        deliveryType: NpDeliveryType.ADDRESS,
        cityName: 'Київ',
        streetName: 'вул. Хрещатик',
        building: '12А',
        flat: '5',
      );
      expect(courier.destination, 'Київ · вул. Хрещатик, 12А, кв. 5');
      expect(courier.recipientName, isNull);
    });

    test(
      'a waybill can be deleted only while Nova Poshta has not taken it',
      () {
        const created = NpShipment(
          waybillNumber: '2045',
          npState: NpState.CREATED,
        );
        const inTransit = NpShipment(
          waybillNumber: '2045',
          npState: NpState.IN_TRANSIT,
        );
        const none = NpShipment();
        expect(created.waybillDeletable, isTrue);
        expect(inTransit.waybillDeletable, isFalse);
        expect(none.hasWaybill, isFalse);
        expect(none.waybillDeletable, isFalse);
      },
    );
  });

  group('parcel', () {
    test('the shipment can be filled in only while the parcel is with us', () {
      for (final status in [
        ParcelStatus.RECEIVED_BY_REPRESENTATIVE,
        ParcelStatus.AT_WAREHOUSE,
        ParcelStatus.IN_CAR,
      ]) {
        expect(Parcel(id: 1, status: status).withUs, isTrue, reason: '$status');
      }
      for (final status in [
        ParcelStatus.IN_NOVA_POSHTA,
        ParcelStatus.SENT_VIA_NOVA_POSHTA,
        ParcelStatus.DELIVERED_TO_CLIENT,
        ParcelStatus.CANCELLED,
      ]) {
        expect(
          Parcel(id: 1, status: status).withUs,
          isFalse,
          reason: '$status',
        );
      }
    });

    test('parses the shipment that comes with the parcel', () {
      final parcel = Parcel.fromJson(const {
        'id': 7,
        'status': 'SENT_VIA_NOVA_POSHTA',
        'npShipment': {
          'recipientLastName': 'Коваль',
          'deliveryType': 'WAREHOUSE',
          'payerType': 'RECIPIENT',
          'paymentMethod': 'CASH',
          'waybillNumber': '20450000000099',
          'waybillCost': 95,
          'estimatedDeliveryDate': '2026-10-14',
          'npState': 'IN_TRANSIT',
        },
      });
      expect(parcel.status, ParcelStatus.SENT_VIA_NOVA_POSHTA);
      expect(parcel.npShipment?.waybillNumber, '20450000000099');
      expect(parcel.npShipment?.waybillCost, 95);
      expect(parcel.npShipment?.estimatedDeliveryDate, DateTime(2026, 10, 14));
      expect(parcel.npShipment?.npState, NpState.IN_TRANSIT);
      expect(parcel.withUs, isFalse);
    });
  });
}

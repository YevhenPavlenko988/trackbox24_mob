import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/features/clients/data/client_model.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/state/parcel_form.dart';

void main() {
  group('createBody', () {
    test('omits empty fields and parses numbers', () {
      final body = createBody(
        const ParcelFormValues(
          description: ' Взуття ',
          seatsAmount: '2',
          weightKg: '1,5',
          senderPhone: '',
        ),
        npTtn: '20451549454007',
      );
      expect(body, {
        'npTtn': '20451549454007',
        'alreadyReceived': false,
        'description': 'Взуття',
        'weightKg': 1.5,
        'seatsAmount': 2,
      });
    });

    test('manual parcel has no TTN keys', () {
      final body = createBody(
        const ParcelFormValues(seatsAmount: '1', clientId: 5),
      );
      expect(body.containsKey('npTtn'), isFalse);
      expect(body.containsKey('alreadyReceived'), isFalse);
      expect(body['clientId'], 5);
    });
  });

  group('updateBody (partial PUT)', () {
    const before = ParcelFormValues(
      description: 'A',
      seatsAmount: '1',
      weightKg: '2',
      clientId: 1,
    );

    test('sends only changed, non-empty fields', () {
      final body = updateBody(
        before,
        const ParcelFormValues(
          description: 'B',
          seatsAmount: '1',
          weightKg: '2',
          clientId: 1,
        ),
      );
      expect(body, {'description': 'B'});
    });

    test('clearing a field is not sent (backend cannot clear)', () {
      final body = updateBody(
        before,
        const ParcelFormValues(
          description: '',
          seatsAmount: '1',
          weightKg: '2',
          clientId: 1,
        ),
      );
      expect(body, isEmpty);
    });

    test('number compare ignores formatting', () {
      final body = updateBody(
        before,
        const ParcelFormValues(
          description: 'A',
          seatsAmount: '1',
          weightKg: '2.0',
          clientId: 1,
        ),
      );
      expect(body, isEmpty);
    });

    test('client and needsEnrichment changes', () {
      final body = updateBody(
        before,
        const ParcelFormValues(
          description: 'A',
          seatsAmount: '3',
          weightKg: '2',
          clientId: 9,
          needsEnrichment: true,
        ),
      );
      expect(body, {'seatsAmount': 3, 'clientId': 9, 'needsEnrichment': true});
    });
  });

  test('fromParcel renders numbers without trailing .0', () {
    final v = ParcelFormValues.fromParcel(
      const Parcel(id: 1, weightKg: 2, declaredValue: 12.5, seatsAmount: 3),
    );
    expect(v.weightKg, '2');
    expect(v.declaredValue, '12.5');
    expect(v.seatsAmount, '3');
  });

  test('canEditSeatsAmount follows seat statuses', () {
    expect(
      canEditSeatsAmount(
        const Parcel(id: 1, status: ParcelStatus.RECEIVED_BY_REPRESENTATIVE),
      ),
      isTrue,
    );
    expect(
      canEditSeatsAmount(
        const Parcel(
          id: 1,
          seats: [
            Seat(seatNumber: 1, status: ParcelStatus.IN_CAR),
            Seat(seatNumber: 2, status: ParcelStatus.AT_WAREHOUSE),
          ],
        ),
      ),
      isFalse,
    );
  });

  test('client display name', () {
    expect(
      const Client(
        id: 1,
        type: ClientType.PRIVATE_PERSON,
        firstName: 'Петро',
        lastName: 'Коваль',
      ).displayName,
      'Коваль Петро',
    );
    expect(
      const Client(
        id: 2,
        type: ClientType.ORGANIZATION,
        organizationName: 'ТОВ Постач',
      ).displayName,
      'ТОВ Постач',
    );
    expect(const Client(id: 3).displayName, '—');
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/features/auth/data/user_model.dart';
import 'package:trackbox24_mob/features/moves/move_seats_section.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';

const _rep = User(id: 1, email: 'rep@test.ua', roles: [Role.REPRESENTATIVE]);
const _driver = User(id: 2, email: 'drv@test.ua', roles: [Role.DRIVER]);
const _manager = User(id: 3, email: 'mgr@test.ua', roles: [Role.MANAGER]);

void main() {
  test(
    'an item already at a warehouse goes onto another one only by a manager',
    () {
      expect(canMoveToWarehouse(ParcelStatus.AT_WAREHOUSE, _driver), isFalse);
      expect(canMoveToWarehouse(ParcelStatus.AT_WAREHOUSE, _rep), isFalse);
      expect(canMoveToWarehouse(ParcelStatus.AT_WAREHOUSE, _manager), isTrue);
    },
  );

  test(
    'from the car or the representative onto a warehouse, as a scan there',
    () {
      expect(canMoveToWarehouse(ParcelStatus.IN_CAR, _driver), isTrue);
      expect(
        canMoveToWarehouse(ParcelStatus.RECEIVED_BY_REPRESENTATIVE, _rep),
        isTrue,
      );
      expect(
        canMoveToWarehouse(ParcelStatus.RECEIVED_BY_REPRESENTATIVE, _driver),
        isFalse,
      );
      expect(
        canMoveToWarehouse(ParcelStatus.DELIVERED_TO_CLIENT, _manager),
        isFalse,
      );
    },
  );

  test(
    'handed over by a driver or a representative from the car or the warehouse',
    () {
      expect(canHandOver(ParcelStatus.AT_WAREHOUSE, _driver), isTrue);
      expect(canHandOver(ParcelStatus.IN_CAR, _driver), isTrue);
      expect(
        canHandOver(ParcelStatus.RECEIVED_BY_REPRESENTATIVE, _driver),
        isFalse,
      );
      expect(canHandOver(ParcelStatus.AT_WAREHOUSE, _rep), isTrue);
    },
  );

  test('from the warehouse into a car by hand, by anyone who loads', () {
    expect(canLoadByHand(ParcelStatus.AT_WAREHOUSE, _driver), isTrue);
    expect(
      canLoadByHand(ParcelStatus.RECEIVED_BY_REPRESENTATIVE, _rep),
      isTrue,
    );
    expect(canLoadByHand(ParcelStatus.IN_CAR, _driver), isFalse);
    expect(canLoadByHand(ParcelStatus.DELIVERED_TO_CLIENT, _manager), isFalse);
  });
}

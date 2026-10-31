import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/features/moves/move_scan_screen.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/data/seat_check.dart';
import 'package:trackbox24_mob/features/scan/state/scan_service.dart';

void main() {
  test('reads the backend check with the missing items', () {
    final check = SeatCheck.fromJson({
      'stage': 'DELIVER',
      'total': 4,
      'done': 3,
      'missing': [
        {
          'seatNumber': 3,
          'barcode': 'M104521-3',
          'status': 'IN_CAR',
          'description': 'Крісло',
        },
      ],
    });
    expect(check.stage, SeatCheckStage.DELIVER);
    expect(check.done, 3);
    expect(check.complete, isFalse);
    expect(check.missing.single.description, 'Крісло');
  });

  test('which items count as done for each stage', () {
    const inCar = Seat(seatNumber: 1, status: ParcelStatus.IN_CAR);
    const atA = Seat(
      seatNumber: 2,
      status: ParcelStatus.AT_WAREHOUSE,
      warehouseId: 1,
    );
    const handed = Seat(
      seatNumber: 3,
      status: ParcelStatus.DELIVERED_TO_CLIENT,
    );
    expect(seatDone(inCar, SeatCheckStage.LOAD), isTrue);
    expect(seatDone(atA, SeatCheckStage.LOAD), isFalse);
    expect(seatDone(atA, SeatCheckStage.WAREHOUSE, warehouseId: 1), isTrue);
    expect(seatDone(atA, SeatCheckStage.WAREHOUSE, warehouseId: 2), isFalse);
    expect(seatDone(atA, SeatCheckStage.WAREHOUSE), isTrue);
    expect(seatDone(handed, SeatCheckStage.DELIVER), isTrue);
    expect(scanModeOf(SeatCheckStage.WAREHOUSE), ScanMode.toWarehouse);
  });
}

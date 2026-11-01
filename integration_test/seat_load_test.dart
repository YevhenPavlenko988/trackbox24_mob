// From the warehouse into the next car by hand: the move is planned on the driver's trip, its items at a warehouse.
// Seed: driver E2E_DRIVER / driver123, trip E2E_TRIP (number), move E2E_MOVE at a warehouse, planned on that trip.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:trackbox24_mob/main.dart' as app;

const _driver = String.fromEnvironment(
  'E2E_DRIVER',
  defaultValue: 'drv-sim@test.ua',
);
const _trip = String.fromEnvironment('E2E_TRIP');
const _move = String.fromEnvironment('E2E_MOVE');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> settle(WidgetTester tester, [int seconds = 3]) async {
    for (var i = 0; i < seconds * 4; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
  }

  testWidgets(
    'chosen items at a warehouse go into the car of the planned trip',
    (tester) async {
      app.main();
      await settle(tester, 4);
      if (find.text('Увійти').evaluate().isEmpty) {
        await tester.tap(find.widgetWithText(NavigationDestination, 'Ще'));
        await settle(tester, 1);
        await tester.tap(find.text('Вийти'));
        await settle(tester, 2);
      }
      await tester.enterText(find.byType(TextFormField).at(0), _driver);
      await tester.enterText(find.byType(TextFormField).at(1), 'driver123');
      await tester.tap(find.text('Увійти'));
      await settle(tester, 4);
      await tester.tap(find.text('Заплановані'));
      await settle(tester, 2);
      await tester.tap(find.textContaining('№$_trip').first);
      await settle(tester);
      // the plan of the trip lists the move; its card has the items
      await tester.scrollUntilVisible(
        find.textContaining(_move).first,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.textContaining(_move).first);
      await settle(tester);

      final boxes = find.byType(Checkbox);
      await tester.scrollUntilVisible(
        boxes.first,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(boxes.first);
      await settle(tester, 1);
      // an item already at a warehouse: into the car of the planned trip, not «на склад» again
      expect(find.text('На склад'), findsNothing);
      expect(find.text('У рейс №$_trip'), findsOneWidget);
      await tester.tap(find.text('У рейс №$_trip'));
      await settle(tester, 2);
      expect(
        find.text('У машину рейсу №$_trip без сканування'),
        findsOneWidget,
      );
      await tester.tap(find.text('Перемістити'));
      await settle(tester);
      expect(find.textContaining('Переміщено місць'), findsOneWidget);
      expect(find.text('У машині'), findsWidgets);
    },
  );
}

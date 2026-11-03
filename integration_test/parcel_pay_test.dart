// A driver hands over a parcel priced in euros and takes the money in hryvnias by a Ukrainian card («Курси валют»),
// against a local backend, with screenshots. Needs the seed from README («Сценарії на симуляторі»): driver
// E2E_DRIVER / driver123 whose car carries the parcel E2E_PARCEL at 30 €, the company with the currency module.
//
//   flutter drive --driver test_driver/integration_test.dart --target integration_test/parcel_pay_test.dart \
//     -d <simulator> --dart-define=FLAVOR=dev --dart-define=API_BASE_URL=http://localhost:8080 \
//     --dart-define=E2E_DRIVER=drv-sim@test.ua --dart-define=E2E_PARCEL=PT1234567890
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:trackbox24_mob/main.dart' as app;

const _driver = String.fromEnvironment(
  'E2E_DRIVER',
  defaultValue: 'drv-sim@test.ua',
);
const _parcel = String.fromEnvironment('E2E_PARCEL');

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> settle(WidgetTester tester, [int seconds = 3]) async {
    for (var i = 0; i < seconds * 4; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
  }

  Future<void> shot(WidgetTester tester, String name) async {
    await binding.convertFlutterSurfaceToImage();
    await tester.pump();
    await binding.takeScreenshot(name);
  }

  testWidgets('the price in other currencies and a payment in hryvnias', (
    tester,
  ) async {
    app.main();
    await settle(tester, 4);
    // someone else may still be signed in from another scenario
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

    await tester.tap(find.widgetWithText(NavigationDestination, 'Сканувати'));
    await settle(tester, 2);
    await tester.tap(find.text('Ввести код'));
    await settle(tester);
    await tester.enterText(find.byType(TextField).last, _parcel);
    await tester.tap(find.text('Добре'));
    await settle(tester);

    // the price in the client's currencies right under it
    expect(find.byKey(const ValueKey('price-in-currencies')), findsOneWidget);
    expect(find.textContaining('≈ '), findsOneWidget);
    await shot(tester, 'pp1-sheet');

    // a Ukrainian card: hryvnias by default, the sum at the rate now
    await tester.tap(find.text('Укр. картка'));
    await settle(tester, 1);
    expect(find.byKey(const ValueKey('paid-currency')), findsOneWidget);
    expect(
      tester
          .widget<ChoiceChip>(find.byKey(const ValueKey('paid-UAH')))
          .selected,
      isTrue,
    );
    expect(find.textContaining('курс фіксується'), findsOneWidget);
    await shot(tester, 'pp2-ua-card');

    // a foreign card: no hryvnias, back to the price's euros
    await tester.tap(find.text('Закорд. картка'));
    await settle(tester, 1);
    expect(find.byKey(const ValueKey('paid-UAH')), findsNothing);
    expect(find.textContaining('курс фіксується'), findsNothing);

    await tester.tap(find.text('Укр. картка'));
    await settle(tester, 2);
    // «Реферальна програма»: the recipient has points from an earlier parcel; all of them go
    expect(find.byKey(const ValueKey('points-redeem')), findsOneWidget);
    final before = tester
        .widget<Text>(
          find.descendant(
            of: find.byKey(const ValueKey('paid-UAH')),
            matching: find.byType(Text),
          ),
        )
        .data;
    await tester.tap(find.textContaining('Усі '));
    await settle(tester, 1);
    // the hryvnia chip now shows less: the points came off
    final after = tester
        .widget<Text>(
          find.descendant(
            of: find.byKey(const ValueKey('paid-UAH')),
            matching: find.byType(Text),
          ),
        )
        .data;
    expect(after, isNot(before));
    await shot(tester, 'pp2b-points');
    await tester.tap(find.text('Видати клієнту'));
    await settle(tester, 4);
    await shot(tester, 'pp3-delivered');
  });
}

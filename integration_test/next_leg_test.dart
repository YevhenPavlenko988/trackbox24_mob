// A driver's own trip goes on with a next leg (it becomes №N.1, the new one №N.2), and the trip picker makes a new
// trip right there, «звідки → куди» filled in. Seed: driver E2E_DRIVER / driver123 with a planned trip E2E_TRIP (number)
// in a company with the moves module.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:trackbox24_mob/features/trips/data/trip_model.dart';
import 'package:trackbox24_mob/main.dart' as app;

const _driver = String.fromEnvironment(
  'E2E_DRIVER',
  defaultValue: 'drv-sim@test.ua',
);
const _trip = String.fromEnvironment('E2E_TRIP');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> settle(WidgetTester tester, [int seconds = 3]) async {
    for (var i = 0; i < seconds * 4; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
  }

  testWidgets('a trip goes on with a next leg; the picker makes a new trip', (
    tester,
  ) async {
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

    // a trip on its own: «Наступне плече» makes it a route
    await tester.scrollUntilVisible(
      find.text('Наступне плече'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Наступне плече'));
    await settle(tester, 2);
    await tester.enterText(find.widgetWithText(TextField, 'Куди'), 'Малага');
    await tester.tap(find.widgetWithText(FilledButton, 'Створити'));
    await settle(tester);
    expect(find.textContaining('№$_trip.2'), findsWidgets);

    // the picker of a move made on the spot: «Новий рейс» with «звідки → куди» filled in, popped back as picked
    final router = GoRouter.of(tester.element(find.byType(Scaffold).first));
    Trip? picked;
    final done = router
        .push<Trip>('/trips/pick?from=Mas%20Camarena&to=Малага')
        .then((t) => picked = t);
    await settle(tester, 2);
    await tester.tap(find.text('Новий рейс'));
    await settle(tester, 2);
    expect(find.text('Mas Camarena'), findsOneWidget);
    expect(find.text('Малага'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Створити'));
    await settle(tester);
    await done;
    expect(picked?.origin, 'Mas Camarena');
    expect(picked?.destination, 'Малага');
  });
}

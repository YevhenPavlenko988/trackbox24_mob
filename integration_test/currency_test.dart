// «Курси валют» on the phone of a representative against a local backend, with screenshots: the rates in «Ще»,
// the company's own rate, a move paid in dollars, the bill shared in another currency.
// Needs the seed from README («Сценарії на симуляторі»): rep E2E_REP / rep12345 in a company with the moves and
// currency modules, a move E2E_MOVE priced in euros.
//
//   flutter drive --driver test_driver/integration_test.dart --target integration_test/currency_test.dart \
//     -d <simulator> --dart-define=FLAVOR=dev --dart-define=API_BASE_URL=http://localhost:8080 \
//     --dart-define=E2E_REP=rep-sim@test.ua --dart-define=E2E_MOVE=M924353
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:trackbox24_mob/main.dart' as app;

const _rep = String.fromEnvironment('E2E_REP', defaultValue: 'rep-sim@test.ua');
const _move = String.fromEnvironment('E2E_MOVE');

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

  testWidgets('rates, a payment in dollars and the bill in zloty', (
    tester,
  ) async {
    app.main();
    await settle(tester, 4);
    if (find.text('Увійти').evaluate().isNotEmpty) {
      await tester.enterText(find.byType(TextFormField).at(0), _rep);
      await tester.enterText(find.byType(TextFormField).at(1), 'rep12345');
      await tester.tap(find.text('Увійти'));
      await settle(tester, 4);
    }

    // «Ще» → «Курси валют»: the bank's rate is used until the company sets its own
    await tester.tap(find.widgetWithText(NavigationDestination, 'Ще'));
    await settle(tester, 2);
    await tester.tap(find.text('Курси валют'));
    await settle(tester);
    expect(find.textContaining('Monobank'), findsWidgets);
    expect(find.text('Діє курс банку (продаж)'), findsNWidgets(3));
    await shot(tester, 'c01-rates');

    // a representative sets the company's dollar rate
    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('rate-USD')),
        matching: find.byTooltip('Встановити курс'),
      ),
    );
    await settle(tester, 1);
    await tester.enterText(find.byType(TextField).last, '46,5');
    await shot(tester, 'c02-set-rate');
    await tester.tap(find.text('Зберегти'));
    await settle(tester);
    expect(find.text(r'1 $ = 46,50 грн'), findsOneWidget);
    expect(find.textContaining('Курс компанії ·'), findsOneWidget);
    await shot(tester, 'c03-company-rate');
    await tester.tap(find.byType(BackButton));
    await settle(tester, 2);

    // the move: 100 $ into a bill in euros
    await tester.tap(find.widgetWithText(NavigationDestination, 'Переїзди'));
    await settle(tester);
    await tester.tap(find.textContaining(_move).first);
    await settle(tester);
    final pay = find.widgetWithText(OutlinedButton, 'Оплата');
    await tester.scrollUntilVisible(
      pay,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await settle(tester, 1);
    await tester.tap(pay);
    await settle(tester, 1);
    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('pay-currency')),
        matching: find.text(r'$'),
      ),
    );
    await settle(tester, 1);
    await tester.enterText(find.byType(TextField).first, '100');
    await settle(tester, 1);
    // 46,5 / EUR bank buy: the preview says what it comes to in euros
    expect(find.textContaining(r'за курсом 1 $ ='), findsOneWidget);
    await shot(tester, 'c04-pay-dollars');
    await tester.tap(find.text('Зберегти'));
    await settle(tester);
    expect(find.textContaining(r'100 $ →'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.textContaining(r'100 $ →'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await settle(tester, 1);
    await shot(tester, 'c05-paid-dollars');

    // the move itself in dollars: the payment is the same 100 $, at the rate it was paid
    await tester.ensureVisible(find.byKey(const ValueKey('move-currency')));
    // ensureVisible leaves it under the app bar: a bit more down
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 200));
    await settle(tester, 1);
    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('move-currency')),
        matching: find.text(r'$'),
      ),
    );
    await settle(tester, 1);
    // asked first: the prices are recalculated at the rate
    expect(find.textContaining(r'Перевести переїзд у $'), findsOneWidget);
    await shot(tester, 'c05a-switch-confirm');
    await tester.tap(find.text('Перерахувати'));
    await settle(tester);
    // the dollars paid are the move's money now, exactly
    expect(find.text(r'100 $'), findsNWidgets(2)); // «Оплачено» and the payment
    expect(find.textContaining(r'100 $ →'), findsNothing);
    await shot(tester, 'c05b-move-in-dollars');
    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('move-currency')),
        matching: find.text('€'),
      ),
    );
    await settle(tester, 1);
    await tester.tap(find.text('Перерахувати'));
    await settle(tester);

    // «Рахунок»: which currency the bill goes in
    await tester.tap(find.widgetWithText(OutlinedButton, 'Рахунок'));
    await settle(tester, 1);
    expect(find.text('У якій валюті рахунок?'), findsOneWidget);
    expect(find.byKey(const ValueKey('share-PLN')), findsOneWidget);
    await shot(tester, 'c06-share-currency');
    Navigator.of(tester.element(find.text('У якій валюті рахунок?'))).pop();
    await settle(tester, 1);
    // the move card is over the tabs
    await tester.tap(find.byType(BackButton));
    await settle(tester, 2);

    // back to the bank's rate, so a rerun starts the same
    await tester.tap(find.widgetWithText(NavigationDestination, 'Ще'));
    await settle(tester, 2);
    await tester.tap(find.text('Курси валют'));
    await settle(tester);
    await tester.tap(find.byTooltip('Повернути курс банку'));
    await settle(tester);
    expect(find.text('Діє курс банку (продаж)'), findsNWidgets(3));
  });
}

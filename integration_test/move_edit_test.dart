// Walks the moves screens of a representative against a local backend, with screenshots.
// Needs the seed from README («Сценарії на симуляторі»): rep E2E_REP / rep12345 in a company with the moves
// module and a move E2E_MOVE with at least three items.
//
//   flutter drive --driver test_driver/integration_test.dart --target integration_test/move_edit_test.dart \
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
    // network calls do not count as frames: pump for a while instead of pumpAndSettle alone
    for (var i = 0; i < seconds * 4; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
  }

  Future<void> shot(WidgetTester tester, String name) async {
    await binding.convertFlutterSurfaceToImage();
    await tester.pump();
    await binding.takeScreenshot(name);
  }

  testWidgets('a representative edits a move and deletes an item', (
    tester,
  ) async {
    app.main();
    await settle(tester, 4);

    // log in unless a session survived from a previous run
    if (find.text('Увійти').evaluate().isNotEmpty) {
      await tester.enterText(find.byType(TextFormField).at(0), _rep);
      await tester.enterText(find.byType(TextFormField).at(1), 'rep12345');
      await tester.tap(find.text('Увійти'));
      await settle(tester, 4);
    }
    await shot(tester, '01-after-login');

    // «Переїзди» is a tab; «Черга» moved into «Ще»
    expect(find.text('Переїзди'), findsWidgets);
    expect(find.widgetWithText(NavigationDestination, 'Черга'), findsNothing);
    await tester.tap(find.widgetWithText(NavigationDestination, 'Переїзди'));
    await settle(tester);
    await shot(tester, '02-moves-tab');

    await tester.tap(find.textContaining(_move).first);
    await settle(tester);
    await shot(tester, '03-move-card');

    // the move's own form, not the parcel one
    await tester.tap(find.byTooltip('Редагувати'));
    await settle(tester, 2);
    expect(find.text('Редагування переїзду'), findsOneWidget);
    await shot(tester, '04-edit-form');
    final to = find.widgetWithText(TextField, 'Куди');
    // a new value every run, or the form has nothing to save
    await tester.enterText(to, 'Краків ${DateTime.now().second}');
    await tester.tap(find.text('Зберегти'));
    await settle(tester);
    expect(find.text('Переїзд збережено'), findsOneWidget);
    await shot(tester, '05-saved');

    // the last item: rename it, then delete it
    final menus = find.byWidgetPredicate(
      (w) =>
          w is PopupMenuButton && (w.tooltip ?? '').startsWith('Дії з місцем'),
    );
    await tester.scrollUntilVisible(
      menus.last,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(menus.last);
    await settle(tester, 1);
    await shot(tester, '06-seat-menu');
    await tester.tap(find.text('Змінити опис'));
    await settle(tester, 1);
    await tester.enterText(find.byType(TextField).last, 'Помилково внесене');
    await tester.tap(find.text('Зберегти'));
    await settle(tester);
    expect(find.text('Помилково внесене'), findsOneWidget);

    await tester.tap(menus.last);
    await settle(tester, 1);
    await tester.tap(find.text('Видалити місце'));
    await settle(tester, 1);
    await shot(tester, '07-delete-confirm');
    await tester.tap(find.widgetWithText(FilledButton, 'Видалити'));
    await settle(tester);
    expect(find.text('Помилково внесене'), findsNothing);
    await shot(tester, '08-deleted');

    // the queue now lives in «Ще»
    await tester.tap(find.byType(BackButton).first);
    await settle(tester, 2);
    await tester.tap(find.widgetWithText(NavigationDestination, 'Ще'));
    await settle(tester, 2);
    expect(find.text('Черга'), findsOneWidget);
    await shot(tester, '09-more');
  });
}

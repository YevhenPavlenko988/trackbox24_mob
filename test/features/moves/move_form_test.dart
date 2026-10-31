import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/features/moves/move_form_screen.dart';
import 'package:trackbox24_mob/features/moves/move_quick_add.dart';

void main() {
  test('items are the non-blank lines', () {
    expect(itemLines('Диван\n\n  Шафа — дверцята \n   \nКоробка'), [
      'Диван',
      'Шафа — дверцята',
      'Коробка',
    ]);
    expect(itemLines(''), isEmpty);
  });

  testWidgets('a move needs its customer and at least one item', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2600);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('uk'),
          home: MoveFormScreen(tripId: 3),
        ),
      ),
    );
    await tester.enterText(find.byType(TextField).at(3), 'Диван\nШафа');
    await tester.pump();
    expect(find.text('Буде місць: 2'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(3), '');
    await tester.tap(find.text('Створити й друкувати етикетки'));
    await tester.pump();
    expect(find.text('Оберіть клієнта або створіть нового'), findsOneWidget);
    expect(find.text('Додайте хоча б одну річ'), findsOneWidget);
  });

  testWidgets('packing item by item: one field, add and print, done', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('uk'),
          home: Scaffold(body: QuickAddSheet(parcelId: 7)),
        ),
      ),
    );
    expect(find.byType(TextField), findsOneWidget);
    expect(find.textContaining('друкуйте етикетку одразу'), findsOneWidget);
    expect(
      find.widgetWithText(FilledButton, 'Додати й друкувати'),
      findsOneWidget,
    );
    expect(find.text('Готово'), findsOneWidget);
  });
}

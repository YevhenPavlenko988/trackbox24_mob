// A heavy camera original (48 Мп, 14–50 МБ) from the gallery goes to the server reduced to 2048 px, against a local
// backend with photos on, as a driver (README «Сценарії на симуляторі»). The system gallery is not a Flutter screen: the test opens
// it and waits up to 3 minutes for a person to tap the photo. Put the photo in first:
//
//   xcrun simctl addmedia <simulator> heavy_48mp.jpg
//   flutter drive --driver test_driver/integration_test.dart --target integration_test/photo_upload_test.dart \
//     -d <simulator> --dart-define=FLAVOR=dev --dart-define=API_BASE_URL=http://localhost:8080 \
//     --dart-define=E2E_USER=drv-photo@test.ua --dart-define=E2E_PASSWORD=driver123 --dart-define=E2E_PARCEL=PT1234567890
//
// The server's request log shows what came: `POST /api/parcels/{id}/photos -> 201 … req=[multipart/form-data…, N bytes]`.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:trackbox24_mob/main.dart' as app;

const _user = String.fromEnvironment(
  'E2E_USER',
  defaultValue: 'drv-photo@test.ua',
);
const _password = String.fromEnvironment(
  'E2E_PASSWORD',
  defaultValue: 'driver123',
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

  Future<void> signIn(WidgetTester tester) async {
    app.main();
    await settle(tester, 4);
    if (find.text('Увійти').evaluate().isEmpty) {
      // the last scenario may have left a screen open on top of the tabs
      while (find.byType(BackButton).evaluate().isNotEmpty) {
        await tester.tap(find.byType(BackButton).first);
        await settle(tester, 1);
      }
      // a web-only account (manager) has no tabs, only «Вийти»
      if (find.text('Вийти').evaluate().isEmpty) {
        await tester.tap(find.widgetWithText(NavigationDestination, 'Ще'));
        await settle(tester, 1);
      }
      if (find.text('Вийти').hitTestable().evaluate().isEmpty) {
        await tester.scrollUntilVisible(
          find.text('Вийти'),
          200,
          scrollable: find.byType(Scrollable).first,
        );
      }
      await tester.tap(find.text('Вийти'));
      await settle(tester, 2);
    }
    await tester.enterText(find.byType(TextFormField).at(0), _user);
    await tester.enterText(find.byType(TextFormField).at(1), _password);
    await tester.tap(find.text('Увійти'));
    await settle(tester, 4);
  }

  /// Opens the parcel by its code and the system gallery from its photos; a person picks the photo there.
  Future<void> openGallery(WidgetTester tester, String step) async {
    await tester.tap(find.widgetWithText(NavigationDestination, 'Сканувати'));
    await settle(tester, 2);
    await tester.tap(find.text('Ввести код'));
    await settle(tester);
    await tester.enterText(find.byType(TextField).last, _parcel);
    await tester.tap(find.text('Добре'));
    await settle(tester);

    // a driver gets the scan result with the actions: «Картка посилки», «Фото», «Сканувати далі»
    await tester.tap(find.text('Фото'));
    await settle(tester);
    final add = find.byIcon(Icons.add_a_photo_outlined);
    await tester.scrollUntilVisible(
      add,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(add);
    await settle(tester, 1);
    await tester.tap(find.byIcon(Icons.photo_library_outlined));
    debugPrint('SHOT gallery-open $step — tap the photo in the simulator');
  }

  Future<bool> waitFor(WidgetTester tester, Finder finder, int seconds) async {
    for (var i = 0; i < seconds * 4 && finder.evaluate().isEmpty; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
    return finder.evaluate().isNotEmpty;
  }

  testWidgets('a heavy photo from the gallery is uploaded', (tester) async {
    await signIn(tester);
    await openGallery(tester, '1');
    // the person picks the photo; then the upload, then «Фото додано»
    final added = find.textContaining(RegExp('[Дд]одано'));
    await waitFor(tester, added, 180);
    await shot(tester, 'photo-uploaded');
    expect(added, findsOneWidget);
  }, timeout: const Timeout(Duration(minutes: 5)));

  // No cancel button: the driver changes their mind by leaving the parcel while the photo is on its way. The app
  // stays usable and the upload finishes on its own (the server log shows the 201). Needs a slow link to catch it.
  testWidgets('leaving the parcel while the photo uploads', (tester) async {
    await signIn(tester);
    await openGallery(tester, '2');
    final uploading = find.byType(CircularProgressIndicator);
    expect(await waitFor(tester, uploading, 180), isTrue);
    await shot(tester, 'photo-uploading');
    await tester.tap(find.byType(BackButton).first);
    await settle(tester, 2);
    await shot(tester, 'left-the-parcel');
    // the app goes on: another tab opens while the photo is still going
    await tester.tap(find.widgetWithText(NavigationDestination, 'Ще'));
    await settle(tester, 30);
    expect(find.text('Вийти'), findsOneWidget);
  }, timeout: const Timeout(Duration(minutes: 5)));
}

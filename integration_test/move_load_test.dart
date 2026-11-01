// A driver loads a move from their trip's scanner: an item of a move opens the move's own screen (every item
// counted), not the sheet of a parcel. Seed: driver E2E_DRIVER / driver123 with an open trip E2E_TRIP (its number),
// a received move E2E_MOVE with at least two items.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:trackbox24_mob/main.dart' as app;

const _driver = String.fromEnvironment(
  'E2E_DRIVER',
  defaultValue: 'drv-sim@test.ua',
);
const _trip = String.fromEnvironment('E2E_TRIP');
const _tripId = int.fromEnvironment('E2E_TRIP_ID');
const _move = String.fromEnvironment('E2E_MOVE');
const _warehouse = int.fromEnvironment('E2E_WAREHOUSE_ID');
const _api = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8080',
);

/// What happens at the warehouse while the driver looks at the trip: a request as [email].
Future<void> _as(
  String email,
  String password,
  String path,
  Object body,
) async {
  final client = HttpClient();
  try {
    Future<Map<String, dynamic>> call(
      String p,
      Object b, [
      String? token,
    ]) async {
      final req = await client.postUrl(Uri.parse('$_api$p'));
      req.headers.contentType = ContentType.json;
      if (token != null) req.headers.set('Authorization', 'Bearer $token');
      req.write(jsonEncode(b));
      final res = await req.close();
      final text = await res.transform(utf8.decoder).join();
      return text.isEmpty ? {} : jsonDecode(text) as Map<String, dynamic>;
    }

    final login = await call('/api/auth/login', {
      'email': email,
      'password': password,
    });
    await call(path, body, login['accessToken'] as String);
  } finally {
    client.close();
  }
}

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

  Future<void> enterCode(WidgetTester tester, String code) async {
    await tester.tap(find.text('Ввести код'));
    await settle(tester);
    await tester.enterText(find.byType(TextField).last, code);
    await tester.tap(find.text('Добре'));
    await settle(tester);
  }

  testWidgets('an item of a move scanned into a trip opens the move screen', (
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

    await shot(tester, 'l0-trips');
    // a trip not started yet is under «Заплановані»
    await tester.tap(find.text('Заплановані'));
    await settle(tester, 2);
    await tester.tap(find.textContaining('№$_trip').first);
    await settle(tester);
    await tester.tap(find.text('Завантажити'));
    await settle(tester, 2);
    await enterCode(tester, '$_move-1');
    await shot(tester, 'l1-move-screen');

    // the move's screen, with the item counted, and the trip by its number on the scanner before it
    expect(find.text('Ваша дія'), findsNothing);
    expect(find.textContaining('1 з'), findsWidgets);

    // the rest of the move loaded: the trip reminds to depart
    for (final n in [2, 3]) {
      await _as(_driver, 'driver123', '/api/scan/load', {
        'code': '$_move-$n',
        'tripId': _tripId,
      });
    }
    await tester.tap(find.byType(BackButton).first);
    await settle(tester);
    if (find.text('Усе завантажено').evaluate().isEmpty) {
      await tester.tap(find.byType(BackButton).first);
      await settle(tester);
    }
    await shot(tester, 'l2-depart-reminder');
    expect(find.text('Усе завантажено'), findsOneWidget);

    // unloaded at the warehouse without «Виїхав»: the trip reminds to complete, and completing records the departure
    for (final n in [1, 2, 3]) {
      await _as('manager@test.ua', 'manager123', '/api/scan/to-warehouse', {
        'code': '$_move-$n',
        'warehouseId': _warehouse,
      });
    }
    await tester.drag(find.byType(ListView).first, const Offset(0, 400));
    await settle(tester);
    await shot(tester, 'l3-complete-reminder');
    expect(find.text('Машина порожня'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Завершити').first);
    await settle(tester, 2);
    await tester.tap(find.widgetWithText(FilledButton, 'Завершити').last);
    await settle(tester);
    await shot(tester, 'l4-completed');
    expect(find.text('Машина порожня'), findsNothing);
    expect(find.text('Завершений'), findsWidgets);
  });
}

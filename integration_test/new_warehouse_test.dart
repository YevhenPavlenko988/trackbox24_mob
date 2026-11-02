// A warehouse added on the web while the app is open is offered when the driver completes a trip. Seed: driver
// E2E_DRIVER / driver123 with a trip on the road (number E2E_TRIP) that still has cargo in the car.
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
const _api = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8080',
);

Future<void> _addWarehouse(String name) async {
  final client = HttpClient();
  try {
    Future<Map<String, dynamic>> post(
      String path,
      Object body, [
      String? token,
    ]) async {
      final req = await client.postUrl(Uri.parse('$_api$path'));
      req.headers.contentType = ContentType.json;
      if (token != null) req.headers.set('Authorization', 'Bearer $token');
      req.write(jsonEncode(body));
      final res = await req.close();
      return jsonDecode(await res.transform(utf8.decoder).join())
          as Map<String, dynamic>;
    }

    final login = await post('/api/auth/login', {
      'email': 'manager@test.ua',
      'password': 'manager123',
    });
    await post('/api/warehouses', {
      'name': name,
    }, login['accessToken'] as String);
  } finally {
    client.close();
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> settle(WidgetTester tester, [int seconds = 3]) async {
    for (var i = 0; i < seconds * 4; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
  }

  testWidgets('a warehouse added meanwhile is offered on completing', (
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
    await tester.tap(find.textContaining('№$_trip').first);
    await settle(tester);

    // the app is open and has read the warehouses already; one is added on the web now
    final name = 'могилів ${DateTime.now().millisecondsSinceEpoch % 100000}';
    await _addWarehouse(name);

    await tester.scrollUntilVisible(
      find.widgetWithText(FilledButton, 'Завершити'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Завершити'));
    await settle(tester);
    // the first try says the car is not empty and asks where to unload
    await tester.tap(find.widgetWithText(FilledButton, 'Завершити').last);
    await settle(tester);
    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await settle(tester, 1);
    expect(find.text(name), findsWidgets);
  });
}

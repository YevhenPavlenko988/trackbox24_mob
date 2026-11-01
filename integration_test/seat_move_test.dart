// A representative moves a chosen item onto a warehouse without scanning. Seed: see move_edit_test.dart, plus an
// active warehouse E2E_WAREHOUSE in the company.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:trackbox24_mob/main.dart' as app;

const _rep = String.fromEnvironment('E2E_REP', defaultValue: 'rep-sim@test.ua');
const _move = String.fromEnvironment('E2E_MOVE');
const _warehouse = String.fromEnvironment(
  'E2E_WAREHOUSE',
  defaultValue: 'варшава',
);
const _api = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8080',
);

/// E2E_REFUSED=true: the move goes to the trash while the sheet is open, so the server refuses and the sheet
/// has to say why (manager@test.ua does it, then restores the move).
const _refused = bool.fromEnvironment('E2E_REFUSED');

Future<Object?> _call(
  String method,
  String path, [
  Object? body,
  String? token,
]) async {
  final client = HttpClient();
  try {
    final req = await client.openUrl(method, Uri.parse('$_api$path'));
    req.headers.contentType = ContentType.json;
    if (token != null) req.headers.set('Authorization', 'Bearer $token');
    if (body != null) req.write(jsonEncode(body));
    final res = await req.close();
    final text = await res.transform(utf8.decoder).join();
    return text.isEmpty ? null : jsonDecode(text);
  } finally {
    client.close();
  }
}

/// Moves the move to the trash (or back) behind the app's back, so the server refuses what the sheet sends.
Future<void> _setMoveDeleted(bool deleted) async {
  final login = await _call('POST', '/api/auth/login', {
    'email': 'manager@test.ua',
    'password': 'manager123',
  });
  final token = (login! as Map)['accessToken'] as String;
  final page = await _call(
    'GET',
    deleted
        ? '/api/parcels?kind=MOVE&query=$_move'
        : '/api/parcels/deleted?size=100',
    null,
    token,
  );
  // the trash wraps each row: {item: parcel, deletedAt, ...}
  final move = ((page! as Map)['content'] as List)
      .cast<Map<String, dynamic>>()
      .map((p) => deleted ? p : p['item'] as Map<String, dynamic>)
      .firstWhere((p) => p['barcode'] == _move);
  await _call(
    deleted ? 'DELETE' : 'POST',
    deleted
        ? '/api/parcels/${move['id']}'
        : '/api/parcels/${move['id']}/restore',
    null,
    token,
  );
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

  testWidgets('a chosen item goes onto a warehouse without scanning', (
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
    await tester.tap(find.widgetWithText(NavigationDestination, 'Переїзди'));
    await settle(tester);
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
    await tester.tap(find.text('На склад'));
    await settle(tester, 2);
    await shot(tester, 'm1-pick-warehouse');
    await tester.tap(find.text(_warehouse).last);
    await settle(tester, 2);
    await tester.enterText(find.byType(TextField).last, 'test');
    await settle(tester, 1);
    await shot(tester, 'm2-sheet');
    if (_refused) {
      await _setMoveDeleted(true);
      try {
        await tester.tap(find.text('Перемістити'));
        await settle(tester, 4);
        await shot(tester, 'm3-refused');
        // the reason is in the sheet, which stays open
        expect(find.textContaining('знайдено'), findsOneWidget);
        expect(find.text('Перемістити'), findsOneWidget);
      } finally {
        await _setMoveDeleted(false);
      }
      return;
    }
    await tester.tap(find.text('Перемістити'));
    await settle(tester, 4);
    await shot(tester, 'm3-after');
    expect(find.textContaining('Переміщено місць'), findsOneWidget);
  });
}

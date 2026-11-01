import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:trackbox24_mob/core/api/auth_interceptor.dart';
import 'package:trackbox24_mob/core/api/dio_client.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/features/moves/data/move_bill.dart';
import 'package:trackbox24_mob/features/moves/move_bill_section.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';

const _json = {
  'currency': 'EUR',
  'transport': 800,
  'works': [
    {
      'id': 3,
      'kind': 'LOAD',
      'kindLabel': 'Завантаження',
      'plannedHours': 3,
      'clientRate': 15,
      'loaderRate': 10,
      'loaders': [
        {
          'loaderId': 4,
          'name': 'Мельник Андрій',
          'actualHours': 4,
          'hours': 4,
          'clientAmount': 60,
          'loaderAmount': 40,
          'paid': true,
        },
        {
          'loaderId': 5,
          'name': 'Петро',
          'hours': 3,
          'clientAmount': 45,
          'loaderAmount': 30,
          'paid': false,
        },
      ],
      'clientAmount': 105,
      'loaderAmount': 70,
    },
  ],
  'storages': [
    {
      'id': 2,
      'warehouseName': 'Склад Львів',
      'days': 10,
      'rate': 5,
      'amount': 50,
    },
  ],
  'payments': [
    {
      'id': 1,
      'amount': 200,
      'methodLabel': 'Готівка',
      'paidOn': '2026-11-01',
      'note': 'Передоплата',
    },
  ],
  'loadersTotal': 105,
  'storageTotal': 50,
  'total': 955,
  'paid': 200,
  'due': 755,
  'loaderPayout': 70,
  'loaderPaid': 40,
};

void main() {
  test('the bill reads the client side and the loaders side', () {
    final b = MoveBill.fromJson(_json);
    expect(b.due, 755);
    expect(b.works.single.loaders.first.actualHours, 4);
    expect(b.works.single.loaders.last.actualHours, isNull);
    expect(b.works.single.loaders.last.hours, 3);
    expect(b.storages.single.amount, 50);
    expect(b.payments.single.note, 'Передоплата');
  });

  test('a loader fact goes with the hours and «paid»', () async {
    final dio = createDio(
      baseUrl: 'http://test',
      auth: AuthInterceptor(
        readToken: () async => 'jwt',
        onUnauthorized: () async {},
      ),
    );
    DioAdapter(dio: dio).onPut(
      '/api/parcels/7/works/3/loaders/5',
      (s) => s.reply(200, _json),
      data: {'actualHours': 3.5, 'paid': true},
    );
    final bill = await MoveBillApi(dio)
        .setFact(7, 3, 5, actualHours: 3.5, paid: true);
    expect(bill.total, 955);
  });

  testWidgets(
    'the card shows the totals, the work with its loaders, storage and payments',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 3000);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            moveBillProvider.overrideWith(
              (ref, id) async => MoveBill.fromJson(_json),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('uk'),
            home: Scaffold(
              body: SingleChildScrollView(
                child: MoveBillSection(
                  parcel: Parcel(
                    id: 7,
                    barcode: 'M104521',
                    kind: ParcelKind.MOVE,
                  ),
                  editable: true,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('До сплати'), findsOneWidget);
      expect(find.textContaining('755'), findsWidgets);
      expect(find.text('Мельник Андрій'), findsOneWidget);
      expect(find.text('Робота'), findsOneWidget);
      expect(find.text('Рахунок'), findsOneWidget);
      expect(find.textContaining('Склад Львів'), findsOneWidget);
      expect(find.textContaining('Передоплата'), findsOneWidget);
    },
  );
}

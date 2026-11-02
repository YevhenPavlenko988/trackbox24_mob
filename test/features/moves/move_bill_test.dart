import 'package:dio/dio.dart';
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

  test('ticked loaders first; a search filters the rest by name or phone', () {
    const all = [
      Loader(id: 1, fullName: 'Мельник Андрій', phone: '380671112233'),
      Loader(id: 2, fullName: 'Петро'),
      Loader(id: 3, fullName: 'Коваль Іван', phone: '380509998877'),
    ];
    expect(pickLoaders(all, {3}, '').map((l) => l.id), [3, 1, 2]);
    expect(pickLoaders(all, {3}, 'мельн').map((l) => l.id), [3, 1]);
    expect(pickLoaders(all, {}, '0671').map((l) => l.id), [1]);
    // a tick in the sheet does not move the row; a ticked one is not hidden by a search
    expect(pickLoaders(all, {}, '', ticked: {2}).map((l) => l.id), [1, 2, 3]);
    expect(pickLoaders(all, {}, 'мельн', ticked: {2}).map((l) => l.id), [1, 2]);
  });

  test('the city narrows the pick, the ticked ones stay', () {
    const all = [
      Loader(id: 1, fullName: 'Мельник Андрій', city: 'Київ'),
      Loader(id: 2, fullName: 'Петро', city: 'Львів'),
      Loader(id: 3, fullName: 'Коваль Іван', city: 'київ'),
    ];
    expect(loaderCities(all), ['Київ', 'Львів']);
    expect(pickLoaders(all, {}, '', city: 'Київ').map((l) => l.id), [1, 3]);
    expect(pickLoaders(all, {2}, '', city: 'Київ').map((l) => l.id), [2, 1, 3]);
  });

  testWidgets('a work entered by mistake is deleted after a confirmation', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 3000);
    addTearDown(tester.view.reset);
    final dio = createDio(
      baseUrl: 'http://test',
      auth: AuthInterceptor(
        readToken: () async => 'jwt',
        onUnauthorized: () async {},
      ),
    );
    var deleted = false;
    DioAdapter(dio: dio).onDelete(
      '/api/parcels/7/works/3',
      (s) => s.reply(200, {..._json, 'works': <Object>[]}),
    );
    // the adapter builds its replies up front: the requests actually sent are counted here
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (o, h) {
          if (o.method == 'DELETE') deleted = true;
          h.next(o);
        },
      ),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          moveBillApiProvider.overrideWithValue(MoveBillApi(dio)),
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
    await tester.tap(find.byTooltip('Видалити роботу'));
    await tester.pumpAndSettle();
    expect(find.textContaining('разом із вантажниками'), findsOneWidget);
    // cancelling keeps it
    await tester.tap(find.text('Скасувати'));
    await tester.pumpAndSettle();
    expect(deleted, isFalse);
    await tester.tap(find.byTooltip('Видалити роботу'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Видалити'));
    await tester.pumpAndSettle();
    expect(deleted, isTrue);
  });

  testWidgets('the hours and rates typed after ticking a loader are saved', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 3000);
    addTearDown(tester.view.reset);
    final dio = createDio(
      baseUrl: 'http://test',
      auth: AuthInterceptor(
        readToken: () async => 'jwt',
        onUnauthorized: () async {},
      ),
    );
    DioAdapter(dio: dio).onPost(
      '/api/parcels/7/works',
      (s) => s.reply(200, _json),
      data: Matchers.any,
    );
    Map<String, dynamic>? sent;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (o, h) {
          if (o.method == 'POST') sent = o.data as Map<String, dynamic>;
          h.next(o);
        },
      ),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          moveBillApiProvider.overrideWithValue(MoveBillApi(dio)),
          moveBillProvider.overrideWith(
            (ref, id) async => MoveBill.fromJson(_json),
          ),
          loadersProvider.overrideWith(
            (ref) async => const [Loader(id: 4, fullName: 'Мельник Андрій')],
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
    await tester.tap(find.widgetWithText(OutlinedButton, 'Робота'));
    await tester.pumpAndSettle();
    // the loader first, the money after: typing does not rebuild the sheet
    await tester.tap(find.widgetWithText(CheckboxListTile, 'Мельник Андрій'));
    await tester.pump();
    await tester.enterText(
      find.widgetWithText(TextField, 'Планових годин'),
      '3',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Клієнту за год'),
      '15',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Вантажнику за год'),
      '10',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Зберегти'));
    await tester.pumpAndSettle();
    expect(sent?['loaderIds'], [4]);
    expect(sent?['plannedHours'], 3);
    expect(sent?['clientRate'], 15);
    expect(sent?['loaderRate'], 10);
  });
}

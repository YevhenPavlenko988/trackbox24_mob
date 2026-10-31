import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/features/company/data/company_api.dart';
import 'package:trackbox24_mob/features/company/state/company.dart';
import 'package:trackbox24_mob/features/moves/move_seats_section.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_photo_api.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_photo_model.dart';

const _move = Parcel(
  id: 7,
  barcode: 'M104521',
  kind: ParcelKind.MOVE,
  status: ParcelStatus.IN_CAR,
  seats: [
    Seat(seatNumber: 1, barcode: 'M104521-1', status: ParcelStatus.IN_CAR),
  ],
);

const _two = Parcel(
  id: 8,
  barcode: 'M104522',
  kind: ParcelKind.MOVE,
  status: ParcelStatus.IN_CAR,
  seats: [
    Seat(seatNumber: 1, barcode: 'M104522-1', status: ParcelStatus.IN_CAR),
    Seat(seatNumber: 2, barcode: 'M104522-2', status: ParcelStatus.IN_CAR),
  ],
);

Future<void> _pump(
  WidgetTester tester, {
  required bool moves,
  bool photos = false,
  Parcel parcel = _move,
  bool canDeliver = false,
}) => tester.pumpWidget(
  ProviderScope(
    overrides: [
      currentCompanyProvider.overrideWith(
        (ref) => CompanyInfo(
          id: 1,
          name: 'Firma',
          photosEnabled: photos,
          movesEnabled: moves,
        ),
      ),
      parcelPhotosProvider.overrideWith((ref, id) => const <ParcelPhoto>[]),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('uk'),
      home: Scaffold(
        body: SingleChildScrollView(
          child: MoveSeatsSection(
            parcel: parcel,
            canScan: true,
            canDeliver: canDeliver,
          ),
        ),
      ),
    ),
  ),
);

void main() {
  testWidgets('with the module the driver scans and photographs items', (
    tester,
  ) async {
    await _pump(tester, moves: true);
    await tester.pumpAndSettle();
    expect(find.text('Сканувати переїзд'), findsOneWidget);
    expect(find.byIcon(Icons.photo_camera_outlined), findsOneWidget);
    expect(find.textContaining('вимкнено'), findsNothing);
    expect(find.text('Додати речі'), findsOneWidget);
    expect(find.text('Додати й друкувати'), findsOneWidget);
  });

  testWidgets('without the module the move is read-only', (tester) async {
    await _pump(tester, moves: false);
    await tester.pumpAndSettle();
    expect(find.text('Сканувати переїзд'), findsNothing);
    expect(find.byIcon(Icons.photo_camera_outlined), findsNothing);
    expect(find.textContaining('вимкнено'), findsOneWidget);
    expect(find.text('Додати речі'), findsNothing);
    expect(find.text('Додати й друкувати'), findsNothing);
    // the register is for anyone who sees the move, module or not
    expect(find.text('Реєстр'), findsOneWidget);
  });

  testWidgets('without the module item photos still come with photos on', (
    tester,
  ) async {
    await _pump(tester, moves: false, photos: true);
    await tester.pumpAndSettle();
    expect(find.text('Сканувати переїзд'), findsNothing);
    expect(find.byIcon(Icons.photo_camera_outlined), findsOneWidget);
  });

  testWidgets('a checkbox chooses items; a driver may hand them over', (
    tester,
  ) async {
    await _pump(tester, moves: true, parcel: _two, canDeliver: true);
    await tester.pumpAndSettle();
    expect(find.text('Вибрано: 1'), findsNothing);
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    expect(find.text('Вибрано: 1'), findsOneWidget);
    expect(find.text('На склад'), findsOneWidget);
    expect(find.text('Видати'), findsOneWidget);
    // a tap on the row chooses too
    await tester.tap(find.text('M104522-2'));
    await tester.pumpAndSettle();
    expect(find.text('Вибрано: 2'), findsOneWidget);
    await tester.tap(find.byTooltip('Зняти вибір'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Вибрано'), findsNothing);
  });

  testWidgets('a representative moves chosen items only onto a warehouse', (
    tester,
  ) async {
    await _pump(tester, moves: true, parcel: _two);
    await tester.pumpAndSettle();
    await tester.tap(find.text('M104522-1'));
    await tester.pumpAndSettle();
    expect(find.text('На склад'), findsOneWidget);
    expect(find.text('Видати'), findsNothing);
  });

  testWidgets('without the module nothing can be chosen', (tester) async {
    await _pump(tester, moves: false, parcel: _two);
    await tester.pumpAndSettle();
    expect(find.byType(Checkbox), findsNothing);
    await tester.tap(find.text('M104522-1'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Вибрано'), findsNothing);
  });
}

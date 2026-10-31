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

Future<void> _pump(
  WidgetTester tester, {
  required bool moves,
  bool photos = false,
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
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('uk'),
      home: Scaffold(
        body: SingleChildScrollView(
          child: MoveSeatsSection(parcel: _move, canScan: true),
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
  });

  testWidgets('without the module the move is read-only', (tester) async {
    await _pump(tester, moves: false);
    await tester.pumpAndSettle();
    expect(find.text('Сканувати переїзд'), findsNothing);
    expect(find.byIcon(Icons.photo_camera_outlined), findsNothing);
    expect(find.textContaining('вимкнено'), findsOneWidget);
  });

  testWidgets('without the module item photos still come with photos on', (
    tester,
  ) async {
    await _pump(tester, moves: false, photos: true);
    await tester.pumpAndSettle();
    expect(find.text('Сканувати переїзд'), findsNothing);
    expect(find.byIcon(Icons.photo_camera_outlined), findsOneWidget);
  });
}

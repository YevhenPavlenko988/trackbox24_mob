import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/scan/ui/scan_result_card.dart';
import 'package:trackbox24_mob/features/trips/data/trip_api.dart';
import 'package:trackbox24_mob/features/trips/data/trip_model.dart';

Future<void> _pump(WidgetTester tester, Parcel parcel) => tester.pumpWidget(
  ProviderScope(
    overrides: [
      // another driver's leg: its car and driver come from the route
      routeLegsProvider.overrideWith(
        (ref, routeId) async => const [
          Trip(id: 20, number: 14, routeId: 5, legNumber: 1),
          Trip(
            id: 21,
            number: 14,
            routeId: 5,
            legNumber: 2,
            carPlateNumber: 'AA1234',
            driverName: 'Іван Коваль',
          ),
        ],
      ),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('uk'),
      home: Scaffold(body: NextLegHint(parcel)),
    ),
  ),
);

void main() {
  testWidgets('a transfer names the next leg with its car and driver', (
    tester,
  ) async {
    await _pump(
      tester,
      const Parcel(
        id: 1,
        plannedRouteId: 5,
        plannedTripId: 21,
        plannedTripNumber: 14,
        tripLegNumber: 2,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Далі — плече 14.2: AA1234, Іван Коваль'), findsOneWidget);
  });

  testWidgets('no next leg yet: it waits at the warehouse', (tester) async {
    await _pump(tester, const Parcel(id: 1, plannedRouteId: 5));
    await tester.pumpAndSettle();
    expect(find.textContaining('ще немає'), findsOneWidget);
  });
}

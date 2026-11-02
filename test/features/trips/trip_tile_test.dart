import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/features/trips/data/trip_model.dart';
import 'package:trackbox24_mob/features/trips/ui/trip_tile.dart';

void main() {
  testWidgets('a trip of moves says what it carries', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('uk'),
        home: Scaffold(
          body: TripTile(
            onTap: () {},
            trip: Trip.fromJson(const {
              'id': 5,
              'number': 4,
              'legNumber': 1,
              'status': 'IN_PROGRESS',
              'origin': 'Київ',
              'destination': 'Могилів',
              'moves': [
                {
                  'id': 9,
                  'barcode': 'M348478',
                  'clientName': 'Павленко Світлана',
                  'description': 'квартирний переїзд',
                  'seats': 6,
                },
                {'id': 10, 'barcode': 'M1', 'seats': 1},
                {'id': 11, 'barcode': 'M2', 'seats': 1},
              ],
            }),
          ),
        ),
      ),
    );
    expect(
      find.text('M348478 · Павленко Світлана · квартирний переїзд · 6 м.'),
      findsOneWidget,
    );
    expect(find.text('ще переїздів: 1'), findsOneWidget);
  });
}

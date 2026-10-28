import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/ui/tracking_qr_sheet.dart';

const _url = 'https://trackbox24.com/track/PT0123456789';

void main() {
  test('reads the tracking link, absent when the company has it off', () {
    expect(Parcel.fromJson({'id': 1, 'trackingUrl': _url}).trackingUrl, _url);
    expect(Parcel.fromJson({'id': 1}).trackingUrl, isNull);
  });

  test('QR modules fill the square and nothing outside it', () {
    final bars = qrModules(_url, 240).toList();
    expect(bars, isNotEmpty);
    for (final b in bars) {
      expect(b.left, greaterThanOrEqualTo(0));
      expect(b.top, greaterThanOrEqualTo(0));
      expect(b.right, lessThanOrEqualTo(240.001));
      expect(b.bottom, lessThanOrEqualTo(240.001));
    }
    // Finder patterns sit in three corners: the top-left module is dark.
    expect(bars.any((b) => b.left < 1 && b.top < 1), isTrue);
  });

  testWidgets('sheet shows the parcel code, the QR and both actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('uk'),
        home: Scaffold(
          body: TrackingQrSheet(
            parcel: Parcel(id: 1, barcode: 'PT0123456789', trackingUrl: _url),
          ),
        ),
      ),
    );
    expect(find.text('PT0123456789'), findsOneWidget);
    expect(find.byType(TrackingQr), findsOneWidget);
    expect(find.text('Копіювати'), findsOneWidget);
    expect(find.text('Поділитися'), findsOneWidget);
  });
}

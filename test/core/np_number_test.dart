import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/core/ui/np_number.dart';

void main() {
  test('the last four digits of a Nova Poshta number stand apart', () {
    expect(npTail('20451558819168'), '9168');
    expect(npTail('20 4515 5881 9168'), '9168');
    expect(npTail('PT9117009599'), isNull);
    expect(npTail('2045155881916'), isNull);
  });

  test('the span splits the number and keeps everything else whole', () {
    final span = npNumberSpan(
      '20451558819168',
      style: const TextStyle(fontSize: 10),
    );
    final parts = span.children!.cast<TextSpan>();
    expect(parts.map((p) => p.text), ['2045155881', '9168']);
    expect(parts.last.style?.fontWeight, FontWeight.w800);
    expect(parts.last.style?.fontSize, 12);

    final grouped = npNumberSpan('20451558819168', grouped: true);
    expect(grouped.children!.cast<TextSpan>().first.text, '20 4515 5881 ');

    final plain = npNumberSpan('PT9117009599-1');
    expect(plain.text, 'PT9117009599-1');
    expect(plain.children, isNull);
  });

  testWidgets('NpNumberText renders a prefix and the tail', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: NpNumberText('20451558819168', prefix: 'ТТН ')),
      ),
    );
    expect(find.textContaining('ТТН 2045155881'), findsOneWidget);
    final rich = tester.widget<Text>(find.byType(Text));
    expect(rich.textSpan?.toPlainText(), 'ТТН 20451558819168');
  });
}

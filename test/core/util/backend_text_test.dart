import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations_uk.dart';
import 'package:trackbox24_mob/core/util/backend_text.dart';

void main() {
  final l = AppLocalizationsUk();

  test('translates known backend comments', () {
    expect(translateComment(l, 'Loading started'), 'Почалося завантаження');
    expect(
      translateComment(l, 'Departed, odometer 1000 km'),
      'Виїхав, одометр 1000 км',
    );
    expect(
      translateComment(l, 'Completed, odometer 1250 km'),
      'Завершено, одометр 1250 км',
    );
    expect(
      translateComment(l, 'To warehouse Склад 107050'),
      'На склад «Склад 107050»',
    );
    expect(
      translateComment(l, 'Not loaded before departure'),
      'Не завантажено до виїзду',
    );
    expect(
      translateComment(l, 'Re-planned to trip 3'),
      'Переплановано в рейс #3',
    );
    expect(translateComment(l, 'All 3 seats'), 'Усі місця (3)');
    expect(
      translateComment(l, 'Manual status change to AT_WAREHOUSE'),
      'Ручна зміна статусу на «На складі»',
    );
  });

  test('passes unknown text and null through', () {
    expect(
      translateComment(l, 'Клієнт просив залишити у сусіда'),
      'Клієнт просив залишити у сусіда',
    );
    expect(translateComment(l, null), isNull);
    expect(translateComment(l, ''), '');
  });
}

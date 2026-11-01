import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/features/auth/data/user_model.dart';
import 'package:trackbox24_mob/features/company/data/company_api.dart';
import 'package:trackbox24_mob/features/shell/role_shell.dart';

const _rep = User(id: 1, email: 'rep@test.ua', roles: [Role.REPRESENTATIVE]);

void main() {
  test('the parcels module is on unless the company says otherwise', () {
    expect(CompanyInfo.fromJson({'id': 1}).parcelsEnabled, isTrue);
    expect(
      CompanyInfo.fromJson({'id': 1, 'parcelsEnabled': false}).parcelsEnabled,
      isFalse,
    );
  });

  test('a representative of a moves-only company has no «Забрати» tab', () {
    expect(shellTabs(_rep).map((t) => t.branch), contains(0));
    final tabs = shellTabs(_rep, parcels: false).map((t) => t.branch);
    expect(tabs, isNot(contains(0)));
    // «Отримані» lists the moves and comes first
    expect(tabs.first, 1);
  });

  test(
    'a representative with moves gets «Переїзди», and «Черга» moves into «Ще»',
    () {
      final tabs = shellTabs(_rep, moves: true).map((t) => t.branch).toList();
      expect(tabs, [0, 1, 7, 3, 5]);
      expect(queueInMore(_rep, moves: true), isTrue);
      // without the module nothing changes
      expect(shellTabs(_rep).map((t) => t.branch), [0, 1, 3, 4, 5]);
    },
  );

  test('a driver keeps the queue tab even in a moves company', () {
    const drv = User(id: 2, email: 'drv@test.ua', roles: [Role.DRIVER]);
    expect(shellTabs(drv, moves: true).map((t) => t.branch), contains(4));
    expect(queueInMore(drv, moves: true), isFalse);
  });
}

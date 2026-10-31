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
}

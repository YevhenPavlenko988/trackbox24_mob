import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/features/auth/data/user_model.dart';
import 'package:trackbox24_mob/features/scan/state/scan_actions.dart';
import 'package:trackbox24_mob/features/scan/state/scan_service.dart';

const _driver = User(id: 1, email: 'd@test.ua', roles: [Role.DRIVER]);
const _rep = User(id: 2, email: 'r@test.ua', roles: [Role.REPRESENTATIVE]);

List<ScanMode> _modes(String code, User user, {bool offline = true}) =>
    actionsForCode(code, user, offline: offline).map((a) => a.mode).toList();

void main() {
  test('offline a driver can load, store or hand over by our label', () {
    expect(_modes('PT0123456789', _driver), [
      ScanMode.load,
      ScanMode.deliver,
      ScanMode.toWarehouse,
    ]);
    expect(_modes('M104521-7', _driver), contains(ScanMode.load));
  });

  test('offline a Nova Poshta waybill is not a dead end for a driver', () {
    expect(_modes('20450000000001', _driver), [
      ScanMode.load,
      ScanMode.deliver,
      ScanMode.toWarehouse,
    ]);
    expect(_modes('20450000000001', _rep).first, ScanMode.receive);
  });

  test('a waybill the server has never seen can only be received', () {
    expect(_modes('20450000000001', _rep, offline: false), [ScanMode.receive]);
    expect(_modes('20450000000001', _driver, offline: false), isEmpty);
  });
}

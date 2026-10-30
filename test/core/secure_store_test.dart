import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/core/storage/secure_store.dart';

void main() {
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  test(
    'remembers the sign-in until the box is unticked, through a logout',
    () async {
      final store = SecureStore();
      expect(await store.readRememberedLogin(), isNull);

      await store.writeRememberedLogin('driver@demo.local', 'secret123');
      await store.clearToken(); // logout keeps it
      expect(await store.readRememberedLogin(), (
        'driver@demo.local',
        'secret123',
      ));

      await store.writeRememberedLogin(null, null);
      expect(await store.readRememberedLogin(), isNull);
    },
  );
}

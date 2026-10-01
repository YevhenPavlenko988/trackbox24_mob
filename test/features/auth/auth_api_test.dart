import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/api/auth_interceptor.dart';
import 'package:trackbox24_mob/core/api/dio_client.dart';
import 'package:trackbox24_mob/features/auth/data/auth_api.dart';
import 'package:trackbox24_mob/features/auth/data/user_model.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late AuthApi api;
  var unauthorizedCalls = 0;
  String? token;

  setUp(() {
    unauthorizedCalls = 0;
    token = null;
    dio = createDio(
      baseUrl: 'http://test',
      auth: AuthInterceptor(
        readToken: () async => token,
        onUnauthorized: () async => unauthorizedCalls++,
      ),
    );
    adapter = DioAdapter(dio: dio);
    api = AuthApi(dio);
  });

  test('login returns token and does not send Authorization', () async {
    token = 'stale';
    adapter.onPost(
      '/api/auth/login',
      (s) => s.reply(200, {'accessToken': 'jwt', 'tokenType': 'Bearer', 'expiresIn': 43200}),
      data: {'email': 'a@b.c', 'password': 'p'},
      headers: {'Accept': 'application/json', 'content-type': 'application/json'},
    );
    final res = await api.login(email: 'a@b.c', password: 'p');
    expect(res.accessToken, 'jwt');
    expect(res.expiresIn, 43200);
  });

  test('login 401 becomes ApiException without expiring the session', () async {
    adapter.onPost('/api/auth/login', (s) => s.reply(401, ''), data: Matchers.any);
    await expectLater(
      api.login(email: 'a@b.c', password: 'bad'),
      throwsA(isA<ApiException>().having((e) => e.isUnauthorized, 'isUnauthorized', isTrue)),
    );
    expect(unauthorizedCalls, 0);
  });

  test('me parses roles and reports 401 to the auth state', () async {
    token = 'jwt';
    adapter.onGet(
      '/api/auth/me',
      (s) => s.reply(200, {
        'id': 7,
        'email': 'rep@test.ua',
        'firstName': 'Іван',
        'lastName': 'Представник',
        'roles': ['REPRESENTATIVE', 'DRIVER'],
        'companyId': 1,
        'active': true,
      }),
      headers: {'Authorization': 'Bearer jwt', 'Accept': 'application/json'},
    );
    final me = await api.me();
    expect(me.roles, [Role.REPRESENTATIVE, Role.DRIVER]);
    expect(me.displayName, 'Іван Представник');
    expect(me.canUseMobile, isTrue);

    adapter.onGet('/api/auth/me', (s) => s.reply(401, ''));
    await expectLater(api.me(), throwsA(isA<ApiException>()));
    expect(unauthorizedCalls, 1);
  });

  test('manager cannot use mobile', () {
    const u = User(id: 1, email: 'm@test.ua', roles: [Role.MANAGER]);
    expect(u.canUseMobile, isFalse);
    expect(u.displayName, 'm@test.ua');
  });
}

# TrackBox24 Mobile

Робочий застосунок **представника** й **водія** [TrackBox24](https://trackbox24.com): сканування посилок (отримання з Нової Пошти, завантаження в машину, видача клієнту, на склад), рейси, офлайн-черга сканів. Менеджери й адміністратори працюють у вебі (`trackbox24_web`); їм застосунок показує сторінку «користуйтесь веб-версією».

**Стек:** Flutter 3.47 / Dart 3.13, Riverpod 3, go_router, dio, flutter_secure_storage, drift (офлайн-черга), mobile_scanner, freezed + json_serializable, ARB-локалізація (лише `uk`).

## Запуск

Потрібен запущений бекенд (`trackbox24_back`, `docker compose up -d`) на `:8080`.

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # freezed / json / drift / riverpod
flutter gen-l10n                                            # також запускається автоматично при build/run

# iOS-симулятор: localhost працює напряму
flutter run --dart-define=FLAVOR=dev --dart-define=API_BASE_URL=http://localhost:8080

# Android-емулятор: хост доступний як 10.0.2.2
flutter run --dart-define=FLAVOR=dev --dart-define=API_BASE_URL=http://10.0.2.2:8080

# фізичний пристрій у тій самій Wi-Fi-мережі
flutter run --dart-define=FLAVOR=dev --dart-define=API_BASE_URL=http://192.168.x.x:8080
```

`FLAVOR` = `dev` | `prod` (за замовчуванням `dev`). У `dev` дозволено `http://` (Android `debug/res/xml/network_security_config.xml`, iOS `NSAllowsLocalNetworking`), у налаштуваннях видно адресу сервера. Prod без `API_BASE_URL` використовує `https://api.trackbox24.com`. У `dev` на екрані «Ще» можна тимчасово перевизначити адресу сервера (зберігається в Keychain/Keystore) та очистити чергу сканів.

Ідентифікатори застосунку: Android `ua.trackbox24.app`, iOS `ua.trackbox24.app`; назва «TrackBox24».

Тестові облікові записи з локального сіду вебу: `rep@test.ua` / `rep12345` (REPRESENTATIVE); водія створює менеджер у вебі.

## Перевірка

```bash
flutter analyze        # very_good_analysis
flutter test           # unit-тести: парсер problem+json, коди сканування, auth/scan/trip API (http_mock_adapter), офлайн-черга (in-memory SQLite)

dart run flutter_launcher_icons        # перегенерувати іконки з assets/icon/
dart run flutter_native_splash:create  # перегенерувати splash
```

Ручний наскрізний сценарій (представник → водій → офлайн-черга → веб): [docs/e2e.md](docs/e2e.md).

## Структура

```
lib/
  main.dart, bootstrap.dart         точка входу; AppConfig з --dart-define
  app/                              MaterialApp.router, go_router (редіректи за auth/роллю), тема
  core/
    api/        dio-клієнт, AuthInterceptor (Bearer, 401 → вихід), problem.dart (RFC 7807 → ApiException), Page
    config/     AppConfig (flavor, apiBaseUrl)
    storage/    SecureStore (Keychain/Keystore: токен + термін дії, override base URL)
    l10n/       app_uk.arb → generated/
    ui/         describeError та спільні віджети
    util/       scan_code.dart — нормалізація й класифікація кодів (ТТН / PT… / PT…-N)
  features/
    auth/       login, me, AuthNotifier (restore → Authenticated | Unauthenticated(expired))
    shell/      RoleShell (нижня навігація за ролями), WebOnlyScreen, заглушки
    settings/   користувач, ролі, сервер, вихід
    scan/       сканер (mobile_scanner), режими за роллю, ScanService, offline-черга (drift) + воркер, екран «Черга»
    parcels/    списки представника, картка, форми, ParcelListNotifier (пагінація)
    clients/    пошук/вибір/створення клієнта
    trips/      рейси водія, картка (план/факт), виїзд, завершення з обробкою 409
    warehouses/ склади (вибір, масове переміщення)
test/
```

## Офлайн-черга

Скани `receive` / `load` / `deliver` / `toWarehouse`, які не вдалося відправити через відсутність зв'язку (connection error / timeout), зберігаються в SQLite (`scan_queue_items`, drift) і відтворюються воркером **строго в порядку сканування**: при появі мережі (`connectivity_plus`), при поверненні застосунку на передній план, після успішного онлайн-скану або кнопкою «Синхронізувати». Транспортна помилка повертає запис у чергу і зупиняє прогін (щоб не обігнати `load` → `deliver` одного місця), далі backoff 2с·2ⁿ ≤ 60с. Відповідь 4xx позначає запис `failed` із `detail` бекенду і каскадно «валить» наступні скани того ж коду; `failed` можна повторити або видалити на екрані «Черга». 401 зупиняє прогін до нового логіну. Пошук (`lookup`) ніколи не ставиться в чергу; дубль (той самий режим + код) відхиляється. Посилки з очікуваним сканом помічаються «скан у черзі» в списках.

## Нюанси бекенду

- JWT без refresh (TTL 12 год); токен відкликається при зміні пароля/ролей/деактивації → будь-який 401 = вихід на логін з позначкою «сесія завершилась». Термін дії зберігається поруч із токеном, протермінований не використовується.
- Помилки — RFC 7807 (`title`, `detail`, `errors{field}`, додаткові поля як `extensions`, напр. `undeliveredParcels` на 409); 401/403 від Spring Security — з порожнім тілом.
- `null`-поля у відповідях пропускаються — усі поля моделей опціональні, крім `id`/`email`.
- Чистий DRIVER не має доступу до `GET /api/parcels` — посилки лише через скан-пошук і списки рейсу.

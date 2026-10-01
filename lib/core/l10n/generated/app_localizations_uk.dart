// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appName => 'TrackBox24';

  @override
  String get auth_email => 'Email';

  @override
  String get auth_password => 'Пароль';

  @override
  String get auth_login => 'Увійти';

  @override
  String get auth_logout => 'Вийти';

  @override
  String get auth_sessionExpired => 'Сесія завершилась, увійдіть знову';

  @override
  String get auth_invalidCredentials => 'Невірний email або пароль';

  @override
  String get auth_emailRequired => 'Вкажіть email';

  @override
  String get auth_passwordRequired => 'Вкажіть пароль';

  @override
  String get webOnly_title => 'Ваші ролі працюють у веб-кабінеті';

  @override
  String get webOnly_body =>
      'Мобільний застосунок призначений для представників і водіїв. Менеджери та адміністратори працюють у веб-версії TrackBox24.';

  @override
  String get role_REPRESENTATIVE => 'Представник';

  @override
  String get role_DRIVER => 'Водій';

  @override
  String get role_MANAGER => 'Менеджер';

  @override
  String get role_ADMIN => 'Адміністратор';

  @override
  String get role_VIEWER => 'Перегляд';

  @override
  String get nav_toReceive => 'Забрати';

  @override
  String get screen_toReceive => 'До отримання';

  @override
  String get nav_received => 'Отримані';

  @override
  String get nav_trips => 'Рейси';

  @override
  String get nav_queue => 'Черга';

  @override
  String get nav_more => 'Ще';

  @override
  String get common_retry => 'Повторити';

  @override
  String get common_cancel => 'Скасувати';

  @override
  String get common_save => 'Зберегти';

  @override
  String get common_ok => 'Добре';

  @override
  String get common_loading => 'Завантаження…';

  @override
  String get common_empty => 'Нічого немає';

  @override
  String get common_comingSoon => 'Цей розділ ще в розробці';

  @override
  String get error_network => 'Немає зв\'язку із сервером';

  @override
  String get error_timeout => 'Сервер не відповідає';

  @override
  String get error_unauthorized => 'Потрібно увійти знову';

  @override
  String get error_forbidden => 'Недостатньо прав';

  @override
  String get error_notFound => 'Не знайдено';

  @override
  String get error_conflict => 'Конфлікт даних';

  @override
  String get error_server => 'Помилка сервера';

  @override
  String get error_unknown => 'Щось пішло не так';

  @override
  String get error_validation => 'Перевірте введені дані';

  @override
  String get settings_title => 'Налаштування';

  @override
  String get settings_user => 'Користувач';

  @override
  String get settings_roles => 'Ролі';

  @override
  String get settings_version => 'Версія';

  @override
  String get settings_server => 'Сервер';

  @override
  String get scan_title => 'Сканування';

  @override
  String get scan_manual => 'Ввести код';

  @override
  String get scan_enterTtn => 'ТТН Нової Пошти (14 цифр)';

  @override
  String get scan_enterCode => 'ТТН або штрих-код PT…';

  @override
  String get scan_mode_lookup => 'Пошук';

  @override
  String get scan_mode_receive => 'Отримати';

  @override
  String get scan_mode_load => 'Завантажити';

  @override
  String get scan_mode_deliver => 'Видати';

  @override
  String get scan_mode_toWarehouse => 'На склад';

  @override
  String get scan_found => 'Знайдено';

  @override
  String get scan_received => 'Отримано';

  @override
  String get scan_createdNew => 'Створено нову посилку та отримано';

  @override
  String get scan_loaded => 'Завантажено в машину';

  @override
  String get scan_delivered => 'Видано клієнту';

  @override
  String get scan_movedToWarehouse => 'Переміщено на склад';

  @override
  String get scan_open => 'Відкрити';

  @override
  String get scan_reject_notTtn =>
      'Для отримання скануйте ТТН Нової Пошти (14 цифр)';

  @override
  String get scan_reject_unknownCode =>
      'Не схоже на ТТН або штрих-код TrackBox24';

  @override
  String get scan_reject_tripRequired => 'Спочатку оберіть рейс';

  @override
  String get scan_reject_warehouseRequired => 'Спочатку оберіть склад';

  @override
  String get scan_tripNotSelected => 'Рейс не обрано';

  @override
  String get scan_tripHint => 'Відкрийте рейс і натисніть «Завантажити»';

  @override
  String scan_tripSelected(int id) {
    return 'Рейс #$id';
  }

  @override
  String get scan_paymentReceived => 'Отримав оплату від клієнта';

  @override
  String get scan_warehouse => 'Склад';

  @override
  String get parcel_sender => 'Відправник';

  @override
  String get parcel_client => 'Клієнт';

  @override
  String get parcel_needsEnrichment => 'потребує уточнення';

  @override
  String get parcel_oneSeat => '1 місце';

  @override
  String parcel_seatsProgress(int total, int loaded, int delivered) {
    return 'Місць: $total · у машині/видано: $loaded · видано: $delivered';
  }

  @override
  String get parcelStatus_IN_NOVA_POSHTA => 'У Новій Пошті';

  @override
  String get parcelStatus_RECEIVED_BY_REPRESENTATIVE =>
      'Отримано представником';

  @override
  String get parcelStatus_AT_WAREHOUSE => 'На складі';

  @override
  String get parcelStatus_IN_CAR => 'У машині';

  @override
  String get parcelStatus_DELIVERED_TO_CLIENT => 'Видано клієнту';

  @override
  String get parcelStatus_CANCELLED => 'Скасовано';

  @override
  String get nav_scan => 'Сканувати';
}

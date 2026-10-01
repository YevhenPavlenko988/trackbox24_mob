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
  String get nav_scan => 'Сканувати';

  @override
  String get nav_received => 'Отримані';

  @override
  String get nav_trips => 'Рейси';

  @override
  String get nav_load => 'Завантажити';

  @override
  String get nav_deliver => 'Видати';

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
}

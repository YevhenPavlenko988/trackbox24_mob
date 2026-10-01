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

  @override
  String get common_edit => 'Редагувати';

  @override
  String get common_create => 'Створити';

  @override
  String get common_required => 'Обов\'язкове поле';

  @override
  String get common_createdAt => 'Створено';

  @override
  String get parcels_searchHint => 'Штрих-код, ТТН, відправник або телефон';

  @override
  String parcels_total(int count) {
    return 'Всього: $count';
  }

  @override
  String get parcels_toReceiveEmpty => 'Немає посилок у Новій Пошті';

  @override
  String get parcels_receivedEmpty => 'Ви ще нічого не отримали';

  @override
  String get parcel_title => 'Посилка';

  @override
  String get parcel_createTitle => 'Нова посилка';

  @override
  String get parcel_editTitle => 'Редагування посилки';

  @override
  String parcel_seatsShort(int count) {
    return '$count м.';
  }

  @override
  String get parcel_paidStorageFrom => 'Платне зберігання з';

  @override
  String get parcel_statusChanged => 'Статус змінено';

  @override
  String get parcel_seats => 'Місця';

  @override
  String parcel_seatsPending(int count) {
    return 'Місця ($count) з\'являться після отримання';
  }

  @override
  String parcel_seatN(int n) {
    return 'місце $n';
  }

  @override
  String get parcel_details => 'Дані посилки';

  @override
  String get parcel_clientPhone => 'Телефон клієнта';

  @override
  String get parcel_clientCity => 'Місто клієнта';

  @override
  String get parcel_clientAddress => 'Адреса клієнта';

  @override
  String get parcel_clientNotSet => 'Не вказано — натисніть, щоб обрати';

  @override
  String get parcel_representative => 'Представник';

  @override
  String get parcel_description => 'Опис вмісту';

  @override
  String get parcel_seatsAmount => 'Кількість місць';

  @override
  String get parcel_seatsLocked =>
      'Кількість місць не можна змінити після завантаження';

  @override
  String get parcel_weightKg => 'Вага, кг';

  @override
  String get parcel_declaredValue => 'Оголошена вартість, грн';

  @override
  String get parcel_senderName => 'ПІБ відправника';

  @override
  String get parcel_senderPhone => 'Телефон відправника';

  @override
  String get parcel_senderCity => 'Місто відправника';

  @override
  String get parcel_notes => 'Примітки';

  @override
  String get parcel_deliveryPrice => 'Ціна доставки';

  @override
  String get parcel_paymentStatus => 'Оплата';

  @override
  String get parcel_paid => 'Оплачено';

  @override
  String get parcel_unpaid => 'Не оплачено';

  @override
  String get parcel_plannedTrip => 'У плані рейсу';

  @override
  String get parcel_trip => 'Рейс';

  @override
  String get parcel_novaPoshta => 'Нова Пошта';

  @override
  String get parcel_npRefresh => 'Оновити';

  @override
  String get parcel_npRefreshed => 'Дані з Нової Пошти оновлено';

  @override
  String get parcel_npTtn => 'ТТН';

  @override
  String get parcel_npStatus => 'Статус НП';

  @override
  String get parcel_npStatusUpdatedAt => 'Статус НП оновлено';

  @override
  String get parcel_npRecipientWarehouse => 'Відділення';

  @override
  String get parcel_npScheduledDeliveryAt => 'Планова доставка';

  @override
  String get parcel_npArrivedAt => 'Прибула у відділення';

  @override
  String get parcel_npDeliveryCost => 'Вартість доставки НП';

  @override
  String get parcel_npCodAmount => 'Накладений платіж';

  @override
  String get parcel_history => 'Історія';

  @override
  String get parcel_historyEmpty => 'Історія порожня';

  @override
  String get parcel_byTtn => 'За ТТН';

  @override
  String get parcel_manual => 'Без ТТН';

  @override
  String get parcel_byTtnHint =>
      'Дані підтягнуться з Нової Пошти, якщо налаштовано ключ';

  @override
  String get parcel_manualHint => 'Посилка одразу вважається отриманою вами';

  @override
  String get parcel_ttnInvalid => 'ТТН — це 14 цифр';

  @override
  String get parcel_alreadyReceived => 'Уже отримана мною';

  @override
  String get parcel_min1 => 'Не менше 1';

  @override
  String get parcel_numberInvalid => 'Введіть число';

  @override
  String get parcel_needsEnrichmentLong => 'Потребує уточнення даних';

  @override
  String get client_title => 'Клієнт';

  @override
  String get client_pickTitle => 'Обрати клієнта';

  @override
  String get client_createTitle => 'Новий клієнт';

  @override
  String get client_searchHint => 'Прізвище, організація або телефон';

  @override
  String get client_none => 'Клієнтів не знайдено';

  @override
  String get client_type => 'Тип';

  @override
  String get client_privatePerson => 'Фізособа';

  @override
  String get client_organization => 'Організація';

  @override
  String get client_organizationName => 'Назва організації';

  @override
  String get client_lastName => 'Прізвище';

  @override
  String get client_firstName => 'Ім\'я';

  @override
  String get client_middleName => 'По батькові';

  @override
  String get client_phone => 'Телефон';

  @override
  String get client_phoneInvalid => 'Формат: 380XXXXXXXXX';

  @override
  String get client_email => 'Email';

  @override
  String get client_city => 'Місто';

  @override
  String get client_address => 'Адреса';

  @override
  String get client_notes => 'Примітки';
}

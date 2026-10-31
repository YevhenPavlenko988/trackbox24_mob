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
  String get auth_remember => 'Запам\'ятати мене';

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
  String get screen_toReceive => 'Нова Пошта';

  @override
  String get nav_received => 'Отримані';

  @override
  String get nav_trips => 'Рейси';

  @override
  String get nav_accepted => 'Прийняті';

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
  String get common_search => 'Пошук';

  @override
  String get common_notSet => 'Не вказано';

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
  String get scan_cameraRetry => 'Перезапустити камеру';

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
  String get scan_tripHint => 'Натисніть, щоб обрати рейс';

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
  String get parcelStatus_PICKED_UP_FROM_NOVA_POSHTA => 'У нас';

  @override
  String get parcelStatus_RECEIVED_BY_REPRESENTATIVE =>
      'Отримано представником';

  @override
  String get parcelStatus_ACCEPTED_BY_DRIVER => 'Прийнято водієм';

  @override
  String get parcelStatus_AT_WAREHOUSE => 'На складі';

  @override
  String get parcelStatus_IN_CAR => 'У машині';

  @override
  String get parcelStatus_SENT_VIA_NOVA_POSHTA => 'Відправлено Новою Поштою';

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
  String get parcels_searchHint =>
      'Штрих-код, ТТН, наша ЕН, відправник або телефон';

  @override
  String parcels_total(int count) {
    return 'Всього: $count';
  }

  @override
  String parcels_filteredTotal(int shown, int loaded) {
    return 'Показано $shown з $loaded завантажених';
  }

  @override
  String get npFilter_all => 'Усі';

  @override
  String get npFilter_arrived => 'У відділенні';

  @override
  String get npFilter_transit => 'В дорозі';

  @override
  String get parcels_toReceiveEmpty => 'Немає посилок у Новій Пошті';

  @override
  String get parcels_receivedEmpty => 'Ви ще нічого не отримали';

  @override
  String get parcels_acceptedEmpty => 'Прийнятих посилок ще немає';

  @override
  String get acceptedFilter_mine => 'Мої';

  @override
  String get acceptedFilter_all => 'Усі';

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
  String get parcel_seatsUnknown =>
      'Кількість місць невідома (НП ще не повернула трекінг), уточніть при отриманні';

  @override
  String get np_noTracking => 'Дані НП ще не отримані';

  @override
  String get np_noTrackingHint =>
      'Нова Пошта ще не повернула трекінг за цією ЕН: немає ваги, кількості місць, відділення й статусу. Натисніть «Оновити».';

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
  String get client_phoneInvalid =>
      'З кодом країни, лише цифри (8–15), напр. 380671234567';

  @override
  String get channel_label => 'Джерело';

  @override
  String get channel_details => 'Уточнення джерела';

  @override
  String get channel_detailsHint => 'Нік, посилання, назва групи чи чату';

  @override
  String get channel_none => 'Не вказано';

  @override
  String get channel_fromClient => 'Підставлено з клієнта, можна змінити';

  @override
  String get channel_WEBSITE => 'Сайт';

  @override
  String get channel_PHONE_CALL => 'Дзвінок';

  @override
  String get channel_REFERRAL => 'Рекомендація';

  @override
  String get channel_OTHER => 'Інше';

  @override
  String get client_email => 'Email';

  @override
  String get client_city => 'Місто';

  @override
  String get client_address => 'Адреса';

  @override
  String get client_notes => 'Примітки';

  @override
  String get client_money => 'Гроші за доставку';

  @override
  String get client_moneyEarned => 'Зароблено за весь час';

  @override
  String get client_moneyEarnedHint => 'Оплачені доставки цього клієнта';

  @override
  String get client_moneyDebt => 'Борг';

  @override
  String get client_moneyUpcoming => 'До оплати при видачі';

  @override
  String get trips_current => 'Поточні';

  @override
  String get trips_planned => 'Заплановані';

  @override
  String get trips_finished => 'Завершені';

  @override
  String get trips_empty => 'Рейсів немає';

  @override
  String get trips_pickTitle => 'Оберіть рейс';

  @override
  String get trip_addParcel => 'Додати в рейс';

  @override
  String get trip_addParcelHint =>
      'Посилку буде завантажено в машину обраного рейсу. У рейс, що вже виїхав, додати не можна — створіть новий.';

  @override
  String get trip_addParcelNew => 'Новий рейс';

  @override
  String get trip_addParcelNoTrips => 'Відкритих рейсів немає';

  @override
  String trip_parcelAdded(int number) {
    return 'Завантажено в рейс №$number';
  }

  @override
  String trip_one(int number) {
    return 'Рейс №$number';
  }

  @override
  String get trip_untitled => 'Рейс';

  @override
  String get trip_createTitle => 'Новий рейс';

  @override
  String get trip_createHint =>
      'Рейс створюється на вас і вашу машину за замовчуванням. Посилки потрапляють у рейс сканами завантаження.';

  @override
  String get trip_car => 'Машина';

  @override
  String get trip_driver => 'Водій';

  @override
  String get trip_coDriver => 'Другий водій';

  @override
  String get trip_plannedDepartureAt => 'Плановий виїзд';

  @override
  String get trip_plannedArrivalAt => 'Планове прибуття';

  @override
  String get trip_departedAt => 'Виїхав';

  @override
  String get trip_arrivedAt => 'Прибув';

  @override
  String get trip_origin => 'Звідки';

  @override
  String get trip_destination => 'Куди';

  @override
  String get trip_notes => 'Примітки';

  @override
  String get trip_startOdometerKm => 'Одометр на старті, км';

  @override
  String get trip_endOdometerKm => 'Одометр на фініші, км';

  @override
  String get trip_depart => 'Виїхав';

  @override
  String get trip_departTitle => 'Виїзд';

  @override
  String get trip_departDescription =>
      'Заплановані, але не завантажені посилки буде знято з плану.';

  @override
  String get trip_departHint =>
      'Щоб виїхати, менеджер має призначити машину та водія';

  @override
  String get trip_complete => 'Завершити';

  @override
  String get trip_completeTitle => 'Завершити рейс';

  @override
  String get trip_undelivered =>
      'У машині ще є посилки — оберіть склад, куди їх перемістити';

  @override
  String get trip_moveAndComplete => 'На склад і завершити';

  @override
  String get trip_endOdometerLess => 'Менше за стартовий одометр';

  @override
  String get trip_plan => 'План';

  @override
  String get trip_planHint =>
      'Заплановано менеджером, ще не завантажено. При виїзді знімається з плану.';

  @override
  String get trip_noPlan => 'План порожній';

  @override
  String get trip_loaded => 'У машині / видано';

  @override
  String trip_loadedProgress(int loaded, int total, int delivered) {
    return 'Завантажено місць: $loaded з $total · видано: $delivered';
  }

  @override
  String get trip_noLoaded => 'Ще нічого не завантажено';

  @override
  String get trip_noLoadedClosed => 'У цьому рейсі посилок немає';

  @override
  String get trip_outsidePlan => 'поза планом';

  @override
  String get trip_history => 'Історія рейсу';

  @override
  String get trip_historyEmpty => 'Історія порожня';

  @override
  String get tripStatus_PLANNED => 'Запланований';

  @override
  String get tripStatus_PREPARING => 'Завантаження';

  @override
  String get tripStatus_IN_PROGRESS => 'У дорозі';

  @override
  String get tripStatus_COMPLETED => 'Завершений';

  @override
  String get tripStatus_CANCELLED => 'Скасований';

  @override
  String get tripEvent_CREATED => 'Рейс створено';

  @override
  String get tripEvent_UPDATED => 'План змінено';

  @override
  String get tripEvent_STATUS_CHANGED => 'Статус змінено';

  @override
  String get tripEvent_PARCEL_PLANNED => 'Заплановано посилку';

  @override
  String get tripEvent_PARCEL_UNPLANNED => 'Прибрано з плану';

  @override
  String get tripEvent_PARCEL_LOADED => 'Завантажено';

  @override
  String get tripEvent_PARCEL_DELIVERED => 'Видано';

  @override
  String get tripEvent_PARCEL_UNLOADED => 'Вивантажено';

  @override
  String get scan_tripChange => 'Натисніть, щоб змінити рейс';

  @override
  String get scan_queued =>
      'Немає зв\'язку — скан у черзі, відправиться автоматично';

  @override
  String get scan_reject_alreadyQueued => 'Такий скан уже чекає в черзі';

  @override
  String get parcel_queued => 'скан у черзі';

  @override
  String get queue_sync => 'Синхронізувати';

  @override
  String queue_syncDone(int sent, int failed) {
    return 'Відправлено: $sent, помилок: $failed';
  }

  @override
  String get queue_syncOffline => 'Сервер недоступний — спробуємо пізніше';

  @override
  String get queue_empty => 'Черга порожня — усі скани відправлено';

  @override
  String get queue_pending => 'чекає';

  @override
  String get queue_sending => 'відправляється';

  @override
  String get queue_sent => 'відправлено';

  @override
  String get queue_failed => 'помилка';

  @override
  String queue_attempts(int count) {
    return 'Спроб: $count';
  }

  @override
  String get settings_serverHint =>
      'Порожнє поле — адреса зі збірки. Після зміни потрібно увійти знову.';

  @override
  String get settings_serverReset => 'Скинути';

  @override
  String get settings_clearQueue => 'Очистити чергу сканів';

  @override
  String get settings_clearQueueDone => 'Чергу очищено';

  @override
  String trip_counters(int planned, int loaded, int delivered) {
    return 'План: $planned · у машині/видано: $loaded · видано: $delivered';
  }

  @override
  String get tripEvent_DELETED => 'Рейс видалено';

  @override
  String get tripEvent_RESTORED => 'Рейс відновлено';

  @override
  String get parcel_npVolumeWeight => 'Об\'ємна вага НП';

  @override
  String get parcel_dimensions => 'Габарити, см';

  @override
  String get parcel_deliveryCity => 'Місто доставки';

  @override
  String get npState_CREATED => 'Створена, ще не в НП';

  @override
  String get npState_IN_TRANSIT => 'В дорозі';

  @override
  String get npState_ARRIVED => 'У відділенні';

  @override
  String get npState_RECEIVED => 'Забрали з НП';

  @override
  String get npState_REDIRECTED => 'Змінено адресу';

  @override
  String get npState_RETURNING => 'Відмова / повернення';

  @override
  String get npState_DELIVERY_FAILED => 'Невдала доставка';

  @override
  String get npState_NOT_FOUND => 'Видалена / не знайдена';

  @override
  String get npState_OTHER => 'Статус НП';

  @override
  String get np_pickedUpNotScanned => 'Забрана з НП, не відскановано';

  @override
  String get np_toPay => 'До сплати на пошті';

  @override
  String get np_unknown => 'невідомо';

  @override
  String get np_amountToPayTitle => 'До сплати на пошті';

  @override
  String get np_delivery => 'Доставка';

  @override
  String np_deliveryRecipient(String method) {
    return 'Доставка (платить отримувач, $method)';
  }

  @override
  String get np_method_Cash => 'готівка';

  @override
  String get np_method_NonCash => 'безготівково';

  @override
  String get np_paidBySender => 'оплачено відправником';

  @override
  String get np_recipientPays => 'платить отримувач';

  @override
  String get np_paidByThirdPerson => 'платить третя сторона';

  @override
  String get np_previousDelivery => 'Доставка за попередньою ТТН';

  @override
  String get np_total => 'Разом';

  @override
  String get np_previousTtn => 'Переадресовано з ЕН';

  @override
  String get np_payerType => 'Платник доставки НП';

  @override
  String get np_paymentMethod => 'Спосіб оплати НП';

  @override
  String get np_payer_Sender => 'відправник';

  @override
  String get np_payer_Recipient => 'отримувач';

  @override
  String get np_payer_ThirdPerson => 'третя сторона';

  @override
  String get np_copied => 'Скопійовано';

  @override
  String get np_gone => 'Посилку об\'єднано з іншою або видалено';

  @override
  String get scanAction_receive => 'Забрати з Нової Пошти';

  @override
  String get scanAction_load => 'Завантажити в машину';

  @override
  String get scanAction_deliver => 'Видати клієнту';

  @override
  String get scanAction_toWarehouse => 'Перемістити на склад';

  @override
  String get scanAction_none => 'Для цієї посилки немає доступних дій';

  @override
  String get scanAction_offline =>
      'Немає зв’язку: статус невідомий. Оберіть дію — вона піде в чергу.';

  @override
  String get scanAction_chooseTrip => 'Оберіть рейс';

  @override
  String get scanAction_chooseWarehouse => 'Оберіть склад';

  @override
  String get scanAction_pickAgain => 'Сканувати далі';

  @override
  String get scan_hint => 'Наведіть камеру на штрих-код або ТТН';

  @override
  String get npFilter_withUs => 'У нас';

  @override
  String get npFilter_problem => 'Проблемні';

  @override
  String get receiveWithoutScan_action => 'Підтвердити отримання';

  @override
  String get receiveWithoutScan_title => 'Підтвердити отримання?';

  @override
  String receiveWithoutScan_body(String code) {
    return 'Нова Пошта вже видала посилку $code. Вона отримає наш штрих-код і статус «Отримано представником», без сканування.';
  }

  @override
  String get receiveWithoutScan_confirm => 'Підтвердити';

  @override
  String receiveWithoutScan_done(String code) {
    return 'Отримано: $code';
  }

  @override
  String get scanAction_confirmReceipt => 'Підтвердити отримання';

  @override
  String get scanAction_notFound => 'Посилку не знайдено.';

  @override
  String get scanAction_notFoundReceive =>
      'Можна забрати з Нової Пошти — посилку буде створено.';

  @override
  String get scanAction_badCode => 'Не схоже на код посилки чи ЕН Нової Пошти.';

  @override
  String get scanAction_createTitle => 'Створити посилку?';

  @override
  String scanAction_createBody(String code) {
    return 'Посилки з ЕН $code ще немає в системі. Її буде створено за даними Нової Пошти.';
  }

  @override
  String get scanAction_createConfirm => 'Створити';

  @override
  String get np_paidOnline => 'оплачено';

  @override
  String get np_settled => 'Посилку вже забрали з Нової Пошти, платити нічого';

  @override
  String get parcel_npPaymentStatus => 'Оплата доставки НП';

  @override
  String get trip_startLoading => 'Почати завантаження';

  @override
  String parcel_inTripPlan(int number) {
    return 'У плані рейсу №$number';
  }

  @override
  String parcel_inTrip(int number) {
    return 'Рейс №$number';
  }

  @override
  String get scanAction_noneDelivered => 'Посилку вже видано клієнту';

  @override
  String get scanAction_noneCancelled => 'Посилку скасовано';

  @override
  String get scanAction_noneNeedsRepresentative =>
      'Спершу посилку має отримати представник';

  @override
  String scanAction_noneRole(String status) {
    return 'Ваша роль не дозволяє діяти з посилкою в статусі «$status»';
  }

  @override
  String scanAction_trip(int id) {
    return 'рейс №$id';
  }

  @override
  String get payment_cash => 'Готівка';

  @override
  String get payment_uaCard => 'Укр. картка';

  @override
  String get payment_foreignCard => 'Закордонна картка';

  @override
  String get payment_methodUnknown => 'Спосіб не вказано';

  @override
  String get scan_paymentMethod => 'Оплата від клієнта';

  @override
  String get scan_paymentNone => 'Нічого не обрано — посилка йде без оплати';

  @override
  String get scan_paymentTaken => 'Посилка стане оплаченою';

  @override
  String get parcel_paymentMethod => 'Спосіб оплати';

  @override
  String get trip_payments => 'Гроші по рейсу';

  @override
  String get trip_paymentsReceived => 'Отримано';

  @override
  String get trip_paymentsNotReceived => 'Видано без оплати';

  @override
  String get trip_paymentsDelivered => 'Видано';

  @override
  String get trip_paymentsEmpty => 'Оплат по рейсу немає';

  @override
  String trip_paymentsParcels(int count) {
    return 'посилок: $count';
  }

  @override
  String get client_moneyDebtHint => 'Посилки видано, доставку не оплачено';

  @override
  String get client_moneyUpcomingHint => 'Ще не видані посилки';

  @override
  String get client_moneyNone => '—';

  @override
  String get np_pickCity => 'Місто Нової Пошти';

  @override
  String get np_pickBranch => 'Відділення Нової Пошти';

  @override
  String get np_pickPostomat => 'Поштомат Нової Пошти';

  @override
  String get np_pickStreet => 'Вулиця';

  @override
  String np_typeMore(int count) {
    return 'Введіть щонайменше $count символи';
  }

  @override
  String get npShipment_title => 'Відправка Новою Поштою';

  @override
  String get npShipment_hint =>
      'Куди Нова Пошта везе посилку далі. Опис, вагу, габарити й оголошену вартість бере з самої посилки. Можна заповнити не все — чого бракує, покаже створення ЕН.';

  @override
  String get npShipment_empty => 'Відправку не заповнено';

  @override
  String get npShipment_fill => 'Заповнити';

  @override
  String get npShipment_locked =>
      'ЕН уже створено: щоб змінити дані, спершу видаліть ЕН';

  @override
  String get npShipment_recipient => 'Отримувач';

  @override
  String get npShipment_lastName => 'Прізвище отримувача';

  @override
  String get npShipment_firstName => 'Ім\'я отримувача';

  @override
  String get npShipment_middleName => 'По батькові';

  @override
  String get npShipment_phone => 'Телефон отримувача';

  @override
  String get npShipment_phoneInvalid => 'Лише український номер: 380XXXXXXXXX';

  @override
  String get npShipment_deliveryType => 'Спосіб доставки';

  @override
  String get npShipment_destination => 'Куди';

  @override
  String get npShipment_city => 'Місто';

  @override
  String get npShipment_cityFirst => 'Спершу оберіть місто';

  @override
  String get npShipment_branch => 'Відділення';

  @override
  String get npShipment_postomat => 'Поштомат';

  @override
  String get npShipment_street => 'Вулиця';

  @override
  String get npShipment_building => 'Будинок';

  @override
  String get npShipment_flat => 'Квартира';

  @override
  String get npShipment_cargoType => 'Тип вантажу';

  @override
  String get npShipment_payerType => 'Хто платить НП';

  @override
  String get npShipment_paymentMethod => 'Оплата НП';

  @override
  String get npShipment_codAmount => 'Накладений платіж';

  @override
  String get npShipment_codAmountHint => 'НП збере цю суму з отримувача';

  @override
  String get npShipment_waybillNumber => 'Наша ЕН';

  @override
  String get npShipment_waybillCost => 'Вартість за розрахунком НП';

  @override
  String get npShipment_estimatedDeliveryDate => 'Орієнтовна доставка';

  @override
  String get npShipment_npStatus => 'Статус НП';

  @override
  String get npShipment_npStatusUpdatedAt => 'Статус оновлено';

  @override
  String get npShipment_typeWarehouse => 'Відділення';

  @override
  String get npShipment_typePostomat => 'Поштомат';

  @override
  String get npShipment_typeAddress => 'Адреса';

  @override
  String get npShipment_cargoParcel => 'Посилка';

  @override
  String get npShipment_cargoDocuments => 'Документи';

  @override
  String get npShipment_cargoCargo => 'Вантаж';

  @override
  String get npShipment_payerSender => 'Ми (відправник)';

  @override
  String get npShipment_payerRecipient => 'Отримувач';

  @override
  String get npShipment_payCash => 'Готівка';

  @override
  String get npShipment_payNonCash => 'Безготівкова';

  @override
  String get parcel_acceptTitle => 'Прийняти посилку';

  @override
  String get parcel_clientRequired => 'Оберіть клієнта або створіть нового';

  @override
  String get parcel_clientRequiredLabel => 'Клієнт (обов\'язково)';

  @override
  String get parcel_currency => 'Валюта';

  @override
  String get trips_acceptParcel => 'Прийняти посилку';

  @override
  String get scanAction_openParcel => 'Картка посилки';

  @override
  String get photos_title => 'Фото';

  @override
  String photos_screenTitle(String code) {
    return 'Фото $code';
  }

  @override
  String get photos_add => 'Додати фото';

  @override
  String get photos_camera => 'Зняти фото';

  @override
  String get photos_gallery => 'З галереї';

  @override
  String get photos_empty => 'Фото ще немає';

  @override
  String get photos_emptyDelivered =>
      'Фото видалено через 14 днів після видачі';

  @override
  String get photos_purgeHint =>
      'Фото буде видалено через 14 днів після видачі';

  @override
  String photos_added(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Додано фото: $count',
      one: 'Фото додано',
    );
    return '$_temp0';
  }

  @override
  String get photos_deleted => 'Фото видалено';

  @override
  String get photos_deleteTitle => 'Видалити фото?';

  @override
  String get photos_deleteBody => 'Фото зникне зі сховища назавжди.';

  @override
  String get photos_delete => 'Видалити';

  @override
  String photos_tooMany(int left, int picked) {
    return 'До посилки можна додати ще $left фото з 3, а вибрано $picked';
  }

  @override
  String photos_counter(int index, int total) {
    return '$index з $total';
  }

  @override
  String get scanAction_photos => 'Фото';

  @override
  String get password_title => 'Змінити пароль';

  @override
  String get password_subtitle => 'Інші пристрої вийдуть із системи';

  @override
  String get password_hint =>
      'Потрібен поточний пароль. Після зміни сесії на інших пристроях завершаться, а цей застосунок залишиться в системі.';

  @override
  String get password_current => 'Поточний пароль';

  @override
  String get password_new => 'Новий пароль';

  @override
  String get password_repeat => 'Новий пароль ще раз';

  @override
  String password_tooShort(int count) {
    return 'Мінімум $count символів';
  }

  @override
  String get password_mismatch => 'Паролі не збігаються';

  @override
  String get password_done => 'Пароль змінено';

  @override
  String get password_show => 'Показати пароль';

  @override
  String get password_hide => 'Сховати пароль';

  @override
  String get parcel_recipientName => 'ПІБ отримувача';

  @override
  String get parcel_recipientNameHint =>
      'Кому Нова Пошта везе далі, напр. Коваль Іван Петрович';

  @override
  String get parcel_dimensionsCm => 'Габарити, см';

  @override
  String get parcel_length => 'Довжина';

  @override
  String get parcel_width => 'Ширина';

  @override
  String get parcel_height => 'Висота';

  @override
  String npShipment_parcelNotReady(String fields) {
    return 'Нова Пошта не створить ЕН без цього в посилці: $fields';
  }

  @override
  String get npShipment_needDescription => 'опис вмісту';

  @override
  String get npShipment_needWeight => 'вага';

  @override
  String get npShipment_needDeclaredValue => 'оголошена вартість';

  @override
  String get parcel_paidNow => 'Оплачено зараз';

  @override
  String get parcel_paidNowHint =>
      'Відправник заплатив при прийомі — посилка одразу стане оплаченою';

  @override
  String get parcel_paidNowNone =>
      'Не оплачено — позначити можна при видачі або у вебі';

  @override
  String get parcel_requiredForNp => 'Потрібно для ЕН Нової Пошти';

  @override
  String get parcel_requiredForNpHint =>
      'Опис, оголошену вартість і вагу водій вказує лише при прийомі — без них Нова Пошта не створить ЕН';

  @override
  String get parcel_cargoParcelHint =>
      'Для ЕН потрібна вага. Габарити необов\'язкові; якщо є всі три — підуть у НП як об\'єм';

  @override
  String get parcel_cargoDocumentsHint =>
      'Вага необов\'язкова, до 1 кг: у НП піде 0,1 / 0,5 / 1 кг (округлення вгору). Габарити в ЕН не передаються';

  @override
  String get parcel_documentsWeightMax => 'Документи — до 1 кг';

  @override
  String get parcel_dimensionRange => 'Від 0,1 до 9999';

  @override
  String get npShipment_create => 'Створити ЕН';

  @override
  String get npShipment_saveAndCreate => 'Зберегти і створити ЕН';

  @override
  String get npShipment_created => 'ЕН створено';

  @override
  String get npShipment_delete => 'Видалити ЕН';

  @override
  String get npShipment_deleted => 'ЕН видалено';

  @override
  String get npShipment_deleteConfirmTitle => 'Видалити ЕН?';

  @override
  String get npShipment_deleteConfirmBody =>
      'ЕН видалиться в кабінеті Нової Пошти. Поки посилку не передали в НП, її можна створити заново — і передрукувати етикетку.';

  @override
  String get npShipment_shipDate => 'Дата відправки в ЕН';

  @override
  String get npShipment_waybillCreatedAt => 'ЕН створено';

  @override
  String get npShipment_acceptHint =>
      'Куди Нова Пошта везе посилку далі. Можна заповнити не все — чого бракує, покаже створення ЕН. Після ЕН надрукуйте одну етикетку 70×40 з нашим штрих-кодом і ЕН.';

  @override
  String get npShipment_reprint => 'Після створення ЕН передрукуйте етикетку';

  @override
  String label_title(int h) {
    return 'Етикетка 70×$h мм';
  }

  @override
  String get label_action => 'Етикетка';

  @override
  String get label_hint =>
      'Друкується на NIIMBOT B3S по Bluetooth (принтер обирається в «Ще → Принтер етикеток») або передається картинкою в застосунок NIIMBOT.';

  @override
  String get label_noWaybill =>
      'ЕН ще немає — на етикетці лише наш штрих-код. Після створення ЕН передрукуйте.';

  @override
  String get label_share => 'Поділитися етикеткою';

  @override
  String label_shareAll(int count) {
    return 'Поділитися всіма ($count)';
  }

  @override
  String label_seat(int n, int total) {
    return 'Місце $n з $total';
  }

  @override
  String get label_shareFailed => 'Не вдалося поділитися етикеткою';

  @override
  String get label_print => 'Надрукувати';

  @override
  String label_printAll(int count) {
    return 'Надрукувати всі ($count)';
  }

  @override
  String get label_printSetup => 'Спочатку оберіть принтер';

  @override
  String get printer_title => 'Принтер етикеток';

  @override
  String get printer_subtitleNone => 'Не обрано';

  @override
  String get printer_current => 'Поточний принтер';

  @override
  String get printer_choose => 'Обрати принтер';

  @override
  String get printer_chooseOther => 'Обрати інший';

  @override
  String get printer_scanning => 'Пошук принтерів…';

  @override
  String get printer_scanHint =>
      'Увімкніть принтер і тримайте його поруч. Закрийте застосунок NIIMBOT — він займає принтер.';

  @override
  String get printer_noneFound => 'Принтерів не знайдено';

  @override
  String get printer_showAll => 'Показати всі пристрої';

  @override
  String get printer_rescan => 'Шукати ще раз';

  @override
  String get printer_forget => 'Забути принтер';

  @override
  String get printer_saved => 'Принтер збережено';

  @override
  String get printer_density => 'Щільність друку';

  @override
  String get printer_densityHint => '1 — світліше, 5 — темніше. Стандартно 3.';

  @override
  String get printer_roll => 'Ширина рулону';

  @override
  String get printer_rollHint =>
      '40 і 50 мм — етикетка 70 мм лежить уздовж стрічки й друкується повернутою; 70 мм — упоперек.';

  @override
  String get printer_offset => 'Зсув по ширині';

  @override
  String get printer_offsetHint =>
      'Якщо друк зміщений до краю стрічки: мінус — лівіше, плюс — правіше (дивлячись на етикетку, що виходить з принтера).';

  @override
  String get printer_testPrint => 'Надрукувати пробну етикетку';

  @override
  String get printer_testLine => 'TrackBox24 · пробний друк';

  @override
  String printer_model(String model, int percent) {
    return 'Модель $model · заряд $percent%';
  }

  @override
  String printer_connecting(String name) {
    return 'Підключення до $name…';
  }

  @override
  String printer_printing(int n, int total) {
    return 'Друк $n з $total…';
  }

  @override
  String get printer_done => 'Надруковано';

  @override
  String printer_doneCount(int count) {
    return 'Надруковано етикеток: $count';
  }

  @override
  String get printer_failed => 'Не вдалося надрукувати';

  @override
  String printer_failedAfter(int printed, int total) {
    return 'Надруковано $printed з $total';
  }

  @override
  String get printer_errTimeout =>
      'Принтер не відповідає. Увімкніть його, тримайте поруч і закрийте застосунок NIIMBOT.';

  @override
  String get printer_errDisconnected => 'Зв\'язок із принтером обірвався';

  @override
  String get printer_errNotSupported =>
      'Принтер не розуміє команду — можливо, це інша модель NIIMBOT';

  @override
  String get printer_errBluetoothOff => 'Bluetooth вимкнено';

  @override
  String get printer_errBluetoothUnauthorized =>
      'Немає дозволу на Bluetooth. Дозвольте його в налаштуваннях телефону.';

  @override
  String get printer_errBluetoothUnsupported => 'Цей пристрій не має Bluetooth';

  @override
  String get printer_errCoverOpen => 'Відкрита кришка принтера';

  @override
  String get printer_errNoPaper => 'У принтері немає стрічки';

  @override
  String get printer_errLowBattery => 'Принтер розряджений';

  @override
  String get printer_errOverheat => 'Принтер перегрівся — зачекайте хвилину';

  @override
  String get printer_errCold => 'Принтер занадто холодний';

  @override
  String get printer_errBusy =>
      'Принтер зайнятий — закрийте застосунок NIIMBOT';

  @override
  String get printer_errWrongPaper =>
      'Стрічка не підходить або вставлена неправильно';

  @override
  String get printer_errPaperJam => 'Стрічка застрягла';

  @override
  String printer_errPrinter(int code) {
    return 'Помилка принтера (код $code)';
  }

  @override
  String get tracking_action => 'QR-код для відстеження';

  @override
  String get tracking_title => 'Відстеження посилки';

  @override
  String get tracking_hint =>
      'Покажіть код клієнту: він сканує його камерою телефону й бачить статус посилки без входу.';

  @override
  String get tracking_share => 'Поділитися';

  @override
  String get tracking_copy => 'Копіювати';

  @override
  String tracking_shareText(String code, String url) {
    return 'Посилка $code: $url';
  }

  @override
  String get move_badge => 'Переїзд';

  @override
  String move_seats(int count) {
    return 'Місця ($count)';
  }

  @override
  String get move_scan => 'Сканувати переїзд';

  @override
  String get move_moduleOff =>
      'Модуль «Переїзди» вимкнено — місця лише для перегляду.';

  @override
  String get move_stage_LOAD => 'Завантаження в машину';

  @override
  String get move_stage_WAREHOUSE => 'Прийом на склад';

  @override
  String get move_stage_DELIVER => 'Видача отримувачу';

  @override
  String get move_stagePick => 'Що скануємо?';

  @override
  String move_progress(int done, int total) {
    return '$done з $total';
  }

  @override
  String get move_scanHint => 'Скануйте етикетки місць у будь-якому порядку';

  @override
  String move_scanned(int n, String description) {
    return '№$n $description';
  }

  @override
  String move_already(int n) {
    return '№$n уже відскановано';
  }

  @override
  String get move_foreign => 'Це не місце цього переїзду';

  @override
  String get move_notSeat =>
      'Скануйте етикетку місця (код з номером після дефіса)';

  @override
  String move_queued(int n) {
    return '№$n збережено, надішлеться, коли з\'явиться зв\'язок';
  }

  @override
  String move_remaining(int count) {
    return 'Ще не відскановано ($count)';
  }

  @override
  String get move_finish => 'Закінчили сканування';

  @override
  String get move_summary => 'Підсумок';

  @override
  String get move_allHere => 'Усі місця на місці';

  @override
  String move_missing(int count) {
    return 'Бракує ($count):';
  }

  @override
  String get move_comment => 'Коментар';

  @override
  String get move_commentRequired => 'Видано не всі місця — вкажіть, чому';

  @override
  String get move_save => 'Записати підсумок';

  @override
  String get move_saved => 'Підсумок записано в історію';

  @override
  String get move_offlineSummary =>
      'Немає зв\'язку: показано, що відскановано на цьому телефоні. Підсумок запишіть, коли з\'явиться зв\'язок.';

  @override
  String get move_noDescription => 'Без опису';

  @override
  String move_seatPhoto(int n) {
    return 'Фото місця $n';
  }

  @override
  String get move_continue => 'Сканувати далі';

  @override
  String get move_newTitle => 'Новий переїзд';

  @override
  String get move_new => 'Новий переїзд';

  @override
  String get move_customer => 'Замовник (обов\'язково)';

  @override
  String get move_from => 'Звідки';

  @override
  String get move_to => 'Куди';

  @override
  String get move_description => 'Опис';

  @override
  String get move_descriptionHint =>
      'Необов\'язково; без нього — «Переїзд Київ → Варшава»';

  @override
  String get move_byList => 'Список речей';

  @override
  String get move_byCount => 'Лише кількість';

  @override
  String get move_items => 'Речі — кожна з нового рядка';

  @override
  String get move_itemsHint => 'Диван\nШафа — дверцята\nКоробка — посуд';

  @override
  String move_itemsWillCreate(int count) {
    return 'Буде місць: $count';
  }

  @override
  String get move_count => 'Кількість місць';

  @override
  String get move_countHint => 'Описи можна додати пізніше';

  @override
  String get move_itemsNone => 'Додайте хоча б одну річ';

  @override
  String get move_itemsTooMany => 'Щонайбільше 500 місць';

  @override
  String get move_createAndPrint => 'Створити й друкувати етикетки';

  @override
  String move_created(int count) {
    return 'Переїзд створено, місць: $count';
  }

  @override
  String get move_addItems => 'Додати речі';

  @override
  String get move_addItemsHint =>
      'Нові місця отримають наступні номери; потім надрукуйте їхні етикетки.';

  @override
  String get move_addItemsSubmit => 'Додати';

  @override
  String move_itemsAdded(int count) {
    return 'Додано місць: $count';
  }

  @override
  String get move_printNew => 'Друкувати нові етикетки';

  @override
  String get move_register => 'Реєстр';

  @override
  String get move_registerShare => 'Поділитися реєстром';

  @override
  String move_registerText(String code) {
    return 'Реєстр місць переїзду $code';
  }

  @override
  String get move_registerFailed => 'Не вдалося підготувати реєстр';

  @override
  String get move_quickAdd => 'Додати й друкувати';

  @override
  String get move_quickAddHint =>
      'Пишіть річ і друкуйте етикетку одразу; поле очиститься для наступної.';

  @override
  String move_quickAdded(int count, int number) {
    return 'Додано: $count, остання №$number';
  }

  @override
  String get move_quickAddItem => 'Що це';

  @override
  String get move_quickAddItemHint => 'Коробка — книги; можна порожнім';

  @override
  String get move_quickAddSubmit => 'Додати й друкувати';

  @override
  String get move_quickAddDone => 'Готово';

  @override
  String get new_whatTitle => 'Що приймаємо?';

  @override
  String get new_parcel => 'Посилку';

  @override
  String get new_move => 'Переїзд';

  @override
  String move_chosen(int count) {
    return 'Вибрано: $count';
  }

  @override
  String get move_toWarehouse => 'На склад';

  @override
  String get move_deliver => 'Видати';

  @override
  String get move_clearChoice => 'Зняти вибір';

  @override
  String move_manualTitleWarehouse(String name) {
    return 'На склад «$name» без сканування';
  }

  @override
  String get move_manualTitleDeliver => 'Видати без сканування';

  @override
  String move_manualHint(int count) {
    return 'Місць: $count. В історії буде видно «Без сканування» і хто перемістив.';
  }

  @override
  String move_manualLeft(int count) {
    return 'Лишиться невиданих місць: $count — поясніть чому';
  }

  @override
  String get move_manualSubmit => 'Перемістити';

  @override
  String move_manualDone(int count) {
    return 'Переміщено місць: $count';
  }
}

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
  String trip_one(int id) {
    return 'Рейс #$id';
  }

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
  String get receiveWithoutScan_action => 'Позначити отриманою';

  @override
  String get receiveWithoutScan_title => 'Позначити отриманою?';

  @override
  String receiveWithoutScan_body(String code) {
    return 'Посилка $code отримає наш штрих-код і статус «Отримано представником», без сканування.';
  }

  @override
  String get receiveWithoutScan_confirm => 'Позначити';

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
}

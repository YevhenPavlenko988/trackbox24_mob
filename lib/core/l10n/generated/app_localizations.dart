import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('uk')];

  /// No description provided for @appName.
  ///
  /// In uk, this message translates to:
  /// **'TrackBox24'**
  String get appName;

  /// No description provided for @auth_email.
  ///
  /// In uk, this message translates to:
  /// **'Email'**
  String get auth_email;

  /// No description provided for @auth_password.
  ///
  /// In uk, this message translates to:
  /// **'Пароль'**
  String get auth_password;

  /// No description provided for @auth_login.
  ///
  /// In uk, this message translates to:
  /// **'Увійти'**
  String get auth_login;

  /// No description provided for @auth_logout.
  ///
  /// In uk, this message translates to:
  /// **'Вийти'**
  String get auth_logout;

  /// No description provided for @auth_sessionExpired.
  ///
  /// In uk, this message translates to:
  /// **'Сесія завершилась, увійдіть знову'**
  String get auth_sessionExpired;

  /// No description provided for @auth_invalidCredentials.
  ///
  /// In uk, this message translates to:
  /// **'Невірний email або пароль'**
  String get auth_invalidCredentials;

  /// No description provided for @auth_emailRequired.
  ///
  /// In uk, this message translates to:
  /// **'Вкажіть email'**
  String get auth_emailRequired;

  /// No description provided for @auth_passwordRequired.
  ///
  /// In uk, this message translates to:
  /// **'Вкажіть пароль'**
  String get auth_passwordRequired;

  /// No description provided for @webOnly_title.
  ///
  /// In uk, this message translates to:
  /// **'Ваші ролі працюють у веб-кабінеті'**
  String get webOnly_title;

  /// No description provided for @webOnly_body.
  ///
  /// In uk, this message translates to:
  /// **'Мобільний застосунок призначений для представників і водіїв. Менеджери та адміністратори працюють у веб-версії TrackBox24.'**
  String get webOnly_body;

  /// No description provided for @role_REPRESENTATIVE.
  ///
  /// In uk, this message translates to:
  /// **'Представник'**
  String get role_REPRESENTATIVE;

  /// No description provided for @role_DRIVER.
  ///
  /// In uk, this message translates to:
  /// **'Водій'**
  String get role_DRIVER;

  /// No description provided for @role_MANAGER.
  ///
  /// In uk, this message translates to:
  /// **'Менеджер'**
  String get role_MANAGER;

  /// No description provided for @role_ADMIN.
  ///
  /// In uk, this message translates to:
  /// **'Адміністратор'**
  String get role_ADMIN;

  /// No description provided for @role_VIEWER.
  ///
  /// In uk, this message translates to:
  /// **'Перегляд'**
  String get role_VIEWER;

  /// No description provided for @nav_toReceive.
  ///
  /// In uk, this message translates to:
  /// **'Забрати'**
  String get nav_toReceive;

  /// No description provided for @screen_toReceive.
  ///
  /// In uk, this message translates to:
  /// **'До отримання'**
  String get screen_toReceive;

  /// No description provided for @nav_received.
  ///
  /// In uk, this message translates to:
  /// **'Отримані'**
  String get nav_received;

  /// No description provided for @nav_trips.
  ///
  /// In uk, this message translates to:
  /// **'Рейси'**
  String get nav_trips;

  /// No description provided for @nav_queue.
  ///
  /// In uk, this message translates to:
  /// **'Черга'**
  String get nav_queue;

  /// No description provided for @nav_more.
  ///
  /// In uk, this message translates to:
  /// **'Ще'**
  String get nav_more;

  /// No description provided for @common_retry.
  ///
  /// In uk, this message translates to:
  /// **'Повторити'**
  String get common_retry;

  /// No description provided for @common_cancel.
  ///
  /// In uk, this message translates to:
  /// **'Скасувати'**
  String get common_cancel;

  /// No description provided for @common_save.
  ///
  /// In uk, this message translates to:
  /// **'Зберегти'**
  String get common_save;

  /// No description provided for @common_ok.
  ///
  /// In uk, this message translates to:
  /// **'Добре'**
  String get common_ok;

  /// No description provided for @common_loading.
  ///
  /// In uk, this message translates to:
  /// **'Завантаження…'**
  String get common_loading;

  /// No description provided for @common_empty.
  ///
  /// In uk, this message translates to:
  /// **'Нічого немає'**
  String get common_empty;

  /// No description provided for @error_network.
  ///
  /// In uk, this message translates to:
  /// **'Немає зв\'язку із сервером'**
  String get error_network;

  /// No description provided for @error_timeout.
  ///
  /// In uk, this message translates to:
  /// **'Сервер не відповідає'**
  String get error_timeout;

  /// No description provided for @error_unauthorized.
  ///
  /// In uk, this message translates to:
  /// **'Потрібно увійти знову'**
  String get error_unauthorized;

  /// No description provided for @error_forbidden.
  ///
  /// In uk, this message translates to:
  /// **'Недостатньо прав'**
  String get error_forbidden;

  /// No description provided for @error_notFound.
  ///
  /// In uk, this message translates to:
  /// **'Не знайдено'**
  String get error_notFound;

  /// No description provided for @error_conflict.
  ///
  /// In uk, this message translates to:
  /// **'Конфлікт даних'**
  String get error_conflict;

  /// No description provided for @error_server.
  ///
  /// In uk, this message translates to:
  /// **'Помилка сервера'**
  String get error_server;

  /// No description provided for @error_unknown.
  ///
  /// In uk, this message translates to:
  /// **'Щось пішло не так'**
  String get error_unknown;

  /// No description provided for @error_validation.
  ///
  /// In uk, this message translates to:
  /// **'Перевірте введені дані'**
  String get error_validation;

  /// No description provided for @settings_title.
  ///
  /// In uk, this message translates to:
  /// **'Налаштування'**
  String get settings_title;

  /// No description provided for @settings_user.
  ///
  /// In uk, this message translates to:
  /// **'Користувач'**
  String get settings_user;

  /// No description provided for @settings_roles.
  ///
  /// In uk, this message translates to:
  /// **'Ролі'**
  String get settings_roles;

  /// No description provided for @settings_version.
  ///
  /// In uk, this message translates to:
  /// **'Версія'**
  String get settings_version;

  /// No description provided for @settings_server.
  ///
  /// In uk, this message translates to:
  /// **'Сервер'**
  String get settings_server;

  /// No description provided for @scan_title.
  ///
  /// In uk, this message translates to:
  /// **'Сканування'**
  String get scan_title;

  /// No description provided for @scan_cameraRetry.
  ///
  /// In uk, this message translates to:
  /// **'Перезапустити камеру'**
  String get scan_cameraRetry;

  /// No description provided for @scan_manual.
  ///
  /// In uk, this message translates to:
  /// **'Ввести код'**
  String get scan_manual;

  /// No description provided for @scan_enterTtn.
  ///
  /// In uk, this message translates to:
  /// **'ТТН Нової Пошти (14 цифр)'**
  String get scan_enterTtn;

  /// No description provided for @scan_enterCode.
  ///
  /// In uk, this message translates to:
  /// **'ТТН або штрих-код PT…'**
  String get scan_enterCode;

  /// No description provided for @scan_mode_lookup.
  ///
  /// In uk, this message translates to:
  /// **'Пошук'**
  String get scan_mode_lookup;

  /// No description provided for @scan_mode_receive.
  ///
  /// In uk, this message translates to:
  /// **'Отримати'**
  String get scan_mode_receive;

  /// No description provided for @scan_mode_load.
  ///
  /// In uk, this message translates to:
  /// **'Завантажити'**
  String get scan_mode_load;

  /// No description provided for @scan_mode_deliver.
  ///
  /// In uk, this message translates to:
  /// **'Видати'**
  String get scan_mode_deliver;

  /// No description provided for @scan_mode_toWarehouse.
  ///
  /// In uk, this message translates to:
  /// **'На склад'**
  String get scan_mode_toWarehouse;

  /// No description provided for @scan_found.
  ///
  /// In uk, this message translates to:
  /// **'Знайдено'**
  String get scan_found;

  /// No description provided for @scan_received.
  ///
  /// In uk, this message translates to:
  /// **'Отримано'**
  String get scan_received;

  /// No description provided for @scan_createdNew.
  ///
  /// In uk, this message translates to:
  /// **'Створено нову посилку та отримано'**
  String get scan_createdNew;

  /// No description provided for @scan_loaded.
  ///
  /// In uk, this message translates to:
  /// **'Завантажено в машину'**
  String get scan_loaded;

  /// No description provided for @scan_delivered.
  ///
  /// In uk, this message translates to:
  /// **'Видано клієнту'**
  String get scan_delivered;

  /// No description provided for @scan_movedToWarehouse.
  ///
  /// In uk, this message translates to:
  /// **'Переміщено на склад'**
  String get scan_movedToWarehouse;

  /// No description provided for @scan_open.
  ///
  /// In uk, this message translates to:
  /// **'Відкрити'**
  String get scan_open;

  /// No description provided for @scan_reject_notTtn.
  ///
  /// In uk, this message translates to:
  /// **'Для отримання скануйте ТТН Нової Пошти (14 цифр)'**
  String get scan_reject_notTtn;

  /// No description provided for @scan_reject_unknownCode.
  ///
  /// In uk, this message translates to:
  /// **'Не схоже на ТТН або штрих-код TrackBox24'**
  String get scan_reject_unknownCode;

  /// No description provided for @scan_reject_tripRequired.
  ///
  /// In uk, this message translates to:
  /// **'Спочатку оберіть рейс'**
  String get scan_reject_tripRequired;

  /// No description provided for @scan_reject_warehouseRequired.
  ///
  /// In uk, this message translates to:
  /// **'Спочатку оберіть склад'**
  String get scan_reject_warehouseRequired;

  /// No description provided for @scan_tripNotSelected.
  ///
  /// In uk, this message translates to:
  /// **'Рейс не обрано'**
  String get scan_tripNotSelected;

  /// No description provided for @scan_tripHint.
  ///
  /// In uk, this message translates to:
  /// **'Натисніть, щоб обрати рейс'**
  String get scan_tripHint;

  /// No description provided for @scan_tripSelected.
  ///
  /// In uk, this message translates to:
  /// **'Рейс #{id}'**
  String scan_tripSelected(int id);

  /// No description provided for @scan_paymentReceived.
  ///
  /// In uk, this message translates to:
  /// **'Отримав оплату від клієнта'**
  String get scan_paymentReceived;

  /// No description provided for @scan_warehouse.
  ///
  /// In uk, this message translates to:
  /// **'Склад'**
  String get scan_warehouse;

  /// No description provided for @parcel_sender.
  ///
  /// In uk, this message translates to:
  /// **'Відправник'**
  String get parcel_sender;

  /// No description provided for @parcel_client.
  ///
  /// In uk, this message translates to:
  /// **'Клієнт'**
  String get parcel_client;

  /// No description provided for @parcel_needsEnrichment.
  ///
  /// In uk, this message translates to:
  /// **'потребує уточнення'**
  String get parcel_needsEnrichment;

  /// No description provided for @parcel_oneSeat.
  ///
  /// In uk, this message translates to:
  /// **'1 місце'**
  String get parcel_oneSeat;

  /// No description provided for @parcel_seatsProgress.
  ///
  /// In uk, this message translates to:
  /// **'Місць: {total} · у машині/видано: {loaded} · видано: {delivered}'**
  String parcel_seatsProgress(int total, int loaded, int delivered);

  /// No description provided for @parcelStatus_IN_NOVA_POSHTA.
  ///
  /// In uk, this message translates to:
  /// **'У Новій Пошті'**
  String get parcelStatus_IN_NOVA_POSHTA;

  /// No description provided for @parcelStatus_PICKED_UP_FROM_NOVA_POSHTA.
  ///
  /// In uk, this message translates to:
  /// **'У нас'**
  String get parcelStatus_PICKED_UP_FROM_NOVA_POSHTA;

  /// No description provided for @parcelStatus_RECEIVED_BY_REPRESENTATIVE.
  ///
  /// In uk, this message translates to:
  /// **'Отримано представником'**
  String get parcelStatus_RECEIVED_BY_REPRESENTATIVE;

  /// No description provided for @parcelStatus_AT_WAREHOUSE.
  ///
  /// In uk, this message translates to:
  /// **'На складі'**
  String get parcelStatus_AT_WAREHOUSE;

  /// No description provided for @parcelStatus_IN_CAR.
  ///
  /// In uk, this message translates to:
  /// **'У машині'**
  String get parcelStatus_IN_CAR;

  /// No description provided for @parcelStatus_DELIVERED_TO_CLIENT.
  ///
  /// In uk, this message translates to:
  /// **'Видано клієнту'**
  String get parcelStatus_DELIVERED_TO_CLIENT;

  /// No description provided for @parcelStatus_CANCELLED.
  ///
  /// In uk, this message translates to:
  /// **'Скасовано'**
  String get parcelStatus_CANCELLED;

  /// No description provided for @nav_scan.
  ///
  /// In uk, this message translates to:
  /// **'Сканувати'**
  String get nav_scan;

  /// No description provided for @common_edit.
  ///
  /// In uk, this message translates to:
  /// **'Редагувати'**
  String get common_edit;

  /// No description provided for @common_create.
  ///
  /// In uk, this message translates to:
  /// **'Створити'**
  String get common_create;

  /// No description provided for @common_required.
  ///
  /// In uk, this message translates to:
  /// **'Обов\'язкове поле'**
  String get common_required;

  /// No description provided for @common_createdAt.
  ///
  /// In uk, this message translates to:
  /// **'Створено'**
  String get common_createdAt;

  /// No description provided for @parcels_searchHint.
  ///
  /// In uk, this message translates to:
  /// **'Штрих-код, ТТН, відправник або телефон'**
  String get parcels_searchHint;

  /// No description provided for @parcels_total.
  ///
  /// In uk, this message translates to:
  /// **'Всього: {count}'**
  String parcels_total(int count);

  /// No description provided for @parcels_filteredTotal.
  ///
  /// In uk, this message translates to:
  /// **'Показано {shown} з {loaded} завантажених'**
  String parcels_filteredTotal(int shown, int loaded);

  /// No description provided for @npFilter_all.
  ///
  /// In uk, this message translates to:
  /// **'Усі'**
  String get npFilter_all;

  /// No description provided for @npFilter_arrived.
  ///
  /// In uk, this message translates to:
  /// **'У відділенні'**
  String get npFilter_arrived;

  /// No description provided for @npFilter_transit.
  ///
  /// In uk, this message translates to:
  /// **'В дорозі'**
  String get npFilter_transit;

  /// No description provided for @parcels_toReceiveEmpty.
  ///
  /// In uk, this message translates to:
  /// **'Немає посилок у Новій Пошті'**
  String get parcels_toReceiveEmpty;

  /// No description provided for @parcels_receivedEmpty.
  ///
  /// In uk, this message translates to:
  /// **'Ви ще нічого не отримали'**
  String get parcels_receivedEmpty;

  /// No description provided for @parcel_title.
  ///
  /// In uk, this message translates to:
  /// **'Посилка'**
  String get parcel_title;

  /// No description provided for @parcel_createTitle.
  ///
  /// In uk, this message translates to:
  /// **'Нова посилка'**
  String get parcel_createTitle;

  /// No description provided for @parcel_editTitle.
  ///
  /// In uk, this message translates to:
  /// **'Редагування посилки'**
  String get parcel_editTitle;

  /// No description provided for @parcel_seatsShort.
  ///
  /// In uk, this message translates to:
  /// **'{count} м.'**
  String parcel_seatsShort(int count);

  /// No description provided for @parcel_paidStorageFrom.
  ///
  /// In uk, this message translates to:
  /// **'Платне зберігання з'**
  String get parcel_paidStorageFrom;

  /// No description provided for @parcel_statusChanged.
  ///
  /// In uk, this message translates to:
  /// **'Статус змінено'**
  String get parcel_statusChanged;

  /// No description provided for @parcel_seats.
  ///
  /// In uk, this message translates to:
  /// **'Місця'**
  String get parcel_seats;

  /// No description provided for @parcel_seatsPending.
  ///
  /// In uk, this message translates to:
  /// **'Місця ({count}) з\'являться після отримання'**
  String parcel_seatsPending(int count);

  /// No description provided for @parcel_seatsUnknown.
  ///
  /// In uk, this message translates to:
  /// **'Кількість місць невідома (НП ще не повернула трекінг), уточніть при отриманні'**
  String get parcel_seatsUnknown;

  /// No description provided for @np_noTracking.
  ///
  /// In uk, this message translates to:
  /// **'Дані НП ще не отримані'**
  String get np_noTracking;

  /// No description provided for @np_noTrackingHint.
  ///
  /// In uk, this message translates to:
  /// **'Нова Пошта ще не повернула трекінг за цією ЕН: немає ваги, кількості місць, відділення й статусу. Натисніть «Оновити».'**
  String get np_noTrackingHint;

  /// No description provided for @parcel_seatN.
  ///
  /// In uk, this message translates to:
  /// **'місце {n}'**
  String parcel_seatN(int n);

  /// No description provided for @parcel_details.
  ///
  /// In uk, this message translates to:
  /// **'Дані посилки'**
  String get parcel_details;

  /// No description provided for @parcel_clientPhone.
  ///
  /// In uk, this message translates to:
  /// **'Телефон клієнта'**
  String get parcel_clientPhone;

  /// No description provided for @parcel_clientCity.
  ///
  /// In uk, this message translates to:
  /// **'Місто клієнта'**
  String get parcel_clientCity;

  /// No description provided for @parcel_clientAddress.
  ///
  /// In uk, this message translates to:
  /// **'Адреса клієнта'**
  String get parcel_clientAddress;

  /// No description provided for @parcel_clientNotSet.
  ///
  /// In uk, this message translates to:
  /// **'Не вказано — натисніть, щоб обрати'**
  String get parcel_clientNotSet;

  /// No description provided for @parcel_representative.
  ///
  /// In uk, this message translates to:
  /// **'Представник'**
  String get parcel_representative;

  /// No description provided for @parcel_description.
  ///
  /// In uk, this message translates to:
  /// **'Опис вмісту'**
  String get parcel_description;

  /// No description provided for @parcel_seatsAmount.
  ///
  /// In uk, this message translates to:
  /// **'Кількість місць'**
  String get parcel_seatsAmount;

  /// No description provided for @parcel_seatsLocked.
  ///
  /// In uk, this message translates to:
  /// **'Кількість місць не можна змінити після завантаження'**
  String get parcel_seatsLocked;

  /// No description provided for @parcel_weightKg.
  ///
  /// In uk, this message translates to:
  /// **'Вага, кг'**
  String get parcel_weightKg;

  /// No description provided for @parcel_declaredValue.
  ///
  /// In uk, this message translates to:
  /// **'Оголошена вартість, грн'**
  String get parcel_declaredValue;

  /// No description provided for @parcel_senderName.
  ///
  /// In uk, this message translates to:
  /// **'ПІБ відправника'**
  String get parcel_senderName;

  /// No description provided for @parcel_senderPhone.
  ///
  /// In uk, this message translates to:
  /// **'Телефон відправника'**
  String get parcel_senderPhone;

  /// No description provided for @parcel_senderCity.
  ///
  /// In uk, this message translates to:
  /// **'Місто відправника'**
  String get parcel_senderCity;

  /// No description provided for @parcel_notes.
  ///
  /// In uk, this message translates to:
  /// **'Примітки'**
  String get parcel_notes;

  /// No description provided for @parcel_deliveryPrice.
  ///
  /// In uk, this message translates to:
  /// **'Ціна доставки'**
  String get parcel_deliveryPrice;

  /// No description provided for @parcel_paymentStatus.
  ///
  /// In uk, this message translates to:
  /// **'Оплата'**
  String get parcel_paymentStatus;

  /// No description provided for @parcel_paid.
  ///
  /// In uk, this message translates to:
  /// **'Оплачено'**
  String get parcel_paid;

  /// No description provided for @parcel_unpaid.
  ///
  /// In uk, this message translates to:
  /// **'Не оплачено'**
  String get parcel_unpaid;

  /// No description provided for @parcel_plannedTrip.
  ///
  /// In uk, this message translates to:
  /// **'У плані рейсу'**
  String get parcel_plannedTrip;

  /// No description provided for @parcel_trip.
  ///
  /// In uk, this message translates to:
  /// **'Рейс'**
  String get parcel_trip;

  /// No description provided for @parcel_novaPoshta.
  ///
  /// In uk, this message translates to:
  /// **'Нова Пошта'**
  String get parcel_novaPoshta;

  /// No description provided for @parcel_npRefresh.
  ///
  /// In uk, this message translates to:
  /// **'Оновити'**
  String get parcel_npRefresh;

  /// No description provided for @parcel_npRefreshed.
  ///
  /// In uk, this message translates to:
  /// **'Дані з Нової Пошти оновлено'**
  String get parcel_npRefreshed;

  /// No description provided for @parcel_npTtn.
  ///
  /// In uk, this message translates to:
  /// **'ТТН'**
  String get parcel_npTtn;

  /// No description provided for @parcel_npStatus.
  ///
  /// In uk, this message translates to:
  /// **'Статус НП'**
  String get parcel_npStatus;

  /// No description provided for @parcel_npStatusUpdatedAt.
  ///
  /// In uk, this message translates to:
  /// **'Статус НП оновлено'**
  String get parcel_npStatusUpdatedAt;

  /// No description provided for @parcel_npRecipientWarehouse.
  ///
  /// In uk, this message translates to:
  /// **'Відділення'**
  String get parcel_npRecipientWarehouse;

  /// No description provided for @parcel_npScheduledDeliveryAt.
  ///
  /// In uk, this message translates to:
  /// **'Планова доставка'**
  String get parcel_npScheduledDeliveryAt;

  /// No description provided for @parcel_npArrivedAt.
  ///
  /// In uk, this message translates to:
  /// **'Прибула у відділення'**
  String get parcel_npArrivedAt;

  /// No description provided for @parcel_npDeliveryCost.
  ///
  /// In uk, this message translates to:
  /// **'Вартість доставки НП'**
  String get parcel_npDeliveryCost;

  /// No description provided for @parcel_npCodAmount.
  ///
  /// In uk, this message translates to:
  /// **'Накладений платіж'**
  String get parcel_npCodAmount;

  /// No description provided for @parcel_history.
  ///
  /// In uk, this message translates to:
  /// **'Історія'**
  String get parcel_history;

  /// No description provided for @parcel_historyEmpty.
  ///
  /// In uk, this message translates to:
  /// **'Історія порожня'**
  String get parcel_historyEmpty;

  /// No description provided for @parcel_byTtn.
  ///
  /// In uk, this message translates to:
  /// **'За ТТН'**
  String get parcel_byTtn;

  /// No description provided for @parcel_manual.
  ///
  /// In uk, this message translates to:
  /// **'Без ТТН'**
  String get parcel_manual;

  /// No description provided for @parcel_byTtnHint.
  ///
  /// In uk, this message translates to:
  /// **'Дані підтягнуться з Нової Пошти, якщо налаштовано ключ'**
  String get parcel_byTtnHint;

  /// No description provided for @parcel_manualHint.
  ///
  /// In uk, this message translates to:
  /// **'Посилка одразу вважається отриманою вами'**
  String get parcel_manualHint;

  /// No description provided for @parcel_ttnInvalid.
  ///
  /// In uk, this message translates to:
  /// **'ТТН — це 14 цифр'**
  String get parcel_ttnInvalid;

  /// No description provided for @parcel_alreadyReceived.
  ///
  /// In uk, this message translates to:
  /// **'Уже отримана мною'**
  String get parcel_alreadyReceived;

  /// No description provided for @parcel_min1.
  ///
  /// In uk, this message translates to:
  /// **'Не менше 1'**
  String get parcel_min1;

  /// No description provided for @parcel_numberInvalid.
  ///
  /// In uk, this message translates to:
  /// **'Введіть число'**
  String get parcel_numberInvalid;

  /// No description provided for @parcel_needsEnrichmentLong.
  ///
  /// In uk, this message translates to:
  /// **'Потребує уточнення даних'**
  String get parcel_needsEnrichmentLong;

  /// No description provided for @client_title.
  ///
  /// In uk, this message translates to:
  /// **'Клієнт'**
  String get client_title;

  /// No description provided for @client_pickTitle.
  ///
  /// In uk, this message translates to:
  /// **'Обрати клієнта'**
  String get client_pickTitle;

  /// No description provided for @client_createTitle.
  ///
  /// In uk, this message translates to:
  /// **'Новий клієнт'**
  String get client_createTitle;

  /// No description provided for @client_searchHint.
  ///
  /// In uk, this message translates to:
  /// **'Прізвище, організація або телефон'**
  String get client_searchHint;

  /// No description provided for @client_none.
  ///
  /// In uk, this message translates to:
  /// **'Клієнтів не знайдено'**
  String get client_none;

  /// No description provided for @client_type.
  ///
  /// In uk, this message translates to:
  /// **'Тип'**
  String get client_type;

  /// No description provided for @client_privatePerson.
  ///
  /// In uk, this message translates to:
  /// **'Фізособа'**
  String get client_privatePerson;

  /// No description provided for @client_organization.
  ///
  /// In uk, this message translates to:
  /// **'Організація'**
  String get client_organization;

  /// No description provided for @client_organizationName.
  ///
  /// In uk, this message translates to:
  /// **'Назва організації'**
  String get client_organizationName;

  /// No description provided for @client_lastName.
  ///
  /// In uk, this message translates to:
  /// **'Прізвище'**
  String get client_lastName;

  /// No description provided for @client_firstName.
  ///
  /// In uk, this message translates to:
  /// **'Ім\'я'**
  String get client_firstName;

  /// No description provided for @client_middleName.
  ///
  /// In uk, this message translates to:
  /// **'По батькові'**
  String get client_middleName;

  /// No description provided for @client_phone.
  ///
  /// In uk, this message translates to:
  /// **'Телефон'**
  String get client_phone;

  /// No description provided for @client_phoneInvalid.
  ///
  /// In uk, this message translates to:
  /// **'З кодом країни, лише цифри (8–15), напр. 380671234567'**
  String get client_phoneInvalid;

  /// No description provided for @channel_label.
  ///
  /// In uk, this message translates to:
  /// **'Джерело'**
  String get channel_label;

  /// No description provided for @channel_details.
  ///
  /// In uk, this message translates to:
  /// **'Уточнення джерела'**
  String get channel_details;

  /// No description provided for @channel_detailsHint.
  ///
  /// In uk, this message translates to:
  /// **'Нік, посилання, назва групи чи чату'**
  String get channel_detailsHint;

  /// No description provided for @channel_none.
  ///
  /// In uk, this message translates to:
  /// **'Не вказано'**
  String get channel_none;

  /// No description provided for @channel_fromClient.
  ///
  /// In uk, this message translates to:
  /// **'Підставлено з клієнта, можна змінити'**
  String get channel_fromClient;

  /// No description provided for @channel_WEBSITE.
  ///
  /// In uk, this message translates to:
  /// **'Сайт'**
  String get channel_WEBSITE;

  /// No description provided for @channel_PHONE_CALL.
  ///
  /// In uk, this message translates to:
  /// **'Дзвінок'**
  String get channel_PHONE_CALL;

  /// No description provided for @channel_REFERRAL.
  ///
  /// In uk, this message translates to:
  /// **'Рекомендація'**
  String get channel_REFERRAL;

  /// No description provided for @channel_OTHER.
  ///
  /// In uk, this message translates to:
  /// **'Інше'**
  String get channel_OTHER;

  /// No description provided for @client_email.
  ///
  /// In uk, this message translates to:
  /// **'Email'**
  String get client_email;

  /// No description provided for @client_city.
  ///
  /// In uk, this message translates to:
  /// **'Місто'**
  String get client_city;

  /// No description provided for @client_address.
  ///
  /// In uk, this message translates to:
  /// **'Адреса'**
  String get client_address;

  /// No description provided for @client_notes.
  ///
  /// In uk, this message translates to:
  /// **'Примітки'**
  String get client_notes;

  /// No description provided for @trips_current.
  ///
  /// In uk, this message translates to:
  /// **'Поточні'**
  String get trips_current;

  /// No description provided for @trips_planned.
  ///
  /// In uk, this message translates to:
  /// **'Заплановані'**
  String get trips_planned;

  /// No description provided for @trips_finished.
  ///
  /// In uk, this message translates to:
  /// **'Завершені'**
  String get trips_finished;

  /// No description provided for @trips_empty.
  ///
  /// In uk, this message translates to:
  /// **'Рейсів немає'**
  String get trips_empty;

  /// No description provided for @trips_pickTitle.
  ///
  /// In uk, this message translates to:
  /// **'Оберіть рейс'**
  String get trips_pickTitle;

  /// No description provided for @trip_one.
  ///
  /// In uk, this message translates to:
  /// **'Рейс #{id}'**
  String trip_one(int id);

  /// No description provided for @trip_createTitle.
  ///
  /// In uk, this message translates to:
  /// **'Новий рейс'**
  String get trip_createTitle;

  /// No description provided for @trip_createHint.
  ///
  /// In uk, this message translates to:
  /// **'Рейс створюється на вас і вашу машину за замовчуванням. Посилки потрапляють у рейс сканами завантаження.'**
  String get trip_createHint;

  /// No description provided for @trip_car.
  ///
  /// In uk, this message translates to:
  /// **'Машина'**
  String get trip_car;

  /// No description provided for @trip_driver.
  ///
  /// In uk, this message translates to:
  /// **'Водій'**
  String get trip_driver;

  /// No description provided for @trip_plannedDepartureAt.
  ///
  /// In uk, this message translates to:
  /// **'Плановий виїзд'**
  String get trip_plannedDepartureAt;

  /// No description provided for @trip_plannedArrivalAt.
  ///
  /// In uk, this message translates to:
  /// **'Планове прибуття'**
  String get trip_plannedArrivalAt;

  /// No description provided for @trip_departedAt.
  ///
  /// In uk, this message translates to:
  /// **'Виїхав'**
  String get trip_departedAt;

  /// No description provided for @trip_arrivedAt.
  ///
  /// In uk, this message translates to:
  /// **'Прибув'**
  String get trip_arrivedAt;

  /// No description provided for @trip_origin.
  ///
  /// In uk, this message translates to:
  /// **'Звідки'**
  String get trip_origin;

  /// No description provided for @trip_destination.
  ///
  /// In uk, this message translates to:
  /// **'Куди'**
  String get trip_destination;

  /// No description provided for @trip_notes.
  ///
  /// In uk, this message translates to:
  /// **'Примітки'**
  String get trip_notes;

  /// No description provided for @trip_startOdometerKm.
  ///
  /// In uk, this message translates to:
  /// **'Одометр на старті, км'**
  String get trip_startOdometerKm;

  /// No description provided for @trip_endOdometerKm.
  ///
  /// In uk, this message translates to:
  /// **'Одометр на фініші, км'**
  String get trip_endOdometerKm;

  /// No description provided for @trip_depart.
  ///
  /// In uk, this message translates to:
  /// **'Виїхав'**
  String get trip_depart;

  /// No description provided for @trip_departTitle.
  ///
  /// In uk, this message translates to:
  /// **'Виїзд'**
  String get trip_departTitle;

  /// No description provided for @trip_departDescription.
  ///
  /// In uk, this message translates to:
  /// **'Заплановані, але не завантажені посилки буде знято з плану.'**
  String get trip_departDescription;

  /// No description provided for @trip_departHint.
  ///
  /// In uk, this message translates to:
  /// **'Щоб виїхати, менеджер має призначити машину та водія'**
  String get trip_departHint;

  /// No description provided for @trip_complete.
  ///
  /// In uk, this message translates to:
  /// **'Завершити'**
  String get trip_complete;

  /// No description provided for @trip_completeTitle.
  ///
  /// In uk, this message translates to:
  /// **'Завершити рейс'**
  String get trip_completeTitle;

  /// No description provided for @trip_undelivered.
  ///
  /// In uk, this message translates to:
  /// **'У машині ще є посилки — оберіть склад, куди їх перемістити'**
  String get trip_undelivered;

  /// No description provided for @trip_moveAndComplete.
  ///
  /// In uk, this message translates to:
  /// **'На склад і завершити'**
  String get trip_moveAndComplete;

  /// No description provided for @trip_endOdometerLess.
  ///
  /// In uk, this message translates to:
  /// **'Менше за стартовий одометр'**
  String get trip_endOdometerLess;

  /// No description provided for @trip_plan.
  ///
  /// In uk, this message translates to:
  /// **'План'**
  String get trip_plan;

  /// No description provided for @trip_planHint.
  ///
  /// In uk, this message translates to:
  /// **'Заплановано менеджером, ще не завантажено. При виїзді знімається з плану.'**
  String get trip_planHint;

  /// No description provided for @trip_noPlan.
  ///
  /// In uk, this message translates to:
  /// **'План порожній'**
  String get trip_noPlan;

  /// No description provided for @trip_loaded.
  ///
  /// In uk, this message translates to:
  /// **'У машині / видано'**
  String get trip_loaded;

  /// No description provided for @trip_loadedProgress.
  ///
  /// In uk, this message translates to:
  /// **'Завантажено місць: {loaded} з {total} · видано: {delivered}'**
  String trip_loadedProgress(int loaded, int total, int delivered);

  /// No description provided for @trip_noLoaded.
  ///
  /// In uk, this message translates to:
  /// **'Ще нічого не завантажено'**
  String get trip_noLoaded;

  /// No description provided for @trip_noLoadedClosed.
  ///
  /// In uk, this message translates to:
  /// **'У цьому рейсі посилок немає'**
  String get trip_noLoadedClosed;

  /// No description provided for @trip_outsidePlan.
  ///
  /// In uk, this message translates to:
  /// **'поза планом'**
  String get trip_outsidePlan;

  /// No description provided for @trip_history.
  ///
  /// In uk, this message translates to:
  /// **'Історія рейсу'**
  String get trip_history;

  /// No description provided for @trip_historyEmpty.
  ///
  /// In uk, this message translates to:
  /// **'Історія порожня'**
  String get trip_historyEmpty;

  /// No description provided for @tripStatus_PLANNED.
  ///
  /// In uk, this message translates to:
  /// **'Запланований'**
  String get tripStatus_PLANNED;

  /// No description provided for @tripStatus_PREPARING.
  ///
  /// In uk, this message translates to:
  /// **'Завантаження'**
  String get tripStatus_PREPARING;

  /// No description provided for @tripStatus_IN_PROGRESS.
  ///
  /// In uk, this message translates to:
  /// **'У дорозі'**
  String get tripStatus_IN_PROGRESS;

  /// No description provided for @tripStatus_COMPLETED.
  ///
  /// In uk, this message translates to:
  /// **'Завершений'**
  String get tripStatus_COMPLETED;

  /// No description provided for @tripStatus_CANCELLED.
  ///
  /// In uk, this message translates to:
  /// **'Скасований'**
  String get tripStatus_CANCELLED;

  /// No description provided for @tripEvent_CREATED.
  ///
  /// In uk, this message translates to:
  /// **'Рейс створено'**
  String get tripEvent_CREATED;

  /// No description provided for @tripEvent_UPDATED.
  ///
  /// In uk, this message translates to:
  /// **'План змінено'**
  String get tripEvent_UPDATED;

  /// No description provided for @tripEvent_STATUS_CHANGED.
  ///
  /// In uk, this message translates to:
  /// **'Статус змінено'**
  String get tripEvent_STATUS_CHANGED;

  /// No description provided for @tripEvent_PARCEL_PLANNED.
  ///
  /// In uk, this message translates to:
  /// **'Заплановано посилку'**
  String get tripEvent_PARCEL_PLANNED;

  /// No description provided for @tripEvent_PARCEL_UNPLANNED.
  ///
  /// In uk, this message translates to:
  /// **'Прибрано з плану'**
  String get tripEvent_PARCEL_UNPLANNED;

  /// No description provided for @tripEvent_PARCEL_LOADED.
  ///
  /// In uk, this message translates to:
  /// **'Завантажено'**
  String get tripEvent_PARCEL_LOADED;

  /// No description provided for @tripEvent_PARCEL_DELIVERED.
  ///
  /// In uk, this message translates to:
  /// **'Видано'**
  String get tripEvent_PARCEL_DELIVERED;

  /// No description provided for @tripEvent_PARCEL_UNLOADED.
  ///
  /// In uk, this message translates to:
  /// **'Вивантажено'**
  String get tripEvent_PARCEL_UNLOADED;

  /// No description provided for @scan_tripChange.
  ///
  /// In uk, this message translates to:
  /// **'Натисніть, щоб змінити рейс'**
  String get scan_tripChange;

  /// No description provided for @scan_queued.
  ///
  /// In uk, this message translates to:
  /// **'Немає зв\'язку — скан у черзі, відправиться автоматично'**
  String get scan_queued;

  /// No description provided for @scan_reject_alreadyQueued.
  ///
  /// In uk, this message translates to:
  /// **'Такий скан уже чекає в черзі'**
  String get scan_reject_alreadyQueued;

  /// No description provided for @parcel_queued.
  ///
  /// In uk, this message translates to:
  /// **'скан у черзі'**
  String get parcel_queued;

  /// No description provided for @queue_sync.
  ///
  /// In uk, this message translates to:
  /// **'Синхронізувати'**
  String get queue_sync;

  /// No description provided for @queue_syncDone.
  ///
  /// In uk, this message translates to:
  /// **'Відправлено: {sent}, помилок: {failed}'**
  String queue_syncDone(int sent, int failed);

  /// No description provided for @queue_syncOffline.
  ///
  /// In uk, this message translates to:
  /// **'Сервер недоступний — спробуємо пізніше'**
  String get queue_syncOffline;

  /// No description provided for @queue_empty.
  ///
  /// In uk, this message translates to:
  /// **'Черга порожня — усі скани відправлено'**
  String get queue_empty;

  /// No description provided for @queue_pending.
  ///
  /// In uk, this message translates to:
  /// **'чекає'**
  String get queue_pending;

  /// No description provided for @queue_sending.
  ///
  /// In uk, this message translates to:
  /// **'відправляється'**
  String get queue_sending;

  /// No description provided for @queue_sent.
  ///
  /// In uk, this message translates to:
  /// **'відправлено'**
  String get queue_sent;

  /// No description provided for @queue_failed.
  ///
  /// In uk, this message translates to:
  /// **'помилка'**
  String get queue_failed;

  /// No description provided for @queue_attempts.
  ///
  /// In uk, this message translates to:
  /// **'Спроб: {count}'**
  String queue_attempts(int count);

  /// No description provided for @settings_serverHint.
  ///
  /// In uk, this message translates to:
  /// **'Порожнє поле — адреса зі збірки. Після зміни потрібно увійти знову.'**
  String get settings_serverHint;

  /// No description provided for @settings_serverReset.
  ///
  /// In uk, this message translates to:
  /// **'Скинути'**
  String get settings_serverReset;

  /// No description provided for @settings_clearQueue.
  ///
  /// In uk, this message translates to:
  /// **'Очистити чергу сканів'**
  String get settings_clearQueue;

  /// No description provided for @settings_clearQueueDone.
  ///
  /// In uk, this message translates to:
  /// **'Чергу очищено'**
  String get settings_clearQueueDone;

  /// No description provided for @trip_counters.
  ///
  /// In uk, this message translates to:
  /// **'План: {planned} · у машині/видано: {loaded} · видано: {delivered}'**
  String trip_counters(int planned, int loaded, int delivered);

  /// No description provided for @tripEvent_DELETED.
  ///
  /// In uk, this message translates to:
  /// **'Рейс видалено'**
  String get tripEvent_DELETED;

  /// No description provided for @tripEvent_RESTORED.
  ///
  /// In uk, this message translates to:
  /// **'Рейс відновлено'**
  String get tripEvent_RESTORED;

  /// No description provided for @parcel_npVolumeWeight.
  ///
  /// In uk, this message translates to:
  /// **'Об\'ємна вага НП'**
  String get parcel_npVolumeWeight;

  /// No description provided for @parcel_dimensions.
  ///
  /// In uk, this message translates to:
  /// **'Габарити, см'**
  String get parcel_dimensions;

  /// No description provided for @parcel_deliveryCity.
  ///
  /// In uk, this message translates to:
  /// **'Місто доставки'**
  String get parcel_deliveryCity;

  /// No description provided for @npState_CREATED.
  ///
  /// In uk, this message translates to:
  /// **'Створена, ще не в НП'**
  String get npState_CREATED;

  /// No description provided for @npState_IN_TRANSIT.
  ///
  /// In uk, this message translates to:
  /// **'В дорозі'**
  String get npState_IN_TRANSIT;

  /// No description provided for @npState_ARRIVED.
  ///
  /// In uk, this message translates to:
  /// **'У відділенні'**
  String get npState_ARRIVED;

  /// No description provided for @npState_RECEIVED.
  ///
  /// In uk, this message translates to:
  /// **'Забрали з НП'**
  String get npState_RECEIVED;

  /// No description provided for @npState_REDIRECTED.
  ///
  /// In uk, this message translates to:
  /// **'Змінено адресу'**
  String get npState_REDIRECTED;

  /// No description provided for @npState_RETURNING.
  ///
  /// In uk, this message translates to:
  /// **'Відмова / повернення'**
  String get npState_RETURNING;

  /// No description provided for @npState_DELIVERY_FAILED.
  ///
  /// In uk, this message translates to:
  /// **'Невдала доставка'**
  String get npState_DELIVERY_FAILED;

  /// No description provided for @npState_NOT_FOUND.
  ///
  /// In uk, this message translates to:
  /// **'Видалена / не знайдена'**
  String get npState_NOT_FOUND;

  /// No description provided for @npState_OTHER.
  ///
  /// In uk, this message translates to:
  /// **'Статус НП'**
  String get npState_OTHER;

  /// No description provided for @np_pickedUpNotScanned.
  ///
  /// In uk, this message translates to:
  /// **'Забрана з НП, не відскановано'**
  String get np_pickedUpNotScanned;

  /// No description provided for @np_toPay.
  ///
  /// In uk, this message translates to:
  /// **'До сплати на пошті'**
  String get np_toPay;

  /// No description provided for @np_unknown.
  ///
  /// In uk, this message translates to:
  /// **'невідомо'**
  String get np_unknown;

  /// No description provided for @np_amountToPayTitle.
  ///
  /// In uk, this message translates to:
  /// **'До сплати на пошті'**
  String get np_amountToPayTitle;

  /// No description provided for @np_delivery.
  ///
  /// In uk, this message translates to:
  /// **'Доставка'**
  String get np_delivery;

  /// No description provided for @np_deliveryRecipient.
  ///
  /// In uk, this message translates to:
  /// **'Доставка (платить отримувач, {method})'**
  String np_deliveryRecipient(String method);

  /// No description provided for @np_method_Cash.
  ///
  /// In uk, this message translates to:
  /// **'готівка'**
  String get np_method_Cash;

  /// No description provided for @np_method_NonCash.
  ///
  /// In uk, this message translates to:
  /// **'безготівково'**
  String get np_method_NonCash;

  /// No description provided for @np_paidBySender.
  ///
  /// In uk, this message translates to:
  /// **'оплачено відправником'**
  String get np_paidBySender;

  /// No description provided for @np_recipientPays.
  ///
  /// In uk, this message translates to:
  /// **'платить отримувач'**
  String get np_recipientPays;

  /// No description provided for @np_paidByThirdPerson.
  ///
  /// In uk, this message translates to:
  /// **'платить третя сторона'**
  String get np_paidByThirdPerson;

  /// No description provided for @np_previousDelivery.
  ///
  /// In uk, this message translates to:
  /// **'Доставка за попередньою ТТН'**
  String get np_previousDelivery;

  /// No description provided for @np_total.
  ///
  /// In uk, this message translates to:
  /// **'Разом'**
  String get np_total;

  /// No description provided for @np_previousTtn.
  ///
  /// In uk, this message translates to:
  /// **'Переадресовано з ЕН'**
  String get np_previousTtn;

  /// No description provided for @np_payerType.
  ///
  /// In uk, this message translates to:
  /// **'Платник доставки НП'**
  String get np_payerType;

  /// No description provided for @np_paymentMethod.
  ///
  /// In uk, this message translates to:
  /// **'Спосіб оплати НП'**
  String get np_paymentMethod;

  /// No description provided for @np_payer_Sender.
  ///
  /// In uk, this message translates to:
  /// **'відправник'**
  String get np_payer_Sender;

  /// No description provided for @np_payer_Recipient.
  ///
  /// In uk, this message translates to:
  /// **'отримувач'**
  String get np_payer_Recipient;

  /// No description provided for @np_payer_ThirdPerson.
  ///
  /// In uk, this message translates to:
  /// **'третя сторона'**
  String get np_payer_ThirdPerson;

  /// No description provided for @np_copied.
  ///
  /// In uk, this message translates to:
  /// **'Скопійовано'**
  String get np_copied;

  /// No description provided for @np_gone.
  ///
  /// In uk, this message translates to:
  /// **'Посилку об\'єднано з іншою або видалено'**
  String get np_gone;

  /// No description provided for @scanAction_receive.
  ///
  /// In uk, this message translates to:
  /// **'Забрати з Нової Пошти'**
  String get scanAction_receive;

  /// No description provided for @scanAction_load.
  ///
  /// In uk, this message translates to:
  /// **'Завантажити в машину'**
  String get scanAction_load;

  /// No description provided for @scanAction_deliver.
  ///
  /// In uk, this message translates to:
  /// **'Видати клієнту'**
  String get scanAction_deliver;

  /// No description provided for @scanAction_toWarehouse.
  ///
  /// In uk, this message translates to:
  /// **'Перемістити на склад'**
  String get scanAction_toWarehouse;

  /// No description provided for @scanAction_none.
  ///
  /// In uk, this message translates to:
  /// **'Для цієї посилки немає доступних дій'**
  String get scanAction_none;

  /// No description provided for @scanAction_offline.
  ///
  /// In uk, this message translates to:
  /// **'Немає зв’язку: статус невідомий. Оберіть дію — вона піде в чергу.'**
  String get scanAction_offline;

  /// No description provided for @scanAction_chooseTrip.
  ///
  /// In uk, this message translates to:
  /// **'Оберіть рейс'**
  String get scanAction_chooseTrip;

  /// No description provided for @scanAction_chooseWarehouse.
  ///
  /// In uk, this message translates to:
  /// **'Оберіть склад'**
  String get scanAction_chooseWarehouse;

  /// No description provided for @scanAction_pickAgain.
  ///
  /// In uk, this message translates to:
  /// **'Сканувати далі'**
  String get scanAction_pickAgain;

  /// No description provided for @scan_hint.
  ///
  /// In uk, this message translates to:
  /// **'Наведіть камеру на штрих-код або ТТН'**
  String get scan_hint;

  /// No description provided for @npFilter_withUs.
  ///
  /// In uk, this message translates to:
  /// **'У нас'**
  String get npFilter_withUs;

  /// No description provided for @npFilter_problem.
  ///
  /// In uk, this message translates to:
  /// **'Проблемні'**
  String get npFilter_problem;

  /// No description provided for @receiveWithoutScan_action.
  ///
  /// In uk, this message translates to:
  /// **'Підтвердити отримання'**
  String get receiveWithoutScan_action;

  /// No description provided for @receiveWithoutScan_title.
  ///
  /// In uk, this message translates to:
  /// **'Підтвердити отримання?'**
  String get receiveWithoutScan_title;

  /// No description provided for @receiveWithoutScan_body.
  ///
  /// In uk, this message translates to:
  /// **'Нова Пошта вже видала посилку {code}. Вона отримає наш штрих-код і статус «Отримано представником», без сканування.'**
  String receiveWithoutScan_body(String code);

  /// No description provided for @receiveWithoutScan_confirm.
  ///
  /// In uk, this message translates to:
  /// **'Підтвердити'**
  String get receiveWithoutScan_confirm;

  /// No description provided for @receiveWithoutScan_done.
  ///
  /// In uk, this message translates to:
  /// **'Отримано: {code}'**
  String receiveWithoutScan_done(String code);

  /// No description provided for @scanAction_confirmReceipt.
  ///
  /// In uk, this message translates to:
  /// **'Підтвердити отримання'**
  String get scanAction_confirmReceipt;

  /// No description provided for @scanAction_notFound.
  ///
  /// In uk, this message translates to:
  /// **'Посилку не знайдено.'**
  String get scanAction_notFound;

  /// No description provided for @scanAction_notFoundReceive.
  ///
  /// In uk, this message translates to:
  /// **'Можна забрати з Нової Пошти — посилку буде створено.'**
  String get scanAction_notFoundReceive;

  /// No description provided for @scanAction_badCode.
  ///
  /// In uk, this message translates to:
  /// **'Не схоже на код посилки чи ЕН Нової Пошти.'**
  String get scanAction_badCode;

  /// No description provided for @scanAction_createTitle.
  ///
  /// In uk, this message translates to:
  /// **'Створити посилку?'**
  String get scanAction_createTitle;

  /// No description provided for @scanAction_createBody.
  ///
  /// In uk, this message translates to:
  /// **'Посилки з ЕН {code} ще немає в системі. Її буде створено за даними Нової Пошти.'**
  String scanAction_createBody(String code);

  /// No description provided for @scanAction_createConfirm.
  ///
  /// In uk, this message translates to:
  /// **'Створити'**
  String get scanAction_createConfirm;

  /// No description provided for @np_paidOnline.
  ///
  /// In uk, this message translates to:
  /// **'оплачено'**
  String get np_paidOnline;

  /// No description provided for @np_settled.
  ///
  /// In uk, this message translates to:
  /// **'Посилку вже забрали з Нової Пошти, платити нічого'**
  String get np_settled;

  /// No description provided for @parcel_npPaymentStatus.
  ///
  /// In uk, this message translates to:
  /// **'Оплата доставки НП'**
  String get parcel_npPaymentStatus;

  /// No description provided for @trip_startLoading.
  ///
  /// In uk, this message translates to:
  /// **'Почати завантаження'**
  String get trip_startLoading;

  /// No description provided for @parcel_inTripPlan.
  ///
  /// In uk, this message translates to:
  /// **'У плані рейсу #{id}'**
  String parcel_inTripPlan(int id);

  /// No description provided for @scanAction_noneDelivered.
  ///
  /// In uk, this message translates to:
  /// **'Посилку вже видано клієнту'**
  String get scanAction_noneDelivered;

  /// No description provided for @scanAction_noneCancelled.
  ///
  /// In uk, this message translates to:
  /// **'Посилку скасовано'**
  String get scanAction_noneCancelled;

  /// No description provided for @scanAction_noneNeedsRepresentative.
  ///
  /// In uk, this message translates to:
  /// **'Спершу посилку має отримати представник'**
  String get scanAction_noneNeedsRepresentative;

  /// No description provided for @scanAction_noneRole.
  ///
  /// In uk, this message translates to:
  /// **'Ваша роль не дозволяє діяти з посилкою в статусі «{status}»'**
  String scanAction_noneRole(String status);

  /// No description provided for @scanAction_trip.
  ///
  /// In uk, this message translates to:
  /// **'рейс №{id}'**
  String scanAction_trip(int id);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

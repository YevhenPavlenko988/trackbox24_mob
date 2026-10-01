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

  /// No description provided for @nav_scan.
  ///
  /// In uk, this message translates to:
  /// **'Сканувати'**
  String get nav_scan;

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

  /// No description provided for @nav_load.
  ///
  /// In uk, this message translates to:
  /// **'Завантажити'**
  String get nav_load;

  /// No description provided for @nav_deliver.
  ///
  /// In uk, this message translates to:
  /// **'Видати'**
  String get nav_deliver;

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

  /// No description provided for @common_comingSoon.
  ///
  /// In uk, this message translates to:
  /// **'Цей розділ ще в розробці'**
  String get common_comingSoon;

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

import 'package:intl/intl.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

final _dateTime = DateFormat('dd.MM.yyyy HH:mm');
final _date = DateFormat('dd.MM.yyyy');
final _number = NumberFormat.decimalPattern('uk');

String formatDateTime(DateTime? d) =>
    d == null ? '—' : _dateTime.format(d.toLocal());

String formatDate(DateTime? d) => d == null ? '—' : _date.format(d.toLocal());

/// Digits as stored by the backend → a readable international number.
/// Ukrainian numbers keep the grouping people here are used to; everything else is formatted by country.
String formatPhone(String? phone) {
  if (phone == null || phone.isEmpty) return '—';
  final ua = RegExp(r'^380(\d{2})(\d{3})(\d{2})(\d{2})$').firstMatch(phone);
  if (ua != null) return '+380 ${ua[1]} ${ua[2]} ${ua[3]} ${ua[4]}';
  try {
    final parsed = PhoneNumber.parse('+$phone');
    if (parsed.isValid()) {
      return '+${parsed.countryCode} ${parsed.formatNsn()}';
    }
  } on PhoneNumberException {
    // not a number we know: show it as stored
  }
  return phone;
}

String formatMoney(num? value, [String? currency]) {
  if (value == null) return '—';
  return '${_number.format(value)} ${currency == 'EUR' ? '€' : 'грн'}';
}

String formatWeight(num? kg) => kg == null ? '—' : '${_number.format(kg)} кг';

/// `tel:` link target for a phone from the backend.
Uri? telUri(String? phone) =>
    phone == null || phone.isEmpty ? null : Uri(scheme: 'tel', path: '+$phone');

/// Backend rule: country code first, digits only, 8–15 digits, no leading 0; checked after [normalizePhone].
final phoneRegex = RegExp(r'^[1-9]\d{7,14}$');

/// "+380 (50) 123-45-67" → "380501234567": what the backend stores.
String normalizePhone(String raw) => raw
    .replaceAll(RegExp(r'[\s\-().]'), '')
    .replaceFirst(RegExp(r'^\+'), '')
    .replaceFirst(RegExp('^00'), '');

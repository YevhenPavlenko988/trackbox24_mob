import 'package:intl/intl.dart';

final _dateTime = DateFormat('dd.MM.yyyy HH:mm');
final _date = DateFormat('dd.MM.yyyy');
final _number = NumberFormat.decimalPattern('uk');

String formatDateTime(DateTime? d) =>
    d == null ? '—' : _dateTime.format(d.toLocal());

String formatDate(DateTime? d) => d == null ? '—' : _date.format(d.toLocal());

/// `380501234567` → `+380 50 123 45 67`; anything else is returned as is.
String formatPhone(String? phone) {
  if (phone == null || phone.isEmpty) return '—';
  final m = RegExp(r'^380(\d{2})(\d{3})(\d{2})(\d{2})$').firstMatch(phone);
  return m == null ? phone : '+380 ${m[1]} ${m[2]} ${m[3]} ${m[4]}';
}

String formatMoney(num? value, [String? currency]) {
  if (value == null) return '—';
  return '${_number.format(value)} ${currency == 'EUR' ? '€' : 'грн'}';
}

String formatWeight(num? kg) => kg == null ? '—' : '${_number.format(kg)} кг';

/// `tel:` link target for a phone from the backend.
Uri? telUri(String? phone) =>
    phone == null || phone.isEmpty ? null : Uri(scheme: 'tel', path: '+$phone');

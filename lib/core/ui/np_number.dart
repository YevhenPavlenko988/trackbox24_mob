import 'package:flutter/material.dart';

final _npNumber = RegExp(r'^\d{14}$');

/// The last four digits of a 14-digit Nova Poshta number — how a parcel is called out at the branch — or null
/// when [value] is not such a number.
String? npTail(String value) {
  final digits = value.replaceAll(RegExp(r'\s+'), '');
  return _npNumber.hasMatch(digits) ? digits.substring(10) : null;
}

/// [value] with its last four digits set apart (bigger, bold); anything that is not a Nova Poshta number
/// is returned as one plain span. [grouped] prints it the way Nova Poshta does: 20 4515 5881 9168.
TextSpan npNumberSpan(
  String value, {
  TextStyle? style,
  bool grouped = false,
  double emphasis = 1.2,
}) {
  final tail = npTail(value);
  if (tail == null) return TextSpan(text: value, style: style);
  final digits = value.replaceAll(RegExp(r'\s+'), '');
  final head = grouped
      ? '${digits.substring(0, 2)} ${digits.substring(2, 6)} '
            '${digits.substring(6, 10)} '
      : digits.substring(0, 10);
  final base = style ?? const TextStyle();
  return TextSpan(
    style: style,
    children: [
      TextSpan(text: head),
      TextSpan(
        text: tail,
        style: base.copyWith(
          fontWeight: FontWeight.w800,
          fontSize: (base.fontSize ?? 14) * emphasis,
        ),
      ),
    ],
  );
}

/// A Nova Poshta number (incoming TTN or our outgoing waybill) with its last four digits set apart.
/// [prefix] goes before it in the same style («ТТН »).
class NpNumberText extends StatelessWidget {
  const NpNumberText(
    this.value, {
    this.style,
    this.prefix,
    this.grouped = false,
    this.textAlign,
    super.key,
  });

  final String value;
  final TextStyle? style;
  final String? prefix;
  final bool grouped;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    // The default style has to be resolved here: a bare TextSpan has no font size to scale.
    final base = DefaultTextStyle.of(context).style.merge(style);
    return Text.rich(
      TextSpan(
        style: base,
        children: [
          if (prefix != null) TextSpan(text: prefix),
          npNumberSpan(value, style: base, grouped: grouped),
        ],
      ),
      textAlign: textAlign,
    );
  }
}

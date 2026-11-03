import 'package:flutter/material.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/referral/data/referral_api.dart';

/// «Списати бали» at a payment («Реферальна програма»): how many the payer has and may spend, a field and «усі».
class PointsField extends StatefulWidget {
  const PointsField({
    required this.info,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final RedeemInfo info;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  State<PointsField> createState() => _PointsFieldState();
}

class _PointsFieldState extends State<PointsField> {
  late final _text = TextEditingController(
    text: widget.value > 0 ? '${widget.value}' : '',
  );

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _set(int v) {
    final points = v.clamp(0, widget.info.maxPoints);
    _text.text = points > 0 ? '$points' : '';
    widget.onChanged(points);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final info = widget.info;
    if (info.maxPoints <= 0) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          l.points_none(info.reason ?? '—'),
          style: theme.textTheme.bodySmall,
        ),
      );
    }
    // one row: the label, the field, «усі» and how many there are
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Text(l.points_redeemShort, style: theme.textTheme.labelLarge),
          const SizedBox(width: 8),
          SizedBox(
            width: 64,
            child: TextField(
              key: const ValueKey('points-redeem'),
              controller: _text,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(isDense: true, hintText: '0'),
              onChanged: (s) => widget.onChanged(
                (int.tryParse(s.trim()) ?? 0).clamp(0, info.maxPoints),
              ),
            ),
          ),
          const SizedBox(width: 6),
          ActionChip(
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            label: Text(l.points_all(info.maxPoints)),
            onPressed: () => _set(info.maxPoints),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l.points_have(
                info.balance,
                formatMoney(info.pointValue, info.currency),
              ),
              style: theme.textTheme.bodySmall,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

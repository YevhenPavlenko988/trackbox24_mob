import 'package:flutter/material.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/parcels/payment_method_ui.dart';
import 'package:trackbox24_mob/features/trips/data/trip_model.dart';

/// What the trip brought in, by currency and payment method, and what went out unpaid.
///
/// The backend counts only parcels with our own price and sends nothing of this to a representative.
class TripPaymentsView extends StatelessWidget {
  const TripPaymentsView({required this.payments, super.key});

  final TripPayments payments;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    if (payments.isEmpty) {
      return Text(l.trip_paymentsEmpty, style: theme.textTheme.bodySmall);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (payments.received.isNotEmpty) ...[
          Text(l.trip_paymentsReceived, style: theme.textTheme.labelLarge),
          for (final line in payments.received)
            _Line(label: paymentMethodLabel(l, line.method), line: line),
        ],
        if (payments.notReceived.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            l.trip_paymentsNotReceived,
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.orange.shade900,
            ),
          ),
          for (final line in payments.notReceived)
            _Line(label: l.trip_paymentsDelivered, line: line),
        ],
      ],
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.line});

  final String label;
  final TripPaymentLine line;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Text(
            formatMoney(line.amount, line.currency),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            ' · ${l.trip_paymentsParcels(line.parcels)}',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';

/// Offered in this order wherever the money is taken or summed up.
const paymentMethods = [
  PaymentMethod.CASH,
  PaymentMethod.UA_CARD,
  PaymentMethod.FOREIGN_CARD,
];

String paymentMethodLabel(AppLocalizations l, PaymentMethod? method) =>
    switch (method) {
      PaymentMethod.CASH => l.payment_cash,
      PaymentMethod.UA_CARD => l.payment_uaCard,
      PaymentMethod.FOREIGN_CARD => l.payment_foreignCard,
      _ => l.payment_methodUnknown,
    };

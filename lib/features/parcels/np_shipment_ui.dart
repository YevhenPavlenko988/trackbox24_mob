import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';

String npDeliveryTypeLabel(AppLocalizations l, NpDeliveryType? t) =>
    switch (t) {
      NpDeliveryType.WAREHOUSE => l.npShipment_typeWarehouse,
      NpDeliveryType.POSTOMAT => l.npShipment_typePostomat,
      NpDeliveryType.ADDRESS => l.npShipment_typeAddress,
      _ => '—',
    };

String npCargoTypeLabel(AppLocalizations l, NpCargoType? t) => switch (t) {
  NpCargoType.PARCEL => l.npShipment_cargoParcel,
  NpCargoType.DOCUMENTS => l.npShipment_cargoDocuments,
  NpCargoType.CARGO => l.npShipment_cargoCargo,
  _ => '—',
};

String npPayerTypeLabel(AppLocalizations l, NpPayerType? t) => switch (t) {
  NpPayerType.SENDER => l.npShipment_payerSender,
  NpPayerType.RECIPIENT => l.npShipment_payerRecipient,
  _ => '—',
};

String npPaymentMethodLabel(AppLocalizations l, NpPaymentMethod? m) =>
    switch (m) {
      NpPaymentMethod.CASH => l.npShipment_payCash,
      NpPaymentMethod.NON_CASH => l.npShipment_payNonCash,
      _ => '—',
    };

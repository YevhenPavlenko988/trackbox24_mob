import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/state/parcel_form.dart';

/// Form values of the outgoing Nova Poshta shipment, as typed; refs come from the Nova Poshta directories.
class NpShipmentFormValues {
  const NpShipmentFormValues({
    this.lastName = '',
    this.firstName = '',
    this.middleName = '',
    this.phone = '',
    this.deliveryType = NpDeliveryType.WAREHOUSE,
    this.cityRef,
    this.cityName,
    this.branchRef,
    this.branchName,
    this.streetRef,
    this.streetName,
    this.building = '',
    this.flat = '',
    this.cargoType = NpCargoType.PARCEL,
    this.payerType = NpPayerType.RECIPIENT,
    this.paymentMethod = NpPaymentMethod.CASH,
    this.codAmount = '',
  });

  factory NpShipmentFormValues.fromShipment(NpShipment? s) {
    if (s == null) return const NpShipmentFormValues();
    return NpShipmentFormValues(
      lastName: s.recipientLastName ?? '',
      firstName: s.recipientFirstName ?? '',
      middleName: s.recipientMiddleName ?? '',
      phone: s.recipientPhone ?? '',
      deliveryType: s.deliveryType == null || s.deliveryType == NpDeliveryType.unknown
          ? NpDeliveryType.WAREHOUSE
          : s.deliveryType!,
      cityRef: s.cityRef,
      cityName: s.cityName,
      branchRef: s.warehouseRef,
      branchName: s.warehouseName,
      streetRef: s.streetRef,
      streetName: s.streetName,
      building: s.building ?? '',
      flat: s.flat ?? '',
      cargoType: s.cargoType == null || s.cargoType == NpCargoType.unknown
          ? NpCargoType.PARCEL
          : s.cargoType!,
      payerType: s.payerType == null || s.payerType == NpPayerType.unknown
          ? NpPayerType.RECIPIENT
          : s.payerType!,
      paymentMethod: s.paymentMethod == null || s.paymentMethod == NpPaymentMethod.unknown
          ? NpPaymentMethod.CASH
          : s.paymentMethod!,
      codAmount: s.codAmount == null ? '' : _num(s.codAmount!),
    );
  }

  final String lastName;
  final String firstName;
  final String middleName;
  final String phone;
  final NpDeliveryType deliveryType;
  final String? cityRef;
  final String? cityName;
  final String? branchRef;
  final String? branchName;
  final String? streetRef;
  final String? streetName;
  final String building;
  final String flat;
  final NpCargoType cargoType;
  final NpPayerType payerType;
  final NpPaymentMethod paymentMethod;
  final String codAmount;

  static String _num(num v) => v == v.roundToDouble() ? '${v.toInt()}' : '$v';
}

/// Nova Poshta only takes Ukrainian numbers for the recipient.
final npPhonePattern = RegExp(r'^380\d{9}$');

/// Splits a Ukrainian full name as people write it — «Коваль Іван Петрович» — into the three fields Nova Poshta
/// wants. Anything past the third word stays with the patronymic, and a single word counts as the surname.
({String? lastName, String? firstName, String? middleName}) splitFullName(
  String value,
) {
  final parts = value.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  return (
    lastName: parts.isEmpty ? null : parts.first,
    firstName: parts.length < 2 ? null : parts[1],
    middleName: parts.length < 3 ? null : parts.sublist(2).join(' '),
  );
}

String? _orNull(String? s) => s == null || s.trim().isEmpty ? null : s.trim();

/// `PUT /api/parcels/{id}/np-shipment` replaces every field, so the whole form goes out, half-filled or not.
/// Fields that do not belong to the chosen delivery type are dropped — the backend does the same.
Map<String, dynamic> npShipmentBody(NpShipmentFormValues v) {
  final toAddress = v.deliveryType == NpDeliveryType.ADDRESS;
  return {
    'recipientLastName': _orNull(v.lastName),
    'recipientFirstName': _orNull(v.firstName),
    'recipientMiddleName': _orNull(v.middleName),
    'recipientPhone': _orNull(v.phone),
    'deliveryType': v.deliveryType.name,
    'cityRef': _orNull(v.cityRef),
    'cityName': _orNull(v.cityName),
    'warehouseRef': toAddress ? null : _orNull(v.branchRef),
    'warehouseName': toAddress ? null : _orNull(v.branchName),
    'streetRef': toAddress ? _orNull(v.streetRef) : null,
    'streetName': toAddress ? _orNull(v.streetName) : null,
    'building': toAddress ? _orNull(v.building) : null,
    'flat': toAddress ? _orNull(v.flat) : null,
    'cargoType': v.cargoType.name,
    'payerType': v.payerType.name,
    'paymentMethod': v.paymentMethod.name,
    'codAmount': parseNum(v.codAmount),
  };
}

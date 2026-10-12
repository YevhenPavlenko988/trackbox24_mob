import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/async_view.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/features/nova_poshta/ui/np_ref_picker.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_api.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/np_shipment_ui.dart';
import 'package:trackbox24_mob/features/parcels/state/np_shipment_form.dart';

/// Where Nova Poshta takes the parcel after us — filled in by the driver on acceptance.
/// Everything may stay half-filled: the manager sees what is still missing when creating the waybill.
class NpShipmentScreen extends ConsumerWidget {
  const NpShipmentScreen({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final parcel = ref.watch(parcelProvider(id));
    return switch (parcel) {
      AsyncData(:final value) => _Form(parcel: value),
      AsyncError(:final error) => Scaffold(
        appBar: AppBar(title: Text(l.npShipment_title)),
        body: ErrorView(
          error: error,
          onRetry: () => ref.invalidate(parcelProvider(id)),
        ),
      ),
      _ => Scaffold(
        appBar: AppBar(title: Text(l.npShipment_title)),
        body: const Center(child: CircularProgressIndicator()),
      ),
    };
  }
}

class _Form extends ConsumerStatefulWidget {
  const _Form({required this.parcel});

  final Parcel parcel;

  @override
  ConsumerState<_Form> createState() => _FormState();
}

class _FormState extends ConsumerState<_Form> {
  final _formKey = GlobalKey<FormState>();
  late final NpShipmentFormValues _initial = NpShipmentFormValues.fromShipment(
    widget.parcel.npShipment,
  );
  late final _lastName = TextEditingController(text: _initial.lastName);
  late final _firstName = TextEditingController(text: _initial.firstName);
  late final _middleName = TextEditingController(text: _initial.middleName);
  late final _phone = TextEditingController(text: _initial.phone);
  late final _building = TextEditingController(text: _initial.building);
  late final _flat = TextEditingController(text: _initial.flat);
  late final _cod = TextEditingController(text: _initial.codAmount);
  late NpDeliveryType _deliveryType = _initial.deliveryType;
  late String? _cityRef = _initial.cityRef;
  late String? _cityName = _initial.cityName;
  late String? _branchRef = _initial.branchRef;
  late String? _branchName = _initial.branchName;
  late String? _streetRef = _initial.streetRef;
  late String? _streetName = _initial.streetName;
  late NpCargoType _cargoType = _initial.cargoType;
  late NpPayerType _payerType = _initial.payerType;
  late NpPaymentMethod _paymentMethod = _initial.paymentMethod;
  bool _saving = false;
  Map<String, String> _serverErrors = const {};

  @override
  void dispose() {
    for (final c in [
      _lastName,
      _firstName,
      _middleName,
      _phone,
      _building,
      _flat,
      _cod,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  NpShipmentFormValues _current() => NpShipmentFormValues(
    lastName: _lastName.text,
    firstName: _firstName.text,
    middleName: _middleName.text,
    phone: _phone.text,
    deliveryType: _deliveryType,
    cityRef: _cityRef,
    cityName: _cityName,
    branchRef: _branchRef,
    branchName: _branchName,
    streetRef: _streetRef,
    streetName: _streetName,
    building: _building.text,
    flat: _flat.text,
    cargoType: _cargoType,
    payerType: _payerType,
    paymentMethod: _paymentMethod,
    codAmount: _cod.text,
  );

  Future<void> _pickCity() async {
    final city = await pickNpCity(context);
    if (city == null) return;
    setState(() {
      _cityRef = city.ref;
      _cityName = city.name;
      // Branches and streets belong to the city chosen before.
      _branchRef = null;
      _branchName = null;
      _streetRef = null;
      _streetName = null;
    });
  }

  Future<void> _pickBranch() async {
    final city = _cityRef;
    if (city == null) return;
    final branch = await pickNpBranch(
      context,
      cityRef: city,
      postomat: _deliveryType == NpDeliveryType.POSTOMAT,
    );
    if (branch == null) return;
    setState(() {
      _branchRef = branch.ref;
      _branchName = branch.name;
    });
  }

  Future<void> _pickStreet() async {
    final city = _cityRef;
    if (city == null) return;
    final street = await pickNpStreet(context, cityRef: city);
    if (street == null) return;
    setState(() {
      _streetRef = street.ref;
      _streetName = street.name;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _serverErrors = const {};
    });
    try {
      await ref
          .read(parcelApiProvider)
          .updateNpShipment(widget.parcel.id, npShipmentBody(_current()));
      ref
        ..invalidate(parcelProvider(widget.parcel.id))
        ..invalidate(parcelHistoryProvider(widget.parcel.id));
      if (mounted) context.pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _serverErrors = e.fieldErrors);
      if (e.fieldErrors.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(describeError(context, e))));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final toAddress = _deliveryType == NpDeliveryType.ADDRESS;

    return Scaffold(
      appBar: AppBar(title: Text(l.npShipment_title)),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Text(l.npShipment_hint, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            _field(_lastName, l.npShipment_lastName, key: 'recipientLastName'),
            _field(_firstName, l.npShipment_firstName, key: 'recipientFirstName'),
            _field(_middleName, l.npShipment_middleName, key: 'recipientMiddleName'),
            _field(
              _phone,
              l.npShipment_phone,
              key: 'recipientPhone',
              keyboard: TextInputType.phone,
              hint: '380XXXXXXXXX',
              validator: (v) =>
                  v == null || v.trim().isEmpty || npPhonePattern.hasMatch(v.trim())
                  ? null
                  : l.npShipment_phoneInvalid,
            ),
            const SizedBox(height: 4),
            SegmentedButton<NpDeliveryType>(
              // Three Ukrainian labels only fit on one line with tighter padding.
              style: SegmentedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                visualDensity: VisualDensity.compact,
              ),
              showSelectedIcon: false,
              segments: [
                for (final t in [
                  NpDeliveryType.WAREHOUSE,
                  NpDeliveryType.POSTOMAT,
                  NpDeliveryType.ADDRESS,
                ])
                  ButtonSegment(value: t, label: Text(npDeliveryTypeLabel(l, t))),
              ],
              selected: {_deliveryType},
              onSelectionChanged: (s) => setState(() {
                // A locker ref is not a branch ref, and neither is an address.
                if (s.first != _deliveryType) {
                  _branchRef = null;
                  _branchName = null;
                }
                _deliveryType = s.first;
              }),
            ),
            _pickerTile(
              icon: Icons.location_city_outlined,
              label: l.npShipment_city,
              value: _cityName,
              onTap: _pickCity,
            ),
            if (toAddress) ...[
              _pickerTile(
                icon: Icons.signpost_outlined,
                label: l.npShipment_street,
                value: _streetName,
                onTap: _cityRef == null ? null : _pickStreet,
                hint: _cityRef == null ? l.npShipment_cityFirst : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: _field(_building, l.npShipment_building, key: 'building'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _field(_flat, l.npShipment_flat, key: 'flat')),
                ],
              ),
            ] else
              _pickerTile(
                icon: Icons.local_post_office_outlined,
                label: _deliveryType == NpDeliveryType.POSTOMAT
                    ? l.npShipment_postomat
                    : l.npShipment_branch,
                value: _branchName,
                onTap: _cityRef == null ? null : _pickBranch,
                hint: _cityRef == null ? l.npShipment_cityFirst : null,
              ),
            _dropdown<NpCargoType>(
              label: l.npShipment_cargoType,
              value: _cargoType,
              values: const [NpCargoType.PARCEL, NpCargoType.DOCUMENTS, NpCargoType.CARGO],
              labelOf: (v) => npCargoTypeLabel(l, v),
              onChanged: (v) => setState(() => _cargoType = v),
            ),
            _dropdown<NpPayerType>(
              label: l.npShipment_payerType,
              value: _payerType,
              values: const [NpPayerType.RECIPIENT, NpPayerType.SENDER],
              labelOf: (v) => npPayerTypeLabel(l, v),
              onChanged: (v) => setState(() => _payerType = v),
            ),
            _dropdown<NpPaymentMethod>(
              label: l.npShipment_paymentMethod,
              value: _paymentMethod,
              values: const [NpPaymentMethod.CASH, NpPaymentMethod.NON_CASH],
              labelOf: (v) => npPaymentMethodLabel(l, v),
              onChanged: (v) => setState(() => _paymentMethod = v),
            ),
            _field(
              _cod,
              l.npShipment_codAmount,
              key: 'codAmount',
              keyboard: const TextInputType.numberWithOptions(decimal: true),
              hint: l.npShipment_codAmountHint,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l.common_save),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pickerTile({
    required IconData icon,
    required String label,
    required String? value,
    required VoidCallback? onTap,
    String? hint,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value ?? hint ?? AppLocalizations.of(context).common_notSet),
      trailing: const Icon(Icons.chevron_right),
      enabled: onTap != null,
      onTap: onTap,
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T value,
    required List<T> values,
    required String Function(T) labelOf,
    required ValueChanged<T> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<T>(
        initialValue: value,
        decoration: InputDecoration(labelText: label),
        items: [
          for (final v in values)
            DropdownMenuItem(value: v, child: Text(labelOf(v))),
        ],
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    required String key,
    TextInputType? keyboard,
    List<TextInputFormatter>? formatters,
    FormFieldValidator<String>? validator,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        keyboardType: keyboard,
        inputFormatters: formatters,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          errorText: _serverErrors[key],
        ),
        onChanged: _serverErrors.containsKey(key)
            ? (_) => setState(
                () => _serverErrors = {..._serverErrors}..remove(key),
              )
            : null,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/model/channel.dart';
import 'package:trackbox24_mob/core/ui/async_view.dart';
import 'package:trackbox24_mob/core/ui/channel_ui.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';
import 'package:trackbox24_mob/features/clients/data/client_model.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_api.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/state/np_shipment_form.dart';
import 'package:trackbox24_mob/features/parcels/state/parcel_form.dart';

/// Create (`id == null`) or edit a parcel. Mirrors the web form minus manager-only price fields.
///
/// A driver uses the same screen to accept a parcel handed over in person (no Nova Poshta waybill, a client is
/// required, the price is agreed on the spot) — that is all the backend lets a pure driver create.
class ParcelFormScreen extends ConsumerWidget {
  const ParcelFormScreen({this.id, super.key});

  final int? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final byDriver = switch (ref.watch(authProvider)) {
      Authenticated(:final user) => user.isDriver && !user.isRepresentative,
      _ => false,
    };
    if (id == null) {
      return _Form(
        title: byDriver ? l.parcel_acceptTitle : l.parcel_createTitle,
        byDriver: byDriver,
      );
    }
    final parcel = ref.watch(parcelProvider(id!));
    return switch (parcel) {
      AsyncData(:final value) => _Form(
        title: l.parcel_editTitle,
        parcel: value,
      ),
      AsyncError(:final error) => Scaffold(
        appBar: AppBar(),
        body: ErrorView(
          error: error,
          onRetry: () => ref.invalidate(parcelProvider(id!)),
        ),
      ),
      _ => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
    };
  }
}

class _Form extends ConsumerStatefulWidget {
  const _Form({required this.title, this.parcel, this.byDriver = false});

  final String title;
  final Parcel? parcel;

  /// A pure driver accepting a parcel: no TTN, a client is required, the delivery price may be set.
  final bool byDriver;

  @override
  ConsumerState<_Form> createState() => _FormState();
}

class _FormState extends ConsumerState<_Form> {
  final _formKey = GlobalKey<FormState>();
  late final ParcelFormValues _initial = ParcelFormValues.fromParcel(
    widget.parcel,
  );
  late final _ttn = TextEditingController();
  late final _description = TextEditingController(text: _initial.description);
  late final _seats = TextEditingController(text: _initial.seatsAmount);
  late final _weight = TextEditingController(text: _initial.weightKg);
  late final _declared = TextEditingController(text: _initial.declaredValue);
  late final _senderName = TextEditingController(text: _initial.senderName);
  late final _senderPhone = TextEditingController(text: _initial.senderPhone);
  late final _senderCity = TextEditingController(text: _initial.senderCity);
  late final _notes = TextEditingController(text: _initial.notes);
  late final _channelDetails = TextEditingController(
    text: _initial.channelDetails,
  );
  final _price = TextEditingController();
  String _currency = 'UAH';
  // A parcel accepted by hand goes on to its recipient by Nova Poshta, so the driver takes down who gets it.
  final _recipientName = TextEditingController();
  final _recipientPhone = TextEditingController();
  late Channel? _channel = _initial.channel;
  bool _channelFromClient = false;
  bool _byTtn = true;
  bool _alreadyReceived = false;
  late bool _needsEnrichment = _initial.needsEnrichment;
  int? _clientId;
  String? _clientName;
  bool _saving = false;
  Map<String, String> _serverErrors = const {};

  bool get _isEdit => widget.parcel != null;

  @override
  void initState() {
    super.initState();
    _clientId = widget.parcel?.clientId;
    _clientName = widget.parcel?.clientName;
  }

  @override
  void dispose() {
    for (final c in [
      _ttn,
      _description,
      _seats,
      _weight,
      _declared,
      _senderName,
      _senderPhone,
      _senderCity,
      _notes,
      _channelDetails,
      _price,
      _recipientName,
      _recipientPhone,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  ParcelFormValues _current() => ParcelFormValues(
    description: _description.text,
    seatsAmount: _seats.text,
    weightKg: _weight.text,
    declaredValue: _declared.text,
    senderName: _senderName.text,
    senderPhone: _senderPhone.text,
    senderCity: _senderCity.text,
    notes: _notes.text,
    needsEnrichment: _needsEnrichment,
    clientId: _clientId,
    channel: _channel,
    channelDetails: _channelDetails.text,
  );

  Future<void> _pickClient() async {
    final client = await context.push<Client>('/clients/pick');
    if (client != null) {
      setState(() {
        _clientId = client.id;
        _clientName = client.displayName;
        // The backend defaults the channel from the client; show it so the user can override.
        if (_channel == null &&
            client.channel != null &&
            client.channel != Channel.unknown) {
          _channel = client.channel;
          _channelDetails.text = client.channelDetails ?? '';
          _channelFromClient = true;
        }
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (widget.byDriver && _clientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).parcel_clientRequired)),
      );
      return;
    }
    setState(() {
      _saving = true;
      _serverErrors = const {};
    });
    final api = ref.read(parcelApiProvider);
    try {
      final Parcel saved;
      if (_isEdit) {
        final diff = updateBody(_initial, _current());
        saved = diff.isEmpty
            ? widget.parcel!
            : await api.update(widget.parcel!.id, diff);
      } else {
        final created = await api.create(
          createBody(
            _current(),
            npTtn: _byTtn ? _ttn.text.trim() : null,
            alreadyReceived: _byTtn && _alreadyReceived,
            deliveryPrice: widget.byDriver ? _price.text : '',
            deliveryPriceCurrency: _currency,
          ),
        );
        saved = await _saveRecipient(api, created);
      }
      if (!mounted) return;
      if (_isEdit) {
        context.pop(saved);
      } else {
        context.pushReplacement('/parcels/${saved.id}');
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _serverErrors = e.fieldErrors);
      if (e.fieldErrors.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(describeError(context, e))));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// The recipient the driver wrote down is the Nova Poshta recipient; the rest of the shipment (branch, locker,
  /// address) is filled in on the parcel card. Nothing typed — nothing sent.
  Future<Parcel> _saveRecipient(ParcelApi api, Parcel parcel) async {
    if (!widget.byDriver) return parcel;
    final name = splitFullName(_recipientName.text);
    final phone = _recipientPhone.text.trim();
    if (name.lastName == null && phone.isEmpty) return parcel;
    return await api.updateNpShipment(
      parcel.id,
      npShipmentBody(
        NpShipmentFormValues(
          lastName: name.lastName ?? '',
          firstName: name.firstName ?? '',
          middleName: name.middleName ?? '',
          phone: phone,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final seatsEditable =
        widget.parcel == null || canEditSeatsAmount(widget.parcel!);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            if (!_isEdit && !widget.byDriver) ...[
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment(value: true, label: Text(l.parcel_byTtn)),
                  ButtonSegment(value: false, label: Text(l.parcel_manual)),
                ],
                selected: {_byTtn},
                onSelectionChanged: (s) => setState(() => _byTtn = s.first),
              ),
              const SizedBox(height: 4),
              Text(
                _byTtn ? l.parcel_byTtnHint : l.parcel_manualHint,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              if (_byTtn) ...[
                _field(
                  _ttn,
                  l.parcel_npTtn,
                  key: 'npTtn',
                  keyboard: TextInputType.number,
                  formatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(14),
                  ],
                  validator: (v) => RegExp(r'^\d{14}$').hasMatch(v ?? '')
                      ? null
                      : l.parcel_ttnInvalid,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.parcel_alreadyReceived),
                  value: _alreadyReceived,
                  onChanged: (v) => setState(() => _alreadyReceived = v),
                ),
              ],
            ],
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.person_outline),
              title: Text(widget.byDriver ? l.parcel_clientRequiredLabel : l.parcel_client),
              subtitle: Text(_clientName ?? l.parcel_clientNotSet),
              trailing: _clientId == null
                  ? const Icon(Icons.chevron_right)
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() {
                        _clientId = null;
                        _clientName = null;
                      }),
                    ),
              onTap: _pickClient,
            ),
            _field(_description, l.parcel_description, key: 'description'),
            Row(
              children: [
                Expanded(
                  child: _field(
                    _seats,
                    l.parcel_seatsAmount,
                    key: 'seatsAmount',
                    keyboard: TextInputType.number,
                    enabled: seatsEditable,
                    formatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) =>
                        (v == null || v.isEmpty || int.parse(v) >= 1)
                        ? null
                        : l.parcel_min1,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    _weight,
                    l.parcel_weightKg,
                    key: 'weightKg',
                    keyboard: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _nonNegative,
                  ),
                ),
              ],
            ),
            if (!seatsEditable)
              Text(
                l.parcel_seatsLocked,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            _field(
              _declared,
              l.parcel_declaredValue,
              key: 'declaredValue',
              keyboard: const TextInputType.numberWithOptions(decimal: true),
              validator: _nonNegative,
            ),
            // The person handing the parcel over is the client picked above, so a driver writes down the
            // recipient instead — that is what the Nova Poshta waybill needs.
            if (widget.byDriver) ...[
              _field(
                _recipientName,
                l.parcel_recipientName,
                key: 'recipientName',
                hint: l.parcel_recipientNameHint,
              ),
              _field(
                _recipientPhone,
                l.npShipment_phone,
                key: 'recipientPhone',
                keyboard: TextInputType.phone,
                hint: '380XXXXXXXXX',
                validator: (v) =>
                    v == null ||
                        v.trim().isEmpty ||
                        npPhonePattern.hasMatch(v.trim())
                    ? null
                    : l.npShipment_phoneInvalid,
              ),
            ] else ...[
              _field(_senderName, l.parcel_senderName, key: 'senderName'),
              _field(
                _senderPhone,
                l.parcel_senderPhone,
                key: 'senderPhone',
                keyboard: TextInputType.phone,
                hint: '380XXXXXXXXX',
              ),
              _field(_senderCity, l.parcel_senderCity, key: 'senderCity'),
            ],
            if (widget.byDriver)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _field(
                      _price,
                      l.parcel_deliveryPrice,
                      key: 'deliveryPrice',
                      keyboard: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: _nonNegative,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 110,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DropdownButtonFormField<String>(
                        initialValue: _currency,
                        decoration: InputDecoration(
                          labelText: l.parcel_currency,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'UAH', child: Text('UAH')),
                          DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                        ],
                        onChanged: (v) => setState(() => _currency = v ?? 'UAH'),
                      ),
                    ),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ChannelDropdown(
                value: _channel,
                hint: _channelFromClient ? l.channel_fromClient : null,
                onChanged: (c) => setState(() {
                  _channel = c;
                  _channelFromClient = false;
                }),
              ),
            ),
            if (_channel != null)
              _field(
                _channelDetails,
                l.channel_details,
                key: 'channelDetails',
                hint: l.channel_detailsHint,
              ),
            _field(_notes, l.parcel_notes, key: 'notes', lines: 3),
            if (_isEdit)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.parcel_needsEnrichmentLong),
                value: _needsEnrichment,
                onChanged: (v) => setState(() => _needsEnrichment = v),
              ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_isEdit ? l.common_save : l.common_create),
            ),
          ],
        ),
      ),
    );
  }

  String? _nonNegative(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final n = double.tryParse(v.replaceAll(',', '.'));
    return n == null || n < 0
        ? AppLocalizations.of(context).parcel_numberInvalid
        : null;
  }

  Widget _field(
    TextEditingController c,
    String label, {
    required String key,
    TextInputType? keyboard,
    List<TextInputFormatter>? formatters,
    FormFieldValidator<String>? validator,
    bool enabled = true,
    int lines = 1,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        enabled: enabled,
        keyboardType: keyboard,
        inputFormatters: formatters,
        maxLines: lines,
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

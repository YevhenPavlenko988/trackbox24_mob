import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/features/clients/data/client_api.dart';
import 'package:trackbox24_mob/features/clients/data/client_model.dart';

/// New client (representatives may create, not edit). Pops with the created [Client].
class ClientFormScreen extends ConsumerStatefulWidget {
  const ClientFormScreen({super.key});

  @override
  ConsumerState<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends ConsumerState<ClientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  ClientType _type = ClientType.PRIVATE_PERSON;
  final _lastName = TextEditingController();
  final _firstName = TextEditingController();
  final _middleName = TextEditingController();
  final _organization = TextEditingController();
  final _phone = TextEditingController();
  final _city = TextEditingController();
  final _address = TextEditingController();
  bool _saving = false;
  Map<String, String> _serverErrors = const {};

  @override
  void dispose() {
    for (final c in [
      _lastName,
      _firstName,
      _middleName,
      _organization,
      _phone,
      _city,
      _address,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _serverErrors = const {};
    });
    try {
      final created = await ref.read(clientApiProvider).create({
        'type': _type.name,
        'firstName': _firstName.text.trim(),
        'lastName': _lastName.text.trim(),
        if (_middleName.text.trim().isNotEmpty)
          'middleName': _middleName.text.trim(),
        if (_type == ClientType.ORGANIZATION)
          'organizationName': _organization.text.trim(),
        'phone': _phone.text.trim(),
        if (_city.text.trim().isNotEmpty) 'city': _city.text.trim(),
        if (_address.text.trim().isNotEmpty) 'address': _address.text.trim(),
      });
      if (mounted) context.pop(created);
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

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    String? required(String? v) =>
        (v == null || v.trim().isEmpty) ? l.common_required : null;

    return Scaffold(
      appBar: AppBar(title: Text(l.client_createTitle)),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            SegmentedButton<ClientType>(
              segments: [
                ButtonSegment(
                  value: ClientType.PRIVATE_PERSON,
                  label: Text(l.client_privatePerson),
                ),
                ButtonSegment(
                  value: ClientType.ORGANIZATION,
                  label: Text(l.client_organization),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (s) => setState(() => _type = s.first),
            ),
            const SizedBox(height: 12),
            if (_type == ClientType.ORGANIZATION)
              _field(
                _organization,
                l.client_organizationName,
                key: 'organizationName',
                validator: required,
              ),
            _field(
              _lastName,
              l.client_lastName,
              key: 'lastName',
              validator: required,
              capitalization: TextCapitalization.words,
            ),
            _field(
              _firstName,
              l.client_firstName,
              key: 'firstName',
              validator: required,
              capitalization: TextCapitalization.words,
            ),
            _field(
              _middleName,
              l.client_middleName,
              key: 'middleName',
              capitalization: TextCapitalization.words,
            ),
            _field(
              _phone,
              l.client_phone,
              key: 'phone',
              keyboard: TextInputType.phone,
              hint: '380XXXXXXXXX',
              formatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => RegExp(r'^380\d{9}$').hasMatch(v ?? '')
                  ? null
                  : l.client_phoneInvalid,
            ),
            _field(
              _city,
              l.client_city,
              key: 'city',
              capitalization: TextCapitalization.words,
            ),
            _field(
              _address,
              l.client_address,
              key: 'address',
              capitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l.common_create),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    required String key,
    FormFieldValidator<String>? validator,
    TextInputType? keyboard,
    List<TextInputFormatter>? formatters,
    TextCapitalization capitalization = TextCapitalization.none,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        validator: validator,
        keyboardType: keyboard,
        inputFormatters: formatters,
        textCapitalization: capitalization,
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

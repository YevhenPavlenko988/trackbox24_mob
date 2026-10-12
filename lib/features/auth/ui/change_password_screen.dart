import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';

/// Minimum the backend accepts for a new password.
const passwordMinLength = 8;

/// Change your own password. The backend revokes every token issued before, so this session continues on the
/// fresh token it returns, while other devices are logged out.
class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _repeat = TextEditingController();
  bool _show = false;
  bool _saving = false;
  Map<String, String> _serverErrors = const {};

  /// Shown under the form when the backend refused without naming a field (a wrong current password).
  String? _error;

  @override
  void dispose() {
    for (final c in [_current, _next, _repeat]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _serverErrors = const {};
      _error = null;
    });
    final l = AppLocalizations.of(context);
    try {
      await ref.read(authProvider.notifier).changePassword(
        currentPassword: _current.text,
        newPassword: _next.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.password_done)));
      context.pop();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _serverErrors = e.fieldErrors;
        _error = e.fieldErrors.isEmpty ? describeError(context, e) : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.password_title),
        actions: [
          IconButton(
            tooltip: _show ? l.password_hide : l.password_show,
            icon: Icon(_show ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _show = !_show),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Text(l.password_hint, style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            _field(
              _current,
              l.password_current,
              key: 'currentPassword',
              autofill: AutofillHints.password,
              validator: (v) =>
                  (v == null || v.isEmpty) ? l.common_required : null,
            ),
            _field(
              _next,
              l.password_new,
              key: 'newPassword',
              autofill: AutofillHints.newPassword,
              validator: (v) => (v == null || v.length < passwordMinLength)
                  ? l.password_tooShort(passwordMinLength)
                  : null,
            ),
            _field(
              _repeat,
              l.password_repeat,
              key: 'repeat',
              autofill: AutofillHints.newPassword,
              validator: (v) =>
                  v == _next.text ? null : l.password_mismatch,
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  _error!,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
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

  Widget _field(
    TextEditingController c,
    String label, {
    required String key,
    required String autofill,
    FormFieldValidator<String>? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        obscureText: !_show,
        autocorrect: false,
        enableSuggestions: false,
        autofillHints: [autofill],
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
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

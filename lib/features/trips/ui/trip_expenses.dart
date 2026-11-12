import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/async_view.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/currency/data/currency_api.dart';
import 'package:trackbox24_mob/features/parcels/data/photo_pick.dart';
import 'package:trackbox24_mob/features/trips/data/expense_api.dart';

String expenseKindLabel(AppLocalizations l, String kind) => switch (kind) {
  'FUEL' => l.expense_kindFuel,
  'TOLL' => l.expense_kindToll,
  'PARKING' => l.expense_kindParking,
  'REPAIR' => l.expense_kindRepair,
  'FINE' => l.expense_kindFine,
  _ => l.expense_kindOther,
};

String expensePaidFromLabel(AppLocalizations l, String from) => switch (from) {
  'COLLECTED_CASH' => l.expense_fromCash,
  'OWN' => l.expense_fromOwn,
  _ => l.expense_fromCompany,
};

/// «Витрати» of a trip: what it cost, with receipts; the trip's driver adds their own here.
class TripExpensesSection extends ConsumerWidget {
  const TripExpensesSection({
    required this.tripId,
    required this.canAdd,
    super.key,
  });

  final int tripId;

  /// The trip's driver, while the trip is not cancelled.
  final bool canAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final async = ref.watch(tripExpensesProvider(tripId));
    final rows = async.value ?? const <TripExpense>[];
    final totals = [
      for (final c in moneyCurrencies)
        if (rows.any((e) => e.currency == c))
          formatMoney(
            rows
                .where((e) => e.currency == c)
                .fold<double>(0, (n, e) => n + e.amount),
            c,
          ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle('${l.expense_title} (${rows.length})'),
        if (totals.isNotEmpty)
          Text(totals.join(' + '), style: theme.textTheme.bodySmall),
        if (async.isLoading) const LinearProgressIndicator(),
        if (async.hasError)
          Text(
            describeError(context, async.error!),
            style: TextStyle(color: theme.colorScheme.error),
          ),
        for (final e in rows)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: e.receiptThumbUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      e.receiptThumbUrl!,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(Icons.receipt_long_outlined),
            title: Text(
              '${expenseKindLabel(l, e.kind)} · ${formatMoney(e.amount, e.currency)}',
            ),
            subtitle: Text(
              [
                formatDateTime(e.spentAt),
                expensePaidFromLabel(l, e.paidFrom),
                if (e.note != null) e.note!,
              ].join(' · '),
            ),
            trailing: e.editable ? const Icon(Icons.chevron_right) : null,
            onTap: e.editable
                ? () => showExpenseSheet(context, tripId, expense: e)
                : null,
          ),
        if (canAdd)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: OutlinedButton.icon(
              onPressed: () => showExpenseSheet(context, tripId),
              icon: const Icon(Icons.add),
              label: Text(l.expense_add),
            ),
          ),
      ],
    );
  }
}

Future<void> showExpenseSheet(
  BuildContext context,
  int tripId, {
  TripExpense? expense,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _ExpenseSheet(tripId: tripId, expense: expense),
);

class _ExpenseSheet extends ConsumerStatefulWidget {
  const _ExpenseSheet({required this.tripId, this.expense});

  final int tripId;
  final TripExpense? expense;

  @override
  ConsumerState<_ExpenseSheet> createState() => _ExpenseSheetState();
}

class _ExpenseSheetState extends ConsumerState<_ExpenseSheet> {
  late String _kind = widget.expense?.kind ?? 'FUEL';
  late String _currency = widget.expense?.currency ?? 'EUR';
  late String _paidFrom = widget.expense?.paidFrom ?? 'COLLECTED_CASH';
  late final _amount = TextEditingController(
    text: widget.expense == null
        ? ''
        : widget.expense!.amount.toString().replaceAll('.', ','),
  );
  late final _note = TextEditingController(text: widget.expense?.note ?? '');
  XFile? _photo;
  bool _saving = false;
  String? _error;

  double? get _value =>
      double.tryParse(_amount.text.trim().replaceAll(',', '.'));

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final l = AppLocalizations.of(context);
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l.photos_camera),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l.photos_gallery),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final file = await ImagePicker().pickPhoto(source);
    if (file != null && mounted) setState(() => _photo = file);
  }

  Future<void> _save() async {
    final value = _value;
    if (value == null || value <= 0) return;
    final l = AppLocalizations.of(context);
    final api = ref.read(expenseApiProvider);
    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final saved = await api.save(
        widget.tripId,
        id: widget.expense?.id,
        kind: _kind,
        amount: value,
        currency: _currency,
        paidFrom: _paidFrom,
        note: _note.text.trim().isEmpty ? null : _note.text.trim(),
      );
      if (_photo != null) {
        try {
          await api.receipt(widget.tripId, saved.id, _photo!);
        } on Object catch (e) {
          // the expense is saved; only its photo did not make it
          if (mounted) {
            messenger.showSnackBar(
              SnackBar(content: Text(describeError(context, e))),
            );
          }
        }
      }
      ref.invalidate(tripExpensesProvider(widget.tripId));
      if (mounted) {
        Navigator.pop(context);
        messenger.showSnackBar(SnackBar(content: Text(l.expense_saved)));
      }
    } on Object catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = describeError(context, e);
        });
      }
    }
  }

  Future<void> _delete() async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.expense_deleteTitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.common_cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.expense_delete),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(expenseApiProvider)
          .delete(widget.tripId, widget.expense!.id);
      ref.invalidate(tripExpensesProvider(widget.tripId));
      if (mounted) Navigator.pop(context);
    } on Object catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = describeError(context, e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    Widget chips(
      List<String> values,
      String current,
      String Function(String) label,
      void Function(String) set,
    ) => Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        for (final v in values)
          ChoiceChip(
            label: Text(label(v)),
            selected: v == current,
            onSelected: (_) => setState(() => set(v)),
          ),
      ],
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.expense == null ? l.expense_add : l.expense_edit,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            chips(
              expenseKinds,
              _kind,
              (v) => expenseKindLabel(l, v),
              (v) => _kind = v,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amount,
              autofocus: widget.expense == null,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: l.expense_amount,
                suffixText: currencySymbol(_currency),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            chips(
              moneyCurrencies,
              _currency,
              currencySymbol,
              (v) => _currency = v,
            ),
            const SizedBox(height: 12),
            Text(l.expense_paidFrom, style: theme.textTheme.labelLarge),
            const SizedBox(height: 4),
            chips(
              expensePaidFrom,
              _paidFrom,
              (v) => expensePaidFromLabel(l, v),
              (v) => _paidFrom = v,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _note,
              decoration: InputDecoration(labelText: l.expense_note),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _saving ? null : _pick,
              icon: Icon(
                _photo != null ? Icons.check_circle : Icons.receipt_long,
              ),
              label: Text(
                _photo != null
                    ? l.expense_photoChosen
                    : widget.expense?.receiptUrl != null
                    ? l.expense_photoReplace
                    : l.expense_photo,
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
            ],
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _saving || (_value ?? 0) <= 0 ? null : _save,
              child: Text(l.common_save),
            ),
            if (widget.expense != null) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: _saving ? null : _delete,
                child: Text(
                  l.expense_delete,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

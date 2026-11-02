import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/async_view.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/company/state/company.dart';
import 'package:trackbox24_mob/features/moves/data/move_bill.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_api.dart'
    show xlsxMimeType;
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/payment_method_ui.dart';
import 'package:trackbox24_mob/features/warehouses/data/warehouse_api.dart';
import 'package:trackbox24_mob/features/warehouses/data/warehouse_model.dart';
import 'package:trackbox24_mob/features/warehouses/new_warehouse.dart';

String _n(double? v) => v == null
    ? ''
    : v == v.roundToDouble()
    ? v.toInt().toString()
    : v.toString();

/// The loaders ticked when the sheet opened (and a new one) — [pinned] — first, then the others in their order: a tick
/// does not move anyone, so the row under the finger stays put. A search or a city filters the rest, never hiding one
/// that is [ticked].
List<Loader> pickLoaders(
  List<Loader> all,
  Set<int> pinned,
  String search, {
  String? city,
  Set<int> ticked = const {},
}) {
  final q = search.trim().toLowerCase();
  final digits = q.replaceAll(RegExp(r'\D'), '');
  bool matches(Loader l) =>
      (city == null || sameCity(l, city)) &&
      (q.isEmpty ||
          l.fullName.toLowerCase().contains(q) ||
          (digits.isNotEmpty && (l.phone ?? '').contains(digits)));
  return [
    ...all.where((l) => pinned.contains(l.id)),
    ...all.where(
      (l) => !pinned.contains(l.id) && (ticked.contains(l.id) || matches(l)),
    ),
  ];
}

bool sameCity(Loader l, String city) =>
    (l.city ?? '').trim().toLowerCase() == city.trim().toLowerCase();

/// The cities of the directory, once each, alphabetically.
List<String> loaderCities(List<Loader> all) {
  final seen = <String, String>{};
  for (final l in all) {
    final c = l.city?.trim();
    if (c != null && c.isNotEmpty) seen.putIfAbsent(c.toLowerCase(), () => c);
  }
  return seen.values.toList()..sort();
}

/// « × 3 год» when every loader of the work did the same hours, otherwise nothing (the sum says the rest).
String _sameHours(BillWork w) {
  final each = {for (final l in w.loaders) l.hours ?? 0};
  return each.length == 1 ? ' × ${_n(each.first)} год' : '';
}

double? _parse(String s) =>
    s.trim().isEmpty ? null : double.tryParse(s.trim().replaceAll(',', '.'));

/// A move's money on its card for the driver and the representative on site: the totals, loading and unloading
/// with loaders (their actual hours and «paid» after the work), storage, the client's payments and the bill to share.
class MoveBillSection extends ConsumerWidget {
  const MoveBillSection({
    required this.parcel,
    required this.editable,
    super.key,
  });

  final Parcel parcel;
  final bool editable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final bill = ref.watch(moveBillProvider(parcel.id)).value;
    if (bill == null) return const SizedBox.shrink();
    String money(double? v) => formatMoney(v, bill.currency);

    Future<void> run(Future<MoveBill> Function(MoveBillApi api) fn) async {
      try {
        await fn(ref.read(moveBillApiProvider));
        ref.invalidate(moveBillProvider(parcel.id));
      } on ApiException catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(describeError(context, e))));
      }
    }

    Future<void> sheet(Widget child) => showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => child,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: SectionTitle(l.bill_title)),
            // the currency of the whole move: transport, rates, storage and payments
            if (editable)
              SegmentedButton<String>(
                showSelectedIcon: false,
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
                segments: const [
                  ButtonSegment(value: 'EUR', label: Text('€')),
                  ButtonSegment(value: 'UAH', label: Text('грн')),
                ],
                selected: {bill.currency},
                onSelectionChanged: (v) =>
                    run((api) => api.setCurrency(parcel.id, v.first)),
              ),
          ],
        ),
        _Totals(bill: bill, money: money),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            if (editable) ...[
              OutlinedButton.icon(
                onPressed: () => sheet(_WorkSheet(parcel: parcel)),
                icon: const Icon(Icons.groups_outlined),
                label: Text(l.bill_work),
              ),
              OutlinedButton.icon(
                onPressed: () => sheet(_PaymentSheet(parcelId: parcel.id)),
                icon: const Icon(Icons.payments_outlined),
                label: Text(l.bill_payment),
              ),
              OutlinedButton.icon(
                onPressed: () => sheet(_StorageSheet(parcelId: parcel.id)),
                icon: const Icon(Icons.warehouse_outlined),
                label: Text(l.bill_storage),
              ),
            ],
            Builder(
              builder: (button) => OutlinedButton.icon(
                onPressed: () => _share(button, ref, l, bill, money),
                icon: const Icon(Icons.ios_share),
                label: Text(l.bill_share),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (bill.works.isEmpty)
          Text(l.bill_noWorks, style: theme.textTheme.bodySmall),
        for (final w in bill.works)
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          [
                            w.kindLabel,
                            if (w.plannedAt != null)
                              formatDateTime(w.plannedAt),
                            if (w.plannedHours != null)
                              l.bill_plan(_n(w.plannedHours)),
                          ].join(' · '),
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                      if (editable)
                        IconButton(
                          tooltip: l.bill_editWork,
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () =>
                              sheet(_WorkSheet(parcel: parcel, work: w)),
                        ),
                      // a work entered by mistake goes with its loaders and hours
                      if (editable)
                        IconButton(
                          tooltip: l.bill_deleteWork,
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            final ok = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text(l.bill_deleteWork),
                                content: Text(
                                  l.bill_deleteWorkConfirm(
                                    [
                                      w.kindLabel,
                                      if (w.plannedAt != null)
                                        formatDateTime(w.plannedAt),
                                    ].join(' · '),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(false),
                                    child: Text(l.common_cancel),
                                  ),
                                  FilledButton(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Theme.of(ctx)
                                          .colorScheme
                                          .error,
                                      foregroundColor: Theme.of(ctx)
                                          .colorScheme
                                          .onError,
                                    ),
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(true),
                                    child: Text(l.bill_deleteWorkSubmit),
                                  ),
                                ],
                              ),
                            );
                            if (ok == true) {
                              await run(
                                (api) => api.deleteWork(parcel.id, w.id),
                              );
                            }
                          },
                        ),
                    ],
                  ),
                  Text(
                    l.bill_rates(money(w.clientRate), money(w.loaderRate)),
                    style: theme.textTheme.bodySmall,
                  ),
                  // per loader: the plan (read-only), the fact (tap to enter), what it comes to, and paid out or not
                  for (final ld in w.loaders)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  ld.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ),
                              Text(
                                l.bill_toLoaderAmount(money(ld.loaderAmount)),
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              if (w.plannedHours != null)
                                Text(
                                  l.bill_planHours(_n(w.plannedHours)),
                                  style: theme.textTheme.bodySmall,
                                ),
                              ActionChip(
                                avatar: Icon(
                                  ld.actualHours == null
                                      ? Icons.add
                                      : Icons.edit_outlined,
                                  size: 16,
                                ),
                                label: Text(
                                  ld.actualHours == null
                                      ? l.bill_factEnter
                                      : l.bill_factHours(_n(ld.actualHours)),
                                ),
                                onPressed: !editable
                                    ? null
                                    : () async {
                                        final hours = await _askHours(
                                          context,
                                          l.bill_hours(ld.name),
                                          ld.actualHours ?? w.plannedHours,
                                        );
                                        if (hours == null) return;
                                        await run(
                                          (api) => api.setFact(
                                            parcel.id,
                                            w.id,
                                            ld.loaderId,
                                            actualHours: hours,
                                            paid: ld.paid,
                                          ),
                                        );
                                      },
                              ),
                              FilterChip(
                                showCheckmark: false,
                                selected: ld.paid,
                                selectedColor: Colors.green.shade600,
                                labelStyle: ld.paid
                                    ? const TextStyle(color: Colors.white)
                                    : null,
                                label: Text(
                                  ld.paid ? l.bill_paidOut : l.bill_notPaidOut,
                                ),
                                onSelected: !editable
                                    ? null
                                    : (v) => run(
                                        (api) => api.setFact(
                                          parcel.id,
                                          w.id,
                                          ld.loaderId,
                                          actualHours: ld.actualHours,
                                          paid: v,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  // the two sums apart: what the loaders get (the lines above add up to it) and what the client pays
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 12, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            l.bill_workLoaders(money(w.loaderAmount)),
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                        Text(
                          l.bill_workClient(money(w.clientAmount)),
                          style: theme.textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (bill.storages.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(l.bill_storages, style: theme.textTheme.titleSmall),
          for (final s in bill.storages)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(
                '${s.warehouseName ?? l.bill_noWarehouse} · ${_n(s.days)} × ${money(s.rate)}',
              ),
              subtitle: s.notes == null ? null : Text(s.notes!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(money(s.amount)),
                  if (editable)
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () =>
                          run((api) => api.deleteStorage(parcel.id, s.id)),
                    ),
                ],
              ),
            ),
        ],
        const SizedBox(height: 8),
        Text(l.bill_payments, style: theme.textTheme.titleSmall),
        for (final p in bill.payments)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(
              [formatDate(p.paidOn), ?p.methodLabel, ?p.note].join(' · '),
            ),
            subtitle: p.by == null ? null : Text(p.by!),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(money(p.amount)),
                if (editable && p.id != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () =>
                        run((api) => api.deletePayment(parcel.id, p.id!)),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  /// The bill as text for any messenger: services with sums, payments, what is left.
  Future<void> _share(
    BuildContext button,
    WidgetRef ref,
    AppLocalizations l,
    MoveBill b,
    String Function(double?) money,
  ) async {
    final box = button.findRenderObject() as RenderBox?;
    final company = ref.read(currentCompanyProvider).value?.name;
    final now = DateTime.now();
    final number =
        '${parcel.code}-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final route = [?parcel.senderCity, ?parcel.deliveryCity].join(' → ');
    final lines = <String>[
      'Рахунок № $number від ${formatDate(now)}',
      if (company != null) 'Перевізник: $company',
      if (parcel.clientName != null)
        'Клієнт: ${[parcel.clientName!, if (parcel.clientPhone != null) formatPhone(parcel.clientPhone)].join(', ')}',
      if (route.isNotEmpty) route,
      '',
      if ((b.transport ?? 0) > 0) '${l.bill_transport} — ${money(b.transport)}',
      for (final w in b.works)
        '${w.kindLabel}: ${w.loaders.length} вантажн.${_sameHours(w)} × ${money(w.clientRate)} — ${money(w.clientAmount)}',
      for (final s in b.storages)
        'Зберігання${s.warehouseName == null ? '' : ' (${s.warehouseName})'}: ${_n(s.days)} дн × ${money(s.rate)} — ${money(s.amount)}',
      '',
      '${l.bill_total}: ${money(b.total)}',
      for (final p in b.payments)
        '${l.bill_paidTotal} ${formatDate(p.paidOn)}${p.note == null ? '' : ' (${p.note})'}: ${money(p.amount)}',
      '${l.bill_due}: ${money(b.due)}',
    ];
    final origin = box == null
        ? null
        : box.localToGlobal(Offset.zero) & box.size;
    // an Excel file for the client, the same as the web's; with no connection — the same bill as text
    try {
      final bytes = await ref.read(moveBillApiProvider).invoiceXlsx(parcel.id);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/Рахунок-${parcel.code}.xlsx');
      await file.writeAsBytes(bytes, flush: true);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: xlsxMimeType)],
          text: 'Рахунок № $number',
          sharePositionOrigin: origin,
        ),
      );
    } on ApiException catch (e) {
      debugPrint('invoice file failed, sharing text: $e');
      await SharePlus.instance.share(
        ShareParams(text: lines.join('\n'), sharePositionOrigin: origin),
      );
    }
  }
}

class _Totals extends StatelessWidget {
  const _Totals({required this.bill, required this.money});

  final MoveBill bill;
  final String Function(double?) money;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    Widget cell(String label, double? v, {bool big = false}) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          Text(
            money(v),
            style: big
                ? theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )
                : theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                cell(l.bill_transport, bill.transport),
                cell(l.bill_loadersTotal, bill.loadersTotal),
                cell(l.bill_storageTotal, bill.storageTotal),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                cell(l.bill_total, bill.total),
                cell(l.bill_paidTotal, bill.paid),
                cell(l.bill_due, bill.due, big: true),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l.bill_payout(money(bill.loaderPayout), money(bill.loaderPaid)),
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<double?> _askHours(
  BuildContext context,
  String title,
  double? initial,
) async {
  final controller = TextEditingController(text: _n(initial));
  final l = AppLocalizations.of(context);
  final result = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l.common_cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, controller.text),
          child: Text(l.common_save),
        ),
      ],
    ),
  );
  controller.dispose();
  return result == null ? null : _parse(result);
}

/// Base of the sheets: padding above the keyboard, a title, the fields, a save button that shows progress.
class _SheetFrame extends StatelessWidget {
  const _SheetFrame({
    required this.title,
    required this.children,
    required this.onSave,
    required this.saving,
    this.error,
  });

  final String title;
  final List<Widget> children;
  final VoidCallback? onSave;
  final bool saving;

  /// Why the last save failed, in the sheet itself: a snackbar lands on the page behind it, under the keyboard.
  final String? error;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...children,
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(
                error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 12),
            FilledButton(
              onPressed: saving ? null : onSave,
              child: Text(l.common_save),
            ),
          ],
        ),
      ),
    );
  }
}

mixin _Saving<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  bool saving = false;
  String? error;

  Future<void> save(
    int parcelId,
    Future<MoveBill> Function(MoveBillApi api) fn,
  ) async {
    setState(() {
      saving = true;
      error = null;
    });
    try {
      await fn(ref.read(moveBillApiProvider));
      ref.invalidate(moveBillProvider(parcelId));
      if (mounted) Navigator.of(context).pop();
    } catch (e, st) {
      // any failure, not only the API's: a save that silently does nothing is what people saw
      debugPrint('bill save failed: $e\n$st');
      if (!mounted) return;
      setState(() => error = describeError(context, e));
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }
}

class _WorkSheet extends ConsumerStatefulWidget {
  const _WorkSheet({required this.parcel, this.work});

  final Parcel parcel;
  final BillWork? work;

  int get parcelId => parcel.id;

  @override
  ConsumerState<_WorkSheet> createState() => _WorkSheetState();
}

class _WorkSheetState extends ConsumerState<_WorkSheet> with _Saving {
  late String _kind = widget.work?.kind ?? 'LOAD';
  late DateTime? _when = widget.work?.plannedAt;
  late final _hours = TextEditingController(
    text: _n(widget.work?.plannedHours),
  );
  late final _clientRate = TextEditingController(
    text: _n(widget.work?.clientRate),
  );
  late final _loaderRate = TextEditingController(
    text: _n(widget.work?.loaderRate),
  );
  late final _notes = TextEditingController(text: widget.work?.notes ?? '');
  final _search = TextEditingController();

  /// Null — every city; set at first to where the work is (from for loading, to for unloading).
  String? _city;
  bool _cityChosen = false;
  late final Set<int> _loaders = {
    ...?widget.work?.loaders.map((l) => l.loaderId),
  };

  /// Who stays on top: ticked when the sheet opened, or just created here. A new tick keeps its row where it is.
  late final Set<int> _pinned = {..._loaders};

  @override
  void dispose() {
    for (final c in [_hours, _clientRate, _loaderRate, _notes, _search]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickWhen() async {
    final now = _when ?? DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
    if (time == null) return;
    setState(
      () => _when = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      ),
    );
  }

  Future<void> _newLoader() async {
    final loader = await showModalBottomSheet<Loader>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _LoaderSheet(),
    );
    if (loader != null && mounted) {
      setState(() {
        _loaders.add(loader.id);
        _pinned.add(loader.id);
      });
    }
  }

  Map<String, dynamic> _body() => {
    'kind': _kind,
    'plannedAt': _when?.toUtc().toIso8601String(),
    'plannedHours': _parse(_hours.text),
    'clientRate': _parse(_clientRate.text),
    'loaderRate': _parse(_loaderRate.text),
    'notes': _notes.text.trim().isEmpty ? null : _notes.text.trim(),
    'loaderIds': _loaders.toList(),
  };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final loaders = ref.watch(loadersProvider).value ?? const <Loader>[];
    final cities = loaderCities(loaders);
    if (!_cityChosen && loaders.isNotEmpty) {
      _cityChosen = true;
      final here = _kind == 'UNLOAD'
          ? widget.parcel.deliveryCity
          : widget.parcel.senderCity;
      _city = cities
          .where(
            (c) => here != null && c.toLowerCase() == here.trim().toLowerCase(),
          )
          .firstOrNull;
    }
    InputDecoration dec(String label) => InputDecoration(labelText: label);
    const decimal = TextInputType.numberWithOptions(decimal: true);
    return _SheetFrame(
      title: widget.work == null ? l.bill_work : l.bill_editWork,
      saving: saving,
      error: error,
      onSave: () {
        // read the fields at the tap: typing in them does not rebuild the sheet, so a body made in build() kept the
        // hours and rates of the last tick («the work and the loaders saved, the money did not»)
        final body = _body();
        unawaited(
          save(
            widget.parcelId,
            (api) => widget.work == null
                ? api.addWork(widget.parcelId, body)
                : api.updateWork(widget.parcelId, widget.work!.id, body),
          ),
        );
      },
      children: [
        SegmentedButton<String>(
          segments: [
            ButtonSegment(value: 'LOAD', label: Text(l.bill_kindLoad)),
            ButtonSegment(value: 'UNLOAD', label: Text(l.bill_kindUnload)),
          ],
          selected: {_kind},
          onSelectionChanged: (v) => setState(() => _kind = v.first),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.schedule),
          title: Text(l.bill_when),
          subtitle: Text(_when == null ? '—' : formatDateTime(_when)),
          onTap: _pickWhen,
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _hours,
                keyboardType: decimal,
                decoration: dec(l.bill_plannedHours),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _clientRate,
                keyboardType: decimal,
                decoration: dec(l.bill_clientRate),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _loaderRate,
                keyboardType: decimal,
                decoration: dec(l.bill_loaderRate),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                l.bill_loaders,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            TextButton.icon(
              onPressed: _newLoader,
              icon: const Icon(Icons.person_add_alt),
              label: Text(l.bill_newLoader),
            ),
          ],
        ),
        if (loaders.isEmpty) Text(l.bill_noLoaders),
        // find by name or phone; who was ticked on opening stays on top, a new tick does not move the list
        if (loaders.isNotEmpty)
          TextField(
            controller: _search,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: l.bill_searchLoader,
              isDense: true,
            ),
          ),
        // by city as soon as any loader has one
        if (cities.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ChoiceChip(
                  label: Text(l.bill_allCities),
                  selected: _city == null,
                  onSelected: (_) => setState(() => _city = null),
                ),
                for (final c in cities)
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: _city == c,
                      onSelected: (_) => setState(() => _city = c),
                    ),
                  ),
              ],
            ),
          ),
        for (final ld in pickLoaders(
          loaders,
          _pinned,
          _search.text,
          city: _city,
          ticked: _loaders,
        ))
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            value: _loaders.contains(ld.id),
            onChanged: (v) => setState(
              () => v == true ? _loaders.add(ld.id) : _loaders.remove(ld.id),
            ),
            title: Text(ld.fullName),
            subtitle: ld.phone == null && ld.city == null
                ? null
                : Text(
                    [
                      if (ld.phone != null) formatPhone(ld.phone),
                      ?ld.city,
                    ].join(' · '),
                  ),
          ),
        TextField(controller: _notes, decoration: dec(l.bill_notes)),
      ],
    );
  }
}

class _LoaderSheet extends ConsumerStatefulWidget {
  const _LoaderSheet();

  @override
  ConsumerState<_LoaderSheet> createState() => _LoaderSheetState();
}

class _LoaderSheetState extends ConsumerState<_LoaderSheet> {
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _phone = TextEditingController();
  final _city = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_first, _last, _phone, _city]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_first.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      final phone = _phone.text.replaceAll(RegExp(r'\D'), '');
      final loader = await ref.read(moveBillApiProvider).createLoader({
        'firstName': _first.text.trim(),
        if (_last.text.trim().isNotEmpty) 'lastName': _last.text.trim(),
        if (phone.isNotEmpty) 'phone': phone,
        if (_city.text.trim().isNotEmpty) 'city': _city.text.trim(),
      });
      ref.invalidate(loadersProvider);
      if (mounted) Navigator.of(context).pop(loader);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(describeError(context, e))));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _SheetFrame(
      title: l.bill_newLoader,
      saving: _saving,
      onSave: _save,
      children: [
        TextField(
          controller: _first,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: l.bill_firstName),
        ),
        TextField(
          controller: _last,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: l.bill_lastName),
        ),
        TextField(
          controller: _city,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: l.bill_city),
        ),
        TextField(
          controller: _phone,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: l.bill_phone,
            hintText: '380…',
          ),
        ),
      ],
    );
  }
}

class _PaymentSheet extends ConsumerStatefulWidget {
  const _PaymentSheet({required this.parcelId});

  final int parcelId;

  @override
  ConsumerState<_PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends ConsumerState<_PaymentSheet> with _Saving {
  final _amount = TextEditingController();
  final _note = TextEditingController();
  PaymentMethod _method = PaymentMethod.CASH;

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _SheetFrame(
      title: l.bill_payment,
      saving: saving,
      error: error,
      onSave: () {
        final amount = _parse(_amount.text);
        if (amount == null || amount <= 0) return;
        unawaited(
          save(
            widget.parcelId,
            (api) => api.addPayment(widget.parcelId, {
              'amount': amount,
              'method': _method.name,
              if (_note.text.trim().isNotEmpty) 'note': _note.text.trim(),
            }),
          ),
        );
      },
      children: [
        TextField(
          controller: _amount,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: l.bill_amount),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            for (final m in const [
              PaymentMethod.CASH,
              PaymentMethod.UA_CARD,
              PaymentMethod.FOREIGN_CARD,
            ])
              ChoiceChip(
                label: Text(paymentMethodLabel(l, m)),
                selected: _method == m,
                onSelected: (_) => setState(() => _method = m),
              ),
          ],
        ),
        TextField(
          controller: _note,
          decoration: InputDecoration(
            labelText: l.bill_note,
            hintText: l.bill_prepayment,
          ),
        ),
      ],
    );
  }
}

class _StorageSheet extends ConsumerStatefulWidget {
  const _StorageSheet({required this.parcelId});

  final int parcelId;

  @override
  ConsumerState<_StorageSheet> createState() => _StorageSheetState();
}

class _StorageSheetState extends ConsumerState<_StorageSheet> with _Saving {
  final _days = TextEditingController();
  final _rate = TextEditingController();
  final _notes = TextEditingController();
  Warehouse? _warehouse;

  @override
  void dispose() {
    for (final c in [_days, _rate, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final warehouses =
        ref.watch(activeWarehousesProvider).value ?? const <Warehouse>[];
    const decimal = TextInputType.numberWithOptions(decimal: true);
    return _SheetFrame(
      title: l.bill_storage,
      saving: saving,
      error: error,
      onSave: () {
        final days = _parse(_days.text);
        final rate = _parse(_rate.text);
        if (days == null || rate == null) return;
        unawaited(
          save(
            widget.parcelId,
            (api) => api.addStorage(widget.parcelId, {
              'warehouseId': ?_warehouse?.id,
              'days': days,
              'rate': rate,
              if (_notes.text.trim().isNotEmpty) 'notes': _notes.text.trim(),
            }),
          ),
        );
      },
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<Warehouse?>(
                key: ValueKey(_warehouse?.id),
                initialValue: _warehouse,
                decoration: InputDecoration(labelText: l.bill_warehouse),
                items: [
                  DropdownMenuItem(child: Text(l.bill_noWarehouse)),
                  for (final w in warehouses)
                    DropdownMenuItem(value: w, child: Text(w.name)),
                ],
                onChanged: (w) => setState(() => _warehouse = w),
              ),
            ),
            IconButton(
              tooltip: l.warehouse_new,
              icon: const Icon(Icons.add_business_outlined),
              onPressed: () async {
                final created = await createWarehouse(context, ref);
                if (created != null && mounted) {
                  setState(() => _warehouse = created);
                }
              },
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _days,
                keyboardType: decimal,
                decoration: InputDecoration(labelText: l.bill_days),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _rate,
                keyboardType: decimal,
                decoration: InputDecoration(labelText: l.bill_dayRate),
              ),
            ),
          ],
        ),
        TextField(
          controller: _notes,
          decoration: InputDecoration(labelText: l.bill_notes),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/trips/data/trip_api.dart';
import 'package:trackbox24_mob/features/trips/data/trip_model.dart';
import 'package:trackbox24_mob/features/warehouses/data/warehouse_api.dart';
import 'package:trackbox24_mob/features/warehouses/data/warehouse_model.dart';

Future<void> showDepartDialog(
  BuildContext context,
  WidgetRef ref,
  Trip trip,
) async {
  final changed = await showDialog<bool>(
    context: context,
    builder: (_) => _DepartDialog(trip: trip),
  );
  if (changed ?? false) invalidateTrip(ref, trip.id);
}

/// Starting to load needs nothing from the user, so it runs straight away; only a failure is worth a message.
Future<void> startLoadingTrip(
  BuildContext context,
  WidgetRef ref,
  Trip trip,
) async {
  try {
    await ref.read(tripApiProvider).startLoading(trip.id);
    invalidateTrip(ref, trip.id);
  } on ApiException catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(describeError(context, e))));
  }
}

Future<void> showCompleteDialog(
  BuildContext context,
  WidgetRef ref,
  Trip trip,
) async {
  final changed = await showDialog<bool>(
    context: context,
    builder: (_) => _CompleteDialog(trip: trip),
  );
  if (changed ?? false) invalidateTrip(ref, trip.id);
}

class _DepartDialog extends ConsumerStatefulWidget {
  const _DepartDialog({required this.trip});

  final Trip trip;

  @override
  ConsumerState<_DepartDialog> createState() => _DepartDialogState();
}

class _DepartDialogState extends ConsumerState<_DepartDialog> {
  final _odometer = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _odometer.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(tripApiProvider)
          .depart(
            widget.trip.id,
            startOdometerKm: int.tryParse(_odometer.text),
          );
      if (mounted) Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error =
              e.fieldErrors['startOdometerKm'] ?? describeError(context, e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l.trip_departTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l.trip_departDescription),
          const SizedBox(height: 12),
          TextField(
            controller: _odometer,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: l.trip_startOdometerKm,
              errorText: _error,
            ),
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(false),
          child: Text(l.common_cancel),
        ),
        FilledButton(
          onPressed: _busy ? null : _submit,
          child: Text(l.trip_depart),
        ),
      ],
    );
  }
}

/// Complete; on 409 the backend lists parcels still in the car — they are moved to a chosen warehouse, then retried.
class _CompleteDialog extends ConsumerStatefulWidget {
  const _CompleteDialog({required this.trip});

  final Trip trip;

  @override
  ConsumerState<_CompleteDialog> createState() => _CompleteDialogState();
}

class _CompleteDialogState extends ConsumerState<_CompleteDialog> {
  final _odometer = TextEditingController();
  late final _notes = TextEditingController(text: widget.trip.notes ?? '');
  bool _busy = false;
  String? _error;
  List<Parcel> _undelivered = const [];
  Warehouse? _warehouse;

  @override
  void dispose() {
    _odometer.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final start = widget.trip.startOdometerKm;
    final end = int.tryParse(_odometer.text);
    final l = AppLocalizations.of(context);
    if (end != null && start != null && end < start) {
      setState(() => _error = l.trip_endOdometerLess);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      if (_undelivered.isNotEmpty) {
        await ref
            .read(warehouseApiProvider)
            .moveParcels(
              _warehouse!.id,
              _undelivered.map((p) => p.id).toList(),
              comment: l.trip_completeTitle,
            );
      }
      await ref
          .read(tripApiProvider)
          .complete(
            widget.trip.id,
            endOdometerKm: end,
            notes: _notes.text.trim(),
          );
      if (mounted) Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      final left = e.extensions['undeliveredParcels'];
      if (e.isConflict && left is List) {
        setState(() {
          _busy = false;
          _undelivered = left
              .map((x) => Parcel.fromJson((x as Map).cast<String, dynamic>()))
              .toList();
        });
        return;
      }
      setState(() {
        _busy = false;
        _error = e.fieldErrors['endOdometerKm'] ?? describeError(context, e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final warehouses = ref.watch(activeWarehousesProvider);
    return AlertDialog(
      title: Text(l.trip_completeTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _odometer,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: l.trip_endOdometerKm,
                helperText: widget.trip.startOdometerKm == null
                    ? null
                    : '≥ ${widget.trip.startOdometerKm}',
                errorText: _error,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notes,
              decoration: InputDecoration(labelText: l.trip_notes),
              maxLines: 2,
            ),
            if (_undelivered.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                l.trip_undelivered,
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              for (final p in _undelivered)
                Text(
                  '${p.code}${p.clientName != null ? ' · ${p.clientName}' : ''}',
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                ),
              const SizedBox(height: 8),
              warehouses.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text(describeError(context, e)),
                data: (list) => DropdownButtonFormField<int>(
                  initialValue: _warehouse?.id,
                  decoration: InputDecoration(
                    labelText: l.scan_warehouse,
                    isDense: true,
                  ),
                  items: [
                    for (final w in list)
                      DropdownMenuItem(value: w.id, child: Text(w.name)),
                  ],
                  onChanged: (id) => setState(
                    () =>
                        _warehouse = list.where((w) => w.id == id).firstOrNull,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(false),
          child: Text(l.common_cancel),
        ),
        FilledButton(
          onPressed: _busy || (_undelivered.isNotEmpty && _warehouse == null)
              ? null
              : _submit,
          child: Text(
            _undelivered.isEmpty ? l.trip_complete : l.trip_moveAndComplete,
          ),
        ),
      ],
    );
  }
}

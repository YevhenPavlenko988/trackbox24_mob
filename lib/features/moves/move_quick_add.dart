import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/app/router.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_api.dart';
import 'package:trackbox24_mob/features/parcels/label/label_data.dart';
import 'package:trackbox24_mob/features/printer/state/printer_settings.dart';
import 'package:trackbox24_mob/features/printer/ui/print_sheet.dart';

/// Packing item by item: a printer must be set up first (one trip to its settings), then the sheet stays open —
/// each item is added and its label printed straight away, the field clears for the next one.
Future<void> startQuickAdd(
  BuildContext context,
  WidgetRef ref,
  int parcelId,
) async {
  final settings = await ref.read(printerSettingsProvider.future);
  if (!context.mounted) return;
  if (!settings.hasPrinter) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).label_printSetup)),
    );
    await context.push<void>(Routes.printer);
    return;
  }
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => QuickAddSheet(parcelId: parcelId),
  );
}

class QuickAddSheet extends ConsumerStatefulWidget {
  const QuickAddSheet({required this.parcelId, super.key});

  final int parcelId;

  @override
  ConsumerState<QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends ConsumerState<QuickAddSheet> {
  final _item = TextEditingController();
  final _focus = FocusNode();
  int _added = 0;
  int? _last;
  bool _busy = false;

  @override
  void dispose() {
    _item.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _addAndPrint() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final move = await ref.read(parcelApiProvider).addSeats(widget.parcelId, [
        _item.text.trim(),
      ]);
      ref.invalidate(parcelProvider(widget.parcelId));
      final number = move.seats.last.seatNumber;
      setState(() {
        _added++;
        _last = number;
        _item.clear();
      });
      if (!mounted) return;
      await showPrintSheet(context, [
        for (final label in labelsFor(move))
          if (label.seat == number) label,
      ]);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(describeError(context, e))));
    } finally {
      if (mounted) {
        setState(() => _busy = false);
        _focus.requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.move_quickAdd, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            _last == null
                ? l.move_quickAddHint
                : l.move_quickAdded(_added, _last!),
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _item,
            focusNode: _focus,
            autofocus: true,
            maxLength: 200,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _addAndPrint(),
            decoration: InputDecoration(
              labelText: l.move_quickAddItem,
              hintText: l.move_quickAddItemHint,
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _busy ? null : _addAndPrint,
            icon: _busy
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.print_outlined),
            label: Text(l.move_quickAddSubmit),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l.move_quickAddDone),
          ),
        ],
      ),
    );
  }
}

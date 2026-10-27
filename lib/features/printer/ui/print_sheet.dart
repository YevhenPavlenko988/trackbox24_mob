import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/features/parcels/label/label_data.dart';
import 'package:trackbox24_mob/features/printer/state/print_job.dart';
import 'package:trackbox24_mob/features/printer/ui/printer_errors.dart';

/// Runs a print of [labels] and shows how it goes; closes itself on success, offers a retry on failure.
Future<void> showPrintSheet(BuildContext context, List<ParcelLabel> labels) {
  return showModalBottomSheet<void>(
    context: context,
    isDismissible: false,
    enableDrag: false,
    builder: (_) => _PrintSheet(labels: labels),
  );
}

class _PrintSheet extends ConsumerStatefulWidget {
  const _PrintSheet({required this.labels});

  final List<ParcelLabel> labels;

  @override
  ConsumerState<_PrintSheet> createState() => _PrintSheetState();
}

class _PrintSheetState extends ConsumerState<_PrintSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  void _start() =>
      ref.read(printJobProvider.notifier).printLabels(widget.labels);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(printJobProvider);
    ref.listen(printJobProvider, (_, next) {
      if (next is PrintDone) {
        Future<void>.delayed(const Duration(milliseconds: 900), () {
          if (!context.mounted) return;
          Navigator.of(context).pop();
        });
      }
    });

    final (icon, title, subtitle, progress) = switch (state) {
      PrintIdle() || PrintConnecting() => (
        null,
        state is PrintConnecting
            ? l.printer_connecting(state.printerName)
            : l.common_loading,
        l.printer_scanHint,
        null,
      ),
      PrintPrinting(:final index, :final total, :final progress) => (
        null,
        l.printer_printing(index, total),
        null,
        ((index - 1) + progress) / total,
      ),
      PrintDone(:final count) => (
        Icon(Icons.check_circle, color: Colors.green.shade700, size: 40),
        l.printer_done,
        count > 1 ? l.printer_doneCount(count) : null,
        null,
      ),
      PrintFailed(:final error, :final printed, :final total) => (
        Icon(Icons.error_outline, color: theme.colorScheme.error, size: 40),
        describePrinterError(context, error),
        printed > 0 ? l.printer_failedAfter(printed, total) : null,
        null,
      ),
    };
    final busy =
        state is PrintIdle ||
        state is PrintConnecting ||
        state is PrintPrinting;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (icon != null)
              Center(child: icon)
            else
              Center(
                child: SizedBox.square(
                  dimension: 40,
                  child: CircularProgressIndicator(value: progress),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 20),
            if (state is PrintFailed)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l.common_cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _start,
                      child: Text(l.common_retry),
                    ),
                  ),
                ],
              )
            else if (busy)
              // Printing cannot be interrupted mid-page; the sheet just stays until the printer answers.
              const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

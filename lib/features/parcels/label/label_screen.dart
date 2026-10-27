import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trackbox24_mob/app/router.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/async_view.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_api.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/label/label_data.dart';
import 'package:trackbox24_mob/features/parcels/label/label_painter.dart';
import 'package:trackbox24_mob/features/printer/state/printer_settings.dart';
import 'package:trackbox24_mob/features/printer/ui/print_sheet.dart';

/// The 70×40 mm labels of a parcel, one per seat, drawn here and printed on the NIIMBOT over Bluetooth — or
/// handed to the NIIMBOT app as pictures when no printer is set up.
class LabelScreen extends ConsumerWidget {
  const LabelScreen({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final parcel = ref.watch(parcelProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text(l.label_title)),
      body: switch (parcel) {
        AsyncData(:final value) => _Labels(parcel: value),
        AsyncError(:final error) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(parcelProvider(id)),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Labels extends ConsumerStatefulWidget {
  const _Labels({required this.parcel});

  final Parcel parcel;

  @override
  ConsumerState<_Labels> createState() => _LabelsState();
}

class _LabelsState extends ConsumerState<_Labels> {
  bool _sharing = false;

  Future<void> _print(List<ParcelLabel> labels) async {
    final l = AppLocalizations.of(context);
    final settings = await ref.read(printerSettingsProvider.future);
    if (!mounted) return;
    if (!settings.hasPrinter) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.label_printSetup)));
      await context.push(Routes.printer);
      return;
    }
    await showPrintSheet(context, labels);
  }

  Future<void> _share(List<ParcelLabel> labels) async {
    setState(() => _sharing = true);
    final l = AppLocalizations.of(context);
    // The share sheet on an iPad anchors to the button that opened it.
    final box = context.findRenderObject() as RenderBox?;
    final origin = box == null
        ? null
        : box.localToGlobal(Offset.zero) & box.size;
    try {
      final dir = await getTemporaryDirectory();
      final files = <XFile>[];
      for (final label in labels) {
        final file = File('${dir.path}/${label.fileName}');
        await file.writeAsBytes(await renderLabelPng(label), flush: true);
        files.add(XFile(file.path, mimeType: 'image/png'));
      }
      await SharePlus.instance.share(
        ShareParams(
          files: files,
          text: widget.parcel.code,
          sharePositionOrigin: origin,
        ),
      );
    } on Exception {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.label_shareFailed)));
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final labels = labelsFor(widget.parcel);
    final hasWaybill = widget.parcel.npShipment?.hasWaybill ?? false;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        Text(l.label_hint, style: theme.textTheme.bodySmall),
        if (!hasWaybill) ...[
          const SizedBox(height: 8),
          Text(
            l.label_noWaybill,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.orange.shade900,
            ),
          ),
        ],
        const SizedBox(height: 16),
        for (final label in labels) ...[
          if (label.seat != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                l.label_seat(label.seat!, label.total),
                style: theme.textTheme.labelLarge,
              ),
            ),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: theme.dividerColor),
              borderRadius: BorderRadius.circular(4),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: AspectRatio(
                aspectRatio: labelWidthDots / labelHeightDots,
                child: CustomPaint(painter: LabelPainter(label)),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        FilledButton.icon(
          onPressed: labels.isEmpty ? null : () => _print(labels),
          icon: const Icon(Icons.print_outlined),
          label: Text(
            labels.length > 1 ? l.label_printAll(labels.length) : l.label_print,
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _sharing || labels.isEmpty ? null : () => _share(labels),
          icon: _sharing
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.ios_share),
          label: Text(
            labels.length > 1 ? l.label_shareAll(labels.length) : l.label_share,
          ),
        ),
      ],
    );
  }
}

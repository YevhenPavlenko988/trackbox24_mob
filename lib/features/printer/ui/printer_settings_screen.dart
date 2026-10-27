import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/async_view.dart';
import 'package:trackbox24_mob/features/parcels/label/label_data.dart';
import 'package:trackbox24_mob/features/printer/niimbot/ble_transport.dart';
import 'package:trackbox24_mob/features/printer/state/printer_settings.dart';
import 'package:trackbox24_mob/features/printer/ui/print_sheet.dart';
import 'package:trackbox24_mob/features/printer/ui/printer_errors.dart';

/// «Ще → Принтер етикеток»: which NIIMBOT the phone prints on, how dark, and a test label.
class PrinterSettingsScreen extends ConsumerWidget {
  const PrinterSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final settings = ref.watch(printerSettingsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.printer_title)),
      body: switch (settings) {
        AsyncData(:final value) => _Body(settings: value),
        AsyncError(:final error) => ErrorView(error: error),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.settings});

  final PrinterSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final notifier = ref.read(printerSettingsProvider.notifier);
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        ListTile(
          leading: const Icon(Icons.print_outlined),
          title: Text(
            settings.hasPrinter ? settings.name! : l.printer_subtitleNone,
          ),
          subtitle: settings.hasPrinter
              ? Text(settings.deviceId!, style: theme.textTheme.bodySmall)
              : null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FilledButton.icon(
            onPressed: () => _choose(context, ref),
            icon: const Icon(Icons.bluetooth_searching),
            label: Text(
              settings.hasPrinter ? l.printer_chooseOther : l.printer_choose,
            ),
          ),
        ),
        if (settings.hasPrinter) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: OutlinedButton.icon(
              onPressed: () => showPrintSheet(context, [_testLabel(l)]),
              icon: const Icon(Icons.receipt_long_outlined),
              label: Text(l.printer_testPrint),
            ),
          ),
          const Divider(height: 32),
          ListTile(
            title: Text(l.printer_density),
            subtitle: Text(l.printer_densityHint),
            trailing: Text(
              '${settings.density}',
              style: theme.textTheme.titleMedium,
            ),
          ),
          Slider(
            value: settings.density.toDouble(),
            min: PrinterSettings.minDensity.toDouble(),
            max: PrinterSettings.maxDensity.toDouble(),
            divisions: PrinterSettings.maxDensity - PrinterSettings.minDensity,
            label: '${settings.density}',
            onChanged: (v) => notifier.setDensity(v.round()),
          ),
          SwitchListTile(
            title: Text(l.printer_rotate),
            subtitle: Text(l.printer_rotateHint),
            value: settings.rotate,
            onChanged: notifier.setRotate,
          ),
          const Divider(height: 32),
          ListTile(
            leading: Icon(
              Icons.bluetooth_disabled,
              color: theme.colorScheme.error,
            ),
            title: Text(
              l.printer_forget,
              style: TextStyle(color: theme.colorScheme.error),
            ),
            onTap: notifier.forgetPrinter,
          ),
        ],
      ],
    );
  }

  Future<void> _choose(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final picked = await showModalBottomSheet<FoundPrinter>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _ScanSheet(),
    );
    if (picked == null || !context.mounted) return;
    await ref
        .read(printerSettingsProvider.notifier)
        .savePrinter(picked.deviceId, picked.name);
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.printer_saved)));
    }
  }

  /// A label with a real Code 128 so the client can check the printer reads back what it printed.
  ParcelLabel _testLabel(AppLocalizations l) => ParcelLabel(
    code: 'PT0000000000',
    total: 1,
    line: l.printer_testLine,
    weightKg: 1,
  );
}

/// Scans for a few seconds and lists what answers; a tap picks the printer.
class _ScanSheet extends StatefulWidget {
  const _ScanSheet();

  @override
  State<_ScanSheet> createState() => _ScanSheetState();
}

class _ScanSheetState extends State<_ScanSheet> {
  final _found = <FoundPrinter>[];
  StreamSubscription<FoundPrinter>? _sub;
  bool _scanning = false;
  bool _all = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _scan();
  }

  @override
  void dispose() {
    unawaited(_sub?.cancel());
    super.dispose();
  }

  void _scan() {
    unawaited(_sub?.cancel());
    setState(() {
      _found.clear();
      _scanning = true;
      _error = null;
    });
    _sub = NiimbotBleTransport.scan(all: _all).listen(
      (p) => setState(() {
        _found
          ..add(p)
          ..sort((a, b) => (b.rssi ?? -999).compareTo(a.rssi ?? -999));
      }),
      onError: (Object e) => setState(() {
        _error = e;
        _scanning = false;
      }),
      onDone: () {
        if (mounted) setState(() => _scanning = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _scanning ? l.printer_scanning : l.printer_choose,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                if (_scanning)
                  const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  IconButton(
                    onPressed: _scan,
                    tooltip: l.printer_rescan,
                    icon: const Icon(Icons.refresh),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(l.printer_scanHint, style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  describePrinterError(context, _error!),
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              )
            else if (_found.isEmpty && !_scanning)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(l.printer_noneFound, textAlign: TextAlign.center),
              ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final p in _found)
                    ListTile(
                      leading: const Icon(Icons.print_outlined),
                      title: Text(p.name),
                      subtitle: Text(
                        p.rssi == null
                            ? p.deviceId
                            : '${p.rssi} dBm · ${p.deviceId}',
                      ),
                      onTap: () => Navigator.of(context).pop(p),
                    ),
                ],
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.printer_showAll, style: theme.textTheme.bodyMedium),
              value: _all,
              onChanged: (v) {
                _all = v;
                _scan();
              },
            ),
          ],
        ),
      ),
    );
  }
}

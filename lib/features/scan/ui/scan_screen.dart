import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';
import 'package:trackbox24_mob/features/scan/state/scan_service.dart';
import 'package:trackbox24_mob/features/scan/ui/scan_result_card.dart';
import 'package:trackbox24_mob/features/scan/ui/scanner_view.dart';
import 'package:trackbox24_mob/features/trips/data/trip_model.dart';
import 'package:trackbox24_mob/features/warehouses/data/warehouse_api.dart';
import 'package:trackbox24_mob/features/warehouses/data/warehouse_model.dart';

/// Single scanning screen for every role: pick a mode, point the camera, see the result.
class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({this.initialMode, this.tripId, super.key});

  final ScanMode? initialMode;

  /// Preselected trip for [ScanMode.load] (set when opened from a trip).
  final int? tripId;

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  late ScanMode _mode = widget.initialMode ?? ScanMode.lookup;
  late int? _tripId = widget.tripId;
  Warehouse? _warehouse;
  bool _paymentReceived = false;
  bool _busy = false;
  ScanOutcome? _last;
  Timer? _autoHide;

  @override
  void dispose() {
    _autoHide?.cancel();
    super.dispose();
  }

  Future<void> _handle(String code, {bool manual = false}) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _autoHide?.cancel();
    });
    final outcome = await ref
        .read(scanServiceProvider)
        .perform(
          _mode,
          code,
          manual: manual,
          params: ScanParams(
            tripId: _tripId,
            warehouseId: _warehouse?.id,
            paymentReceived: _paymentReceived,
          ),
        );
    if (!mounted) return;
    await (outcome is ScanSuccess
        ? HapticFeedback.mediumImpact()
        : HapticFeedback.heavyImpact());
    setState(() {
      _busy = false;
      _last = outcome;
    });
    if (outcome is ScanSuccess) {
      _autoHide = Timer(const Duration(seconds: 4), () {
        if (mounted) setState(() => _last = null);
      });
    }
  }

  Future<void> _manualInput() async {
    final code = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _ManualInputSheet(numeric: _mode == ScanMode.receive),
    );
    if (code != null && code.isNotEmpty) await _handle(code, manual: true);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final user = switch (ref.watch(authProvider)) {
      Authenticated(:final user) => user,
      _ => null,
    };
    final modes = modesFor(user);
    if (!modes.contains(_mode)) _mode = modes.first;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.scan_title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Row(
              children: [
                for (final m in modes)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_modeLabel(l, m)),
                      selected: _mode == m,
                      onSelected: (_) => setState(() {
                        _mode = m;
                        _last = null;
                      }),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _busy ? null : _manualInput,
        icon: const Icon(Icons.keyboard),
        label: Text(l.scan_manual),
      ),
      // A bottom sheet keeps the FAB above the result instead of overlapping it.
      bottomSheet: _last == null
          ? null
          : ScanResultCard(
              outcome: _last!,
              mode: _mode,
              onDismiss: () => setState(() => _last = null),
            ),
      body: Column(
        children: [
          _ModeOptions(
            mode: _mode,
            tripId: _tripId,
            warehouse: _warehouse,
            paymentReceived: _paymentReceived,
            onWarehouse: (w) => setState(() => _warehouse = w),
            onPaymentReceived: (v) => setState(() => _paymentReceived = v),
            onPickTrip: () async {
              final trip = await context.push<Trip>('/trips/pick');
              if (trip != null) setState(() => _tripId = trip.id);
            },
          ),
          Expanded(
            child: Stack(
              children: [
                ScannerView(onCode: _handle, enabled: !_busy),
                if (_busy) const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _modeLabel(AppLocalizations l, ScanMode m) => switch (m) {
    ScanMode.lookup => l.scan_mode_lookup,
    ScanMode.receive => l.scan_mode_receive,
    ScanMode.load => l.scan_mode_load,
    ScanMode.deliver => l.scan_mode_deliver,
    ScanMode.toWarehouse => l.scan_mode_toWarehouse,
  };
}

/// Per-mode inputs above the camera: trip (load), warehouse (toWarehouse), payment toggle (deliver).
class _ModeOptions extends ConsumerWidget {
  const _ModeOptions({
    required this.mode,
    required this.tripId,
    required this.warehouse,
    required this.paymentReceived,
    required this.onWarehouse,
    required this.onPaymentReceived,
    required this.onPickTrip,
  });

  final ScanMode mode;
  final int? tripId;
  final Warehouse? warehouse;
  final bool paymentReceived;
  final ValueChanged<Warehouse?> onWarehouse;
  final ValueChanged<bool> onPaymentReceived;
  final VoidCallback onPickTrip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    switch (mode) {
      case ScanMode.lookup:
      case ScanMode.receive:
        return const SizedBox.shrink();
      case ScanMode.load:
        return ListTile(
          dense: true,
          leading: const Icon(Icons.local_shipping_outlined),
          title: Text(
            tripId == null
                ? l.scan_tripNotSelected
                : l.scan_tripSelected(tripId!),
          ),
          subtitle: Text(tripId == null ? l.scan_tripHint : l.scan_tripChange),
          trailing: const Icon(Icons.chevron_right),
          onTap: onPickTrip,
        );
      case ScanMode.deliver:
        return SwitchListTile(
          dense: true,
          secondary: const Icon(Icons.payments_outlined),
          title: Text(l.scan_paymentReceived),
          value: paymentReceived,
          onChanged: onPaymentReceived,
        );
      case ScanMode.toWarehouse:
        final warehouses = ref.watch(activeWarehousesProvider);
        return warehouses.when(
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => ListTile(
            dense: true,
            leading: const Icon(Icons.error_outline),
            title: Text(describeError(context, e)),
          ),
          data: (list) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: DropdownButtonFormField<int>(
              initialValue: warehouse?.id,
              decoration: InputDecoration(
                labelText: l.scan_warehouse,
                isDense: true,
              ),
              items: [
                for (final w in list)
                  DropdownMenuItem(value: w.id, child: Text(w.name)),
              ],
              onChanged: (id) =>
                  onWarehouse(list.where((w) => w.id == id).firstOrNull),
            ),
          ),
        );
    }
  }
}

class _ManualInputSheet extends StatefulWidget {
  const _ManualInputSheet({required this.numeric});

  final bool numeric;

  @override
  State<_ManualInputSheet> createState() => _ManualInputSheetState();
}

class _ManualInputSheetState extends State<_ManualInputSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.of(context).pop(_controller.text);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: widget.numeric
                ? TextInputType.number
                : TextInputType.visiblePassword,
            textCapitalization: TextCapitalization.characters,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: widget.numeric ? l.scan_enterTtn : l.scan_enterCode,
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 12),
          FilledButton(onPressed: _submit, child: Text(l.common_ok)),
        ],
      ),
    );
  }
}

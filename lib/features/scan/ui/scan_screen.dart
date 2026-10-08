import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/util/scan_code.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';
import 'package:trackbox24_mob/features/scan/queue/scan_queue_worker.dart';
import 'package:trackbox24_mob/features/scan/state/scan_actions.dart';
import 'package:trackbox24_mob/features/scan/state/scan_service.dart';
import 'package:trackbox24_mob/features/scan/ui/scan_action_sheet.dart';
import 'package:trackbox24_mob/features/scan/ui/scan_result_card.dart';
import 'package:trackbox24_mob/features/scan/ui/scanner_view.dart';
import 'package:trackbox24_mob/features/trips/data/trip_model.dart';
import 'package:trackbox24_mob/features/warehouses/data/warehouse_model.dart';

/// Scan first, then choose.
///
/// Every scan is a lookup, so pointing the camera can never change a parcel by itself. What the parcel's status
/// and the user's role allow is then offered as buttons; the chosen action is what actually gets sent.
class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({this.tripId, super.key});

  /// Preselected trip when opened from a trip, so loading does not ask for it.
  final int? tripId;

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  late int? _tripId = widget.tripId;
  Warehouse? _warehouse;
  bool _busy = false;

  /// The action sheet is open. The camera keeps running behind it, so without this every barcode in front of the
  /// lens would push another sheet onto the stack and bury the first one.
  bool _choosing = false;

  /// A code the user dismissed, ignored for a moment so the label still under the lens does not reopen the sheet.
  String? _dismissed;
  DateTime? _dismissedAt;
  static const _dismissCooldown = Duration(seconds: 5);

  ScanOutcome? _last;
  ScanMode? _lastMode;
  Timer? _autoHide;

  @override
  void dispose() {
    _autoHide?.cancel();
    super.dispose();
  }

  Future<void> _handle(String code, {bool manual = false}) async {
    if (_busy || _choosing) return;
    if (!manual &&
        code == _dismissed &&
        _dismissedAt != null &&
        DateTime.now().difference(_dismissedAt!) < _dismissCooldown) {
      return;
    }
    setState(() {
      _busy = true;
      _autoHide?.cancel();
      _last = null;
    });

    final service = ref.read(scanServiceProvider);
    final found = await service.perform(ScanMode.lookup, code, manual: manual);
    if (!mounted) return;

    final user = switch (ref.read(authProvider)) {
      Authenticated(:final user) => user,
      _ => null,
    };
    final parcel = found is ScanSuccess ? found.parcel : null;
    final error = found is ScanFailure ? found.error : null;
    final actions = switch (found) {
      ScanSuccess(:final parcel) => actionsFor(parcel, user),
      // Offline the status is unknown, so the actions come from the code itself and go to the queue.
      ScanFailure(:final error) when error.isTransport => actionsForCode(
        code,
        user,
      ),
      // A waybill the backend has never seen is created by the receive scan, so that one action still applies.
      ScanFailure(:final error) when error.isNotFound && ttnOf(code) != null =>
        actionsForCode(code, user),
      _ => const <ScanAction>[],
    };

    await HapticFeedback.selectionClick();
    if (!mounted) return;
    // The spinner goes, but the scanner stays off until the sheet is answered.
    setState(() {
      _busy = false;
      _choosing = true;
    });

    final chosen = await showModalBottomSheet<ChosenScanAction>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ScanActionSheet(
        code: code,
        actions: actions,
        parcel: parcel,
        lookupError: error,
        tripId: _tripId,
        warehouse: _warehouse,
        onPickTrip: _pickTrip,
      ),
    );
    if (!mounted) return;
    setState(() {
      _choosing = false;
      _dismissed = chosen == null ? code : null;
      _dismissedAt = chosen == null ? DateTime.now() : null;
    });
    if (chosen == null) return;

    // Remember the trip and warehouse so a run of parcels is scanned without re-picking.
    setState(() {
      _busy = true;
      if (chosen.tripId != null) _tripId = chosen.tripId;
      if (chosen.warehouse != null) _warehouse = chosen.warehouse;
    });
    final outcome = await service.perform(
      chosen.mode,
      code,
      manual: manual,
      params: ScanParams(
        tripId: chosen.tripId,
        warehouseId: chosen.warehouseId,
        paymentReceived: chosen.paymentReceived,
      ),
    );
    if (!mounted) return;
    await (outcome is ScanSuccess
        ? HapticFeedback.mediumImpact()
        : HapticFeedback.heavyImpact());
    setState(() {
      _busy = false;
      _last = outcome;
      _lastMode = chosen.mode;
    });
    if (outcome is ScanSuccess) {
      unawaited(ref.read(scanQueueWorkerProvider).run());
    }
    if (outcome is ScanSuccess || outcome is ScanQueued) {
      _autoHide = Timer(const Duration(seconds: 4), () {
        if (mounted) setState(() => _last = null);
      });
    }
  }

  Future<int?> _pickTrip() async {
    final trip = await context.push<Trip>('/trips/pick');
    return trip?.id;
  }

  Future<void> _manualInput() async {
    // Typing a code is also a sheet, and a label in front of the lens must not interrupt it.
    setState(() => _choosing = true);
    final code = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _ManualInputSheet(),
    );
    if (!mounted) return;
    setState(() => _choosing = false);
    if (code != null && code.isNotEmpty) await _handle(code, manual: true);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.scan_title)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _busy ? null : _manualInput,
        icon: const Icon(Icons.keyboard),
        label: Text(l.scan_manual),
      ),
      floatingActionButtonLocation: const _AboveBottomSheet(),
      bottomSheet: _last == null
          ? null
          : ScanResultCard(
              outcome: _last!,
              mode: _lastMode ?? ScanMode.lookup,
              onDismiss: () => setState(() => _last = null),
            ),
      body: Stack(
        children: [
          ScannerView(onCode: _handle, enabled: !_busy && !_choosing),
          Positioned(
            left: 16,
            right: 16,
            top: 16,
            child: Text(
              l.scan_hint,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          if (_busy) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

/// Keeps the button clear of the result card. Scaffold's own locations ignore a persistent bottom sheet, so the
/// button would sit on top of the card and bury the message.
class _AboveBottomSheet extends StandardFabLocation
    with FabEndOffsetX, FabFloatOffsetY {
  const _AboveBottomSheet();

  @override
  double getOffsetY(
    ScaffoldPrelayoutGeometry scaffoldGeometry,
    double adjustment,
  ) =>
      super.getOffsetY(scaffoldGeometry, adjustment) -
      scaffoldGeometry.bottomSheetSize.height;
}

class _ManualInputSheet extends StatefulWidget {
  const _ManualInputSheet();

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
            keyboardType: TextInputType.visiblePassword,
            textCapitalization: TextCapitalization.characters,
            autocorrect: false,
            decoration: InputDecoration(labelText: l.scan_enterCode),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 12),
          FilledButton(onPressed: _submit, child: Text(l.common_ok)),
        ],
      ),
    );
  }
}
